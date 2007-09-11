Return-Path: <linux-kernel-owner+w=401wt.eu-S1764277AbXIKNbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764277AbXIKNbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763376AbXIKNbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:31:12 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:1833 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758650AbXIKNbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:31:10 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 04/12] IB/ehca: Use remap_4k_pfn() to map firmware contexts to user space
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709111518.26276.fenkes@de.ibm.com>
In-Reply-To: <200709111518.26276.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3006
Date: Tue, 11 Sep 2007 15:31:06 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709111531.07604.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

Use Paul's new remap_4k_pfn() function to map our 4K firmware contexts into
user space on 64K-page machines without exposing neighboring firmware
contexts. Return the context's offset within a 64K page to user space so it
can determine the proper virtual address.

For details about remap_4k_pfn(), see commit 721151d0 or
http://patchwork.ozlabs.org/linuxppc/patch?id=10281

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    4 +++-
 drivers/infiniband/hw/ehca/ehca_cq.c      |    2 ++
 drivers/infiniband/hw/ehca/ehca_qp.c      |    2 ++
 drivers/infiniband/hw/ehca/ehca_uverbs.c  |    6 +++---
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index b5e9603..206d4eb 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -337,6 +337,8 @@ struct ehca_create_cq_resp {
 	u32 cq_number;
 	u32 token;
 	struct ipzu_queue_resp ipz_queue;
+	u32 fw_handle_ofs;
+	u32 dummy;
 };
 
 struct ehca_create_qp_resp {
@@ -347,7 +349,7 @@ struct ehca_create_qp_resp {
 	u32 qkey;
 	/* qp_num assigned by ehca: sqp0/1 may have got different numbers */
 	u32 real_qp_num;
-	u32 dummy; /* padding for 8 byte alignment */
+	u32 fw_handle_ofs;
 	struct ipzu_queue_resp ipz_squeue;
 	struct ipzu_queue_resp ipz_rqueue;
 };
diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index a6f17e4..d68603d 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -281,6 +281,8 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 		resp.ipz_queue.queue_length = ipz_queue->queue_length;
 		resp.ipz_queue.pagesize = ipz_queue->pagesize;
 		resp.ipz_queue.toggle_state = ipz_queue->toggle_state;
+		resp.fw_handle_ofs = (u32)
+			(my_cq->galpas.user.fw_handle & (PAGE_SIZE - 1));
 		if (ib_copy_to_udata(udata, &resp, sizeof(resp))) {
 			ehca_err(device, "Copy to udata failed.");
 			goto create_cq_exit4;
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index e886e3b..3a3880f 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -751,6 +751,8 @@ static struct ehca_qp *internal_create_qp(
 			queue2resp(&resp.ipz_squeue, &my_qp->ipz_squeue);
 		if (HAS_RQ(my_qp))
 			queue2resp(&resp.ipz_rqueue, &my_qp->ipz_rqueue);
+		resp.fw_handle_ofs = (u32)
+			(my_qp->galpas.user.fw_handle & (PAGE_SIZE - 1));
 
 		if (ib_copy_to_udata(udata, &resp, sizeof resp)) {
 			ehca_err(pd->device, "Copy to udata failed");
diff --git a/drivers/infiniband/hw/ehca/ehca_uverbs.c b/drivers/infiniband/hw/ehca/ehca_uverbs.c
index 3340f49..84a16bc 100644
--- a/drivers/infiniband/hw/ehca/ehca_uverbs.c
+++ b/drivers/infiniband/hw/ehca/ehca_uverbs.c
@@ -109,7 +109,7 @@ static int ehca_mmap_fw(struct vm_area_struct *vma, struct h_galpas *galpas,
 	u64 vsize, physical;
 
 	vsize = vma->vm_end - vma->vm_start;
-	if (vsize != EHCA_PAGESIZE) {
+	if (vsize < EHCA_PAGESIZE) {
 		ehca_gen_err("invalid vsize=%lx", vma->vm_end - vma->vm_start);
 		return -EINVAL;
 	}
@@ -118,8 +118,8 @@ static int ehca_mmap_fw(struct vm_area_struct *vma, struct h_galpas *galpas,
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	ehca_gen_dbg("vsize=%lx physical=%lx", vsize, physical);
 	/* VM_IO | VM_RESERVED are set by remap_pfn_range() */
-	ret = remap_pfn_range(vma, vma->vm_start, physical >> PAGE_SHIFT,
-			      vsize, vma->vm_page_prot);
+	ret = remap_4k_pfn(vma, vma->vm_start, physical >> EHCA_PAGESHIFT,
+			   vma->vm_page_prot);
 	if (unlikely(ret)) {
 		ehca_gen_err("remap_pfn_range() failed ret=%x", ret);
 		return -ENOMEM;
-- 
1.5.2


