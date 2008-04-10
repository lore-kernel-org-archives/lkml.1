Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYDJTG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYDJTG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYDJTGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:06:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51788 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbYDJTGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:06:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 10 Apr 2008 21:05:47 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH linux1394-2.6.git] firewire: fw-ohci: add option for remote
 debugging - amendment
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Bernhard Kaindl <bk@suse.de>
In-Reply-To: <20080410095112.GB12543@elte.hu>
Message-ID: <tkrat.88330c779367ee9d@s5r6.in-berlin.de>
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au>
 <47FCF50E.9090703@s5r6.in-berlin.de> <20080410065227.GB30066@elte.hu>
 <20080410174418.ebfe76c3.sfr@canb.auug.org.au>
 <tkrat.991b1750a56cf2e9@s5r6.in-berlin.de> <20080410095112.GB12543@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some afterthoughts:

  - Tell where the Kconfig prompt is in debugging-via-ohci1394.txt.

  - Open the physical DMA filter in the top half of the IRQ handler
    and flush the necessary MMIO writes.  This is to open the filter
    as soon as possible after bus reset.

  - Move the Kconfig prompt below the existing early debugging option.
    Seems more logical after all, because that one is for early use
    and this one for subsequent use.

  - Reword the existing early debugging option to state what it is for
    rather than how it works internally.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

This could be merged into patch "firewire: fw-ohci: add option for
remote debugging" before it is submitted to mainline.

 Documentation/debugging-via-ohci1394.txt |    9 +++++----
 drivers/firewire/fw-ohci.c               |   13 +++++++------
 lib/Kconfig.debug                        |   23 ++++++++++++-----------
 3 files changed, 24 insertions(+), 21 deletions(-)

Index: linux/Documentation/debugging-via-ohci1394.txt
===================================================================
--- linux.orig/Documentation/debugging-via-ohci1394.txt
+++ linux/Documentation/debugging-via-ohci1394.txt
@@ -42,8 +42,9 @@ This can be turned off by ohci1394's mod
 
 The alternative firewire-ohci driver in drivers/firewire uses filtered physical
 DMA by default, which is more secure but not suitable for remote debugging.
-Compile the driver with CONFIG_FIREWIRE_OHCI_REMOTE_DMA to get unfiltered
-physical DMA.
+Compile the driver with CONFIG_FIREWIRE_OHCI_REMOTE_DMA (Kernel hacking menu:
+Remote debugging over FireWire with firewire-ohci) to get unfiltered physical
+DMA.
 
 Because ohci1394 and firewire-ohci depend on the PCI enumeration to be
 completed, an initialization routine which runs pretty early has been
@@ -51,8 +52,8 @@ implemented for x86.  This routine runs 
 called, i.e. before the printk buffer appears on the console.
 
 To activate it, enable CONFIG_PROVIDE_OHCI1394_DMA_INIT (Kernel hacking menu:
-Provide code for enabling DMA over FireWire early on boot) and pass the
-parameter "ohci1394_dma=early" to the recompiled kernel on boot.
+Remote debugging over FireWire early on boot) and pass the parameter
+"ohci1394_dma=early" to the recompiled kernel on boot.
 
 Tools
 -----
Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -1309,11 +1309,6 @@ static void bus_reset_tasklet(unsigned l
 		reg_write(ohci, OHCI1394_ConfigROMhdr, ohci->next_header);
 	}
 
-#ifdef CONFIG_FIREWIRE_OHCI_REMOTE_DMA
-	reg_write(ohci, OHCI1394_PhyReqFilterHiSet, ~0);
-	reg_write(ohci, OHCI1394_PhyReqFilterLoSet, ~0);
-#endif
-
 	spin_unlock_irqrestore(&ohci->lock, flags);
 
 	if (free_rom)
@@ -1341,8 +1336,14 @@ static irqreturn_t irq_handler(int irq, 
 	reg_write(ohci, OHCI1394_IntEventClear, event & ~OHCI1394_busReset);
 	log_irqs(event);
 
-	if (event & OHCI1394_selfIDComplete)
+	if (event & OHCI1394_selfIDComplete) {
+#ifdef CONFIG_FIREWIRE_OHCI_REMOTE_DMA
+		reg_write(ohci, OHCI1394_PhyReqFilterHiSet, ~0);
+		reg_write(ohci, OHCI1394_PhyReqFilterLoSet, ~0);
+		flush_writes(ohci);
+#endif
 		tasklet_schedule(&ohci->bus_reset_tasklet);
+	}
 
 	if (event & OHCI1394_RQPkt)
 		tasklet_schedule(&ohci->ar_request_ctx.tasklet);
Index: linux/lib/Kconfig.debug
===================================================================
--- linux.orig/lib/Kconfig.debug
+++ linux/lib/Kconfig.debug
@@ -592,18 +592,8 @@ config LATENCYTOP
 	  Enable this option if you want to use the LatencyTOP tool
 	  to find out which userspace is blocking on what kernel operations.
 
-config FIREWIRE_OHCI_REMOTE_DMA
-	bool "Remote debugging via firewire-ohci"
-	depends on FIREWIRE_OHCI
-	help
-	  This option lets you use the FireWire bus for remote debugging.
-	  It enables unfiltered remote DMA in the firewire-ohci driver.
-	  See Documentation/debugging-via-ohci1394.txt for more information.
-
-	  If unsure, say N.
-
 config PROVIDE_OHCI1394_DMA_INIT
-	bool "Provide code for enabling DMA over FireWire early on boot"
+	bool "Remote debugging over FireWire early on boot"
 	depends on PCI && X86
 	help
 	  If you want to debug problems which hang or crash the kernel early
@@ -631,4 +621,15 @@ config PROVIDE_OHCI1394_DMA_INIT
 
 	  See Documentation/debugging-via-ohci1394.txt for more information.
 
+config FIREWIRE_OHCI_REMOTE_DMA
+	bool "Remote debugging over FireWire with firewire-ohci"
+	depends on FIREWIRE_OHCI
+	help
+	  This option lets you use the FireWire bus for remote debugging
+	  with help of the firewire-ohci driver. It enables unfiltered
+	  remote DMA in firewire-ohci.
+	  See Documentation/debugging-via-ohci1394.txt for more information.
+
+	  If unsure, say N.
+
 source "samples/Kconfig"

-- 
Stefan Richter
-=====-==--- -=-- -=-=-
http://arcgraph.de/sr/


