Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbYCKBey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbYCKBey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 21:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYCKBer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 21:34:47 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:54862 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYCKBeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 21:34:46 -0400
Date: Tue, 11 Mar 2008 02:34:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, clameter@sgi.com,
       willy@linux.intel.com
Subject: [PATCH] Enable dmapool debugging for CONFIG_SLUB_DEBUG_ON too
Message-ID: <20080311013444.GA705@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 11 Mar 2008 01:28:12.0482 (UTC) FILETIME=[2BF1EA20:01C88317]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable dmapool debugging for CONFIG_SLUB_DEBUG_ON too

Previously it was only enabled for CONFIG_SLAB_DEBUG.

Not hooked into the slub runtime debug configuration, so you currently
only get it with CONFIG_SLUB_DEBUG_ON, not plain CONFIG_SLUB_DEBUG

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/mm/dmapool.c
===================================================================
--- linux.orig/mm/dmapool.c
+++ linux/mm/dmapool.c
@@ -37,6 +37,10 @@
 #include <linux/types.h>
 #include <linux/wait.h>
 
+#if defined(CONFIG_SLAB_DEBUG) || defined(CONFIG_SLUB_DEBUG_ON)
+#define DMAPOOL_DEBUG 1
+#endif
+
 struct dma_pool {		/* the pool */
 	struct list_head page_list;
 	spinlock_t lock;
@@ -216,7 +220,7 @@ static struct dma_page *pool_alloc_page(
 	page->vaddr = dma_alloc_coherent(pool->dev, pool->allocation,
 					 &page->dma, mem_flags);
 	if (page->vaddr) {
-#ifdef	CONFIG_DEBUG_SLAB
+#ifdef	DMAPOOL_DEBUG
 		memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
 		pool_initialise_page(pool, page);
@@ -239,7 +243,7 @@ static void pool_free_page(struct dma_po
 {
 	dma_addr_t dma = page->dma;
 
-#ifdef	CONFIG_DEBUG_SLAB
+#ifdef	DMAPOOL_DEBUG
 	memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
 	dma_free_coherent(pool->dev, pool->allocation, page->vaddr, dma);
@@ -336,7 +340,7 @@ void *dma_pool_alloc(struct dma_pool *po
 	page->offset = *(int *)(page->vaddr + offset);
 	retval = offset + page->vaddr;
 	*handle = offset + page->dma;
-#ifdef	CONFIG_DEBUG_SLAB
+#ifdef	DMAPOOL_DEBUG
 	memset(retval, POOL_POISON_ALLOCATED, pool->size);
 #endif
  done:
@@ -391,7 +395,7 @@ void dma_pool_free(struct dma_pool *pool
 	}
 
 	offset = vaddr - page->vaddr;
-#ifdef	CONFIG_DEBUG_SLAB
+#ifdef	DMAPOOL_DEBUG
 	if ((dma - page->dma) != offset) {
 		if (pool->dev)
 			dev_err(pool->dev,
