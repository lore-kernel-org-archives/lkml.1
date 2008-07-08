Return-Path: <linux-kernel-owner+w=401wt.eu-S1758700AbYGHRBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbYGHRBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbYGHQ56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:57:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:55151 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbYGHQ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:57:57 -0400
Date: Tue, 8 Jul 2008 09:51:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 11/17] Use WARN() in arch/x86/kernel
Message-ID: <20080708095156.6c769cfe@infradead.org>
In-Reply-To: <20080708093800.274504ba@infradead.org>
References: <20080708093800.274504ba@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Use WARN instead of printk+WARN_ON in arch/x86/kernel

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.
This also allowed the folding of some if()'s into the WARN()

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/kernel/cpu/mtrr/main.c  |    5 +----
 arch/x86/kernel/pci-calgary_64.c |    3 +--
 arch/x86/kernel/tsc_sync.c       |    6 ++----
 3 files changed, 4 insertions(+), 10 deletions(-)

Index: linux.trees.git/arch/x86/kernel/pci-calgary_64.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/pci-calgary_64.c
+++ linux.trees.git/arch/x86/kernel/pci-calgary_64.c
@@ -339,9 +339,8 @@ static void iommu_free(struct iommu_tabl
 	/* were we called with bad_dma_address? */
 	badend = bad_dma_address + (EMERGENCY_PAGES * PAGE_SIZE);
 	if (unlikely((dma_addr >= bad_dma_address) && (dma_addr < badend))) {
-		printk(KERN_ERR "Calgary: driver tried unmapping bad DMA "
+		WARN(1, KERN_ERR "Calgary: driver tried unmapping bad DMA "
 		       "address 0x%Lx\n", dma_addr);
-		WARN_ON(1);
 		return;
 	}
 
Index: linux.trees.git/arch/x86/kernel/tsc_sync.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/tsc_sync.c
+++ linux.trees.git/arch/x86/kernel/tsc_sync.c
@@ -88,11 +88,9 @@ static __cpuinit void check_tsc_warp(voi
 			__raw_spin_unlock(&sync_lock);
 		}
 	}
-	if (!(now-start)) {
-		printk("Warning: zero tsc calibration delta: %Ld [max: %Ld]\n",
+	WARN(!(now-start),
+		"Warning: zero tsc calibration delta: %Ld [max: %Ld]\n",
 			now-start, end-start);
-		WARN_ON(1);
-	}
 }
 
 /*
Index: linux.trees.git/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux.trees.git/arch/x86/kernel/cpu/mtrr/main.c
@@ -1496,11 +1496,8 @@ int __init mtrr_trim_uncached_memory(uns
 
 	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
 	if (!highest_pfn) {
-		if (!kvm_para_available()) {
-			printk(KERN_WARNING
+		WARN(!kvm_para_available(), KERN_WARNING
 				"WARNING: strange, CPU MTRRs all blank?\n");
-			WARN_ON(1);
-		}
 		return 0;
 	}
 
