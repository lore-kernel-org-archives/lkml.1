Return-Path: <linux-kernel-owner+w=401wt.eu-S968076AbXILMjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968076AbXILMjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 08:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965805AbXILMjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 08:39:36 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:12533 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965250AbXILMjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 08:39:35 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH] IB/ehca: Make sure user pages are from hugetlb before using MR large pages
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Wed, 12 Sep 2007 14:39:31 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709121439.32641.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

...because, on virtualized hardware like System p, we can't be sure that the
physical pages behind them are contiguous.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---

Another patch for 2.6.24 that will apply cleanly on top of my previous
patchset. Please review and apply. Thanks!

 drivers/infiniband/hw/ehca/ehca_classes.h |    8 ++--
 drivers/infiniband/hw/ehca/ehca_mrmw.c    |   82 +++++++++++++++++++++++++----
 2 files changed, 75 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 206d4eb..c2edd4c 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -99,10 +99,10 @@ struct ehca_sport {
 	struct ehca_sma_attr saved_attr;
 };
 
-#define HCA_CAP_MR_PGSIZE_4K  1
-#define HCA_CAP_MR_PGSIZE_64K 2
-#define HCA_CAP_MR_PGSIZE_1M  4
-#define HCA_CAP_MR_PGSIZE_16M 8
+#define HCA_CAP_MR_PGSIZE_4K  0x80000000
+#define HCA_CAP_MR_PGSIZE_64K 0x40000000
+#define HCA_CAP_MR_PGSIZE_1M  0x20000000
+#define HCA_CAP_MR_PGSIZE_16M 0x10000000
 
 struct ehca_shca {
 	struct ib_device ib_device;
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 4c8f3b3..1bb9d23 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -41,6 +41,8 @@
  */
 
 #include <asm/current.h>
+#include <linux/mm.h>
+#include <linux/hugetlb.h>
 
 #include <rdma/ib_umem.h>
 
@@ -51,6 +53,7 @@
 
 #define NUM_CHUNKS(length, chunk_size) \
 	(((length) + (chunk_size - 1)) / (chunk_size))
+
 /* max number of rpages (per hcall register_rpages) */
 #define MAX_RPAGES 512
 
@@ -279,6 +282,52 @@ reg_phys_mr_exit0:
 } /* end ehca_reg_phys_mr() */
 
 /*----------------------------------------------------------------------*/
+static int ehca_is_mem_hugetlb(unsigned long addr, unsigned long size)
+{
+	struct vm_area_struct **vma_list;
+	unsigned long cur_base;
+	unsigned long npages;
+	int ret, i;
+
+	vma_list = (struct vm_area_struct **) __get_free_page(GFP_KERNEL);
+	if (!vma_list) {
+		ehca_gen_err("Can not alloc vma_list");
+		return -ENOMEM;
+	}
+
+	down_write(&current->mm->mmap_sem);
+	npages = PAGE_ALIGN(size + (addr & ~PAGE_MASK)) >> PAGE_SHIFT;
+	cur_base = addr & PAGE_MASK;
+
+	while (npages) {
+		ret = get_user_pages(current, current->mm, cur_base,
+				     min_t(int, npages,
+					   PAGE_SIZE / sizeof (*vma_list)),
+				     1, 0, NULL, vma_list);
+
+		if (ret < 0) {
+			ehca_gen_err("get_user_pages() failed "
+				     "ret=%x cur_base=%lx", ret, cur_base);
+			goto is_hugetlb_out;
+		}
+
+		for (i = 0; i < ret; ++i)
+			if (!is_vm_hugetlb_page(vma_list[i])) {
+				ret = 0;
+				goto is_hugetlb_out;
+			}
+
+		cur_base += ret * PAGE_SIZE;
+		npages -= ret;
+	}
+	ret = 1;
+
+is_hugetlb_out:
+	up_write(&current->mm->mmap_sem);
+	free_page((unsigned long) vma_list);
+
+	return ret;
+}
 
 struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			       u64 virt, int mr_access_flags,
@@ -346,18 +395,29 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	num_kpages = NUM_CHUNKS((virt % PAGE_SIZE) + length, PAGE_SIZE);
 	/* select proper hw_pgsize */
 	if (ehca_mr_largepage &&
-	    (shca->hca_cap_mr_pgsize & HCA_CAP_MR_PGSIZE_16M)) {
-		if (length <= EHCA_MR_PGSIZE4K
-		    && PAGE_SIZE == EHCA_MR_PGSIZE4K)
-			hwpage_size = EHCA_MR_PGSIZE4K;
-		else if (length <= EHCA_MR_PGSIZE64K)
-			hwpage_size = EHCA_MR_PGSIZE64K;
-		else if (length <= EHCA_MR_PGSIZE1M)
-			hwpage_size = EHCA_MR_PGSIZE1M;
-		else
-			hwpage_size = EHCA_MR_PGSIZE16M;
+	    shca->hca_cap_mr_pgsize & HCA_CAP_MR_PGSIZE_16M) {
+		ret = ehca_is_mem_hugetlb(virt, length);
+		switch (ret) {
+		case 0: /* mem is not from hugetlb */
+			hwpage_size = PAGE_SIZE;
+			break;
+		case 1:
+			if (length <= EHCA_MR_PGSIZE4K
+			    && PAGE_SIZE == EHCA_MR_PGSIZE4K)
+				hwpage_size = EHCA_MR_PGSIZE4K;
+			else if (length <= EHCA_MR_PGSIZE64K)
+				hwpage_size = EHCA_MR_PGSIZE64K;
+			else if (length <= EHCA_MR_PGSIZE1M)
+				hwpage_size = EHCA_MR_PGSIZE1M;
+			else
+				hwpage_size = EHCA_MR_PGSIZE16M;
+			break;
+		default: /* out of mem */
+			ib_mr = ERR_PTR(-ENOMEM);
+			goto reg_user_mr_exit1;
+		}
 	} else
-		hwpage_size = EHCA_MR_PGSIZE4K;
+		hwpage_size = EHCA_MR_PGSIZE4K; /* ehca1 can only 4k */
 	ehca_dbg(pd->device, "hwpage_size=%lx", hwpage_size);
 
 reg_user_mr_fallback:
-- 
1.5.2



