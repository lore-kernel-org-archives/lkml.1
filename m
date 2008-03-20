Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbYCTQ5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbYCTQ5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 12:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbYCTQ5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 12:57:04 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35242 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbYCTQ5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 12:57:01 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH] ehca: remove tgid checking
Date: Thu, 20 Mar 2008 17:56:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Sean Hefty <sean.hefty@intel.com>, Pavel Emelyanov <xemul@openvz.org>,
       raisch@de.ibm.com, general@lists.openfabrics.org,
       Hal Rosenstock <hal.rosenstock@gmail.com>, hnguyen@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803201756.52818.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes pid_t in ehca, as discussed with roland here: 
http://lkml.org/lkml/2008/3/19/169
It will apply against roland's git tree.


Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_av.c      |   31 ------------------
 drivers/infiniband/hw/ehca/ehca_classes.h |    2 -
 drivers/infiniband/hw/ehca/ehca_cq.c      |   19 -----------
 drivers/infiniband/hw/ehca/ehca_mrmw.c    |   32 -------------------
 drivers/infiniband/hw/ehca/ehca_pd.c      |   11 ------
 drivers/infiniband/hw/ehca/ehca_qp.c      |   48 -----------------------------
 drivers/infiniband/hw/ehca/ehca_uverbs.c  |   19 -----------
 7 files changed, 0 insertions(+), 162 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_av.c b/drivers/infiniband/hw/ehca/ehca_av.c
index 194c1c3..56735ea 100644
--- a/drivers/infiniband/hw/ehca/ehca_av.c
+++ b/drivers/infiniband/hw/ehca/ehca_av.c
@@ -41,9 +41,6 @@
  * POSSIBILITY OF SUCH DAMAGE.
  */
 
-
-#include <asm/current.h>
-
 #include "ehca_tools.h"
 #include "ehca_iverbs.h"
 #include "hcp_if.h"
@@ -170,17 +167,8 @@ int ehca_modify_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr)
 {
 	struct ehca_av *av;
 	struct ehca_ud_av new_ehca_av;
-	struct ehca_pd *my_pd = container_of(ah->pd, struct ehca_pd, ib_pd);
 	struct ehca_shca *shca = container_of(ah->pd->device, struct ehca_shca,
 					      ib_device);
-	u32 cur_pid = current->tgid;
-
-	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(ah->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
-		return -EINVAL;
-	}
 
 	memset(&new_ehca_av, 0, sizeof(new_ehca_av));
 	new_ehca_av.sl = ah_attr->sl;
@@ -242,15 +230,6 @@ int ehca_modify_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr)
 int ehca_query_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr)
 {
 	struct ehca_av *av = container_of(ah, struct ehca_av, ib_ah);
-	struct ehca_pd *my_pd = container_of(ah->pd, struct ehca_pd, ib_pd);
-	u32 cur_pid = current->tgid;
-
-	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(ah->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
-		return -EINVAL;
-	}
 
 	memcpy(&ah_attr->grh.dgid, &av->av.grh.word_3,
 	       sizeof(ah_attr->grh.dgid));
@@ -273,16 +252,6 @@ int ehca_query_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr)
 
 int ehca_destroy_ah(struct ib_ah *ah)
 {
-	struct ehca_pd *my_pd = container_of(ah->pd, struct ehca_pd, ib_pd);
-	u32 cur_pid = current->tgid;
-
-	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(ah->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
-		return -EINVAL;
-	}
-
 	kmem_cache_free(av_cache, container_of(ah, struct ehca_av, ib_ah));
 
 	return 0;
diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 92cce8a..0d13fe0 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -132,7 +132,6 @@ struct ehca_shca {
 struct ehca_pd {
 	struct ib_pd ib_pd;
 	struct ipz_pd fw_pd;
-	u32 ownpid;
 	/* small queue mgmt */
 	struct mutex lock;
 	struct list_head free[2];
@@ -215,7 +214,6 @@ struct ehca_cq {
 	atomic_t nr_events; /* #events seen */
 	wait_queue_head_t wait_completion;
 	spinlock_t task_lock;
-	u32 ownpid;
 	/* mmap counter for resources mapped into user space */
 	u32 mm_count_queue;
 	u32 mm_count_galpa;
diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 0467c15..ec0cfcf 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -43,8 +43,6 @@
  * POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <asm/current.h>
-
 #include "ehca_iverbs.h"
 #include "ehca_classes.h"
 #include "ehca_irq.h"
@@ -148,7 +146,6 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 	spin_lock_init(&my_cq->task_lock);
 	atomic_set(&my_cq->nr_events, 0);
 	init_waitqueue_head(&my_cq->wait_completion);
-	my_cq->ownpid = current->tgid;
 
 	cq = &my_cq->ib_cq;
 
@@ -320,7 +317,6 @@ int ehca_destroy_cq(struct ib_cq *cq)
 	struct ehca_shca *shca = container_of(device, struct ehca_shca,
 					      ib_device);
 	struct ipz_adapter_handle adapter_handle = shca->ipz_hca_handle;
-	u32 cur_pid = current->tgid;
 	unsigned long flags;
 
 	if (cq->uobject) {
@@ -329,12 +325,6 @@ int ehca_destroy_cq(struct ib_cq *cq)
 				 "user space cq_num=%x", my_cq->cq_number);
 			return -EINVAL;
 		}
-		if (my_cq->ownpid != cur_pid) {
-			ehca_err(device, "Invalid caller pid=%x ownpid=%x "
-				 "cq_num=%x",
-				 cur_pid, my_cq->ownpid, my_cq->cq_number);
-			return -EINVAL;
-		}
 	}
 
 	/*
@@ -374,15 +364,6 @@ int ehca_destroy_cq(struct ib_cq *cq)
 
 int ehca_resize_cq(struct ib_cq *cq, int cqe, struct ib_udata *udata)
 {
-	struct ehca_cq *my_cq = container_of(cq, struct ehca_cq, ib_cq);
-	u32 cur_pid = current->tgid;
-
-	if (cq->uobject && my_cq->ownpid != cur_pid) {
-		ehca_err(cq->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_cq->ownpid);
-		return -EINVAL;
-	}
-
 	/* TODO: proper resize needs to be done */
 	ehca_err(cq->device, "not implemented yet");
 
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 5e99c45..f26997f 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -40,8 +40,6 @@
  * POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <asm/current.h>
-
 #include <rdma/ib_umem.h>
 
 #include "ehca_iverbs.h"
@@ -419,7 +417,6 @@ int ehca_rereg_phys_mr(struct ib_mr *mr,
 	struct ehca_shca *shca =
 		container_of(mr->device, struct ehca_shca, ib_device);
 	struct ehca_mr *e_mr = container_of(mr, struct ehca_mr, ib.ib_mr);
-	struct ehca_pd *my_pd = container_of(mr->pd, struct ehca_pd, ib_pd);
 	u64 new_size;
 	u64 *new_start;
 	u32 new_acl;
@@ -429,15 +426,6 @@ int ehca_rereg_phys_mr(struct ib_mr *mr,
 	u32 num_kpages = 0;
 	u32 num_hwpages = 0;
 	struct ehca_mr_pginfo pginfo;
-	u32 cur_pid = current->tgid;
-
-	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    (my_pd->ownpid != cur_pid)) {
-		ehca_err(mr->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
-		ret = -EINVAL;
-		goto rereg_phys_mr_exit0;
-	}
 
 	if (!(mr_rereg_mask & IB_MR_REREG_TRANS)) {
 		/* TODO not supported, because PHYP rereg hCall needs pages */
@@ -577,19 +565,9 @@ int ehca_query_mr(struct ib_mr *mr, struct ib_mr_attr *mr_attr)
 	struct ehca_shca *shca =
 		container_of(mr->device, struct ehca_shca, ib_device);
 	struct ehca_mr *e_mr = container_of(mr, struct ehca_mr, ib.ib_mr);
-	struct ehca_pd *my_pd = container_of(mr->pd, struct ehca_pd, ib_pd);
-	u32 cur_pid = current->tgid;
 	unsigned long sl_flags;
 	struct ehca_mr_hipzout_parms hipzout;
 
-	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    (my_pd->ownpid != cur_pid)) {
-		ehca_err(mr->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
-		ret = -EINVAL;
-		goto query_mr_exit0;
-	}
-
 	if ((e_mr->flags & EHCA_MR_FLAG_FMR)) {
 		ehca_err(mr->device, "not supported for FMR, mr=%p e_mr=%p "
 			 "e_mr->flags=%x", mr, e_mr, e_mr->flags);
@@ -634,16 +612,6 @@ int ehca_dereg_mr(struct ib_mr *mr)
 	struct ehca_shca *shca =
 		container_of(mr->device, struct ehca_shca, ib_device);
 	struct ehca_mr *e_mr = container_of(mr, struct ehca_mr, ib.ib_mr);
-	struct ehca_pd *my_pd = container_of(mr->pd, struct ehca_pd, ib_pd);
-	u32 cur_pid = current->tgid;
-
-	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    (my_pd->ownpid != cur_pid)) {
-		ehca_err(mr->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
-		ret = -EINVAL;
-		goto dereg_mr_exit0;
-	}
 
 	if ((e_mr->flags & EHCA_MR_FLAG_FMR)) {
 		ehca_err(mr->device, "not supported for FMR, mr=%p e_mr=%p "
diff --git a/drivers/infiniband/hw/ehca/ehca_pd.c b/drivers/infiniband/hw/ehca/ehca_pd.c
index 43bcf08..2fe5548 100644
--- a/drivers/infiniband/hw/ehca/ehca_pd.c
+++ b/drivers/infiniband/hw/ehca/ehca_pd.c
@@ -38,8 +38,6 @@
  * POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <asm/current.h>
-
 #include "ehca_tools.h"
 #include "ehca_iverbs.h"
 
@@ -58,7 +56,6 @@ struct ib_pd *ehca_alloc_pd(struct ib_device *device,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	pd->ownpid = current->tgid;
 	for (i = 0; i < 2; i++) {
 		INIT_LIST_HEAD(&pd->free[i]);
 		INIT_LIST_HEAD(&pd->full[i]);
@@ -85,18 +82,10 @@ struct ib_pd *ehca_alloc_pd(struct ib_device *device,
 
 int ehca_dealloc_pd(struct ib_pd *pd)
 {
-	u32 cur_pid = current->tgid;
 	struct ehca_pd *my_pd = container_of(pd, struct ehca_pd, ib_pd);
 	int i, leftovers = 0;
 	struct ipz_small_queue_page *page, *tmp;
 
-	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(pd->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
-		return -EINVAL;
-	}
-
 	for (i = 0; i < 2; i++) {
 		list_splice(&my_pd->full[i], &my_pd->free[i]);
 		list_for_each_entry_safe(page, tmp, &my_pd->free[i], list) {
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 1012f15..a9fd419 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -43,9 +43,6 @@
  * POSSIBILITY OF SUCH DAMAGE.
  */
 
-
-#include <asm/current.h>
-
 #include "ehca_classes.h"
 #include "ehca_tools.h"
 #include "ehca_qes.h"
@@ -1526,16 +1523,6 @@ int ehca_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 	struct ehca_shca *shca = container_of(ibqp->device, struct ehca_shca,
 					      ib_device);
 	struct ehca_qp *my_qp = container_of(ibqp, struct ehca_qp, ib_qp);
-	struct ehca_pd *my_pd = container_of(my_qp->ib_qp.pd, struct ehca_pd,
-					     ib_pd);
-	u32 cur_pid = current->tgid;
-
-	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(ibqp->pd->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
-		return -EINVAL;
-	}
 
 	/* The if-block below caches qp_attr to be modified for GSI and SMI
 	 * qps during the initialization by ib_mad. When the respective port
@@ -1636,23 +1623,13 @@ int ehca_query_qp(struct ib_qp *qp,
 		  int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr)
 {
 	struct ehca_qp *my_qp = container_of(qp, struct ehca_qp, ib_qp);
-	struct ehca_pd *my_pd = container_of(my_qp->ib_qp.pd, struct ehca_pd,
-					     ib_pd);
 	struct ehca_shca *shca = container_of(qp->device, struct ehca_shca,
 					      ib_device);
 	struct ipz_adapter_handle adapter_handle = shca->ipz_hca_handle;
 	struct hcp_modify_qp_control_block *qpcb;
-	u32 cur_pid = current->tgid;
 	int cnt, ret = 0;
 	u64 h_ret;
 
-	if (my_pd->ib_pd.uobject  && my_pd->ib_pd.uobject->context  &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(qp->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
-		return -EINVAL;
-	}
-
 	if (qp_attr_mask & QP_ATTR_QUERY_NOT_SUPPORTED) {
 		ehca_err(qp->device, "Invalid attribute mask "
 			 "ehca_qp=%p qp_num=%x qp_attr_mask=%x ",
@@ -1797,8 +1774,6 @@ int ehca_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 {
 	struct ehca_qp *my_qp =
 		container_of(ibsrq, struct ehca_qp, ib_srq);
-	struct ehca_pd *my_pd =
-		container_of(ibsrq->pd, struct ehca_pd, ib_pd);
 	struct ehca_shca *shca =
 		container_of(ibsrq->pd->device, struct ehca_shca, ib_device);
 	struct hcp_modify_qp_control_block *mqpcb;
@@ -1806,14 +1781,6 @@ int ehca_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 	u64 h_ret;
 	int ret = 0;
 
-	u32 cur_pid = current->tgid;
-	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(ibsrq->pd->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
-		return -EINVAL;
-	}
-
 	mqpcb = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
 	if (!mqpcb) {
 		ehca_err(ibsrq->device, "Could not get zeroed page for mqpcb "
@@ -1864,22 +1831,13 @@ modify_srq_exit0:
 int ehca_query_srq(struct ib_srq *srq, struct ib_srq_attr *srq_attr)
 {
 	struct ehca_qp *my_qp = container_of(srq, struct ehca_qp, ib_srq);
-	struct ehca_pd *my_pd = container_of(srq->pd, struct ehca_pd, ib_pd);
 	struct ehca_shca *shca = container_of(srq->device, struct ehca_shca,
 					      ib_device);
 	struct ipz_adapter_handle adapter_handle = shca->ipz_hca_handle;
 	struct hcp_modify_qp_control_block *qpcb;
-	u32 cur_pid = current->tgid;
 	int ret = 0;
 	u64 h_ret;
 
-	if (my_pd->ib_pd.uobject  && my_pd->ib_pd.uobject->context  &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(srq->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
-		return -EINVAL;
-	}
-
 	qpcb = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
 	if (!qpcb) {
 		ehca_err(srq->device, "Out of memory for qpcb "
@@ -1919,7 +1877,6 @@ static int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
 	struct ehca_pd *my_pd = container_of(my_qp->ib_qp.pd, struct ehca_pd,
 					     ib_pd);
 	struct ehca_sport *sport = &shca->sport[my_qp->init_attr.port_num - 1];
-	u32 cur_pid = current->tgid;
 	u32 qp_num = my_qp->real_qp_num;
 	int ret;
 	u64 h_ret;
@@ -1934,11 +1891,6 @@ static int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
 				 "user space qp_num=%x", qp_num);
 			return -EINVAL;
 		}
-		if (my_pd->ownpid != cur_pid) {
-			ehca_err(dev, "Invalid caller pid=%x ownpid=%x",
-				 cur_pid, my_pd->ownpid);
-			return -EINVAL;
-		}
 	}
 
 	if (my_qp->send_cq) {
diff --git a/drivers/infiniband/hw/ehca/ehca_uverbs.c b/drivers/infiniband/hw/ehca/ehca_uverbs.c
index 5234d6c..1b07f2b 100644
--- a/drivers/infiniband/hw/ehca/ehca_uverbs.c
+++ b/drivers/infiniband/hw/ehca/ehca_uverbs.c
@@ -40,8 +40,6 @@
  * POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <asm/current.h>
-
 #include "ehca_classes.h"
 #include "ehca_iverbs.h"
 #include "ehca_mrmw.h"
@@ -253,11 +251,9 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	u32 idr_handle = fileoffset & 0x1FFFFFF;
 	u32 q_type = (fileoffset >> 27) & 0x1;	  /* CQ, QP,...        */
 	u32 rsrc_type = (fileoffset >> 25) & 0x3; /* sq,rq,cmnd_window */
-	u32 cur_pid = current->tgid;
 	u32 ret;
 	struct ehca_cq *cq;
 	struct ehca_qp *qp;
-	struct ehca_pd *pd;
 	struct ib_uobject *uobject;
 
 	switch (q_type) {
@@ -270,13 +266,6 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		if (!cq)
 			return -EINVAL;
 
-		if (cq->ownpid != cur_pid) {
-			ehca_err(cq->ib_cq.device,
-				 "Invalid caller pid=%x ownpid=%x",
-				 cur_pid, cq->ownpid);
-			return -ENOMEM;
-		}
-
 		if (!cq->ib_cq.uobject || cq->ib_cq.uobject->context != context)
 			return -EINVAL;
 
@@ -298,14 +287,6 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		if (!qp)
 			return -EINVAL;
 
-		pd = container_of(qp->ib_qp.pd, struct ehca_pd, ib_pd);
-		if (pd->ownpid != cur_pid) {
-			ehca_err(qp->ib_qp.device,
-				 "Invalid caller pid=%x ownpid=%x",
-				 cur_pid, pd->ownpid);
-			return -ENOMEM;
-		}
-
 		uobject = IS_SRQ(qp) ? qp->ib_srq.uobject : qp->ib_qp.uobject;
 		if (!uobject || uobject->context != context)
 			return -EINVAL;
-- 
1.5.2


