Return-Path: <linux-kernel-owner+w=401wt.eu-S1764049AbXGTNxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764049AbXGTNxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 09:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757787AbXGTNw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 09:52:57 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:42319 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959AbXGTNwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 09:52:55 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org
Subject: [PATCH 5/5] ehca: Support small QP queues
Date: Fri, 20 Jul 2007 16:04:17 +0200
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, stefan.roscher@de.ibm.com, fenkes@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707201604.17991.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Roscher <stefan.roscher at de.ibm.com>
Date: Fri, 20 Jul 2007 13:59:14 +0200
Subject: [PATCH 5/5] IB/ehca: Small QP queues

eHCA2 supports QP queues that can be as small as 512 bytes. This greatly
reduces memory overhead for consumers that use lots of QPs with small queues
(e.g. RDMA-only QPs). Apart from dealing with firmware, this code needs to
manage bite-sized chunks of kernel pages, making sure that no kernel page is
shared between different protection domains.

Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |   41 ++++--
 drivers/infiniband/hw/ehca/ehca_cq.c      |    8 +-
 drivers/infiniband/hw/ehca/ehca_eq.c      |    8 +-
 drivers/infiniband/hw/ehca/ehca_main.c    |   14 ++-
 drivers/infiniband/hw/ehca/ehca_pd.c      |   25 +++-
 drivers/infiniband/hw/ehca/ehca_qp.c      |  163 +++++++++++++---------
 drivers/infiniband/hw/ehca/ehca_uverbs.c  |    2 +-
 drivers/infiniband/hw/ehca/hcp_if.c       |   30 +++--
 drivers/infiniband/hw/ehca/ipz_pt_fn.c    |  222 ++++++++++++++++++++++-------
 drivers/infiniband/hw/ehca/ipz_pt_fn.h    |   26 +++-
 10 files changed, 379 insertions(+), 160 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 63b8b9f..3725aa8 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -43,7 +43,6 @@
 #ifndef __EHCA_CLASSES_H__
 #define __EHCA_CLASSES_H__
 
-
 struct ehca_module;
 struct ehca_qp;
 struct ehca_cq;
@@ -129,6 +128,10 @@ struct ehca_pd {
 	struct ib_pd ib_pd;
 	struct ipz_pd fw_pd;
 	u32 ownpid;
+	/* small queue mgmt */
+	struct mutex lock;
+	struct list_head free[2];
+	struct list_head full[2];
 };
 
 enum ehca_ext_qp_type {
@@ -307,6 +310,8 @@ int ehca_init_av_cache(void);
 void ehca_cleanup_av_cache(void);
 int ehca_init_mrmw_cache(void);
 void ehca_cleanup_mrmw_cache(void);
+int ehca_init_small_qp_cache(void);
+void ehca_cleanup_small_qp_cache(void);
 
 extern rwlock_t ehca_qp_idr_lock;
 extern rwlock_t ehca_cq_idr_lock;
@@ -324,7 +329,7 @@ struct ipzu_queue_resp {
 	u32 queue_length; /* queue length allocated in bytes */
 	u32 pagesize;
 	u32 toggle_state;
-	u32 dummy; /* padding for 8 byte alignment */
+	u32 offset; /* save offset within a page for small_qp */
 };
 
 struct ehca_create_cq_resp {
@@ -366,15 +371,29 @@ enum ehca_ll_comp_flags {
 	LLQP_COMP_MASK = 0x60,
 };
 
+struct ehca_alloc_queue_parms {
+	/* input parameters */
+	int max_wr;
+	int max_sge;
+	int page_size;
+	int is_small;
+
+	/* output parameters */
+	u16 act_nr_wqes;
+	u8  act_nr_sges;
+	u32 queue_size; /* bytes for small queues, pages otherwise */
+};
+
 struct ehca_alloc_qp_parms {
-/* input parameters */
+	struct ehca_alloc_queue_parms squeue;
+	struct ehca_alloc_queue_parms rqueue;
+
+	/* input parameters */
 	enum ehca_service_type servicetype;
+	int qp_storage;
 	int sigtype;
 	enum ehca_ext_qp_type ext_type;
 	enum ehca_ll_comp_flags ll_comp_flags;
-
-	int max_send_wr, max_recv_wr;
-	int max_send_sge, max_recv_sge;
 	int ud_av_l_key_ctl;
 
 	u32 token;
@@ -384,18 +403,10 @@ struct ehca_alloc_qp_parms {
 
 	u32 srq_qpn, srq_token, srq_limit;
 
-/* output parameters */
+	/* output parameters */
 	u32 real_qp_num;
 	struct ipz_qp_handle qp_handle;
 	struct h_galpas galpas;
-
-	u16 act_nr_send_wqes;
-	u16 act_nr_recv_wqes;
-	u8  act_nr_recv_sges;
-	u8  act_nr_send_sges;
-
-	u32 nr_rq_pages;
-	u32 nr_sq_pages;
 };
 
 int ehca_cq_assign_qp(struct ehca_cq *cq, struct ehca_qp *qp);
diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 9e87883..5746787 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -190,8 +190,8 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 		goto create_cq_exit2;
 	}
 
-	ipz_rc = ipz_queue_ctor(&my_cq->ipz_queue, param.act_pages,
-				EHCA_PAGESIZE, sizeof(struct ehca_cqe), 0);
+	ipz_rc = ipz_queue_ctor(NULL, &my_cq->ipz_queue, param.act_pages,
+				EHCA_PAGESIZE, sizeof(struct ehca_cqe), 0, 0);
 	if (!ipz_rc) {
 		ehca_err(device, "ipz_queue_ctor() failed ipz_rc=%x device=%p",
 			 ipz_rc, device);
@@ -285,7 +285,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 	return cq;
 
 create_cq_exit4:
-	ipz_queue_dtor(&my_cq->ipz_queue);
+	ipz_queue_dtor(NULL, &my_cq->ipz_queue);
 
 create_cq_exit3:
 	h_ret = hipz_h_destroy_cq(adapter_handle, my_cq, 1);
@@ -359,7 +359,7 @@ int ehca_destroy_cq(struct ib_cq *cq)
 			 "ehca_cq=%p cq_num=%x", h_ret, my_cq, cq_num);
 		return ehca2ib_return_code(h_ret);
 	}
-	ipz_queue_dtor(&my_cq->ipz_queue);
+	ipz_queue_dtor(NULL, &my_cq->ipz_queue);
 	kmem_cache_free(cq_cache, my_cq);
 
 	return 0;
diff --git a/drivers/infiniband/hw/ehca/ehca_eq.c b/drivers/infiniband/hw/ehca/ehca_eq.c
index 4825975..1d41faa 100644
--- a/drivers/infiniband/hw/ehca/ehca_eq.c
+++ b/drivers/infiniband/hw/ehca/ehca_eq.c
@@ -86,8 +86,8 @@ int ehca_create_eq(struct ehca_shca *shca,
 		return -EINVAL;
 	}
 
-	ret = ipz_queue_ctor(&eq->ipz_queue, nr_pages,
-			     EHCA_PAGESIZE, sizeof(struct ehca_eqe), 0);
+	ret = ipz_queue_ctor(NULL, &eq->ipz_queue, nr_pages,
+			     EHCA_PAGESIZE, sizeof(struct ehca_eqe), 0, 0);
 	if (!ret) {
 		ehca_err(ib_dev, "Can't allocate EQ pages eq=%p", eq);
 		goto create_eq_exit1;
@@ -145,7 +145,7 @@ int ehca_create_eq(struct ehca_shca *shca,
 	return 0;
 
 create_eq_exit2:
-	ipz_queue_dtor(&eq->ipz_queue);
+	ipz_queue_dtor(NULL, &eq->ipz_queue);
 
 create_eq_exit1:
 	hipz_h_destroy_eq(shca->ipz_hca_handle, eq);
@@ -181,7 +181,7 @@ int ehca_destroy_eq(struct ehca_shca *shca, struct ehca_eq *eq)
 		ehca_err(&shca->ib_device, "Can't free EQ resources.");
 		return -EINVAL;
 	}
-	ipz_queue_dtor(&eq->ipz_queue);
+	ipz_queue_dtor(NULL, &eq->ipz_queue);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 3bd7afb..e09a2ae 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -181,6 +181,12 @@ static int ehca_create_slab_caches(void)
 		goto create_slab_caches5;
 	}
 
+	ret = ehca_init_small_qp_cache();
+	if (ret) {
+		ehca_gen_err("Cannot create small queue SLAB cache.");
+		goto create_slab_caches6;
+	}
+
 #ifdef CONFIG_PPC_64K_PAGES
 	ctblk_cache = kmem_cache_create("ehca_cache_ctblk",
 					EHCA_PAGESIZE, H_CB_ALIGNMENT,
@@ -188,12 +194,15 @@ static int ehca_create_slab_caches(void)
 					NULL, NULL);
 	if (!ctblk_cache) {
 		ehca_gen_err("Cannot create ctblk SLAB cache.");
-		ehca_cleanup_mrmw_cache();
-		goto create_slab_caches5;
+		ehca_cleanup_small_qp_cache();
+		goto create_slab_caches6;
 	}
 #endif
 	return 0;
 
+create_slab_caches6:
+	ehca_cleanup_mrmw_cache();
+
 create_slab_caches5:
 	ehca_cleanup_av_cache();
 
@@ -211,6 +220,7 @@ create_slab_caches2:
 
 static void ehca_destroy_slab_caches(void)
 {
+	ehca_cleanup_small_qp_cache();
 	ehca_cleanup_mrmw_cache();
 	ehca_cleanup_av_cache();
 	ehca_cleanup_qp_cache();
diff --git a/drivers/infiniband/hw/ehca/ehca_pd.c b/drivers/infiniband/hw/ehca/ehca_pd.c
index 79d0591..79d5bc8 100644
--- a/drivers/infiniband/hw/ehca/ehca_pd.c
+++ b/drivers/infiniband/hw/ehca/ehca_pd.c
@@ -49,6 +49,7 @@ struct ib_pd *ehca_alloc_pd(struct ib_device *device,
 			    struct ib_ucontext *context, struct ib_udata *udata)
 {
 	struct ehca_pd *pd;
+	int i;
 
 	pd = kmem_cache_zalloc(pd_cache, GFP_KERNEL);
 	if (!pd) {
@@ -58,6 +59,11 @@ struct ib_pd *ehca_alloc_pd(struct ib_device *device,
 	}
 
 	pd->ownpid = current->tgid;
+	for (i = 0; i < 2; i++) {
+		INIT_LIST_HEAD(&pd->free[i]);
+		INIT_LIST_HEAD(&pd->full[i]);
+	}
+	mutex_init(&pd->lock);
 
 	/*
 	 * Kernel PD: when device = -1, 0
@@ -81,6 +87,9 @@ int ehca_dealloc_pd(struct ib_pd *pd)
 {
 	u32 cur_pid = current->tgid;
 	struct ehca_pd *my_pd = container_of(pd, struct ehca_pd, ib_pd);
+	int i, leftovers = 0;
+	extern struct kmem_cache *small_qp_cache;
+	struct ipz_small_queue_page *page, *tmp;
 
 	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
 	    my_pd->ownpid != cur_pid) {
@@ -89,8 +98,20 @@ int ehca_dealloc_pd(struct ib_pd *pd)
 		return -EINVAL;
 	}
 
-	kmem_cache_free(pd_cache,
-			container_of(pd, struct ehca_pd, ib_pd));
+	for (i = 0; i < 2; i++) {
+		list_splice(&my_pd->full[i], &my_pd->free[i]);
+		list_for_each_entry_safe(page, tmp, &my_pd->free[i], list) {
+			leftovers = 1;
+			free_page(page->page);
+			kmem_cache_free(small_qp_cache, page);
+		}
+	}
+
+	if (leftovers)
+		ehca_warn(pd->device,
+			  "Some small queue pages were not freed");
+
+	kmem_cache_free(pd_cache, my_pd);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index b916d9c..6c6f9d9 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -275,34 +275,39 @@ static inline void queue2resp(struct ipzu_queue_resp *resp,
 	resp->toggle_state = queue->toggle_state;
 }
 
-static inline int ll_qp_msg_size(int nr_sge)
-{
-	return 128 << nr_sge;
-}
-
 /*
  * init_qp_queue initializes/constructs r/squeue and registers queue pages.
  */
 static inline int init_qp_queue(struct ehca_shca *shca,
+				struct ehca_pd *pd,
 				struct ehca_qp *my_qp,
 				struct ipz_queue *queue,
 				int q_type,
 				u64 expected_hret,
-				int nr_q_pages,
-				int wqe_size,
-				int nr_sges)
+				struct ehca_alloc_queue_parms *parms,
+				int wqe_size)
 {
-	int ret, cnt, ipz_rc;
+	int ret, cnt, ipz_rc, nr_q_pages;
 	void *vpage;
 	u64 rpage, h_ret;
 	struct ib_device *ib_dev = &shca->ib_device;
 	struct ipz_adapter_handle ipz_hca_handle = shca->ipz_hca_handle;
 
-	if (!nr_q_pages)
+	if (!parms->queue_size)
 		return 0;
 
-	ipz_rc = ipz_queue_ctor(queue, nr_q_pages, EHCA_PAGESIZE,
-				wqe_size, nr_sges);
+	if (parms->is_small) {
+		nr_q_pages = 1;
+		ipz_rc = ipz_queue_ctor(pd, queue, nr_q_pages,
+					128 << parms->page_size,
+					wqe_size, parms->act_nr_sges, 1);
+	} else {
+		nr_q_pages = parms->queue_size;
+		ipz_rc = ipz_queue_ctor(pd, queue, nr_q_pages,
+					EHCA_PAGESIZE, wqe_size,
+					parms->act_nr_sges, 0);
+	}
+
 	if (!ipz_rc) {
 		ehca_err(ib_dev, "Cannot allocate page for queue. ipz_rc=%x",
 			 ipz_rc);
@@ -323,7 +328,7 @@ static inline int init_qp_queue(struct ehca_shca *shca,
 		h_ret = hipz_h_register_rpage_qp(ipz_hca_handle,
 						 my_qp->ipz_qp_handle,
 						 NULL, 0, q_type,
-						 rpage, 1,
+						 rpage, parms->is_small ? 0 : 1,
 						 my_qp->galpas.kernel);
 		if (cnt == (nr_q_pages - 1)) {	/* last page! */
 			if (h_ret != expected_hret) {
@@ -354,10 +359,45 @@ static inline int init_qp_queue(struct ehca_shca *shca,
 	return 0;
 
 init_qp_queue1:
-	ipz_queue_dtor(queue);
+	ipz_queue_dtor(pd, queue);
 	return ret;
 }
 
+static inline int ehca_calc_wqe_size(int act_nr_sge, int is_llqp)
+{
+	if (is_llqp)
+		return 128 << act_nr_sge;
+	else
+		return offsetof(struct ehca_wqe,
+				u.nud.sg_list[act_nr_sge]);
+}
+
+static void ehca_determine_small_queue(struct ehca_alloc_queue_parms *queue,
+				       int req_nr_sge, int is_llqp)
+{
+	u32 wqe_size, q_size;
+	int act_nr_sge = req_nr_sge;
+
+	if (!is_llqp)
+		/* round up #SGEs so WQE size is a power of 2 */
+		for (act_nr_sge = 4; act_nr_sge <= 252;
+		     act_nr_sge = 4 + 2 * act_nr_sge)
+			if (act_nr_sge >= req_nr_sge)
+				break;
+
+	wqe_size = ehca_calc_wqe_size(act_nr_sge, is_llqp);
+	q_size = wqe_size * (queue->max_wr + 1);
+
+	if (q_size <= 512)
+		queue->page_size = 2;
+	else if (q_size <= 1024)
+		queue->page_size = 3;
+	else
+		queue->page_size = 0;
+
+	queue->is_small = (queue->page_size != 0);
+}
+
 /*
  * Create an ib_qp struct that is either a QP or an SRQ, depending on
  * the value of the is_srq parameter. If init_attr and srq_init_attr share
@@ -553,10 +593,20 @@ static struct ehca_qp *internal_create_qp(
 	if (my_qp->recv_cq)
 		parms.recv_cq_handle = my_qp->recv_cq->ipz_cq_handle;
 
-	parms.max_send_wr = init_attr->cap.max_send_wr;
-	parms.max_recv_wr = init_attr->cap.max_recv_wr;
-	parms.max_send_sge = max_send_sge;
-	parms.max_recv_sge = max_recv_sge;
+	parms.squeue.max_wr = init_attr->cap.max_send_wr;
+	parms.rqueue.max_wr = init_attr->cap.max_recv_wr;
+	parms.squeue.max_sge = max_send_sge;
+	parms.rqueue.max_sge = max_recv_sge;
+
+	if (EHCA_BMASK_GET(HCA_CAP_MINI_QP, shca->hca_cap)
+	    && !(context && udata)) { /* no small QP support in userspace ATM */
+		ehca_determine_small_queue(
+			&parms.squeue, max_send_sge, is_llqp);
+		ehca_determine_small_queue(
+			&parms.rqueue, max_recv_sge, is_llqp);
+		parms.qp_storage =
+			(parms.squeue.is_small || parms.rqueue.is_small);
+	}
 
 	h_ret = hipz_h_alloc_resource_qp(shca->ipz_hca_handle, &parms);
 	if (h_ret != H_SUCCESS) {
@@ -570,50 +620,33 @@ static struct ehca_qp *internal_create_qp(
 	my_qp->ipz_qp_handle = parms.qp_handle;
 	my_qp->galpas = parms.galpas;
 
+	swqe_size = ehca_calc_wqe_size(parms.squeue.act_nr_sges, is_llqp);
+	rwqe_size = ehca_calc_wqe_size(parms.rqueue.act_nr_sges, is_llqp);
+
 	switch (qp_type) {
 	case IB_QPT_RC:
-		if (!is_llqp) {
-			swqe_size = offsetof(struct ehca_wqe, u.nud.sg_list[
-					     (parms.act_nr_send_sges)]);
-			rwqe_size = offsetof(struct ehca_wqe, u.nud.sg_list[
-					     (parms.act_nr_recv_sges)]);
-		} else { /* for LLQP we need to use msg size, not wqe size */
-			swqe_size = ll_qp_msg_size(max_send_sge);
-			rwqe_size = ll_qp_msg_size(max_recv_sge);
-			parms.act_nr_send_sges = 1;
-			parms.act_nr_recv_sges = 1;
-		}
-		break;
-	case IB_QPT_UC:
-		swqe_size = offsetof(struct ehca_wqe,
-				     u.nud.sg_list[parms.act_nr_send_sges]);
-		rwqe_size = offsetof(struct ehca_wqe,
-				     u.nud.sg_list[parms.act_nr_recv_sges]);
+		if (is_llqp) {
+			parms.squeue.act_nr_sges = 1;
+			parms.rqueue.act_nr_sges = 1;
+		}
 		break;
-
 	case IB_QPT_UD:
 	case IB_QPT_GSI:
 	case IB_QPT_SMI:
+		/* UD circumvention */
 		if (is_llqp) {
-			swqe_size = ll_qp_msg_size(parms.act_nr_send_sges);
-			rwqe_size = ll_qp_msg_size(parms.act_nr_recv_sges);
-			parms.act_nr_send_sges = 1;
-			parms.act_nr_recv_sges = 1;
+			parms.squeue.act_nr_sges = 1;
+			parms.rqueue.act_nr_sges = 1;
 		} else {
-			/* UD circumvention */
-			parms.act_nr_send_sges -= 2;
-			parms.act_nr_recv_sges -= 2;
-			swqe_size = offsetof(struct ehca_wqe, u.ud_av.sg_list[
-						     parms.act_nr_send_sges]);
-			rwqe_size = offsetof(struct ehca_wqe, u.ud_av.sg_list[
-						     parms.act_nr_recv_sges]);
+			parms.squeue.act_nr_sges -= 2;
+			parms.rqueue.act_nr_sges -= 2;
 		}
 
 		if (IB_QPT_GSI == qp_type || IB_QPT_SMI == qp_type) {
-			parms.act_nr_send_wqes = init_attr->cap.max_send_wr;
-			parms.act_nr_recv_wqes = init_attr->cap.max_recv_wr;
-			parms.act_nr_send_sges = init_attr->cap.max_send_sge;
-			parms.act_nr_recv_sges = init_attr->cap.max_recv_sge;
+			parms.squeue.act_nr_wqes = init_attr->cap.max_send_wr;
+			parms.rqueue.act_nr_wqes = init_attr->cap.max_recv_wr;
+			parms.squeue.act_nr_sges = init_attr->cap.max_send_sge;
+			parms.rqueue.act_nr_sges = init_attr->cap.max_recv_sge;
 			ib_qp_num = (qp_type == IB_QPT_SMI) ? 0 : 1;
 		}
 
@@ -626,10 +659,9 @@ static struct ehca_qp *internal_create_qp(
 	/* initialize r/squeue and register queue pages */
 	if (HAS_SQ(my_qp)) {
 		ret = init_qp_queue(
-			shca, my_qp, &my_qp->ipz_squeue, 0,
+			shca, my_pd, my_qp, &my_qp->ipz_squeue, 0,
 			HAS_RQ(my_qp) ? H_PAGE_REGISTERED : H_SUCCESS,
-			parms.nr_sq_pages, swqe_size,
-			parms.act_nr_send_sges);
+			&parms.squeue, swqe_size);
 		if (ret) {
 			ehca_err(pd->device, "Couldn't initialize squeue "
 				 "and pages  ret=%x", ret);
@@ -639,9 +671,8 @@ static struct ehca_qp *internal_create_qp(
 
 	if (HAS_RQ(my_qp)) {
 		ret = init_qp_queue(
-			shca, my_qp, &my_qp->ipz_rqueue, 1,
-			H_SUCCESS, parms.nr_rq_pages, rwqe_size,
-			parms.act_nr_recv_sges);
+			shca, my_pd, my_qp, &my_qp->ipz_rqueue, 1,
+			H_SUCCESS, &parms.rqueue, rwqe_size);
 		if (ret) {
 			ehca_err(pd->device, "Couldn't initialize rqueue "
 				 "and pages ret=%x", ret);
@@ -671,10 +702,10 @@ static struct ehca_qp *internal_create_qp(
 	}
 
 	init_attr->cap.max_inline_data = 0; /* not supported yet */
-	init_attr->cap.max_recv_sge = parms.act_nr_recv_sges;
-	init_attr->cap.max_recv_wr = parms.act_nr_recv_wqes;
-	init_attr->cap.max_send_sge = parms.act_nr_send_sges;
-	init_attr->cap.max_send_wr = parms.act_nr_send_wqes;
+	init_attr->cap.max_recv_sge = parms.rqueue.act_nr_sges;
+	init_attr->cap.max_recv_wr = parms.rqueue.act_nr_wqes;
+	init_attr->cap.max_send_sge = parms.squeue.act_nr_sges;
+	init_attr->cap.max_send_wr = parms.squeue.act_nr_wqes;
 	my_qp->init_attr = *init_attr;
 
 	/* NOTE: define_apq0() not supported yet */
@@ -708,6 +739,8 @@ static struct ehca_qp *internal_create_qp(
 		resp.ext_type = my_qp->ext_type;
 		resp.qkey = my_qp->qkey;
 		resp.real_qp_num = my_qp->real_qp_num;
+		resp.ipz_rqueue.offset = my_qp->ipz_rqueue.offset;
+		resp.ipz_squeue.offset = my_qp->ipz_squeue.offset;
 		if (HAS_SQ(my_qp))
 			queue2resp(&resp.ipz_squeue, &my_qp->ipz_squeue);
 		if (HAS_RQ(my_qp))
@@ -724,11 +757,11 @@ static struct ehca_qp *internal_create_qp(
 
 create_qp_exit4:
 	if (HAS_RQ(my_qp))
-		ipz_queue_dtor(&my_qp->ipz_rqueue);
+		ipz_queue_dtor(my_pd, &my_qp->ipz_rqueue);
 
 create_qp_exit3:
 	if (HAS_SQ(my_qp))
-		ipz_queue_dtor(&my_qp->ipz_squeue);
+		ipz_queue_dtor(my_pd, &my_qp->ipz_squeue);
 
 create_qp_exit2:
 	hipz_h_destroy_qp(shca->ipz_hca_handle, my_qp);
@@ -1735,9 +1768,9 @@ static int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
 	}
 
 	if (HAS_RQ(my_qp))
-		ipz_queue_dtor(&my_qp->ipz_rqueue);
+		ipz_queue_dtor(my_pd, &my_qp->ipz_rqueue);
 	if (HAS_SQ(my_qp))
-		ipz_queue_dtor(&my_qp->ipz_squeue);
+		ipz_queue_dtor(my_pd, &my_qp->ipz_squeue);
 	kmem_cache_free(qp_cache, my_qp);
 	return 0;
 }
diff --git a/drivers/infiniband/hw/ehca/ehca_uverbs.c b/drivers/infiniband/hw/ehca/ehca_uverbs.c
index 05c4157..4bc687f 100644
--- a/drivers/infiniband/hw/ehca/ehca_uverbs.c
+++ b/drivers/infiniband/hw/ehca/ehca_uverbs.c
@@ -149,7 +149,7 @@ static int ehca_mmap_queue(struct vm_area_struct *vma, struct ipz_queue *queue,
 			ehca_gen_err("vm_insert_page() failed rc=%x", ret);
 			return ret;
 		}
-		start +=  PAGE_SIZE;
+		start += PAGE_SIZE;
 	}
 	vma->vm_private_data = mm_count;
 	(*mm_count)++;
diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index 358796c..fdbfebe 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -52,10 +52,13 @@
 #define H_ALL_RES_QP_ENHANCED_OPS       EHCA_BMASK_IBM(9, 11)
 #define H_ALL_RES_QP_PTE_PIN            EHCA_BMASK_IBM(12, 12)
 #define H_ALL_RES_QP_SERVICE_TYPE       EHCA_BMASK_IBM(13, 15)
+#define H_ALL_RES_QP_STORAGE            EHCA_BMASK_IBM(16, 17)
 #define H_ALL_RES_QP_LL_RQ_CQE_POSTING  EHCA_BMASK_IBM(18, 18)
 #define H_ALL_RES_QP_LL_SQ_CQE_POSTING  EHCA_BMASK_IBM(19, 21)
 #define H_ALL_RES_QP_SIGNALING_TYPE     EHCA_BMASK_IBM(22, 23)
 #define H_ALL_RES_QP_UD_AV_LKEY_CTRL    EHCA_BMASK_IBM(31, 31)
+#define H_ALL_RES_QP_SMALL_SQ_PAGE_SIZE EHCA_BMASK_IBM(32, 35)
+#define H_ALL_RES_QP_SMALL_RQ_PAGE_SIZE EHCA_BMASK_IBM(36, 39)
 #define H_ALL_RES_QP_RESOURCE_TYPE      EHCA_BMASK_IBM(56, 63)
 
 #define H_ALL_RES_QP_MAX_OUTST_SEND_WR  EHCA_BMASK_IBM(0, 15)
@@ -299,6 +302,11 @@ u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
 		| EHCA_BMASK_SET(H_ALL_RES_QP_PTE_PIN, 0)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_SERVICE_TYPE, parms->servicetype)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_SIGNALING_TYPE, parms->sigtype)
+		| EHCA_BMASK_SET(H_ALL_RES_QP_STORAGE, parms->qp_storage)
+		| EHCA_BMASK_SET(H_ALL_RES_QP_SMALL_SQ_PAGE_SIZE,
+				 parms->squeue.page_size)
+		| EHCA_BMASK_SET(H_ALL_RES_QP_SMALL_RQ_PAGE_SIZE,
+				 parms->rqueue.page_size)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_LL_RQ_CQE_POSTING,
 				 !!(parms->ll_comp_flags & LLQP_RECV_COMP))
 		| EHCA_BMASK_SET(H_ALL_RES_QP_LL_SQ_CQE_POSTING,
@@ -309,13 +317,13 @@ u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
 
 	max_r10_reg =
 		EHCA_BMASK_SET(H_ALL_RES_QP_MAX_OUTST_SEND_WR,
-			       parms->max_send_wr + 1)
+			       parms->squeue.max_wr + 1)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_MAX_OUTST_RECV_WR,
-				 parms->max_recv_wr + 1)
+				 parms->rqueue.max_wr + 1)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_MAX_SEND_SGE,
-				 parms->max_send_sge)
+				 parms->squeue.max_sge)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_MAX_RECV_SGE,
-				 parms->max_recv_sge);
+				 parms->rqueue.max_sge);
 
 	r11 = EHCA_BMASK_SET(H_ALL_RES_QP_SRQ_QP_TOKEN, parms->srq_token);
 
@@ -335,17 +343,17 @@ u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
 
 	parms->qp_handle.handle = outs[0];
 	parms->real_qp_num = (u32)outs[1];
-	parms->act_nr_send_wqes =
+	parms->squeue.act_nr_wqes =
 		(u16)EHCA_BMASK_GET(H_ALL_RES_QP_ACT_OUTST_SEND_WR, outs[2]);
-	parms->act_nr_recv_wqes =
+	parms->rqueue.act_nr_wqes =
 		(u16)EHCA_BMASK_GET(H_ALL_RES_QP_ACT_OUTST_RECV_WR, outs[2]);
-	parms->act_nr_send_sges =
+	parms->squeue.act_nr_sges =
 		(u8)EHCA_BMASK_GET(H_ALL_RES_QP_ACT_SEND_SGE, outs[3]);
-	parms->act_nr_recv_sges =
+	parms->rqueue.act_nr_sges =
 		(u8)EHCA_BMASK_GET(H_ALL_RES_QP_ACT_RECV_SGE, outs[3]);
-	parms->nr_sq_pages =
+	parms->squeue.queue_size =
 		(u32)EHCA_BMASK_GET(H_ALL_RES_QP_SQUEUE_SIZE_PAGES, outs[4]);
-	parms->nr_rq_pages =
+	parms->rqueue.queue_size =
 		(u32)EHCA_BMASK_GET(H_ALL_RES_QP_RQUEUE_SIZE_PAGES, outs[4]);
 
 	if (ret == H_SUCCESS)
@@ -497,7 +505,7 @@ u64 hipz_h_register_rpage_qp(const struct ipz_adapter_handle adapter_handle,
 			     const u64 count,
 			     const struct h_galpa galpa)
 {
-	if (count != 1) {
+	if (count > 1) {
 		ehca_gen_err("Page counter=%lx", count);
 		return H_PARAMETER;
 	}
diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.c b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
index 9606f13..6506501 100644
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.c
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
@@ -40,6 +40,11 @@
 
 #include "ehca_tools.h"
 #include "ipz_pt_fn.h"
+#include "ehca_classes.h"
+
+#define PAGES_PER_KPAGE (PAGE_SIZE >> EHCA_PAGESHIFT)
+
+struct kmem_cache *small_qp_cache;
 
 void *ipz_qpageit_get_inc(struct ipz_queue *queue)
 {
@@ -49,7 +54,7 @@ void *ipz_qpageit_get_inc(struct ipz_queue *queue)
 		queue->current_q_offset -= queue->pagesize;
 		ret = NULL;
 	}
-	if (((u64)ret) % EHCA_PAGESIZE) {
+	if (((u64)ret) % queue->pagesize) {
 		ehca_gen_err("ERROR!! not at PAGE-Boundary");
 		return NULL;
 	}
@@ -83,80 +88,195 @@ int ipz_queue_abs_to_offset(struct ipz_queue *queue, u64 addr, u64 *q_offset)
 	return -EINVAL;
 }
 
-int ipz_queue_ctor(struct ipz_queue *queue,
-		   const u32 nr_of_pages,
-		   const u32 pagesize, const u32 qe_size, const u32 nr_of_sg)
+#if PAGE_SHIFT < EHCA_PAGESHIFT
+#error Kernel pages must be at least as large than eHCA pages (4K) !
+#endif
+
+/*
+ * allocate pages for queue:
+ * outer loop allocates whole kernel pages (page aligned) and
+ * inner loop divides a kernel page into smaller hca queue pages
+ */
+static int alloc_queue_pages(struct ipz_queue *queue, const u32 nr_of_pages)
 {
-	int pages_per_kpage = PAGE_SIZE >> EHCA_PAGESHIFT;
-	int f;
+	int k, f = 0;
+	u8 *kpage;
 
-	if (pagesize > PAGE_SIZE) {
-		ehca_gen_err("FATAL ERROR: pagesize=%x is greater "
-			     "than kernel page size", pagesize);
-		return 0;
-	}
-	if (!pages_per_kpage) {
-		ehca_gen_err("FATAL ERROR: invalid kernel page size. "
-			     "pages_per_kpage=%x", pages_per_kpage);
-		return 0;
-	}
-	queue->queue_length = nr_of_pages * pagesize;
-	queue->queue_pages = vmalloc(nr_of_pages * sizeof(void *));
-	if (!queue->queue_pages) {
-		ehca_gen_err("ERROR!! didn't get the memory");
-		return 0;
-	}
-	memset(queue->queue_pages, 0, nr_of_pages * sizeof(void *));
-	/*
-	 * allocate pages for queue:
-	 * outer loop allocates whole kernel pages (page aligned) and
-	 * inner loop divides a kernel page into smaller hca queue pages
-	 */
-	f = 0;
 	while (f < nr_of_pages) {
-		u8 *kpage = (u8 *)get_zeroed_page(GFP_KERNEL);
-		int k;
+		kpage = (u8 *)get_zeroed_page(GFP_KERNEL);
 		if (!kpage)
-			goto ipz_queue_ctor_exit0; /*NOMEM*/
-		for (k = 0; k < pages_per_kpage && f < nr_of_pages; k++) {
-			(queue->queue_pages)[f] = (struct ipz_page *)kpage;
+			goto out;
+
+		for (k = 0; k < PAGES_PER_KPAGE && f < nr_of_pages; k++) {
+			queue->queue_pages[f] = (struct ipz_page *)kpage;
 			kpage += EHCA_PAGESIZE;
 			f++;
 		}
 	}
+	return 1;
 
-	queue->current_q_offset = 0;
+out:
+	for (f = 0; f < nr_of_pages && queue->queue_pages[f];
+	     f += PAGES_PER_KPAGE)
+		free_page((unsigned long)(queue->queue_pages)[f]);
+	return 0;
+}
+
+static int alloc_small_queue_page(struct ipz_queue *queue, struct ehca_pd *pd)
+{
+	int order = ilog2(queue->pagesize) - 9;
+	struct ipz_small_queue_page *page;
+	unsigned long bit;
+
+	mutex_lock(&pd->lock);
+
+	if (!list_empty(&pd->free[order]))
+		page = list_entry(pd->free[order].next,
+				  struct ipz_small_queue_page, list);
+	else {
+		page = kmem_cache_zalloc(small_qp_cache, GFP_KERNEL);
+		if (!page)
+			goto out;
+
+		page->page = get_zeroed_page(GFP_KERNEL);
+		if (!page->page) {
+			kmem_cache_free(small_qp_cache, page);
+			goto out;
+		}
+
+		list_add(&page->list, &pd->free[order]);
+	}
+
+	bit = find_first_zero_bit(page->bitmap, IPZ_SPAGE_PER_KPAGE >> order);
+	__set_bit(bit, page->bitmap);
+	page->fill++;
+
+	if (page->fill == IPZ_SPAGE_PER_KPAGE >> order)
+		list_move(&page->list, &pd->full[order]);
+
+	mutex_unlock(&pd->lock);
+
+	queue->queue_pages[0] = (void *)(page->page | (bit << (order + 9)));
+	queue->small_page = page;
+	return 1;
+
+out:
+	ehca_err(pd->ib_pd.device, "failed to allocate small queue page");
+	return 0;
+}
+
+static void free_small_queue_page(struct ipz_queue *queue, struct ehca_pd *pd)
+{
+	int order = ilog2(queue->pagesize) - 9;
+	struct ipz_small_queue_page *page = queue->small_page;
+	unsigned long bit;
+	int free_page = 0;
+
+	bit = ((unsigned long)queue->queue_pages[0] & PAGE_MASK)
+		>> (order + 9);
+
+	mutex_lock(&pd->lock);
+
+	__clear_bit(bit, page->bitmap);
+	page->fill--;
+
+	if (page->fill == 0) {
+		list_del(&page->list);
+		free_page = 1;
+	}
+
+	if (page->fill == (IPZ_SPAGE_PER_KPAGE >> order) - 1)
+		/* the page was full until we freed the chunk */
+		list_move_tail(&page->list, &pd->free[order]);
+
+	mutex_unlock(&pd->lock);
+
+	if (free_page) {
+		free_page(page->page);
+		kmem_cache_free(small_qp_cache, page);
+	}
+}
+
+int ipz_queue_ctor(struct ehca_pd *pd, struct ipz_queue *queue,
+		   const u32 nr_of_pages, const u32 pagesize,
+		   const u32 qe_size, const u32 nr_of_sg,
+		   int is_small)
+{
+	if (pagesize > PAGE_SIZE) {
+		ehca_gen_err("FATAL ERROR: pagesize=%x "
+			     "is greater than kernel page size", pagesize);
+		return 0;
+	}
+
+	/* init queue fields */
+	queue->queue_length = nr_of_pages * pagesize;
+	queue->pagesize = pagesize;
 	queue->qe_size = qe_size;
 	queue->act_nr_of_sg = nr_of_sg;
-	queue->pagesize = pagesize;
+	queue->current_q_offset = 0;
 	queue->toggle_state = 1;
-	return 1;
+	queue->small_page = NULL;
 
- ipz_queue_ctor_exit0:
-	ehca_gen_err("Couldn't get alloc pages queue=%p f=%x nr_of_pages=%x",
-		     queue, f, nr_of_pages);
-	for (f = 0; f < nr_of_pages; f += pages_per_kpage) {
-		if (!(queue->queue_pages)[f])
-			break;
-		free_page((unsigned long)(queue->queue_pages)[f]);
+	/* allocate queue page pointers */
+	queue->queue_pages = vmalloc(nr_of_pages * sizeof(void *));
+	if (!queue->queue_pages) {
+		ehca_gen_err("Couldn't allocate queue page list");
+		return 0;
 	}
+	memset(queue->queue_pages, 0, nr_of_pages * sizeof(void *));
+
+	/* allocate actual queue pages */
+	if (is_small) {
+		if (!alloc_small_queue_page(queue, pd))
+			goto ipz_queue_ctor_exit0;
+	} else
+		if (!alloc_queue_pages(queue, nr_of_pages))
+			goto ipz_queue_ctor_exit0;
+
+	return 1;
+
+ipz_queue_ctor_exit0:
+	ehca_gen_err("Couldn't alloc pages queue=%p "
+		 "nr_of_pages=%x",  queue, nr_of_pages);
+	vfree(queue->queue_pages);
+
 	return 0;
 }
 
-int ipz_queue_dtor(struct ipz_queue *queue)
+int ipz_queue_dtor(struct ehca_pd *pd, struct ipz_queue *queue)
 {
-	int pages_per_kpage = PAGE_SIZE >> EHCA_PAGESHIFT;
-	int g;
-	int nr_pages;
+	int i, nr_pages;
 
 	if (!queue || !queue->queue_pages) {
 		ehca_gen_dbg("queue or queue_pages is NULL");
 		return 0;
 	}
-	nr_pages = queue->queue_length / queue->pagesize;
-	for (g = 0; g < nr_pages; g += pages_per_kpage)
-		free_page((unsigned long)(queue->queue_pages)[g]);
+
+	if (queue->small_page)
+		free_small_queue_page(queue, pd);
+	else {
+		nr_pages = queue->queue_length / queue->pagesize;
+		for (i = 0; i < nr_pages; i += PAGES_PER_KPAGE)
+			free_page((unsigned long)queue->queue_pages[i]);
+	}
+
 	vfree(queue->queue_pages);
 
 	return 1;
 }
+
+int ehca_init_small_qp_cache(void)
+{
+	small_qp_cache = kmem_cache_create("ehca_cache_small_qp",
+					   sizeof(struct ipz_small_queue_page),
+					   0, SLAB_HWCACHE_ALIGN, NULL, NULL);
+	if (!small_qp_cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void ehca_cleanup_small_qp_cache(void)
+{
+	kmem_cache_destroy(small_qp_cache);
+}
diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.h b/drivers/infiniband/hw/ehca/ipz_pt_fn.h
index 39a4f64..c6937a0 100644
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.h
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.h
@@ -51,11 +51,25 @@
 #include "ehca_tools.h"
 #include "ehca_qes.h"
 
+struct ehca_pd;
+struct ipz_small_queue_page;
+
 /* struct generic ehca page */
 struct ipz_page {
 	u8 entries[EHCA_PAGESIZE];
 };
 
+#define IPZ_SPAGE_PER_KPAGE (PAGE_SIZE / 512)
+
+struct ipz_small_queue_page {
+	unsigned long page;
+	unsigned long bitmap[IPZ_SPAGE_PER_KPAGE / BITS_PER_LONG];
+	int fill;
+	void *mapped_addr;
+	u32 mmap_count;
+	struct list_head list;
+};
+
 /* struct generic queue in linux kernel virtual memory (kv) */
 struct ipz_queue {
 	u64 current_q_offset;	/* current queue entry */
@@ -66,7 +80,8 @@ struct ipz_queue {
 	u32 queue_length;	/* queue length allocated in bytes */
 	u32 pagesize;
 	u32 toggle_state;	/* toggle flag - per page */
-	u32 dummy3;		/* 64 bit alignment */
+	u32 offset; /* save offset within page for small_qp */
+	struct ipz_small_queue_page *small_page;
 };
 
 /*
@@ -188,9 +203,10 @@ struct ipz_qpt {
  * see ipz_qpt_ctor()
  * returns true if ok, false if out of memory
  */
-int ipz_queue_ctor(struct ipz_queue *queue, const u32 nr_of_pages,
-		   const u32 pagesize, const u32 qe_size,
-		   const u32 nr_of_sg);
+int ipz_queue_ctor(struct ehca_pd *pd, struct ipz_queue *queue,
+		   const u32 nr_of_pages, const u32 pagesize,
+		   const u32 qe_size, const u32 nr_of_sg,
+		   int is_small);
 
 /*
  * destructor for a ipz_queue_t
@@ -198,7 +214,7 @@ int ipz_queue_ctor(struct ipz_queue *queue, const u32 nr_of_pages,
  *  see ipz_queue_ctor()
  *  returns true if ok, false if queue was NULL-ptr of free failed
  */
-int ipz_queue_dtor(struct ipz_queue *queue);
+int ipz_queue_dtor(struct ehca_pd *pd, struct ipz_queue *queue);
 
 /*
  * constructor for a ipz_qpt_t,
-- 
1.5.2



