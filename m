Return-Path: <linux-kernel-owner+w=401wt.eu-S933074AbXGOBjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074AbXGOBjB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 21:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762559AbXGOBiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 21:38:54 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:48887 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760534AbXGOBiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 21:38:54 -0400
Date: Sat, 14 Jul 2007 21:38:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH] Immediate Values - PowerPC Optimization - kerneldoc
Message-ID: <20070715013852.GH23209@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012624.842959793@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012624.842959793@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:38:03 up 7 days, 15:43,  2 users,  load average: 0.17, 0.23, 0.17
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate Values - PowerPC Optimization - kerneldoc

Add kerneldoc to Immediate Values (PowerPC Optimization) API.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
---
 include/asm-powerpc/immediate.h |   51 ++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 15 deletions(-)

Index: linux-2.6-lttng/include/asm-powerpc/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-powerpc/immediate.h	2007-07-14 20:54:47.000000000 -0400
+++ linux-2.6-lttng/include/asm-powerpc/immediate.h	2007-07-14 20:56:50.000000000 -0400
@@ -24,14 +24,18 @@ struct __immediate {
 	long size;		/* Type size. */
 };
 
-/*
+/**
+ * immediate_read - read immediate variable
+ * @var: pointer of type immediate_*_t
+ *
+ * Reads the value of @var.
  * Optimized version of the immediate.
- * Make sure the 2 bytes update will be atomic by aligning the immediate
- * value.
- * Use a normal memory read for the 4 bytes immediate because there is no way to
- * atomically update it without using a seqlock read side, which would cost more
- * in term of total i-cache and d-cache space than a simple memory read.
  * Do not use in __init and __exit functions. Use _immediate_read() instead.
+ * Makes sure the 2 bytes update will be atomic by aligning the immediate
+ * value. Use a normal memory read for the 4 bytes immediate because there is no
+ * way to atomically update it without using a seqlock read side, which would
+ * cost more in term of total i-cache and d-cache space than a simple memory
+ * read.
  */
 #define immediate_read(var)						\
 	({								\
@@ -65,37 +69,54 @@ struct __immediate {
 		value;							\
 	})
 
-/*
- * Update immediate value, can take module mutex.
+/**
+ * immediate_set - set immediate variable (with locking)
+ * @var: pointer of type immediate_*_t
+ * @i: required value
+ *
+ * Sets the value of @var, taking the module_mutex if required by
+ * the architecture.
  */
 #define immediate_set(var, i) \
 	(var)->value = (i); \
 	immediate_update(1);
 
-/*
- * Update immediate value. Module mutex must already be taken.
+/**
+ * _immediate_set - set immediate variable (without locking)
+ * @var: pointer of type immediate_*_t
+ * @i: required value
+ *
+ * Sets the value of @var. Must be called with module_mutex held.
  */
 #define _immediate_set(var, i) \
 	(var)->value = (i); \
 	immediate_update(0);
 
-/*
- * Update immediate value at early boot.
+/**
+ * immediate_set_early - set immediate variable at early boot
+ * @var: pointer of type immediate_*_t
+ * @i: required value
+ *
+ * Sets the value of @var. Should be used for early boot updates.
  */
 #define immediate_set_early(var, i) \
 	(var)->value = (i); \
 	immediate_update_early();
 
-/*
+/**
+ * immediate_if - if () statement depending on an immediate value
+ * @var: pointer of type immediate_*_t
+ *
+ * Use as an if () statement depending on an immediate value.
+ * Do not use in __init and __exit functions. Use _immediate_if() instead.
  * Branch depending on an immediate value. Could eventually be optimized further
  * by improving gcc to give the ability to patch a jump instruction instead of
  * the value it depends on.
- * Do not use in __init and __exit functions. Use _immediate_if() instead.
  */
 #define immediate_if(var)	if (unlikely(immediate_read(var)))
 
 /*
- * Used internally.
+ * Internal update functions.
  */
 extern void immediate_update(int lock);
 extern void module_immediate_setup(struct module *mod);
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
