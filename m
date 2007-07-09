Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbXGINXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbXGINXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbXGINXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:23:22 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:16782 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbXGINXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:23:19 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 03/13] IB/ehca: QP code restructuring in preparation for SRQ
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707091502.22407.fenkes@de.ibm.com>
In-Reply-To: <200707091502.22407.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1748
Date: Mon, 9 Jul 2007 15:23:15 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707091523.16498.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- Replace init_qp_queues() by a shorter init_qp_queue(), eliminating
  duplicate code.

- hipz_h_alloc_resource_qp() doesn't need a pointer to struct ehca_qp any
  longer. All input and output data is transferred through the parms
  parameter.

- Change the interface to also support SRQ.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |   46 +++++-
 drivers/infiniband/hw/ehca/ehca_qp.c      |  254 +++++++++++++----------------
 drivers/infiniband/hw/ehca/hcp_if.c       |   35 ++---
 drivers/infiniband/hw/ehca/hcp_if.h       |    1 -
 4 files changed, 166 insertions(+), 170 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 35d948f..6e75db6 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -322,14 +322,49 @@ struct ehca_alloc_cq_parms {
 	struct ipz_eq_handle eq_handle;
 };
 
+enum ehca_service_type {
+	ST_RC  = 0,
+	ST_UC  = 1,
+	ST_RD  = 2,
+	ST_UD  = 3,
+};
+
+enum ehca_ext_qp_type {
+	EQPT_NORMAL    = 0,
+	EQPT_LLQP      = 1,
+	EQPT_SRQBASE   = 2,
+	EQPT_SRQ       = 3,
+};
+
+enum ehca_ll_comp_flags {
+	LLQP_SEND_COMP = 0x20,
+	LLQP_RECV_COMP = 0x40,
+	LLQP_COMP_MASK = 0x60,
+};
+
 struct ehca_alloc_qp_parms {
-	int servicetype;
+/* input parameters */
+	enum ehca_service_type servicetype;
 	int sigtype;
-	int daqp_ctrl;
-	int max_send_sge;
-	int max_recv_sge;
+	enum ehca_ext_qp_type ext_type;
+	enum ehca_ll_comp_flags ll_comp_flags;
+
+	int max_send_wr, max_recv_wr;
+	int max_send_sge, max_recv_sge;
 	int ud_av_l_key_ctl;
 
+	u32 token;
+	struct ipz_eq_handle eq_handle;
+	struct ipz_pd pd;
+	struct ipz_cq_handle send_cq_handle, recv_cq_handle;
+
+	u32 srq_qpn, srq_token, srq_limit;
+
+/* output parameters */
+	u32 real_qp_num;
+	struct ipz_qp_handle qp_handle;
+	struct h_galpas galpas;
+
 	u16 act_nr_send_wqes;
 	u16 act_nr_recv_wqes;
 	u8  act_nr_recv_sges;
@@ -337,9 +372,6 @@ struct ehca_alloc_qp_parms {
 
 	u32 nr_rq_pages;
 	u32 nr_sq_pages;
-
-	struct ipz_eq_handle ipz_eq_handle;
-	struct ipz_pd pd;
 };
 
 int ehca_cq_assign_qp(struct ehca_cq *cq, struct ehca_qp *qp);
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index b5bc787..ec1d555 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -234,13 +234,6 @@ static inline enum ib_qp_statetrans get_modqp_statetrans(int ib_fromstate,
 	return index;
 }
 
-enum ehca_service_type {
-	ST_RC = 0,
-	ST_UC = 1,
-	ST_RD = 2,
-	ST_UD = 3
-};
-
 /*
  * ibqptype2servicetype returns hcp service type corresponding to given
  * ib qp type used by create_qp()
@@ -268,15 +261,16 @@ static inline int ibqptype2servicetype(enum ib_qp_type ibqptype)
 }
 
 /*
- * init_qp_queues initializes/constructs r/squeue and registers queue pages.
+ * init_qp_queue initializes/constructs r/squeue and registers queue pages.
  */
-static inline int init_qp_queues(struct ehca_shca *shca,
-				 struct ehca_qp *my_qp,
-				 int nr_sq_pages,
-				 int nr_rq_pages,
-				 int swqe_size,
-				 int rwqe_size,
-				 int nr_send_sges, int nr_receive_sges)
+static inline int init_qp_queue(struct ehca_shca *shca,
+				struct ehca_qp *my_qp,
+				struct ipz_queue *queue,
+				int q_type,
+				u64 expected_hret,
+				int nr_q_pages,
+				int wqe_size,
+				int nr_sges)
 {
 	int ret, cnt, ipz_rc;
 	void *vpage;
@@ -284,104 +278,63 @@ static inline int init_qp_queues(struct ehca_shca *shca,
 	struct ib_device *ib_dev = &shca->ib_device;
 	struct ipz_adapter_handle ipz_hca_handle = shca->ipz_hca_handle;
 
-	ipz_rc = ipz_queue_ctor(&my_qp->ipz_squeue,
-				nr_sq_pages,
-				EHCA_PAGESIZE, swqe_size, nr_send_sges);
+	if (!nr_q_pages)
+		return 0;
+
+	ipz_rc = ipz_queue_ctor(queue, nr_q_pages, EHCA_PAGESIZE,
+				wqe_size, nr_sges);
 	if (!ipz_rc) {
-		ehca_err(ib_dev,"Cannot allocate page for squeue. ipz_rc=%x",
+		ehca_err(ib_dev,"Cannot allocate page for queue. ipz_rc=%x",
 			 ipz_rc);
 		return -EBUSY;
 	}
 
-	ipz_rc = ipz_queue_ctor(&my_qp->ipz_rqueue,
-				nr_rq_pages,
-				EHCA_PAGESIZE, rwqe_size, nr_receive_sges);
-	if (!ipz_rc) {
-		ehca_err(ib_dev, "Cannot allocate page for rqueue. ipz_rc=%x",
-			 ipz_rc);
-		ret = -EBUSY;
-		goto init_qp_queues0;
-	}
-	/* register SQ pages */
-	for (cnt = 0; cnt < nr_sq_pages; cnt++) {
-		vpage = ipz_qpageit_get_inc(&my_qp->ipz_squeue);
+	/* register queue pages */
+	for (cnt = 0; cnt < nr_q_pages; cnt++) {
+		vpage = ipz_qpageit_get_inc(queue);
 		if (!vpage) {
-			ehca_err(ib_dev, "SQ ipz_qpageit_get_inc() "
+			ehca_err(ib_dev, "ipz_qpageit_get_inc() "
 				 "failed p_vpage= %p", vpage);
 			ret = -EINVAL;
-			goto init_qp_queues1;
+			goto init_qp_queue1;
 		}
 		rpage = virt_to_abs(vpage);
 
 		h_ret = hipz_h_register_rpage_qp(ipz_hca_handle,
 						 my_qp->ipz_qp_handle,
-						 &my_qp->pf, 0, 0,
+						 NULL, 0, q_type,
 						 rpage, 1,
 						 my_qp->galpas.kernel);
-		if (h_ret < H_SUCCESS) {
-			ehca_err(ib_dev, "SQ hipz_qp_register_rpage()"
-				 " failed rc=%lx", h_ret);
-			ret = ehca2ib_return_code(h_ret);
-			goto init_qp_queues1;
-		}
-	}
-
-	ipz_qeit_reset(&my_qp->ipz_squeue);
-
-	/* register RQ pages */
-	for (cnt = 0; cnt < nr_rq_pages; cnt++) {
-		vpage = ipz_qpageit_get_inc(&my_qp->ipz_rqueue);
-		if (!vpage) {
-			ehca_err(ib_dev, "RQ ipz_qpageit_get_inc() "
-				 "failed p_vpage = %p", vpage);
-			ret = -EINVAL;
-			goto init_qp_queues1;
-		}
-
-		rpage = virt_to_abs(vpage);
-
-		h_ret = hipz_h_register_rpage_qp(ipz_hca_handle,
-						 my_qp->ipz_qp_handle,
-						 &my_qp->pf, 0, 1,
-						 rpage, 1,my_qp->galpas.kernel);
-		if (h_ret < H_SUCCESS) {
-			ehca_err(ib_dev, "RQ hipz_qp_register_rpage() failed "
-				 "rc=%lx", h_ret);
-			ret = ehca2ib_return_code(h_ret);
-			goto init_qp_queues1;
-		}
-		if (cnt == (nr_rq_pages - 1)) {	/* last page! */
-			if (h_ret != H_SUCCESS) {
-				ehca_err(ib_dev, "RQ hipz_qp_register_rpage() "
+		if (cnt == (nr_q_pages - 1)) {	/* last page! */
+			if (h_ret != expected_hret) {
+				ehca_err(ib_dev, "hipz_qp_register_rpage() "
 					 "h_ret= %lx ", h_ret);
 				ret = ehca2ib_return_code(h_ret);
-				goto init_qp_queues1;
+				goto init_qp_queue1;
 			}
 			vpage = ipz_qpageit_get_inc(&my_qp->ipz_rqueue);
 			if (vpage) {
 				ehca_err(ib_dev, "ipz_qpageit_get_inc() "
 					 "should not succeed vpage=%p", vpage);
 				ret = -EINVAL;
-				goto init_qp_queues1;
+				goto init_qp_queue1;
 			}
 		} else {
 			if (h_ret != H_PAGE_REGISTERED) {
-				ehca_err(ib_dev, "RQ hipz_qp_register_rpage() "
+				ehca_err(ib_dev, "hipz_qp_register_rpage() "
 					 "h_ret= %lx ", h_ret);
 				ret = ehca2ib_return_code(h_ret);
-				goto init_qp_queues1;
+				goto init_qp_queue1;
 			}
 		}
 	}
 
-	ipz_qeit_reset(&my_qp->ipz_rqueue);
+	ipz_qeit_reset(queue);
 
 	return 0;
 
-init_qp_queues1:
-	ipz_queue_dtor(&my_qp->ipz_rqueue);
-init_qp_queues0:
-	ipz_queue_dtor(&my_qp->ipz_squeue);
+init_qp_queue1:
+	ipz_queue_dtor(queue);
 	return ret;
 }
 
@@ -397,14 +350,17 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 					      ib_device);
 	struct ib_ucontext *context = NULL;
 	u64 h_ret;
-	int max_send_sge, max_recv_sge, ret;
+	int is_llqp = 0, has_srq = 0;
+	int qp_type, max_send_sge, max_recv_sge, ret;
 
 	/* h_call's out parameters */
 	struct ehca_alloc_qp_parms parms;
 	u32 swqe_size = 0, rwqe_size = 0;
-	u8 daqp_completion, isdaqp;
 	unsigned long flags;
 
+	memset(&parms, 0, sizeof(parms));
+	qp_type = init_attr->qp_type;
+
 	if (init_attr->sq_sig_type != IB_SIGNAL_REQ_WR &&
 		init_attr->sq_sig_type != IB_SIGNAL_ALL_WR) {
 		ehca_err(pd->device, "init_attr->sg_sig_type=%x not allowed",
@@ -412,38 +368,47 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 		return ERR_PTR(-EINVAL);
 	}
 
-	/* save daqp completion bits */
-	daqp_completion = init_attr->qp_type & 0x60;
-	/* save daqp bit */
-	isdaqp = (init_attr->qp_type & 0x80) ? 1 : 0;
-	init_attr->qp_type = init_attr->qp_type & 0x1F;
+	/* save LLQP info */
+	if (qp_type & 0x80) {
+		is_llqp = 1;
+		parms.ext_type = EQPT_LLQP;
+		parms.ll_comp_flags = qp_type & LLQP_COMP_MASK;
+	}
+	qp_type &= 0x1F;
+
+	/* check for SRQ */
+	has_srq = !!(init_attr->srq);
+	if (is_llqp && has_srq) {
+		ehca_err(pd->device, "LLQPs can't have an SRQ");
+		return ERR_PTR(-EINVAL);
+	}
 
-	if (init_attr->qp_type != IB_QPT_UD &&
-	    init_attr->qp_type != IB_QPT_SMI &&
-	    init_attr->qp_type != IB_QPT_GSI &&
-	    init_attr->qp_type != IB_QPT_UC &&
-	    init_attr->qp_type != IB_QPT_RC) {
-		ehca_err(pd->device, "wrong QP Type=%x", init_attr->qp_type);
+	/* check QP type */
+	if (qp_type != IB_QPT_UD &&
+	    qp_type != IB_QPT_UC &&
+	    qp_type != IB_QPT_RC &&
+	    qp_type != IB_QPT_SMI &&
+	    qp_type != IB_QPT_GSI) {
+		ehca_err(pd->device, "wrong QP Type=%x", qp_type);
 		return ERR_PTR(-EINVAL);
 	}
-	if ((init_attr->qp_type != IB_QPT_RC && init_attr->qp_type != IB_QPT_UD)
-	    && isdaqp) {
-		ehca_err(pd->device, "unsupported LL QP Type=%x",
-			 init_attr->qp_type);
+
+	if (is_llqp && (qp_type != IB_QPT_RC && qp_type != IB_QPT_UD)) {
+		ehca_err(pd->device, "unsupported LL QP Type=%x", qp_type);
 		return ERR_PTR(-EINVAL);
-	} else if (init_attr->qp_type == IB_QPT_RC && isdaqp &&
+	} else if (is_llqp && qp_type == IB_QPT_RC &&
 		   (init_attr->cap.max_send_wr > 255 ||
 		    init_attr->cap.max_recv_wr > 255 )) {
-		       ehca_err(pd->device, "Invalid Number of max_sq_wr =%x "
-				"or max_rq_wr=%x for QP Type=%x",
-				init_attr->cap.max_send_wr,
-				init_attr->cap.max_recv_wr,init_attr->qp_type);
-		       return ERR_PTR(-EINVAL);
-	} else if (init_attr->qp_type == IB_QPT_UD && isdaqp &&
-		  init_attr->cap.max_send_wr > 255) {
+		ehca_err(pd->device, "Invalid Number of max_sq_wr=%x "
+			 "or max_rq_wr=%x for RC LLQP",
+			 init_attr->cap.max_send_wr,
+			 init_attr->cap.max_recv_wr);
+		return ERR_PTR(-EINVAL);
+	} else if (is_llqp && qp_type == IB_QPT_UD &&
+		 init_attr->cap.max_send_wr > 255) {
 		ehca_err(pd->device,
 			 "Invalid Number of max_send_wr=%x for UD QP_TYPE=%x",
-			 init_attr->cap.max_send_wr, init_attr->qp_type);
+			 init_attr->cap.max_send_wr, qp_type);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -456,7 +421,6 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	memset (&parms, 0, sizeof(struct ehca_alloc_qp_parms));
 	spin_lock_init(&my_qp->spinlock_s);
 	spin_lock_init(&my_qp->spinlock_r);
 
@@ -465,8 +429,6 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 	my_qp->send_cq =
 		container_of(init_attr->send_cq, struct ehca_cq, ib_cq);
 
-	my_qp->init_attr = *init_attr;
-
 	do {
 		if (!idr_pre_get(&ehca_qp_idr, GFP_KERNEL)) {
 			ret = -ENOMEM;
@@ -486,10 +448,10 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 		goto create_qp_exit0;
 	}
 
-	parms.servicetype = ibqptype2servicetype(init_attr->qp_type);
+	parms.servicetype = ibqptype2servicetype(qp_type);
 	if (parms.servicetype < 0) {
 		ret = -EINVAL;
-		ehca_err(pd->device, "Invalid qp_type=%x", init_attr->qp_type);
+		ehca_err(pd->device, "Invalid qp_type=%x", qp_type);
 		goto create_qp_exit0;
 	}
 
@@ -501,21 +463,23 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 	/* UD_AV CIRCUMVENTION */
 	max_send_sge = init_attr->cap.max_send_sge;
 	max_recv_sge = init_attr->cap.max_recv_sge;
-	if (IB_QPT_UD == init_attr->qp_type ||
-	    IB_QPT_GSI == init_attr->qp_type ||
-	    IB_QPT_SMI == init_attr->qp_type) {
+	if (parms.servicetype == ST_UD) {
 		max_send_sge += 2;
 		max_recv_sge += 2;
 	}
 
-	parms.ipz_eq_handle = shca->eq.ipz_eq_handle;
-	parms.daqp_ctrl = isdaqp | daqp_completion;
+	parms.token = my_qp->token;
+	parms.eq_handle = shca->eq.ipz_eq_handle;
 	parms.pd = my_pd->fw_pd;
-	parms.max_recv_sge = max_recv_sge;
-	parms.max_send_sge = max_send_sge;
+	parms.send_cq_handle = my_qp->send_cq->ipz_cq_handle;
+	parms.recv_cq_handle = my_qp->recv_cq->ipz_cq_handle;
 
-	h_ret = hipz_h_alloc_resource_qp(shca->ipz_hca_handle, my_qp, &parms);
+	parms.max_send_wr = init_attr->cap.max_send_wr;
+	parms.max_recv_wr = init_attr->cap.max_recv_wr;
+	parms.max_send_sge = max_send_sge;
+	parms.max_recv_sge = max_recv_sge;
 
+	h_ret = hipz_h_alloc_resource_qp(shca->ipz_hca_handle, &parms);
 	if (h_ret != H_SUCCESS) {
 		ehca_err(pd->device, "h_alloc_resource_qp() failed h_ret=%lx",
 			 h_ret);
@@ -523,16 +487,18 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 		goto create_qp_exit1;
 	}
 
-	my_qp->ib_qp.qp_num = my_qp->real_qp_num;
+	my_qp->ib_qp.qp_num = my_qp->real_qp_num = parms.real_qp_num;
+	my_qp->ipz_qp_handle = parms.qp_handle;
+	my_qp->galpas = parms.galpas;
 
-	switch (init_attr->qp_type) {
+	switch (qp_type) {
 	case IB_QPT_RC:
-	        if (isdaqp == 0) {
+	        if (!is_llqp) {
 			swqe_size = offsetof(struct ehca_wqe, u.nud.sg_list[
 					     (parms.act_nr_send_sges)]);
 			rwqe_size = offsetof(struct ehca_wqe, u.nud.sg_list[
 					     (parms.act_nr_recv_sges)]);
-		} else { /* for daqp we need to use msg size, not wqe size */
+		} else { /* for LLQP we need to use msg size, not wqe size */
 		        swqe_size = da_rc_msg_size[max_send_sge];
 			rwqe_size = da_rc_msg_size[max_recv_sge];
 			parms.act_nr_send_sges = 1;
@@ -552,7 +518,7 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 		/* UD circumvention */
 		parms.act_nr_recv_sges -= 2;
 		parms.act_nr_send_sges -= 2;
-		if (isdaqp) {
+		if (is_llqp) {
 		        swqe_size = da_ud_sq_msg_size[max_send_sge];
 			rwqe_size = da_rc_msg_size[max_recv_sge];
 			parms.act_nr_send_sges = 1;
@@ -564,14 +530,12 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 					     u.ud_av.sg_list[parms.act_nr_recv_sges]);
 		}
 
-		if (IB_QPT_GSI == init_attr->qp_type ||
-		    IB_QPT_SMI == init_attr->qp_type) {
+		if (IB_QPT_GSI == qp_type || IB_QPT_SMI == qp_type) {
 			parms.act_nr_send_wqes = init_attr->cap.max_send_wr;
 			parms.act_nr_recv_wqes = init_attr->cap.max_recv_wr;
 			parms.act_nr_send_sges = init_attr->cap.max_send_sge;
 			parms.act_nr_recv_sges = init_attr->cap.max_recv_sge;
-			my_qp->ib_qp.qp_num =
-				(init_attr->qp_type == IB_QPT_SMI) ? 0 : 1;
+			my_qp->ib_qp.qp_num = (qp_type == IB_QPT_SMI) ? 0 : 1;
 		}
 
 		break;
@@ -580,26 +544,33 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 		break;
 	}
 
-	/* initializes r/squeue and registers queue pages */
-	ret = init_qp_queues(shca, my_qp,
-			     parms.nr_sq_pages, parms.nr_rq_pages,
-			     swqe_size, rwqe_size,
-			     parms.act_nr_send_sges, parms.act_nr_recv_sges);
+	/* initialize r/squeue and register queue pages */
+	ret = init_qp_queue(shca, my_qp, &my_qp->ipz_squeue, 0,
+			    has_srq ? H_SUCCESS : H_PAGE_REGISTERED,
+			    parms.nr_sq_pages, swqe_size,
+			    parms.act_nr_send_sges);
 	if (ret) {
 		ehca_err(pd->device,
-			 "Couldn't initialize r/squeue and pages ret=%x", ret);
+			 "Couldn't initialize squeue and pages ret=%x", ret);
 		goto create_qp_exit2;
 	}
 
+	ret = init_qp_queue(shca, my_qp, &my_qp->ipz_rqueue, 1, H_SUCCESS,
+			    parms.nr_rq_pages, rwqe_size,
+			    parms.act_nr_recv_sges);
+	if (ret) {
+		ehca_err(pd->device,
+			 "Couldn't initialize rqueue and pages ret=%x", ret);
+		goto create_qp_exit3;
+	}
+
 	my_qp->ib_qp.pd = &my_pd->ib_pd;
 	my_qp->ib_qp.device = my_pd->ib_pd.device;
 
 	my_qp->ib_qp.recv_cq = init_attr->recv_cq;
 	my_qp->ib_qp.send_cq = init_attr->send_cq;
 
-	my_qp->ib_qp.qp_type = init_attr->qp_type;
-
-	my_qp->qp_type = init_attr->qp_type;
+	my_qp->ib_qp.qp_type = my_qp->qp_type = qp_type;
 	my_qp->ib_qp.srq = init_attr->srq;
 
 	my_qp->ib_qp.qp_context = init_attr->qp_context;
@@ -610,15 +581,16 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 	init_attr->cap.max_recv_wr = parms.act_nr_recv_wqes;
 	init_attr->cap.max_send_sge = parms.act_nr_send_sges;
 	init_attr->cap.max_send_wr = parms.act_nr_send_wqes;
+	my_qp->init_attr = *init_attr;
 
 	/* NOTE: define_apq0() not supported yet */
-	if (init_attr->qp_type == IB_QPT_GSI) {
+	if (qp_type == IB_QPT_GSI) {
 		h_ret = ehca_define_sqp(shca, my_qp, init_attr);
 		if (h_ret != H_SUCCESS) {
 			ehca_err(pd->device, "ehca_define_sqp() failed rc=%lx",
 				 h_ret);
 			ret = ehca2ib_return_code(h_ret);
-			goto create_qp_exit3;
+			goto create_qp_exit4;
 		}
 	}
 	if (init_attr->send_cq) {
@@ -628,7 +600,7 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 		if (ret) {
 			ehca_err(pd->device, "Couldn't assign qp to send_cq ret=%x",
 				 ret);
-			goto create_qp_exit3;
+			goto create_qp_exit4;
 		}
 		my_qp->send_cq = cq;
 	}
@@ -659,14 +631,16 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 		if (ib_copy_to_udata(udata, &resp, sizeof resp)) {
 			ehca_err(pd->device, "Copy to udata failed");
 			ret = -EINVAL;
-			goto create_qp_exit3;
+			goto create_qp_exit4;
 		}
 	}
 
 	return &my_qp->ib_qp;
 
-create_qp_exit3:
+create_qp_exit4:
 	ipz_queue_dtor(&my_qp->ipz_rqueue);
+
+create_qp_exit3:
 	ipz_queue_dtor(&my_qp->ipz_squeue);
 
 create_qp_exit2:
diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index 5766ae3..7efc4a2 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -74,11 +74,6 @@
 #define H_MP_SHUTDOWN                   EHCA_BMASK_IBM(48, 48)
 #define H_MP_RESET_QKEY_CTR             EHCA_BMASK_IBM(49, 49)
 
-/* direct access qp controls */
-#define DAQP_CTRL_ENABLE    0x01
-#define DAQP_CTRL_SEND_COMP 0x20
-#define DAQP_CTRL_RECV_COMP 0x40
-
 static u32 get_longbusy_msecs(int longbusy_rc)
 {
 	switch (longbusy_rc) {
@@ -284,36 +279,31 @@ u64 hipz_h_alloc_resource_cq(const struct ipz_adapter_handle adapter_handle,
 }
 
 u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
-			     struct ehca_qp *qp,
 			     struct ehca_alloc_qp_parms *parms)
 {
 	u64 ret;
 	u64 allocate_controls;
 	u64 max_r10_reg;
 	u64 outs[PLPAR_HCALL9_BUFSIZE];
-	u16 max_nr_receive_wqes = qp->init_attr.cap.max_recv_wr + 1;
-	u16 max_nr_send_wqes = qp->init_attr.cap.max_send_wr + 1;
-	int daqp_ctrl = parms->daqp_ctrl;
 
 	allocate_controls =
-		EHCA_BMASK_SET(H_ALL_RES_QP_ENHANCED_OPS,
-			       (daqp_ctrl & DAQP_CTRL_ENABLE) ? 1 : 0)
+		EHCA_BMASK_SET(H_ALL_RES_QP_ENHANCED_OPS, parms->ext_type)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_PTE_PIN, 0)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_SERVICE_TYPE, parms->servicetype)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_SIGNALING_TYPE, parms->sigtype)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_LL_RQ_CQE_POSTING,
-				 (daqp_ctrl & DAQP_CTRL_RECV_COMP) ? 1 : 0)
+				 !!(parms->ll_comp_flags & LLQP_RECV_COMP))
 		| EHCA_BMASK_SET(H_ALL_RES_QP_LL_SQ_CQE_POSTING,
-				 (daqp_ctrl & DAQP_CTRL_SEND_COMP) ? 1 : 0)
+				 !!(parms->ll_comp_flags & LLQP_SEND_COMP))
 		| EHCA_BMASK_SET(H_ALL_RES_QP_UD_AV_LKEY_CTRL,
 				 parms->ud_av_l_key_ctl)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_RESOURCE_TYPE, 1);
 
 	max_r10_reg =
 		EHCA_BMASK_SET(H_ALL_RES_QP_MAX_OUTST_SEND_WR,
-			       max_nr_send_wqes)
+			       parms->max_send_wr + 1)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_MAX_OUTST_RECV_WR,
-				 max_nr_receive_wqes)
+				 parms->max_recv_wr + 1)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_MAX_SEND_SGE,
 				 parms->max_send_sge)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_MAX_RECV_SGE,
@@ -322,15 +312,16 @@ u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
 	ret = ehca_plpar_hcall9(H_ALLOC_RESOURCE, outs,
 				adapter_handle.handle,	           /* r4  */
 				allocate_controls,	           /* r5  */
-				qp->send_cq->ipz_cq_handle.handle,
-				qp->recv_cq->ipz_cq_handle.handle,
-				parms->ipz_eq_handle.handle,
-				((u64)qp->token << 32) | parms->pd.value,
+				parms->send_cq_handle.handle,
+				parms->recv_cq_handle.handle,
+				parms->eq_handle.handle,
+				((u64)parms->token << 32) | parms->pd.value,
 				max_r10_reg,	                   /* r10 */
 				parms->ud_av_l_key_ctl,            /* r11 */
 				0);
-	qp->ipz_qp_handle.handle = outs[0];
-	qp->real_qp_num = (u32)outs[1];
+
+	parms->qp_handle.handle = outs[0];
+	parms->real_qp_num = (u32)outs[1];
 	parms->act_nr_send_wqes =
 		(u16)EHCA_BMASK_GET(H_ALL_RES_QP_ACT_OUTST_SEND_WR, outs[2]);
 	parms->act_nr_recv_wqes =
@@ -345,7 +336,7 @@ u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
 		(u32)EHCA_BMASK_GET(H_ALL_RES_QP_RQUEUE_SIZE_PAGES, outs[4]);
 
 	if (ret == H_SUCCESS)
-		hcp_galpas_ctor(&qp->galpas, outs[6], outs[6]);
+		hcp_galpas_ctor(&parms->galpas, outs[6], outs[6]);
 
 	if (ret == H_NOT_ENOUGH_RESOURCES)
 		ehca_gen_err("Not enough resources. ret=%lx", ret);
diff --git a/drivers/infiniband/hw/ehca/hcp_if.h b/drivers/infiniband/hw/ehca/hcp_if.h
index 2869f7d..60ce02b 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.h
+++ b/drivers/infiniband/hw/ehca/hcp_if.h
@@ -78,7 +78,6 @@ u64 hipz_h_alloc_resource_cq(const struct ipz_adapter_handle adapter_handle,
  * initialize resources, create empty QPPTs (2 rings).
  */
 u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
-			     struct ehca_qp *qp,
 			     struct ehca_alloc_qp_parms *parms);
 
 u64 hipz_h_query_port(const struct ipz_adapter_handle adapter_handle,
-- 
1.5.2


