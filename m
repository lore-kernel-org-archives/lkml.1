Return-Path: <linux-kernel-owner+w=401wt.eu-S1765478AbYB1T7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765478AbYB1T7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764670AbYB1Tyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:54:54 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60386 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862AbYB1Tyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:54:53 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 28 Feb 2008 20:54:43 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: add option for remote debugging
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Bernhard Kaindl <bk@suse.de>
Message-ID: <tkrat.66c379c72c01f7fa@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way firewire-ohci can be used for remote debugging like ohci1394.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 Documentation/debugging-via-ohci1394.txt |   13 ++++++++-----
 drivers/firewire/fw-ohci.c               |    9 +++++++++
 lib/Kconfig.debug                        |   10 ++++++++++
 3 files changed, 27 insertions(+), 5 deletions(-)

Index: linux/Documentation/debugging-via-ohci1394.txt
===================================================================
--- linux.orig/Documentation/debugging-via-ohci1394.txt
+++ linux/Documentation/debugging-via-ohci1394.txt
@@ -41,11 +41,14 @@ to a working state and enables physical 
 This can be turned off by ohci1394's module parameter phys_dma=0.
 
 The alternative firewire-ohci driver in drivers/firewire uses filtered physical
-DMA, hence is not yet suitable for remote debugging.
-
-Because ohci1394 depends on the PCI enumeration to be completed, an
-initialization routine which runs pretty early (long before console_init()
-which makes the printk buffer appear on the console can be called) was written.
+DMA by default, which is more secure but not suitable for remote debugging.
+Compile the driver with CONFIG_FIREWIRE_OHCI_REMOTE_DMA to get unfiltered
+physical DMA.
+
+Because ohci1394 and firewire-ohci depend on the PCI enumeration to be
+completed, an initialization routine which runs pretty early has been
+implemented for x86.  This routine runs long before console_init() can be
+called, i.e. before the printk buffer appears on the console.
 
 To activate it, enable CONFIG_PROVIDE_OHCI1394_DMA_INIT (Kernel hacking menu:
 Provide code for enabling DMA over FireWire early on boot) and pass the
Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -1091,6 +1091,11 @@ static void bus_reset_tasklet(unsigned l
 		reg_write(ohci, OHCI1394_ConfigROMhdr, ohci->next_header);
 	}
 
+#ifdef CONFIG_FIREWIRE_OHCI_REMOTE_DMA
+	reg_write(ohci, OHCI1394_PhyReqFilterHiSet, ~0);
+	reg_write(ohci, OHCI1394_PhyReqFilterLoSet, ~0);
+#endif
+
 	spin_unlock_irqrestore(&ohci->lock, flags);
 
 	if (free_rom)
@@ -1429,6 +1434,9 @@ static int ohci_cancel_packet(struct fw_
 static int
 ohci_enable_phys_dma(struct fw_card *card, int node_id, int generation)
 {
+#ifdef CONFIG_FIREWIRE_OHCI_REMOTE_DMA
+	return 0;
+#else
 	struct fw_ohci *ohci = fw_ohci(card);
 	unsigned long flags;
 	int n, retval = 0;
@@ -1460,6 +1468,7 @@ ohci_enable_phys_dma(struct fw_card *car
  out:
 	spin_unlock_irqrestore(&ohci->lock, flags);
 	return retval;
+#endif /* CONFIG_FIREWIRE_OHCI_REMOTE_DMA */
 }
 
 static u64
Index: linux/lib/Kconfig.debug
===================================================================
--- linux.orig/lib/Kconfig.debug
+++ linux/lib/Kconfig.debug
@@ -592,6 +592,16 @@ config LATENCYTOP
 	  Enable this option if you want to use the LatencyTOP tool
 	  to find out which userspace is blocking on what kernel operations.
 
+config FIREWIRE_OHCI_REMOTE_DMA
+	bool "Remote debugging via firewire-ohci"
+	depends on FIREWIRE_OHCI
+	help
+	  This option lets you use the FireWire bus for remote debugging.
+	  It enables unfiltered remote DMA in the firewire-ohci driver.
+	  See Documentation/debugging-via-ohci1394.txt for more information.
+
+	  If unsure, say N.
+
 config PROVIDE_OHCI1394_DMA_INIT
 	bool "Provide code for enabling DMA over FireWire early on boot"
 	depends on PCI && X86

-- 
Stefan Richter
-=====-==--- --=- ===--
http://arcgraph.de/sr/

