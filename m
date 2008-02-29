Return-Path: <linux-kernel-owner+w=401wt.eu-S933888AbYB2WHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888AbYB2WHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761379AbYB2WHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:07:05 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:25568 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753AbYB2WHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:07:03 -0500
X-IronPort-AV: E=Sophos;i="4.25,429,1199692800"; 
   d="scan'208";a="7661766"
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 29 Feb 2008 14:06:55 -0800
Message-ID: <adaod9zto1s.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Feb 2008 22:06:55.0936 (UTC) FILETIME=[65A1BC00:01C87B1F]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get some more small post-2.6.25-rc3 fixes:

Arthur Jones (1):
      MAINTAINERS: update ipath owner

Jon Mason (1):
      RDMA/cxgb3: Return correct max_inline_data when creating a QP

Pete Wyckoff (2):
      Revert "IB/fmr_pool: ib_fmr_pool_flush() should flush all dirty FMRs"
      IB/fmr_pool: Flush all dirty FMRs from ib_fmr_pool_flush()

Sean Hefty (1):
      IB/cm: Flush workqueue when removing device

 MAINTAINERS                                 |    2 +-
 drivers/infiniband/core/cm.c                |    3 +-
 drivers/infiniband/core/fmr_pool.c          |   38 +++++++++++++++-----------
 drivers/infiniband/hw/cxgb3/iwch_provider.c |    3 ++
 4 files changed, 28 insertions(+), 18 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index fed09b5..f229e16 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2143,7 +2143,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 
 IPATH DRIVER:
-P:	Arthur Jones
+P:	Ralph Campbell
 M:	infinipath@qlogic.com
 L:	general@lists.openfabrics.org
 T:	git git://git.qlogic.com/ipath-linux-2.6
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index b10ade9..4df4051 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3759,6 +3759,7 @@ static void cm_remove_one(struct ib_device *device)
 		port = cm_dev->port[i-1];
 		ib_modify_port(device, port->port_num, 0, &port_modify);
 		ib_unregister_mad_agent(port->mad_agent);
+		flush_workqueue(cm.wq);
 		cm_remove_port_fs(port);
 	}
 	kobject_put(&cm_dev->dev_obj);
@@ -3813,6 +3814,7 @@ static void __exit ib_cm_cleanup(void)
 		cancel_delayed_work(&timewait_info->work.work);
 	spin_unlock_irq(&cm.lock);
 
+	ib_unregister_client(&cm_client);
 	destroy_workqueue(cm.wq);
 
 	list_for_each_entry_safe(timewait_info, tmp, &cm.timewait_list, list) {
@@ -3820,7 +3822,6 @@ static void __exit ib_cm_cleanup(void)
 		kfree(timewait_info);
 	}
 
-	ib_unregister_client(&cm_client);
 	class_unregister(&cm_class);
 	idr_destroy(&cm.local_id_table);
 }
diff --git a/drivers/infiniband/core/fmr_pool.c b/drivers/infiniband/core/fmr_pool.c
index 7f00347..06d502c 100644
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
@@ -407,8 +398,23 @@ EXPORT_SYMBOL(ib_destroy_fmr_pool);
  */
 int ib_flush_fmr_pool(struct ib_fmr_pool *pool)
 {
-	int serial = atomic_inc_return(&pool->req_ser);
+	int serial;
+	struct ib_pool_fmr *fmr, *next;
+
+	/*
+	 * The free_list holds FMRs that may have been used
+	 * but have not been remapped enough times to be dirty.
+	 * Put them on the dirty list now so that the cleanup
+	 * thread will reap them too.
+	 */
+	spin_lock_irq(&pool->pool_lock);
+	list_for_each_entry_safe(fmr, next, &pool->free_list, list) {
+		if (fmr->remap_count > 0)
+			list_move(&fmr->list, &pool->dirty_list);
+	}
+	spin_unlock_irq(&pool->pool_lock);
 
+	serial = atomic_inc_return(&pool->req_ser);
 	wake_up_process(pool->thread);
 
 	if (wait_event_interruptible(pool->force_wait,
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index df1838f..ee3d63c 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -819,8 +819,11 @@ static struct ib_qp *iwch_create_qp(struct ib_pd *pd,
 		kfree(qhp);
 		return ERR_PTR(-ENOMEM);
 	}
+
 	attrs->cap.max_recv_wr = rqsize - 1;
 	attrs->cap.max_send_wr = sqsize;
+	attrs->cap.max_inline_data = T3_MAX_INLINE;
+
 	qhp->rhp = rhp;
 	qhp->attr.pd = php->pdid;
 	qhp->attr.scq = ((struct iwch_cq *) attrs->send_cq)->cq.cqid;
