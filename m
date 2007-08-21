Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbXHUXMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbXHUXMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbXHUXMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:12:20 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:33369 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbXHUXMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:12:18 -0400
Date: Tue, 21 Aug 2007 19:12:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070821231216.GA29691@Krystal>
References: <20070820201822.597720007@polymtl.ca> <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com> <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com> <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com> <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com> <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211404290.3082@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708211404290.3082@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:07:47 up 22 days, 23:26,  3 users,  load average: 0.34, 0.36, 0.30
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:
> 
> > - Fixed an erroneous test in slab_free() (logic was flipped from the 
> >   original code when testing for slow path. It explains the wrong 
> >   numbers you have with big free).
> 
> If you look at the numbers that I posted earlier then you will see that 
> even the measurements without free were not up to par.
> 

I seem to get a clear performance improvement in the kmalloc fast path.

> > It applies on top of the 
> > "SLUB Use cmpxchg() everywhere" patch.
> 
> Which one is that?
> 

This one:


SLUB Use cmpxchg() everywhere.

It applies to "SLUB: Single atomic instruction alloc/free using
cmpxchg".

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: slab/mm/slub.c
===================================================================
--- slab.orig/mm/slub.c	2007-08-20 18:42:16.000000000 -0400
+++ slab/mm/slub.c	2007-08-20 18:42:28.000000000 -0400
@@ -1682,7 +1682,7 @@ redo:
 
 	object[c->offset] = freelist;
 
-	if (unlikely(cmpxchg_local(&c->freelist, freelist, object) != freelist))
+	if (unlikely(cmpxchg(&c->freelist, freelist, object) != freelist))
 		goto redo;
 	return;
 slow:

> >              |     slab.git HEAD slub (min-max)    |  cmpxchg_local slub
> > kmalloc(8)   |         190 - 201                   |         83
> > kfree(8)     |         351 - 351                   |        363
> > kmalloc(64)  |         224 - 245                   |        115
> > kfree(64)    |         389 - 394                   |        397
> > kmalloc(16384)|        713 - 741                   |        724
> > kfree(16384) |         843 - 856                   |        843
> > 
> > Therefore, there seems to be a repeatable gain on the kmalloc fast path
> > (more than twice faster). No significant performance hit for the kfree
> > case, but no gain neither, same for large kmalloc, as expected.
> 
> There is a consistent loss on slab_free it seems. The 16k numbers are 
> irrelevant since we do not use slab_alloc/slab_free due to the direct pass 
> through patch but call the page allocator directly. That also explains 
> that there is no loss there.
> 

Yes. slab_free in these tests falls mostly into __slab_free() slow path
(I instrumented the number of slow and fast path to get this). The small
performance hit (~10 cycles) can be explained by the added
preempt_disable()/preempt_enable().

> The kmalloc numbers look encouraging. I will check to see if I can 
> reproduce it once I sort out the patches.

Ok.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
