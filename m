Return-Path: <linux-kernel-owner+w=401wt.eu-S1764291AbYBZS1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764291AbYBZS1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760383AbYBZS1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:27:32 -0500
Received: from quasar.osc.edu ([192.148.249.15]:50040 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758951AbYBZS1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:27:31 -0500
Date: Tue, 26 Feb 2008 13:27:31 -0500
From: Pete Wyckoff <pw@osc.edu>
To: Roland Dreier <rdreier@cisco.com>
Cc: Olaf Kirch <olaf.kirch@oracle.com>, general@lists.openfabrics.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Revert "IB/fmr_pool: ib_fmr_pool_flush() should flush
	all dirty FMRs"
Message-ID: <20080226182731.GE7033@osc.edu>
References: <20080225225330.GA3316@osc.edu> <ada1w70zlkf.fsf@cisco.com> <20080226182655.GD7033@osc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226182655.GD7033@osc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit a3cd7d9070be417a21905c997ee32d756d999b38.

The original commit breaks iSER reliably, making it complain:

    iser: iser_reg_page_vec:ib_fmr_pool_map_phys failed: -11

The FMR cleanup thread runs ib_fmr_batch_release() as dirty
entries build up.  This commit causes clean but used FMR
entries also to be purged.  During that process, another thread
can see that there are no free FMRs and fail, even though
there should always have been enough available.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 drivers/infiniband/core/fmr_pool.c |   21 ++++++---------------
 1 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/fmr_pool.c b/drivers/infiniband/core/fmr_pool.c
index 7f00347..4044fdf 100644
--- a/drivers/infiniband/core/fmr_pool.c
+++ b/drivers/infiniband/core/fmr_pool.c
@@ -139,7 +139,7 @@ static inline struct ib_pool_fmr *ib_fmr_cache_lookup(struct ib_fmr_pool *pool,
 static void ib_fmr_batch_release(struct ib_fmr_pool *pool)
 {
 	int                 ret;
-	struct ib_pool_fmr *fmr, *next;
+	struct ib_pool_fmr *fmr;
 	LIST_HEAD(unmap_list);
 	LIST_HEAD(fmr_list);
 
@@ -158,20 +158,6 @@ static void ib_fmr_batch_release(struct ib_fmr_pool *pool)
 #endif
 	}
 
-	/*
-	 * The free_list may hold FMRs that have been put there
-	 * because they haven't reached the max_remap count.
-	 * Invalidate their mapping as well.
-	 */
-	list_for_each_entry_safe(fmr, next, &pool->free_list, list) {
-		if (fmr->remap_count == 0)
-			continue;
-		hlist_del_init(&fmr->cache_node);
-		fmr->remap_count = 0;
-		list_add_tail(&fmr->fmr->list, &fmr_list);
-		list_move(&fmr->list, &unmap_list);
-	}
-
 	list_splice(&pool->dirty_list, &unmap_list);
 	INIT_LIST_HEAD(&pool->dirty_list);
 	pool->dirty_len = 0;
@@ -384,6 +370,11 @@ void ib_destroy_fmr_pool(struct ib_fmr_pool *pool)
 
 	i = 0;
 	list_for_each_entry_safe(fmr, tmp, &pool->free_list, list) {
+		if (fmr->remap_count) {
+			INIT_LIST_HEAD(&fmr_list);
+			list_add_tail(&fmr->fmr->list, &fmr_list);
+			ib_unmap_fmr(&fmr_list);
+		}
 		ib_dealloc_fmr(fmr->fmr);
 		list_del(&fmr->list);
 		kfree(fmr);
-- 
1.5.4.1

