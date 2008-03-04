Return-Path: <linux-kernel-owner+w=401wt.eu-S1758659AbYCDGRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659AbYCDGRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYCDGRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:17:30 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:51997 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751162AbYCDGR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:17:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CADp3zEdMQWoK/2dsb2JhbACBVpBrmn2BfA
Date: Tue, 4 Mar 2008 01:17:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtml.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Slub Freeoffset check overflow (updated)
Message-ID: <20080304061721.GA27279@Krystal>
References: <Pine.LNX.4.64.0802271532580.14380@schroedinger.engr.sgi.com> <20080228055510.GA9026@Krystal> <Pine.LNX.4.64.0802281054230.29191@schroedinger.engr.sgi.com> <20080228232507.GB20319@Krystal> <Pine.LNX.4.64.0802281648510.1954@schroedinger.engr.sgi.com> <20080229015621.GB32200@Krystal> <Pine.LNX.4.64.0802281812290.3159@schroedinger.engr.sgi.com> <20080229033255.GA2200@Krystal> <Pine.LNX.4.64.0802282107090.5947@schroedinger.engr.sgi.com> <20080229132848.GA10565@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080229132848.GA10565@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:04:54 up 4 days,  2:15,  5 users,  load average: 0.14, 0.41,
	0.37
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for overflow of the freeoffset version number.

I just thought adding this check in CONFIG_SLUB_DEBUG makes sense. It's
really unlikely that enough interrupt handlers will nest over the slub
fast path, and each of them do about a million alloc/free on 32 bits or
a huge amount of alloc/free on 64 bits, but just in case, it seems good
to warn if we detect we are half-way to a version overflow.

Changelog :
- Mask out the LSB because of alloc fast path. See comment in source.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 mm/slub.c |   40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/mm/slub.c
===================================================================
--- linux-2.6-lttng.orig/mm/slub.c	2008-03-04 00:59:01.000000000 -0500
+++ linux-2.6-lttng/mm/slub.c	2008-03-04 01:03:44.000000000 -0500
@@ -1660,7 +1660,7 @@ static __always_inline void *slab_alloc(
  */
 
 #ifdef SLUB_FASTPATH
-	unsigned long freeoffset, newoffset;
+	unsigned long freeoffset, newoffset, resoffset;
 
 	c = get_cpu_slab(s, raw_smp_processor_id());
 	do {
@@ -1682,8 +1682,22 @@ static __always_inline void *slab_alloc(
 		newoffset = freeoffset;
 		newoffset &= ~c->off_mask;
 		newoffset |= (unsigned long)object[c->offset] & c->off_mask;
-	} while (cmpxchg_local(&c->freeoffset, freeoffset, newoffset)
-			!= freeoffset);
+		resoffset = cmpxchg_local(&c->freeoffset, freeoffset,
+				newoffset);
+#ifdef CONFIG_SLUB_DEBUG
+		/*
+		 * Just to be paranoid : warn if we detect that enough free or
+		 * slow paths nested on top of us to get the counter to go
+		 * half-way to overflow. That would be insane to do that much
+		 * allocations/free in interrupt handers, but check it anyway.
+		 * Mask out the LSBs because alloc fast path does not increment
+		 * the sequence number, which may cause the overall values to go
+		 * backward.
+		 */
+		WARN_ON((resoffset & ~c->off_mask)
+			- (freeoffset & ~c->off_mask) > -1UL >> 1);
+#endif
+	} while (resoffset != freeoffset);
 #else
 	unsigned long flags;
 
@@ -1822,7 +1836,7 @@ static __always_inline void slab_free(st
 	struct kmem_cache_cpu *c;
 
 #ifdef SLUB_FASTPATH
-	unsigned long freeoffset, newoffset;
+	unsigned long freeoffset, newoffset, resoffset;
 
 	c = get_cpu_slab(s, raw_smp_processor_id());
 	debug_check_no_locks_freed(object, s->objsize);
@@ -1850,8 +1864,22 @@ static __always_inline void slab_free(st
 		newoffset = freeoffset + c->off_mask + 1;
 		newoffset &= ~c->off_mask;
 		newoffset |= (unsigned long)object & c->off_mask;
-	} while (cmpxchg_local(&c->freeoffset, freeoffset, newoffset)
-			!= freeoffset);
+		resoffset = cmpxchg_local(&c->freeoffset, freeoffset,
+				newoffset);
+#ifdef CONFIG_SLUB_DEBUG
+		/*
+		 * Just to be paranoid : warn if we detect that enough free or
+		 * slow paths nested on top of us to get the counter to go
+		 * half-way to overflow. That would be insane to do that much
+		 * allocations/free in interrupt handers, but check it anyway.
+		 * Mask out the LSBs because alloc fast path does not increment
+		 * the sequence number, which may cause the overall values to go
+		 * backward.
+		 */
+		WARN_ON((resoffset & ~c->off_mask)
+			- (freeoffset & ~c->off_mask) > -1UL >> 1);
+#endif
+	} while (resoffset != freeoffset);
 #else
 	unsigned long flags;
 
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
