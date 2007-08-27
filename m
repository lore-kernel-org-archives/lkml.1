Return-Path: <linux-kernel-owner+w=401wt.eu-S1762199AbXH0RcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762199AbXH0RcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbXH0RcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:32:06 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:35070 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758328AbXH0RcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:32:04 -0400
Date: Mon, 27 Aug 2007 13:31:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/28] Add cmpxchg64_local and cmpxchg_local to each architecture
Message-ID: <20070827173151.GA28974@Krystal>
References: <20070827155234.062715780@polymtl.ca> <20070827091726.a2e8fbb8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070827091726.a2e8fbb8.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:06:12 up 28 days, 17:25,  6 users,  load average: 0.46, 0.46, 0.88
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Mon, 27 Aug 2007 11:52:34 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Here is the patch series for 2.6.23-rc3-mm1 that adds cmpxchg_local, and now
> > also cmpxchg64_local, to each architecture.
> 
> How well tested are these on the various architectures?
> 

I compile-tested the patchset on:

arm
i686
ia64
m68k
mips/mipsel
powerpc405
powerpc 64
s390
sparc64
sparc
x86_64

With various config options (ALL yes, ALL no, all modules,
CONFIG_MODULES=yes/no...)

Since then, I added the trivial architecture-specific patches:
add-cmpxchg64-to-alpha.patch
add-cmpxchg64-to-mips.patch
add-cmpxchg64-to-powerpc.patch
add-cmpxchg64-to-x86_64.patch

Which I tested before submitting; mips, powerpc405, powerpc64 and x86_64
build fine. (I have no cross-compiler for alpha though)

The rest of the changes, since last thorough architecture-wide compile
test, were either architecture specific comments I got from LKML or
tested since then because they were architecture agnostic.

I must admit though that there are still a few architectures I touch in
the cmpxchg_local patches for which I don't have a cross-compiler. But I
think the changes are trivial enough, and repetitive enough across
architectures, to minimize the build breakages.

For runtime testing, I am a bit limited on hardware: I myself have i686
and AMD64, and rely on the LTTng community (and the kernel community) to
test the other architectures.

Christoph Lameter and I tested the cmpxchg_local with slub on i686 and
x86_64.


> > When the architecture supports it, it also defines cmpxchg64, but is is not
> > defined for architecture that does not support atomic 64 bits updates.
> > 
> > Following performance testing of the slub allocator with cmpxchg_local, these
> > patches should prove themselves useful in a near future.
> 
> It would be useful if we could have (numerical) details on these benefits as
> part of this patch series description, please.
> 

Sure, they follow at the end of this email (will append to the
add-cmpxchg-local-to-generic-for-up.patch description).

> Also, it would be good to get the slub patch in there at the same time so that
> the new code gets a bit of exercise.
> 

Good point. Christoph, could you please prepare a slub cmpxchg_local
patch for the mm tree ?

Mathieu

> Thanks.

Patch add-cmpxchg-local-to-generic-for-up.patch description addendum :

* Patch series comments

Performance improvements of the fast path goes from a 66% speedup on a
Pentium 4 to a 14% speedup on AMD64.

Tested-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Measurements on a Pentium4, 3GHz, Hyperthread.
SLUB Performance testing
========================
1. Kmalloc: Repeatedly allocate then free test

* slub HEAD, test 1
kmalloc(8) = 201 cycles         kfree = 351 cycles
kmalloc(16) = 198 cycles        kfree = 359 cycles
kmalloc(32) = 200 cycles        kfree = 381 cycles
kmalloc(64) = 224 cycles        kfree = 394 cycles
kmalloc(128) = 285 cycles       kfree = 424 cycles
kmalloc(256) = 411 cycles       kfree = 546 cycles
kmalloc(512) = 480 cycles       kfree = 619 cycles
kmalloc(1024) = 623 cycles      kfree = 750 cycles
kmalloc(2048) = 686 cycles      kfree = 811 cycles
kmalloc(4096) = 482 cycles      kfree = 538 cycles
kmalloc(8192) = 680 cycles      kfree = 734 cycles
kmalloc(16384) = 713 cycles     kfree = 843 cycles

* Slub HEAD, test 2
kmalloc(8) = 190 cycles         kfree = 351 cycles
kmalloc(16) = 195 cycles        kfree = 360 cycles
kmalloc(32) = 201 cycles        kfree = 370 cycles
kmalloc(64) = 245 cycles        kfree = 389 cycles
kmalloc(128) = 283 cycles       kfree = 413 cycles
kmalloc(256) = 409 cycles       kfree = 547 cycles
kmalloc(512) = 476 cycles       kfree = 616 cycles
kmalloc(1024) = 628 cycles      kfree = 753 cycles
kmalloc(2048) = 684 cycles      kfree = 811 cycles
kmalloc(4096) = 480 cycles      kfree = 539 cycles
kmalloc(8192) = 661 cycles      kfree = 746 cycles
kmalloc(16384) = 741 cycles     kfree = 856 cycles

* cmpxchg_local Slub test
kmalloc(8) = 83 cycles          kfree = 363 cycles
kmalloc(16) = 85 cycles         kfree = 372 cycles
kmalloc(32) = 92 cycles         kfree = 377 cycles
kmalloc(64) = 115 cycles        kfree = 397 cycles
kmalloc(128) = 179 cycles       kfree = 438 cycles
kmalloc(256) = 314 cycles       kfree = 564 cycles
kmalloc(512) = 398 cycles       kfree = 615 cycles
kmalloc(1024) = 573 cycles      kfree = 745 cycles
kmalloc(2048) = 629 cycles      kfree = 816 cycles
kmalloc(4096) = 473 cycles      kfree = 548 cycles
kmalloc(8192) = 659 cycles      kfree = 745 cycles
kmalloc(16384) = 724 cycles     kfree = 843 cycles


2. Kmalloc: alloc/free test

* slub HEAD, test 1
kmalloc(8)/kfree = 322 cycles
kmalloc(16)/kfree = 318 cycles
kmalloc(32)/kfree = 318 cycles
kmalloc(64)/kfree = 325 cycles
kmalloc(128)/kfree = 318 cycles
kmalloc(256)/kfree = 328 cycles
kmalloc(512)/kfree = 328 cycles
kmalloc(1024)/kfree = 328 cycles
kmalloc(2048)/kfree = 328 cycles
kmalloc(4096)/kfree = 678 cycles
kmalloc(8192)/kfree = 1013 cycles
kmalloc(16384)/kfree = 1157 cycles

* Slub HEAD, test 2
kmalloc(8)/kfree = 323 cycles
kmalloc(16)/kfree = 318 cycles
kmalloc(32)/kfree = 318 cycles
kmalloc(64)/kfree = 318 cycles
kmalloc(128)/kfree = 318 cycles
kmalloc(256)/kfree = 328 cycles
kmalloc(512)/kfree = 328 cycles
kmalloc(1024)/kfree = 328 cycles
kmalloc(2048)/kfree = 328 cycles
kmalloc(4096)/kfree = 648 cycles
kmalloc(8192)/kfree = 1009 cycles
kmalloc(16384)/kfree = 1105 cycles

* cmpxchg_local Slub test
kmalloc(8)/kfree = 112 cycles
kmalloc(16)/kfree = 103 cycles
kmalloc(32)/kfree = 103 cycles
kmalloc(64)/kfree = 103 cycles
kmalloc(128)/kfree = 112 cycles
kmalloc(256)/kfree = 111 cycles
kmalloc(512)/kfree = 111 cycles
kmalloc(1024)/kfree = 111 cycles
kmalloc(2048)/kfree = 121 cycles
kmalloc(4096)/kfree = 650 cycles
kmalloc(8192)/kfree = 1042 cycles
kmalloc(16384)/kfree = 1149 cycles



Tested-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Measurements on a AMD64 2.0 GHz dual-core

In this test, we seem to remove 10 cycles from the kmalloc fast path.
On small allocations, it gives a 14% performance increase. kfree fast
path also seems to have a 10 cycles improvement.

1. Kmalloc: Repeatedly allocate then free test

* cmpxchg_local slub
kmalloc(8) = 63 cycles      kfree = 126 cycles
kmalloc(16) = 66 cycles     kfree = 129 cycles
kmalloc(32) = 76 cycles     kfree = 138 cycles
kmalloc(64) = 100 cycles    kfree = 288 cycles
kmalloc(128) = 128 cycles   kfree = 309 cycles
kmalloc(256) = 170 cycles   kfree = 315 cycles
kmalloc(512) = 221 cycles   kfree = 357 cycles
kmalloc(1024) = 324 cycles  kfree = 393 cycles
kmalloc(2048) = 354 cycles  kfree = 440 cycles
kmalloc(4096) = 394 cycles  kfree = 330 cycles
kmalloc(8192) = 523 cycles  kfree = 481 cycles
kmalloc(16384) = 643 cycles kfree = 649 cycles

* Base
kmalloc(8) = 74 cycles      kfree = 113 cycles
kmalloc(16) = 76 cycles     kfree = 116 cycles
kmalloc(32) = 85 cycles     kfree = 133 cycles
kmalloc(64) = 111 cycles    kfree = 279 cycles
kmalloc(128) = 138 cycles   kfree = 294 cycles
kmalloc(256) = 181 cycles   kfree = 304 cycles
kmalloc(512) = 237 cycles   kfree = 327 cycles
kmalloc(1024) = 340 cycles  kfree = 379 cycles
kmalloc(2048) = 378 cycles  kfree = 433 cycles
kmalloc(4096) = 399 cycles  kfree = 329 cycles
kmalloc(8192) = 528 cycles  kfree = 624 cycles
kmalloc(16384) = 651 cycles kfree = 737 cycles

2. Kmalloc: alloc/free test

* cmpxchg_local slub
kmalloc(8)/kfree = 96 cycles
kmalloc(16)/kfree = 97 cycles
kmalloc(32)/kfree = 97 cycles
kmalloc(64)/kfree = 97 cycles
kmalloc(128)/kfree = 97 cycles
kmalloc(256)/kfree = 105 cycles
kmalloc(512)/kfree = 108 cycles
kmalloc(1024)/kfree = 105 cycles
kmalloc(2048)/kfree = 107 cycles
kmalloc(4096)/kfree = 390 cycles
kmalloc(8192)/kfree = 626 cycles
kmalloc(16384)/kfree = 662 cycles

* Base
kmalloc(8)/kfree = 116 cycles
kmalloc(16)/kfree = 116 cycles
kmalloc(32)/kfree = 116 cycles
kmalloc(64)/kfree = 116 cycles
kmalloc(128)/kfree = 116 cycles
kmalloc(256)/kfree = 126 cycles
kmalloc(512)/kfree = 126 cycles
kmalloc(1024)/kfree = 126 cycles
kmalloc(2048)/kfree = 126 cycles
kmalloc(4096)/kfree = 384 cycles
kmalloc(8192)/kfree = 749 cycles
kmalloc(16384)/kfree = 786 cycles


Tested-by: Christoph Lameter <clameter@sgi.com>
I can confirm Mathieus' measurement now:

Athlon64:

regular NUMA/discontig

1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 79 cycles kfree -> 92 cycles
10000 times kmalloc(16) -> 79 cycles kfree -> 93 cycles
10000 times kmalloc(32) -> 88 cycles kfree -> 95 cycles
10000 times kmalloc(64) -> 124 cycles kfree -> 132 cycles
10000 times kmalloc(128) -> 157 cycles kfree -> 247 cycles
10000 times kmalloc(256) -> 200 cycles kfree -> 257 cycles
10000 times kmalloc(512) -> 250 cycles kfree -> 277 cycles
10000 times kmalloc(1024) -> 337 cycles kfree -> 314 cycles
10000 times kmalloc(2048) -> 365 cycles kfree -> 330 cycles
10000 times kmalloc(4096) -> 352 cycles kfree -> 240 cycles
10000 times kmalloc(8192) -> 456 cycles kfree -> 340 cycles
10000 times kmalloc(16384) -> 646 cycles kfree -> 471 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 124 cycles
10000 times kmalloc(16)/kfree -> 124 cycles
10000 times kmalloc(32)/kfree -> 124 cycles
10000 times kmalloc(64)/kfree -> 124 cycles
10000 times kmalloc(128)/kfree -> 124 cycles
10000 times kmalloc(256)/kfree -> 132 cycles
10000 times kmalloc(512)/kfree -> 132 cycles
10000 times kmalloc(1024)/kfree -> 132 cycles
10000 times kmalloc(2048)/kfree -> 132 cycles
10000 times kmalloc(4096)/kfree -> 319 cycles
10000 times kmalloc(8192)/kfree -> 486 cycles
10000 times kmalloc(16384)/kfree -> 539 cycles

cmpxchg_local NUMA/discontig

1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 55 cycles kfree -> 90 cycles
10000 times kmalloc(16) -> 55 cycles kfree -> 92 cycles
10000 times kmalloc(32) -> 70 cycles kfree -> 91 cycles
10000 times kmalloc(64) -> 100 cycles kfree -> 141 cycles
10000 times kmalloc(128) -> 128 cycles kfree -> 233 cycles
10000 times kmalloc(256) -> 172 cycles kfree -> 251 cycles
10000 times kmalloc(512) -> 225 cycles kfree -> 275 cycles
10000 times kmalloc(1024) -> 325 cycles kfree -> 311 cycles
10000 times kmalloc(2048) -> 346 cycles kfree -> 330 cycles
10000 times kmalloc(4096) -> 351 cycles kfree -> 238 cycles
10000 times kmalloc(8192) -> 450 cycles kfree -> 342 cycles
10000 times kmalloc(16384) -> 630 cycles kfree -> 546 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 81 cycles
10000 times kmalloc(16)/kfree -> 81 cycles
10000 times kmalloc(32)/kfree -> 81 cycles
10000 times kmalloc(64)/kfree -> 81 cycles
10000 times kmalloc(128)/kfree -> 81 cycles
10000 times kmalloc(256)/kfree -> 91 cycles
10000 times kmalloc(512)/kfree -> 90 cycles
10000 times kmalloc(1024)/kfree -> 91 cycles
10000 times kmalloc(2048)/kfree -> 90 cycles
10000 times kmalloc(4096)/kfree -> 318 cycles
10000 times kmalloc(8192)/kfree -> 483 cycles
10000 times kmalloc(16384)/kfree -> 536 cycles


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
