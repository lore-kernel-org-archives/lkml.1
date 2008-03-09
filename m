Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbYCINb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbYCINb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 09:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYCINbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 09:31:21 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:35376 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbYCINbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 09:31:21 -0400
Date: Sun, 9 Mar 2008 16:31:17 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, FUJITA Tomonori <tomof@acm.org>,
       rct@frus.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: fix iommu-related boot panic
Message-ID: <20080309133117.GB757@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix boot panic due to a typo in the recent iommu patchset from
FUJITA Tomonori <tomof@acm.org> - dma_get_max_seg_size()
instead of dma_get_seg_boundary().
This also removes a couple of unnecessary BUG_ON() and ALIGN() macros.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Reported-and-tested-by: Bob Tracy <rct@frus.com>
Acked-by: FUJITA Tomonori <tomof@acm.org>

Ivan.

---
 arch/alpha/kernel/pci_iommu.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index be6fa10..e07a23f 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -144,15 +144,14 @@ iommu_arena_find_pages(struct device *dev, struct pci_iommu_arena *arena,
 	unsigned long base;
 	unsigned long boundary_size;
 
-	BUG_ON(arena->dma_base & ~PAGE_MASK);
 	base = arena->dma_base >> PAGE_SHIFT;
-	if (dev)
-		boundary_size = ALIGN(dma_get_max_seg_size(dev) + 1, PAGE_SIZE)
-			>> PAGE_SHIFT;
-	else
-		boundary_size = ALIGN(1UL << 32, PAGE_SIZE) >> PAGE_SHIFT;
-
-	BUG_ON(!is_power_of_2(boundary_size));
+	if (dev) {
+		boundary_size = dma_get_seg_boundary(dev) + 1;
+		BUG_ON(!is_power_of_2(boundary_size));
+		boundary_size >>= PAGE_SHIFT;
+	} else {
+		boundary_size = 1UL << (32 - PAGE_SHIFT);
+	}
 
 	/* Search forward for the first mask-aligned sequence of N free ptes */
 	ptes = arena->ptes;
