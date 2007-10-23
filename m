Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbXJWQaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbXJWQaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbXJWQaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:30:46 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:20063 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbXJWQan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:30:43 -0400
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 23 Oct 2007 09:30:33 -0700
Message-ID: <ada1wbl7pzq.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Oct 2007 16:30:34.0112 (UTC) FILETIME=[090A0800:01C81592]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

this will get some more fixes/changes for 2.6.24.  I have one more
IPoIB feature (support for CM without SRQs) I hope to send later
today, but we'll see...

Anton Blanchard (1):
      IPoIB: Use round_jiffies() for ah_reap_task

Jack Morgenstein (2):
      IB/mlx4: Sanity check userspace send queue sizes
      mlx4_core: Increase command timeout for INIT_HCA to 10 seconds

Joachim Fenkes (5):
      IB/ehca: Supply QP token for SRQ base QPs
      IB/ehca: Fix masking error in {,re}reg_phys_mr()
      IB/ehca: Fix ehca_encode_hwpage_size() and alloc_fmr()
      IB/ehca: Change meaning of hca_cap_mr_pgsize
      IB/ehca: Enable large page MRs by default

Michael S. Tsirkin (1):
      IPoIB/cm: Use common CQ for CM send completions

Roland Dreier (4):
      mlx4_core: Kill mlx4_write64_raw()
      IB/mthca: Avoid alignment traps when writing doorbells
      IPoIB: Rewrite "if (!likely(...))" as "if (unlikely(!(...)))"
      IB/uverbs: Fix checking of userspace object ownership

Sean Hefty (2):
      RDMA/cma: Add locking around QP accesses
      RDMA/cma: Fix deadlock destroying listen requests

 drivers/infiniband/core/cma.c                |  160 +++++++++++++------------
 drivers/infiniband/core/uverbs_cmd.c         |    8 +-
 drivers/infiniband/hw/ehca/ehca_classes.h    |    1 -
 drivers/infiniband/hw/ehca/ehca_hca.c        |    1 +
 drivers/infiniband/hw/ehca/ehca_main.c       |   20 +++-
 drivers/infiniband/hw/ehca/ehca_mrmw.c       |   57 ++++-----
 drivers/infiniband/hw/ehca/ehca_qp.c         |    4 +-
 drivers/infiniband/hw/mlx4/qp.c              |   16 +++-
 drivers/infiniband/hw/mthca/mthca_cq.c       |   53 +++------
 drivers/infiniband/hw/mthca/mthca_doorbell.h |   13 ++-
 drivers/infiniband/hw/mthca/mthca_eq.c       |   21 +---
 drivers/infiniband/hw/mthca/mthca_qp.c       |   45 +++-----
 drivers/infiniband/hw/mthca/mthca_srq.c      |   11 +--
 drivers/infiniband/ulp/ipoib/ipoib.h         |   15 ++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c      |  114 ++++++++-----------
 drivers/infiniband/ulp/ipoib/ipoib_ib.c      |   52 +++++----
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |    4 +-
 drivers/net/mlx4/fw.c                        |    2 +-
 include/linux/mlx4/doorbell.h                |   11 --
 19 files changed, 284 insertions(+), 324 deletions(-)


diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 93644f8..ee946cc 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -114,13 +114,16 @@ struct rdma_id_private {
 
 	struct rdma_bind_list	*bind_list;
 	struct hlist_node	node;
-	struct list_head	list;
-	struct list_head	listen_list;
+	struct list_head	list; /* listen_any_list or cma_device.list */
+	struct list_head	listen_list; /* per device listens */
 	struct cma_device	*cma_dev;
 	struct list_head	mc_list;
 
+	int			internal_id;
 	enum cma_state		state;
 	spinlock_t		lock;
+	struct mutex		qp_mutex;
+
 	struct completion	comp;
 	atomic_t		refcount;
 	wait_queue_head_t	wait_remove;
@@ -389,6 +392,7 @@ struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
 	id_priv->id.event_handler = event_handler;
 	id_priv->id.ps = ps;
 	spin_lock_init(&id_priv->lock);
+	mutex_init(&id_priv->qp_mutex);
 	init_completion(&id_priv->comp);
 	atomic_set(&id_priv->refcount, 1);
 	init_waitqueue_head(&id_priv->wait_remove);
@@ -474,61 +478,86 @@ EXPORT_SYMBOL(rdma_create_qp);
 
 void rdma_destroy_qp(struct rdma_cm_id *id)
 {
-	ib_destroy_qp(id->qp);
+	struct rdma_id_private *id_priv;
+
+	id_priv = container_of(id, struct rdma_id_private, id);
+	mutex_lock(&id_priv->qp_mutex);
+	ib_destroy_qp(id_priv->id.qp);
+	id_priv->id.qp = NULL;
+	mutex_unlock(&id_priv->qp_mutex);
 }
 EXPORT_SYMBOL(rdma_destroy_qp);
 
-static int cma_modify_qp_rtr(struct rdma_cm_id *id)
+static int cma_modify_qp_rtr(struct rdma_id_private *id_priv)
 {
 	struct ib_qp_attr qp_attr;
 	int qp_attr_mask, ret;
 
-	if (!id->qp)
-		return 0;
+	mutex_lock(&id_priv->qp_mutex);
+	if (!id_priv->id.qp) {
+		ret = 0;
+		goto out;
+	}
 
 	/* Need to update QP attributes from default values. */
 	qp_attr.qp_state = IB_QPS_INIT;
-	ret = rdma_init_qp_attr(id, &qp_attr, &qp_attr_mask);
+	ret = rdma_init_qp_attr(&id_priv->id, &qp_attr, &qp_attr_mask);
 	if (ret)
-		return ret;
+		goto out;
 
-	ret = ib_modify_qp(id->qp, &qp_attr, qp_attr_mask);
+	ret = ib_modify_qp(id_priv->id.qp, &qp_attr, qp_attr_mask);
 	if (ret)
-		return ret;
+		goto out;
 
 	qp_attr.qp_state = IB_QPS_RTR;
-	ret = rdma_init_qp_attr(id, &qp_attr, &qp_attr_mask);
+	ret = rdma_init_qp_attr(&id_priv->id, &qp_attr, &qp_attr_mask);
 	if (ret)
-		return ret;
+		goto out;
 
-	return ib_modify_qp(id->qp, &qp_attr, qp_attr_mask);
+	ret = ib_modify_qp(id_priv->id.qp, &qp_attr, qp_attr_mask);
+out:
+	mutex_unlock(&id_priv->qp_mutex);
+	return ret;
 }
 
-static int cma_modify_qp_rts(struct rdma_cm_id *id)
+static int cma_modify_qp_rts(struct rdma_id_private *id_priv)
 {
 	struct ib_qp_attr qp_attr;
 	int qp_attr_mask, ret;
 
-	if (!id->qp)
-		return 0;
+	mutex_lock(&id_priv->qp_mutex);
+	if (!id_priv->id.qp) {
+		ret = 0;
+		goto out;
+	}
 
 	qp_attr.qp_state = IB_QPS_RTS;
-	ret = rdma_init_qp_attr(id, &qp_attr, &qp_attr_mask);
+	ret = rdma_init_qp_attr(&id_priv->id, &qp_attr, &qp_attr_mask);
 	if (ret)
-		return ret;
+		goto out;
 
-	return ib_modify_qp(id->qp, &qp_attr, qp_attr_mask);
+	ret = ib_modify_qp(id_priv->id.qp, &qp_attr, qp_attr_mask);
+out:
+	mutex_unlock(&id_priv->qp_mutex);
+	return ret;
 }
 
-static int cma_modify_qp_err(struct rdma_cm_id *id)
+static int cma_modify_qp_err(struct rdma_id_private *id_priv)
 {
 	struct ib_qp_attr qp_attr;
+	int ret;
 
-	if (!id->qp)
-		return 0;
+	mutex_lock(&id_priv->qp_mutex);
+	if (!id_priv->id.qp) {
+		ret = 0;
+		goto out;
+	}
 
 	qp_attr.qp_state = IB_QPS_ERR;
-	return ib_modify_qp(id->qp, &qp_attr, IB_QP_STATE);
+	ret = ib_modify_qp(id_priv->id.qp, &qp_attr, IB_QP_STATE);
+out:
+	mutex_unlock(&id_priv->qp_mutex);
+	return ret;
 }
 
 static int cma_ib_init_qp_attr(struct rdma_id_private *id_priv,
@@ -717,50 +746,27 @@ static void cma_cancel_route(struct rdma_id_private *id_priv)
 	}
 }
 
-static inline int cma_internal_listen(struct rdma_id_private *id_priv)
-{
-	return (id_priv->state == CMA_LISTEN) && id_priv->cma_dev &&
-	       cma_any_addr(&id_priv->id.route.addr.src_addr);
-}
-
-static void cma_destroy_listen(struct rdma_id_private *id_priv)
-{
-	cma_exch(id_priv, CMA_DESTROYING);
-
-	if (id_priv->cma_dev) {
-		switch (rdma_node_get_transport(id_priv->id.device->node_type)) {
-		case RDMA_TRANSPORT_IB:
-			if (id_priv->cm_id.ib && !IS_ERR(id_priv->cm_id.ib))
-				ib_destroy_cm_id(id_priv->cm_id.ib);
-			break;
-		case RDMA_TRANSPORT_IWARP:
-			if (id_priv->cm_id.iw && !IS_ERR(id_priv->cm_id.iw))
-				iw_destroy_cm_id(id_priv->cm_id.iw);
-			break;
-		default:
-			break;
-		}
-		cma_detach_from_dev(id_priv);
-	}
-	list_del(&id_priv->listen_list);
-
-	cma_deref_id(id_priv);
-	wait_for_completion(&id_priv->comp);
-
-	kfree(id_priv);
-}
-
 static void cma_cancel_listens(struct rdma_id_private *id_priv)
 {
 	struct rdma_id_private *dev_id_priv;
 
+	/*
+	 * Remove from listen_any_list to prevent added devices from spawning
+	 * additional listen requests.
+	 */
 	mutex_lock(&lock);
 	list_del(&id_priv->list);
 
 	while (!list_empty(&id_priv->listen_list)) {
 		dev_id_priv = list_entry(id_priv->listen_list.next,
 					 struct rdma_id_private, listen_list);
-		cma_destroy_listen(dev_id_priv);
+		/* sync with device removal to avoid duplicate destruction */
+		list_del_init(&dev_id_priv->list);
+		list_del(&dev_id_priv->listen_list);
+		mutex_unlock(&lock);
+
+		rdma_destroy_id(&dev_id_priv->id);
+		mutex_lock(&lock);
 	}
 	mutex_unlock(&lock);
 }
@@ -848,6 +854,9 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 	cma_deref_id(id_priv);
 	wait_for_completion(&id_priv->comp);
 
+	if (id_priv->internal_id)
+		cma_deref_id(id_priv->id.context);
+
 	kfree(id_priv->id.route.path_rec);
 	kfree(id_priv);
 }
@@ -857,11 +866,11 @@ static int cma_rep_recv(struct rdma_id_private *id_priv)
 {
 	int ret;
 
-	ret = cma_modify_qp_rtr(&id_priv->id);
+	ret = cma_modify_qp_rtr(id_priv);
 	if (ret)
 		goto reject;
 
-	ret = cma_modify_qp_rts(&id_priv->id);
+	ret = cma_modify_qp_rts(id_priv);
 	if (ret)
 		goto reject;
 
@@ -871,7 +880,7 @@ static int cma_rep_recv(struct rdma_id_private *id_priv)
 
 	return 0;
 reject:
-	cma_modify_qp_err(&id_priv->id);
+	cma_modify_qp_err(id_priv);
 	ib_send_cm_rej(id_priv->cm_id.ib, IB_CM_REJ_CONSUMER_DEFINED,
 		       NULL, 0, NULL, 0);
 	return ret;
@@ -947,7 +956,7 @@ static int cma_ib_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 		/* ignore event */
 		goto out;
 	case IB_CM_REJ_RECEIVED:
-		cma_modify_qp_err(&id_priv->id);
+		cma_modify_qp_err(id_priv);
 		event.status = ib_event->param.rej_rcvd.reason;
 		event.event = RDMA_CM_EVENT_REJECTED;
 		event.param.conn.private_data = ib_event->private_data;
@@ -1404,14 +1413,13 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
 
 	cma_attach_to_dev(dev_id_priv, cma_dev);
 	list_add_tail(&dev_id_priv->listen_list, &id_priv->listen_list);
+	atomic_inc(&id_priv->refcount);
+	dev_id_priv->internal_id = 1;
 
 	ret = rdma_listen(id, id_priv->backlog);
 	if (ret)
-		goto err;
-
-	return;
-err:
-	cma_destroy_listen(dev_id_priv);
+		printk(KERN_WARNING "RDMA CMA: cma_listen_on_dev, error %d, "
+		       "listening on device %s", ret, cma_dev->device->name);
 }
 
 static void cma_listen_on_all(struct rdma_id_private *id_priv)
@@ -2264,7 +2272,7 @@ static int cma_connect_iw(struct rdma_id_private *id_priv,
 	sin = (struct sockaddr_in*) &id_priv->id.route.addr.dst_addr;
 	cm_id->remote_addr = *sin;
 
-	ret = cma_modify_qp_rtr(&id_priv->id);
+	ret = cma_modify_qp_rtr(id_priv);
 	if (ret)
 		goto out;
 
@@ -2331,7 +2339,7 @@ static int cma_accept_ib(struct rdma_id_private *id_priv,
 	int qp_attr_mask, ret;
 
 	if (id_priv->id.qp) {
-		ret = cma_modify_qp_rtr(&id_priv->id);
+		ret = cma_modify_qp_rtr(id_priv);
 		if (ret)
 			goto out;
 
@@ -2370,7 +2378,7 @@ static int cma_accept_iw(struct rdma_id_private *id_priv,
 	struct iw_cm_conn_param iw_param;
 	int ret;
 
-	ret = cma_modify_qp_rtr(&id_priv->id);
+	ret = cma_modify_qp_rtr(id_priv);
 	if (ret)
 		return ret;
 
@@ -2442,7 +2450,7 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 
 	return 0;
 reject:
-	cma_modify_qp_err(id);
+	cma_modify_qp_err(id_priv);
 	rdma_reject(id, NULL, 0);
 	return ret;
 }
@@ -2512,7 +2520,7 @@ int rdma_disconnect(struct rdma_cm_id *id)
 
 	switch (rdma_node_get_transport(id->device->node_type)) {
 	case RDMA_TRANSPORT_IB:
-		ret = cma_modify_qp_err(id);
+		ret = cma_modify_qp_err(id_priv);
 		if (ret)
 			goto out;
 		/* Initiate or respond to a disconnect. */
@@ -2543,9 +2551,11 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 	    cma_disable_remove(id_priv, CMA_ADDR_RESOLVED))
 		return 0;
 
+	mutex_lock(&id_priv->qp_mutex);
 	if (!status && id_priv->id.qp)
 		status = ib_attach_mcast(id_priv->id.qp, &multicast->rec.mgid,
 					 multicast->rec.mlid);
+	mutex_unlock(&id_priv->qp_mutex);
 
 	memset(&event, 0, sizeof event);
 	event.status = status;
@@ -2757,16 +2767,12 @@ static void cma_process_remove(struct cma_device *cma_dev)
 		id_priv = list_entry(cma_dev->id_list.next,
 				     struct rdma_id_private, list);
 
-		if (cma_internal_listen(id_priv)) {
-			cma_destroy_listen(id_priv);
-			continue;
-		}
-
+		list_del(&id_priv->listen_list);
 		list_del_init(&id_priv->list);
 		atomic_inc(&id_priv->refcount);
 		mutex_unlock(&lock);
 
-		ret = cma_remove_id_dev(id_priv);
+		ret = id_priv->internal_id ? 1 : cma_remove_id_dev(id_priv);
 		cma_deref_id(id_priv);
 		if (ret)
 			rdma_destroy_id(&id_priv->id);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 01d7008..495c803 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -147,8 +147,12 @@ static struct ib_uobject *__idr_get_uobj(struct idr *idr, int id,
 
 	spin_lock(&ib_uverbs_idr_lock);
 	uobj = idr_find(idr, id);
-	if (uobj)
-		kref_get(&uobj->ref);
+	if (uobj) {
+		if (uobj->context == context)
+			kref_get(&uobj->ref);
+		else
+			uobj = NULL;
+	}
 	spin_unlock(&ib_uverbs_idr_lock);
 
 	return uobj;
diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 0f7a55d..365bc5d 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -323,7 +323,6 @@ extern int ehca_static_rate;
 extern int ehca_port_act_time;
 extern int ehca_use_hp_mr;
 extern int ehca_scaling_code;
-extern int ehca_mr_largepage;
 
 struct ipzu_queue_resp {
 	u32 qe_size;      /* queue entry size */
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index 4aa3ffa..15806d1 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -77,6 +77,7 @@ int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
 	}
 
 	memset(props, 0, sizeof(struct ib_device_attr));
+	props->page_size_cap   = shca->hca_cap_mr_pgsize;
 	props->fw_ver          = rblock->hw_ver;
 	props->max_mr_size     = rblock->max_mr_size;
 	props->vendor_id       = rblock->vendor_id >> 8;
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 403467f..2f51c13 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -65,7 +65,7 @@ int ehca_port_act_time = 30;
 int ehca_poll_all_eqs  = 1;
 int ehca_static_rate   = -1;
 int ehca_scaling_code  = 0;
-int ehca_mr_largepage  = 0;
+int ehca_mr_largepage  = 1;
 
 module_param_named(open_aqp1,     ehca_open_aqp1,     int, S_IRUGO);
 module_param_named(debug_level,   ehca_debug_level,   int, S_IRUGO);
@@ -260,13 +260,20 @@ static struct cap_descr {
 	{ HCA_CAP_MINI_QP, "HCA_CAP_MINI_QP" },
 };
 
-int ehca_sense_attributes(struct ehca_shca *shca)
+static int ehca_sense_attributes(struct ehca_shca *shca)
 {
 	int i, ret = 0;
 	u64 h_ret;
 	struct hipz_query_hca *rblock;
 	struct hipz_query_port *port;
 
+	static const u32 pgsize_map[] = {
+		HCA_CAP_MR_PGSIZE_4K,  0x1000,
+		HCA_CAP_MR_PGSIZE_64K, 0x10000,
+		HCA_CAP_MR_PGSIZE_1M,  0x100000,
+		HCA_CAP_MR_PGSIZE_16M, 0x1000000,
+	};
+
 	rblock = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
 	if (!rblock) {
 		ehca_gen_err("Cannot allocate rblock memory.");
@@ -329,8 +336,15 @@ int ehca_sense_attributes(struct ehca_shca *shca)
 		if (EHCA_BMASK_GET(hca_cap_descr[i].mask, shca->hca_cap))
 			ehca_gen_dbg("   %s", hca_cap_descr[i].descr);
 
-	shca->hca_cap_mr_pgsize = rblock->memory_page_size_supported;
+	/* translate supported MR page sizes; always support 4K */
+	shca->hca_cap_mr_pgsize = EHCA_PAGESIZE;
+	if (ehca_mr_largepage) { /* support extra sizes only if enabled */
+		for (i = 0; i < ARRAY_SIZE(pgsize_map); i += 2)
+			if (rblock->memory_page_size_supported & pgsize_map[i])
+				shca->hca_cap_mr_pgsize |= pgsize_map[i + 1];
+	}
 
+	/* query max MTU from first port -- it's the same for all ports */
 	port = (struct hipz_query_port *)rblock;
 	h_ret = hipz_h_query_port(shca->ipz_hca_handle, 1, port);
 	if (h_ret != H_SUCCESS) {
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index da88738..bb97915 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -72,24 +72,14 @@ enum ehca_mr_pgsize {
 
 static u32 ehca_encode_hwpage_size(u32 pgsize)
 {
-	u32 idx = 0;
-	pgsize >>= 12;
-	/*
-	 * map mr page size into hw code:
-	 * 0, 1, 2, 3 for 4K, 64K, 1M, 64M
-	 */
-	while (!(pgsize & 1)) {
-		idx++;
-		pgsize >>= 4;
-	}
-	return idx;
+	int log = ilog2(pgsize);
+	WARN_ON(log < 12 || log > 24 || log & 3);
+	return (log - 12) / 4;
 }
 
 static u64 ehca_get_max_hwpage_size(struct ehca_shca *shca)
 {
-	if (shca->hca_cap_mr_pgsize & HCA_CAP_MR_PGSIZE_16M)
-		return EHCA_MR_PGSIZE16M;
-	return EHCA_MR_PGSIZE4K;
+	return 1UL << ilog2(shca->hca_cap_mr_pgsize);
 }
 
 static struct ehca_mr *ehca_mr_new(void)
@@ -259,7 +249,7 @@ struct ib_mr *ehca_reg_phys_mr(struct ib_pd *pd,
 		pginfo.u.phy.num_phys_buf = num_phys_buf;
 		pginfo.u.phy.phys_buf_array = phys_buf_array;
 		pginfo.next_hwpage =
-			((u64)iova_start & ~(hw_pgsize - 1)) / hw_pgsize;
+			((u64)iova_start & ~PAGE_MASK) / hw_pgsize;
 
 		ret = ehca_reg_mr(shca, e_mr, iova_start, size, mr_access_flags,
 				  e_pd, &pginfo, &e_mr->ib.ib_mr.lkey,
@@ -296,7 +286,7 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		container_of(pd->device, struct ehca_shca, ib_device);
 	struct ehca_pd *e_pd = container_of(pd, struct ehca_pd, ib_pd);
 	struct ehca_mr_pginfo pginfo;
-	int ret;
+	int ret, page_shift;
 	u32 num_kpages;
 	u32 num_hwpages;
 	u64 hwpage_size;
@@ -351,19 +341,20 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	/* determine number of MR pages */
 	num_kpages = NUM_CHUNKS((virt % PAGE_SIZE) + length, PAGE_SIZE);
 	/* select proper hw_pgsize */
-	if (ehca_mr_largepage &&
-	    (shca->hca_cap_mr_pgsize & HCA_CAP_MR_PGSIZE_16M)) {
-		int page_shift = PAGE_SHIFT;
-		if (e_mr->umem->hugetlb) {
-			/* determine page_shift, clamp between 4K and 16M */
-			page_shift = (fls64(length - 1) + 3) & ~3;
-			page_shift = min(max(page_shift, EHCA_MR_PGSHIFT4K),
-					 EHCA_MR_PGSHIFT16M);
-		}
-		hwpage_size = 1UL << page_shift;
-	} else
-		hwpage_size = EHCA_MR_PGSIZE4K; /* ehca1 only supports 4k */
-	ehca_dbg(pd->device, "hwpage_size=%lx", hwpage_size);
+	page_shift = PAGE_SHIFT;
+	if (e_mr->umem->hugetlb) {
+		/* determine page_shift, clamp between 4K and 16M */
+		page_shift = (fls64(length - 1) + 3) & ~3;
+		page_shift = min(max(page_shift, EHCA_MR_PGSHIFT4K),
+				 EHCA_MR_PGSHIFT16M);
+	}
+	hwpage_size = 1UL << page_shift;
+
+	/* now that we have the desired page size, shift until it's
+	 * supported, too. 4K is always supported, so this terminates.
+	 */
+	while (!(hwpage_size & shca->hca_cap_mr_pgsize))
+		hwpage_size >>= 4;
 
 reg_user_mr_fallback:
 	num_hwpages = NUM_CHUNKS((virt % hwpage_size) + length, hwpage_size);
@@ -547,7 +538,7 @@ int ehca_rereg_phys_mr(struct ib_mr *mr,
 		pginfo.u.phy.num_phys_buf = num_phys_buf;
 		pginfo.u.phy.phys_buf_array = phys_buf_array;
 		pginfo.next_hwpage =
-			((u64)iova_start & ~(hw_pgsize - 1)) / hw_pgsize;
+			((u64)iova_start & ~PAGE_MASK) / hw_pgsize;
 	}
 	if (mr_rereg_mask & IB_MR_REREG_ACCESS)
 		new_acl = mr_access_flags;
@@ -809,8 +800,9 @@ struct ib_fmr *ehca_alloc_fmr(struct ib_pd *pd,
 		ib_fmr = ERR_PTR(-EINVAL);
 		goto alloc_fmr_exit0;
 	}
-	hw_pgsize = ehca_get_max_hwpage_size(shca);
-	if ((1 << fmr_attr->page_shift) != hw_pgsize) {
+
+	hw_pgsize = 1 << fmr_attr->page_shift;
+	if (!(hw_pgsize & shca->hca_cap_mr_pgsize)) {
 		ehca_err(pd->device, "unsupported fmr_attr->page_shift=%x",
 			 fmr_attr->page_shift);
 		ib_fmr = ERR_PTR(-EINVAL);
@@ -826,6 +818,7 @@ struct ib_fmr *ehca_alloc_fmr(struct ib_pd *pd,
 
 	/* register MR on HCA */
 	memset(&pginfo, 0, sizeof(pginfo));
+	pginfo.hwpage_size = hw_pgsize;
 	/*
 	 * pginfo.num_hwpages==0, ie register_rpages() will not be called
 	 * but deferred to map_phys_fmr()
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index e2bd62b..de18264 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -451,7 +451,6 @@ static struct ehca_qp *internal_create_qp(
 		has_srq = 1;
 		parms.ext_type = EQPT_SRQBASE;
 		parms.srq_qpn = my_srq->real_qp_num;
-		parms.srq_token = my_srq->token;
 	}
 
 	if (is_llqp && has_srq) {
@@ -583,6 +582,9 @@ static struct ehca_qp *internal_create_qp(
 		goto create_qp_exit1;
 	}
 
+	if (has_srq)
+		parms.srq_token = my_qp->token;
+
 	parms.servicetype = ibqptype2servicetype(qp_type);
 	if (parms.servicetype < 0) {
 		ret = -EINVAL;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 31a480e..6b33224 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -63,6 +63,10 @@ struct mlx4_ib_sqp {
 	u8			header_buf[MLX4_IB_UD_HEADER_SIZE];
 };
 
+enum {
+	MLX4_IB_MIN_SQ_STRIDE = 6
+};
+
 static const __be32 mlx4_ib_opcode[] = {
 	[IB_WR_SEND]			= __constant_cpu_to_be32(MLX4_OPCODE_SEND),
 	[IB_WR_SEND_WITH_IMM]		= __constant_cpu_to_be32(MLX4_OPCODE_SEND_IMM),
@@ -285,9 +289,17 @@ static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 	return 0;
 }
 
-static int set_user_sq_size(struct mlx4_ib_qp *qp,
+static int set_user_sq_size(struct mlx4_ib_dev *dev,
+			    struct mlx4_ib_qp *qp,
 			    struct mlx4_ib_create_qp *ucmd)
 {
+	/* Sanity check SQ size before proceeding */
+	if ((1 << ucmd->log_sq_bb_count) > dev->dev->caps.max_wqes	 ||
+	    ucmd->log_sq_stride >
+		ilog2(roundup_pow_of_two(dev->dev->caps.max_sq_desc_sz)) ||
+	    ucmd->log_sq_stride < MLX4_IB_MIN_SQ_STRIDE)
+		return -EINVAL;
+
 	qp->sq.wqe_cnt   = 1 << ucmd->log_sq_bb_count;
 	qp->sq.wqe_shift = ucmd->log_sq_stride;
 
@@ -330,7 +342,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 
 		qp->sq_no_prefetch = ucmd.sq_no_prefetch;
 
-		err = set_user_sq_size(qp, &ucmd);
+		err = set_user_sq_size(dev, qp, &ucmd);
 		if (err)
 			goto err;
 
diff --git a/drivers/infiniband/hw/mthca/mthca_cq.c b/drivers/infiniband/hw/mthca/mthca_cq.c
index be6e1e0..6bd9f13 100644
--- a/drivers/infiniband/hw/mthca/mthca_cq.c
+++ b/drivers/infiniband/hw/mthca/mthca_cq.c
@@ -204,16 +204,11 @@ static void dump_cqe(struct mthca_dev *dev, void *cqe_ptr)
 static inline void update_cons_index(struct mthca_dev *dev, struct mthca_cq *cq,
 				     int incr)
 {
-	__be32 doorbell[2];
-
 	if (mthca_is_memfree(dev)) {
 		*cq->set_ci_db = cpu_to_be32(cq->cons_index);
 		wmb();
 	} else {
-		doorbell[0] = cpu_to_be32(MTHCA_TAVOR_CQ_DB_INC_CI | cq->cqn);
-		doorbell[1] = cpu_to_be32(incr - 1);
-
-		mthca_write64(doorbell,
+		mthca_write64(MTHCA_TAVOR_CQ_DB_INC_CI | cq->cqn, incr - 1,
 			      dev->kar + MTHCA_CQ_DOORBELL,
 			      MTHCA_GET_DOORBELL_LOCK(&dev->doorbell_lock));
 		/*
@@ -731,17 +726,12 @@ repoll:
 
 int mthca_tavor_arm_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags)
 {
-	__be32 doorbell[2];
+	u32 dbhi = ((flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED ?
+		    MTHCA_TAVOR_CQ_DB_REQ_NOT_SOL :
+		    MTHCA_TAVOR_CQ_DB_REQ_NOT) |
+		to_mcq(cq)->cqn;
 
-	doorbell[0] = cpu_to_be32(((flags & IB_CQ_SOLICITED_MASK) ==
-				   IB_CQ_SOLICITED ?
-				   MTHCA_TAVOR_CQ_DB_REQ_NOT_SOL :
-				   MTHCA_TAVOR_CQ_DB_REQ_NOT)      |
-				  to_mcq(cq)->cqn);
-	doorbell[1] = (__force __be32) 0xffffffff;
-
-	mthca_write64(doorbell,
-		      to_mdev(cq->device)->kar + MTHCA_CQ_DOORBELL,
+	mthca_write64(dbhi, 0xffffffff, to_mdev(cq->device)->kar + MTHCA_CQ_DOORBELL,
 		      MTHCA_GET_DOORBELL_LOCK(&to_mdev(cq->device)->doorbell_lock));
 
 	return 0;
@@ -750,19 +740,16 @@ int mthca_tavor_arm_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags)
 int mthca_arbel_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 {
 	struct mthca_cq *cq = to_mcq(ibcq);
-	__be32 doorbell[2];
-	u32 sn;
-	__be32 ci;
-
-	sn = cq->arm_sn & 3;
-	ci = cpu_to_be32(cq->cons_index);
+	__be32 db_rec[2];
+	u32 dbhi;
+	u32 sn = cq->arm_sn & 3;
 
-	doorbell[0] = ci;
-	doorbell[1] = cpu_to_be32((cq->cqn << 8) | (2 << 5) | (sn << 3) |
-				  ((flags & IB_CQ_SOLICITED_MASK) ==
-				   IB_CQ_SOLICITED ? 1 : 2));
+	db_rec[0] = cpu_to_be32(cq->cons_index);
+	db_rec[1] = cpu_to_be32((cq->cqn << 8) | (2 << 5) | (sn << 3) |
+				((flags & IB_CQ_SOLICITED_MASK) ==
+				 IB_CQ_SOLICITED ? 1 : 2));
 
-	mthca_write_db_rec(doorbell, cq->arm_db);
+	mthca_write_db_rec(db_rec, cq->arm_db);
 
 	/*
 	 * Make sure that the doorbell record in host memory is
@@ -770,14 +757,12 @@ int mthca_arbel_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 	 */
 	wmb();
 
-	doorbell[0] = cpu_to_be32((sn << 28)                       |
-				  ((flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED ?
-				   MTHCA_ARBEL_CQ_DB_REQ_NOT_SOL :
-				   MTHCA_ARBEL_CQ_DB_REQ_NOT)      |
-				  cq->cqn);
-	doorbell[1] = ci;
+	dbhi = (sn << 28) |
+		((flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED ?
+		 MTHCA_ARBEL_CQ_DB_REQ_NOT_SOL :
+		 MTHCA_ARBEL_CQ_DB_REQ_NOT) | cq->cqn;
 
-	mthca_write64(doorbell,
+	mthca_write64(dbhi, cq->cons_index,
 		      to_mdev(ibcq->device)->kar + MTHCA_CQ_DOORBELL,
 		      MTHCA_GET_DOORBELL_LOCK(&to_mdev(ibcq->device)->doorbell_lock));
 
diff --git a/drivers/infiniband/hw/mthca/mthca_doorbell.h b/drivers/infiniband/hw/mthca/mthca_doorbell.h
index dd9a44d..b374dc3 100644
--- a/drivers/infiniband/hw/mthca/mthca_doorbell.h
+++ b/drivers/infiniband/hw/mthca/mthca_doorbell.h
@@ -58,10 +58,10 @@ static inline void mthca_write64_raw(__be64 val, void __iomem *dest)
 	__raw_writeq((__force u64) val, dest);
 }
 
-static inline void mthca_write64(__be32 val[2], void __iomem *dest,
+static inline void mthca_write64(u32 hi, u32 lo, void __iomem *dest,
 				 spinlock_t *doorbell_lock)
 {
-	__raw_writeq(*(u64 *) val, dest);
+	__raw_writeq((__force u64) cpu_to_be64((u64) hi << 32 | lo), dest);
 }
 
 static inline void mthca_write_db_rec(__be32 val[2], __be32 *db)
@@ -87,14 +87,17 @@ static inline void mthca_write64_raw(__be64 val, void __iomem *dest)
 	__raw_writel(((__force u32 *) &val)[1], dest + 4);
 }
 
-static inline void mthca_write64(__be32 val[2], void __iomem *dest,
+static inline void mthca_write64(u32 hi, u32 lo, void __iomem *dest,
 				 spinlock_t *doorbell_lock)
 {
 	unsigned long flags;
 
+	hi = (__force u32) cpu_to_be32(hi);
+	lo = (__force u32) cpu_to_be32(lo);
+
 	spin_lock_irqsave(doorbell_lock, flags);
-	__raw_writel((__force u32) val[0], dest);
-	__raw_writel((__force u32) val[1], dest + 4);
+	__raw_writel(hi, dest);
+	__raw_writel(lo, dest + 4);
 	spin_unlock_irqrestore(doorbell_lock, flags);
 }
 
diff --git a/drivers/infiniband/hw/mthca/mthca_eq.c b/drivers/infiniband/hw/mthca/mthca_eq.c
index 8592b26..b29de51 100644
--- a/drivers/infiniband/hw/mthca/mthca_eq.c
+++ b/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -173,11 +173,6 @@ static inline u64 async_mask(struct mthca_dev *dev)
 
 static inline void tavor_set_eq_ci(struct mthca_dev *dev, struct mthca_eq *eq, u32 ci)
 {
-	__be32 doorbell[2];
-
-	doorbell[0] = cpu_to_be32(MTHCA_EQ_DB_SET_CI | eq->eqn);
-	doorbell[1] = cpu_to_be32(ci & (eq->nent - 1));
-
 	/*
 	 * This barrier makes sure that all updates to ownership bits
 	 * done by set_eqe_hw() hit memory before the consumer index
@@ -187,7 +182,7 @@ static inline void tavor_set_eq_ci(struct mthca_dev *dev, struct mthca_eq *eq, u
 	 * having set_eqe_hw() overwrite the owner field.
 	 */
 	wmb();
-	mthca_write64(doorbell,
+	mthca_write64(MTHCA_EQ_DB_SET_CI | eq->eqn, ci & (eq->nent - 1),
 		      dev->kar + MTHCA_EQ_DOORBELL,
 		      MTHCA_GET_DOORBELL_LOCK(&dev->doorbell_lock));
 }
@@ -212,12 +207,7 @@ static inline void set_eq_ci(struct mthca_dev *dev, struct mthca_eq *eq, u32 ci)
 
 static inline void tavor_eq_req_not(struct mthca_dev *dev, int eqn)
 {
-	__be32 doorbell[2];
-
-	doorbell[0] = cpu_to_be32(MTHCA_EQ_DB_REQ_NOT | eqn);
-	doorbell[1] = 0;
-
-	mthca_write64(doorbell,
+	mthca_write64(MTHCA_EQ_DB_REQ_NOT | eqn, 0,
 		      dev->kar + MTHCA_EQ_DOORBELL,
 		      MTHCA_GET_DOORBELL_LOCK(&dev->doorbell_lock));
 }
@@ -230,12 +220,7 @@ static inline void arbel_eq_req_not(struct mthca_dev *dev, u32 eqn_mask)
 static inline void disarm_cq(struct mthca_dev *dev, int eqn, int cqn)
 {
 	if (!mthca_is_memfree(dev)) {
-		__be32 doorbell[2];
-
-		doorbell[0] = cpu_to_be32(MTHCA_EQ_DB_DISARM_CQ | eqn);
-		doorbell[1] = cpu_to_be32(cqn);
-
-		mthca_write64(doorbell,
+		mthca_write64(MTHCA_EQ_DB_DISARM_CQ | eqn, cqn,
 			      dev->kar + MTHCA_EQ_DOORBELL,
 			      MTHCA_GET_DOORBELL_LOCK(&dev->doorbell_lock));
 	}
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index df01b20..0e5461c 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -1799,15 +1799,11 @@ int mthca_tavor_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 out:
 	if (likely(nreq)) {
-		__be32 doorbell[2];
-
-		doorbell[0] = cpu_to_be32(((qp->sq.next_ind << qp->sq.wqe_shift) +
-					   qp->send_wqe_offset) | f0 | op0);
-		doorbell[1] = cpu_to_be32((qp->qpn << 8) | size0);
-
 		wmb();
 
-		mthca_write64(doorbell,
+		mthca_write64(((qp->sq.next_ind << qp->sq.wqe_shift) +
+			       qp->send_wqe_offset) | f0 | op0,
+			      (qp->qpn << 8) | size0,
 			      dev->kar + MTHCA_SEND_DOORBELL,
 			      MTHCA_GET_DOORBELL_LOCK(&dev->doorbell_lock));
 		/*
@@ -1829,7 +1825,6 @@ int mthca_tavor_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 {
 	struct mthca_dev *dev = to_mdev(ibqp->device);
 	struct mthca_qp *qp = to_mqp(ibqp);
-	__be32 doorbell[2];
 	unsigned long flags;
 	int err = 0;
 	int nreq;
@@ -1907,13 +1902,10 @@ int mthca_tavor_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 		if (unlikely(nreq == MTHCA_TAVOR_MAX_WQES_PER_RECV_DB)) {
 			nreq = 0;
 
-			doorbell[0] = cpu_to_be32((qp->rq.next_ind << qp->rq.wqe_shift) | size0);
-			doorbell[1] = cpu_to_be32(qp->qpn << 8);
-
 			wmb();
 
-			mthca_write64(doorbell,
-				      dev->kar + MTHCA_RECEIVE_DOORBELL,
+			mthca_write64((qp->rq.next_ind << qp->rq.wqe_shift) | size0,
+				      qp->qpn << 8, dev->kar + MTHCA_RECEIVE_DOORBELL,
 				      MTHCA_GET_DOORBELL_LOCK(&dev->doorbell_lock));
 
 			qp->rq.next_ind = ind;
@@ -1923,13 +1915,10 @@ int mthca_tavor_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 
 out:
 	if (likely(nreq)) {
-		doorbell[0] = cpu_to_be32((qp->rq.next_ind << qp->rq.wqe_shift) | size0);
-		doorbell[1] = cpu_to_be32((qp->qpn << 8) | nreq);
-
 		wmb();
 
-		mthca_write64(doorbell,
-			      dev->kar + MTHCA_RECEIVE_DOORBELL,
+		mthca_write64((qp->rq.next_ind << qp->rq.wqe_shift) | size0,
+			      qp->qpn << 8 | nreq, dev->kar + MTHCA_RECEIVE_DOORBELL,
 			      MTHCA_GET_DOORBELL_LOCK(&dev->doorbell_lock));
 	}
 
@@ -1951,7 +1940,7 @@ int mthca_arbel_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 {
 	struct mthca_dev *dev = to_mdev(ibqp->device);
 	struct mthca_qp *qp = to_mqp(ibqp);
-	__be32 doorbell[2];
+	u32 dbhi;
 	void *wqe;
 	void *prev_wqe;
 	unsigned long flags;
@@ -1981,10 +1970,8 @@ int mthca_arbel_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		if (unlikely(nreq == MTHCA_ARBEL_MAX_WQES_PER_SEND_DB)) {
 			nreq = 0;
 
-			doorbell[0] = cpu_to_be32((MTHCA_ARBEL_MAX_WQES_PER_SEND_DB << 24) |
-						  ((qp->sq.head & 0xffff) << 8) |
-						  f0 | op0);
-			doorbell[1] = cpu_to_be32((qp->qpn << 8) | size0);
+			dbhi = (MTHCA_ARBEL_MAX_WQES_PER_SEND_DB << 24) |
+				((qp->sq.head & 0xffff) << 8) | f0 | op0;
 
 			qp->sq.head += MTHCA_ARBEL_MAX_WQES_PER_SEND_DB;
 
@@ -2000,7 +1987,8 @@ int mthca_arbel_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			 * write MMIO send doorbell.
 			 */
 			wmb();
-			mthca_write64(doorbell,
+
+			mthca_write64(dbhi, (qp->qpn << 8) | size0,
 				      dev->kar + MTHCA_SEND_DOORBELL,
 				      MTHCA_GET_DOORBELL_LOCK(&dev->doorbell_lock));
 		}
@@ -2154,10 +2142,7 @@ int mthca_arbel_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 out:
 	if (likely(nreq)) {
-		doorbell[0] = cpu_to_be32((nreq << 24)                  |
-					  ((qp->sq.head & 0xffff) << 8) |
-					  f0 | op0);
-		doorbell[1] = cpu_to_be32((qp->qpn << 8) | size0);
+		dbhi = (nreq << 24) | ((qp->sq.head & 0xffff) << 8) | f0 | op0;
 
 		qp->sq.head += nreq;
 
@@ -2173,8 +2158,8 @@ out:
 		 * write MMIO send doorbell.
 		 */
 		wmb();
-		mthca_write64(doorbell,
-			      dev->kar + MTHCA_SEND_DOORBELL,
+
+		mthca_write64(dbhi, (qp->qpn << 8) | size0, dev->kar + MTHCA_SEND_DOORBELL,
 			      MTHCA_GET_DOORBELL_LOCK(&dev->doorbell_lock));
 	}
 
diff --git a/drivers/infiniband/hw/mthca/mthca_srq.c b/drivers/infiniband/hw/mthca/mthca_srq.c
index 3f58c11..553d681 100644
--- a/drivers/infiniband/hw/mthca/mthca_srq.c
+++ b/drivers/infiniband/hw/mthca/mthca_srq.c
@@ -491,7 +491,6 @@ int mthca_tavor_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 {
 	struct mthca_dev *dev = to_mdev(ibsrq->device);
 	struct mthca_srq *srq = to_msrq(ibsrq);
-	__be32 doorbell[2];
 	unsigned long flags;
 	int err = 0;
 	int first_ind;
@@ -563,16 +562,13 @@ int mthca_tavor_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 		if (unlikely(nreq == MTHCA_TAVOR_MAX_WQES_PER_RECV_DB)) {
 			nreq = 0;
 
-			doorbell[0] = cpu_to_be32(first_ind << srq->wqe_shift);
-			doorbell[1] = cpu_to_be32(srq->srqn << 8);
-
 			/*
 			 * Make sure that descriptors are written
 			 * before doorbell is rung.
 			 */
 			wmb();
 
-			mthca_write64(doorbell,
+			mthca_write64(first_ind << srq->wqe_shift, srq->srqn << 8,
 				      dev->kar + MTHCA_RECEIVE_DOORBELL,
 				      MTHCA_GET_DOORBELL_LOCK(&dev->doorbell_lock));
 
@@ -581,16 +577,13 @@ int mthca_tavor_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 	}
 
 	if (likely(nreq)) {
-		doorbell[0] = cpu_to_be32(first_ind << srq->wqe_shift);
-		doorbell[1] = cpu_to_be32((srq->srqn << 8) | nreq);
-
 		/*
 		 * Make sure that descriptors are written before
 		 * doorbell is rung.
 		 */
 		wmb();
 
-		mthca_write64(doorbell,
+		mthca_write64(first_ind << srq->wqe_shift, (srq->srqn << 8) | nreq,
 			      dev->kar + MTHCA_RECEIVE_DOORBELL,
 			      MTHCA_GET_DOORBELL_LOCK(&dev->doorbell_lock));
 	}
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 6545fa7..0a00ea0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -84,9 +84,8 @@ enum {
 	IPOIB_MCAST_RUN 	  = 6,
 	IPOIB_STOP_REAPER         = 7,
 	IPOIB_MCAST_STARTED       = 8,
-	IPOIB_FLAG_NETIF_STOPPED  = 9,
-	IPOIB_FLAG_ADMIN_CM 	  = 10,
-	IPOIB_FLAG_UMCAST	  = 11,
+	IPOIB_FLAG_ADMIN_CM 	  = 9,
+	IPOIB_FLAG_UMCAST	  = 10,
 
 	IPOIB_MAX_BACKOFF_SECONDS = 16,
 
@@ -98,9 +97,9 @@ enum {
 
 #define	IPOIB_OP_RECV   (1ul << 31)
 #ifdef CONFIG_INFINIBAND_IPOIB_CM
-#define	IPOIB_CM_OP_SRQ (1ul << 30)
+#define	IPOIB_OP_CM     (1ul << 30)
 #else
-#define	IPOIB_CM_OP_SRQ (0)
+#define	IPOIB_OP_CM     (0)
 #endif
 
 /* structs */
@@ -197,7 +196,6 @@ struct ipoib_cm_rx {
 
 struct ipoib_cm_tx {
 	struct ib_cm_id     *id;
-	struct ib_cq        *cq;
 	struct ib_qp        *qp;
 	struct list_head     list;
 	struct net_device   *dev;
@@ -294,6 +292,7 @@ struct ipoib_dev_priv {
 	unsigned             tx_tail;
 	struct ib_sge        tx_sge;
 	struct ib_send_wr    tx_wr;
+	unsigned             tx_outstanding;
 
 	struct ib_wc ibwc[IPOIB_NUM_WC];
 
@@ -502,6 +501,7 @@ void ipoib_cm_destroy_tx(struct ipoib_cm_tx *tx);
 void ipoib_cm_skb_too_long(struct net_device* dev, struct sk_buff *skb,
 			   unsigned int mtu);
 void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc);
+void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc);
 #else
 
 struct ipoib_cm_tx;
@@ -590,6 +590,9 @@ static inline void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *w
 {
 }
 
+static inline void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
+{
+}
 #endif
 
 #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 0a0dcb8..8761077 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -87,7 +87,7 @@ static int ipoib_cm_post_receive(struct net_device *dev, int id)
 	struct ib_recv_wr *bad_wr;
 	int i, ret;
 
-	priv->cm.rx_wr.wr_id = id | IPOIB_CM_OP_SRQ;
+	priv->cm.rx_wr.wr_id = id | IPOIB_OP_CM | IPOIB_OP_RECV;
 
 	for (i = 0; i < IPOIB_CM_RX_SG; ++i)
 		priv->cm.rx_sge[i].addr = priv->cm.srq_ring[id].mapping[i];
@@ -401,7 +401,7 @@ static void skb_put_frags(struct sk_buff *skb, unsigned int hdr_space,
 void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
-	unsigned int wr_id = wc->wr_id & ~IPOIB_CM_OP_SRQ;
+	unsigned int wr_id = wc->wr_id & ~(IPOIB_OP_CM | IPOIB_OP_RECV);
 	struct sk_buff *skb, *newskb;
 	struct ipoib_cm_rx *p;
 	unsigned long flags;
@@ -412,7 +412,7 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 		       wr_id, wc->status);
 
 	if (unlikely(wr_id >= ipoib_recvq_size)) {
-		if (wr_id == (IPOIB_CM_RX_DRAIN_WRID & ~IPOIB_CM_OP_SRQ)) {
+		if (wr_id == (IPOIB_CM_RX_DRAIN_WRID & ~(IPOIB_OP_CM | IPOIB_OP_RECV))) {
 			spin_lock_irqsave(&priv->lock, flags);
 			list_splice_init(&priv->cm.rx_drain_list, &priv->cm.rx_reap_list);
 			ipoib_cm_start_rx_drain(priv);
@@ -434,7 +434,7 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 		goto repost;
 	}
 
-	if (!likely(wr_id & IPOIB_CM_RX_UPDATE_MASK)) {
+	if (unlikely(!(wr_id & IPOIB_CM_RX_UPDATE_MASK))) {
 		p = wc->qp->qp_context;
 		if (p && time_after_eq(jiffies, p->jiffies + IPOIB_CM_RX_UPDATE_TIME)) {
 			spin_lock_irqsave(&priv->lock, flags);
@@ -498,7 +498,7 @@ static inline int post_send(struct ipoib_dev_priv *priv,
 	priv->tx_sge.addr             = addr;
 	priv->tx_sge.length           = len;
 
-	priv->tx_wr.wr_id 	      = wr_id;
+	priv->tx_wr.wr_id 	      = wr_id | IPOIB_OP_CM;
 
 	return ib_post_send(tx->qp, &priv->tx_wr, &bad_wr);
 }
@@ -549,20 +549,19 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 		dev->trans_start = jiffies;
 		++tx->tx_head;
 
-		if (tx->tx_head - tx->tx_tail == ipoib_sendq_size) {
+		if (++priv->tx_outstanding == ipoib_sendq_size) {
 			ipoib_dbg(priv, "TX ring 0x%x full, stopping kernel net queue\n",
 				  tx->qp->qp_num);
 			netif_stop_queue(dev);
-			set_bit(IPOIB_FLAG_NETIF_STOPPED, &tx->flags);
 		}
 	}
 }
 
-static void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ipoib_cm_tx *tx,
-				  struct ib_wc *wc)
+void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
-	unsigned int wr_id = wc->wr_id;
+	struct ipoib_cm_tx *tx = wc->qp->qp_context;
+	unsigned int wr_id = wc->wr_id & ~IPOIB_OP_CM;
 	struct ipoib_tx_buf *tx_req;
 	unsigned long flags;
 
@@ -587,11 +586,10 @@ static void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ipoib_cm_tx *tx
 
 	spin_lock_irqsave(&priv->tx_lock, flags);
 	++tx->tx_tail;
-	if (unlikely(test_bit(IPOIB_FLAG_NETIF_STOPPED, &tx->flags)) &&
-	    tx->tx_head - tx->tx_tail <= ipoib_sendq_size >> 1) {
-		clear_bit(IPOIB_FLAG_NETIF_STOPPED, &tx->flags);
+	if (unlikely(--priv->tx_outstanding == ipoib_sendq_size >> 1) &&
+	    netif_queue_stopped(dev) &&
+	    test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
 		netif_wake_queue(dev);
-	}
 
 	if (wc->status != IB_WC_SUCCESS &&
 	    wc->status != IB_WC_WR_FLUSH_ERR) {
@@ -614,11 +612,6 @@ static void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ipoib_cm_tx *tx
 			tx->neigh = NULL;
 		}
 
-		/* queue would be re-started anyway when TX is destroyed,
-		 * but it makes sense to do it ASAP here. */
-		if (test_and_clear_bit(IPOIB_FLAG_NETIF_STOPPED, &tx->flags))
-			netif_wake_queue(dev);
-
 		if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
 			list_move(&tx->list, &priv->cm.reap_list);
 			queue_work(ipoib_workqueue, &priv->cm.reap_task);
@@ -632,19 +625,6 @@ static void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ipoib_cm_tx *tx
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
 }
 
-static void ipoib_cm_tx_completion(struct ib_cq *cq, void *tx_ptr)
-{
-	struct ipoib_cm_tx *tx = tx_ptr;
-	int n, i;
-
-	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
-	do {
-		n = ib_poll_cq(cq, IPOIB_NUM_WC, tx->ibwc);
-		for (i = 0; i < n; ++i)
-			ipoib_cm_handle_tx_wc(tx->dev, tx, tx->ibwc + i);
-	} while (n == IPOIB_NUM_WC);
-}
-
 int ipoib_cm_dev_open(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
@@ -807,17 +787,18 @@ static int ipoib_cm_rep_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
 	return 0;
 }
 
-static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ib_cq *cq)
+static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_cm_tx *tx)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ib_qp_init_attr attr = {
-		.send_cq		= cq,
+		.send_cq		= priv->cq,
 		.recv_cq		= priv->cq,
 		.srq			= priv->cm.srq,
 		.cap.max_send_wr	= ipoib_sendq_size,
 		.cap.max_send_sge	= 1,
 		.sq_sig_type		= IB_SIGNAL_ALL_WR,
 		.qp_type		= IB_QPT_RC,
+		.qp_context		= tx
         };
 
 	return ib_create_qp(priv->pd, &attr);
@@ -899,21 +880,7 @@ static int ipoib_cm_tx_init(struct ipoib_cm_tx *p, u32 qpn,
 		goto err_tx;
 	}
 
-	p->cq = ib_create_cq(priv->ca, ipoib_cm_tx_completion, NULL, p,
-			     ipoib_sendq_size + 1, 0);
-	if (IS_ERR(p->cq)) {
-		ret = PTR_ERR(p->cq);
-		ipoib_warn(priv, "failed to allocate tx cq: %d\n", ret);
-		goto err_cq;
-	}
-
-	ret = ib_req_notify_cq(p->cq, IB_CQ_NEXT_COMP);
-	if (ret) {
-		ipoib_warn(priv, "failed to request completion notification: %d\n", ret);
-		goto err_req_notify;
-	}
-
-	p->qp = ipoib_cm_create_tx_qp(p->dev, p->cq);
+	p->qp = ipoib_cm_create_tx_qp(p->dev, p);
 	if (IS_ERR(p->qp)) {
 		ret = PTR_ERR(p->qp);
 		ipoib_warn(priv, "failed to allocate tx qp: %d\n", ret);
@@ -950,12 +917,8 @@ err_modify:
 err_id:
 	p->id = NULL;
 	ib_destroy_qp(p->qp);
-err_req_notify:
 err_qp:
 	p->qp = NULL;
-	ib_destroy_cq(p->cq);
-err_cq:
-	p->cq = NULL;
 err_tx:
 	return ret;
 }
@@ -964,6 +927,8 @@ static void ipoib_cm_tx_destroy(struct ipoib_cm_tx *p)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(p->dev);
 	struct ipoib_tx_buf *tx_req;
+	unsigned long flags;
+	unsigned long begin;
 
 	ipoib_dbg(priv, "Destroy active connection 0x%x head 0x%x tail 0x%x\n",
 		  p->qp ? p->qp->qp_num : 0, p->tx_head, p->tx_tail);
@@ -971,27 +936,40 @@ static void ipoib_cm_tx_destroy(struct ipoib_cm_tx *p)
 	if (p->id)
 		ib_destroy_cm_id(p->id);
 
-	if (p->qp)
-		ib_destroy_qp(p->qp);
-
-	if (p->cq)
-		ib_destroy_cq(p->cq);
-
-	if (test_bit(IPOIB_FLAG_NETIF_STOPPED, &p->flags))
-		netif_wake_queue(p->dev);
-
 	if (p->tx_ring) {
+		/* Wait for all sends to complete */
+		begin = jiffies;
 		while ((int) p->tx_tail - (int) p->tx_head < 0) {
-			tx_req = &p->tx_ring[p->tx_tail & (ipoib_sendq_size - 1)];
-			ib_dma_unmap_single(priv->ca, tx_req->mapping, tx_req->skb->len,
-					 DMA_TO_DEVICE);
-			dev_kfree_skb_any(tx_req->skb);
-			++p->tx_tail;
+			if (time_after(jiffies, begin + 5 * HZ)) {
+				ipoib_warn(priv, "timing out; %d sends not completed\n",
+					   p->tx_head - p->tx_tail);
+				goto timeout;
+			}
+
+			msleep(1);
 		}
+	}
 
-		kfree(p->tx_ring);
+timeout:
+
+	while ((int) p->tx_tail - (int) p->tx_head < 0) {
+		tx_req = &p->tx_ring[p->tx_tail & (ipoib_sendq_size - 1)];
+		ib_dma_unmap_single(priv->ca, tx_req->mapping, tx_req->skb->len,
+				    DMA_TO_DEVICE);
+		dev_kfree_skb_any(tx_req->skb);
+		++p->tx_tail;
+		spin_lock_irqsave(&priv->tx_lock, flags);
+		if (unlikely(--priv->tx_outstanding == ipoib_sendq_size >> 1) &&
+		    netif_queue_stopped(p->dev) &&
+		    test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
+			netif_wake_queue(p->dev);
+		spin_unlock_irqrestore(&priv->tx_lock, flags);
 	}
 
+	if (p->qp)
+		ib_destroy_qp(p->qp);
+
+	kfree(p->tx_ring);
 	kfree(p);
 }
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 1a77e79..5063dd5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -267,11 +267,10 @@ static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 
 	spin_lock_irqsave(&priv->tx_lock, flags);
 	++priv->tx_tail;
-	if (unlikely(test_bit(IPOIB_FLAG_NETIF_STOPPED, &priv->flags)) &&
-	    priv->tx_head - priv->tx_tail <= ipoib_sendq_size >> 1) {
-		clear_bit(IPOIB_FLAG_NETIF_STOPPED, &priv->flags);
+	if (unlikely(--priv->tx_outstanding == ipoib_sendq_size >> 1) &&
+	    netif_queue_stopped(dev) &&
+	    test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
 		netif_wake_queue(dev);
-	}
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
 	if (wc->status != IB_WC_SUCCESS &&
@@ -301,14 +300,18 @@ poll_more:
 		for (i = 0; i < n; i++) {
 			struct ib_wc *wc = priv->ibwc + i;
 
-			if (wc->wr_id & IPOIB_CM_OP_SRQ) {
-				++done;
-				ipoib_cm_handle_rx_wc(dev, wc);
-			} else if (wc->wr_id & IPOIB_OP_RECV) {
+			if (wc->wr_id & IPOIB_OP_RECV) {
 				++done;
-				ipoib_ib_handle_rx_wc(dev, wc);
-			} else
-				ipoib_ib_handle_tx_wc(dev, wc);
+				if (wc->wr_id & IPOIB_OP_CM)
+					ipoib_cm_handle_rx_wc(dev, wc);
+				else
+					ipoib_ib_handle_rx_wc(dev, wc);
+			} else {
+				if (wc->wr_id & IPOIB_OP_CM)
+					ipoib_cm_handle_tx_wc(dev, wc);
+				else
+					ipoib_ib_handle_tx_wc(dev, wc);
+			}
 		}
 
 		if (n != t)
@@ -401,10 +404,9 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 		address->last_send = priv->tx_head;
 		++priv->tx_head;
 
-		if (priv->tx_head - priv->tx_tail == ipoib_sendq_size) {
+		if (++priv->tx_outstanding == ipoib_sendq_size) {
 			ipoib_dbg(priv, "TX ring full, stopping kernel net queue\n");
 			netif_stop_queue(dev);
-			set_bit(IPOIB_FLAG_NETIF_STOPPED, &priv->flags);
 		}
 	}
 }
@@ -436,7 +438,8 @@ void ipoib_reap_ah(struct work_struct *work)
 	__ipoib_reap_ah(dev);
 
 	if (!test_bit(IPOIB_STOP_REAPER, &priv->flags))
-		queue_delayed_work(ipoib_workqueue, &priv->ah_reap_task, HZ);
+		queue_delayed_work(ipoib_workqueue, &priv->ah_reap_task,
+				   round_jiffies_relative(HZ));
 }
 
 int ipoib_ib_dev_open(struct net_device *dev)
@@ -472,7 +475,8 @@ int ipoib_ib_dev_open(struct net_device *dev)
 	}
 
 	clear_bit(IPOIB_STOP_REAPER, &priv->flags);
-	queue_delayed_work(ipoib_workqueue, &priv->ah_reap_task, HZ);
+	queue_delayed_work(ipoib_workqueue, &priv->ah_reap_task,
+			   round_jiffies_relative(HZ));
 
 	set_bit(IPOIB_FLAG_INITIALIZED, &priv->flags);
 
@@ -561,12 +565,17 @@ void ipoib_drain_cq(struct net_device *dev)
 			if (priv->ibwc[i].status == IB_WC_SUCCESS)
 				priv->ibwc[i].status = IB_WC_WR_FLUSH_ERR;
 
-			if (priv->ibwc[i].wr_id & IPOIB_CM_OP_SRQ)
-				ipoib_cm_handle_rx_wc(dev, priv->ibwc + i);
-			else if (priv->ibwc[i].wr_id & IPOIB_OP_RECV)
-				ipoib_ib_handle_rx_wc(dev, priv->ibwc + i);
-			else
-				ipoib_ib_handle_tx_wc(dev, priv->ibwc + i);
+			if (priv->ibwc[i].wr_id & IPOIB_OP_RECV) {
+				if (priv->ibwc[i].wr_id & IPOIB_OP_CM)
+					ipoib_cm_handle_rx_wc(dev, priv->ibwc + i);
+				else
+					ipoib_ib_handle_rx_wc(dev, priv->ibwc + i);
+			} else {
+				if (priv->ibwc[i].wr_id & IPOIB_OP_CM)
+					ipoib_cm_handle_tx_wc(dev, priv->ibwc + i);
+				else
+					ipoib_ib_handle_tx_wc(dev, priv->ibwc + i);
+			}
 		}
 	} while (n == IPOIB_NUM_WC);
 }
@@ -612,6 +621,7 @@ int ipoib_ib_dev_stop(struct net_device *dev, int flush)
 						    DMA_TO_DEVICE);
 				dev_kfree_skb_any(tx_req->skb);
 				++priv->tx_tail;
+				--priv->tx_outstanding;
 			}
 
 			for (i = 0; i < ipoib_recvq_size; ++i) {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index e072f3c..ace2345 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -148,8 +148,6 @@ static int ipoib_stop(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	clear_bit(IPOIB_FLAG_NETIF_STOPPED, &priv->flags);
-
 	/*
 	 * Now flush workqueue to make sure a scheduled task doesn't
 	 * bring our internal state back up.
@@ -895,7 +893,7 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 		goto out_rx_ring_cleanup;
 	}
 
-	/* priv->tx_head & tx_tail are already 0 */
+	/* priv->tx_head, tx_tail & tx_outstanding are already 0 */
 
 	if (ipoib_ib_dev_init(dev, ca, port))
 		goto out_tx_ring_cleanup;
diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index 6471d33..5064873 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -736,7 +736,7 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 	MLX4_PUT(inbox, (u8) (PAGE_SHIFT - 12), INIT_HCA_UAR_PAGE_SZ_OFFSET);
 	MLX4_PUT(inbox, param->log_uar_sz,      INIT_HCA_LOG_UAR_SZ_OFFSET);
 
-	err = mlx4_cmd(dev, mailbox->dma, 0, 0, MLX4_CMD_INIT_HCA, 1000);
+	err = mlx4_cmd(dev, mailbox->dma, 0, 0, MLX4_CMD_INIT_HCA, 10000);
 
 	if (err)
 		mlx4_err(dev, "INIT_HCA returns %d\n", err);
diff --git a/include/linux/mlx4/doorbell.h b/include/linux/mlx4/doorbell.h
index 3f2da44..f31bba2 100644
--- a/include/linux/mlx4/doorbell.h
+++ b/include/linux/mlx4/doorbell.h
@@ -52,11 +52,6 @@
 #define MLX4_INIT_DOORBELL_LOCK(ptr)    do { } while (0)
 #define MLX4_GET_DOORBELL_LOCK(ptr)      (NULL)
 
-static inline void mlx4_write64_raw(__be64 val, void __iomem *dest)
-{
-	__raw_writeq((__force u64) val, dest);
-}
-
 static inline void mlx4_write64(__be32 val[2], void __iomem *dest,
 				spinlock_t *doorbell_lock)
 {
@@ -75,12 +70,6 @@ static inline void mlx4_write64(__be32 val[2], void __iomem *dest,
 #define MLX4_INIT_DOORBELL_LOCK(ptr)     spin_lock_init(ptr)
 #define MLX4_GET_DOORBELL_LOCK(ptr)      (ptr)
 
-static inline void mlx4_write64_raw(__be64 val, void __iomem *dest)
-{
-	__raw_writel(((__force u32 *) &val)[0], dest);
-	__raw_writel(((__force u32 *) &val)[1], dest + 4);
-}
-
 static inline void mlx4_write64(__be32 val[2], void __iomem *dest,
 				spinlock_t *doorbell_lock)
 {
