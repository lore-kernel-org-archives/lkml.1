Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZGMGal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZGMGal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZGMG3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:29:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:60443 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbZGMG2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:28:43 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       reif@earthlink.net, x86@kernel.org, tony.luck@intel.com,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org
Subject: [PATCH 6/8] sparc: replace sbus_map_single and sbus_unmap_single with sbus_map_page and sbus_unmap_page
Date: Mon, 13 Jul 2009 15:25:58 +0900
Message-Id: <1247466360-13330-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 13 Jul 2009 15:27:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation for using asm-generic/pci-dma-compat.h; SPARC32
has two dma_map_ops structures for pci and sbus (removing
arch/sparc/kernel/dma.c, PCI and SBUS DMA accessor).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Robert Reif <reif@earthlink.net>
---
 arch/sparc/kernel/dma.c    |    5 ++---
 arch/sparc/kernel/dma.h    |    6 +++---
 arch/sparc/kernel/ioport.c |    7 +++++--
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/sparc/kernel/dma.c b/arch/sparc/kernel/dma.c
index 15820a9..a5d50da 100644
--- a/arch/sparc/kernel/dma.c
+++ b/arch/sparc/kernel/dma.c
@@ -68,8 +68,7 @@ static dma_addr_t dma32_map_page(struct device *dev, struct page *page,
 		return pci_map_page(to_pci_dev(dev), page, offset,
 				    size, (int)direction);
 #endif
-	return sbus_map_single(dev, page_address(page) + offset,
-			       size, (int)direction);
+	return sbus_map_page(dev, page, offset, size, (int)direction);
 }
 
 static void dma32_unmap_page(struct device *dev, dma_addr_t dma_address,
@@ -83,7 +82,7 @@ static void dma32_unmap_page(struct device *dev, dma_addr_t dma_address,
 		return;
 	}
 #endif
-	sbus_unmap_single(dev, dma_address, size, (int)direction);
+	sbus_unmap_page(dev, dma_address, size, (int)direction);
 }
 
 static int dma32_map_sg(struct device *dev, struct scatterlist *sg,
diff --git a/arch/sparc/kernel/dma.h b/arch/sparc/kernel/dma.h
index f8d8951..680351e 100644
--- a/arch/sparc/kernel/dma.h
+++ b/arch/sparc/kernel/dma.h
@@ -1,8 +1,8 @@
 void *sbus_alloc_consistent(struct device *dev, long len, u32 *dma_addrp);
 void sbus_free_consistent(struct device *dev, long n, void *p, u32 ba);
-dma_addr_t sbus_map_single(struct device *dev, void *va,
-			   size_t len, int direction);
-void sbus_unmap_single(struct device *dev, dma_addr_t ba,
+dma_addr_t sbus_map_page(struct device *dev, struct page *page,
+			 unsigned long offset, size_t len, int direction);
+void sbus_unmap_page(struct device *dev, dma_addr_t ba,
 		       size_t n, int direction);
 int sbus_map_sg(struct device *dev, struct scatterlist *sg,
 		int n, int direction);
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 87ea0d0..39ff1e0 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -337,8 +337,11 @@ void sbus_free_consistent(struct device *dev, long n, void *p, u32 ba)
  * CPU view of this memory may be inconsistent with
  * a device view and explicit flushing is necessary.
  */
-dma_addr_t sbus_map_single(struct device *dev, void *va, size_t len, int direction)
+dma_addr_t sbus_map_page(struct device *dev, struct page *page,
+			 unsigned long offset, size_t len, int direction)
 {
+	void *va = page_address(page) + offset;
+
 	/* XXX why are some lengths signed, others unsigned? */
 	if (len <= 0) {
 		return 0;
@@ -350,7 +353,7 @@ dma_addr_t sbus_map_single(struct device *dev, void *va, size_t len, int directi
 	return mmu_get_scsi_one(dev, va, len);
 }
 
-void sbus_unmap_single(struct device *dev, dma_addr_t ba, size_t n, int direction)
+void sbus_unmap_page(struct device *dev, dma_addr_t ba, size_t n, int direction)
 {
 	mmu_release_scsi_one(dev, ba, n);
 }
-- 
1.6.0.6

