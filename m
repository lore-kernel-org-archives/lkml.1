Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbXGINZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbXGINZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXGINZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:25:17 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:62634 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbXGINZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:25:14 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 04/13] IB/ehca: add Shared Receive Queue support
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707091502.22407.fenkes@de.ibm.com>
In-Reply-To: <200707091502.22407.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1748
Date: Mon, 9 Jul 2007 15:25:10 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707091525.11777.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Support SRQs on eHCA2. Since an SRQ is a QP for eHCA2, a lot of code
(structures, create, destroy, post_recv) can be shared between QP and SRQ.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h         |   26 +-
 drivers/infiniband/hw/ehca/ehca_classes_pSeries.h |    4 +-
 drivers/infiniband/hw/ehca/ehca_iverbs.h          |   15 +
 drivers/infiniband/hw/ehca/ehca_main.c            |   16 +-
 drivers/infiniband/hw/ehca/ehca_qp.c              |  451 +++++++++++++++++----
 drivers/infiniband/hw/ehca/ehca_reqs.c            |   47 ++-
 drivers/infiniband/hw/ehca/ehca_uverbs.c          |    4 +-
 drivers/infiniband/hw/ehca/hcp_if.c               |   23 +-
 drivers/infiniband/hw/ehca/hipz_hw.h              |    1 +
 9 files changed, 480 insertions(+), 107 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 6e75db6..9d689ae 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -5,6 +5,7 @@
  *
  *  Authors: Heiko J Schick <schickhj@de.ibm.com>
  *           Christoph Raisch <raisch@de.ibm.com>
+ *           Joachim Fenkes <fenkes@de.ibm.com>
  *
  *  Copyright (c) 2005 IBM Corporation
  *
@@ -117,9 +118,20 @@ struct ehca_pd {
 	u32 ownpid;
 };
 
+enum ehca_ext_qp_type {
+	EQPT_NORMAL    = 0,
+	EQPT_LLQP      = 1,
+	EQPT_SRQBASE   = 2,
+	EQPT_SRQ       = 3,
+};
+
 struct ehca_qp {
-	struct ib_qp ib_qp;
+	union {
+		struct ib_qp ib_qp;
+		struct ib_srq ib_srq;
+	};
 	u32 qp_type;
+	enum ehca_ext_qp_type ext_type;
 	struct ipz_queue ipz_squeue;
 	struct ipz_queue ipz_rqueue;
 	struct h_galpas galpas;
@@ -142,6 +154,10 @@ struct ehca_qp {
 	u32 mm_count_galpa;
 };
 
+#define IS_SRQ(qp) (qp->ext_type == EQPT_SRQ)
+#define HAS_SQ(qp) (qp->ext_type != EQPT_SRQ)
+#define HAS_RQ(qp) (qp->ext_type != EQPT_SRQBASE)
+
 /* must be power of 2 */
 #define QP_HASHTAB_LEN 8
 
@@ -307,6 +323,7 @@ struct ehca_create_qp_resp {
 	u32 qp_num;
 	u32 token;
 	u32 qp_type;
+	u32 ext_type;
 	u32 qkey;
 	/* qp_num assigned by ehca: sqp0/1 may have got different numbers */
 	u32 real_qp_num;
@@ -329,13 +346,6 @@ enum ehca_service_type {
 	ST_UD  = 3,
 };
 
-enum ehca_ext_qp_type {
-	EQPT_NORMAL    = 0,
-	EQPT_LLQP      = 1,
-	EQPT_SRQBASE   = 2,
-	EQPT_SRQ       = 3,
-};
-
 enum ehca_ll_comp_flags {
 	LLQP_SEND_COMP = 0x20,
 	LLQP_RECV_COMP = 0x40,
diff --git a/drivers/infiniband/hw/ehca/ehca_classes_pSeries.h b/drivers/infiniband/hw/ehca/ehca_classes_pSeries.h
index 5665f21..fb3df5c 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes_pSeries.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes_pSeries.h
@@ -228,8 +228,8 @@ struct hcp_modify_qp_control_block {
 #define MQPCB_QP_NUMBER                         EHCA_BMASK_IBM(8,31)
 #define MQPCB_MASK_QP_ENABLE                    EHCA_BMASK_IBM(48,48)
 #define MQPCB_QP_ENABLE                         EHCA_BMASK_IBM(31,31)
-#define MQPCB_MASK_CURR_SQR_LIMIT               EHCA_BMASK_IBM(49,49)
-#define MQPCB_CURR_SQR_LIMIT                    EHCA_BMASK_IBM(15,31)
+#define MQPCB_MASK_CURR_SRQ_LIMIT               EHCA_BMASK_IBM(49,49)
+#define MQPCB_CURR_SRQ_LIMIT                    EHCA_BMASK_IBM(16,31)
 #define MQPCB_MASK_QP_AFF_ASYN_EV_LOG_REG       EHCA_BMASK_IBM(50,50)
 #define MQPCB_MASK_SHARED_RQ_HNDL               EHCA_BMASK_IBM(51,51)
 
diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/infiniband/hw/ehca/ehca_iverbs.h
index 37e7fe0..fd84a80 100644
--- a/drivers/infiniband/hw/ehca/ehca_iverbs.h
+++ b/drivers/infiniband/hw/ehca/ehca_iverbs.h
@@ -154,6 +154,21 @@ int ehca_post_send(struct ib_qp *qp, struct ib_send_wr *send_wr,
 int ehca_post_recv(struct ib_qp *qp, struct ib_recv_wr *recv_wr,
 		   struct ib_recv_wr **bad_recv_wr);
 
+int ehca_post_srq_recv(struct ib_srq *srq,
+		       struct ib_recv_wr *recv_wr,
+		       struct ib_recv_wr **bad_recv_wr);
+
+struct ib_srq *ehca_create_srq(struct ib_pd *pd,
+			       struct ib_srq_init_attr *init_attr,
+			       struct ib_udata *udata);
+
+int ehca_modify_srq(struct ib_srq *srq, struct ib_srq_attr *attr,
+		    enum ib_srq_attr_mask attr_mask, struct ib_udata *udata);
+
+int ehca_query_srq(struct ib_srq *srq, struct ib_srq_attr *srq_attr);
+
+int ehca_destroy_srq(struct ib_srq *srq);
+
 u64 ehca_define_sqp(struct ehca_shca *shca, struct ehca_qp *ibqp,
 		    struct ib_qp_init_attr *qp_init_attr);
 
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index befbb9c..9bd749c 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -343,7 +343,7 @@ int ehca_init_device(struct ehca_shca *shca)
 	strlcpy(shca->ib_device.name, "ehca%d", IB_DEVICE_NAME_MAX);
 	shca->ib_device.owner               = THIS_MODULE;
 
-	shca->ib_device.uverbs_abi_ver	    = 6;
+	shca->ib_device.uverbs_abi_ver	    = 7;
 	shca->ib_device.uverbs_cmd_mask	    =
 		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT)		|
 		(1ull << IB_USER_VERBS_CMD_QUERY_DEVICE)	|
@@ -411,6 +411,20 @@ int ehca_init_device(struct ehca_shca *shca)
 	/* shca->ib_device.process_mad	    = ehca_process_mad;	    */
 	shca->ib_device.mmap		    = ehca_mmap;
 
+	if (EHCA_BMASK_GET(HCA_CAP_SRQ, shca->hca_cap)) {
+		shca->ib_device.uverbs_cmd_mask |=
+			(1ull << IB_USER_VERBS_CMD_CREATE_SRQ) |
+			(1ull << IB_USER_VERBS_CMD_MODIFY_SRQ) |
+			(1ull << IB_USER_VERBS_CMD_QUERY_SRQ) |
+			(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ);
+
+		shca->ib_device.create_srq          = ehca_create_srq;
+		shca->ib_device.modify_srq          = ehca_modify_srq;
+		shca->ib_device.query_srq           = ehca_query_srq;
+		shca->ib_device.destroy_srq         = ehca_destroy_srq;
+		shca->ib_device.post_srq_recv       = ehca_post_srq_recv;
+	}
+
 	return ret;
 }
 
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index ec1d555..9486a44 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -3,7 +3,9 @@
  *
  *  QP functions
  *
- *  Authors: Waleri Fomin <fomin@de.ibm.com>
+ *  Authors: Joachim Fenkes <fenkes@de.ibm.com>
+ *           Stefan Roscher <stefan.roscher@de.ibm.com>
+ *           Waleri Fomin <fomin@de.ibm.com>
  *           Hoang-Nam Nguyen <hnguyen@de.ibm.com>
  *           Reinhard Ernst <rernst@de.ibm.com>
  *           Heiko J Schick <schickhj@de.ibm.com>
@@ -261,6 +263,19 @@ static inline int ibqptype2servicetype(enum ib_qp_type ibqptype)
 }
 
 /*
+ * init userspace queue info from ipz_queue data
+ */
+static inline void queue2resp(struct ipzu_queue_resp *resp,
+			      struct ipz_queue *queue)
+{
+	resp->qe_size = queue->qe_size;
+	resp->act_nr_of_sg = queue->act_nr_of_sg;
+	resp->queue_length = queue->queue_length;
+	resp->pagesize = queue->pagesize;
+	resp->toggle_state = queue->toggle_state;
+}
+
+/*
  * init_qp_queue initializes/constructs r/squeue and registers queue pages.
  */
 static inline int init_qp_queue(struct ehca_shca *shca,
@@ -338,11 +353,17 @@ init_qp_queue1:
 	return ret;
 }
 
-struct ib_qp *ehca_create_qp(struct ib_pd *pd,
-			     struct ib_qp_init_attr *init_attr,
-			     struct ib_udata *udata)
+/*
+ * Create an ib_qp struct that is either a QP or an SRQ, depending on
+ * the value of the is_srq parameter. If init_attr and srq_init_attr share
+ * fields, the field out of init_attr is used.
+ */
+struct ehca_qp *internal_create_qp(struct ib_pd *pd,
+				   struct ib_qp_init_attr *init_attr,
+				   struct ib_srq_init_attr *srq_init_attr,
+				   struct ib_udata *udata, int is_srq)
 {
-	static int da_rc_msg_size[]={ 128, 256, 512, 1024, 2048, 4096 };
+	static int da_rc_msg_size[] = { 128, 256, 512, 1024, 2048, 4096 };
 	static int da_ud_sq_msg_size[]={ 128, 384, 896, 1920, 3968 };
 	struct ehca_qp *my_qp;
 	struct ehca_pd *my_pd = container_of(pd, struct ehca_pd, ib_pd);
@@ -355,7 +376,7 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 
 	/* h_call's out parameters */
 	struct ehca_alloc_qp_parms parms;
-	u32 swqe_size = 0, rwqe_size = 0;
+	u32 swqe_size = 0, rwqe_size = 0, ib_qp_num;
 	unsigned long flags;
 
 	memset(&parms, 0, sizeof(parms));
@@ -376,13 +397,34 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 	}
 	qp_type &= 0x1F;
 
-	/* check for SRQ */
-	has_srq = !!(init_attr->srq);
+	/* handle SRQ base QPs */
+	if (init_attr->srq) {
+		struct ehca_qp *my_srq =
+			container_of(init_attr->srq, struct ehca_qp, ib_srq);
+
+		has_srq = 1;
+		parms.ext_type = EQPT_SRQBASE;
+		parms.srq_qpn = my_srq->real_qp_num;
+		parms.srq_token = my_srq->token;
+	}
+
 	if (is_llqp && has_srq) {
 		ehca_err(pd->device, "LLQPs can't have an SRQ");
 		return ERR_PTR(-EINVAL);
 	}
 
+	/* handle SRQs */
+	if (is_srq) {
+		parms.ext_type = EQPT_SRQ;
+		parms.srq_limit = srq_init_attr->attr.srq_limit;
+		if (init_attr->cap.max_recv_sge > 3) {
+			ehca_err(pd->device, "no more than three SGEs "
+				 "supported for SRQ  pd=%p  max_sge=%x",
+				 pd, init_attr->cap.max_recv_sge);
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
 	/* check QP type */
 	if (qp_type != IB_QPT_UD &&
 	    qp_type != IB_QPT_UC &&
@@ -423,11 +465,15 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 
 	spin_lock_init(&my_qp->spinlock_s);
 	spin_lock_init(&my_qp->spinlock_r);
+	my_qp->qp_type = qp_type;
+	my_qp->ext_type = parms.ext_type;
 
-	my_qp->recv_cq =
-		container_of(init_attr->recv_cq, struct ehca_cq, ib_cq);
-	my_qp->send_cq =
-		container_of(init_attr->send_cq, struct ehca_cq, ib_cq);
+	if (init_attr->recv_cq)
+		my_qp->recv_cq =
+			container_of(init_attr->recv_cq, struct ehca_cq, ib_cq);
+	if (init_attr->send_cq)
+		my_qp->send_cq =
+			container_of(init_attr->send_cq, struct ehca_cq, ib_cq);
 
 	do {
 		if (!idr_pre_get(&ehca_qp_idr, GFP_KERNEL)) {
@@ -471,8 +517,10 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 	parms.token = my_qp->token;
 	parms.eq_handle = shca->eq.ipz_eq_handle;
 	parms.pd = my_pd->fw_pd;
-	parms.send_cq_handle = my_qp->send_cq->ipz_cq_handle;
-	parms.recv_cq_handle = my_qp->recv_cq->ipz_cq_handle;
+	if (my_qp->send_cq)
+		parms.send_cq_handle = my_qp->send_cq->ipz_cq_handle;
+	if (my_qp->recv_cq)
+		parms.recv_cq_handle = my_qp->recv_cq->ipz_cq_handle;
 
 	parms.max_send_wr = init_attr->cap.max_send_wr;
 	parms.max_recv_wr = init_attr->cap.max_recv_wr;
@@ -487,7 +535,7 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 		goto create_qp_exit1;
 	}
 
-	my_qp->ib_qp.qp_num = my_qp->real_qp_num = parms.real_qp_num;
+	ib_qp_num = my_qp->real_qp_num = parms.real_qp_num;
 	my_qp->ipz_qp_handle = parms.qp_handle;
 	my_qp->galpas = parms.galpas;
 
@@ -535,7 +583,7 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 			parms.act_nr_recv_wqes = init_attr->cap.max_recv_wr;
 			parms.act_nr_send_sges = init_attr->cap.max_send_sge;
 			parms.act_nr_recv_sges = init_attr->cap.max_recv_sge;
-			my_qp->ib_qp.qp_num = (qp_type == IB_QPT_SMI) ? 0 : 1;
+			ib_qp_num = (qp_type == IB_QPT_SMI) ? 0 : 1;
 		}
 
 		break;
@@ -545,36 +593,51 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 	}
 
 	/* initialize r/squeue and register queue pages */
-	ret = init_qp_queue(shca, my_qp, &my_qp->ipz_squeue, 0,
-			    has_srq ? H_SUCCESS : H_PAGE_REGISTERED,
-			    parms.nr_sq_pages, swqe_size,
-			    parms.act_nr_send_sges);
-	if (ret) {
-		ehca_err(pd->device,
-			 "Couldn't initialize squeue and pages ret=%x", ret);
-		goto create_qp_exit2;
+	if (HAS_SQ(my_qp)) {
+		ret = init_qp_queue(
+			shca, my_qp, &my_qp->ipz_squeue, 0,
+			HAS_RQ(my_qp) ? H_PAGE_REGISTERED : H_SUCCESS,
+			parms.nr_sq_pages, swqe_size,
+			parms.act_nr_send_sges);
+		if (ret) {
+			ehca_err(pd->device, "Couldn't initialize squeue "
+				 "and pages  ret=%x", ret);
+			goto create_qp_exit2;
+		}
 	}
 
-	ret = init_qp_queue(shca, my_qp, &my_qp->ipz_rqueue, 1, H_SUCCESS,
-			    parms.nr_rq_pages, rwqe_size,
-			    parms.act_nr_recv_sges);
-	if (ret) {
-		ehca_err(pd->device,
-			 "Couldn't initialize rqueue and pages ret=%x", ret);
-		goto create_qp_exit3;
+	if (HAS_RQ(my_qp)) {
+		ret = init_qp_queue(
+			shca, my_qp, &my_qp->ipz_rqueue, 1,
+			H_SUCCESS, parms.nr_rq_pages, rwqe_size,
+			parms.act_nr_recv_sges);
+		if (ret) {
+			ehca_err(pd->device, "Couldn't initialize rqueue "
+				 "and pages ret=%x", ret);
+			goto create_qp_exit3;
+		}
 	}
 
-	my_qp->ib_qp.pd = &my_pd->ib_pd;
-	my_qp->ib_qp.device = my_pd->ib_pd.device;
+	if (is_srq) {
+		my_qp->ib_srq.pd = &my_pd->ib_pd;
+		my_qp->ib_srq.device = my_pd->ib_pd.device;
 
-	my_qp->ib_qp.recv_cq = init_attr->recv_cq;
-	my_qp->ib_qp.send_cq = init_attr->send_cq;
+		my_qp->ib_srq.srq_context = init_attr->qp_context;
+		my_qp->ib_srq.event_handler = init_attr->event_handler;
+	} else {
+		my_qp->ib_qp.qp_num = ib_qp_num;
+		my_qp->ib_qp.pd = &my_pd->ib_pd;
+		my_qp->ib_qp.device = my_pd->ib_pd.device;
+
+		my_qp->ib_qp.recv_cq = init_attr->recv_cq;
+		my_qp->ib_qp.send_cq = init_attr->send_cq;
 
-	my_qp->ib_qp.qp_type = my_qp->qp_type = qp_type;
-	my_qp->ib_qp.srq = init_attr->srq;
+		my_qp->ib_qp.qp_type = qp_type;
+		my_qp->ib_qp.srq = init_attr->srq;
 
-	my_qp->ib_qp.qp_context = init_attr->qp_context;
-	my_qp->ib_qp.event_handler = init_attr->event_handler;
+		my_qp->ib_qp.qp_context = init_attr->qp_context;
+		my_qp->ib_qp.event_handler = init_attr->event_handler;
+	}
 
 	init_attr->cap.max_inline_data = 0; /* not supported yet */
 	init_attr->cap.max_recv_sge = parms.act_nr_recv_sges;
@@ -593,41 +656,32 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 			goto create_qp_exit4;
 		}
 	}
-	if (init_attr->send_cq) {
-		struct ehca_cq *cq = container_of(init_attr->send_cq,
-						  struct ehca_cq, ib_cq);
-		ret = ehca_cq_assign_qp(cq, my_qp);
+
+	if (my_qp->send_cq) {
+		ret = ehca_cq_assign_qp(my_qp->send_cq, my_qp);
 		if (ret) {
 			ehca_err(pd->device, "Couldn't assign qp to send_cq ret=%x",
 				 ret);
 			goto create_qp_exit4;
 		}
-		my_qp->send_cq = cq;
 	}
+
 	/* copy queues, galpa data to user space */
 	if (context && udata) {
-		struct ipz_queue *ipz_rqueue = &my_qp->ipz_rqueue;
-		struct ipz_queue *ipz_squeue = &my_qp->ipz_squeue;
 		struct ehca_create_qp_resp resp;
 		memset(&resp, 0, sizeof(resp));
 
 		resp.qp_num = my_qp->real_qp_num;
 		resp.token = my_qp->token;
 		resp.qp_type = my_qp->qp_type;
+		resp.ext_type = my_qp->ext_type;
 		resp.qkey = my_qp->qkey;
 		resp.real_qp_num = my_qp->real_qp_num;
-		/* rqueue properties */
-		resp.ipz_rqueue.qe_size = ipz_rqueue->qe_size;
-		resp.ipz_rqueue.act_nr_of_sg = ipz_rqueue->act_nr_of_sg;
-		resp.ipz_rqueue.queue_length = ipz_rqueue->queue_length;
-		resp.ipz_rqueue.pagesize = ipz_rqueue->pagesize;
-		resp.ipz_rqueue.toggle_state = ipz_rqueue->toggle_state;
-		/* squeue properties */
-		resp.ipz_squeue.qe_size = ipz_squeue->qe_size;
-		resp.ipz_squeue.act_nr_of_sg = ipz_squeue->act_nr_of_sg;
-		resp.ipz_squeue.queue_length = ipz_squeue->queue_length;
-		resp.ipz_squeue.pagesize = ipz_squeue->pagesize;
-		resp.ipz_squeue.toggle_state = ipz_squeue->toggle_state;
+		if (HAS_SQ(my_qp))
+			queue2resp(&resp.ipz_squeue, &my_qp->ipz_squeue);
+		if (HAS_RQ(my_qp))
+			queue2resp(&resp.ipz_rqueue, &my_qp->ipz_rqueue);
+
 		if (ib_copy_to_udata(udata, &resp, sizeof resp)) {
 			ehca_err(pd->device, "Copy to udata failed");
 			ret = -EINVAL;
@@ -635,13 +689,15 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 		}
 	}
 
-	return &my_qp->ib_qp;
+	return my_qp;
 
 create_qp_exit4:
-	ipz_queue_dtor(&my_qp->ipz_rqueue);
+	if (HAS_RQ(my_qp))
+		ipz_queue_dtor(&my_qp->ipz_rqueue);
 
 create_qp_exit3:
-	ipz_queue_dtor(&my_qp->ipz_squeue);
+	if (HAS_SQ(my_qp))
+		ipz_queue_dtor(&my_qp->ipz_squeue);
 
 create_qp_exit2:
 	hipz_h_destroy_qp(shca->ipz_hca_handle, my_qp);
@@ -656,6 +712,114 @@ create_qp_exit0:
 	return ERR_PTR(ret);
 }
 
+struct ib_qp *ehca_create_qp(struct ib_pd *pd,
+			     struct ib_qp_init_attr *qp_init_attr,
+			     struct ib_udata *udata)
+{
+	struct ehca_qp *ret;
+
+	ret = internal_create_qp(pd, qp_init_attr, NULL, udata, 0);
+	return IS_ERR(ret) ? (struct ib_qp*)ret : &ret->ib_qp;
+}
+
+int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
+			struct ib_uobject *uobject);
+
+struct ib_srq *ehca_create_srq(struct ib_pd *pd,
+			       struct ib_srq_init_attr *srq_init_attr,
+			       struct ib_udata *udata)
+{
+	struct ib_qp_init_attr qp_init_attr;
+	struct ehca_qp *my_qp;
+	struct ib_srq *ret;
+	struct ehca_shca *shca = container_of(pd->device, struct ehca_shca,
+					      ib_device);
+	struct hcp_modify_qp_control_block *mqpcb;
+	u64 hret, update_mask;
+
+	/* For common attributes, internal_create_qp() takes its info
+	 * out of qp_init_attr, so copy all common attrs there.
+	 */
+	memset(&qp_init_attr, 0, sizeof(qp_init_attr));
+	qp_init_attr.event_handler = srq_init_attr->event_handler;
+	qp_init_attr.qp_context = srq_init_attr->srq_context;
+	qp_init_attr.sq_sig_type = IB_SIGNAL_ALL_WR;
+	qp_init_attr.qp_type = IB_QPT_RC;
+	qp_init_attr.cap.max_recv_wr = srq_init_attr->attr.max_wr;
+	qp_init_attr.cap.max_recv_sge = srq_init_attr->attr.max_sge;
+
+	my_qp = internal_create_qp(pd, &qp_init_attr, srq_init_attr, udata, 1);
+	if (IS_ERR(my_qp))
+		return (struct ib_srq*)my_qp;
+
+	/* copy back return values */
+	srq_init_attr->attr.max_wr = qp_init_attr.cap.max_recv_wr;
+	srq_init_attr->attr.max_sge = qp_init_attr.cap.max_recv_sge;
+
+	/* drive SRQ into RTR state */
+	mqpcb = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
+	if (!mqpcb) {
+		ehca_err(pd->device, "Could not get zeroed page for mqpcb "
+			 "ehca_qp=%p qp_num=%x ", my_qp, my_qp->real_qp_num);
+		ret = ERR_PTR(-ENOMEM);
+		goto create_srq1;
+	}
+
+	mqpcb->qp_state = EHCA_QPS_INIT;
+	mqpcb->prim_phys_port = 1;
+	update_mask = EHCA_BMASK_SET(MQPCB_MASK_QP_STATE, 1);
+	hret = hipz_h_modify_qp(shca->ipz_hca_handle,
+				my_qp->ipz_qp_handle,
+				&my_qp->pf,
+				update_mask,
+				mqpcb, my_qp->galpas.kernel);
+	if (hret != H_SUCCESS) {
+		ehca_err(pd->device, "Could not modify SRQ to INIT"
+			 "ehca_qp=%p qp_num=%x hret=%lx",
+			 my_qp, my_qp->real_qp_num, hret);
+		goto create_srq2;
+	}
+
+	mqpcb->qp_enable = 1;
+	update_mask = EHCA_BMASK_SET(MQPCB_MASK_QP_ENABLE, 1);
+	hret = hipz_h_modify_qp(shca->ipz_hca_handle,
+				my_qp->ipz_qp_handle,
+				&my_qp->pf,
+				update_mask,
+				mqpcb, my_qp->galpas.kernel);
+	if (hret != H_SUCCESS) {
+		ehca_err(pd->device, "Could not enable SRQ"
+			 "ehca_qp=%p qp_num=%x hret=%lx",
+			 my_qp, my_qp->real_qp_num, hret);
+		goto create_srq2;
+	}
+
+	mqpcb->qp_state  = EHCA_QPS_RTR;
+	update_mask = EHCA_BMASK_SET(MQPCB_MASK_QP_STATE, 1);
+	hret = hipz_h_modify_qp(shca->ipz_hca_handle,
+				my_qp->ipz_qp_handle,
+				&my_qp->pf,
+				update_mask,
+				mqpcb, my_qp->galpas.kernel);
+	if (hret != H_SUCCESS) {
+		ehca_err(pd->device, "Could not modify SRQ to RTR"
+			 "ehca_qp=%p qp_num=%x hret=%lx",
+			 my_qp, my_qp->real_qp_num, hret);
+		goto create_srq2;
+	}
+
+	return &my_qp->ib_srq;
+
+create_srq2:
+	ret = ERR_PTR(ehca2ib_return_code(hret));
+	ehca_free_fw_ctrlblock(mqpcb);
+
+create_srq1:
+	internal_destroy_qp(pd->device, my_qp, my_qp->ib_srq.uobject);
+
+	return ret;
+}
+
 /*
  * prepare_sqe_rts called by internal_modify_qp() at trans sqe -> rts
  * set purge bit of bad wqe and subsequent wqes to avoid reentering sqe
@@ -1341,42 +1505,159 @@ query_qp_exit1:
 	return ret;
 }
 
-int ehca_destroy_qp(struct ib_qp *ibqp)
+int ehca_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
+		    enum ib_srq_attr_mask attr_mask, struct ib_udata *udata)
 {
-	struct ehca_qp *my_qp = container_of(ibqp, struct ehca_qp, ib_qp);
-	struct ehca_shca *shca = container_of(ibqp->device, struct ehca_shca,
+	struct ehca_qp *my_qp =
+		container_of(ibsrq, struct ehca_qp, ib_srq);
+	struct ehca_pd *my_pd =
+		container_of(ibsrq->pd, struct ehca_pd, ib_pd);
+	struct ehca_shca *shca =
+		container_of(ibsrq->pd->device, struct ehca_shca, ib_device);
+	struct hcp_modify_qp_control_block *mqpcb;
+	u64 update_mask;
+	u64 h_ret;
+	int ret = 0;
+
+	u32 cur_pid = current->tgid;
+	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
+	    my_pd->ownpid != cur_pid) {
+		ehca_err(ibsrq->pd->device, "Invalid caller pid=%x ownpid=%x",
+			 cur_pid, my_pd->ownpid);
+		return -EINVAL;
+	}
+
+	mqpcb = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
+	if (!mqpcb) {
+		ehca_err(ibsrq->device, "Could not get zeroed page for mqpcb "
+			 "ehca_qp=%p qp_num=%x ", my_qp, my_qp->real_qp_num);
+		return -ENOMEM;
+	}
+
+	update_mask = 0;
+	if (attr_mask & IB_SRQ_LIMIT) {
+		attr_mask &= ~IB_SRQ_LIMIT;
+		update_mask |=
+			EHCA_BMASK_SET(MQPCB_MASK_CURR_SRQ_LIMIT, 1)
+			| EHCA_BMASK_SET(MQPCB_MASK_QP_AFF_ASYN_EV_LOG_REG, 1);
+		mqpcb->curr_srq_limit =
+			EHCA_BMASK_SET(MQPCB_CURR_SRQ_LIMIT, attr->srq_limit);
+		mqpcb->qp_aff_asyn_ev_log_reg =
+			EHCA_BMASK_SET(QPX_AAELOG_RESET_SRQ_LIMIT, 1);
+	}
+
+	/* by now, all bits in attr_mask should have been cleared */
+	if (attr_mask) {
+		ehca_err(ibsrq->device, "invalid attribute mask bits set  "
+			 "attr_mask=%x", attr_mask);
+		ret = -EINVAL;
+		goto modify_srq_exit0;
+	}
+
+	if (ehca_debug_level)
+		ehca_dmp(mqpcb, 4*70, "qp_num=%x", my_qp->real_qp_num);
+
+	h_ret = hipz_h_modify_qp(shca->ipz_hca_handle, my_qp->ipz_qp_handle,
+				 NULL, update_mask, mqpcb,
+				 my_qp->galpas.kernel);
+
+	if (h_ret != H_SUCCESS) {
+		ret = ehca2ib_return_code(h_ret);
+		ehca_err(ibsrq->device, "hipz_h_modify_qp() failed rc=%lx "
+			 "ehca_qp=%p qp_num=%x",
+			 h_ret, my_qp, my_qp->real_qp_num);
+	}
+
+modify_srq_exit0:
+	ehca_free_fw_ctrlblock(mqpcb);
+
+	return ret;
+}
+
+int ehca_query_srq(struct ib_srq *srq, struct ib_srq_attr *srq_attr)
+{
+	struct ehca_qp *my_qp = container_of(srq, struct ehca_qp, ib_srq);
+	struct ehca_pd *my_pd = container_of(srq->pd, struct ehca_pd, ib_pd);
+	struct ehca_shca *shca = container_of(srq->device, struct ehca_shca,
 					      ib_device);
+	struct ipz_adapter_handle adapter_handle = shca->ipz_hca_handle;
+	struct hcp_modify_qp_control_block *qpcb;
+	u32 cur_pid = current->tgid;
+	int ret = 0;
+	u64 h_ret;
+
+	if (my_pd->ib_pd.uobject  && my_pd->ib_pd.uobject->context  &&
+	    my_pd->ownpid != cur_pid) {
+		ehca_err(srq->device, "Invalid caller pid=%x ownpid=%x",
+			 cur_pid, my_pd->ownpid);
+		return -EINVAL;
+	}
+
+	qpcb = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
+	if (!qpcb) {
+		ehca_err(srq->device,"Out of memory for qpcb "
+			 "ehca_qp=%p qp_num=%x", my_qp, my_qp->real_qp_num);
+		return -ENOMEM;
+	}
+
+	h_ret = hipz_h_query_qp(adapter_handle, my_qp->ipz_qp_handle,
+				NULL, qpcb, my_qp->galpas.kernel);
+
+	if (h_ret != H_SUCCESS) {
+		ret = ehca2ib_return_code(h_ret);
+		ehca_err(srq->device,"hipz_h_query_qp() failed "
+			 "ehca_qp=%p qp_num=%x h_ret=%lx",
+			 my_qp, my_qp->real_qp_num, h_ret);
+		goto query_srq_exit1;
+	}
+
+	srq_attr->max_wr = qpcb->max_nr_outst_recv_wr - 1;
+	srq_attr->srq_limit = EHCA_BMASK_GET(
+		MQPCB_CURR_SRQ_LIMIT, qpcb->curr_srq_limit);
+
+	if (ehca_debug_level)
+		ehca_dmp(qpcb, 4*70, "qp_num=%x", my_qp->real_qp_num);
+
+query_srq_exit1:
+	ehca_free_fw_ctrlblock(qpcb);
+
+	return ret;
+}
+
+int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
+			struct ib_uobject *uobject)
+{
+	struct ehca_shca *shca = container_of(dev, struct ehca_shca, ib_device);
 	struct ehca_pd *my_pd = container_of(my_qp->ib_qp.pd, struct ehca_pd,
 					     ib_pd);
 	u32 cur_pid = current->tgid;
-	u32 qp_num = ibqp->qp_num;
+	u32 qp_num = my_qp->real_qp_num;
 	int ret;
 	u64 h_ret;
 	u8 port_num;
 	enum ib_qp_type	qp_type;
 	unsigned long flags;
 
-	if (ibqp->uobject) {
+	if (uobject) {
 		if (my_qp->mm_count_galpa ||
 		    my_qp->mm_count_rqueue || my_qp->mm_count_squeue) {
-			ehca_err(ibqp->device, "Resources still referenced in "
-				 "user space qp_num=%x", ibqp->qp_num);
+			ehca_err(dev, "Resources still referenced in "
+				 "user space qp_num=%x", qp_num);
 			return -EINVAL;
 		}
 		if (my_pd->ownpid != cur_pid) {
-			ehca_err(ibqp->device, "Invalid caller pid=%x ownpid=%x",
+			ehca_err(dev, "Invalid caller pid=%x ownpid=%x",
 				 cur_pid, my_pd->ownpid);
 			return -EINVAL;
 		}
 	}
 
 	if (my_qp->send_cq) {
-		ret = ehca_cq_unassign_qp(my_qp->send_cq,
-					      my_qp->real_qp_num);
+		ret = ehca_cq_unassign_qp(my_qp->send_cq, qp_num);
 		if (ret) {
-			ehca_err(ibqp->device, "Couldn't unassign qp from "
+			ehca_err(dev, "Couldn't unassign qp from "
 				 "send_cq ret=%x qp_num=%x cq_num=%x", ret,
-				 my_qp->ib_qp.qp_num, my_qp->send_cq->cq_number);
+				 qp_num, my_qp->send_cq->cq_number);
 			return ret;
 		}
 	}
@@ -1387,7 +1668,7 @@ int ehca_destroy_qp(struct ib_qp *ibqp)
 
 	h_ret = hipz_h_destroy_qp(shca->ipz_hca_handle, my_qp);
 	if (h_ret != H_SUCCESS) {
-		ehca_err(ibqp->device, "hipz_h_destroy_qp() failed rc=%lx "
+		ehca_err(dev, "hipz_h_destroy_qp() failed rc=%lx "
 			 "ehca_qp=%p qp_num=%x", h_ret, my_qp, qp_num);
 		return ehca2ib_return_code(h_ret);
 	}
@@ -1398,7 +1679,7 @@ int ehca_destroy_qp(struct ib_qp *ibqp)
 	/* no support for IB_QPT_SMI yet */
 	if (qp_type == IB_QPT_GSI) {
 		struct ib_event event;
-		ehca_info(ibqp->device, "device %s: port %x is inactive.",
+		ehca_info(dev, "device %s: port %x is inactive.",
 			  shca->ib_device.name, port_num);
 		event.device = &shca->ib_device;
 		event.event = IB_EVENT_PORT_ERR;
@@ -1407,12 +1688,28 @@ int ehca_destroy_qp(struct ib_qp *ibqp)
 		ib_dispatch_event(&event);
 	}
 
-	ipz_queue_dtor(&my_qp->ipz_rqueue);
-	ipz_queue_dtor(&my_qp->ipz_squeue);
+	if (HAS_RQ(my_qp))
+		ipz_queue_dtor(&my_qp->ipz_rqueue);
+	if (HAS_SQ(my_qp))
+		ipz_queue_dtor(&my_qp->ipz_squeue);
 	kmem_cache_free(qp_cache, my_qp);
 	return 0;
 }
 
+int ehca_destroy_qp(struct ib_qp *qp)
+{
+	return internal_destroy_qp(qp->device,
+				   container_of(qp, struct ehca_qp, ib_qp),
+				   qp->uobject);
+}
+
+int ehca_destroy_srq(struct ib_srq *srq)
+{
+	return internal_destroy_qp(srq->device,
+				   container_of(srq, struct ehca_qp, ib_srq),
+				   srq->uobject);
+}
+
 int ehca_init_qp_cache(void)
 {
 	qp_cache = kmem_cache_create("ehca_cache_qp",
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index 56c4527..b5664fa 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -3,8 +3,9 @@
  *
  *  post_send/recv, poll_cq, req_notify
  *
- *  Authors: Waleri Fomin <fomin@de.ibm.com>
- *           Hoang-Nam Nguyen <hnguyen@de.ibm.com>
+ *  Authors: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
+ *           Waleri Fomin <fomin@de.ibm.com>
+ *           Joachim Fenkes <fenkes@de.ibm.com>
  *           Reinhard Ernst <rernst@de.ibm.com>
  *
  *  Copyright (c) 2005 IBM Corporation
@@ -413,17 +414,23 @@ post_send_exit0:
 	return ret;
 }
 
-int ehca_post_recv(struct ib_qp *qp,
-		   struct ib_recv_wr *recv_wr,
-		   struct ib_recv_wr **bad_recv_wr)
+static int internal_post_recv(struct ehca_qp *my_qp,
+			      struct ib_device *dev,
+			      struct ib_recv_wr *recv_wr,
+			      struct ib_recv_wr **bad_recv_wr)
 {
-	struct ehca_qp *my_qp = container_of(qp, struct ehca_qp, ib_qp);
 	struct ib_recv_wr *cur_recv_wr;
 	struct ehca_wqe *wqe_p;
 	int wqe_cnt = 0;
 	int ret = 0;
 	unsigned long spl_flags;
 
+	if (unlikely(!HAS_RQ(my_qp))) {
+		ehca_err(dev, "QP has no RQ  ehca_qp=%p qp_num=%x ext_type=%d",
+			 my_qp, my_qp->real_qp_num, my_qp->ext_type);
+		return -ENODEV;
+	}
+
 	/* LOCK the QUEUE */
 	spin_lock_irqsave(&my_qp->spinlock_r, spl_flags);
 
@@ -439,8 +446,8 @@ int ehca_post_recv(struct ib_qp *qp,
 				*bad_recv_wr = cur_recv_wr;
 			if (wqe_cnt == 0) {
 				ret = -ENOMEM;
-				ehca_err(qp->device, "Too many posted WQEs "
-					 "qp_num=%x", qp->qp_num);
+				ehca_err(dev, "Too many posted WQEs "
+					 "qp_num=%x", my_qp->real_qp_num);
 			}
 			goto post_recv_exit0;
 		}
@@ -455,14 +462,14 @@ int ehca_post_recv(struct ib_qp *qp,
 			*bad_recv_wr = cur_recv_wr;
 			if (wqe_cnt == 0) {
 				ret = -EINVAL;
-				ehca_err(qp->device, "Could not write WQE "
-					 "qp_num=%x", qp->qp_num);
+				ehca_err(dev, "Could not write WQE "
+					 "qp_num=%x", my_qp->real_qp_num);
 			}
 			goto post_recv_exit0;
 		}
 		wqe_cnt++;
-		ehca_gen_dbg("ehca_qp=%p qp_num=%x wqe_cnt=%d",
-		     my_qp, qp->qp_num, wqe_cnt);
+		ehca_dbg(dev, "ehca_qp=%p qp_num=%x wqe_cnt=%d",
+			 my_qp, my_qp->real_qp_num, wqe_cnt);
 	} /* eof for cur_recv_wr */
 
 post_recv_exit0:
@@ -472,6 +479,22 @@ post_recv_exit0:
 	return ret;
 }
 
+int ehca_post_recv(struct ib_qp *qp,
+		   struct ib_recv_wr *recv_wr,
+		   struct ib_recv_wr **bad_recv_wr)
+{
+	return internal_post_recv(container_of(qp, struct ehca_qp, ib_qp),
+				  qp->device, recv_wr, bad_recv_wr);
+}
+
+int ehca_post_srq_recv(struct ib_srq *srq,
+		       struct ib_recv_wr *recv_wr,
+		       struct ib_recv_wr **bad_recv_wr)
+{
+	return internal_post_recv(container_of(srq, struct ehca_qp, ib_srq),
+				  srq->device, recv_wr, bad_recv_wr);
+}
+
 /*
  * ib_wc_opcode table converts ehca wc opcode to ib
  * Since we use zero to indicate invalid opcode, the actual ib opcode must
diff --git a/drivers/infiniband/hw/ehca/ehca_uverbs.c b/drivers/infiniband/hw/ehca/ehca_uverbs.c
index 73db920..d8fe37d 100644
--- a/drivers/infiniband/hw/ehca/ehca_uverbs.c
+++ b/drivers/infiniband/hw/ehca/ehca_uverbs.c
@@ -257,6 +257,7 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	struct ehca_cq *cq;
 	struct ehca_qp *qp;
 	struct ehca_pd *pd;
+	struct ib_uobject *uobject;
 
 	switch (q_type) {
 	case  1: /* CQ */
@@ -304,7 +305,8 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 			return -ENOMEM;
 		}
 
-		if (!qp->ib_qp.uobject || qp->ib_qp.uobject->context != context)
+		uobject = IS_SRQ(qp) ? qp->ib_srq.uobject : qp->ib_qp.uobject;
+		if (!uobject || uobject->context != context)
 			return -EINVAL;
 
 		ret = ehca_mmap_qp(vma, qp, rsrc_type);
diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index 7efc4a2..b078377 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -5,6 +5,7 @@
  *
  *  Authors: Christoph Raisch <raisch@de.ibm.com>
  *           Hoang-Nam Nguyen <hnguyen@de.ibm.com>
+ *           Joachim Fenkes <fenkes@de.ibm.com>
  *           Gerd Bayer <gerd.bayer@de.ibm.com>
  *           Waleri Fomin <fomin@de.ibm.com>
  *
@@ -62,6 +63,12 @@
 #define H_ALL_RES_QP_MAX_SEND_SGE       EHCA_BMASK_IBM(32, 39)
 #define H_ALL_RES_QP_MAX_RECV_SGE       EHCA_BMASK_IBM(40, 47)
 
+#define H_ALL_RES_QP_UD_AV_LKEY         EHCA_BMASK_IBM(32, 63)
+#define H_ALL_RES_QP_SRQ_QP_TOKEN       EHCA_BMASK_IBM(0, 31)
+#define H_ALL_RES_QP_SRQ_QP_HANDLE      EHCA_BMASK_IBM(0, 64)
+#define H_ALL_RES_QP_SRQ_LIMIT          EHCA_BMASK_IBM(48, 63)
+#define H_ALL_RES_QP_SRQ_QPN            EHCA_BMASK_IBM(40, 63)
+
 #define H_ALL_RES_QP_ACT_OUTST_SEND_WR  EHCA_BMASK_IBM(16, 31)
 #define H_ALL_RES_QP_ACT_OUTST_RECV_WR  EHCA_BMASK_IBM(48, 63)
 #define H_ALL_RES_QP_ACT_SEND_SGE       EHCA_BMASK_IBM(8, 15)
@@ -150,7 +157,7 @@ static long ehca_plpar_hcall9(unsigned long opcode,
 {
 	long ret;
 	int i, sleep_msecs, lock_is_set = 0;
-	unsigned long flags;
+	unsigned long flags = 0;
 
 	ehca_gen_dbg("opcode=%lx arg1=%lx arg2=%lx arg3=%lx arg4=%lx "
 		     "arg5=%lx arg6=%lx arg7=%lx arg8=%lx arg9=%lx",
@@ -282,8 +289,7 @@ u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
 			     struct ehca_alloc_qp_parms *parms)
 {
 	u64 ret;
-	u64 allocate_controls;
-	u64 max_r10_reg;
+	u64 allocate_controls, max_r10_reg, r11, r12;
 	u64 outs[PLPAR_HCALL9_BUFSIZE];
 
 	allocate_controls =
@@ -309,6 +315,13 @@ u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
 		| EHCA_BMASK_SET(H_ALL_RES_QP_MAX_RECV_SGE,
 				 parms->max_recv_sge);
 
+	r11 = EHCA_BMASK_SET(H_ALL_RES_QP_SRQ_QP_TOKEN, parms->srq_token);
+
+	if (parms->ext_type == EQPT_SRQ)
+		r12 = EHCA_BMASK_SET(H_ALL_RES_QP_SRQ_LIMIT, parms->srq_limit);
+	else
+		r12 = EHCA_BMASK_SET(H_ALL_RES_QP_SRQ_QPN, parms->srq_qpn);
+
 	ret = ehca_plpar_hcall9(H_ALLOC_RESOURCE, outs,
 				adapter_handle.handle,	           /* r4  */
 				allocate_controls,	           /* r5  */
@@ -316,9 +329,7 @@ u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
 				parms->recv_cq_handle.handle,
 				parms->eq_handle.handle,
 				((u64)parms->token << 32) | parms->pd.value,
-				max_r10_reg,	                   /* r10 */
-				parms->ud_av_l_key_ctl,            /* r11 */
-				0);
+				max_r10_reg, r11, r12);
 
 	parms->qp_handle.handle = outs[0];
 	parms->real_qp_num = (u32)outs[1];
diff --git a/drivers/infiniband/hw/ehca/hipz_hw.h b/drivers/infiniband/hw/ehca/hipz_hw.h
index 9fe8367..d46b18c 100644
--- a/drivers/infiniband/hw/ehca/hipz_hw.h
+++ b/drivers/infiniband/hw/ehca/hipz_hw.h
@@ -163,6 +163,7 @@ struct hipz_qptemm {
 
 #define QPX_SQADDER EHCA_BMASK_IBM(48,63)
 #define QPX_RQADDER EHCA_BMASK_IBM(48,63)
+#define QPX_AAELOG_RESET_SRQ_LIMIT EHCA_BMASK_IBM(3,3)
 
 #define QPTEMM_OFFSET(x) offsetof(struct hipz_qptemm,x)
 
-- 
1.5.2


