Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbZHJIsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbZHJIsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZHJIsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:48:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:46695 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZHJIsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:48:18 -0400
Date: Mon, 10 Aug 2009 08:47:30 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, reif@earthlink.net,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, reif@earthlink.net,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249872797-1314-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1249872797-1314-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Subject: [tip:core/iommu] sparc: Replace sbus_map_single and sbus_unmap_single with sbus_map_page and sbus_unmap_page
Message-ID: <tip-c2c07dbd8742a26ab3f1ee8b82237a060a0d9f61@git.kernel.org>
Git-Commit-ID: c2c07dbd8742a26ab3f1ee8b82237a060a0d9f61
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Aug 2009 08:47:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2c07dbd8742a26ab3f1ee8b82237a060a0d9f61
Gitweb:     http://git.kernel.org/tip/c2c07dbd8742a26ab3f1ee8b82237a060a0d9f61
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Mon, 10 Aug 2009 11:53:15 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 Aug 2009 09:35:00 +0200

sparc: Replace sbus_map_single and sbus_unmap_single with sbus_map_page and sbus_unmap_page

This is a preparation for using asm-generic/pci-dma-compat.h;
SPARC32 has two dma_map_ops structures for pci and sbus
(removing arch/sparc/kernel/dma.c, PCI and SBUS DMA accessor).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Robert Reif <reif@earthlink.net>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: tony.luck@intel.com
Cc: fenghua.yu@intel.com
LKML-Reference: <1249872797-1314-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
