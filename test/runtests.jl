using Juxta
using Test

ja = JuxtArray(randn(5,10), ["x","y"],
                     Dict("x"=>collect(1:5),"y"=>collect(1:10)))
ja1 = JuxtArray(randn(5,10), ["x","y"],
                     Dict("x"=>collect(1:5),"y"=>collect(1:10) .* 2))
ja2 = JuxtArray(randn(5,10), ["x","y"],
                     Dict("x"=>collect(1:5),"y"=>collect(1:10) .* 2))
ja3 = JuxtArray(randn(5,10), ["x","y"],
                     Dict("x"=>collect(1:5),"y"=>collect(1:10) .* 2))
ja4 = JuxtArray(randn(5,10,1), ["x","y","za"],
                     Dict("x"=>collect(1:5),"y"=>collect(1:10) .* 2,"za"=>[2]))
ja5 = JuxtArray(randn(5,10,1), ["x","y","za"],
                     Dict("x"=>collect(1:5),"y"=>collect(1:10) .* 2,"za"=>[2]))
@testset "juxta.jl" begin
    @test typeof(ja) == JuxtArray
    @test ja.indices["x"] == 1:5
    @test ja.indices["y"] == 1:10
    @test ja1.indices["x"] == 1:5
    @test ja1.indices["y"] == 1:10
    @test isel!(ja, x=2:4).indices["x"] == 1:3
    @test isel!(ja, y=2).indices["y"] == 1:1
    @test ja.coords["y"][1] == 2
    @test size(ja.array,1) == 3
    @test isel!(ja1, x=2:4, y=3:2:8).indices["x"] == 1:3
    @test ja1.indices["y"] == 1:3
    @test ja1.coords["y"] == [3,5,7] .* 2
    @test ja1.coords["x"] == collect(2:4)
    @test sel!(ja2, x=1.1:0.2:4.1).indices["x"] == 1:3
    @test ja2.coords["x"] == collect(2:4)
    @test sel!(ja3, "nearest", x=1.1:0.2:4.1).indices["x"] == 1:4
    @test ja3.coords["x"] == collect(1:4)
    @test sel!(ja3, "nearest", x=0.8).indices["x"] == 1:1
    @test ja3.coords["x"] == Number[1]
    @test sel!(ja3, y=10.3).indices["y"] == 1:2
    @test ja3.coords["y"] == Number[10,12]
    @test size(ja3) == (1,2)
    @test size(ja3, "x") == 1
    @test size(ja3, "y") == 2
    @test size(dropdims(ja3, ["x"])) == (2,)
    @test ja3.dims == ["y"]
    @test (ja4
           |> j->isel!(j,x=2)
           |> j->dropdims(j,["x","za"])
           |> j->size(j)) == (10,)
    @test ja4.dims == ["y"]
    @test typeof(show(ja4)) == Nothing
    @test ja5(x=1.1:0.2:4.1).indices["x"] == 1:3
end
