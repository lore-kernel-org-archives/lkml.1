Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbXDWNsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbXDWNsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXDWNsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:48:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57248 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752658AbXDWNsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:48:07 -0400
Date: Mon, 23 Apr 2007 14:51:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: davej@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] sworks-agp: Switch to PCI ref counting APIs
Message-ID: <20070423145129.1cfcd1f2@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/drivers/char/agp/sworks-agp.c linux-2.6.21-rc6-mm1/drivers/char/agp/sworks-agp.c
--- linux.vanilla-2.6.21-rc6-mm1/drivers/char/agp/sworks-agp.c	2007-04-12 14:15:03.000000000 +0100
+++ linux-2.6.21-rc6-mm1/drivers/char/agp/sworks-agp.c	2007-04-23 11:58:02.342524528 +0100
@@ -455,15 +455,6 @@
 	u32 temp, temp2;
 	u8 cap_ptr = 0;
 
-	/* Everything is on func 1 here so we are hardcoding function one */
-	bridge_dev = pci_find_slot((unsigned int)pdev->bus->number,
-			PCI_DEVFN(0, 1));
-	if (!bridge_dev) {
-		printk(KERN_INFO PFX "Detected a Serverworks chipset "
-		       "but could not find the secondary device.\n");
-		return -ENODEV;
-	}
-
 	cap_ptr = pci_find_capability(pdev, PCI_CAP_ID_AGP);
 
 	switch (pdev->device) {
@@ -483,6 +474,15 @@
 		return -ENODEV;
 	}
 
+	/* Everything is on func 1 here so we are hardcoding function one */
+	bridge_dev = pci_get_bus_and_slot((unsigned int)pdev->bus->number,
+			PCI_DEVFN(0, 1));
+	if (!bridge_dev) {
+		printk(KERN_INFO PFX "Detected a Serverworks chipset "
+		       "but could not find the secondary device.\n");
+		return -ENODEV;
+	}
+
 	serverworks_private.svrwrks_dev = bridge_dev;
 	serverworks_private.gart_addr_ofs = 0x10;
 
@@ -515,7 +515,7 @@
 
 	bridge->driver = &sworks_driver;
 	bridge->dev_private_data = &serverworks_private,
-	bridge->dev = pdev;
+	bridge->dev = pci_dev_get(pdev);
 
 	pci_set_drvdata(pdev, bridge);
 	return agp_add_bridge(bridge);
@@ -525,8 +525,11 @@
 {
 	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
 
+	pci_dev_put(bridge->dev);
 	agp_remove_bridge(bridge);
 	agp_put_bridge(bridge);
+	pci_dev_put(serverworks_private.svrwrks_dev)
+	serverworks_private.svrwrks_dev = NULL;
 }
 
 static struct pci_device_id agp_serverworks_pci_table[] = {
