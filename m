Return-Path: <linux-kernel-owner+w=401wt.eu-S934287AbZJMU2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287AbZJMU2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZJMU2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:28:13 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:47966 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751495AbZJMU2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:28:12 -0400
Date: Tue, 13 Oct 2009 16:20:13 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: this_cpu_xx's patchset effect on SLUB cycle counts 
Message-ID: <alpine.DEB.1.10.0910131603380.7246@gentwo.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The recent this_cpu_xx patchsets have allowed an increase in the
effectiveness of the allocation fastpath in SLUB by avoiding lookups and
interrupt disable. The approaches likely can be also applied to other allocators.

Measurements were done using the in kernel page allocator benchmarks that
were also posted today. I hope that these numbers can lead to an
evaluation of how useful the this_cpu_xx operations are and how to most
effectively apply them in the kernel.

The following kernels were run:

A. Upstream with Tejun's for-next tree (this include this_cpu_xx base
functionality but not the enhancements to the page allocator and rework of
slubs fastpath)

B. Kernel A with the page allocator and slub enhancements (including the
one titled "aggressive use of this_cpu_xx").

C. Kernel B with the slub irqless patch on top.

Note that B and C are improving only the fastpath of the SLUB allocator.
They do not affect slowpath nor page allocator fallback. Well not entirely
true: C especially adds code to the slowpath. Question is if that offsets
the gains in the fastpath


The following tests were run:

1. Single threaded testing

Single thread is running performing allocation and frees. The first test
does a large number of allocs and then a large number of frees. The second
test performs a single alloc followed by a single free a large number of
times. The same object is reused in the second test which allow use of
the fastpath for alloc and free. The first test
requires periodic fallback to the slowpath on alloc and almost constant
fallback to the slowpath on free.

2. Concurrent allocations

Allocations are performed concurrently on all cpus. The first test
performns a large number of allocs followed by a large number of frees and
the second (like under 1) follows each alloc with a free.

The remote free tests frees all objects on different processors than where
they were allocated.

For details on the test: Please look at todays posting of the source code
for the testing modules.

Results for kernel A
--------------------

Linux version 2.6.32-rc4-00027-gceb8d11 (gcc version 4.3.4 (Debian 4.3.4-5) ) #7 SMP Tue Oct 13 13:55:52 CDT 2009
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=2
Single thread testing
=====================
1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 239 cycles kfree -> 261 cycles
10000 times kmalloc(16) -> 249 cycles kfree -> 208 cycles
10000 times kmalloc(32) -> 215 cycles kfree -> 232 cycles
10000 times kmalloc(64) -> 164 cycles kfree -> 216 cycles
10000 times kmalloc(128) -> 266 cycles kfree -> 275 cycles
10000 times kmalloc(256) -> 478 cycles kfree -> 199 cycles
10000 times kmalloc(512) -> 449 cycles kfree -> 201 cycles
10000 times kmalloc(1024) -> 484 cycles kfree -> 398 cycles
10000 times kmalloc(2048) -> 475 cycles kfree -> 559 cycles
10000 times kmalloc(4096) -> 792 cycles kfree -> 506 cycles
10000 times kmalloc(8192) -> 753 cycles kfree -> 679 cycles
10000 times kmalloc(16384) -> 968 cycles kfree -> 712 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 292 cycles
10000 times kmalloc(16)/kfree -> 308 cycles
10000 times kmalloc(32)/kfree -> 326 cycles
10000 times kmalloc(64)/kfree -> 303 cycles
10000 times kmalloc(128)/kfree -> 257 cycles
10000 times kmalloc(256)/kfree -> 262 cycles
10000 times kmalloc(512)/kfree -> 293 cycles
10000 times kmalloc(1024)/kfree -> 262 cycles
10000 times kmalloc(2048)/kfree -> 289 cycles
10000 times kmalloc(4096)/kfree -> 274 cycles
10000 times kmalloc(8192)/kfree -> 265 cycles
10000 times kmalloc(16384)/kfree -> 1041 cycles
Concurrent allocs
=================
Kmalloc N*alloc N*free(8): 0=172/168 1=173/176 2=173/169 3=170/165 4=167/166 5=172/168 6=173/167 7=170/172 8=172/166 9=171/171 10=171/171 11=169/166 12=169/167 13=172/168 14=171/169 15=171/166 Average=171/168
Kmalloc N*alloc N*free(16): 0=185/175 1=181/176 2=187/174 3=183/171 4=186/177 5=183/171 6=187/174 7=181/173 8=184/175 9=181/174 10=184/173 11=181/175 12=185/178 13=182/175 14=184/173 15=180/170 Average=183/174
Kmalloc N*alloc N*free(32): 0=201/185 1=205/189 2=200/183 3=202/178 4=198/180 5=202/177 6=201/183 7=201/181 8=201/185 9=200/185 10=199/182 11=200/177 12=199/183 13=204/177 14=199/184 15=203/178 Average=201/182
Kmalloc N*alloc N*free(64): 0=239/216 1=234/196 2=243/214 3=244/197 4=241/216 5=241/204 6=240/213 7=235/198 8=241/217 9=237/192 10=240/213 11=243/198 12=243/219 13=242/205 14=243/215 15=236/195 Average=240/207
Kmalloc N*alloc N*free(128): 0=405/342 1=346/303 2=402/346 3=346/303 4=403/353 5=344/306 6=401/340 7=346/314 8=403/348 9=344/306 10=398/342 11=344/309 12=407/337 13=347/312 14=402/349 15=344/302 Average=374/326
Kmalloc N*alloc N*free(256): 0=607/594 1=444/455 2=490/588 3=440/461 4=494/577 5=447/454 6=497/585 7=444/446 8=599/587 9=444/454 10=491/585 11=444/454 12=490/584 13=443/446 14=494/586 15=445/457 Average=482/520
Kmalloc N*alloc N*free(512): 0=419/683 1=419/428 2=419/561 3=420/435 4=422/566 5=433/448 6=423/566 7=432/445 8=424/670 9=430/448 10=426/565 11=428/451 12=429/574 13=438/472 14=430/576 15=440/468 Average=427/522
Kmalloc N*alloc N*free(1024): 0=399/377 1=381/373 2=399/373 3=383/374 4=399/377 5=381/378 6=399/377 7=382/372 8=397/376 9=382/376 10=398/375 11=384/374 12=400/375 13=379/375 14=400/374 15=384/374 Average=390/375
Kmalloc N*alloc N*free(2048): 0=713/446 1=514/444 2=600/446 3=512/445 4=599/449 5=512/440 6=605/446 7=510/441 8=704/446 9=511/441 10=601/443 11=512/442 12=598/449 13=512/441 14=605/445 15=511/440 Average=570/444
Kmalloc N*alloc N*free(4096): 0=972/1487 1=810/753 2=942/1308 3=808/758 4=944/1306 5=806/762 6=940/1309 7=807/753 8=968/1469 9=811/756 10=939/1305 11=807/757 12=943/1305 13=807/758 14=942/1307 15=812/758 Average=879/1053
Kmalloc N*(alloc free)(8): 0=252 1=251 2=254 3=252 4=251 5=251 6=252 7=252 8=252 9=251 10=254 11=252 12=251 13=251 14=252 15=252 Average=252
Kmalloc N*(alloc free)(16): 0=251 1=251 2=250 3=251 4=252 5=251 6=252 7=249 8=250 9=251 10=250 11=251 12=252 13=252 14=252 15=250 Average=251
Kmalloc N*(alloc free)(32): 0=252 1=254 2=250 3=255 4=251 5=254 6=250 7=251 8=251 9=251 10=250 11=254 12=251 13=253 14=250 15=254 Average=252
Kmalloc N*(alloc free)(64): 0=252 1=261 2=253 3=263 4=253 5=264 6=253 7=263 8=253 9=261 10=254 11=262 12=252 13=263 14=252 15=262 Average=258
Kmalloc N*(alloc free)(128): 0=252 1=261 2=250 3=250 4=253 5=265 6=252 7=263 8=252 9=261 10=250 11=250 12=253 13=264 14=251 15=263 Average=256
Kmalloc N*(alloc free)(256): 0=251 1=249 2=251 3=251 4=248 5=249 6=248 7=249 8=250 9=248 10=248 11=263 12=248 13=249 14=247 15=250 Average=250
Kmalloc N*(alloc free)(512): 0=250 1=251 2=245 3=250 4=250 5=252 6=250 7=250 8=249 9=250 10=245 11=250 12=250 13=253 14=250 15=251 Average=250
Kmalloc N*(alloc free)(1024): 0=254 1=250 2=250 3=247 4=251 5=248 6=252 7=248 8=253 9=251 10=250 11=247 12=250 13=249 14=250 15=248 Average=250
Kmalloc N*(alloc free)(2048): 0=250 1=256 2=250 3=254 4=272 5=253 6=253 7=251 8=249 9=254 10=250 11=267 12=272 13=252 14=254 15=254 Average=256
Kmalloc N*(alloc free)(4096): 0=248 1=250 2=250 3=250 4=248 5=250 6=250 7=263 8=247 9=249 10=250 11=248 12=248 13=250 14=250 15=259 Average=251
Remote free test
================
N*remote free(8): 0=5/3647 1=174/0 2=172/0 3=171/0 4=177/0 5=176/0 6=175/0 7=176/0 8=112/0 9=175/0 10=175/0 11=175/0 12=176/0 13=175/0 14=176/0 15=175/0 Average=160/228
N*remote free(16): 0=5/2805 1=188/0 2=188/0 3=187/0 4=189/0 5=187/0 6=189/0 7=186/0 8=121/0 9=186/0 10=188/0 11=186/0 12=187/0 13=187/0 14=187/0 15=187/0 Average=172/175
N*remote free(32): 0=4/3106 1=203/0 2=206/0 3=203/0 4=201/0 5=203/0 6=200/0 7=204/0 8=140/0 9=203/0 10=205/0 11=205/0 12=205/0 13=206/0 14=204/0 15=206/0 Average=187/194
N*remote free(64): 0=4/3595 1=262/0 2=264/0 3=259/0 4=263/0 5=259/0 6=260/0 7=258/0 8=190/0 9=255/0 10=261/0 11=259/0 12=259/0 13=254/0 14=255/0 15=257/0 Average=239/224
N*remote free(128): 0=4/5423 1=368/0 2=390/0 3=361/0 4=400/0 5=376/0 6=390/0 7=362/0 8=315/0 9=369/0 10=394/0 11=364/0 12=399/0 13=373/0 14=394/0 15=364/0 Average=351/339
N*remote free(256): 0=3/9422 1=435/0 2=459/0 3=426/0 4=453/0 5=431/0 6=455/0 7=429/0 8=374/0 9=434/0 10=459/0 11=425/0 12=459/0 13=436/0 14=458/0 15=434/0 Average=411/588
N*remote free(512): 0=4/8615 1=427/0 2=418/0 3=431/0 4=425/0 5=438/0 6=424/0 7=438/0 8=382/0 9=432/0 10=428/0 11=434/0 12=429/0 13=442/0 14=427/0 15=444/0 Average=401/538
N*remote free(1024): 0=4/9794 1=411/0 2=399/0 3=409/0 4=401/0 5=404/0 6=398/0 7=411/0 8=351/0 9=410/0 10=400/0 11=409/0 12=401/0 13=407/0 14=402/0 15=409/0 Average=377/612
N*remote free(2048): 0=4/10466 1=532/0 2=606/0 3=532/0 4=606/0 5=536/0 6=602/0 7=536/0 8=532/0 9=533/0 10=605/0 11=532/0 12=604/0 13=534/0 14=602/0 15=535/0 Average=527/654
N*remote free(4096): 0=4/12602 1=839/0 2=931/0 3=832/0 4=926/0 5=834/0 6=932/0 7=834/0 8=827/0 9=841/0 10=933/0 11=835/0 12=929/0 13=834/0 14=937/0 15=839/0 Average=819/787
1 alloc N free test
===================
1 alloc N free(8): 0=3596 1=940 2=942 3=955 4=934 5=966 6=934 7=969 8=953 9=964 10=934 11=947 12=937 13=966 14=941 15=969 Average=1115
1 alloc N free(16): 0=4365 1=1078 2=1065 3=1068 4=1061 5=1068 6=1059 7=1064 8=1082 9=1082 10=1067 11=1073 12=1064 13=1067 14=1058 15=1063 Average=1274
1 alloc N free(32): 0=4193 1=1001 2=1004 3=1010 4=1005 5=1006 6=1007 7=1010 8=1009 9=1002 10=1001 11=1006 12=1008 13=1001 14=1006 15=1010 Average=1205
1 alloc N free(64): 0=4961 1=1209 2=1209 3=1208 4=1205 5=1209 6=1206 7=1207 8=1208 9=1206 10=1207 11=1206 12=1205 13=1206 14=1207 15=1208 Average=1442
1 alloc N free(128): 0=7100 1=1413 2=1413 3=1412 4=1416 5=1414 6=1412 7=1412 8=1413 9=1413 10=1412 11=1414 12=1412 13=1414 14=1413 15=1412 Average=1768
1 alloc N free(256): 0=9157 1=1321 2=1318 3=1318 4=1319 5=1321 6=1320 7=1319 8=1321 9=1320 10=1319 11=1317 12=1319 13=1320 14=1320 15=1319 Average=1809
1 alloc N free(512): 0=9415 1=826 2=824 3=823 4=824 5=823 6=824 7=829 8=828 9=826 10=827 11=826 12=826 13=825 14=825 15=824 Average=1362
1 alloc N free(1024): 0=8331 1=847 2=849 3=847 4=848 5=847 6=848 7=847 8=847 9=848 10=848 11=846 12=847 13=847 14=846 15=846 Average=1315
1 alloc N free(2048): 0=9732 1=858 2=858 3=859 4=858 5=859 6=858 7=858 8=857 9=858 10=858 11=857 12=858 13=858 14=857 15=857 Average=1413
1 alloc N free(4096): 0=12370 1=944 2=944 3=944 4=944 5=944 6=944 7=941 8=943 9=943 10=944 11=942 12=943 13=943 14=943 15=944 Average=1658

Results for kernel B (this_cpu_xx optimized fastpath):
------------------------------------------------------

Linux version 2.6.32-rc4-00027-gceb8d11-dirty (gcc version 4.3.4 (Debian 4.3.4-5) ) #6 SMP Tue Oct 13 13:44:47 CDT 2009
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=2
Single thread testing
=====================
1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 134 cycles kfree -> 212 cycles
10000 times kmalloc(16) -> 109 cycles kfree -> 116 cycles
10000 times kmalloc(32) -> 157 cycles kfree -> 231 cycles
10000 times kmalloc(64) -> 168 cycles kfree -> 169 cycles
10000 times kmalloc(128) -> 263 cycles kfree -> 260 cycles
10000 times kmalloc(256) -> 430 cycles kfree -> 251 cycles
10000 times kmalloc(512) -> 415 cycles kfree -> 258 cycles
10000 times kmalloc(1024) -> 406 cycles kfree -> 432 cycles
10000 times kmalloc(2048) -> 457 cycles kfree -> 579 cycles
10000 times kmalloc(4096) -> 624 cycles kfree -> 553 cycles
10000 times kmalloc(8192) -> 851 cycles kfree -> 851 cycles
10000 times kmalloc(16384) -> 907 cycles kfree -> 722 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 232 cycles
10000 times kmalloc(16)/kfree -> 150 cycles
10000 times kmalloc(32)/kfree -> 278 cycles
10000 times kmalloc(64)/kfree -> 263 cycles
10000 times kmalloc(128)/kfree -> 280 cycles
10000 times kmalloc(256)/kfree -> 279 cycles
10000 times kmalloc(512)/kfree -> 299 cycles
10000 times kmalloc(1024)/kfree -> 289 cycles
10000 times kmalloc(2048)/kfree -> 288 cycles
10000 times kmalloc(4096)/kfree -> 321 cycles
10000 times kmalloc(8192)/kfree -> 285 cycles
10000 times kmalloc(16384)/kfree -> 1002 cycles
Concurrent allocs
=================
Kmalloc N*alloc N*free(8): 0=174/191 1=172/180 2=173/191 3=176/179 4=172/190 5=172/182 6=172/190 7=173/182 8=172/191 9=173/191 10=172/191 11=173/191 12=175/190 13=173/183 14=173/191 15=175/183 Average=173/187
Kmalloc N*alloc N*free(16): 0=181/190 1=184/194 2=183/189 3=186/189 4=185/189 5=185/190 6=184/190 7=187/188 8=179/189 9=184/190 10=182/189 11=182/192 12=184/190 13=181/188 14=183/189 15=184/190 Average=183/190
Kmalloc N*alloc N*free(32): 0=195/345 1=179/242 2=201/270 3=181/239 4=201/270 5=183/241 6=199/270 7=182/240 8=196/283 9=185/237 10=198/270 11=180/238 12=201/271 13=181/240 14=200/272 15=181/239 Average=190/260
Kmalloc N*alloc N*free(64): 0=217/450 1=216/362 2=219/453 3=213/355 4=220/449 5=210/361 6=224/448 7=213/359 8=222/452 9=216/358 10=220/454 11=211/357 12=220/450 13=213/362 14=225/451 15=216/360 Average=217/405
Kmalloc N*alloc N*free(128): 0=421/688 1=348/440 2=423/593 3=356/421 4=419/587 5=355/438 6=418/590 7=345/431 8=418/675 9=353/424 10=421/587 11=355/440 12=419/589 13=356/446 14=421/577 15=356/437 Average=386/523
Kmalloc N*alloc N*free(256): 0=478/880 1=464/675 2=476/847 3=471/673 4=473/845 5=463/679 6=473/841 7=466/676 8=479/871 9=467/669 10=476/848 11=473/674 12=473/845 13=465/664 14=471/847 15=465/666 Average=471/763
Kmalloc N*alloc N*free(512): 0=448/628 1=454/550 2=450/574 3=455/541 4=446/576 5=452/557 6=447/575 7=454/547 8=445/591 9=453/555 10=446/577 11=457/542 12=446/573 13=454/550 14=447/572 15=455/553 Average=450/566
Kmalloc N*alloc N*free(1024): 0=569/707 1=501/624 2=542/694 3=501/624 4=533/695 5=489/624 6=544/695 7=502/617 8=550/705 9=501/624 10=543/693 11=500/617 12=534/695 13=489/619 14=544/693 15=502/619 Average=521/659
Kmalloc N*alloc N*free(2048): 0=466/1246 1=474/856 2=465/1151 3=473/866 4=465/1169 5=474/860 6=466/1170 7=475/838 8=466/1240 9=474/852 10=466/1153 11=475/855 12=467/1154 13=475/851 14=467/1151 15=475/844 Average=470/1016
Kmalloc N*alloc N*free(4096): 0=841/794 1=790/778 2=839/796 3=789/781 4=838/795 5=790/777 6=843/798 7=787/777 8=841/795 9=789/781 10=839/798 11=792/777 12=838/800 13=791/776 14=840/801 15=788/781 Average=815/788
Kmalloc N*(alloc free)(8): 0=245 1=244 2=242 3=261 4=247 5=247 6=243 7=246 8=244 9=243 10=242 11=261 12=247 13=248 14=244 15=245 Average=247
Kmalloc N*(alloc free)(16): 0=248 1=247 2=248 3=243 4=247 5=247 6=242 7=256 8=247 9=246 10=247 11=242 12=247 13=247 14=242 15=257 Average=247
Kmalloc N*(alloc free)(32): 0=243 1=260 2=254 3=243 4=243 5=242 6=247 7=264 8=242 9=259 10=253 11=243 12=243 13=242 14=247 15=265 Average=250
Kmalloc N*(alloc free)(64): 0=244 1=248 2=251 3=244 4=248 5=249 6=247 7=247 8=243 9=247 10=251 11=244 12=248 13=249 14=247 15=248 Average=247
Kmalloc N*(alloc free)(128): 0=253 1=259 2=257 3=261 4=252 5=257 6=253 7=256 8=252 9=256 10=256 11=259 12=252 13=257 14=252 15=256 Average=255
Kmalloc N*(alloc free)(256): 0=241 1=241 2=244 3=241 4=250 5=250 6=244 7=246 8=239 9=240 10=241 11=240 12=250 13=250 14=243 15=247 Average=244
Kmalloc N*(alloc free)(512): 0=247 1=245 2=241 3=255 4=245 5=256 6=242 7=253 8=296 9=244 10=240 11=255 12=245 13=256 14=242 15=250 Average=251
Kmalloc N*(alloc free)(1024): 0=259 1=255 2=247 3=254 4=245 5=244 6=248 7=248 8=256 9=254 10=247 11=254 12=245 13=245 14=249 15=249 Average=250
Kmalloc N*(alloc free)(2048): 0=248 1=248 2=243 3=243 4=251 5=259 6=251 7=248 8=248 9=249 10=244 11=244 12=250 13=246 14=250 15=247 Average=248
Kmalloc N*(alloc free)(4096): 0=243 1=243 2=259 3=244 4=243 5=244 6=244 7=244 8=242 9=243 10=246 11=245 12=243 13=245 14=244 15=244 Average=245
Remote free test
================
N*remote free(8): 0=5/3085 1=174/0 2=173/0 3=173/0 4=173/0 5=173/0 6=173/0 7=174/0 8=105/0 9=174/0 10=173/0 11=174/0 12=174/0 13=174/0 14=174/0 15=175/0 Average=159/192
N*remote free(16): 0=5/3341 1=185/0 2=184/0 3=185/0 4=185/0 5=186/0 6=183/0 7=185/0 8=114/0 9=185/0 10=184/0 11=185/0 12=186/0 13=188/0 14=185/0 15=187/0 Average=170/208
N*remote free(32): 0=4/2829 1=187/0 2=207/0 3=182/0 4=201/0 5=186/0 6=207/0 7=184/0 8=127/0 9=188/0 10=205/0 11=186/0 12=204/0 13=189/0 14=209/0 15=188/0 Average=178/176
N*remote free(64): 0=4/3535 1=233/0 2=238/0 3=226/0 4=239/0 5=230/0 6=233/0 7=232/0 8=174/0 9=228/0 10=237/0 11=223/0 12=239/0 13=228/0 14=233/0 15=230/0 Average=214/221
N*remote free(128): 0=3/4747 1=366/0 2=419/0 3=372/0 4=414/0 5=372/0 6=417/0 7=378/0 8=336/0 9=373/0 10=411/0 11=377/0 12=415/0 13=379/0 14=423/0 15=381/0 Average=365/296
N*remote free(256): 0=4/9083 1=456/0 2=443/0 3=461/0 4=441/0 5=460/0 6=446/0 7=456/0 8=392/0 9=453/0 10=446/0 11=458/0 12=441/0 13=460/0 14=446/0 15=455/0 Average=420/567
N*remote free(512): 0=4/9468 1=445/0 2=427/0 3=446/0 4=436/0 5=447/0 6=430/0 7=444/0 8=384/0 9=445/0 10=430/0 11=446/0 12=439/0 13=445/0 14=430/0 15=443/0 Average=409/591
N*remote free(1024): 0=3/10387 1=498/0 2=533/0 3=506/0 4=531/0 5=509/0 6=540/0 7=511/0 8=476/0 9=497/0 10=532/0 11=508/0 12=531/0 13=508/0 14=541/0 15=510/0 Average=483/649
N*remote free(2048): 0=4/10294 1=489/0 2=468/0 3=487/0 4=470/0 5=490/0 6=466/0 7=487/0 8=405/0 9=486/0 10=467/0 11=487/0 12=468/0 13=488/0 14=467/0 15=489/0 Average=445/643
N*remote free(4096): 0=4/12687 1=821/0 2=835/0 3=823/0 4=834/0 5=820/0 6=833/0 7=819/0 8=750/0 9=822/0 10=835/0 11=819/0 12=833/0 13=818/0 14=829/0 15=819/0 Average=770/793
1 alloc N free test
===================
1 alloc N free(8): 0=3949 1=1060 2=1046 3=1068 4=1049 5=1047 6=1049 7=1037 8=1070 9=1046 10=1044 11=1066 12=1048 13=1048 14=1051 15=1055 Average=1233
1 alloc N free(16): 0=3703 1=1153 2=1155 3=1154 4=1154 5=1150 6=1155 7=1150 8=1159 9=1154 10=1154 11=1154 12=1153 13=1149 14=1154 15=1150 Average=1313
1 alloc N free(32): 0=4098 1=997 2=999 3=1004 4=1001 5=996 6=993 7=1003 8=1003 9=1000 10=997 11=1003 12=1003 13=996 14=993 15=1001 Average=1193
1 alloc N free(64): 0=4567 1=1018 2=1020 3=1021 4=1020 5=1019 6=1016 7=1011 8=1022 9=1022 10=1019 11=1021 12=1019 13=1021 14=1020 15=1010 Average=1240
1 alloc N free(128): 0=6814 1=1345 2=1346 3=1343 4=1342 5=1345 6=1343 7=1345 8=1345 9=1344 10=1345 11=1343 12=1342 13=1344 14=1344 15=1344 Average=1686
1 alloc N free(256): 0=9469 1=946 2=945 3=945 4=944 5=944 6=945 7=941 8=943 9=943 10=942 11=945 12=943 13=945 14=941 15=944 Average=1477
1 alloc N free(512): 0=8600 1=1278 2=1280 3=1277 4=1278 5=1279 6=1277 7=1277 8=1279 9=1277 10=1279 11=1281 12=1280 13=1280 14=1279 15=1280 Average=1736
1 alloc N free(1024): 0=9485 1=844 2=844 3=842 4=841 5=841 6=841 7=842 8=841 9=842 10=843 11=843 12=842 13=842 14=842 15=843 Average=1382
1 alloc N free(2048): 0=10836 1=868 2=867 3=868 4=868 5=867 6=867 7=867 8=868 9=867 10=867 11=867 12=867 13=867 14=867 15=867 Average=1490
1 alloc N free(4096): 0=12653 1=930 2=929 3=929 4=928 5=927 6=928 7=927 8=928 9=929 10=928 11=930 12=928 13=930 14=928 15=929 Average=1661

Results for kernel C (Irqless fastpath):
---------------------------------------

Linux version 2.6.32-rc4-00027-gceb8d11-dirty (gcc version 4.3.4 (Debian 4.3.4-5) ) #8 SMP Tue Oct 13 14:14:05 CDT 2009
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=2
Single thread testing
=====================
1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 55 cycles kfree -> 251 cycles
10000 times kmalloc(16) -> 201 cycles kfree -> 261 cycles
10000 times kmalloc(32) -> 220 cycles kfree -> 261 cycles
10000 times kmalloc(64) -> 186 cycles kfree -> 224 cycles
10000 times kmalloc(128) -> 205 cycles kfree -> 125 cycles
10000 times kmalloc(256) -> 351 cycles kfree -> 267 cycles
10000 times kmalloc(512) -> 330 cycles kfree -> 310 cycles
10000 times kmalloc(1024) -> 416 cycles kfree -> 419 cycles
10000 times kmalloc(2048) -> 537 cycles kfree -> 439 cycles
10000 times kmalloc(4096) -> 458 cycles kfree -> 594 cycles
10000 times kmalloc(8192) -> 810 cycles kfree -> 678 cycles
10000 times kmalloc(16384) -> 879 cycles kfree -> 746 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 66 cycles
10000 times kmalloc(16)/kfree -> 187 cycles
10000 times kmalloc(32)/kfree -> 116 cycles
10000 times kmalloc(64)/kfree -> 107 cycles
10000 times kmalloc(128)/kfree -> 115 cycles
10000 times kmalloc(256)/kfree -> 65 cycles
10000 times kmalloc(512)/kfree -> 66 cycles
10000 times kmalloc(1024)/kfree -> 206 cycles
10000 times kmalloc(2048)/kfree -> 65 cycles
10000 times kmalloc(4096)/kfree -> 193 cycles
10000 times kmalloc(8192)/kfree -> 65 cycles
10000 times kmalloc(16384)/kfree -> 976 cycles
Concurrent allocs
=================
Kmalloc N*alloc N*free(8): 0=112/188 1=113/195 2=113/188 3=115/186 4=112/188 5=112/183 6=112/188 7=112/181 8=114/190 9=115/183 10=113/187 11=113/185 12=113/189 13=113/186 14=112/186 15=114/181 Average=113/187
Kmalloc N*alloc N*free(16): 0=124/196 1=125/205 2=123/196 3=127/199 4=124/195 5=124/198 6=123/196 7=125/207 8=124/194 9=124/208 10=123/198 11=126/199 12=125/196 13=125/199 14=125/198 15=126/202 Average=125/199
Kmalloc N*alloc N*free(32): 0=153/271 1=124/247 2=145/269 3=130/264 4=146/270 5=127/244 6=144/275 7=131/251 8=143/270 9=123/249 10=142/270 11=127/264 12=145/270 13=129/247 14=143/275 15=130/249 Average=136/262
Kmalloc N*alloc N*free(64): 0=172/615 1=169/370 2=181/493 3=170/388 4=179/494 5=169/417 6=177/495 7=169/391 8=176/504 9=167/369 10=178/494 11=168/381 12=178/493 13=168/431 14=178/494 15=170/394 Average=173/451
Kmalloc N*alloc N*free(128): 0=378/683 1=324/481 2=377/654 3=324/448 4=378/651 5=320/494 6=375/647 7=328/522 8=381/683 9=326/490 10=380/645 11=322/461 12=377/650 13=321/464 14=377/642 15=318/509 Average=350/570
Kmalloc N*alloc N*free(256): 0=441/906 1=424/670 2=436/837 3=428/658 4=435/839 5=425/669 6=439/839 7=427/671 8=435/893 9=425/669 10=434/832 11=425/663 12=434/835 13=422/661 14=437/824 15=424/652 Average=431/757
Kmalloc N*alloc N*free(512): 0=402/662 1=392/578 2=401/614 3=402/574 4=401/618 5=394/578 6=402/618 7=395/576 8=403/652 9=394/574 10=404/616 11=400/569 12=400/616 13=395/570 14=400/616 15=397/582 Average=399/601
Kmalloc N*alloc N*free(1024): 0=585/690 1=428/604 2=488/691 3=423/601 4=481/696 5=428/602 6=488/696 7=428/605 8=571/689 9=426/606 10=487/693 11=425/601 12=481/695 13=428/595 14=485/693 15=428/603 Average=467/647
Kmalloc N*alloc N*free(2048): 0=424/1273 1=437/834 2=422/1122 3=434/831 4=420/1122 5=439/837 6=421/1119 7=437/830 8=423/1259 9=436/822 10=424/1118 11=437/827 12=421/1120 13=436/841 14=423/1115 15=439/830 Average=430/994
Kmalloc N*alloc N*free(4096): 0=870/806 1=763/789 2=854/805 3=760/782 4=857/803 5=767/788 6=854/807 7=760/788 8=867/803 9=763/785 10=853/805 11=757/785 12=858/806 13=763/783 14=857/802 15=766/782 Average=811/795
Kmalloc N*(alloc free)(8): 0=139 1=138 2=138 3=140 4=139 5=139 6=138 7=140 8=139 9=138 10=137 11=140 12=140 13=140 14=138 15=141 Average=139
Kmalloc N*(alloc free)(16): 0=141 1=140 2=139 3=139 4=131 5=139 6=131 7=138 8=139 9=139 10=139 11=139 12=131 13=139 14=131 15=138 Average=137
Kmalloc N*(alloc free)(32): 0=132 1=140 2=131 3=139 4=139 5=138 6=138 7=140 8=132 9=140 10=132 11=140 12=139 13=139 14=139 15=140 Average=137
Kmalloc N*(alloc free)(64): 0=141 1=142 2=131 3=142 4=140 5=141 6=138 7=142 8=139 9=141 10=131 11=141 12=140 13=141 14=138 15=141 Average=139
Kmalloc N*(alloc free)(128): 0=140 1=139 2=132 3=138 4=139 5=139 6=138 7=139 8=140 9=139 10=132 11=139 12=139 13=140 14=138 15=140 Average=138
Kmalloc N*(alloc free)(256): 0=140 1=138 2=137 3=136 4=138 5=137 6=137 7=137 8=137 9=137 10=137 11=137 12=138 13=137 14=137 15=137 Average=137
Kmalloc N*(alloc free)(512): 0=137 1=136 2=138 3=138 4=137 5=135 6=136 7=136 8=137 9=135 10=137 11=137 12=137 13=146 14=137 15=137 Average=137
Kmalloc N*(alloc free)(1024): 0=138 1=138 2=139 3=138 4=135 5=137 6=137 7=137 8=137 9=137 10=138 11=137 12=146 13=137 14=137 15=137 Average=138
Kmalloc N*(alloc free)(2048): 0=136 1=136 2=135 3=137 4=136 5=137 6=136 7=137 8=137 9=136 10=144 11=138 12=145 13=138 14=136 15=138 Average=138
Kmalloc N*(alloc free)(4096): 0=136 1=136 2=137 3=137 4=137 5=137 6=138 7=136 8=147 9=135 10=137 11=137 12=137 13=137 14=138 15=137 Average=137
Remote free test
================
N*remote free(8): 0=5/3335 1=115/0 2=117/0 3=117/0 4=117/0 5=117/0 6=115/0 7=117/0 8=60/0 9=115/0 10=116/0 11=118/0 12=116/0 13=117/0 14=116/0 15=118/0 Average=106/208
N*remote free(16): 0=5/3944 1=126/0 2=123/0 3=127/0 4=125/0 5=127/0 6=126/0 7=127/0 8=68/0 9=125/0 10=124/0 11=126/0 12=126/0 13=128/0 14=127/0 15=127/0 Average=115/246
N*remote free(32): 0=4/3129 1=132/0 2=152/0 3=129/0 4=153/0 5=128/0 6=151/0 7=132/0 8=88/0 9=133/0 10=154/0 11=130/0 12=155/0 13=131/0 14=154/0 15=137/0 Average=129/195
N*remote free(64): 0=4/3313 1=197/0 2=204/0 3=196/0 4=194/0 5=200/0 6=196/0 7=189/0 8=143/0 9=194/0 10=201/0 11=186/0 12=198/0 13=190/0 14=192/0 15=189/0 Average=180/207
N*remote free(128): 0=3/4289 1=343/0 2=377/0 3=342/0 4=381/0 5=344/0 6=385/0 7=340/0 8=314/0 9=345/0 10=378/0 11=342/0 12=378/0 13=343/0 14=375/0 15=346/0 Average=334/268
N*remote free(256): 0=4/9425 1=423/0 2=408/0 3=419/0 4=407/0 5=419/0 6=405/0 7=420/0 8=352/0 9=423/0 10=409/0 11=422/0 12=409/0 13=418/0 14=405/0 15=419/0 Average=385/589
N*remote free(512): 0=4/9517 1=386/0 2=383/0 3=390/0 4=386/0 5=391/0 6=383/0 7=387/0 8=345/0 9=389/0 10=381/0 11=391/0 12=386/0 13=388/0 14=384/0 15=390/0 Average=360/594
N*remote free(1024): 0=3/10053 1=451/0 2=490/0 3=446/0 4=490/0 5=450/0 6=492/0 7=452/0 8=448/0 9=452/0 10=492/0 11=447/0 12=491/0 13=454/0 14=490/0 15=453/0 Average=438/628
N*remote free(2048): 0=4/11238 1=454/0 2=415/0 3=454/0 4=415/0 5=455/0 6=416/0 7=457/0 8=375/0 9=454/0 10=416/0 11=454/0 12=414/0 13=455/0 14=415/0 15=458/0 Average=407/702
N*remote free(4096): 0=3/10262 1=807/0 2=845/0 3=803/0 4=832/0 5=806/0 6=838/0 7=810/0 8=760/0 9=800/0 10=840/0 11=805/0 12=836/0 13=802/0 14=837/0 15=806/0 Average=764/641
1 alloc N free test
===================
1 alloc N free(8): 0=2119 1=606 2=611 3=593 4=603 5=580 6=592 7=587 8=617 9=607 10=607 11=588 12=608 13=578 14=570 15=603 Average=692
1 alloc N free(16): 0=3315 1=1177 2=1178 3=1175 4=1176 5=1177 6=1179 7=1177 8=1184 9=1178 10=1178 11=1175 12=1178 13=1177 14=1177 15=1175 Average=1311
1 alloc N free(32): 0=3005 1=952 2=946 3=954 4=948 5=952 6=954 7=944 8=956 9=955 10=945 11=955 12=947 13=946 14=954 15=947 Average=1079
1 alloc N free(64): 0=3534 1=1013 2=1013 3=1011 4=1013 5=1009 6=1009 7=1010 8=1014 9=1013 10=1012 11=1010 12=1012 13=1009 14=1008 15=1008 Average=1169
1 alloc N free(128): 0=6786 1=1406 2=1404 3=1408 4=1405 5=1404 6=1405 7=1404 8=1406 9=1404 10=1406 11=1407 12=1404 13=1407 14=1403 15=1405 Average=1742
1 alloc N free(256): 0=7496 1=1266 2=1269 3=1266 4=1269 5=1268 6=1266 7=1267 8=1266 9=1267 10=1268 11=1266 12=1269 13=1268 14=1267 15=1267 Average=1657
1 alloc N free(512): 0=6893 1=847 2=846 3=848 4=846 5=848 6=847 7=848 8=847 9=847 10=847 11=848 12=846 13=847 14=846 15=846 Average=1225
1 alloc N free(1024): 0=9241 1=839 2=841 3=839 4=838 5=838 6=838 7=835 8=837 9=837 10=838 11=839 12=837 13=839 14=837 15=838 Average=1363
1 alloc N free(2048): 0=8790 1=854 2=854 3=853 4=854 5=855 6=853 7=854 8=854 9=854 10=853 11=853 12=854 13=853 14=852 15=853 Average=1350
1 alloc N free(4096): 0=9548 1=922 2=924 3=924 4=924 5=924 6=923 7=921 8=923 9=923 10=925 11=922 12=924 13=922 14=923 15=924 Average=1462
