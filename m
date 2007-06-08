Return-Path: <linux-kernel-owner+w=401wt.eu-S939034AbXFHHxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939034AbXFHHxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938412AbXFHHZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:25:15 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55347 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967785AbXFHHZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:25:06 -0400
Message-Id: <20070608072238.896760000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:22:19 -0700
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
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 52/54] SPARC64: Dont be picky about virtual-dma values on sun4v.
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
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/pci_sun4v.c |   36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

--- linux-2.6.21.4.orig/arch/sparc64/kernel/pci_sun4v.c
+++ linux-2.6.21.4/arch/sparc64/kernel/pci_sun4v.c
@@ -12,6 +12,7 @@
 #include <linux/percpu.h>
 #include <linux/irq.h>
 #include <linux/msi.h>
+#include <linux/log2.h>
 
 #include <asm/pbm.h>
 #include <asm/iommu.h>
@@ -996,9 +997,8 @@ static void pci_sun4v_iommu_init(struct 
 {
 	struct pci_iommu *iommu = pbm->iommu;
 	struct property *prop;
-	unsigned long num_tsb_entries, sz;
+	unsigned long num_tsb_entries, sz, tsbsize;
 	u32 vdma[2], dma_mask, dma_offset;
-	int tsbsize;
 
 	prop = of_find_property(pbm->prom_node, "virtual-dma", NULL);
 	if (prop) {
@@ -1012,31 +1012,15 @@ static void pci_sun4v_iommu_init(struct 
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
 
@@ -1047,7 +1031,7 @@ static void pci_sun4v_iommu_init(struct 
 	iommu->dma_addr_mask = dma_mask;
 
 	/* Allocate and initialize the free area map.  */
-	sz = num_tsb_entries / 8;
+	sz = (num_tsb_entries + 7) / 8;
 	sz = (sz + 7UL) & ~7UL;
 	iommu->arena.map = kzalloc(sz, GFP_KERNEL);
 	if (!iommu->arena.map) {

-- 
