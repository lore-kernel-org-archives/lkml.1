Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbYC1LYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbYC1LYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYC1LY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:24:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44492 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbYC1LYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:24:25 -0400
Date: Fri, 28 Mar 2008 12:25:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: agpgart: when telling user you'll corrupt his data, at least do it
	at KERN_CRIT
Message-ID: <20080328112507.GA10774@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


IOMMU off means very bad stuff may happen, like data corruption on
your hard drives. At least tells users this is serious...

Plus, agp_amd64_init should go into .h file.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index faf3229..19e4f74 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -615,13 +615,11 @@ static __init int init_k8_gatt(struct ag
 
  nommu:
 	/* Should not happen anymore */
-	printk(KERN_ERR "PCI-DMA: More than 4GB of RAM and no IOMMU\n"
-	       KERN_ERR "PCI-DMA: 32bit PCI IO may malfunction.\n");
+	printk(KERN_CRIT "PCI-DMA: More than 4GB of RAM and no IOMMU\n"
+	       KERN_CRIT "PCI-DMA: 32bit PCI IO may malfunction.\n");
 	return -1;
 }
 
-extern int agp_amd64_init(void);
-
 static const struct dma_mapping_ops gart_dma_ops = {
 	.mapping_error			= NULL,
 	.map_single			= gart_map_single,
@@ -692,9 +690,9 @@ #endif
 	    !gart_iommu_aperture ||
 	    (no_agp && init_k8_gatt(&info) < 0)) {
 		if (end_pfn > MAX_DMA32_PFN) {
-			printk(KERN_ERR "WARNING more than 4GB of memory "
-					"but GART IOMMU not available.\n"
-			       KERN_ERR "WARNING 32bit PCI may malfunction.\n");
+			printk(KERN_CRIT "More than 4GB of memory "
+			       	          "but GART IOMMU not available.\n"
+			       KERN_CRIT "32bit PCI may malfunction.\n");
 		}
 		return;
 	}
diff --git a/include/asm-x86/agp.h b/include/asm-x86/agp.h
index e4004a9..657c25b 100644
--- a/include/asm-x86/agp.h
+++ b/include/asm-x86/agp.h
@@ -32,4 +32,7 @@ #define alloc_gatt_pages(order)		\
 #define free_gatt_pages(table, order)	\
 	free_pages((unsigned long)(table), (order))
 
+/* Only available in certain configs */
+extern int agp_amd64_init(void);
+
 #endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
