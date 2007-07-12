Return-Path: <linux-kernel-owner+w=401wt.eu-S1762928AbXGLPqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762928AbXGLPqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 11:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758165AbXGLPql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 11:46:41 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:5928 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125AbXGLPqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 11:46:39 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 01/10] IB/ehca: Support for multiple event queues
Date: Thu, 12 Jul 2007 17:46:35 +0200
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707121745.27592.fenkes@de.ibm.com>
In-Reply-To: <200707121745.27592.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707121746.36763.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

The eHCA driver can now handle multiple event queues (read: interrupt
sources) instead of one. The number of available EQs is selected via the
nr_eqs module parameter.

CQs are either assigned to the EQs based on the comp_vector index or, if the
dist_eqs module parameter is supplied, using a round-robin scheme.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |   13 +++-
 drivers/infiniband/hw/ehca/ehca_cq.c      |   16 +++-
 drivers/infiniband/hw/ehca/ehca_eq.c      |  139 ++++++++++++++++++-----------
 drivers/infiniband/hw/ehca/ehca_irq.c     |   36 +++-----
 drivers/infiniband/hw/ehca/ehca_irq.h     |    8 +-
 drivers/infiniband/hw/ehca/ehca_iverbs.h  |    9 +-
 drivers/infiniband/hw/ehca/ehca_main.c    |  118 ++++++++++++++++++++-----
 drivers/infiniband/hw/ehca/ehca_qp.c      |    2 +-
 8 files changed, 233 insertions(+), 108 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index daf823e..b2d614a 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -72,7 +72,11 @@ struct ehca_eqe_cache_entry {
 	struct ehca_cq *cq;
 };
 
+struct ehca_shca;
+
 struct ehca_eq {
+	struct ehca_shca *shca;
+	char name[17];
 	u32 length;
 	struct ipz_queue ipz_queue;
 	struct ipz_eq_handle ipz_eq_handle;
@@ -100,6 +104,7 @@ struct ehca_sport {
 	struct ehca_sma_attr saved_attr;
 };
 
+#define EHCA_MAX_NR_EQS 512
 struct ehca_shca {
 	struct ib_device ib_device;
 	struct ibmebus_dev *ibmebus_dev;
@@ -108,14 +113,16 @@ struct ehca_shca {
 	struct list_head shca_list;
 	struct ipz_adapter_handle ipz_hca_handle;
 	struct ehca_sport sport[2];
-	struct ehca_eq eq;
-	struct ehca_eq neq;
+	struct ehca_eq **eqs;
+	struct ehca_eq *aeq; /* async event for qps */
+	struct ehca_eq *neq;
 	struct ehca_mr *maxmr;
 	struct ehca_pd *pd;
 	struct h_galpas galpas;
 	struct mutex modify_mutex;
 	u64 hca_cap;
 	int max_mtu;
+	atomic_t cur_eq_idx;
 };
 
 struct ehca_pd {
@@ -290,6 +297,8 @@ struct ehca_ucontext {
 
 int ehca_init_pd_cache(void);
 void ehca_cleanup_pd_cache(void);
+int ehca_init_eq_cache(void);
+void ehca_cleanup_eq_cache(void);
 int ehca_init_cq_cache(void);
 void ehca_cleanup_cq_cache(void);
 int ehca_init_qp_cache(void);
diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 01d4a14..97da51e 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -117,6 +117,8 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 			     struct ib_ucontext *context,
 			     struct ib_udata *udata)
 {
+	extern int ehca_nr_eqs;
+	extern int ehca_dist_eqs;
 	static const u32 additional_cqe = 20;
 	struct ib_cq *cq;
 	struct ehca_cq *my_cq;
@@ -134,6 +136,12 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 	if (cqe >= 0xFFFFFFFF - 64 - additional_cqe)
 		return ERR_PTR(-EINVAL);
 
+	if (comp_vector < 0 || comp_vector >= ehca_nr_eqs) {
+		ehca_err(device, "Invalid comp_vector=%x ehca_nr_eqs=%x",
+			 comp_vector, ehca_nr_eqs);
+		return ERR_PTR(-EINVAL);
+	}
+
 	my_cq = kmem_cache_zalloc(cq_cache, GFP_KERNEL);
 	if (!my_cq) {
 		ehca_err(device, "Out of memory for ehca_cq struct device=%p",
@@ -153,7 +161,13 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 	cq = &my_cq->ib_cq;
 
 	adapter_handle = shca->ipz_hca_handle;
-	param.eq_handle = shca->eq.ipz_eq_handle;
+	if (!ehca_dist_eqs)
+		param.eq_handle = shca->eqs[comp_vector]->ipz_eq_handle;
+	else {
+		u32 eq_idx = atomic_inc_return(&shca->cur_eq_idx) % ehca_nr_eqs;
+		param.eq_handle = shca->eqs[eq_idx]->ipz_eq_handle;
+		ehca_dbg(device, "assigned comp_vector=%x", eq_idx);
+	}
 
 	do {
 		if (!idr_pre_get(&ehca_cq_idr, GFP_KERNEL)) {
diff --git a/drivers/infiniband/hw/ehca/ehca_eq.c b/drivers/infiniband/hw/ehca/ehca_eq.c
index 4961eb8..d443bcb 100644
--- a/drivers/infiniband/hw/ehca/ehca_eq.c
+++ b/drivers/infiniband/hw/ehca/ehca_eq.c
@@ -8,6 +8,7 @@
  *           Reinhard Ernst <rernst@de.ibm.com>
  *           Heiko J Schick <schickhj@de.ibm.com>
  *           Hoang-Nam Nguyen <hnguyen@de.ibm.com>
+ *           Joachim Fenkes <fenkes@de.ibm.com>
  *
  *
  *  Copyright (c) 2005 IBM Corporation
@@ -50,40 +51,54 @@
 #include "hcp_if.h"
 #include "ipz_pt_fn.h"
 
-int ehca_create_eq(struct ehca_shca *shca,
-		   struct ehca_eq *eq,
-		   const enum ehca_eq_type type, const u32 length)
+static struct kmem_cache *eq_cache;
+
+struct ehca_eq *ehca_create_eq(struct ehca_shca *shca,
+			       const enum ehca_eq_type type, const u32 length)
 {
-	u64 ret;
+	struct ehca_eq *eq = NULL;
+	int ret;
+	u64 h_ret;
 	u32 nr_pages;
 	u32 i;
 	void *vpage;
 	struct ib_device *ib_dev = &shca->ib_device;
 
-	spin_lock_init(&eq->spinlock);
-	spin_lock_init(&eq->irq_spinlock);
-	eq->is_initialized = 0;
+	if (!length) {
+		ehca_err(ib_dev, "EQ length must not be zero.");
+		return ERR_PTR(-EINVAL);
+	}
 
 	if (type != EHCA_EQ && type != EHCA_NEQ) {
-		ehca_err(ib_dev, "Invalid EQ type %x. eq=%p", type, eq);
-		return -EINVAL;
+		ehca_err(ib_dev, "Invalid EQ type %x", type);
+		return ERR_PTR(-EINVAL);
 	}
-	if (!length) {
-		ehca_err(ib_dev, "EQ length must not be zero. eq=%p", eq);
-		return -EINVAL;
+
+	eq = kmem_cache_zalloc(eq_cache, GFP_KERNEL);
+	if (!eq) {
+		ehca_err(ib_dev, "Out of memory for ehca_eq struct device=%p",
+			 ib_dev);
+		return ERR_PTR(-ENOMEM);
 	}
 
-	ret = hipz_h_alloc_resource_eq(shca->ipz_hca_handle,
-				       &eq->pf,
-				       type,
-				       length,
-				       &eq->ipz_eq_handle,
-				       &eq->length,
-				       &nr_pages, &eq->ist);
+	spin_lock_init(&eq->spinlock);
+	spin_lock_init(&eq->irq_spinlock);
+	eq->is_initialized = 0;
+	eq->shca = shca;
 
-	if (ret != H_SUCCESS) {
-		ehca_err(ib_dev, "Can't allocate EQ/NEQ. eq=%p", eq);
-		return -EINVAL;
+	h_ret = hipz_h_alloc_resource_eq(shca->ipz_hca_handle,
+					 &eq->pf,
+					 type,
+					 length,
+					 &eq->ipz_eq_handle,
+					 &eq->length,
+					 &nr_pages, &eq->ist);
+
+	if (h_ret != H_SUCCESS) {
+		ehca_err(ib_dev, "Can't allocate EQ/NEQ. eq=%p h_ret=%lx",
+			 eq, h_ret);
+		ret = -EINVAL;
+		goto create_eq_exit0;
 	}
 
 	ret = ipz_queue_ctor(&eq->ipz_queue, nr_pages,
@@ -97,51 +112,51 @@ int ehca_create_eq(struct ehca_shca *shca,
 		u64 rpage;
 
 		if (!(vpage = ipz_qpageit_get_inc(&eq->ipz_queue))) {
-			ret = H_RESOURCE;
+			ret = -ENOMEM;
 			goto create_eq_exit2;
 		}
 
 		rpage = virt_to_abs(vpage);
-		ret = hipz_h_register_rpage_eq(shca->ipz_hca_handle,
-					       eq->ipz_eq_handle,
-					       &eq->pf,
-					       0, 0, rpage, 1);
+		h_ret = hipz_h_register_rpage_eq(shca->ipz_hca_handle,
+						 eq->ipz_eq_handle,
+						 &eq->pf,
+						 0, 0, rpage, 1);
 
 		if (i == (nr_pages - 1)) {
 			/* last page */
 			vpage = ipz_qpageit_get_inc(&eq->ipz_queue);
-			if (ret != H_SUCCESS || vpage)
+			if (h_ret != H_SUCCESS || vpage) {
+				ret = -ENOMEM;
 				goto create_eq_exit2;
+			}
 		} else {
-			if (ret != H_PAGE_REGISTERED || !vpage)
+			if (h_ret != H_PAGE_REGISTERED || !vpage) {
+				ret = -ENOMEM;
 				goto create_eq_exit2;
+			}
 		}
 	}
 
 	ipz_qeit_reset(&eq->ipz_queue);
 
 	/* register interrupt handlers and initialize work queues */
-	if (type == EHCA_EQ) {
-		ret = ibmebus_request_irq(NULL, eq->ist, ehca_interrupt_eq,
-					  IRQF_DISABLED, "ehca_eq",
-					  (void *)shca);
-		if (ret < 0)
-			ehca_err(ib_dev, "Can't map interrupt handler.");
-
-		tasklet_init(&eq->interrupt_task, ehca_tasklet_eq, (long)shca);
-	} else if (type == EHCA_NEQ) {
-		ret = ibmebus_request_irq(NULL, eq->ist, ehca_interrupt_neq,
-					  IRQF_DISABLED, "ehca_neq",
-					  (void *)shca);
-		if (ret < 0)
-			ehca_err(ib_dev, "Can't map interrupt handler.");
-
-		tasklet_init(&eq->interrupt_task, ehca_tasklet_neq, (long)shca);
-	}
+	if (type == EHCA_EQ)
+		snprintf(eq->name, sizeof(eq->name), "ehca_eq_%x", eq->ist);
+	else
+		snprintf(eq->name, sizeof(eq->name), "ehca_neq");
+
+	ret = ibmebus_request_irq(NULL, eq->ist, ehca_interrupt,
+				  IRQF_DISABLED, eq->name, (void *)eq);
+	if (ret < 0)
+		ehca_err(ib_dev, "Can't map interrupt handler.");
+
+	tasklet_init(&eq->interrupt_task,
+		     (type == EHCA_EQ) ? ehca_tasklet_eq : ehca_tasklet_neq,
+		     (long)eq);
 
 	eq->is_initialized = 1;
 
-	return 0;
+	return eq;
 
 create_eq_exit2:
 	ipz_queue_dtor(&eq->ipz_queue);
@@ -149,10 +164,13 @@ create_eq_exit2:
 create_eq_exit1:
 	hipz_h_destroy_eq(shca->ipz_hca_handle, eq);
 
-	return -EINVAL;
+create_eq_exit0:
+	kmem_cache_free(eq_cache, eq);
+
+	return ERR_PTR(ret);
 }
 
-void *ehca_poll_eq(struct ehca_shca *shca, struct ehca_eq *eq)
+void *ehca_poll_eq(struct ehca_eq *eq)
 {
 	unsigned long flags;
 	void *eqe;
@@ -164,13 +182,14 @@ void *ehca_poll_eq(struct ehca_shca *shca, struct ehca_eq *eq)
 	return eqe;
 }
 
-int ehca_destroy_eq(struct ehca_shca *shca, struct ehca_eq *eq)
+int ehca_destroy_eq(struct ehca_eq *eq)
 {
+	struct ehca_shca *shca = eq->shca;
 	unsigned long flags;
 	u64 h_ret;
 
 	spin_lock_irqsave(&eq->spinlock, flags);
-	ibmebus_free_irq(NULL, eq->ist, (void *)shca);
+	ibmebus_free_irq(NULL, eq->ist, (void *)eq);
 
 	h_ret = hipz_h_destroy_eq(shca->ipz_hca_handle, eq);
 
@@ -181,6 +200,24 @@ int ehca_destroy_eq(struct ehca_shca *shca, struct ehca_eq *eq)
 		return -EINVAL;
 	}
 	ipz_queue_dtor(&eq->ipz_queue);
+	kmem_cache_free(eq_cache, eq);
 
 	return 0;
 }
+
+int ehca_init_eq_cache(void)
+{
+	eq_cache = kmem_cache_create("ehca_cache_eq",
+				     sizeof(struct ehca_eq), 0,
+				     SLAB_HWCACHE_ALIGN,
+				     NULL, NULL);
+	if (!eq_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void ehca_cleanup_eq_cache(void)
+{
+	if (eq_cache)
+		kmem_cache_destroy(eq_cache);
+}
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 96eba38..7a4071a 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -389,32 +389,24 @@ static inline void reset_eq_pending(struct ehca_cq *cq)
 	return;
 }
 
-irqreturn_t ehca_interrupt_neq(int irq, void *dev_id)
-{
-	struct ehca_shca *shca = (struct ehca_shca*)dev_id;
-
-	tasklet_hi_schedule(&shca->neq.interrupt_task);
-
-	return IRQ_HANDLED;
-}
-
 void ehca_tasklet_neq(unsigned long data)
 {
-	struct ehca_shca *shca = (struct ehca_shca*)data;
+	struct ehca_eq *neq = (struct ehca_eq *)data;
+	struct ehca_shca *shca = neq->shca;
 	struct ehca_eqe *eqe;
 	u64 ret;
 
-	eqe = (struct ehca_eqe *)ehca_poll_eq(shca, &shca->neq);
+	eqe = (struct ehca_eqe *)ehca_poll_eq(neq);
 
 	while (eqe) {
 		if (!EHCA_BMASK_GET(NEQE_COMPLETION_EVENT, eqe->entry))
 			parse_ec(shca, eqe->entry);
 
-		eqe = (struct ehca_eqe *)ehca_poll_eq(shca, &shca->neq);
+		eqe = (struct ehca_eqe *)ehca_poll_eq(neq);
 	}
 
 	ret = hipz_h_reset_event(shca->ipz_hca_handle,
-				 shca->neq.ipz_eq_handle, 0xFFFFFFFFFFFFFFFFL);
+				 neq->ipz_eq_handle, 0xFFFFFFFFFFFFFFFFL);
 
 	if (ret != H_SUCCESS)
 		ehca_err(&shca->ib_device, "Can't clear notification events.");
@@ -422,11 +414,11 @@ void ehca_tasklet_neq(unsigned long data)
 	return;
 }
 
-irqreturn_t ehca_interrupt_eq(int irq, void *dev_id)
+irqreturn_t ehca_interrupt(int irq, void *dev_id)
 {
-	struct ehca_shca *shca = (struct ehca_shca*)dev_id;
+	struct ehca_eq *eq = (struct ehca_eq *)dev_id;
 
-	tasklet_hi_schedule(&shca->eq.interrupt_task);
+	tasklet_hi_schedule(&eq->interrupt_task);
 
 	return IRQ_HANDLED;
 }
@@ -468,9 +460,9 @@ static inline void process_eqe(struct ehca_shca *shca, struct ehca_eqe *eqe)
 	}
 }
 
-void ehca_process_eq(struct ehca_shca *shca, int is_irq)
+void ehca_process_eq(struct ehca_eq *eq, int is_irq)
 {
-	struct ehca_eq *eq = &shca->eq;
+	struct ehca_shca *shca = eq->shca;
 	struct ehca_eqe_cache_entry *eqe_cache = eq->eqe_cache;
 	u64 eqe_value;
 	unsigned long flags;
@@ -498,7 +490,7 @@ void ehca_process_eq(struct ehca_shca *shca, int is_irq)
 	do {
 		u32 token;
 		eqe_cache[eqe_cnt].eqe =
-			(struct ehca_eqe *)ehca_poll_eq(shca, eq);
+			(struct ehca_eqe *)ehca_poll_eq(eq);
 		if (!eqe_cache[eqe_cnt].eqe)
 			break;
 		eqe_value = eqe_cache[eqe_cnt].eqe->entry;
@@ -535,7 +527,7 @@ void ehca_process_eq(struct ehca_shca *shca, int is_irq)
 	}
 	/* check eq */
 	spin_lock(&eq->spinlock);
-	eq_empty = (!ipz_eqit_eq_peek_valid(&shca->eq.ipz_queue));
+	eq_empty = (!ipz_eqit_eq_peek_valid(&eq->ipz_queue));
 	spin_unlock(&eq->spinlock);
 	/* call completion handler for cached eqes */
 	for (i = 0; i < eqe_cnt; i++)
@@ -557,7 +549,7 @@ void ehca_process_eq(struct ehca_shca *shca, int is_irq)
 		goto unlock_irq_spinlock;
 	do {
 		struct ehca_eqe *eqe;
-		eqe = (struct ehca_eqe *)ehca_poll_eq(shca, &shca->eq);
+		eqe = (struct ehca_eqe *)ehca_poll_eq(eq);
 		if (!eqe)
 			break;
 		process_eqe(shca, eqe);
@@ -569,7 +561,7 @@ unlock_irq_spinlock:
 
 void ehca_tasklet_eq(unsigned long data)
 {
-	ehca_process_eq((struct ehca_shca*)data, 1);
+	ehca_process_eq((struct ehca_eq *)data, 1);
 }
 
 static inline int find_next_online_cpu(struct ehca_comp_pool* pool)
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.h b/drivers/infiniband/hw/ehca/ehca_irq.h
index 3346cb0..18d5397 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.h
+++ b/drivers/infiniband/hw/ehca/ehca_irq.h
@@ -50,12 +50,10 @@ struct ehca_shca;
 
 int ehca_error_data(struct ehca_shca *shca, void *data, u64 resource);
 
-irqreturn_t ehca_interrupt_neq(int irq, void *dev_id);
-void ehca_tasklet_neq(unsigned long data);
-
-irqreturn_t ehca_interrupt_eq(int irq, void *dev_id);
+irqreturn_t ehca_interrupt(int irq, void *dev_id);
 void ehca_tasklet_eq(unsigned long data);
-void ehca_process_eq(struct ehca_shca *shca, int is_irq);
+void ehca_tasklet_neq(unsigned long data);
+void ehca_process_eq(struct ehca_eq *eq, int is_irq);
 
 struct ehca_cpu_comp_task {
 	wait_queue_head_t wait_queue;
diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/infiniband/hw/ehca/ehca_iverbs.h
index 77aeca6..bf8fbf7 100644
--- a/drivers/infiniband/hw/ehca/ehca_iverbs.h
+++ b/drivers/infiniband/hw/ehca/ehca_iverbs.h
@@ -117,13 +117,12 @@ enum ehca_eq_type {
 	EHCA_NEQ     /* Notification Event Queue */
 };
 
-int ehca_create_eq(struct ehca_shca *shca, struct ehca_eq *eq,
-		   enum ehca_eq_type type, const u32 length);
+struct ehca_eq *ehca_create_eq(struct ehca_shca *shca,
+			       const enum ehca_eq_type type, const u32 length);
 
-int ehca_destroy_eq(struct ehca_shca *shca, struct ehca_eq *eq);
-
-void *ehca_poll_eq(struct ehca_shca *shca, struct ehca_eq *eq);
+int ehca_destroy_eq(struct ehca_eq *eq);
 
+void *ehca_poll_eq(struct ehca_eq *eq);
 
 struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 			     struct ib_ucontext *context,
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 28ba2dd..d9a37dc 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -63,6 +63,8 @@ int ehca_port_act_time = 30;
 int ehca_poll_all_eqs  = 1;
 int ehca_static_rate   = -1;
 int ehca_scaling_code  = 0;
+int ehca_nr_eqs        = 2;
+int ehca_dist_eqs      = 0;
 
 module_param_named(open_aqp1,     ehca_open_aqp1,     int, 0);
 module_param_named(debug_level,   ehca_debug_level,   int, 0);
@@ -72,7 +74,9 @@ module_param_named(use_hp_mr,     ehca_use_hp_mr,     int, 0);
 module_param_named(port_act_time, ehca_port_act_time, int, 0);
 module_param_named(poll_all_eqs,  ehca_poll_all_eqs,  int, 0);
 module_param_named(static_rate,   ehca_static_rate,   int, 0);
-module_param_named(scaling_code,   ehca_scaling_code,   int, 0);
+module_param_named(scaling_code,  ehca_scaling_code,  int, 0);
+module_param_named(nr_eqs,        ehca_nr_eqs,        int, 0);
+module_param_named(dist_eqs,      ehca_dist_eqs,      int, 0);
 
 MODULE_PARM_DESC(open_aqp1,
 		 "AQP1 on startup (0: no (default), 1: yes)");
@@ -95,6 +99,11 @@ MODULE_PARM_DESC(static_rate,
 		 "set permanent static rate (default: disabled)");
 MODULE_PARM_DESC(scaling_code,
 		 "set scaling code (0: disabled/default, 1: enabled)");
+MODULE_PARM_DESC(nr_eqs,
+		 "set number of event queues (default : 2)");
+MODULE_PARM_DESC(dist_eqs,
+		 "enable distributing EQs across CQs "
+		 "(0: disabled/default, 1: enabled)");
 
 DEFINE_RWLOCK(ehca_qp_idr_lock);
 DEFINE_RWLOCK(ehca_cq_idr_lock);
@@ -135,6 +144,12 @@ static int ehca_create_slab_caches(void)
 		return ret;
 	}
 
+	ret = ehca_init_eq_cache();
+	if (ret) {
+		ehca_gen_err("Cannot create EQ SLAB cache.");
+		goto create_slab_caches1;
+	}
+
 	ret = ehca_init_cq_cache();
 	if (ret) {
 		ehca_gen_err("Cannot create CQ SLAB cache.");
@@ -182,6 +197,9 @@ create_slab_caches3:
 	ehca_cleanup_cq_cache();
 
 create_slab_caches2:
+	ehca_cleanup_eq_cache();
+
+create_slab_caches1:
 	ehca_cleanup_pd_cache();
 
 	return ret;
@@ -193,6 +211,7 @@ static void ehca_destroy_slab_caches(void)
 	ehca_cleanup_av_cache();
 	ehca_cleanup_qp_cache();
 	ehca_cleanup_cq_cache();
+	ehca_cleanup_eq_cache();
 	ehca_cleanup_pd_cache();
 #ifdef CONFIG_PPC_64K_PAGES
 	if (ctblk_cache)
@@ -362,7 +381,7 @@ int ehca_init_device(struct ehca_shca *shca)
 
 	shca->ib_device.node_type           = RDMA_NODE_IB_CA;
 	shca->ib_device.phys_port_cnt       = shca->num_ports;
-	shca->ib_device.num_comp_vectors    = 1;
+	shca->ib_device.num_comp_vectors    = ehca_nr_eqs;
 	shca->ib_device.dma_device          = &shca->ibmebus_dev->ofdev.dev;
 	shca->ib_device.query_device        = ehca_query_device;
 	shca->ib_device.query_port          = ehca_query_port;
@@ -585,6 +604,15 @@ static ssize_t ehca_show_adapter_handle(struct device *dev,
 }
 static DEVICE_ATTR(adapter_handle, S_IRUGO, ehca_show_adapter_handle, NULL);
 
+static ssize_t ehca_show_nr_eqs(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	return sprintf(buf, "%d\n", ehca_nr_eqs);
+}
+
+static DEVICE_ATTR(nr_eqs, S_IRUGO, ehca_show_nr_eqs, NULL);
+
 static struct attribute *ehca_dev_attrs[] = {
 	&dev_attr_adapter_handle.attr,
 	&dev_attr_num_ports.attr,
@@ -601,6 +629,7 @@ static struct attribute *ehca_dev_attrs[] = {
 	&dev_attr_cur_mw.attr,
 	&dev_attr_max_pd.attr,
 	&dev_attr_max_ah.attr,
+	&dev_attr_nr_eqs.attr,
 	NULL
 };
 
@@ -608,13 +637,27 @@ static struct attribute_group ehca_dev_attr_grp = {
 	.attrs = ehca_dev_attrs
 };
 
+static void destroy_all_eqs(struct ehca_shca *shca)
+{
+	int ret, i;
+
+	for (i = 0; i < ehca_nr_eqs && shca->eqs[i]; i++) {
+		ret = ehca_destroy_eq(shca->eqs[i]);
+		if (ret)
+			ehca_err(&shca->ib_device, "Cannot destroy EQ "
+				 "ret=%x i=%x eq=%p", ret, i, shca->eqs[i]);
+	}
+
+	kfree(shca->eqs);
+}
+
 static int __devinit ehca_probe(struct ibmebus_dev *dev,
 				const struct of_device_id *id)
 {
 	struct ehca_shca *shca;
 	const u64 *handle;
 	struct ib_pd *ibpd;
-	int ret;
+	int ret, i;
 
 	handle = of_get_property(dev->ofdev.node, "ibm,hca-handle", NULL);
 	if (!handle) {
@@ -648,19 +691,35 @@ static int __devinit ehca_probe(struct ibmebus_dev *dev,
 
 	ret = ehca_init_device(shca);
 	if (ret) {
-		ehca_gen_err("Cannot init ehca  device struct");
+		ehca_gen_err("Cannot init ehca device struct");
 		goto probe1;
 	}
 
 	/* create event queues */
-	ret = ehca_create_eq(shca, &shca->eq, EHCA_EQ, 2048);
-	if (ret) {
-		ehca_err(&shca->ib_device, "Cannot create EQ.");
+	shca->eqs = kzalloc(ehca_nr_eqs * sizeof(*shca->eqs), GFP_KERNEL);
+	if (!shca->eqs) {
+		ehca_gen_err("Cannot alloc eqs array");
 		goto probe1;
 	}
 
-	ret = ehca_create_eq(shca, &shca->neq, EHCA_NEQ, 513);
-	if (ret) {
+	for (i = 0; i < ehca_nr_eqs; i++) {
+		shca->eqs[i] = ehca_create_eq(shca, EHCA_EQ, 2048);
+		if (IS_ERR(shca->eqs[i])) {
+			ehca_err(&shca->ib_device, "Cannot create EQ.");
+			ret = PTR_ERR(shca->eqs[i]);
+			shca->eqs[i] = NULL;
+			goto probe2;
+		}
+	}
+
+	shca->aeq = ehca_create_eq(shca, EHCA_EQ, 2048);
+	if (IS_ERR(shca->aeq)) {
+		ehca_err(&shca->ib_device, "Cannot create AEQ.");
+		goto probe2;
+	}
+
+	shca->neq = ehca_create_eq(shca, EHCA_NEQ, 513);
+	if (IS_ERR(shca->neq)) {
 		ehca_err(&shca->ib_device, "Cannot create NEQ.");
 		goto probe3;
 	}
@@ -747,16 +806,20 @@ probe5:
 			 "Cannot destroy internal PD. ret=%x", ret);
 
 probe4:
-	ret = ehca_destroy_eq(shca, &shca->neq);
+	ret = ehca_destroy_eq(shca->neq);
 	if (ret)
 		ehca_err(&shca->ib_device,
 			 "Cannot destroy NEQ. ret=%x", ret);
 
 probe3:
-	ret = ehca_destroy_eq(shca, &shca->eq);
+	ret = ehca_destroy_eq(shca->aeq);
 	if (ret)
 		ehca_err(&shca->ib_device,
-			 "Cannot destroy EQ. ret=%x", ret);
+			 "Cannot destroy AEQ. ret=%x", ret);
+
+probe2:
+	if (shca->eqs)
+		destroy_all_eqs(shca);
 
 probe1:
 	ib_dealloc_device(&shca->ib_device);
@@ -767,12 +830,11 @@ probe1:
 static int __devexit ehca_remove(struct ibmebus_dev *dev)
 {
 	struct ehca_shca *shca = dev->ofdev.dev.driver_data;
-	int ret;
+	int ret, i;
 
 	sysfs_remove_group(&dev->ofdev.dev.kobj, &ehca_dev_attr_grp);
 
 	if (ehca_open_aqp1 == 1) {
-		int i;
 		for (i = 0; i < shca->num_ports; i++) {
 			ret = ehca_destroy_aqp1(&shca->sport[i]);
 			if (ret)
@@ -794,11 +856,14 @@ static int __devexit ehca_remove(struct ibmebus_dev *dev)
 		ehca_err(&shca->ib_device,
 			 "Cannot destroy internal PD. ret=%x", ret);
 
-	ret = ehca_destroy_eq(shca, &shca->eq);
+	if (shca->eqs)
+		destroy_all_eqs(shca);
+
+	ret = ehca_destroy_eq(shca->aeq);
 	if (ret)
-		ehca_err(&shca->ib_device, "Cannot destroy EQ. ret=%x", ret);
+		ehca_err(&shca->ib_device, "Canot destroy AEQ. ret=%x", ret);
 
-	ret = ehca_destroy_eq(shca, &shca->neq);
+	ret = ehca_destroy_eq(shca->neq);
 	if (ret)
 		ehca_err(&shca->ib_device, "Canot destroy NEQ. ret=%x", ret);
 
@@ -829,16 +894,20 @@ static struct ibmebus_driver ehca_driver = {
 
 void ehca_poll_eqs(unsigned long data)
 {
+	extern int ehca_nr_eqs;
 	struct ehca_shca *shca;
 
 	spin_lock(&shca_list_lock);
 	list_for_each_entry(shca, &shca_list, shca_list) {
-		if (shca->eq.is_initialized) {
-			/* call deadman proc only if eq ptr does not change */
-			struct ehca_eq *eq = &shca->eq;
+		int i;
+		for (i = 0; i < ehca_nr_eqs; i++) {
+			struct ehca_eq *eq = shca->eqs[i];
 			int max = 3;
 			volatile u64 q_ofs, q_ofs2;
 			u64 flags;
+			if (!eq || !eq->is_initialized)
+				continue;
+			/* call deadman proc only if eq ptr does not change */
 			spin_lock_irqsave(&eq->spinlock, flags);
 			q_ofs = eq->ipz_queue.current_q_offset;
 			spin_unlock_irqrestore(&eq->spinlock, flags);
@@ -849,7 +918,7 @@ void ehca_poll_eqs(unsigned long data)
 				max--;
 			} while (q_ofs == q_ofs2 && max > 0);
 			if (q_ofs == q_ofs2)
-				ehca_process_eq(shca, 0);
+				ehca_process_eq(eq, 0);
 		}
 	}
 	mod_timer(&poll_eqs_timer, jiffies + HZ);
@@ -863,6 +932,13 @@ int __init ehca_module_init(void)
 	printk(KERN_INFO "eHCA Infiniband Device Driver "
 	       "(Rel.: SVNEHCA_0023)\n");
 
+	if (ehca_nr_eqs < 1 || ehca_nr_eqs > EHCA_MAX_NR_EQS) {
+		ehca_gen_err("Invalid option nr_eqs=%x. "
+			     "Specify a number in range [1-%d].",
+			     ehca_nr_eqs, EHCA_MAX_NR_EQS);
+		return -EINVAL;
+	}
+
 	if ((ret = ehca_create_comp_pool())) {
 		ehca_gen_err("Cannot create comp pool.");
 		return ret;
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 7467125..f6f4ef6 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -545,7 +545,7 @@ struct ehca_qp *internal_create_qp(struct ib_pd *pd,
 	}
 
 	parms.token = my_qp->token;
-	parms.eq_handle = shca->eq.ipz_eq_handle;
+	parms.eq_handle = shca->aeq->ipz_eq_handle;
 	parms.pd = my_pd->fw_pd;
 	if (my_qp->send_cq)
 		parms.send_cq_handle = my_qp->send_cq->ipz_cq_handle;
-- 
1.5.2


