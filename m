Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbXFKS4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbXFKS4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbXFKS4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:56:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:43979 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752542AbXFKS4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:56:11 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/V80EIR3fVg+Ql2ldkuucXbTaVU8fyagv80JUZ4F
	HeGHMACIuYeKxK
Date: Mon, 11 Jun 2007 20:56:08 +0200
From: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: clameter@sgi.com
Subject: profiling likely/unlikely in slub.c
Message-ID: <20070611185608.GB4592@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.22-rc3 (x86_64)
X-Uptime: 20:49:07 up 12:48,  5 users,  load average: 0.08, 0.09, 0.14
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

when taking a look at /proc/likely_prof i noticed the following

+unlikely | 40969931|  6228144  __slab_free()@:mm/slub.c@1606
+unlikely | 47198075|        0  __slab_free()@:mm/slub.c@1599
-likely   |        0| 47198075  slab_free()@:mm/slub.c@1660
+unlikely | 47280864|        0  __slab_alloc()@:mm/slub.c@1475
+unlikely |    26857|        0  new_slab()@:mm/slub.c@1107
+unlikely | 47280864|        0  slab_alloc()@:mm/slub.c@1557

three of the unlikely cases are caused by "if (unlikely(SlabDebug(page)))"
if SLUB_DEBUG is turned off, it really is unlikely, since SlabDebug()
always returns 0, if SLUB_DEBUG is turned on it is likely (not sure if there are
cases where it can return 0) therefore it makes sense to change this
to likely for the SLUB_DEBUG case. 

The following patch changes the SlabDebug() functions to defines, so gcc
can easily optimize the if away entirely and changes the unlikely() to a
likely().

Remaining problem is, that if likely/unlikely profiling is turned on,
gcc does not optimize away a likely(0), and they still show up in the
stats... guess heisenbug is involved in this :-)


Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>

--- linux/mm/slub.c.orig	2007-06-11 09:04:15.000000000 +0000
+++ linux/mm/slub.c	2007-06-11 17:11:36.000000000 +0000
@@ -101,12 +101,6 @@
 
 #define FROZEN (1 << PG_active)
 
-#ifdef CONFIG_SLUB_DEBUG
-#define SLABDEBUG (1 << PG_error)
-#else
-#define SLABDEBUG 0
-#endif
-
 static inline int SlabFrozen(struct page *page)
 {
 	return page->flags & FROZEN;
@@ -122,6 +116,9 @@ static inline void ClearSlabFrozen(struc
 	page->flags &= ~FROZEN;
 }
 
+#ifdef CONFIG_SLUB_DEBUG
+
+#define SLABDEBUG (1 << PG_error)
 static inline int SlabDebug(struct page *page)
 {
 	return page->flags & SLABDEBUG;
@@ -136,6 +133,13 @@ static inline void ClearSlabDebug(struct
 {
 	page->flags &= ~SLABDEBUG;
 }
+#else
+
+#define SlabDebug(x) 0
+#define SetSlabDebug(x) 
+#define ClearSlabDebug(x)
+
+#endif
 
 /*
  * Issues still to be resolved:
@@ -1129,7 +1133,7 @@ static void __free_slab(struct kmem_cach
 {
 	int pages = 1 << s->order;
 
-	if (unlikely(SlabDebug(page))) {
+	if (likely(SlabDebug(page))) {
 		void *p;
 
 		slab_pad_check(s, page);
@@ -1472,7 +1476,7 @@ load_freelist:
 	object = page->freelist;
 	if (unlikely(!object))
 		goto another_slab;
-	if (unlikely(SlabDebug(page)))
+	if (likely(SlabDebug(page)))
 		goto debug;
 
 	object = page->freelist;
@@ -1596,7 +1600,7 @@ static void __slab_free(struct kmem_cach
 
 	slab_lock(page);
 
-	if (unlikely(SlabDebug(page)))
+	if (likely(SlabDebug(page)))
 		goto debug;
 checks_ok:
 	prior = object[page->offset] = page->freelist;

