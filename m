Return-Path: <linux-kernel-owner+w=401wt.eu-S967975AbXFHH2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967975AbXFHH2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965698AbXFHHS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:18:56 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:57586 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965469AbXFHHSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:18:54 -0400
Message-Id: <20070608071559.804884000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:43 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de
Subject: [patch 32/32] SPARC64: Dont be picky about virtual-dma values on sun4v.
Content-Disposition: inline; filename=sparc64-don-t-be-picky-about-virtual-dma-values-on-sun4v.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David Miller <davem@davemloft.net>

Handle arbitrary base and length values as long as they
are multiples of IO_PAGE_SIZE.

Bug found by Arun Kumar Rao.

Signed-off-by: David S. Miller <davem@davemloft.net>
[chrisw: backport to 2.6.20]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 arch/sparc64/kernel/pci_sun4v.c |   36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

--- linux-2.6.20.13.orig/arch/sparc64/kernel/pci_sun4v.c
+++ linux-2.6.20.13/arch/sparc64/kernel/pci_sun4v.c
@@ -10,6 +10,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/percpu.h>
+#include <linux/log2.h>
 
 #include <asm/pbm.h>
 #include <asm/iommu.h>
@@ -994,9 +995,8 @@ static void pci_sun4v_iommu_init(struct 
 {
 	struct pci_iommu *iommu = pbm->iommu;
 	struct property *prop;
-	unsigned long num_tsb_entries, sz;
+	unsigned long num_tsb_entries, sz, tsbsize;
 	u32 vdma[2], dma_mask, dma_offset;
-	int tsbsize;
 
 	prop = of_find_property(pbm->prom_node, "virtual-dma", NULL);
 	if (prop) {
@@ -1010,31 +1010,15 @@ static void pci_sun4v_iommu_init(struct 
 		vdma[1] = 0x80000000;
 	}
 
-	dma_mask = vdma[0];
-	switch (vdma[1]) {
-		case 0x20000000:
-			dma_mask |= 0x1fffffff;
-			tsbsize = 64;
-			break;
-
-		case 0x40000000:
-			dma_mask |= 0x3fffffff;
-			tsbsize = 128;
-			break;
-
-		case 0x80000000:
-			dma_mask |= 0x7fffffff;
-			tsbsize = 256;
-			break;
-
-		default:
-			prom_printf("PCI-SUN4V: strange virtual-dma size.\n");
-			prom_halt();
+	if ((vdma[0] | vdma[1]) & ~IO_PAGE_MASK) {
+		prom_printf("PCI-SUN4V: strange virtual-dma[%08x:%08x].\n",
+			    vdma[0], vdma[1]);
+		prom_halt();
 	};
 
-	tsbsize *= (8 * 1024);
-
-	num_tsb_entries = tsbsize / sizeof(iopte_t);
+	dma_mask = (roundup_pow_of_two(vdma[1]) - 1UL);
+	num_tsb_entries = vdma[1] / IO_PAGE_SIZE;
+	tsbsize = num_tsb_entries * sizeof(iopte_t);
 
 	dma_offset = vdma[0];
 
@@ -1045,7 +1029,7 @@ static void pci_sun4v_iommu_init(struct 
 	iommu->dma_addr_mask = dma_mask;
 
 	/* Allocate and initialize the free area map.  */
-	sz = num_tsb_entries / 8;
+	sz = (num_tsb_entries + 7) / 8;
 	sz = (sz + 7UL) & ~7UL;
 	iommu->arena.map = kzalloc(sz, GFP_KERNEL);
 	if (!iommu->arena.map) {

-- 
