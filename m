Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZKQI11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZKQI11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbZKQI11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:27:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:45987 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbZKQI10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:27:26 -0500
Date: Tue, 17 Nov 2009 08:24:49 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbarnes@virtuousgeek.org, fujita.tomonori@lab.ntt.co.jp,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, fujita.tomonori@lab.ntt.co.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258287594-8777-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1258287594-8777-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86: gart: Add own dma_mapping_error function
Message-ID: <tip-42109197eb7c01080eea6d9cd48ca23cbc3c566c@git.kernel.org>
Git-Commit-ID: 42109197eb7c01080eea6d9cd48ca23cbc3c566c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42109197eb7c01080eea6d9cd48ca23cbc3c566c
Gitweb:     http://git.kernel.org/tip/42109197eb7c01080eea6d9cd48ca23cbc3c566c
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Sun, 15 Nov 2009 21:19:52 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 07:53:20 +0100

x86: gart: Add own dma_mapping_error function

GART IOMMU is the only user of bad_dma_address variable.

This patch converts GART to use the newer mechanism, fill in
->mapping_error() in struct dma_map_ops, to make
dma_mapping_error() work in IOMMU specific way.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: muli@il.ibm.com
Cc: joerg.roedel@amd.com
LKML-Reference: <1258287594-8777-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/pci-gart_64.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 919182e..61c4d1e 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -47,6 +47,8 @@ static unsigned long iommu_pages;	/* .. and in pages */
 
 static u32 *iommu_gatt_base;		/* Remapping table */
 
+static dma_addr_t bad_dma_addr;
+
 /*
  * If this is disabled the IOMMU will use an optimized flushing strategy
  * of only flushing when an mapping is reused. With it true the GART is
@@ -217,7 +219,7 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 		if (panic_on_overflow)
 			panic("dma_map_area overflow %lu bytes\n", size);
 		iommu_full(dev, size, dir);
-		return bad_dma_address;
+		return bad_dma_addr;
 	}
 
 	for (i = 0; i < npages; i++) {
@@ -303,7 +305,7 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 
 		if (nonforced_iommu(dev, addr, s->length)) {
 			addr = dma_map_area(dev, addr, s->length, dir, 0);
-			if (addr == bad_dma_address) {
+			if (addr == bad_dma_addr) {
 				if (i > 0)
 					gart_unmap_sg(dev, sg, i, dir, NULL);
 				nents = 0;
@@ -456,7 +458,7 @@ error:
 
 	iommu_full(dev, pages << PAGE_SHIFT, dir);
 	for_each_sg(sg, s, nents, i)
-		s->dma_address = bad_dma_address;
+		s->dma_address = bad_dma_addr;
 	return 0;
 }
 
@@ -480,7 +482,7 @@ gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
 				     DMA_BIDIRECTIONAL, align_mask);
 
 		flush_gart();
-		if (paddr != bad_dma_address) {
+		if (paddr != bad_dma_addr) {
 			*dma_addr = paddr;
 			return page_address(page);
 		}
@@ -500,6 +502,11 @@ gart_free_coherent(struct device *dev, size_t size, void *vaddr,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
+static int gart_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return (dma_addr == bad_dma_addr);
+}
+
 static int no_agp;
 
 static __init unsigned long check_iommu_size(unsigned long aper, u64 aper_size)
@@ -687,6 +694,7 @@ static struct dma_map_ops gart_dma_ops = {
 	.unmap_page			= gart_unmap_page,
 	.alloc_coherent			= gart_alloc_coherent,
 	.free_coherent			= gart_free_coherent,
+	.mapping_error			= gart_mapping_error,
 };
 
 static void gart_iommu_shutdown(void)
@@ -785,7 +793,7 @@ int __init gart_iommu_init(void)
 
 	iommu_start = aper_size - iommu_size;
 	iommu_bus_base = info.aper_base + iommu_start;
-	bad_dma_address = iommu_bus_base;
+	bad_dma_addr = iommu_bus_base;
 	iommu_gatt_base = agp_gatt_table + (iommu_start>>PAGE_SHIFT);
 
 	/*
