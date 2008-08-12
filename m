Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYHLUzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYHLUzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYHLUzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:55:37 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:61299 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbYHLUzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:55:36 -0400
X-IronPort-AV: E=Sophos;i="4.32,197,1217808000"; 
   d="scan'208";a="64684869"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Tue, 12 Aug 2008 13:55:33 -0700
Message-ID: <adaproej6m2.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Aug 2008 20:55:33.0738 (UTC) FILETIME=[C366ECA0:01C8FCBD]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the following fixes:

Alexander Schmidt (5):
      IB/ehca: Update qp_state on cached modify_qp()
      IB/ehca: Rename goto label in ehca_poll_cq_one()
      IB/ehca: Repoll CQ on invalid opcode
      IB/ehca: Check idr_find() return value
      IB/ehca: Discard double CQE for one WR

David J. Wilder (1):
      IPoIB/cm: Use vmalloc() to allocate rx_rings

Roland Dreier (1):
      Merge branches 'ehca' and 'ipoib' into for-linus

 drivers/infiniband/hw/ehca/ehca_classes.h |    9 ++++
 drivers/infiniband/hw/ehca/ehca_qes.h     |    1 +
 drivers/infiniband/hw/ehca/ehca_qp.c      |   48 +++++++++++++++++------
 drivers/infiniband/hw/ehca/ehca_reqs.c    |   60 ++++++++++++++++++++++------
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |   17 ++++++--
 5 files changed, 104 insertions(+), 31 deletions(-)


diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 0b0618e..1ab919f 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -156,6 +156,14 @@ struct ehca_mod_qp_parm {
 
 #define EHCA_MOD_QP_PARM_MAX 4
 
+#define QMAP_IDX_MASK 0xFFFFULL
+
+/* struct for tracking if cqes have been reported to the application */
+struct ehca_qmap_entry {
+	u16 app_wr_id;
+	u16 reported;
+};
+
 struct ehca_qp {
 	union {
 		struct ib_qp ib_qp;
@@ -165,6 +173,7 @@ struct ehca_qp {
 	enum ehca_ext_qp_type ext_type;
 	enum ib_qp_state state;
 	struct ipz_queue ipz_squeue;
+	struct ehca_qmap_entry *sq_map;
 	struct ipz_queue ipz_rqueue;
 	struct h_galpas galpas;
 	u32 qkey;
diff --git a/drivers/infiniband/hw/ehca/ehca_qes.h b/drivers/infiniband/hw/ehca/ehca_qes.h
index 8188030..5d28e3e 100644
--- a/drivers/infiniband/hw/ehca/ehca_qes.h
+++ b/drivers/infiniband/hw/ehca/ehca_qes.h
@@ -213,6 +213,7 @@ struct ehca_wqe {
 #define WC_STATUS_ERROR_BIT 0x80000000
 #define WC_STATUS_REMOTE_ERROR_FLAGS 0x0000F800
 #define WC_STATUS_PURGE_BIT 0x10
+#define WC_SEND_RECEIVE_BIT 0x80
 
 struct ehca_cqe {
 	u64 work_request_id;
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index ea13efd..b6bcee0 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -412,6 +412,7 @@ static struct ehca_qp *internal_create_qp(
 	struct ehca_shca *shca = container_of(pd->device, struct ehca_shca,
 					      ib_device);
 	struct ib_ucontext *context = NULL;
+	u32 nr_qes;
 	u64 h_ret;
 	int is_llqp = 0, has_srq = 0;
 	int qp_type, max_send_sge, max_recv_sge, ret;
@@ -715,6 +716,15 @@ static struct ehca_qp *internal_create_qp(
 				 "and pages ret=%i", ret);
 			goto create_qp_exit2;
 		}
+		nr_qes = my_qp->ipz_squeue.queue_length /
+			 my_qp->ipz_squeue.qe_size;
+		my_qp->sq_map = vmalloc(nr_qes *
+					sizeof(struct ehca_qmap_entry));
+		if (!my_qp->sq_map) {
+			ehca_err(pd->device, "Couldn't allocate squeue "
+				 "map ret=%i", ret);
+			goto create_qp_exit3;
+		}
 	}
 
 	if (HAS_RQ(my_qp)) {
@@ -724,7 +734,7 @@ static struct ehca_qp *internal_create_qp(
 		if (ret) {
 			ehca_err(pd->device, "Couldn't initialize rqueue "
 				 "and pages ret=%i", ret);
-			goto create_qp_exit3;
+			goto create_qp_exit4;
 		}
 	}
 
@@ -770,7 +780,7 @@ static struct ehca_qp *internal_create_qp(
 			if (!my_qp->mod_qp_parm) {
 				ehca_err(pd->device,
 					 "Could not alloc mod_qp_parm");
-				goto create_qp_exit4;
+				goto create_qp_exit5;
 			}
 		}
 	}
@@ -780,7 +790,7 @@ static struct ehca_qp *internal_create_qp(
 		h_ret = ehca_define_sqp(shca, my_qp, init_attr);
 		if (h_ret != H_SUCCESS) {
 			ret = ehca2ib_return_code(h_ret);
-			goto create_qp_exit5;
+			goto create_qp_exit6;
 		}
 	}
 
@@ -789,7 +799,7 @@ static struct ehca_qp *internal_create_qp(
 		if (ret) {
 			ehca_err(pd->device,
 				 "Couldn't assign qp to send_cq ret=%i", ret);
-			goto create_qp_exit5;
+			goto create_qp_exit6;
 		}
 	}
 
@@ -815,22 +825,26 @@ static struct ehca_qp *internal_create_qp(
 		if (ib_copy_to_udata(udata, &resp, sizeof resp)) {
 			ehca_err(pd->device, "Copy to udata failed");
 			ret = -EINVAL;
-			goto create_qp_exit6;
+			goto create_qp_exit7;
 		}
 	}
 
 	return my_qp;
 
-create_qp_exit6:
+create_qp_exit7:
 	ehca_cq_unassign_qp(my_qp->send_cq, my_qp->real_qp_num);
 
-create_qp_exit5:
+create_qp_exit6:
 	kfree(my_qp->mod_qp_parm);
 
-create_qp_exit4:
+create_qp_exit5:
 	if (HAS_RQ(my_qp))
 		ipz_queue_dtor(my_pd, &my_qp->ipz_rqueue);
 
+create_qp_exit4:
+	if (HAS_SQ(my_qp))
+		vfree(my_qp->sq_map);
+
 create_qp_exit3:
 	if (HAS_SQ(my_qp))
 		ipz_queue_dtor(my_pd, &my_qp->ipz_squeue);
@@ -1534,8 +1548,6 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 	if (attr_mask & IB_QP_QKEY)
 		my_qp->qkey = attr->qkey;
 
-	my_qp->state = qp_new_state;
-
 modify_qp_exit2:
 	if (squeue_locked) { /* this means: sqe -> rts */
 		spin_unlock_irqrestore(&my_qp->spinlock_s, flags);
@@ -1551,6 +1563,8 @@ modify_qp_exit1:
 int ehca_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 		   struct ib_udata *udata)
 {
+	int ret = 0;
+
 	struct ehca_shca *shca = container_of(ibqp->device, struct ehca_shca,
 					      ib_device);
 	struct ehca_qp *my_qp = container_of(ibqp, struct ehca_qp, ib_qp);
@@ -1597,12 +1611,18 @@ int ehca_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 				 attr->qp_state, my_qp->init_attr.port_num,
 				 ibqp->qp_type);
 			spin_unlock_irqrestore(&sport->mod_sqp_lock, flags);
-			return 0;
+			goto out;
 		}
 		spin_unlock_irqrestore(&sport->mod_sqp_lock, flags);
 	}
 
-	return internal_modify_qp(ibqp, attr, attr_mask, 0);
+	ret = internal_modify_qp(ibqp, attr, attr_mask, 0);
+
+out:
+	if ((ret == 0) && (attr_mask & IB_QP_STATE))
+		my_qp->state = attr->qp_state;
+
+	return ret;
 }
 
 void ehca_recover_sqp(struct ib_qp *sqp)
@@ -1973,8 +1993,10 @@ static int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
 
 	if (HAS_RQ(my_qp))
 		ipz_queue_dtor(my_pd, &my_qp->ipz_rqueue);
-	if (HAS_SQ(my_qp))
+	if (HAS_SQ(my_qp)) {
 		ipz_queue_dtor(my_pd, &my_qp->ipz_squeue);
+		vfree(my_qp->sq_map);
+	}
 	kmem_cache_free(qp_cache, my_qp);
 	atomic_dec(&shca->num_qps);
 	return 0;
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index 898c8b5..4426d82 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -139,6 +139,7 @@ static void trace_send_wr_ud(const struct ib_send_wr *send_wr)
 static inline int ehca_write_swqe(struct ehca_qp *qp,
 				  struct ehca_wqe *wqe_p,
 				  const struct ib_send_wr *send_wr,
+				  u32 sq_map_idx,
 				  int hidden)
 {
 	u32 idx;
@@ -157,7 +158,11 @@ static inline int ehca_write_swqe(struct ehca_qp *qp,
 	/* clear wqe header until sglist */
 	memset(wqe_p, 0, offsetof(struct ehca_wqe, u.ud_av.sg_list));
 
-	wqe_p->work_request_id = send_wr->wr_id;
+	wqe_p->work_request_id = send_wr->wr_id & ~QMAP_IDX_MASK;
+	wqe_p->work_request_id |= sq_map_idx & QMAP_IDX_MASK;
+
+	qp->sq_map[sq_map_idx].app_wr_id = send_wr->wr_id & QMAP_IDX_MASK;
+	qp->sq_map[sq_map_idx].reported = 0;
 
 	switch (send_wr->opcode) {
 	case IB_WR_SEND:
@@ -381,6 +386,7 @@ static inline int post_one_send(struct ehca_qp *my_qp,
 {
 	struct ehca_wqe *wqe_p;
 	int ret;
+	u32 sq_map_idx;
 	u64 start_offset = my_qp->ipz_squeue.current_q_offset;
 
 	/* get pointer next to free WQE */
@@ -393,8 +399,15 @@ static inline int post_one_send(struct ehca_qp *my_qp,
 			 "qp_num=%x", my_qp->ib_qp.qp_num);
 		return -ENOMEM;
 	}
+
+	/*
+	 * Get the index of the WQE in the send queue. The same index is used
+	 * for writing into the sq_map.
+	 */
+	sq_map_idx = start_offset / my_qp->ipz_squeue.qe_size;
+
 	/* write a SEND WQE into the QUEUE */
-	ret = ehca_write_swqe(my_qp, wqe_p, cur_send_wr, hidden);
+	ret = ehca_write_swqe(my_qp, wqe_p, cur_send_wr, sq_map_idx, hidden);
 	/*
 	 * if something failed,
 	 * reset the free entry pointer to the start value
@@ -589,7 +602,7 @@ static inline int ehca_poll_cq_one(struct ib_cq *cq, struct ib_wc *wc)
 	struct ehca_qp *my_qp;
 	int cqe_count = 0, is_error;
 
-poll_cq_one_read_cqe:
+repoll:
 	cqe = (struct ehca_cqe *)
 		ipz_qeit_get_inc_valid(&my_cq->ipz_queue);
 	if (!cqe) {
@@ -617,7 +630,7 @@ poll_cq_one_read_cqe:
 			ehca_dmp(cqe, 64, "cq_num=%x qp_num=%x",
 				 my_cq->cq_number, cqe->local_qp_number);
 			/* ignore this purged cqe */
-			goto poll_cq_one_read_cqe;
+			goto repoll;
 		}
 		spin_lock_irqsave(&qp->spinlock_s, flags);
 		purgeflag = qp->sqerr_purgeflag;
@@ -636,7 +649,7 @@ poll_cq_one_read_cqe:
 			 * that caused sqe and turn off purge flag
 			 */
 			qp->sqerr_purgeflag = 0;
-			goto poll_cq_one_read_cqe;
+			goto repoll;
 		}
 	}
 
@@ -654,8 +667,34 @@ poll_cq_one_read_cqe:
 			 my_cq, my_cq->cq_number);
 	}
 
-	/* we got a completion! */
-	wc->wr_id = cqe->work_request_id;
+	read_lock(&ehca_qp_idr_lock);
+	my_qp = idr_find(&ehca_qp_idr, cqe->qp_token);
+	read_unlock(&ehca_qp_idr_lock);
+	if (!my_qp)
+		goto repoll;
+	wc->qp = &my_qp->ib_qp;
+
+	if (!(cqe->w_completion_flags & WC_SEND_RECEIVE_BIT)) {
+		struct ehca_qmap_entry *qmap_entry;
+		/*
+		 * We got a send completion and need to restore the original
+		 * wr_id.
+		 */
+		qmap_entry = &my_qp->sq_map[cqe->work_request_id &
+					    QMAP_IDX_MASK];
+
+		if (qmap_entry->reported) {
+			ehca_warn(cq->device, "Double cqe on qp_num=%#x",
+				  my_qp->real_qp_num);
+			/* found a double cqe, discard it and read next one */
+			goto repoll;
+		}
+		wc->wr_id = cqe->work_request_id & ~QMAP_IDX_MASK;
+		wc->wr_id |= qmap_entry->app_wr_id;
+		qmap_entry->reported = 1;
+	} else
+		/* We got a receive completion. */
+		wc->wr_id = cqe->work_request_id;
 
 	/* eval ib_wc_opcode */
 	wc->opcode = ib_wc_opcode[cqe->optype]-1;
@@ -667,7 +706,7 @@ poll_cq_one_read_cqe:
 		ehca_dmp(cqe, 64, "ehca_cq=%p cq_num=%x",
 			 my_cq, my_cq->cq_number);
 		/* update also queue adder to throw away this entry!!! */
-		goto poll_cq_one_exit0;
+		goto repoll;
 	}
 
 	/* eval ib_wc_status */
@@ -678,11 +717,6 @@ poll_cq_one_read_cqe:
 	} else
 		wc->status = IB_WC_SUCCESS;
 
-	read_lock(&ehca_qp_idr_lock);
-	my_qp = idr_find(&ehca_qp_idr, cqe->qp_token);
-	wc->qp = &my_qp->ib_qp;
-	read_unlock(&ehca_qp_idr_lock);
-
 	wc->byte_len = cqe->nr_bytes_transferred;
 	wc->pkey_index = cqe->pkey_index;
 	wc->slid = cqe->rlid;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 7ebc400..341ffed 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -202,7 +202,7 @@ static void ipoib_cm_free_rx_ring(struct net_device *dev,
 			dev_kfree_skb_any(rx_ring[i].skb);
 		}
 
-	kfree(rx_ring);
+	vfree(rx_ring);
 }
 
 static void ipoib_cm_start_rx_drain(struct ipoib_dev_priv *priv)
@@ -352,9 +352,14 @@ static int ipoib_cm_nonsrq_init_rx(struct net_device *dev, struct ib_cm_id *cm_i
 	int ret;
 	int i;
 
-	rx->rx_ring = kcalloc(ipoib_recvq_size, sizeof *rx->rx_ring, GFP_KERNEL);
-	if (!rx->rx_ring)
+	rx->rx_ring = vmalloc(ipoib_recvq_size * sizeof *rx->rx_ring);
+	if (!rx->rx_ring) {
+		printk(KERN_WARNING "%s: failed to allocate CM non-SRQ ring (%d entries)\n",
+		       priv->ca->name, ipoib_recvq_size);
 		return -ENOMEM;
+	}
+
+	memset(rx->rx_ring, 0, ipoib_recvq_size * sizeof *rx->rx_ring);
 
 	t = kmalloc(sizeof *t, GFP_KERNEL);
 	if (!t) {
@@ -1494,14 +1499,16 @@ static void ipoib_cm_create_srq(struct net_device *dev, int max_sge)
 		return;
 	}
 
-	priv->cm.srq_ring = kzalloc(ipoib_recvq_size * sizeof *priv->cm.srq_ring,
-				    GFP_KERNEL);
+	priv->cm.srq_ring = vmalloc(ipoib_recvq_size * sizeof *priv->cm.srq_ring);
 	if (!priv->cm.srq_ring) {
 		printk(KERN_WARNING "%s: failed to allocate CM SRQ ring (%d entries)\n",
 		       priv->ca->name, ipoib_recvq_size);
 		ib_destroy_srq(priv->cm.srq);
 		priv->cm.srq = NULL;
+		return;
 	}
+
+	memset(priv->cm.srq_ring, 0, ipoib_recvq_size * sizeof *priv->cm.srq_ring);
 }
 
 int ipoib_cm_dev_init(struct net_device *dev)
