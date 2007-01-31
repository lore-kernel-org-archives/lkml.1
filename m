Return-Path: <linux-kernel-owner+w=401wt.eu-S1030297AbXAaRIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030297AbXAaRIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030298AbXAaRIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:08:04 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55441 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030299AbXAaRIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:08:02 -0500
Date: Wed, 31 Jan 2007 17:20:15 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: takada@mbf.nifty.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: PATCH] cyrix: fails to detect MediaGX
Message-ID: <20070131172015.7ea31dc8@localhost.localdomain>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The old Cyrix 5520 CPU detection code relied upon the PCI layer setup
being done earlier than the CPU setup, which is no longer true.
Fortunately we know that if the processor is a MediaGX we can do type 1
pci config accesses to check the companion chip. We thus do those
directly and from this find the 5520 and implement the workarounds for
the timer problem

Original report from takada@mbf.nifty.com, I sent a proposed patch which
Takara then corrected, tested and sent back to the list on 10th January.

Submitting for merging as it seems to have been missed

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/arch/i386/kernel/cpu/cyrix.c linux-2.6.20-rc6-mm3/arch/i386/kernel/cpu/cyrix.c
--- linux.vanilla-2.6.20-rc6-mm3/arch/i386/kernel/cpu/cyrix.c	2007-01-31 14:20:38.000000000 +0000
+++ linux-2.6.20-rc6-mm3/arch/i386/kernel/cpu/cyrix.c	2007-01-31 14:24:47.000000000 +0000
@@ -8,6 +8,7 @@
 #include <asm/timer.h>
 
 #include "cpu.h"
+#include "../../pci/pci.h"
 
 /*
  * Read NSC/Cyrix DEVID registers (DIR) to get more detailed info. about the CPU
@@ -183,19 +184,12 @@
 }
 
 
-#ifdef CONFIG_PCI
-static struct pci_device_id __cpuinitdata cyrix_55x0[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5510) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5520) },
-	{ },
-};
-#endif
-
 static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 {
 	unsigned char dir0, dir0_msn, dir0_lsn, dir1 = 0;
 	char *buf = c->x86_model_id;
 	const char *p = NULL;
+	u32 vendor, device;
 
 	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
 	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
@@ -273,11 +267,16 @@
 		printk(KERN_INFO "Working around Cyrix MediaGX virtual DMA bugs.\n");
 		isa_dma_bridge_buggy = 2;
 
+		/* We do this before the PCI layer is running. However we 
+		   are safe here as we know the bridge must be a Cyrix 
+		   companion and must be present */
+		pci_conf1_read(0, 0, PCI_DEVFN(0x12, 0), PCI_VENDOR_ID, 2, &vendor);
+		pci_conf1_read(0, 0, PCI_DEVFN(0x12, 0), PCI_DEVICE_ID, 2, &device);
 
 		/*
 		 *  The 5510/5520 companion chips have a funky PIT.
 		 */  
-		if (pci_dev_present(cyrix_55x0))
+		if (vendor == PCI_VENDOR_ID_CYRIX && (device == PCI_DEVICE_ID_CYRIX_5510 || device == PCI_DEVICE_ID_CYRIX_5520))
 			pit_latch_buggy = 1;
 #endif
 		c->x86_cache_size=16;	/* Yep 16K integrated cache thats it */
