Return-Path: <linux-kernel-owner+w=401wt.eu-S1764905AbXIMQR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764905AbXIMQR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762122AbXIMQPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:15:44 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:43248 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760406AbXIMQPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:15:43 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 2/3] IB/umem: Add hugetlb flag to struct ib_umem
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709131814.13937.fenkes@de.ibm.com>
In-Reply-To: <200709131814.13937.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1866
Date: Thu, 13 Sep 2007 18:15:28 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709131815.29040.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

During ib_umem_get(), determine whether all pages from the memory region are
hugetlb pages and report this in the "hugetlb" field. Low-level driver can
use this information if they need it.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/core/umem.c |   20 +++++++++++++++++++-
 include/rdma/ib_umem.h         |    1 +
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 664d2fa..2f54e29 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -37,6 +37,7 @@
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
 #include <linux/sched.h>
+#include <linux/hugetlb.h>
 
 #include "uverbs.h"
 
@@ -75,6 +76,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 {
 	struct ib_umem *umem;
 	struct page **page_list;
+	struct vm_area_struct **vma_list;
 	struct ib_umem_chunk *chunk;
 	unsigned long locked;
 	unsigned long lock_limit;
@@ -104,6 +106,9 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	 */
 	umem->writable  = !!(access & ~IB_ACCESS_REMOTE_READ);
 
+	/* We assume the memory is from hugetlb until proved otherwise */
+	umem->hugetlb   = 1;
+
 	INIT_LIST_HEAD(&umem->chunk_list);
 
 	page_list = (struct page **) __get_free_page(GFP_KERNEL);
@@ -112,6 +117,14 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 		return ERR_PTR(-ENOMEM);
 	}
 
+	/*
+	 * if we can't alloc the vma_list, it's not so bad;
+	 * just assume the memory is not hugetlb memory
+	 */
+	vma_list = (struct vm_area_struct **) __get_free_page(GFP_KERNEL);
+	if (!vma_list)
+		umem->hugetlb = 0;
+
 	npages = PAGE_ALIGN(size + umem->offset) >> PAGE_SHIFT;
 
 	down_write(&current->mm->mmap_sem);
@@ -131,7 +144,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 		ret = get_user_pages(current, current->mm, cur_base,
 				     min_t(int, npages,
 					   PAGE_SIZE / sizeof (struct page *)),
-				     1, !umem->writable, page_list, NULL);
+				     1, !umem->writable, page_list, vma_list);
 
 		if (ret < 0)
 			goto out;
@@ -152,6 +165,9 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 
 			chunk->nents = min_t(int, ret, IB_UMEM_MAX_PAGE_CHUNK);
 			for (i = 0; i < chunk->nents; ++i) {
+				if (vma_list &&
+				    !is_vm_hugetlb_page(vma_list[i + off]))
+					umem->hugetlb = 0;
 				chunk->page_list[i].page   = page_list[i + off];
 				chunk->page_list[i].offset = 0;
 				chunk->page_list[i].length = PAGE_SIZE;
@@ -186,6 +202,8 @@ out:
 		current->mm->locked_vm = locked;
 
 	up_write(&current->mm->mmap_sem);
+	if (vma_list)
+		free_page((unsigned long) vma_list);
 	free_page((unsigned long) page_list);
 
 	return ret < 0 ? ERR_PTR(ret) : umem;
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index c533d6c..2229842 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -45,6 +45,7 @@ struct ib_umem {
 	int			offset;
 	int			page_size;
 	int                     writable;
+	int                     hugetlb;
 	struct list_head	chunk_list;
 	struct work_struct	work;
 	struct mm_struct       *mm;
-- 
1.5.2


