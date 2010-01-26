Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195Ab0AZUjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab0AZUjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 15:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889Ab0AZUjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 15:39:25 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57536 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab0AZUjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 15:39:24 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 26 Jan 2010 21:39:07 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: ohci: fix crashes with TSB43AB23 on 64bit systems
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.9cd039404ec3bf0c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unsurprisingly, Texas Instruments TSB43AB23 exhibits the same behaviour
as TSB43AB22/A in dual buffer IR DMA mode:  If descriptors are located
at physical addresses above the 31 bit address range (2 GB), the
controller will overwrite random memory.  With luck, this merely
prevents video reception.  With only a little less luck, the machine
crashes.

We use the same workaround here as with TSB43AB22/A:  Switch off the
dual buffer capability flag and use packet-per-buffer IR DMA instead.
Another possible workaround would be to limit the coherent DMA mask to
31 bits.

In Linux 2.6.33, this change serves effectively only as documentation
since dual buffer mode is not used for any controller anymore.  But
somebody might want to re-enable it in the future to make use of
features of dual buffer DMA that are not available in packet-per-buffer
mode.

In Linux 2.6.32 and older, this update is vital for anyone with this
controller, more than 2 GB RAM, a 64 bit kernel, and FireWire video or
audio applications.

We have at least four reports:
http://bugzilla.kernel.org/show_bug.cgi?id=13808
http://marc.info/?l=linux1394-user&m=126154279004083
https://bugzilla.redhat.com/show_bug.cgi?id=552142
http://marc.info/?l=linux1394-user&m=126432246128386

Reported-by: Paul Johnson
Reported-by: Ronneil Camara
Reported-by: G Zornetzer
Reported-by: Mark Thompson
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/drivers/firewire/ohci.c
===================================================================
--- linux.orig/drivers/firewire/ohci.c
+++ linux/drivers/firewire/ohci.c
@@ -2420,6 +2420,7 @@ static void ohci_pmac_off(struct pci_dev
 
 #define PCI_VENDOR_ID_AGERE		PCI_VENDOR_ID_ATT
 #define PCI_DEVICE_ID_AGERE_FW643	0x5901
+#define PCI_DEVICE_ID_TI_TSB43AB23	0x8024
 
 static int __devinit pci_probe(struct pci_dev *dev,
 			       const struct pci_device_id *ent)
@@ -2488,7 +2489,8 @@ static int __devinit pci_probe(struct pc
 #if !defined(CONFIG_X86_32)
 	/* dual-buffer mode is broken with descriptor addresses above 2G */
 	if (dev->vendor == PCI_VENDOR_ID_TI &&
-	    dev->device == PCI_DEVICE_ID_TI_TSB43AB22)
+	    (dev->device == PCI_DEVICE_ID_TI_TSB43AB22 ||
+	     dev->device == PCI_DEVICE_ID_TI_TSB43AB23))
 		ohci->use_dualbuffer = false;
 #endif
 

-- 
Stefan Richter
-=====-==-=- ---= ==-=-
http://arcgraph.de/sr/

