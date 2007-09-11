Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbXIKN3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbXIKN3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758490AbXIKN3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:29:44 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:21218 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719AbXIKN3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:29:43 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 03/12] IB/ehca: Support more than 4k QPs for userspace and kernelspace
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709111518.26276.fenkes@de.ibm.com>
In-Reply-To: <200709111518.26276.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3006
Date: Tue, 11 Sep 2007 15:29:39 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709111529.40292.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Roscher <stefan.roscher@de.ibm.com>

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_cq.c     |    7 ++++++-
 drivers/infiniband/hw/ehca/ehca_main.c   |    2 +-
 drivers/infiniband/hw/ehca/ehca_qp.c     |    9 +++++++--
 drivers/infiniband/hw/ehca/ehca_uverbs.c |   22 +++++++++++-----------
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 81aff36..a6f17e4 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -166,7 +166,6 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 		write_lock_irqsave(&ehca_cq_idr_lock, flags);
 		ret = idr_get_new(&ehca_cq_idr, my_cq, &my_cq->token);
 		write_unlock_irqrestore(&ehca_cq_idr_lock, flags);
-
 	} while (ret == -EAGAIN);
 
 	if (ret) {
@@ -176,6 +175,12 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 		goto create_cq_exit1;
 	}
 
+	if (my_cq->token > 0x1FFFFFF) {
+		cq = ERR_PTR(-ENOMEM);
+		ehca_err(device, "Invalid number of cq. device=%p", device);
+		goto create_cq_exit2;
+	}
+
 	/*
 	 * CQs maximum depth is 4GB-64, but we need additional 20 as buffer
 	 * for receiving errors CQEs.
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 99036b6..1a2c542 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -380,7 +380,7 @@ int ehca_init_device(struct ehca_shca *shca)
 	strlcpy(shca->ib_device.name, "ehca%d", IB_DEVICE_NAME_MAX);
 	shca->ib_device.owner               = THIS_MODULE;
 
-	shca->ib_device.uverbs_abi_ver	    = 7;
+	shca->ib_device.uverbs_abi_ver	    = 8;
 	shca->ib_device.uverbs_cmd_mask	    =
 		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT)		|
 		(1ull << IB_USER_VERBS_CMD_QUERY_DEVICE)	|
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 13b61c3..e886e3b 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -557,7 +557,6 @@ static struct ehca_qp *internal_create_qp(
 		write_lock_irqsave(&ehca_qp_idr_lock, flags);
 		ret = idr_get_new(&ehca_qp_idr, my_qp, &my_qp->token);
 		write_unlock_irqrestore(&ehca_qp_idr_lock, flags);
-
 	} while (ret == -EAGAIN);
 
 	if (ret) {
@@ -566,11 +565,17 @@ static struct ehca_qp *internal_create_qp(
 		goto create_qp_exit0;
 	}
 
+	if (my_qp->token > 0x1FFFFFF) {
+		ret = -EINVAL;
+		ehca_err(pd->device, "Invalid number of qp");
+		goto create_qp_exit1;
+	}
+
 	parms.servicetype = ibqptype2servicetype(qp_type);
 	if (parms.servicetype < 0) {
 		ret = -EINVAL;
 		ehca_err(pd->device, "Invalid qp_type=%x", qp_type);
-		goto create_qp_exit0;
+		goto create_qp_exit1;
 	}
 
 	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
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


