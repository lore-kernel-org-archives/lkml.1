Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbXHUXjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbXHUXjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbXHUXjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:39:41 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:50840 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752928AbXHUXjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:39:40 -0400
Date: Tue, 21 Aug 2007 19:39:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070821233938.GD29691@Krystal>
References: <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com> <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com> <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com> <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211404290.3082@schroedinger.engr.sgi.com> <20070821231216.GA29691@Krystal> <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:23:32 up 22 days, 23:42,  3 users,  load average: 0.47, 0.42, 0.33
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:
> 
> > SLUB Use cmpxchg() everywhere.
> > 
> > It applies to "SLUB: Single atomic instruction alloc/free using
> > cmpxchg".
> 
> > +++ slab/mm/slub.c	2007-08-20 18:42:28.000000000 -0400
> > @@ -1682,7 +1682,7 @@ redo:
> >  
> >  	object[c->offset] = freelist;
> >  
> > -	if (unlikely(cmpxchg_local(&c->freelist, freelist, object) != freelist))
> > +	if (unlikely(cmpxchg(&c->freelist, freelist, object) != freelist))
> >  		goto redo;
> >  	return;
> >  slow:
> 
> Ok so regular cmpxchg, no cmpxchg_local. cmpxchg_local does not bring 
> anything more? My measurements did not show any difference. I measured on 
> Athlon64. What processor is being used?
> 

This patch only cleans up the tree before proposing my cmpxchg_local
changes. There was an inconsistent use of cmpxchg/cmpxchg_local there.

Using cmpxchg_local vs cmpxchg has a clear impact on the fast paths, as
shown below: it saves about 60 to 70 cycles for kmalloc and 200 cycles
for the kmalloc/kfree pair (test 2).

Pros :
- we can use barrier() instead of rmb()
- cmpxchg_local is faster

Con :
- we must disable preemption

I use a 3GHz Pentium 4 for my tests.

Results (compared to cmpxchg_local numbers) :

SLUB Performance testing
========================
1. Kmalloc: Repeatedly allocate then free test
(kfree here is slow path)

* cmpxchg
kmalloc(8) = 271 cycles	    kfree = 645 cycles
kmalloc(16) = 158 cycles	  kfree = 428 cycles
kmalloc(32) = 153 cycles	  kfree = 446 cycles
kmalloc(64) = 178 cycles	  kfree = 459 cycles
kmalloc(128) = 247 cycles	  kfree = 481 cycles
kmalloc(256) = 363 cycles	  kfree = 605 cycles
kmalloc(512) = 449 cycles	  kfree = 677 cycles
kmalloc(1024) = 626 cycles	kfree = 810 cycles
kmalloc(2048) = 681 cycles	kfree = 869 cycles
kmalloc(4096) = 471 cycles	kfree = 575 cycles
kmalloc(8192) = 666 cycles	kfree = 747 cycles
kmalloc(16384) = 736 cycles	kfree = 853 cycles

* cmpxchg_local
kmalloc(8) = 83 cycles      kfree = 363 cycles
kmalloc(16) = 85 cycles     kfree = 372 cycles
kmalloc(32) = 92 cycles     kfree = 377 cycles
kmalloc(64) = 115 cycles    kfree = 397 cycles
kmalloc(128) = 179 cycles   kfree = 438 cycles
kmalloc(256) = 314 cycles   kfree = 564 cycles
kmalloc(512) = 398 cycles   kfree = 615 cycles
kmalloc(1024) = 573 cycles  kfree = 745 cycles
kmalloc(2048) = 629 cycles  kfree = 816 cycles
kmalloc(4096) = 473 cycles  kfree = 548 cycles
kmalloc(8192) = 659 cycles  kfree = 745 cycles
kmalloc(16384) = 724 cycles kfree = 843 cycles


2. Kmalloc: alloc/free test

*cmpxchg
kmalloc(8)/kfree = 321 cycles
kmalloc(16)/kfree = 308 cycles
kmalloc(32)/kfree = 311 cycles
kmalloc(64)/kfree = 310 cycles
kmalloc(128)/kfree = 306 cycles
kmalloc(256)/kfree = 325 cycles
kmalloc(512)/kfree = 324 cycles
kmalloc(1024)/kfree = 322 cycles
kmalloc(2048)/kfree = 309 cycles
kmalloc(4096)/kfree = 678 cycles
kmalloc(8192)/kfree = 1027 cycles
kmalloc(16384)/kfree = 1204 cycles

* cmpxchg_local
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

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
