Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbZBQRNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbZBQRNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZBQRM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:12:59 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:52810 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752304AbZBQRM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:12:59 -0500
Date: Tue, 17 Feb 2009 12:05:07 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Mel Gorman <mel@csn.ul.ie>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch] SLQB slab allocator (try 2)
In-Reply-To: <1234890096.11511.6.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0902171204070.15929@qirst.com>
References: <20090123154653.GA14517@wotan.suse.de>  <200902041748.41801.nickpiggin@yahoo.com.au>  <20090204152709.GA4799@csn.ul.ie>  <200902051459.30064.nickpiggin@yahoo.com.au>  <20090216184200.GA31264@csn.ul.ie> <4999BBE6.2080003@cs.helsinki.fi> 
 <alpine.DEB.1.10.0902171120040.27813@qirst.com> <1234890096.11511.6.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well yes you missed two locations (kmalloc_caches array has to be
redimensioned) and I also was writing the same patch...

Here is mine:

Subject: SLUB: Do not pass 8k objects through to the page allocator

Increase the maximum object size in SLUB so that 8k objects are not
passed through to the page allocator anymore. The network stack uses 8k
objects for performance critical operations.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2009-02-17 10:45:51.000000000 -0600
+++ linux-2.6/include/linux/slub_def.h	2009-02-17 11:06:53.000000000 -0600
@@ -121,10 +121,21 @@
 #define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)

 /*
+ * Maximum kmalloc object size handled by SLUB. Larger object allocations
+ * are passed through to the page allocator. The page allocator "fastpath"
+ * is relatively slow so we need this value sufficiently high so that
+ * performance critical objects are allocated through the SLUB fastpath.
+ *
+ * This should be dropped to PAGE_SIZE / 2 once the page allocator
+ * "fastpath" becomes competitive with the slab allocator fastpaths.
+ */
+#define SLUB_MAX_SIZE (2 * PAGE_SIZE)
+
+/*
  * We keep the general caches in an array of slab caches that are used for
  * 2^x bytes of allocations.
  */
-extern struct kmem_cache kmalloc_caches[PAGE_SHIFT + 1];
+extern struct kmem_cache kmalloc_caches[PAGE_SHIFT + 2];

 /*
  * Sorry that the following has to be that ugly but some versions of GCC
@@ -212,7 +223,7 @@
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
 	if (__builtin_constant_p(size)) {
-		if (size > PAGE_SIZE)
+		if (size > SLUB_MAX_SIZE)
 			return kmalloc_large(size, flags);

 		if (!(flags & SLUB_DMA)) {
@@ -234,7 +245,7 @@
 static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	if (__builtin_constant_p(size) &&
-		size <= PAGE_SIZE && !(flags & SLUB_DMA)) {
+		size <= SLUB_MAX_SIZE && !(flags & SLUB_DMA)) {
 			struct kmem_cache *s = kmalloc_slab(size);

 		if (!s)
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2009-02-17 10:49:47.000000000 -0600
+++ linux-2.6/mm/slub.c	2009-02-17 10:58:14.000000000 -0600
@@ -2475,7 +2475,7 @@
  *		Kmalloc subsystem
  *******************************************************************/

-struct kmem_cache kmalloc_caches[PAGE_SHIFT + 1] __cacheline_aligned;
+struct kmem_cache kmalloc_caches[PAGE_SHIFT + 2] __cacheline_aligned;
 EXPORT_SYMBOL(kmalloc_caches);

 static int __init setup_slub_min_order(char *str)
@@ -2658,7 +2658,7 @@
 {
 	struct kmem_cache *s;

-	if (unlikely(size > PAGE_SIZE))
+	if (unlikely(size > SLUB_MAX_SIZE))
 		return kmalloc_large(size, flags);

 	s = get_slab(size, flags);
@@ -2686,7 +2686,7 @@
 {
 	struct kmem_cache *s;

-	if (unlikely(size > PAGE_SIZE))
+	if (unlikely(size > SLUB_MAX_SIZE))
 		return kmalloc_large_node(size, flags, node);

 	s = get_slab(size, flags);
@@ -3223,7 +3223,7 @@
 {
 	struct kmem_cache *s;

-	if (unlikely(size > PAGE_SIZE))
+	if (unlikely(size > SLUB_MAX_SIZE))
 		return kmalloc_large(size, gfpflags);

 	s = get_slab(size, gfpflags);
@@ -3239,7 +3239,7 @@
 {
 	struct kmem_cache *s;

-	if (unlikely(size > PAGE_SIZE))
+	if (unlikely(size > SLUB_MAX_SIZE))
 		return kmalloc_large_node(size, gfpflags, node);

 	s = get_slab(size, gfpflags);
