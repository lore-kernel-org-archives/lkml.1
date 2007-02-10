Return-Path: <linux-kernel-owner+w=401wt.eu-S1751602AbXBJNnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbXBJNnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 08:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbXBJNnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 08:43:52 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:62938 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbXBJNnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 08:43:51 -0500
Date: Sat, 10 Feb 2007 15:43:48 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: [discuss] What will be in the x86-64/x86 2.6.21 merge
Message-ID: <20070210134348.GB18296@rhun.ibm.com>
References: <200702101242.48467.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702101242.48467.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 12:42:48PM +0100, Andi Kleen wrote:
> 
> I will post the existing patches in batches for closer review.
> 
> Can be already all viewed at
> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/

Andi, please make sure to also include this Calgary patch I sent on
Feb 6th.

Thanks,
Muli

Subject: x86-64 Calgary: robustify bad_dma_address handling
From: Muli Ben-Yehuda <muli@il.ibm.com>

- set bad_dma_address explicitly to 0x0
- reserve 32 pages from bad_dma_address and up
- WARN_ON() a driver feeding us bad_dma_address

Thanks to Leo Duran <leo.duran@amd.com> for the suggestion.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Leo Duran <leo.duran@amd.com>
Cc: Job Mason <jdmason@kudzu.us>
---
 arch/x86_64/kernel/pci-calgary.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 3d65b1d..04480c3 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -138,6 +138,8 @@ static const unsigned long phb_debug_off
 
 #define PHB_DEBUG_STUFF_OFFSET	0x0020
 
+#define EMERGENCY_PAGES 32 /* = 128KB */
+
 unsigned int specified_table_size = TCE_TABLE_SIZE_UNSPECIFIED;
 static int translate_empty_slots __read_mostly = 0;
 static int calgary_detected __read_mostly = 0;
@@ -296,6 +298,16 @@ static void __iommu_free(struct iommu_ta
 {
 	unsigned long entry;
 	unsigned long badbit;
+	unsigned long badend;
+
+	/* were we called with bad_dma_address? */
+	badend = bad_dma_address + (EMERGENCY_PAGES * PAGE_SIZE);
+	if (unlikely((dma_addr >= bad_dma_address) && (dma_addr < badend))) {
+		printk(KERN_ERR "Calgary: driver tried unmapping bad DMA "
+		       "address 0x%Lx\n", dma_addr);
+		WARN_ON(1);
+		return;
+	}
 
 	entry = dma_addr >> PAGE_SHIFT;
 
@@ -656,8 +668,8 @@ static void __init calgary_reserve_regio
 	u64 start;
 	struct iommu_table *tbl = dev->sysdata;
 
-	/* reserve bad_dma_address in case it's a legal address */
-	iommu_range_reserve(tbl, bad_dma_address, 1);
+	/* reserve EMERGENCY_PAGES from bad_dma_address and up */
+	iommu_range_reserve(tbl, bad_dma_address, EMERGENCY_PAGES);
 
 	/* avoid the BIOS/VGA first 640KB-1MB region */
 	start = (640 * 1024);
@@ -1176,6 +1188,7 @@ int __init calgary_iommu_init(void)
 	}
 
 	force_iommu = 1;
+	bad_dma_address = 0x0;
 	dma_ops = &calgary_dma_ops;
 
 	return 0;
-- 
1.4.1
