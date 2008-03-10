Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbYCJOfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbYCJOfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 10:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYCJOfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 10:35:08 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:49870 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbYCJOfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 10:35:07 -0400
Date: Mon, 10 Mar 2008 23:34:53 +0900
To: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Cc: akpm@linux-foundation.org, rth@twiddle.net, ink@jurassic.park.msu.ru
Cc: tomof@acm.org
Subject: [PATCH -mm] alpha: use iommu_is_span_boundary helper function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080310231010H.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against the current git.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH -mm] alpha: use iommu_is_span_boundary helper function

iommu_is_span_boundary in lib/iommu-helper.c was exported for PARISC
IOMMUs (commit 3715863aa142c4f4c5208f5f3e5e9bac06006d2f). Alpha's
IOMMU can use it.

This removes the check on the boundary size alignment because
iommu_is_span_boundary does.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/alpha/Kconfig            |    3 +++
 arch/alpha/kernel/pci_iommu.c |   12 ++----------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 002703b..729cdbd 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -330,6 +330,9 @@ config PCI_DOMAINS
 config PCI_SYSCALL
 	def_bool PCI
 
+config IOMMU_HELPER
+	def_bool PCI
+
 config ALPHA_CORE_AGP
 	bool
 	depends on ALPHA_GENERIC || ALPHA_TITAN || ALPHA_MARVEL
diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index e07a23f..4e1c086 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -10,6 +10,7 @@
 #include <linux/scatterlist.h>
 #include <linux/log2.h>
 #include <linux/dma-mapping.h>
+#include <linux/iommu-helper.h>
 
 #include <asm/io.h>
 #include <asm/hwrpb.h>
@@ -125,14 +126,6 @@ iommu_arena_new(struct pci_controller *hose, dma_addr_t base,
 	return iommu_arena_new_node(0, hose, base, window_size, align);
 }
 
-static inline int is_span_boundary(unsigned int index, unsigned int nr,
-				   unsigned long shift,
-				   unsigned long boundary_size)
-{
-	shift = (shift + index) & (boundary_size - 1);
-	return shift + nr > boundary_size;
-}
-
 /* Must be called with the arena lock held */
 static long
 iommu_arena_find_pages(struct device *dev, struct pci_iommu_arena *arena,
@@ -147,7 +140,6 @@ iommu_arena_find_pages(struct device *dev, struct pci_iommu_arena *arena,
 	base = arena->dma_base >> PAGE_SHIFT;
 	if (dev) {
 		boundary_size = dma_get_seg_boundary(dev) + 1;
-		BUG_ON(!is_power_of_2(boundary_size));
 		boundary_size >>= PAGE_SHIFT;
 	} else {
 		boundary_size = 1UL << (32 - PAGE_SHIFT);
@@ -161,7 +153,7 @@ iommu_arena_find_pages(struct device *dev, struct pci_iommu_arena *arena,
 
 again:
 	while (i < n && p+i < nent) {
-		if (!i && is_span_boundary(p, n, base, boundary_size)) {
+		if (!i && iommu_is_span_boundary(p, n, base, boundary_size)) {
 			p = ALIGN(p + 1, mask + 1);
 			goto again;
 		}
-- 
1.5.3.7

