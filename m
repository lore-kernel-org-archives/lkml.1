Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbZH1LZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbZH1LZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 07:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZH1LZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 07:25:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56170 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZH1LZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 07:25:36 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 28 Aug 2009 13:25:15 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/2] firewire: ohci: fix Agere FW643 and multiple cameras
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Samuel Audet <samuel.audet@gmail.com>,
       Jonathan Cameron <jic23@cam.ac.uk>
Message-ID: <tkrat.9dcf6c9a7dfd35fd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: 
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: ohci: fix Agere FW643 and multiple cameras

An Agere FW643 OHCI 1.1 card works fine for video reception from one
camera but fails early if receiving from two cameras.  After a short
while, no IR IRQ events occur and the context control register does not
react anymore.  This happens regardless whether both IR DMA contexts are
dual-buffer or one is dual-buffer and the other packet-per-buffer.

This can be worked around by disabling dual buffer DMA mode entirely.
http://sourceforge.net/mailarchive/message.php?msg_name=4A7C0594.2020208%40gmail.com

Reported-by: Samuel Audet <samuel.audet@gmail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.31-rc8/drivers/firewire/ohci.c
===================================================================
--- linux-2.6.31-rc8.orig/drivers/firewire/ohci.c
+++ linux-2.6.31-rc8/drivers/firewire/ohci.c
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/pci.h>
+#include <linux/pci_ids.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
 
@@ -2372,6 +2373,9 @@ static void ohci_pmac_off(struct pci_dev
 #define ohci_pmac_off(dev)
 #endif /* CONFIG_PPC_PMAC */
 
+#define PCI_VENDOR_ID_AGERE		PCI_VENDOR_ID_ATT
+#define PCI_DEVICE_ID_AGERE_FW643	0x5901
+
 static int __devinit pci_probe(struct pci_dev *dev,
 			       const struct pci_device_id *ent)
 {
@@ -2422,6 +2426,11 @@ static int __devinit pci_probe(struct pc
 	version = reg_read(ohci, OHCI1394_Version) & 0x00ff00ff;
 	ohci->use_dualbuffer = version >= OHCI_VERSION_1_1;
 
+	/* dual-buffer mode is broken if more than one IR context is active */
+	if (dev->vendor == PCI_VENDOR_ID_AGERE &&
+	    dev->device == PCI_DEVICE_ID_AGERE_FW643)
+		ohci->use_dualbuffer = false;
+
 /* x86-32 currently doesn't use highmem for dma_alloc_coherent */
 #if !defined(CONFIG_X86_32)
 	/* dual-buffer mode is broken with descriptor addresses above 2G */

-- 
Stefan Richter
-=====-==--= =--- ===--
http://arcgraph.de/sr/

