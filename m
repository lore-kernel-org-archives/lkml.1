Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbYBWGRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbYBWGRM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 01:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYBWGPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 01:15:53 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:55464 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbYBWGPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 01:15:49 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 3/4] alpha: make IOMMU respect the segment boundary limits
Date: Sat, 23 Feb 2008 15:13:14 +0900
Message-Id: <1203747195-7952-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1203747195-7952-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1203747195-7952-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1203747195-7952-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1203747195-7952-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the IOMMU code not allocate a memory area spanning
LLD's segment boundary.

is_span_boundary() judges whether a memory area spans LLD's segment
boundary. If iommu_arena_find_pages() finds such a area, it tries to
find the next available memory area.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/alpha/kernel/pci_iommu.c |   40 ++++++++++++++++++++++++++++++++++------
 1 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index e54f829..54540c3 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -126,13 +126,34 @@ iommu_arena_new(struct pci_controller *hose, dma_addr_t base,
 	return iommu_arena_new_node(0, hose, base, window_size, align);
 }
 
+static inline int is_span_boundary(unsigned int index, unsigned int nr,
+				   unsigned long shift,
+				   unsigned long boundary_size)
+{
+	shift = (shift + index) & (boundary_size - 1);
+	return shift + nr > boundary_size;
+}
+
 /* Must be called with the arena lock held */
 static long
-iommu_arena_find_pages(struct pci_iommu_arena *arena, long n, long mask)
+iommu_arena_find_pages(struct device *dev, struct pci_iommu_arena *arena,
+		       long n, long mask)
 {
 	unsigned long *ptes;
 	long i, p, nent;
 	int pass = 0;
+	unsigned long base;
+	unsigned long boundary_size;
+
+	BUG_ON(arena->dma_base & ~PAGE_MASK);
+	base = arena->dma_base >> PAGE_SHIFT;
+	if (dev)
+		boundary_size = ALIGN(dma_get_max_seg_size(dev) + 1, PAGE_SIZE)
+			>> PAGE_SHIFT;
+	else
+		boundary_size = ALIGN(1UL << 32, PAGE_SIZE) >> PAGE_SHIFT;
+
+	BUG_ON(!is_power_of_2(boundary_size));
 
 	/* Search forward for the first mask-aligned sequence of N free ptes */
 	ptes = arena->ptes;
@@ -142,6 +163,11 @@ iommu_arena_find_pages(struct pci_iommu_arena *arena, long n, long mask)
 
 again:
 	while (i < n && p+i < nent) {
+		if (!i && is_span_boundary(p, n, base, boundary_size)) {
+			p = ALIGN(p + 1, mask + 1);
+			goto again;
+		}
+
 		if (ptes[p+i])
 			p = ALIGN(p + i + 1, mask + 1), i = 0;
 		else
@@ -170,7 +196,8 @@ again:
 }
 
 static long
-iommu_arena_alloc(struct pci_iommu_arena *arena, long n, unsigned int align)
+iommu_arena_alloc(struct device *dev, struct pci_iommu_arena *arena, long n,
+		  unsigned int align)
 {
 	unsigned long flags;
 	unsigned long *ptes;
@@ -181,7 +208,7 @@ iommu_arena_alloc(struct pci_iommu_arena *arena, long n, unsigned int align)
 	/* Search for N empty ptes */
 	ptes = arena->ptes;
 	mask = max(align, arena->align_entry) - 1;
-	p = iommu_arena_find_pages(arena, n, mask);
+	p = iommu_arena_find_pages(dev, arena, n, mask);
 	if (p < 0) {
 		spin_unlock_irqrestore(&arena->lock, flags);
 		return -1;
@@ -231,6 +258,7 @@ pci_map_single_1(struct pci_dev *pdev, void *cpu_addr, size_t size,
 	unsigned long paddr;
 	dma_addr_t ret;
 	unsigned int align = 0;
+	struct device *dev = pdev ? &pdev->dev : NULL;
 
 	paddr = __pa(cpu_addr);
 
@@ -278,7 +306,7 @@ pci_map_single_1(struct pci_dev *pdev, void *cpu_addr, size_t size,
 	/* Force allocation to 64KB boundary for ISA bridges. */
 	if (pdev && pdev == isa_bridge)
 		align = 8;
-	dma_ofs = iommu_arena_alloc(arena, npages, align);
+	dma_ofs = iommu_arena_alloc(dev, arena, npages, align);
 	if (dma_ofs < 0) {
 		printk(KERN_WARNING "pci_map_single failed: "
 		       "could not allocate dma page tables\n");
@@ -565,7 +593,7 @@ sg_fill(struct device *dev, struct scatterlist *leader, struct scatterlist *end,
 
 	paddr &= ~PAGE_MASK;
 	npages = calc_npages(paddr + size);
-	dma_ofs = iommu_arena_alloc(arena, npages, 0);
+	dma_ofs = iommu_arena_alloc(dev, arena, npages, 0);
 	if (dma_ofs < 0) {
 		/* If we attempted a direct map above but failed, die.  */
 		if (leader->dma_address == 0)
@@ -832,7 +860,7 @@ iommu_reserve(struct pci_iommu_arena *arena, long pg_count, long align_mask)
 
 	/* Search for N empty ptes.  */
 	ptes = arena->ptes;
-	p = iommu_arena_find_pages(arena, pg_count, align_mask);
+	p = iommu_arena_find_pages(NULL, arena, pg_count, align_mask);
 	if (p < 0) {
 		spin_unlock_irqrestore(&arena->lock, flags);
 		return -1;
-- 
1.5.3.4

