Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbZJNDOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbZJNDOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 23:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbZJNDOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 23:14:11 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20501 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbZJNDOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 23:14:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=WZ2gGMyUzWYYuqaQXbb+8c7wLJFXQgmRFCM8k7hamlfDBmdLCfPxw0tsMIW8W109L
	qftbAr/AcRi6ya3ha3H3A==
Date: Tue, 13 Oct 2009 20:12:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: this_cpu_xx's patchset effect on SLUB cycle counts
In-Reply-To: <alpine.DEB.1.10.0910131603380.7246@gentwo.org>
Message-ID: <alpine.DEB.1.00.0910131958040.26072@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0910131603380.7246@gentwo.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Christoph Lameter wrote:

> 
> The recent this_cpu_xx patchsets have allowed an increase in the
> effectiveness of the allocation fastpath in SLUB by avoiding lookups and
> interrupt disable. The approaches likely can be also applied to other allocators.
> 
> Measurements were done using the in kernel page allocator benchmarks that
> were also posted today. I hope that these numbers can lead to an
> evaluation of how useful the this_cpu_xx operations are and how to most
> effectively apply them in the kernel.
> 
> The following kernels were run:
> 
> A. Upstream with Tejun's for-next tree (this include this_cpu_xx base
> functionality but not the enhancements to the page allocator and rework of
> slubs fastpath)
> 
> B. Kernel A with the page allocator and slub enhancements (including the
> one titled "aggressive use of this_cpu_xx").
> 
> C. Kernel B with the slub irqless patch on top.
> 
> Note that B and C are improving only the fastpath of the SLUB allocator.
> They do not affect slowpath nor page allocator fallback. Well not entirely
> true: C especially adds code to the slowpath. Question is if that offsets
> the gains in the fastpath
> 

I benchmarked this patchset both with and without the irqless patch from 
http://marc.info/?l=linux-kernel&m=125503037213262 on several of my 
machines.  The results were good for the most part, but I found a very 
reproducible regression on my 4-core 8G Xeon 5500 with HyperThreading for 
objects of smaller size (8, 16, and 64 bytes) without the irqless patch:

This is your baseline "Kernel A" (percpu#for-next at dec54bf "this_cpu: 
Use this_cpu_xx in trace_functions_graph.c"):

Single thread testing
=====================
1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 241 cycles kfree -> 283 cycles
10000 times kmalloc(16) -> 236 cycles kfree -> 291 cycles
10000 times kmalloc(32) -> 259 cycles kfree -> 300 cycles
10000 times kmalloc(64) -> 350 cycles kfree -> 331 cycles
10000 times kmalloc(128) -> 468 cycles kfree -> 373 cycles
10000 times kmalloc(256) -> 594 cycles kfree -> 525 cycles
10000 times kmalloc(512) -> 647 cycles kfree -> 560 cycles
10000 times kmalloc(1024) -> 707 cycles kfree -> 576 cycles
10000 times kmalloc(2048) -> 688 cycles kfree -> 594 cycles
10000 times kmalloc(4096) -> 860 cycles kfree -> 749 cycles
10000 times kmalloc(8192) -> 1219 cycles kfree -> 1054 cycles
10000 times kmalloc(16384) -> 1440 cycles kfree -> 1403 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 376 cycles
10000 times kmalloc(16)/kfree -> 370 cycles
10000 times kmalloc(32)/kfree -> 366 cycles
10000 times kmalloc(64)/kfree -> 368 cycles
10000 times kmalloc(128)/kfree -> 371 cycles
10000 times kmalloc(256)/kfree -> 380 cycles
10000 times kmalloc(512)/kfree -> 416 cycles
10000 times kmalloc(1024)/kfree -> 383 cycles
10000 times kmalloc(2048)/kfree -> 377 cycles
10000 times kmalloc(4096)/kfree -> 379 cycles
10000 times kmalloc(8192)/kfree -> 381 cycles
10000 times kmalloc(16384)/kfree -> 1697 cycles
Concurrent allocs
=================
Kmalloc N*alloc N*free(8): 0=459/460 1=458/465 2=3239/395 3=3237/431 Average=1848/438
Kmalloc N*alloc N*free(16): 0=820/506 1=821/516 2=1769/510 3=1769/512 Average=1295/511
Kmalloc N*alloc N*free(32): 0=545/520 1=548/534 2=850/527 3=848/535 Average=698/529
Kmalloc N*alloc N*free(64): 0=1105/753 1=1095/761 2=1020/773 3=1018/748 Average=1059/759
Kmalloc N*alloc N*free(128): 0=1217/1313 1=1224/1304 2=1171/1294 3=1171/1285 Average=1196/1299
Kmalloc N*alloc N*free(256): 0=1683/1976 1=1682/2008 2=1717/2001 3=1695/1974 Average=1694/1990
Kmalloc N*alloc N*free(512): 0=1813/2225 1=1826/2227 2=1822/2308 3=1823/2310 Average=1821/2267
Kmalloc N*alloc N*free(1024): 0=1767/2727 1=1767/2707 2=1871/2617 3=1871/2644 Average=1819/2674
Kmalloc N*alloc N*free(2048): 0=2416/2954 1=2416/2959 2=2376/2748 3=2382/2765 Average=2398/2857
Kmalloc N*alloc N*free(4096): 0=3263/3955 1=3274/3958 2=3280/3636 3=3269/3627 Average=3272/3794
Kmalloc N*(alloc free)(8): 0=576 1=574 2=582 3=582 Average=579
Kmalloc N*(alloc free)(16): 0=439 1=439 2=582 3=582 Average=511
Kmalloc N*(alloc free)(32): 0=597 1=596 2=593 3=593 Average=595
Kmalloc N*(alloc free)(64): 0=574 1=576 2=583 3=583 Average=579
Kmalloc N*(alloc free)(128): 0=595 1=595 2=597 3=597 Average=596
Kmalloc N*(alloc free)(256): 0=580 1=579 2=582 3=582 Average=581
Kmalloc N*(alloc free)(512): 0=586 1=588 2=576 3=576 Average=581
Kmalloc N*(alloc free)(1024): 0=625 1=625 2=614 3=614 Average=620
Kmalloc N*(alloc free)(2048): 0=570 1=571 2=584 3=582 Average=577
Kmalloc N*(alloc free)(4096): 0=585 1=584 2=577 3=577 Average=581

And this is your "Kernel B" (with v6 of your patchset plus the two fixes 
to dma_kmalloc_cache() and kmem_cache_open()):

Single thread testing
=====================
1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 323 cycles kfree -> 371 cycles
10000 times kmalloc(16) -> 289 cycles kfree -> 288 cycles
10000 times kmalloc(32) -> 254 cycles kfree -> 397 cycles
10000 times kmalloc(64) -> 398 cycles kfree -> 349 cycles
10000 times kmalloc(128) -> 420 cycles kfree -> 344 cycles
10000 times kmalloc(256) -> 588 cycles kfree -> 521 cycles
10000 times kmalloc(512) -> 646 cycles kfree -> 558 cycles
10000 times kmalloc(1024) -> 668 cycles kfree -> 581 cycles
10000 times kmalloc(2048) -> 690 cycles kfree -> 614 cycles
10000 times kmalloc(4096) -> 861 cycles kfree -> 738 cycles
10000 times kmalloc(8192) -> 1214 cycles kfree -> 1057 cycles
10000 times kmalloc(16384) -> 1503 cycles kfree -> 1380 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 371 cycles
10000 times kmalloc(16)/kfree -> 368 cycles
10000 times kmalloc(32)/kfree -> 366 cycles
10000 times kmalloc(64)/kfree -> 384 cycles
10000 times kmalloc(128)/kfree -> 364 cycles
10000 times kmalloc(256)/kfree -> 370 cycles
10000 times kmalloc(512)/kfree -> 372 cycles
10000 times kmalloc(1024)/kfree -> 377 cycles
10000 times kmalloc(2048)/kfree -> 375 cycles
10000 times kmalloc(4096)/kfree -> 377 cycles
10000 times kmalloc(8192)/kfree -> 379 cycles
10000 times kmalloc(16384)/kfree -> 1592 cycles
Concurrent allocs
=================
Kmalloc N*alloc N*free(8): 0=800/526 1=799/522 2=1252/511 3=1251/511 Average=1025/517
Kmalloc N*alloc N*free(16): 0=1055/498 1=1059/499 2=1822/517 3=1738/515 Average=1419/507
Kmalloc N*alloc N*free(32): 0=1207/563 1=1211/561 2=1402/543 3=1398/541 Average=1305/552
Kmalloc N*alloc N*free(64): 0=1275/757 1=1275/898 2=1515/904 3=1508/886 Average=1393/861
Kmalloc N*alloc N*free(128): 0=1295/1488 1=1294/1519 2=1272/1505 3=1244/1525 Average=1276/1509
Kmalloc N*alloc N*free(256): 0=1621/2524 1=1629/2547 2=1645/2540 3=1651/2518 Average=1637/2532
Kmalloc N*alloc N*free(512): 0=1883/2889 1=1892/2864 2=1898/2807 3=1898/2751 Average=1893/2828
Kmalloc N*alloc N*free(1024): 0=2393/3323 1=2400/3326 2=2402/3221 3=2311/3294 Average=2376/3291
Kmalloc N*alloc N*free(2048): 0=2642/3602 1=2653/3582 2=2635/3295 3=2629/3281 Average=2640/3440
Kmalloc N*alloc N*free(4096): 0=3383/4061 1=3383/4060 2=3312/3823 3=3306/3817 Average=3346/3940
Kmalloc N*(alloc free)(8): 0=674 1=666 2=648 3=647 Average=659
Kmalloc N*(alloc free)(16): 0=603 1=604 2=549 3=549 Average=576
Kmalloc N*(alloc free)(32): 0=565 1=566 2=550 3=550 Average=558
Kmalloc N*(alloc free)(64): 0=444 1=444 2=558 3=556 Average=501
Kmalloc N*(alloc free)(128): 0=448 1=449 2=556 3=556 Average=502
Kmalloc N*(alloc free)(256): 0=458 1=458 2=557 3=558 Average=508
Kmalloc N*(alloc free)(512): 0=460 1=461 2=591 3=591 Average=525
Kmalloc N*(alloc free)(1024): 0=461 1=460 2=590 3=636 Average=537
Kmalloc N*(alloc free)(2048): 0=629 1=629 2=671 3=671 Average=650
Kmalloc N*(alloc free)(4096): 0=574 1=574 2=642 3=642 Average=608

But "Kernel C" (with the irqless patch) shows a major improvement in the 
single threaded tests:

Single thread testing
=====================
1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 115 cycles kfree -> 285 cycles
10000 times kmalloc(16) -> 103 cycles kfree -> 283 cycles
10000 times kmalloc(32) -> 127 cycles kfree -> 301 cycles
10000 times kmalloc(64) -> 170 cycles kfree -> 330 cycles
10000 times kmalloc(128) -> 318 cycles kfree -> 389 cycles
10000 times kmalloc(256) -> 474 cycles kfree -> 532 cycles
10000 times kmalloc(512) -> 525 cycles kfree -> 627 cycles
10000 times kmalloc(1024) -> 568 cycles kfree -> 576 cycles
10000 times kmalloc(2048) -> 579 cycles kfree -> 593 cycles
10000 times kmalloc(4096) -> 772 cycles kfree -> 722 cycles
10000 times kmalloc(8192) -> 1148 cycles kfree -> 1019 cycles
10000 times kmalloc(16384) -> 1476 cycles kfree -> 1393 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 132 cycles
10000 times kmalloc(16)/kfree -> 125 cycles
10000 times kmalloc(32)/kfree -> 128 cycles
10000 times kmalloc(64)/kfree -> 125 cycles
10000 times kmalloc(128)/kfree -> 129 cycles
10000 times kmalloc(256)/kfree -> 136 cycles
10000 times kmalloc(512)/kfree -> 140 cycles
10000 times kmalloc(1024)/kfree -> 136 cycles
10000 times kmalloc(2048)/kfree -> 151 cycles
10000 times kmalloc(4096)/kfree -> 136 cycles
10000 times kmalloc(8192)/kfree -> 151 cycles
10000 times kmalloc(16384)/kfree -> 1584 cycles
Concurrent allocs
=================
Kmalloc N*alloc N*free(8): 0=3083/439 1=3081/444 2=3619/455 3=3614/459 Average=3349/449
Kmalloc N*alloc N*free(16): 0=382/504 1=382/501 2=1899/446 3=1896/445 Average=1140/474
Kmalloc N*alloc N*free(32): 0=270/479 1=204/477 2=1012/483 3=1007/488 Average=623/482
Kmalloc N*alloc N*free(64): 0=1287/922 1=1286/913 2=547/911 3=505/903 Average=906/912
Kmalloc N*alloc N*free(128): 0=1221/1496 1=1211/1485 2=1240/1509 3=1232/1508 Average=1226/1499
Kmalloc N*alloc N*free(256): 0=1644/2561 1=1645/2536 2=1802/2560 3=1808/2550 Average=1725/2552
Kmalloc N*alloc N*free(512): 0=1993/2796 1=1999/2806 2=1971/2768 3=1964/2753 Average=1982/2781
Kmalloc N*alloc N*free(1024): 0=1931/3203 1=1929/3216 2=1935/3124 3=1933/3095 Average=1932/3159
Kmalloc N*alloc N*free(2048): 0=2465/3497 1=2461/3485 2=2459/3268 3=2464/3512 Average=2462/3441
Kmalloc N*alloc N*free(4096): 0=3340/3775 1=3336/3771 2=3318/3819 3=3312/4003 Average=3326/3842
Kmalloc N*(alloc free)(8): 0=4199 1=4198 2=4271 3=4270 Average=4234
Kmalloc N*(alloc free)(16): 0=224 1=225 2=565 3=566 Average=395
Kmalloc N*(alloc free)(32): 0=605 1=604 2=584 3=584 Average=594
Kmalloc N*(alloc free)(64): 0=566 1=564 2=573 3=574 Average=569
Kmalloc N*(alloc free)(128): 0=571 1=571 2=571 3=570 Average=571
Kmalloc N*(alloc free)(256): 0=687 1=686 2=747 3=746 Average=716
Kmalloc N*(alloc free)(512): 0=5089 1=5086 2=3832 3=3836 Average=4461
Kmalloc N*(alloc free)(1024): 0=4970 1=4971 2=5082 3=5086 Average=5027
Kmalloc N*(alloc free)(2048): 0=4932 1=4930 2=4237 3=4257 Average=4589
Kmalloc N*(alloc free)(4096): 0=698 1=697 2=811 3=812 Average=755

While most of my machines showed an improvement from Kernel A -> Kernel B 
-> Kernel C, this one had a significant regression from A to B.

"Kernel C" hangs on my netserver machine during netperf -t TCP_RR -l 60, 
though, so hopefully I'll be able to obtain results for that benchmark 
with the irqless patch and see if there's any noticable improvement once 
it's debugged.
