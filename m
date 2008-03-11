Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbYCKEdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbYCKEdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYCKEd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:33:26 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:29443 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYCKEdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:33:24 -0400
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 10 Mar 2008 21:33:11 -0700
Message-ID: <ada8x0pnam0.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Mar 2008 04:33:18.0448 (UTC) FILETIME=[079DD700:01C88331]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get some more small post-2.6.25-rc5 fixes:

Arne Redlich (2):
      IB/iser: Fix list iteration bug
      IB/iser: Handle iser_device allocation error gracefully

Arthur Jones (1):
      MAINTAINERS: update ipath owner

Jon Mason (2):
      RDMA/cxgb3: Return correct max_inline_data when creating a QP
      RDMA/cxgb3: Fix iwch_create_cq() off-by-one error

Pete Wyckoff (2):
      Revert "IB/fmr_pool: ib_fmr_pool_flush() should flush all dirty FMRs"
      IB/fmr_pool: Flush all dirty FMRs from ib_fmr_pool_flush()

Sean Hefty (1):
      IB/cm: Flush workqueue when removing device

Steve Wise (1):
      RDMA/iwcm: Don't access a cm_id after dropping reference

 MAINTAINERS                                 |    2 +-
 drivers/infiniband/core/cm.c                |    3 +-
 drivers/infiniband/core/fmr_pool.c          |   38 ++++++++++++---------
 drivers/infiniband/core/iwcm.c              |    5 ++-
 drivers/infiniband/hw/cxgb3/iwch_provider.c |    5 ++-
 drivers/infiniband/ulp/iser/iser_verbs.c    |   47 ++++++++++++++-------------
 6 files changed, 56 insertions(+), 44 deletions(-)


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
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 223b1aa..81c9195 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -839,6 +839,7 @@ static void cm_work_handler(struct work_struct *_work)
 	unsigned long flags;
 	int empty;
 	int ret = 0;
+	int destroy_id;
 
 	spin_lock_irqsave(&cm_id_priv->lock, flags);
 	empty = list_empty(&cm_id_priv->work_list);
@@ -857,9 +858,9 @@ static void cm_work_handler(struct work_struct *_work)
 			destroy_cm_id(&cm_id_priv->id);
 		}
 		BUG_ON(atomic_read(&cm_id_priv->refcount)==0);
+		destroy_id = test_bit(IWCM_F_CALLBACK_DESTROY, &cm_id_priv->flags);
 		if (iwcm_deref_id(cm_id_priv)) {
-			if (test_bit(IWCM_F_CALLBACK_DESTROY,
-				     &cm_id_priv->flags)) {
+			if (destroy_id) {
 				BUG_ON(!list_empty(&cm_id_priv->work_list));
 				free_cm_id(cm_id_priv);
 			}
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index df1838f..b2ea921 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -189,7 +189,7 @@ static struct ib_cq *iwch_create_cq(struct ib_device *ibdev, int entries, int ve
 		return ERR_PTR(-ENOMEM);
 	}
 	chp->rhp = rhp;
-	chp->ibcq.cqe = (1 << chp->cq.size_log2) - 1;
+	chp->ibcq.cqe = 1 << chp->cq.size_log2;
 	spin_lock_init(&chp->lock);
 	atomic_set(&chp->refcnt, 1);
 	init_waitqueue_head(&chp->wait);
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
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 714b8db..993f0a8 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -237,36 +237,32 @@ static int iser_free_ib_conn_res(struct iser_conn *ib_conn)
 static
 struct iser_device *iser_device_find_by_ib_device(struct rdma_cm_id *cma_id)
 {
-	struct list_head    *p_list;
-	struct iser_device  *device = NULL;
+	struct iser_device *device;
 
 	mutex_lock(&ig.device_list_mutex);
 
-	p_list = ig.device_list.next;
-	while (p_list != &ig.device_list) {
-		device = list_entry(p_list, struct iser_device, ig_list);
+	list_for_each_entry(device, &ig.device_list, ig_list)
 		/* find if there's a match using the node GUID */
 		if (device->ib_device->node_guid == cma_id->device->node_guid)
-			break;
-	}
+			goto inc_refcnt;
 
-	if (device == NULL) {
-		device = kzalloc(sizeof *device, GFP_KERNEL);
-		if (device == NULL)
-			goto out;
-		/* assign this device to the device */
-		device->ib_device = cma_id->device;
-		/* init the device and link it into ig device list */
-		if (iser_create_device_ib_res(device)) {
-			kfree(device);
-			device = NULL;
-			goto out;
-		}
-		list_add(&device->ig_list, &ig.device_list);
+	device = kzalloc(sizeof *device, GFP_KERNEL);
+	if (device == NULL)
+		goto out;
+
+	/* assign this device to the device */
+	device->ib_device = cma_id->device;
+	/* init the device and link it into ig device list */
+	if (iser_create_device_ib_res(device)) {
+		kfree(device);
+		device = NULL;
+		goto out;
 	}
-out:
-	BUG_ON(device == NULL);
+	list_add(&device->ig_list, &ig.device_list);
+
+inc_refcnt:
 	device->refcount++;
+out:
 	mutex_unlock(&ig.device_list_mutex);
 	return device;
 }
@@ -372,6 +368,12 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
 	int    ret;
 
 	device = iser_device_find_by_ib_device(cma_id);
+	if (!device) {
+		iser_err("device lookup/creation failed\n");
+		iser_connect_error(cma_id);
+		return;
+	}
+
 	ib_conn = (struct iser_conn *)cma_id->context;
 	ib_conn->device = device;
 
@@ -380,7 +382,6 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
 		iser_err("resolve route failed: %d\n", ret);
 		iser_connect_error(cma_id);
 	}
-	return;
 }
 
 static void iser_route_handler(struct rdma_cm_id *cma_id)
