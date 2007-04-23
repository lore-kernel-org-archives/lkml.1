Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbXDWNvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbXDWNvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbXDWNvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:51:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40359 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752808AbXDWNvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:51:13 -0400
Date: Mon, 23 Apr 2007 14:54:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] sl82c105: Switch to ref counting API
Message-ID: <20070423145445.45f5dc6a@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure how this one got missed in the great purge some time ago but it
did. 

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/drivers/ide/pci/sl82c105.c linux-2.6.21-rc6-mm1/drivers/ide/pci/sl82c105.c
--- linux.vanilla-2.6.21-rc6-mm1/drivers/ide/pci/sl82c105.c	2007-04-12 14:15:04.000000000 +0100
+++ linux-2.6.21-rc6-mm1/drivers/ide/pci/sl82c105.c	2007-04-23 11:58:55.016516864 +0100
@@ -349,7 +349,7 @@
 	/*
 	 * The bridge should be part of the same device, but function 0.
 	 */
-	bridge = pci_find_slot(dev->bus->number,
+	bridge = pci_get_bus_and_slot(dev->bus->number,
 			       PCI_DEVFN(PCI_SLOT(dev->devfn), 0));
 	if (!bridge)
 		return -1;
@@ -359,13 +359,15 @@
 	 */
 	if (bridge->vendor != PCI_VENDOR_ID_WINBOND ||
 	    bridge->device != PCI_DEVICE_ID_WINBOND_83C553 ||
-	    bridge->class >> 8 != PCI_CLASS_BRIDGE_ISA)
+	    bridge->class >> 8 != PCI_CLASS_BRIDGE_ISA) {
+	    	pci_dev_put(bridge);
 		return -1;
-
+	}
 	/*
 	 * We need to find function 0's revision, not function 1
 	 */
 	pci_read_config_byte(bridge, PCI_REVISION_ID, &rev);
+	pci_dev_put(bridge);
 
 	return rev;
 }
