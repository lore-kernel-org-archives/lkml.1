Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYHLNri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYHLNri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbYHLNqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:46:34 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:41632 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbYHLNqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:46:33 -0400
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rolandd@cisco.com>, "of-ewg" <ewg@lists.openfabrics.org>,
       "of-general" <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "linuxppc-dev" <linuxppc-dev@ozlabs.org>
Subject: [PATCH 5/5 try2] ib/ehca: discard double CQE for one WR
Date: Tue, 12 Aug 2008 15:46:30 +0200
User-Agent: KMail/1.9.9
Cc: Stefan Roscher <stefan.roscher@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200808121546.31057.alexs@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under rare circumstances, the ehca hardware might erroneously generate
two CQEs for the same WQE, which is not compliant to the IB spec and will
cause unpredictable errors like memory being freed twice. To avoid this
problem, the driver needs to detect the second CQE and discard it.

For this purpose, introduce an array holding as many elements as the SQ of
the QP, called sq_map. Each sq_map entry stores a "reported" flag for one
WQE in the SQ. When a work request is posted to the SQ, the respective
"reported" flag is set to zero. After the arrival of a CQE, the flag is set
to 1, which allows to detect the occurence of a second CQE.

The mapping between WQE / CQE and the corresponding sq_map element is
implemented by replacing the lowest 16 Bits of the wr_id with the index in
the queue map. The original 16 Bits are stored in the sq_map entry and are
restored when the CQE is passed to the application.

Signed-off-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    9 +++++
 drivers/infiniband/hw/ehca/ehca_qes.h     |    1 
 drivers/infiniband/hw/ehca/ehca_qp.c      |   34 +++++++++++++-----
 drivers/infiniband/hw/ehca/ehca_reqs.c    |   54 +++++++++++++++++++++++-------
 4 files changed, 78 insertions(+), 20 deletions(-)

--- infiniband.git.orig/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ infiniband.git/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -139,6 +139,7 @@ static void trace_send_wr_ud(const struc
 static inline int ehca_write_swqe(struct ehca_qp *qp,
 				  struct ehca_wqe *wqe_p,
 				  const struct ib_send_wr *send_wr,
+				  u32 sq_map_idx,
 				  int hidden)
 {
 	u32 idx;
@@ -157,7 +158,11 @@ static inline int ehca_write_swqe(struct
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
@@ -381,6 +386,7 @@ static inline int post_one_send(struct e
 {
 	struct ehca_wqe *wqe_p;
 	int ret;
+	u32 sq_map_idx;
 	u64 start_offset = my_qp->ipz_squeue.current_q_offset;
 
 	/* get pointer next to free WQE */
@@ -393,8 +399,15 @@ static inline int post_one_send(struct e
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
@@ -654,8 +667,34 @@ repoll:
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
@@ -678,13 +717,6 @@ repoll:
 	} else
 		wc->status = IB_WC_SUCCESS;
 
-	read_lock(&ehca_qp_idr_lock);
-	my_qp = idr_find(&ehca_qp_idr, cqe->qp_token);
-	read_unlock(&ehca_qp_idr_lock);
-	if (!my_qp)
-		goto repoll;
-	wc->qp = &my_qp->ib_qp;
-
 	wc->byte_len = cqe->nr_bytes_transferred;
 	wc->pkey_index = cqe->pkey_index;
 	wc->slid = cqe->rlid;
--- infiniband.git.orig/drivers/infiniband/hw/ehca/ehca_classes.h
+++ infiniband.git/drivers/infiniband/hw/ehca/ehca_classes.h
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
--- infiniband.git.orig/drivers/infiniband/hw/ehca/ehca_qp.c
+++ infiniband.git/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -412,6 +412,7 @@ static struct ehca_qp *internal_create_q
 	struct ehca_shca *shca = container_of(pd->device, struct ehca_shca,
 					      ib_device);
 	struct ib_ucontext *context = NULL;
+	u32 nr_qes;
 	u64 h_ret;
 	int is_llqp = 0, has_srq = 0;
 	int qp_type, max_send_sge, max_recv_sge, ret;
@@ -715,6 +716,15 @@ static struct ehca_qp *internal_create_q
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
@@ -724,7 +734,7 @@ static struct ehca_qp *internal_create_q
 		if (ret) {
 			ehca_err(pd->device, "Couldn't initialize rqueue "
 				 "and pages ret=%i", ret);
-			goto create_qp_exit3;
+			goto create_qp_exit4;
 		}
 	}
 
@@ -770,7 +780,7 @@ static struct ehca_qp *internal_create_q
 			if (!my_qp->mod_qp_parm) {
 				ehca_err(pd->device,
 					 "Could not alloc mod_qp_parm");
-				goto create_qp_exit4;
+				goto create_qp_exit5;
 			}
 		}
 	}
@@ -780,7 +790,7 @@ static struct ehca_qp *internal_create_q
 		h_ret = ehca_define_sqp(shca, my_qp, init_attr);
 		if (h_ret != H_SUCCESS) {
 			ret = ehca2ib_return_code(h_ret);
-			goto create_qp_exit5;
+			goto create_qp_exit6;
 		}
 	}
 
@@ -789,7 +799,7 @@ static struct ehca_qp *internal_create_q
 		if (ret) {
 			ehca_err(pd->device,
 				 "Couldn't assign qp to send_cq ret=%i", ret);
-			goto create_qp_exit5;
+			goto create_qp_exit6;
 		}
 	}
 
@@ -815,22 +825,26 @@ static struct ehca_qp *internal_create_q
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
@@ -1979,8 +1993,10 @@ static int internal_destroy_qp(struct ib
 
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
--- infiniband.git.orig/drivers/infiniband/hw/ehca/ehca_qes.h
+++ infiniband.git/drivers/infiniband/hw/ehca/ehca_qes.h
@@ -213,6 +213,7 @@ struct ehca_wqe {
 #define WC_STATUS_ERROR_BIT 0x80000000
 #define WC_STATUS_REMOTE_ERROR_FLAGS 0x0000F800
 #define WC_STATUS_PURGE_BIT 0x10
+#define WC_SEND_RECEIVE_BIT 0x80
 
 struct ehca_cqe {
 	u64 work_request_id;
