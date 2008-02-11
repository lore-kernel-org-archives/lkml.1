Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbYBKUr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbYBKUr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYBKUrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:47:49 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46879 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYBKUrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:47:48 -0500
Date: Mon, 11 Feb 2008 22:47:46 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: clameter@sgi.com
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] slub: kmalloc page allocator pass-through cleanup
Message-ID: <Pine.LNX.4.64.0802112246550.7687@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This adds a proper function for kmalloc page allocator pass-through. While it
simplifies any code that does slab tracing code a lot, I think it's a
worthwhile cleanup in itself.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/slub_def.h |    8 ++++++--
 mm/slub.c                |   14 ++++++--------
 2 files changed, 12 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2008-02-11 22:29:00.000000000 +0200
+++ linux-2.6/include/linux/slub_def.h	2008-02-11 22:30:34.000000000 +0200
@@ -162,12 +162,16 @@
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
+static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
+{
+	return (void *)__get_free_pages(flags | __GFP_COMP, get_order(size));
+}
+
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
 	if (__builtin_constant_p(size)) {
 		if (size > PAGE_SIZE / 2)
-			return (void *)__get_free_pages(flags | __GFP_COMP,
-							get_order(size));
+			return kmalloc_large(size, flags);
 
 		if (!(flags & SLUB_DMA)) {
 			struct kmem_cache *s = kmalloc_slab(size);
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-02-11 22:30:37.000000000 +0200
+++ linux-2.6/mm/slub.c	2008-02-11 22:32:14.000000000 +0200
@@ -2518,8 +2518,7 @@
 	struct kmem_cache *s;
 
 	if (unlikely(size > PAGE_SIZE / 2))
-		return (void *)__get_free_pages(flags | __GFP_COMP,
-							get_order(size));
+		return kmalloc_large(size, flags);
 
 	s = get_slab(size, flags);
 
@@ -2536,8 +2535,7 @@
 	struct kmem_cache *s;
 
 	if (unlikely(size > PAGE_SIZE / 2))
-		return (void *)__get_free_pages(flags | __GFP_COMP,
-							get_order(size));
+		return kmalloc_large(size, flags);
 
 	s = get_slab(size, flags);
 
@@ -3050,8 +3048,8 @@
 	struct kmem_cache *s;
 
 	if (unlikely(size > PAGE_SIZE / 2))
-		return (void *)__get_free_pages(gfpflags | __GFP_COMP,
-							get_order(size));
+		return kmalloc_large(size, gfpflags);
+
 	s = get_slab(size, gfpflags);
 
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
@@ -3066,8 +3064,8 @@
 	struct kmem_cache *s;
 
 	if (unlikely(size > PAGE_SIZE / 2))
-		return (void *)__get_free_pages(gfpflags | __GFP_COMP,
-							get_order(size));
+		return kmalloc_large(size, gfpflags);
+
 	s = get_slab(size, gfpflags);
 
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
