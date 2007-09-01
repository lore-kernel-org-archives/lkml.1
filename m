Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbXIABsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbXIABsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 21:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXIABnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 21:43:31 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46122 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751701AbXIABmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 21:42:24 -0400
Message-Id: <20070901014222.762921292@sgi.com>
References: <20070901014107.719506437@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 31 Aug 2007 18:41:22 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: David Chinner <dgc@sgi.com>
Subject: [RFC 15/26] bufferhead: Revert constructor removal
Content-Disposition: inline; filename=0015-slab_defrag_buffer_head_revert.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The constructor for buffer_head slabs was removed recently. We need
the constructor in order to insure that slab objects always have a definite
state even before we allocated them.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/buffer.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 0e5ec37..f4824d1 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2960,9 +2960,8 @@ static void recalc_bh_state(void)
 	
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
 {
-	struct buffer_head *ret = kmem_cache_zalloc(bh_cachep, gfp_flags);
+	struct buffer_head *ret = kmem_cache_alloc(bh_cachep, gfp_flags);
 	if (ret) {
-		INIT_LIST_HEAD(&ret->b_assoc_buffers);
 		get_cpu_var(bh_accounting).nr++;
 		recalc_bh_state();
 		put_cpu_var(bh_accounting);
@@ -3003,12 +3002,24 @@ static int buffer_cpu_notify(struct notifier_block *self,
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
1.5.2.4

-- 
