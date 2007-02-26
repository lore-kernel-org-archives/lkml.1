Return-Path: <linux-kernel-owner+w=401wt.eu-S1161034AbXBZVFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161034AbXBZVFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161201AbXBZVFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:05:50 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:42389 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161034AbXBZVFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:05:48 -0500
X-IronPort-AV: i="4.14,221,1170662400"; 
   d="scan'208"; a="393807399:sNHT2091429066"
To: torvalds@linux-foundation.org
Cc: openib-general@openib.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 26 Feb 2007 13:05:30 -0800
Message-ID: <adafy8s3a05.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Feb 2007 21:05:31.0079 (UTC) FILETIME=[D9452D70:01C759E9]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get various post-rc1 cleanups and fixes:

Adrian Bunk (2):
      IB/mthca: Make 2 functions static
      RDMA/cxgb3: cleanups

Michael S. Tsirkin (1):
      IPoIB/cm: Improve small message bandwidth

Roland Dreier (3):
      IPoIB: Remove unused local_rate tracking
      IB/uverbs: Return correct error for invalid PD in register MR
      IPoIB: Correct debugging output when path record lookup fails

Sean Hefty (4):
      IB/core: Set hop limit in ib_init_ah_from_wc correctly
      RDMA/cma: Request reversible paths only
      IB/cm: Remove ca_guid from cm_device structure
      RDMA/cma: Remove unused node_guid from cma_device structure

Steve Wise (1):
      RDMA/cxgb3: Stop the EP Timer on BAD CLOSE

 drivers/infiniband/core/cm.c                   |   10 ++---
 drivers/infiniband/core/cma.c                  |    6 ++--
 drivers/infiniband/core/uverbs_cmd.c           |    4 ++-
 drivers/infiniband/core/verbs.c                |    2 +-
 drivers/infiniband/hw/cxgb3/Makefile           |    1 -
 drivers/infiniband/hw/cxgb3/cxio_hal.c         |   31 +++++-----------
 drivers/infiniband/hw/cxgb3/cxio_hal.h         |    5 ---
 drivers/infiniband/hw/cxgb3/cxio_resource.c    |   14 +------
 drivers/infiniband/hw/cxgb3/iwch_cm.c          |    6 ++--
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.h    |    1 -
 drivers/infiniband/hw/cxgb3/iwch_qp.c          |   29 +++++++--------
 drivers/infiniband/hw/mthca/mthca_mr.c         |   10 +++--
 drivers/infiniband/ulp/ipoib/ipoib.h           |    1 -
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |   46 ++++++++++++++----------
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    8 ++---
 17 files changed, 76 insertions(+), 102 deletions(-)


diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index d446998..842cd0b 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -88,7 +88,6 @@ struct cm_port {
 struct cm_device {
 	struct list_head list;
 	struct ib_device *device;
-	__be64 ca_guid;
 	struct cm_port port[0];
 };
 
@@ -739,8 +738,8 @@ retest:
 		ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_priv->msg);
 		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 		ib_send_cm_rej(cm_id, IB_CM_REJ_TIMEOUT,
-			       &cm_id_priv->av.port->cm_dev->ca_guid,
-			       sizeof cm_id_priv->av.port->cm_dev->ca_guid,
+			       &cm_id_priv->id.device->node_guid,
+			       sizeof cm_id_priv->id.device->node_guid,
 			       NULL, 0);
 		break;
 	case IB_CM_REQ_RCVD:
@@ -883,7 +882,7 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 
 	req_msg->local_comm_id = cm_id_priv->id.local_id;
 	req_msg->service_id = param->service_id;
-	req_msg->local_ca_guid = cm_id_priv->av.port->cm_dev->ca_guid;
+	req_msg->local_ca_guid = cm_id_priv->id.device->node_guid;
 	cm_req_set_local_qpn(req_msg, cpu_to_be32(param->qp_num));
 	cm_req_set_resp_res(req_msg, param->responder_resources);
 	cm_req_set_init_depth(req_msg, param->initiator_depth);
@@ -1442,7 +1441,7 @@ static void cm_format_rep(struct cm_rep_msg *rep_msg,
 	cm_rep_set_flow_ctrl(rep_msg, param->flow_control);
 	cm_rep_set_rnr_retry_count(rep_msg, param->rnr_retry_count);
 	cm_rep_set_srq(rep_msg, param->srq);
-	rep_msg->local_ca_guid = cm_id_priv->av.port->cm_dev->ca_guid;
+	rep_msg->local_ca_guid = cm_id_priv->id.device->node_guid;
 
 	if (param->private_data && param->private_data_len)
 		memcpy(rep_msg->private_data, param->private_data,
@@ -3385,7 +3384,6 @@ static void cm_add_one(struct ib_device *device)
 		return;
 
 	cm_dev->device = device;
-	cm_dev->ca_guid = device->node_guid;
 
 	set_bit(IB_MGMT_METHOD_SEND, reg_req.method_mask);
 	for (i = 1; i <= device->phys_port_cnt; i++) {
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index f8d69b3..d441815 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -77,7 +77,6 @@ static int next_port;
 struct cma_device {
 	struct list_head	list;
 	struct ib_device	*device;
-	__be64			node_guid;
 	struct completion	comp;
 	atomic_t		refcount;
 	struct list_head	id_list;
@@ -1492,11 +1491,13 @@ static int cma_query_ib_route(struct rdma_id_private *id_priv, int timeout_ms,
 	ib_addr_get_dgid(addr, &path_rec.dgid);
 	path_rec.pkey = cpu_to_be16(ib_addr_get_pkey(addr));
 	path_rec.numb_path = 1;
+	path_rec.reversible = 1;
 
 	id_priv->query_id = ib_sa_path_rec_get(&sa_client, id_priv->id.device,
 				id_priv->id.port_num, &path_rec,
 				IB_SA_PATH_REC_DGID | IB_SA_PATH_REC_SGID |
-				IB_SA_PATH_REC_PKEY | IB_SA_PATH_REC_NUMB_PATH,
+				IB_SA_PATH_REC_PKEY | IB_SA_PATH_REC_NUMB_PATH |
+				IB_SA_PATH_REC_REVERSIBLE,
 				timeout_ms, GFP_KERNEL,
 				cma_query_handler, work, &id_priv->query);
 
@@ -2672,7 +2673,6 @@ static void cma_add_one(struct ib_device *device)
 		return;
 
 	cma_dev->device = device;
-	cma_dev->node_guid = device->node_guid;
 
 	init_completion(&cma_dev->comp);
 	atomic_set(&cma_dev->refcount, 1);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index df1efbc..4fd75af 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -622,8 +622,10 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	obj->umem.virt_base = cmd.hca_va;
 
 	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
-	if (!pd)
+	if (!pd) {
+		ret = -EINVAL;
 		goto err_release;
+	}
 
 	mr = pd->device->reg_user_mr(pd, &obj->umem, cmd.access_flags, &udata);
 	if (IS_ERR(mr)) {
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 8b5dd36..ccdf93d 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -167,7 +167,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 		ah_attr->grh.sgid_index = (u8) gid_index;
 		flow_class = be32_to_cpu(grh->version_tclass_flow);
 		ah_attr->grh.flow_label = flow_class & 0xFFFFF;
-		ah_attr->grh.hop_limit = grh->hop_limit;
+		ah_attr->grh.hop_limit = 0xFF;
 		ah_attr->grh.traffic_class = (flow_class >> 20) & 0xFF;
 	}
 	return 0;
diff --git a/drivers/infiniband/hw/cxgb3/Makefile b/drivers/infiniband/hw/cxgb3/Makefile
index 0e110f3..36b9898 100644
--- a/drivers/infiniband/hw/cxgb3/Makefile
+++ b/drivers/infiniband/hw/cxgb3/Makefile
@@ -8,5 +8,4 @@ iw_cxgb3-y :=  iwch_cm.o iwch_ev.o iwch_cq.o iwch_qp.o iwch_mem.o \
 
 ifdef CONFIG_INFINIBAND_CXGB3_DEBUG
 EXTRA_CFLAGS += -DDEBUG
-iw_cxgb3-y += cxio_dbg.o
 endif
diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index 114ac3b..d737c73 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -45,7 +45,7 @@
 static LIST_HEAD(rdev_list);
 static cxio_hal_ev_callback_func_t cxio_ev_cb = NULL;
 
-static inline struct cxio_rdev *cxio_hal_find_rdev_by_name(char *dev_name)
+static struct cxio_rdev *cxio_hal_find_rdev_by_name(char *dev_name)
 {
 	struct cxio_rdev *rdev;
 
@@ -55,8 +55,7 @@ static inline struct cxio_rdev *cxio_hal_find_rdev_by_name(char *dev_name)
 	return NULL;
 }
 
-static inline struct cxio_rdev *cxio_hal_find_rdev_by_t3cdev(struct t3cdev
-							     *tdev)
+static struct cxio_rdev *cxio_hal_find_rdev_by_t3cdev(struct t3cdev *tdev)
 {
 	struct cxio_rdev *rdev;
 
@@ -118,7 +117,7 @@ int cxio_hal_cq_op(struct cxio_rdev *rdev_p, struct t3_cq *cq,
 	return 0;
 }
 
-static inline int cxio_hal_clear_cq_ctx(struct cxio_rdev *rdev_p, u32 cqid)
+static int cxio_hal_clear_cq_ctx(struct cxio_rdev *rdev_p, u32 cqid)
 {
 	struct rdma_cq_setup setup;
 	setup.id = cqid;
@@ -130,7 +129,7 @@ static inline int cxio_hal_clear_cq_ctx(struct cxio_rdev *rdev_p, u32 cqid)
 	return (rdev_p->t3cdev_p->ctl(rdev_p->t3cdev_p, RDMA_CQ_SETUP, &setup));
 }
 
-int cxio_hal_clear_qp_ctx(struct cxio_rdev *rdev_p, u32 qpid)
+static int cxio_hal_clear_qp_ctx(struct cxio_rdev *rdev_p, u32 qpid)
 {
 	u64 sge_cmd;
 	struct t3_modify_qp_wr *wqe;
@@ -425,7 +424,7 @@ void cxio_flush_hw_cq(struct t3_cq *cq)
 	}
 }
 
-static inline int cqe_completes_wr(struct t3_cqe *cqe, struct t3_wq *wq)
+static int cqe_completes_wr(struct t3_cqe *cqe, struct t3_wq *wq)
 {
 	if (CQE_OPCODE(*cqe) == T3_TERMINATE)
 		return 0;
@@ -760,17 +759,6 @@ ret:
 	return err;
 }
 
-/* IN : stag key, pdid, pbl_size
- * Out: stag index, actaul pbl_size, and pbl_addr allocated.
- */
-int cxio_allocate_stag(struct cxio_rdev *rdev_p, u32 * stag, u32 pdid,
-		       enum tpt_mem_perm perm, u32 * pbl_size, u32 * pbl_addr)
-{
-	*stag = T3_STAG_UNSET;
-	return (__cxio_tpt_op(rdev_p, 0, stag, 0, pdid, TPT_NON_SHARED_MR,
-			      perm, 0, 0ULL, 0, 0, NULL, pbl_size, pbl_addr));
-}
-
 int cxio_register_phys_mem(struct cxio_rdev *rdev_p, u32 *stag, u32 pdid,
 			   enum tpt_mem_perm perm, u32 zbva, u64 to, u32 len,
 			   u8 page_size, __be64 *pbl, u32 *pbl_size,
@@ -1029,7 +1017,7 @@ void __exit cxio_hal_exit(void)
 	cxio_hal_destroy_rhdl_resource();
 }
 
-static inline void flush_completed_wrs(struct t3_wq *wq, struct t3_cq *cq)
+static void flush_completed_wrs(struct t3_wq *wq, struct t3_cq *cq)
 {
 	struct t3_swsq *sqp;
 	__u32 ptr = wq->sq_rptr;
@@ -1058,9 +1046,8 @@ static inline void flush_completed_wrs(struct t3_wq *wq, struct t3_cq *cq)
 			break;
 }
 
-static inline void create_read_req_cqe(struct t3_wq *wq,
-				       struct t3_cqe *hw_cqe,
-				       struct t3_cqe *read_cqe)
+static void create_read_req_cqe(struct t3_wq *wq, struct t3_cqe *hw_cqe,
+				struct t3_cqe *read_cqe)
 {
 	read_cqe->u.scqe.wrid_hi = wq->oldest_read->sq_wptr;
 	read_cqe->len = wq->oldest_read->read_len;
@@ -1073,7 +1060,7 @@ static inline void create_read_req_cqe(struct t3_wq *wq,
 /*
  * Return a ptr to the next read wr in the SWSQ or NULL.
  */
-static inline void advance_oldest_read(struct t3_wq *wq)
+static void advance_oldest_read(struct t3_wq *wq)
 {
 
 	u32 rptr = wq->oldest_read - wq->sq + 1;
diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.h b/drivers/infiniband/hw/cxgb3/cxio_hal.h
index 8ab04a7..99543d6 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.h
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.h
@@ -143,7 +143,6 @@ int cxio_rdev_open(struct cxio_rdev *rdev);
 void cxio_rdev_close(struct cxio_rdev *rdev);
 int cxio_hal_cq_op(struct cxio_rdev *rdev, struct t3_cq *cq,
 		   enum t3_cq_opcode op, u32 credit);
-int cxio_hal_clear_qp_ctx(struct cxio_rdev *rdev, u32 qpid);
 int cxio_create_cq(struct cxio_rdev *rdev, struct t3_cq *cq);
 int cxio_destroy_cq(struct cxio_rdev *rdev, struct t3_cq *cq);
 int cxio_resize_cq(struct cxio_rdev *rdev, struct t3_cq *cq);
@@ -154,8 +153,6 @@ int cxio_create_qp(struct cxio_rdev *rdev, u32 kernel_domain, struct t3_wq *wq,
 int cxio_destroy_qp(struct cxio_rdev *rdev, struct t3_wq *wq,
 		    struct cxio_ucontext *uctx);
 int cxio_peek_cq(struct t3_wq *wr, struct t3_cq *cq, int opcode);
-int cxio_allocate_stag(struct cxio_rdev *rdev, u32 * stag, u32 pdid,
-		       enum tpt_mem_perm perm, u32 * pbl_size, u32 * pbl_addr);
 int cxio_register_phys_mem(struct cxio_rdev *rdev, u32 * stag, u32 pdid,
 			   enum tpt_mem_perm perm, u32 zbva, u64 to, u32 len,
 			   u8 page_size, __be64 *pbl, u32 *pbl_size,
@@ -171,8 +168,6 @@ int cxio_deallocate_window(struct cxio_rdev *rdev, u32 stag);
 int cxio_rdma_init(struct cxio_rdev *rdev, struct t3_rdma_init_attr *attr);
 void cxio_register_ev_cb(cxio_hal_ev_callback_func_t ev_cb);
 void cxio_unregister_ev_cb(cxio_hal_ev_callback_func_t ev_cb);
-u32 cxio_hal_get_rhdl(void);
-void cxio_hal_put_rhdl(u32 rhdl);
 u32 cxio_hal_get_pdid(struct cxio_hal_resource *rscp);
 void cxio_hal_put_pdid(struct cxio_hal_resource *rscp, u32 pdid);
 int __init cxio_hal_init(void);
diff --git a/drivers/infiniband/hw/cxgb3/cxio_resource.c b/drivers/infiniband/hw/cxgb3/cxio_resource.c
index 65bf577..d3095ae 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_resource.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_resource.c
@@ -179,7 +179,7 @@ tpt_err:
 /*
  * returns 0 if no resource available
  */
-static inline u32 cxio_hal_get_resource(struct kfifo *fifo)
+static u32 cxio_hal_get_resource(struct kfifo *fifo)
 {
 	u32 entry;
 	if (kfifo_get(fifo, (unsigned char *) &entry, sizeof(u32)))
@@ -188,21 +188,11 @@ static inline u32 cxio_hal_get_resource(struct kfifo *fifo)
 		return 0;	/* fifo emptry */
 }
 
-static inline void cxio_hal_put_resource(struct kfifo *fifo, u32 entry)
+static void cxio_hal_put_resource(struct kfifo *fifo, u32 entry)
 {
 	BUG_ON(kfifo_put(fifo, (unsigned char *) &entry, sizeof(u32)) == 0);
 }
 
-u32 cxio_hal_get_rhdl(void)
-{
-	return cxio_hal_get_resource(rhdl_fifo);
-}
-
-void cxio_hal_put_rhdl(u32 rhdl)
-{
-	cxio_hal_put_resource(rhdl_fifo, rhdl);
-}
-
 u32 cxio_hal_get_stag(struct cxio_hal_resource *rscp)
 {
 	return cxio_hal_get_resource(rscp->tpt_fifo);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index e5442e3..b21fde8 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -209,8 +209,7 @@ static enum iwch_ep_state state_read(struct iwch_ep_common *epc)
 	return state;
 }
 
-static inline void __state_set(struct iwch_ep_common *epc,
-			       enum iwch_ep_state new)
+static void __state_set(struct iwch_ep_common *epc, enum iwch_ep_state new)
 {
 	epc->state = new;
 }
@@ -1459,7 +1458,7 @@ static int peer_close(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 /*
  * Returns whether an ABORT_REQ_RSS message is a negative advice.
  */
-static inline int is_neg_adv_abort(unsigned int status)
+static int is_neg_adv_abort(unsigned int status)
 {
 	return status == CPL_ERR_RTX_NEG_ADVICE ||
 	       status == CPL_ERR_PERSIST_NEG_ADVICE;
@@ -1635,6 +1634,7 @@ static int ec_status(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 
 		printk(KERN_ERR MOD "%s BAD CLOSE - Aborting tid %u\n",
 		       __FUNCTION__, ep->hwtid);
+		stop_ep_timer(ep);
 		attrs.next_state = IWCH_QP_STATE_ERROR;
 		iwch_modify_qp(ep->com.qp->rhp,
 			       ep->com.qp, IWCH_QP_ATTR_NEXT_STATE,
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 2aef122..9947a14 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -948,7 +948,7 @@ void iwch_qp_rem_ref(struct ib_qp *qp)
 	        wake_up(&(to_iwch_qp(qp)->wait));
 }
 
-struct ib_qp *iwch_get_qp(struct ib_device *dev, int qpn)
+static struct ib_qp *iwch_get_qp(struct ib_device *dev, int qpn)
 {
 	PDBG("%s ib_dev %p qpn 0x%x\n", __FUNCTION__, dev, qpn);
 	return (struct ib_qp *)get_qhp(to_iwch_dev(dev), qpn);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.h b/drivers/infiniband/hw/cxgb3/iwch_provider.h
index 2af3e93..de0fe1b 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.h
@@ -178,7 +178,6 @@ static inline struct iwch_qp *to_iwch_qp(struct ib_qp *ibqp)
 
 void iwch_qp_add_ref(struct ib_qp *qp);
 void iwch_qp_rem_ref(struct ib_qp *qp);
-struct ib_qp *iwch_get_qp(struct ib_device *dev, int qpn);
 
 struct iwch_ucontext {
 	struct ib_ucontext ibucontext;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 4dda2f6..9ea00cc 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -36,8 +36,8 @@
 
 #define NO_SUPPORT -1
 
-static inline int iwch_build_rdma_send(union t3_wr *wqe, struct ib_send_wr *wr,
-				       u8 * flit_cnt)
+static int iwch_build_rdma_send(union t3_wr *wqe, struct ib_send_wr *wr,
+				u8 * flit_cnt)
 {
 	int i;
 	u32 plen;
@@ -96,8 +96,8 @@ static inline int iwch_build_rdma_send(union t3_wr *wqe, struct ib_send_wr *wr,
 	return 0;
 }
 
-static inline int iwch_build_rdma_write(union t3_wr *wqe, struct ib_send_wr *wr,
-					u8 *flit_cnt)
+static int iwch_build_rdma_write(union t3_wr *wqe, struct ib_send_wr *wr,
+				 u8 *flit_cnt)
 {
 	int i;
 	u32 plen;
@@ -137,8 +137,8 @@ static inline int iwch_build_rdma_write(union t3_wr *wqe, struct ib_send_wr *wr,
 	return 0;
 }
 
-static inline int iwch_build_rdma_read(union t3_wr *wqe, struct ib_send_wr *wr,
-				       u8 *flit_cnt)
+static int iwch_build_rdma_read(union t3_wr *wqe, struct ib_send_wr *wr,
+				u8 *flit_cnt)
 {
 	if (wr->num_sge > 1)
 		return -EINVAL;
@@ -158,9 +158,8 @@ static inline int iwch_build_rdma_read(union t3_wr *wqe, struct ib_send_wr *wr,
 /*
  * TBD: this is going to be moved to firmware. Missing pdid/qpid check for now.
  */
-static inline int iwch_sgl2pbl_map(struct iwch_dev *rhp,
-				   struct ib_sge *sg_list, u32 num_sgle,
-				   u32 * pbl_addr, u8 * page_size)
+static int iwch_sgl2pbl_map(struct iwch_dev *rhp, struct ib_sge *sg_list,
+			    u32 num_sgle, u32 * pbl_addr, u8 * page_size)
 {
 	int i;
 	struct iwch_mr *mhp;
@@ -206,9 +205,8 @@ static inline int iwch_sgl2pbl_map(struct iwch_dev *rhp,
 	return 0;
 }
 
-static inline int iwch_build_rdma_recv(struct iwch_dev *rhp,
-						    union t3_wr *wqe,
-						    struct ib_recv_wr *wr)
+static int iwch_build_rdma_recv(struct iwch_dev *rhp, union t3_wr *wqe,
+				struct ib_recv_wr *wr)
 {
 	int i, err = 0;
 	u32 pbl_addr[4];
@@ -473,8 +471,7 @@ int iwch_bind_mw(struct ib_qp *qp,
 	return err;
 }
 
-static inline void build_term_codes(int t3err, u8 *layer_type, u8 *ecode,
-				    int tagged)
+static void build_term_codes(int t3err, u8 *layer_type, u8 *ecode, int tagged)
 {
 	switch (t3err) {
 	case TPT_ERR_STAG:
@@ -672,7 +669,7 @@ static void __flush_qp(struct iwch_qp *qhp, unsigned long *flag)
 	spin_lock_irqsave(&qhp->lock, *flag);
 }
 
-static inline void flush_qp(struct iwch_qp *qhp, unsigned long *flag)
+static void flush_qp(struct iwch_qp *qhp, unsigned long *flag)
 {
 	if (t3b_device(qhp->rhp))
 		cxio_set_wq_in_error(&qhp->wq);
@@ -684,7 +681,7 @@ static inline void flush_qp(struct iwch_qp *qhp, unsigned long *flag)
 /*
  * Return non zero if at least one RECV was pre-posted.
  */
-static inline int rqes_posted(struct iwch_qp *qhp)
+static int rqes_posted(struct iwch_qp *qhp)
 {
 	return fw_riwrh_opcode((struct fw_riwrh *)qhp->wq.queue) == T3_WR_RCV;
 }
diff --git a/drivers/infiniband/hw/mthca/mthca_mr.c b/drivers/infiniband/hw/mthca/mthca_mr.c
index 6037dd3..8e4846b 100644
--- a/drivers/infiniband/hw/mthca/mthca_mr.c
+++ b/drivers/infiniband/hw/mthca/mthca_mr.c
@@ -310,8 +310,9 @@ int mthca_write_mtt_size(struct mthca_dev *dev)
 	return mthca_is_memfree(dev) ? (PAGE_SIZE / sizeof (u64)) : 0x7ffffff;
 }
 
-void mthca_tavor_write_mtt_seg(struct mthca_dev *dev, struct mthca_mtt *mtt,
-			      int start_index, u64 *buffer_list, int list_len)
+static void mthca_tavor_write_mtt_seg(struct mthca_dev *dev,
+				      struct mthca_mtt *mtt, int start_index,
+				      u64 *buffer_list, int list_len)
 {
 	u64 __iomem *mtts;
 	int i;
@@ -323,8 +324,9 @@ void mthca_tavor_write_mtt_seg(struct mthca_dev *dev, struct mthca_mtt *mtt,
 				  mtts + i);
 }
 
-void mthca_arbel_write_mtt_seg(struct mthca_dev *dev, struct mthca_mtt *mtt,
-			      int start_index, u64 *buffer_list, int list_len)
+static void mthca_arbel_write_mtt_seg(struct mthca_dev *dev,
+				      struct mthca_mtt *mtt, int start_index,
+				      u64 *buffer_list, int list_len)
 {
 	__be64 *mtts;
 	dma_addr_t dma_handle;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 2594db2..fd55826 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -219,7 +219,6 @@ struct ipoib_dev_priv {
 
 	union ib_gid local_gid;
 	u16          local_lid;
-	u8           local_rate;
 
 	unsigned int admin_mtu;
 	unsigned int mcast_mtu;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 4d59682..3484e8b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -65,14 +65,14 @@ struct ipoib_cm_id {
 static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
 			       struct ib_cm_event *event);
 
-static void ipoib_cm_dma_unmap_rx(struct ipoib_dev_priv *priv,
+static void ipoib_cm_dma_unmap_rx(struct ipoib_dev_priv *priv, int frags,
 				  u64 mapping[IPOIB_CM_RX_SG])
 {
 	int i;
 
 	ib_dma_unmap_single(priv->ca, mapping[0], IPOIB_CM_HEAD_SIZE, DMA_FROM_DEVICE);
 
-	for (i = 0; i < IPOIB_CM_RX_SG - 1; ++i)
+	for (i = 0; i < frags; ++i)
 		ib_dma_unmap_single(priv->ca, mapping[i + 1], PAGE_SIZE, DMA_FROM_DEVICE);
 }
 
@@ -90,7 +90,8 @@ static int ipoib_cm_post_receive(struct net_device *dev, int id)
 	ret = ib_post_srq_recv(priv->cm.srq, &priv->cm.rx_wr, &bad_wr);
 	if (unlikely(ret)) {
 		ipoib_warn(priv, "post srq failed for buf %d (%d)\n", id, ret);
-		ipoib_cm_dma_unmap_rx(priv, priv->cm.srq_ring[id].mapping);
+		ipoib_cm_dma_unmap_rx(priv, IPOIB_CM_RX_SG - 1,
+				      priv->cm.srq_ring[id].mapping);
 		dev_kfree_skb_any(priv->cm.srq_ring[id].skb);
 		priv->cm.srq_ring[id].skb = NULL;
 	}
@@ -98,8 +99,8 @@ static int ipoib_cm_post_receive(struct net_device *dev, int id)
 	return ret;
 }
 
-static int ipoib_cm_alloc_rx_skb(struct net_device *dev, int id,
-				 u64 mapping[IPOIB_CM_RX_SG])
+static struct sk_buff *ipoib_cm_alloc_rx_skb(struct net_device *dev, int id, int frags,
+					     u64 mapping[IPOIB_CM_RX_SG])
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct sk_buff *skb;
@@ -107,7 +108,7 @@ static int ipoib_cm_alloc_rx_skb(struct net_device *dev, int id,
 
 	skb = dev_alloc_skb(IPOIB_CM_HEAD_SIZE + 12);
 	if (unlikely(!skb))
-		return -ENOMEM;
+		return NULL;
 
 	/*
 	 * IPoIB adds a 4 byte header. So we need 12 more bytes to align the
@@ -119,10 +120,10 @@ static int ipoib_cm_alloc_rx_skb(struct net_device *dev, int id,
 				       DMA_FROM_DEVICE);
 	if (unlikely(ib_dma_mapping_error(priv->ca, mapping[0]))) {
 		dev_kfree_skb_any(skb);
-		return -EIO;
+		return NULL;
 	}
 
-	for (i = 0; i < IPOIB_CM_RX_SG - 1; i++) {
+	for (i = 0; i < frags; i++) {
 		struct page *page = alloc_page(GFP_ATOMIC);
 
 		if (!page)
@@ -136,7 +137,7 @@ static int ipoib_cm_alloc_rx_skb(struct net_device *dev, int id,
 	}
 
 	priv->cm.srq_ring[id].skb = skb;
-	return 0;
+	return skb;
 
 partial_error:
 
@@ -146,7 +147,7 @@ partial_error:
 		ib_dma_unmap_single(priv->ca, mapping[i + 1], PAGE_SIZE, DMA_FROM_DEVICE);
 
 	dev_kfree_skb_any(skb);
-	return -ENOMEM;
+	return NULL;
 }
 
 static struct ib_qp *ipoib_cm_create_rx_qp(struct net_device *dev,
@@ -309,7 +310,7 @@ static int ipoib_cm_rx_handler(struct ib_cm_id *cm_id,
 }
 /* Adjust length of skb with fragments to match received data */
 static void skb_put_frags(struct sk_buff *skb, unsigned int hdr_space,
-			  unsigned int length)
+			  unsigned int length, struct sk_buff *toskb)
 {
 	int i, num_frags;
 	unsigned int size;
@@ -326,7 +327,7 @@ static void skb_put_frags(struct sk_buff *skb, unsigned int hdr_space,
 
 		if (length == 0) {
 			/* don't need this page */
-			__free_page(frag->page);
+			skb_fill_page_desc(toskb, i, frag->page, 0, PAGE_SIZE);
 			--skb_shinfo(skb)->nr_frags;
 		} else {
 			size = min(length, (unsigned) PAGE_SIZE);
@@ -344,10 +345,11 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	unsigned int wr_id = wc->wr_id & ~IPOIB_CM_OP_SRQ;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *newskb;
 	struct ipoib_cm_rx *p;
 	unsigned long flags;
 	u64 mapping[IPOIB_CM_RX_SG];
+	int frags;
 
 	ipoib_dbg_data(priv, "cm recv completion: id %d, op %d, status: %d\n",
 		       wr_id, wc->opcode, wc->status);
@@ -383,7 +385,11 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 		}
 	}
 
-	if (unlikely(ipoib_cm_alloc_rx_skb(dev, wr_id, mapping))) {
+	frags = PAGE_ALIGN(wc->byte_len - min(wc->byte_len,
+					      (unsigned)IPOIB_CM_HEAD_SIZE)) / PAGE_SIZE;
+
+	newskb = ipoib_cm_alloc_rx_skb(dev, wr_id, frags, mapping);
+	if (unlikely(!newskb)) {
 		/*
 		 * If we can't allocate a new RX buffer, dump
 		 * this packet and reuse the old buffer.
@@ -393,13 +399,13 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 		goto repost;
 	}
 
-	ipoib_cm_dma_unmap_rx(priv, priv->cm.srq_ring[wr_id].mapping);
-	memcpy(priv->cm.srq_ring[wr_id].mapping, mapping, sizeof mapping);
+	ipoib_cm_dma_unmap_rx(priv, frags, priv->cm.srq_ring[wr_id].mapping);
+	memcpy(priv->cm.srq_ring[wr_id].mapping, mapping, (frags + 1) * sizeof *mapping);
 
 	ipoib_dbg_data(priv, "received %d bytes, SLID 0x%04x\n",
 		       wc->byte_len, wc->slid);
 
-	skb_put_frags(skb, IPOIB_CM_HEAD_SIZE, wc->byte_len);
+	skb_put_frags(skb, IPOIB_CM_HEAD_SIZE, wc->byte_len, newskb);
 
 	skb->protocol = ((struct ipoib_header *) skb->data)->proto;
 	skb->mac.raw = skb->data;
@@ -1193,7 +1199,8 @@ int ipoib_cm_dev_init(struct net_device *dev)
 	priv->cm.rx_wr.num_sge = IPOIB_CM_RX_SG;
 
 	for (i = 0; i < ipoib_recvq_size; ++i) {
-		if (ipoib_cm_alloc_rx_skb(dev, i, priv->cm.srq_ring[i].mapping)) {
+		if (!ipoib_cm_alloc_rx_skb(dev, i, IPOIB_CM_RX_SG - 1,
+					   priv->cm.srq_ring[i].mapping)) {
 			ipoib_warn(priv, "failed to allocate receive buffer %d\n", i);
 			ipoib_cm_dev_cleanup(dev);
 			return -ENOMEM;
@@ -1228,7 +1235,8 @@ void ipoib_cm_dev_cleanup(struct net_device *dev)
 		return;
 	for (i = 0; i < ipoib_recvq_size; ++i)
 		if (priv->cm.srq_ring[i].skb) {
-			ipoib_cm_dma_unmap_rx(priv, priv->cm.srq_ring[i].mapping);
+			ipoib_cm_dma_unmap_rx(priv, IPOIB_CM_RX_SG - 1,
+					      priv->cm.srq_ring[i].mapping);
 			dev_kfree_skb_any(priv->cm.srq_ring[i].skb);
 			priv->cm.srq_ring[i].skb = NULL;
 		}
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 18d27fd..f9dbc6f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -385,7 +385,7 @@ static void path_rec_completion(int status,
 	struct sk_buff *skb;
 	unsigned long flags;
 
-	if (pathrec)
+	if (!status)
 		ipoib_dbg(priv, "PathRec LID 0x%04x for GID " IPOIB_GID_FMT "\n",
 			  be16_to_cpu(pathrec->dlid), IPOIB_GID_ARG(pathrec->dgid));
 	else
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index b303ce6..bb2e3d5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -527,11 +527,9 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	{
 		struct ib_port_attr attr;
 
-		if (!ib_query_port(priv->ca, priv->port, &attr)) {
-			priv->local_lid  = attr.lid;
-			priv->local_rate = attr.active_speed *
-				ib_width_enum_to_int(attr.active_width);
-		} else
+		if (!ib_query_port(priv->ca, priv->port, &attr))
+			priv->local_lid = attr.lid;
+		else
 			ipoib_warn(priv, "ib_query_port failed\n");
 	}
 
