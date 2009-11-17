Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbZKQI0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbZKQI0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbZKQI0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:26:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:45384 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbZKQI0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:26:15 -0500
Date: Tue, 17 Nov 2009 08:25:22 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbarnes@virtuousgeek.org, fujita.tomonori@lab.ntt.co.jp,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, fujita.tomonori@lab.ntt.co.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258287594-8777-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1258287594-8777-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86: Calgary: Remove unnecessary DMA_ERROR_CODE usage
Message-ID: <tip-1f7564ca831a00b21bb493ef174c845b2ba9e64d@git.kernel.org>
Git-Commit-ID: 1f7564ca831a00b21bb493ef174c845b2ba9e64d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f7564ca831a00b21bb493ef174c845b2ba9e64d
Gitweb:     http://git.kernel.org/tip/1f7564ca831a00b21bb493ef174c845b2ba9e64d
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Sun, 15 Nov 2009 21:19:54 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 07:53:21 +0100

x86: Calgary: Remove unnecessary DMA_ERROR_CODE usage

This cleans up iommu_alloc() a bit and removes unnecessary
DMA_ERROR_CODE usage.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: muli@il.ibm.com
Cc: joerg.roedel@amd.com
LKML-Reference: <1258287594-8777-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/pci-calgary_64.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index af9f436..849a099 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -261,12 +261,15 @@ static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
 			      void *vaddr, unsigned int npages, int direction)
 {
 	unsigned long entry;
-	dma_addr_t ret = DMA_ERROR_CODE;
+	dma_addr_t ret;
 
 	entry = iommu_range_alloc(dev, tbl, npages);
 
-	if (unlikely(entry == DMA_ERROR_CODE))
-		goto error;
+	if (unlikely(entry == DMA_ERROR_CODE)) {
+		printk(KERN_WARNING "Calgary: failed to allocate %u pages in "
+		       "iommu %p\n", npages, tbl);
+		return DMA_ERROR_CODE;
+	}
 
 	/* set the return dma address */
 	ret = (entry << PAGE_SHIFT) | ((unsigned long)vaddr & ~PAGE_MASK);
@@ -274,13 +277,7 @@ static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
 	/* put the TCEs in the HW table */
 	tce_build(tbl, entry, npages, (unsigned long)vaddr & PAGE_MASK,
 		  direction);
-
 	return ret;
-
-error:
-	printk(KERN_WARNING "Calgary: failed to allocate %u pages in "
-	       "iommu %p\n", npages, tbl);
-	return DMA_ERROR_CODE;
 }
 
 static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
