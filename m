Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbXKGBNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbXKGBNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 20:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbXKGBMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 20:12:31 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33726 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755131AbXKGBM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 20:12:28 -0500
Message-Id: <20071107011227.071157941@sgi.com>
References: <20071107011130.382244340@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 17:11:33 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundatin.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Mel Gorman <mel@skynet.ie>
Subject: [patch 03/23] bufferhead: Revert constructor removal
Content-Disposition: inline; filename=0015-slab_defrag_buffer_head_revert.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The constructor for buffer_head slabs was removed recently. We need
the constructor in order to insure that slab objects always have a definite
state even before we allocated them.

[This patch is already in mm]

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/buffer.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c	2007-10-25 18:28:40.000000000 -0700
+++ linux-2.6/fs/buffer.c	2007-11-06 12:55:45.000000000 -0800
@@ -3169,10 +3169,9 @@ static void recalc_bh_state(void)
 	
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
 {
-	struct buffer_head *ret = kmem_cache_zalloc(bh_cachep,
+	struct buffer_head *ret = kmem_cache_alloc(bh_cachep,
 				set_migrateflags(gfp_flags, __GFP_RECLAIMABLE));
 	if (ret) {
-		INIT_LIST_HEAD(&ret->b_assoc_buffers);
 		get_cpu_var(bh_accounting).nr++;
 		recalc_bh_state();
 		put_cpu_var(bh_accounting);
@@ -3213,12 +3212,24 @@ static int buffer_cpu_notify(struct noti
 	return NOTIFY_OK;
 }
 
+static void
+init_buffer_head(void *data, struct kmem_cache *cachep, unsigned long flags)
+{
+	struct buffer_head * bh = (struct buffer_head *)data;
+
+	memset(bh, 0, sizeof(*bh));
+	INIT_LIST_HEAD(&bh->b_assoc_buffers);
+}
+
 void __init buffer_init(void)
 {
 	int nrpages;
 
-	bh_cachep = KMEM_CACHE(buffer_head,
-			SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
+	bh_cachep = kmem_cache_create("buffer_head",
+			sizeof(struct buffer_head), 0,
+				(SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
+				SLAB_MEM_SPREAD),
+				init_buffer_head);
 
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL

-- 
