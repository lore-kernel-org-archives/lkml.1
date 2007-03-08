Return-Path: <linux-kernel-owner+w=401wt.eu-S1161221AbXCHXuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161221AbXCHXuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161227AbXCHXuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:50:22 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:27780 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161221AbXCHXuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:50:19 -0500
X-IronPort-AV: i="4.14,264,1170662400"; 
   d="scan'208"; a="398968368:sNHT86365040"
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 08 Mar 2007 15:50:17 -0800
Message-ID: <adairdbxpl2.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Mar 2007 23:50:17.0892 (UTC) FILETIME=[86669E40:01C761DC]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get various post-rc3 fixes:

David Miller (1):
      RDMA/cxgb3: Fix build on sparc64

Hoang-Nam Nguyen (1):
      IB/ehca: Fix sync between completion handler and destroy cq

Roland Dreier (2):
      IPoIB: Only handle async events for one port
      IB/mthca: Fix error path in mthca_alloc_memfree()

Sean Hefty (2):
      RDMA/cma: Initialize rdma_bind_list in cma_alloc_any_port()
      RDMA/ucma: Avoid sending reject if backlog is full

Shirley Ma (1):
      IPoIB: Turn on interface's carrier after broadcast group is joined

Steve Wise (8):
      RDMA/cxgb3: Start ep timer on a MPA reject
      RDMA/cxgb3: Don't use mm after it's freed in iwch_mmap()
      RDMA/cxgb3: Fixes for "normal close" failures
      RDMA/cxgb3: Move QP to error on destroy if the state is IDLE
      RDMA/cxgb3: Stop EP timer when MPA exchange is aborted by peer
      RDMA/cxgb3: Squelch logging AE errors
      RDMA/cxgb3: Don't reuse skbs that are non-linear or cloned
      RDMA/cxgb3: Fix MR permission problems

 drivers/infiniband/core/cma.c                  |    2 +-
 drivers/infiniband/core/ucma.c                 |    2 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c         |    1 +
 drivers/infiniband/hw/cxgb3/iwch_cm.c          |   19 ++++---
 drivers/infiniband/hw/cxgb3/iwch_ev.c          |   12 ++--
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |   40 +++++-----------
 drivers/infiniband/hw/cxgb3/iwch_provider.h    |   33 +++++--------
 drivers/infiniband/hw/cxgb3/iwch_qp.c          |    2 +-
 drivers/infiniband/hw/ehca/ehca_classes.h      |    6 ++-
 drivers/infiniband/hw/ehca/ehca_cq.c           |   16 ++++++-
 drivers/infiniband/hw/ehca/ehca_irq.c          |   59 ++++++++++++++++--------
 drivers/infiniband/hw/ehca/ehca_main.c         |    4 +-
 drivers/infiniband/hw/mthca/mthca_qp.c         |   10 ++--
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    5 ++-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |   13 +++--
 15 files changed, 122 insertions(+), 102 deletions(-)


diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d441815..fde92ce 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1821,7 +1821,7 @@ static int cma_alloc_port(struct idr *ps, struct rdma_id_private *id_priv,
 	struct rdma_bind_list *bind_list;
 	int port, ret;
 
-	bind_list = kmalloc(sizeof *bind_list, GFP_KERNEL);
+	bind_list = kzalloc(sizeof *bind_list, GFP_KERNEL);
 	if (!bind_list)
 		return -ENOMEM;
 
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index b516b93..c859134 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -266,7 +266,7 @@ static int ucma_event_handler(struct rdma_cm_id *cm_id,
 	mutex_lock(&ctx->file->mut);
 	if (event->event == RDMA_CM_EVENT_CONNECT_REQUEST) {
 		if (!ctx->backlog) {
-			ret = -EDQUOT;
+			ret = -ENOMEM;
 			kfree(uevent);
 			goto out;
 		}
diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index d737c73..818cf1a 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -36,6 +36,7 @@
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
+#include <linux/dma-mapping.h>
 
 #include "cxio_resource.h"
 #include "cxio_hal.h"
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index b21fde8..d0ed1d3 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -305,8 +305,7 @@ static int status2errno(int status)
  */
 static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
 {
-	if (skb) {
-		BUG_ON(skb_cloned(skb));
+	if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
 		skb_trim(skb, 0);
 		skb_get(skb);
 	} else {
@@ -1415,6 +1414,7 @@ static int peer_close(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 		wake_up(&ep->com.waitq);
 		break;
 	case FPDU_MODE:
+		start_ep_timer(ep);
 		__state_set(&ep->com, CLOSING);
 		attrs.next_state = IWCH_QP_STATE_CLOSING;
 		iwch_modify_qp(ep->com.qp->rhp, ep->com.qp,
@@ -1425,7 +1425,6 @@ static int peer_close(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 		disconnect = 0;
 		break;
 	case CLOSING:
-		start_ep_timer(ep);
 		__state_set(&ep->com, MORIBUND);
 		disconnect = 0;
 		break;
@@ -1487,8 +1486,10 @@ static int peer_abort(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	case CONNECTING:
 		break;
 	case MPA_REQ_WAIT:
+		stop_ep_timer(ep);
 		break;
 	case MPA_REQ_SENT:
+		stop_ep_timer(ep);
 		connect_reply_upcall(ep, -ECONNRESET);
 		break;
 	case MPA_REP_SENT:
@@ -1507,9 +1508,10 @@ static int peer_abort(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 		get_ep(&ep->com);
 		break;
 	case MORIBUND:
+	case CLOSING:
 		stop_ep_timer(ep);
+		/*FALLTHROUGH*/
 	case FPDU_MODE:
-	case CLOSING:
 		if (ep->com.cm_id && ep->com.qp) {
 			attrs.next_state = IWCH_QP_STATE_ERROR;
 			ret = iwch_modify_qp(ep->com.qp->rhp,
@@ -1570,7 +1572,6 @@ static int close_con_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	spin_lock_irqsave(&ep->com.lock, flags);
 	switch (ep->com.state) {
 	case CLOSING:
-		start_ep_timer(ep);
 		__state_set(&ep->com, MORIBUND);
 		break;
 	case MORIBUND:
@@ -1586,6 +1587,8 @@ static int close_con_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 		__state_set(&ep->com, DEAD);
 		release = 1;
 		break;
+	case ABORTING:
+		break;
 	case DEAD:
 	default:
 		BUG_ON(1);
@@ -1659,6 +1662,7 @@ static void ep_timeout(unsigned long arg)
 		break;
 	case MPA_REQ_WAIT:
 		break;
+	case CLOSING:
 	case MORIBUND:
 		if (ep->com.cm_id && ep->com.qp) {
 			attrs.next_state = IWCH_QP_STATE_ERROR;
@@ -1687,12 +1691,11 @@ int iwch_reject_cr(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
 		return -ECONNRESET;
 	}
 	BUG_ON(state_read(&ep->com) != MPA_REQ_RCVD);
-	state_set(&ep->com, CLOSING);
 	if (mpa_rev == 0)
 		abort_connection(ep, NULL, GFP_KERNEL);
 	else {
 		err = send_mpa_reject(ep, pdata, pdata_len);
-		err = send_halfclose(ep, GFP_KERNEL);
+		err = iwch_ep_disconnect(ep, 0, GFP_KERNEL);
 	}
 	return 0;
 }
@@ -1957,11 +1960,11 @@ int iwch_ep_disconnect(struct iwch_ep *ep, int abrupt, gfp_t gfp)
 	case MPA_REQ_RCVD:
 	case MPA_REP_SENT:
 	case FPDU_MODE:
+		start_ep_timer(ep);
 		ep->com.state = CLOSING;
 		close = 1;
 		break;
 	case CLOSING:
-		start_ep_timer(ep);
 		ep->com.state = MORIBUND;
 		close = 1;
 		break;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_ev.c b/drivers/infiniband/hw/cxgb3/iwch_ev.c
index 54362af..b406766 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_ev.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_ev.c
@@ -47,12 +47,6 @@ static void post_qp_event(struct iwch_dev *rnicp, struct iwch_cq *chp,
 	struct iwch_qp_attributes attrs;
 	struct iwch_qp *qhp;
 
-	printk(KERN_ERR "%s - AE qpid 0x%x opcode %d status 0x%x "
-	       "type %d wrid.hi 0x%x wrid.lo 0x%x \n", __FUNCTION__,
-	       CQE_QPID(rsp_msg->cqe), CQE_OPCODE(rsp_msg->cqe),
-	       CQE_STATUS(rsp_msg->cqe), CQE_TYPE(rsp_msg->cqe),
-	       CQE_WRID_HI(rsp_msg->cqe), CQE_WRID_LOW(rsp_msg->cqe));
-
 	spin_lock(&rnicp->lock);
 	qhp = get_qhp(rnicp, CQE_QPID(rsp_msg->cqe));
 
@@ -73,6 +67,12 @@ static void post_qp_event(struct iwch_dev *rnicp, struct iwch_cq *chp,
 		return;
 	}
 
+	printk(KERN_ERR "%s - AE qpid 0x%x opcode %d status 0x%x "
+	       "type %d wrid.hi 0x%x wrid.lo 0x%x \n", __FUNCTION__,
+	       CQE_QPID(rsp_msg->cqe), CQE_OPCODE(rsp_msg->cqe),
+	       CQE_STATUS(rsp_msg->cqe), CQE_TYPE(rsp_msg->cqe),
+	       CQE_WRID_HI(rsp_msg->cqe), CQE_WRID_LOW(rsp_msg->cqe));
+
 	atomic_inc(&qhp->refcnt);
 	spin_unlock(&rnicp->lock);
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 9947a14..f2774ae 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -331,6 +331,7 @@ static int iwch_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	int ret = 0;
 	struct iwch_mm_entry *mm;
 	struct iwch_ucontext *ucontext;
+	u64 addr;
 
 	PDBG("%s pgoff 0x%lx key 0x%x len %d\n", __FUNCTION__, vma->vm_pgoff,
 	     key, len);
@@ -345,10 +346,11 @@ static int iwch_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	mm = remove_mmap(ucontext, key, len);
 	if (!mm)
 		return -EINVAL;
+	addr = mm->addr;
 	kfree(mm);
 
-	if ((mm->addr >= rdev_p->rnic_info.udbell_physbase) &&
-	    (mm->addr < (rdev_p->rnic_info.udbell_physbase +
+	if ((addr >= rdev_p->rnic_info.udbell_physbase) &&
+	    (addr < (rdev_p->rnic_info.udbell_physbase +
 		       rdev_p->rnic_info.udbell_len))) {
 
 		/*
@@ -362,7 +364,7 @@ static int iwch_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND;
 		vma->vm_flags &= ~VM_MAYREAD;
 		ret = io_remap_pfn_range(vma, vma->vm_start,
-					 mm->addr >> PAGE_SHIFT,
+					 addr >> PAGE_SHIFT,
 				         len, vma->vm_page_prot);
 	} else {
 
@@ -370,7 +372,7 @@ static int iwch_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		 * Map WQ or CQ contig dma memory...
 		 */
 		ret = remap_pfn_range(vma, vma->vm_start,
-				      mm->addr >> PAGE_SHIFT,
+				      addr >> PAGE_SHIFT,
 				      len, vma->vm_page_prot);
 	}
 
@@ -463,9 +465,6 @@ static struct ib_mr *iwch_register_phys_mem(struct ib_pd *pd,
 	php = to_iwch_pd(pd);
 	rhp = php->rhp;
 
-	acc = iwch_convert_access(acc);
-
-
 	mhp = kzalloc(sizeof(*mhp), GFP_KERNEL);
 	if (!mhp)
 		return ERR_PTR(-ENOMEM);
@@ -491,12 +490,7 @@ static struct ib_mr *iwch_register_phys_mem(struct ib_pd *pd,
 	mhp->attr.pdid = php->pdid;
 	mhp->attr.zbva = 0;
 
-	/* NOTE: TPT perms are backwards from BIND WR perms! */
-	mhp->attr.perms = (acc & 0x1) << 3;
-	mhp->attr.perms |= (acc & 0x2) << 1;
-	mhp->attr.perms |= (acc & 0x4) >> 1;
-	mhp->attr.perms |= (acc & 0x8) >> 3;
-
+	mhp->attr.perms = iwch_ib_to_tpt_access(acc);
 	mhp->attr.va_fbo = *iova_start;
 	mhp->attr.page_size = shift - 12;
 
@@ -525,7 +519,6 @@ static int iwch_reregister_phys_mem(struct ib_mr *mr,
 	struct iwch_mr mh, *mhp;
 	struct iwch_pd *php;
 	struct iwch_dev *rhp;
-	int new_acc;
 	__be64 *page_list = NULL;
 	int shift = 0;
 	u64 total_size;
@@ -546,14 +539,12 @@ static int iwch_reregister_phys_mem(struct ib_mr *mr,
 	if (rhp != php->rhp)
 		return -EINVAL;
 
-	new_acc = mhp->attr.perms;
-
 	memcpy(&mh, mhp, sizeof *mhp);
 
 	if (mr_rereg_mask & IB_MR_REREG_PD)
 		php = to_iwch_pd(pd);
 	if (mr_rereg_mask & IB_MR_REREG_ACCESS)
-		mh.attr.perms = iwch_convert_access(acc);
+		mh.attr.perms = iwch_ib_to_tpt_access(acc);
 	if (mr_rereg_mask & IB_MR_REREG_TRANS)
 		ret = build_phys_page_list(buffer_list, num_phys_buf,
 					   iova_start,
@@ -568,7 +559,7 @@ static int iwch_reregister_phys_mem(struct ib_mr *mr,
 	if (mr_rereg_mask & IB_MR_REREG_PD)
 		mhp->attr.pdid = php->pdid;
 	if (mr_rereg_mask & IB_MR_REREG_ACCESS)
-		mhp->attr.perms = acc;
+		mhp->attr.perms = iwch_ib_to_tpt_access(acc);
 	if (mr_rereg_mask & IB_MR_REREG_TRANS) {
 		mhp->attr.zbva = 0;
 		mhp->attr.va_fbo = *iova_start;
@@ -613,8 +604,6 @@ static struct ib_mr *iwch_reg_user_mr(struct ib_pd *pd, struct ib_umem *region,
 		goto err;
 	}
 
-	acc = iwch_convert_access(acc);
-
 	i = n = 0;
 
 	list_for_each_entry(chunk, &region->chunk_list, list)
@@ -630,10 +619,7 @@ static struct ib_mr *iwch_reg_user_mr(struct ib_pd *pd, struct ib_umem *region,
 	mhp->rhp = rhp;
 	mhp->attr.pdid = php->pdid;
 	mhp->attr.zbva = 0;
-	mhp->attr.perms = (acc & 0x1) << 3;
-	mhp->attr.perms |= (acc & 0x2) << 1;
-	mhp->attr.perms |= (acc & 0x4) >> 1;
-	mhp->attr.perms |= (acc & 0x8) >> 3;
+	mhp->attr.perms = iwch_ib_to_tpt_access(acc);
 	mhp->attr.va_fbo = region->virt_base;
 	mhp->attr.page_size = shift - 12;
 	mhp->attr.len = (u32) region->length;
@@ -736,10 +722,8 @@ static int iwch_destroy_qp(struct ib_qp *ib_qp)
 	qhp = to_iwch_qp(ib_qp);
 	rhp = qhp->rhp;
 
-	if (qhp->attr.state == IWCH_QP_STATE_RTS) {
-		attrs.next_state = IWCH_QP_STATE_ERROR;
-		iwch_modify_qp(rhp, qhp, IWCH_QP_ATTR_NEXT_STATE, &attrs, 0);
-	}
+	attrs.next_state = IWCH_QP_STATE_ERROR;
+	iwch_modify_qp(rhp, qhp, IWCH_QP_ATTR_NEXT_STATE, &attrs, 0);
 	wait_event(qhp->wait, !qhp->ep);
 
 	remove_handle(rhp, &rhp->qpidr, qhp->wq.qpid);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.h b/drivers/infiniband/hw/cxgb3/iwch_provider.h
index de0fe1b..93bcc56 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.h
@@ -286,27 +286,20 @@ static inline int iwch_convert_state(enum ib_qp_state ib_state)
 	}
 }
 
-enum iwch_mem_perms {
-	IWCH_MEM_ACCESS_LOCAL_READ = 1 << 0,
-	IWCH_MEM_ACCESS_LOCAL_WRITE = 1 << 1,
-	IWCH_MEM_ACCESS_REMOTE_READ = 1 << 2,
-	IWCH_MEM_ACCESS_REMOTE_WRITE = 1 << 3,
-	IWCH_MEM_ACCESS_ATOMICS = 1 << 4,
-	IWCH_MEM_ACCESS_BINDING = 1 << 5,
-	IWCH_MEM_ACCESS_LOCAL =
-	    (IWCH_MEM_ACCESS_LOCAL_READ | IWCH_MEM_ACCESS_LOCAL_WRITE),
-	IWCH_MEM_ACCESS_REMOTE =
-	    (IWCH_MEM_ACCESS_REMOTE_WRITE | IWCH_MEM_ACCESS_REMOTE_READ)
-	    /* cannot go beyond 1 << 31 */
-} __attribute__ ((packed));
-
-static inline u32 iwch_convert_access(int acc)
+static inline u32 iwch_ib_to_tpt_access(int acc)
 {
-	return (acc & IB_ACCESS_REMOTE_WRITE ? IWCH_MEM_ACCESS_REMOTE_WRITE : 0)
-	    | (acc & IB_ACCESS_REMOTE_READ ? IWCH_MEM_ACCESS_REMOTE_READ : 0) |
-	    (acc & IB_ACCESS_LOCAL_WRITE ? IWCH_MEM_ACCESS_LOCAL_WRITE : 0) |
-	    (acc & IB_ACCESS_MW_BIND ? IWCH_MEM_ACCESS_BINDING : 0) |
-	    IWCH_MEM_ACCESS_LOCAL_READ;
+	return (acc & IB_ACCESS_REMOTE_WRITE ? TPT_REMOTE_WRITE : 0) |
+	       (acc & IB_ACCESS_REMOTE_READ ? TPT_REMOTE_READ : 0) |
+	       (acc & IB_ACCESS_LOCAL_WRITE ? TPT_LOCAL_WRITE : 0) |
+	       TPT_LOCAL_READ;
+}
+
+static inline u32 iwch_ib_to_mwbind_access(int acc)
+{
+	return (acc & IB_ACCESS_REMOTE_WRITE ? T3_MEM_ACCESS_REM_WRITE : 0) |
+	       (acc & IB_ACCESS_REMOTE_READ ? T3_MEM_ACCESS_REM_READ : 0) |
+	       (acc & IB_ACCESS_LOCAL_WRITE ? T3_MEM_ACCESS_LOCAL_WRITE : 0) |
+	       T3_MEM_ACCESS_LOCAL_READ;
 }
 
 enum iwch_mmid_state {
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 9ea00cc..0a472c9 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -439,7 +439,7 @@ int iwch_bind_mw(struct ib_qp *qp,
 	wqe->bind.type = T3_VA_BASED_TO;
 
 	/* TBD: check perms */
-	wqe->bind.perms = iwch_convert_access(mw_bind->mw_access_flags);
+	wqe->bind.perms = iwch_ib_to_mwbind_access(mw_bind->mw_access_flags);
 	wqe->bind.mr_stag = cpu_to_be32(mw_bind->mr->lkey);
 	wqe->bind.mw_stag = cpu_to_be32(mw->rkey);
 	wqe->bind.mw_len = cpu_to_be32(mw_bind->length);
diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 40404c9..82ded44 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -52,6 +52,8 @@ struct ehca_mw;
 struct ehca_pd;
 struct ehca_av;
 
+#include <linux/wait.h>
+
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_user_verbs.h>
 
@@ -153,7 +155,9 @@ struct ehca_cq {
 	spinlock_t cb_lock;
 	struct hlist_head qp_hashtab[QP_HASHTAB_LEN];
 	struct list_head entry;
-	u32 nr_callbacks;
+	u32 nr_callbacks; /* #events assigned to cpu by scaling code */
+	u32 nr_events;    /* #events seen */
+	wait_queue_head_t wait_completion;
 	spinlock_t task_lock;
 	u32 ownpid;
 	/* mmap counter for resources mapped into user space */
diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 6ebfa27..e2cdc1a 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -146,6 +146,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe,
 	spin_lock_init(&my_cq->spinlock);
 	spin_lock_init(&my_cq->cb_lock);
 	spin_lock_init(&my_cq->task_lock);
+	init_waitqueue_head(&my_cq->wait_completion);
 	my_cq->ownpid = current->tgid;
 
 	cq = &my_cq->ib_cq;
@@ -302,6 +303,16 @@ create_cq_exit1:
 	return cq;
 }
 
+static int get_cq_nr_events(struct ehca_cq *my_cq)
+{
+	int ret;
+	unsigned long flags;
+	spin_lock_irqsave(&ehca_cq_idr_lock, flags);
+	ret = my_cq->nr_events;
+	spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+	return ret;
+}
+
 int ehca_destroy_cq(struct ib_cq *cq)
 {
 	u64 h_ret;
@@ -329,10 +340,11 @@ int ehca_destroy_cq(struct ib_cq *cq)
 	}
 
 	spin_lock_irqsave(&ehca_cq_idr_lock, flags);
-	while (my_cq->nr_callbacks) {
+	while (my_cq->nr_events) {
 		spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
-		yield();
+		wait_event(my_cq->wait_completion, !get_cq_nr_events(my_cq));
 		spin_lock_irqsave(&ehca_cq_idr_lock, flags);
+		/* recheck nr_events to assure no cqe has just arrived */
 	}
 
 	idr_remove(&ehca_cq_idr, my_cq->token);
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 3ec53c6..20f36bf 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -404,10 +404,11 @@ static inline void process_eqe(struct ehca_shca *shca, struct ehca_eqe *eqe)
 	u32 token;
 	unsigned long flags;
 	struct ehca_cq *cq;
+
 	eqe_value = eqe->entry;
 	ehca_dbg(&shca->ib_device, "eqe_value=%lx", eqe_value);
 	if (EHCA_BMASK_GET(EQE_COMPLETION_EVENT, eqe_value)) {
-		ehca_dbg(&shca->ib_device, "... completion event");
+		ehca_dbg(&shca->ib_device, "Got completion event");
 		token = EHCA_BMASK_GET(EQE_CQ_TOKEN, eqe_value);
 		spin_lock_irqsave(&ehca_cq_idr_lock, flags);
 		cq = idr_find(&ehca_cq_idr, token);
@@ -419,16 +420,20 @@ static inline void process_eqe(struct ehca_shca *shca, struct ehca_eqe *eqe)
 			return;
 		}
 		reset_eq_pending(cq);
-		if (ehca_scaling_code) {
+		cq->nr_events++;
+		spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+		if (ehca_scaling_code)
 			queue_comp_task(cq);
-			spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
-		} else {
-			spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+		else {
 			comp_event_callback(cq);
+			spin_lock_irqsave(&ehca_cq_idr_lock, flags);
+			cq->nr_events--;
+			if (!cq->nr_events)
+				wake_up(&cq->wait_completion);
+			spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 		}
 	} else {
-		ehca_dbg(&shca->ib_device,
-			 "Got non completion event");
+		ehca_dbg(&shca->ib_device, "Got non completion event");
 		parse_identifier(shca, eqe_value);
 	}
 }
@@ -478,6 +483,7 @@ void ehca_process_eq(struct ehca_shca *shca, int is_irq)
 					 "token=%x", token);
 				continue;
 			}
+			eqe_cache[eqe_cnt].cq->nr_events++;
 			spin_unlock(&ehca_cq_idr_lock);
 		} else
 			eqe_cache[eqe_cnt].cq = NULL;
@@ -504,12 +510,18 @@ void ehca_process_eq(struct ehca_shca *shca, int is_irq)
 	/* call completion handler for cached eqes */
 	for (i = 0; i < eqe_cnt; i++)
 		if (eq->eqe_cache[i].cq) {
-			if (ehca_scaling_code) {
-				spin_lock(&ehca_cq_idr_lock);
+			if (ehca_scaling_code)
 				queue_comp_task(eq->eqe_cache[i].cq);
-				spin_unlock(&ehca_cq_idr_lock);
-			} else
-				comp_event_callback(eq->eqe_cache[i].cq);
+			else {
+				struct ehca_cq *cq = eq->eqe_cache[i].cq;
+				comp_event_callback(cq);
+				spin_lock_irqsave(&ehca_cq_idr_lock, flags);
+				cq->nr_events--;
+				if (!cq->nr_events)
+					wake_up(&cq->wait_completion);
+				spin_unlock_irqrestore(&ehca_cq_idr_lock,
+						       flags);
+			}
 		} else {
 			ehca_dbg(&shca->ib_device, "Got non completion event");
 			parse_identifier(shca, eq->eqe_cache[i].eqe->entry);
@@ -523,7 +535,6 @@ void ehca_process_eq(struct ehca_shca *shca, int is_irq)
 		if (!eqe)
 			break;
 		process_eqe(shca, eqe);
-		eqe_cnt++;
 	} while (1);
 
 unlock_irq_spinlock:
@@ -567,8 +578,7 @@ static void __queue_comp_task(struct ehca_cq *__cq,
 		list_add_tail(&__cq->entry, &cct->cq_list);
 		cct->cq_jobs++;
 		wake_up(&cct->wait_queue);
-	}
-	else
+	} else
 		__cq->nr_callbacks++;
 
 	spin_unlock(&__cq->task_lock);
@@ -577,18 +587,21 @@ static void __queue_comp_task(struct ehca_cq *__cq,
 
 static void queue_comp_task(struct ehca_cq *__cq)
 {
-	int cpu;
 	int cpu_id;
 	struct ehca_cpu_comp_task *cct;
+	int cq_jobs;
+	unsigned long flags;
 
-	cpu = get_cpu();
 	cpu_id = find_next_online_cpu(pool);
 	BUG_ON(!cpu_online(cpu_id));
 
 	cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu_id);
 	BUG_ON(!cct);
 
-	if (cct->cq_jobs > 0) {
+	spin_lock_irqsave(&cct->task_lock, flags);
+	cq_jobs = cct->cq_jobs;
+	spin_unlock_irqrestore(&cct->task_lock, flags);
+	if (cq_jobs > 0) {
 		cpu_id = find_next_online_cpu(pool);
 		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu_id);
 		BUG_ON(!cct);
@@ -608,11 +621,17 @@ static void run_comp_task(struct ehca_cpu_comp_task* cct)
 		cq = list_entry(cct->cq_list.next, struct ehca_cq, entry);
 		spin_unlock_irqrestore(&cct->task_lock, flags);
 		comp_event_callback(cq);
-		spin_lock_irqsave(&cct->task_lock, flags);
 
+		spin_lock_irqsave(&ehca_cq_idr_lock, flags);
+		cq->nr_events--;
+		if (!cq->nr_events)
+			wake_up(&cq->wait_completion);
+		spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+
+		spin_lock_irqsave(&cct->task_lock, flags);
 		spin_lock(&cq->task_lock);
 		cq->nr_callbacks--;
-		if (cq->nr_callbacks == 0) {
+		if (!cq->nr_callbacks) {
 			list_del_init(cct->cq_list.next);
 			cct->cq_jobs--;
 		}
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index c183512..059da96 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -52,7 +52,7 @@
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Christoph Raisch <raisch@de.ibm.com>");
 MODULE_DESCRIPTION("IBM eServer HCA InfiniBand Device Driver");
-MODULE_VERSION("SVNEHCA_0021");
+MODULE_VERSION("SVNEHCA_0022");
 
 int ehca_open_aqp1     = 0;
 int ehca_debug_level   = 0;
@@ -810,7 +810,7 @@ int __init ehca_module_init(void)
 	int ret;
 
 	printk(KERN_INFO "eHCA Infiniband Device Driver "
-	       "(Rel.: SVNEHCA_0021)\n");
+	       "(Rel.: SVNEHCA_0022)\n");
 	idr_init(&ehca_qp_idr);
 	idr_init(&ehca_cq_idr);
 	spin_lock_init(&ehca_qp_idr_lock);
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index 71dc84b..1c6b63a 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -1088,21 +1088,21 @@ static void mthca_unmap_memfree(struct mthca_dev *dev,
 static int mthca_alloc_memfree(struct mthca_dev *dev,
 			       struct mthca_qp *qp)
 {
-	int ret = 0;
-
 	if (mthca_is_memfree(dev)) {
 		qp->rq.db_index = mthca_alloc_db(dev, MTHCA_DB_TYPE_RQ,
 						 qp->qpn, &qp->rq.db);
 		if (qp->rq.db_index < 0)
-			return ret;
+			return -ENOMEM;
 
 		qp->sq.db_index = mthca_alloc_db(dev, MTHCA_DB_TYPE_SQ,
 						 qp->qpn, &qp->sq.db);
-		if (qp->sq.db_index < 0)
+		if (qp->sq.db_index < 0) {
 			mthca_free_db(dev, MTHCA_DB_TYPE_RQ, qp->rq.db_index);
+			return -ENOMEM;
+		}
 	}
 
-	return ret;
+	return 0;
 }
 
 static void mthca_free_memfree(struct mthca_dev *dev,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index bb2e3d5..56c87a8 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -407,6 +407,10 @@ static int ipoib_mcast_join_complete(int status,
 			queue_delayed_work(ipoib_workqueue,
 					   &priv->mcast_task, 0);
 		mutex_unlock(&mcast_mutex);
+
+		if (mcast == priv->broadcast)
+			netif_carrier_on(dev);
+
 		return 0;
 	}
 
@@ -594,7 +598,6 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	ipoib_dbg_mcast(priv, "successfully joined all multicast groups\n");
 
 	clear_bit(IPOIB_MCAST_RUN, &priv->flags);
-	netif_carrier_on(dev);
 }
 
 int ipoib_mcast_start_thread(struct net_device *dev)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 3cb551b..7f3ec20 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -259,12 +259,13 @@ void ipoib_event(struct ib_event_handler *handler,
 	struct ipoib_dev_priv *priv =
 		container_of(handler, struct ipoib_dev_priv, event_handler);
 
-	if (record->event == IB_EVENT_PORT_ERR    ||
-	    record->event == IB_EVENT_PKEY_CHANGE ||
-	    record->event == IB_EVENT_PORT_ACTIVE ||
-	    record->event == IB_EVENT_LID_CHANGE  ||
-	    record->event == IB_EVENT_SM_CHANGE   ||
-	    record->event == IB_EVENT_CLIENT_REREGISTER) {
+	if ((record->event == IB_EVENT_PORT_ERR    ||
+	     record->event == IB_EVENT_PKEY_CHANGE ||
+	     record->event == IB_EVENT_PORT_ACTIVE ||
+	     record->event == IB_EVENT_LID_CHANGE  ||
+	     record->event == IB_EVENT_SM_CHANGE   ||
+	     record->event == IB_EVENT_CLIENT_REREGISTER) &&
+	    record->element.port_num == priv->port) {
 		ipoib_dbg(priv, "Port state change event\n");
 		queue_work(ipoib_workqueue, &priv->flush_task);
 	}
