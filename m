Return-Path: <linux-kernel-owner+w=401wt.eu-S1764029AbYCGJXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764029AbYCGJXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763575AbYCGJNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:13:34 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:48552 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762389AbYCGJN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:13:29 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200803071013.837692778@firstfloor.org>
In-Reply-To: <200803071013.837692778@firstfloor.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/7] Convert the blk allocator functions over to the mask allocator
Message-Id: <20080307091326.0AC3A1B419C@basil.firstfloor.org>
Date: Fri,  7 Mar 2008 10:13:26 +0100 (CET)
X-OriginalArrivalTime: 07 Mar 2008 09:06:55.0736 (UTC) FILETIME=[976E2F80:01C88032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a separate patch because the block allocator functions are 
only getting introduced by my earlier SCSI DMA cleanup patch kit.
This means this patch alone relies on them. Without that patchkit
applied earlier it can be safely dropped.

Right now blk_kmalloc rounds up to pages. There are only a few callers
so adding a sub allocator for that doesn't seem worthwhile.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 block/blk-settings.c   |    7 +++++--
 include/linux/blkdev.h |    4 ++--
 2 files changed, 7 insertions(+), 4 deletions(-)

Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h
+++ linux/include/linux/blkdev.h
@@ -560,12 +560,12 @@ extern struct page *blk_alloc_pages(stru
 extern void *blk_kmalloc(struct request_queue *q, unsigned size, gfp_t gfp);
 static inline void blk_free_pages(struct page *p, int size)
 {
-	__free_pages(p, get_order(size));
+	__free_pages_mask(p, size);
 }
 
 static inline void blk_kfree(void *p, int size)
 {
-	kfree(p);
+	free_pages_mask(p, size);
 }
 
 struct req_iterator {
Index: linux/block/blk-settings.c
===================================================================
--- linux.orig/block/blk-settings.c
+++ linux/block/blk-settings.c
@@ -159,13 +159,16 @@ EXPORT_SYMBOL(blk_queue_bounce_limit);
 struct page *blk_alloc_pages(struct request_queue *q,
 				   gfp_t gfp, int size)
 {
-	return alloc_pages((q->bounce_gfp & ~GFP_NOIO) | gfp, get_order(size));
+	return alloc_pages_mask(gfp, size, blk_q_mask(q));
 }
 EXPORT_SYMBOL(blk_alloc_pages);
 
 void *blk_kmalloc(struct request_queue *q, unsigned size, gfp_t gfp)
 {
-	return kmalloc(size, gfp | (q->bounce_gfp & ~GFP_NOIO));
+	/* Right now gets pages. That is ok for the few callers. Later
+	 * might need to use a sub allocator.
+	 */
+	return get_pages_mask(gfp, size, blk_q_mask(q));
 }
 EXPORT_SYMBOL(blk_kmalloc);
 
