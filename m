Return-Path: <linux-kernel-owner+w=401wt.eu-S938168AbXHHSmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938168AbXHHSmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763959AbXHHSl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:41:59 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43358 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761334AbXHHSl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:41:57 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org,
       "\"Hoang-Nam Nguyen\" @dyn-9-152-249-53" 
	<Hoang-Nam.Nguyen@d01av04.pok.ibm.com>,
       fenkes@de.ibm.com
Subject: [PATCH 4/7] IB/ehca: Support more than 4k QPs for userspace and kernelspace
Date: Wed, 8 Aug 2007 20:41:54 +0200
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708082041.55794.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_cq.c     |    7 ++++++-
 drivers/infiniband/hw/ehca/ehca_qp.c     |    6 ++++++
 drivers/infiniband/hw/ehca/ehca_uverbs.c |   22 +++++++++++-----------
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 81aff36..c661939 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -168,7 +168,12 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 		write_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 
 	} while (ret == -EAGAIN);
-
+	if (my_cq->token > 0x1FFFFFF) {
+		cq = ERR_PTR(-ENOMEM);
+		ehca_err(device, "Invalid number of qp. device=%p",
+			 device);
+		goto create_cq_exit2;
+	}
 	if (ret) {
 		cq = ERR_PTR(-ENOMEM);
 		ehca_err(device, "Can't allocate new idr entry. device=%p",
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 13b61c3..f26801b 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -560,6 +560,12 @@ static struct ehca_qp *internal_create_qp(
 
 	} while (ret == -EAGAIN);
 
+	if (my_qp->token > 0x1FFFFFF) {
+		ret = -EINVAL;
+		ehca_err(pd->device, "Invalid number of qp");
+		goto create_qp_exit1;
+	}
+
 	if (ret) {
 		ret = -ENOMEM;
 		ehca_err(pd->device, "Can't allocate new idr entry.");
diff --git a/drivers/infiniband/hw/ehca/ehca_uverbs.c b/drivers/infiniband/hw/ehca/ehca_uverbs.c
index 4bc687f..3340f49 100644
--- a/drivers/infiniband/hw/ehca/ehca_uverbs.c
+++ b/drivers/infiniband/hw/ehca/ehca_uverbs.c
@@ -164,7 +164,7 @@ static int ehca_mmap_cq(struct vm_area_struct *vma, struct ehca_cq *cq,
 	int ret;
 
 	switch (rsrc_type) {
-	case 1: /* galpa fw handle */
+	case 0: /* galpa fw handle */
 		ehca_dbg(cq->ib_cq.device, "cq_num=%x fw", cq->cq_number);
 		ret = ehca_mmap_fw(vma, &cq->galpas, &cq->mm_count_galpa);
 		if (unlikely(ret)) {
@@ -175,7 +175,7 @@ static int ehca_mmap_cq(struct vm_area_struct *vma, struct ehca_cq *cq,
 		}
 		break;
 
-	case 2: /* cq queue_addr */
+	case 1: /* cq queue_addr */
 		ehca_dbg(cq->ib_cq.device, "cq_num=%x queue", cq->cq_number);
 		ret = ehca_mmap_queue(vma, &cq->ipz_queue, &cq->mm_count_queue);
 		if (unlikely(ret)) {
@@ -201,7 +201,7 @@ static int ehca_mmap_qp(struct vm_area_struct *vma, struct ehca_qp *qp,
 	int ret;
 
 	switch (rsrc_type) {
-	case 1: /* galpa fw handle */
+	case 0: /* galpa fw handle */
 		ehca_dbg(qp->ib_qp.device, "qp_num=%x fw", qp->ib_qp.qp_num);
 		ret = ehca_mmap_fw(vma, &qp->galpas, &qp->mm_count_galpa);
 		if (unlikely(ret)) {
@@ -212,7 +212,7 @@ static int ehca_mmap_qp(struct vm_area_struct *vma, struct ehca_qp *qp,
 		}
 		break;
 
-	case 2: /* qp rqueue_addr */
+	case 1: /* qp rqueue_addr */
 		ehca_dbg(qp->ib_qp.device, "qp_num=%x rqueue",
 			 qp->ib_qp.qp_num);
 		ret = ehca_mmap_queue(vma, &qp->ipz_rqueue,
@@ -225,7 +225,7 @@ static int ehca_mmap_qp(struct vm_area_struct *vma, struct ehca_qp *qp,
 		}
 		break;
 
-	case 3: /* qp squeue_addr */
+	case 2: /* qp squeue_addr */
 		ehca_dbg(qp->ib_qp.device, "qp_num=%x squeue",
 			 qp->ib_qp.qp_num);
 		ret = ehca_mmap_queue(vma, &qp->ipz_squeue,
@@ -249,10 +249,10 @@ static int ehca_mmap_qp(struct vm_area_struct *vma, struct ehca_qp *qp,
 
 int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 {
-	u64 fileoffset = vma->vm_pgoff << PAGE_SHIFT;
-	u32 idr_handle = fileoffset >> 32;
-	u32 q_type = (fileoffset >> 28) & 0xF;	  /* CQ, QP,...        */
-	u32 rsrc_type = (fileoffset >> 24) & 0xF; /* sq,rq,cmnd_window */
+	u64 fileoffset = vma->vm_pgoff;
+	u32 idr_handle = fileoffset & 0x1FFFFFF;
+	u32 q_type = (fileoffset >> 27) & 0x1;	  /* CQ, QP,...        */
+	u32 rsrc_type = (fileoffset >> 25) & 0x3; /* sq,rq,cmnd_window */
 	u32 cur_pid = current->tgid;
 	u32 ret;
 	struct ehca_cq *cq;
@@ -261,7 +261,7 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	struct ib_uobject *uobject;
 
 	switch (q_type) {
-	case  1: /* CQ */
+	case  0: /* CQ */
 		read_lock(&ehca_cq_idr_lock);
 		cq = idr_find(&ehca_cq_idr, idr_handle);
 		read_unlock(&ehca_cq_idr_lock);
@@ -289,7 +289,7 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		}
 		break;
 
-	case 2: /* QP */
+	case 1: /* QP */
 		read_lock(&ehca_qp_idr_lock);
 		qp = idr_find(&ehca_qp_idr, idr_handle);
 		read_unlock(&ehca_qp_idr_lock);
-- 
1.5.2


