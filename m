Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbYB2N27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbYB2N27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 08:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbYB2N2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 08:28:52 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:33076 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612AbYB2N2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 08:28:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAD+Xx0dMQWoK/2dsb2JhbACBVpBkmxaBeg
Date: Fri, 29 Feb 2008 08:28:48 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Slub Freeoffset check overflow
Message-ID: <20080229132848.GA10565@Krystal>
References: <20080219200358.GB11197@Krystal> <Pine.LNX.4.64.0802271532580.14380@schroedinger.engr.sgi.com> <20080228055510.GA9026@Krystal> <Pine.LNX.4.64.0802281054230.29191@schroedinger.engr.sgi.com> <20080228232507.GB20319@Krystal> <Pine.LNX.4.64.0802281648510.1954@schroedinger.engr.sgi.com> <20080229015621.GB32200@Krystal> <Pine.LNX.4.64.0802281812290.3159@schroedinger.engr.sgi.com> <20080229033255.GA2200@Krystal> <Pine.LNX.4.64.0802282107090.5947@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802282107090.5947@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:17:54 up  9:28,  2 users,  load average: 0.23, 0.12, 0.22
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Thu, 28 Feb 2008, Mathieu Desnoyers wrote:
> 
> > * Christoph Lameter (clameter@sgi.com) wrote:
> > > On Thu, 28 Feb 2008, Mathieu Desnoyers wrote:
> > > 
> > > > In short, the we also use the versioning to check for change of slab.
> 
> Then we do not need the page->end field anymore right? I will try 
> to rediff your patch against current slab-mm and see how we can proceed 
> from there.


Slub Freeoffset check overflow

Check for overflow of the freeoffset version number.

I just thought adding this check in CONFIG_SLUB_DEBUG makes sense. It's
really unlikely that enough interrupt handlers will nest over the slub
fast path, and each of them do about a million alloc/free on 32 bits or
a huge amount of alloc/free on 64 bits, but just in case, it seems good
to warn if we detect we are half-way to a version overflow.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 mm/slub.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/mm/slub.c
===================================================================
--- linux-2.6-lttng.orig/mm/slub.c	2008-02-29 08:05:01.000000000 -0500
+++ linux-2.6-lttng/mm/slub.c	2008-02-29 08:16:13.000000000 -0500
@@ -1660,7 +1660,7 @@ static __always_inline void *slab_alloc(
  */
 
 #ifdef SLUB_FASTPATH
-	unsigned long freeoffset, newoffset;
+	unsigned long freeoffset, newoffset, resoffset;
 
 	c = get_cpu_slab(s, raw_smp_processor_id());
 	do {
@@ -1682,8 +1682,18 @@ static __always_inline void *slab_alloc(
 		newoffset = freeoffset;
 		newoffset &= ~c->off_mask;
 		newoffset |= (unsigned long)object[c->offset] & c->off_mask;
-	} while (cmpxchg_local(&c->freeoffset, freeoffset, newoffset)
-			!= freeoffset);
+		resoffset = cmpxchg_local(&c->freeoffset, freeoffset,
+				newoffset);
+#ifdef CONFIG_SLUB_DEBUG
+		/*
+		 * Just to be paranoid : warn if we detect that enough
+		 * allocations nested on top of us to get the counter to go
+		 * half-way to overflow. That would be insane to do that much
+		 * allocations in interrupt handers, but check it anyway.
+		 */
+		WARN_ON(resoffset - freeoffset > -1UL >> 1);
+#endif
+	} while (resoffset != freeoffset);
 #else
 	unsigned long flags;
 
@@ -1822,7 +1832,7 @@ static __always_inline void slab_free(st
 	struct kmem_cache_cpu *c;
 
 #ifdef SLUB_FASTPATH
-	unsigned long freeoffset, newoffset;
+	unsigned long freeoffset, newoffset, resoffset;
 
 	c = get_cpu_slab(s, raw_smp_processor_id());
 	debug_check_no_locks_freed(object, s->objsize);
@@ -1850,8 +1860,18 @@ static __always_inline void slab_free(st
 		newoffset = freeoffset + c->off_mask + 1;
 		newoffset &= ~c->off_mask;
 		newoffset |= (unsigned long)object & c->off_mask;
-	} while (cmpxchg_local(&c->freeoffset, freeoffset, newoffset)
-			!= freeoffset);
+		resoffset = cmpxchg_local(&c->freeoffset, freeoffset,
+				newoffset);
+#ifdef CONFIG_SLUB_DEBUG
+		/*
+		 * Just to be paranoid : warn if we detect that enough
+		 * allocations nested on top of us to get the counter to go
+		 * half-way to overflow. That would be insane to do that much
+		 * allocations in interrupt handers, but check it anyway.
+		 */
+		WARN_ON(resoffset - freeoffset > -1UL >> 1);
+#endif
+	} while (resoffset != freeoffset);
 #else
 	unsigned long flags;
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
