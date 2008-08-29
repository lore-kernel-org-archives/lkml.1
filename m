Return-Path: <linux-kernel-owner+w=401wt.eu-S1757170AbYH2XRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbYH2XRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 19:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYH2XRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 19:17:36 -0400
Received: from abydos.nerdbox.net ([216.151.149.55]:54430 "EHLO
	abydos.NerdBox.Net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758805AbYH2XRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 19:17:35 -0400
Date: Fri, 29 Aug 2008 16:17:34 -0700 (PDT)
From: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
To: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       jiayingz@google.com, dkegel@google.com
Subject: [PATCH 5/6] slab: Annotate slab
In-Reply-To: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
Message-ID: <alpine.DEB.1.00.0808291616560.15543@abydos.NerdBox.Net>
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valgrind annotations for the slab allocator:  Malloc-like and free-like
for cache_alloc and free.  Telling Valgrind a region is free-like clears
all the valid bits, so slabs with constructors need different treatment;
tell Valgrind about slab objects when first constructed and free them
when the slab is destroyed.

Signed-off-by: Steve VanDeBogart <vandebo-lkml@nerdbox.net>
---

Index: linux-2.6.27-rc5/mm/slab.c
===================================================================
--- linux-2.6.27-rc5.orig/mm/slab.c	2008-08-29 14:24:25.000000000 -0700
+++ linux-2.6.27-rc5/mm/slab.c	2008-08-29 14:24:42.000000000 -0700
@@ -111,6 +111,7 @@
  #include	<linux/rtmutex.h>
  #include	<linux/reciprocal_div.h>
  #include	<linux/debugobjects.h>
+#include	<linux/memcheck.h>

  #include	<asm/cacheflush.h>
  #include	<asm/tlbflush.h>
@@ -1906,6 +1907,8 @@
  	int i;
  	for (i = 0; i < cachep->num; i++) {
  		void *objp = index_to_obj(cachep, slabp, i);
+		if (cachep->ctor)
+			VALGRIND_FREELIKE_BLOCK(objp, 0);

  		if (cachep->flags & SLAB_POISON) {
  #ifdef CONFIG_DEBUG_PAGEALLOC
@@ -1932,6 +1935,15 @@
  #else
  static void slab_destroy_debugcheck(struct kmem_cache *cachep, struct slab *slabp)
  {
+#ifdef CONFIG_VALGRIND_SUPPORT
+	int i;
+	if (cachep->ctor) {
+		for (i = 0; i < cachep->num; i++) {
+			void *objp = index_to_obj(cachep, slabp, i);
+			VALGRIND_FREELIKE_BLOCK(objp, 0);
+		}
+	}
+#endif
  }
  #endif

@@ -2635,6 +2647,9 @@

  	for (i = 0; i < cachep->num; i++) {
  		void *objp = index_to_obj(cachep, slabp, i);
+		if (cachep->ctor)
+			VALGRIND_MALLOCLIKE_BLOCK(objp, cachep->buffer_size,
+							0, 0);
  #if DEBUG
  		/* need to poison the objs? */
  		if (cachep->flags & SLAB_POISON)
@@ -3466,6 +3481,8 @@
  	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
  	prefetchw(objp);

+	if (!cachep->ctor)
+		VALGRIND_MALLOCLIKE_BLOCK(objp, cachep->buffer_size, 0, 0);
  	if (unlikely((flags & __GFP_ZERO) && objp))
  		memset(objp, 0, obj_size(cachep));

@@ -3578,6 +3595,9 @@
  {
  	struct array_cache *ac = cpu_cache_get(cachep);

+	if (!cachep->ctor)
+		VALGRIND_FREELIKE_BLOCK(objp, 0);
+
  	check_irq_off();
  	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));

