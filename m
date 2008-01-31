Return-Path: <linux-kernel-owner+w=401wt.eu-S1765114AbYAaRih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765114AbYAaRih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbYAaRia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:38:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:50082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532AbYAaRi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:38:29 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: sdhci-devel@list.drzeus.cx
Subject: [PATCH] mmc: extend ricoh_mmc to support Ricoh RL5c476
Date: Thu, 31 Jan 2008 18:38:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Philip Langdale <philipl@overt.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801311838.24743.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <fseidel@suse.de>

This patch (based on current linus git tree) adds support for
the Ricoh RL5c476 chip: with this the mmc adapter that needs this
disabler (R5C843) can also be handled correctly when it sits
on a RL5c476.

Signed-off-by: Frank Seidel <fseidel@suse.de>
---
 drivers/mmc/host/ricoh_mmc.c |   91 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 75 insertions(+), 16 deletions(-)

--- a/drivers/mmc/host/ricoh_mmc.c
+++ b/drivers/mmc/host/ricoh_mmc.c
@@ -45,8 +45,10 @@ static int __devinit ricoh_mmc_probe(str
 				     const struct pci_device_id *ent)
 {
 	u8 rev;
+	u8 ctrlfound = 0;
 
 	struct pci_dev *fw_dev = NULL;
+	struct pci_dev *main_dev = NULL; /* for Ricoh RL5c476 II */
 
 	BUG_ON(pdev == NULL);
 	BUG_ON(ent == NULL);
@@ -58,7 +60,47 @@ static int __devinit ricoh_mmc_probe(str
 		pci_name(pdev), (int)pdev->vendor, (int)pdev->device,
 		(int)rev);
 
-	while ((fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
+	/* disable mmc controller via main function (RL5C476) */
+	while ((main_dev =
+		pci_get_device(PCI_VENDOR_ID_RICOH,
+				PCI_DEVICE_ID_RICOH_RL5C476, main_dev))) {
+		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(main_dev->devfn) &&
+		    pdev->bus == main_dev->bus) {
+			u8 write_enable;
+			u8 write_target;
+			u8 disable;
+
+			pci_read_config_byte(main_dev, 0xB7, &disable);
+			if (disable & 0x02) {
+				printk(KERN_INFO DRIVER_NAME
+					": Controller already disabled. " \
+					"Nothing to do.\n");
+				return -ENODEV;
+			}
+
+			pci_read_config_byte(main_dev, 0x8E, &write_enable);
+			pci_write_config_byte(main_dev, 0x8E, 0xAA);
+			pci_read_config_byte(main_dev, 0x8D, &write_target);
+			pci_write_config_byte(main_dev, 0x8D, 0xB7);
+			pci_write_config_byte(main_dev, 0xB7, disable | 0x02);
+			pci_write_config_byte(main_dev, 0x8E, write_enable);
+			pci_write_config_byte(main_dev, 0x8D, write_target);
+
+			pci_set_drvdata(pdev, main_dev);
+
+			printk(KERN_INFO DRIVER_NAME
+				": Controller is now disabled " \
+				"(via R5L5C476).\n");
+
+			ctrlfound = 1;
+			break;
+		}
+	}
+
+	/* disable mmc controller via firewire function (R5C832) */
+	while (!ctrlfound &&
+	    (fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH,
+					PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
 		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
 		    pdev->bus == fw_dev->bus) {
 			u8 write_enable;
@@ -67,7 +109,8 @@ static int __devinit ricoh_mmc_probe(str
 			pci_read_config_byte(fw_dev, 0xCB, &disable);
 			if (disable & 0x02) {
 				printk(KERN_INFO DRIVER_NAME
-				       ": Controller already disabled. Nothing to do.\n");
+					": Controller already disabled. " \
+					"Nothing to do.\n");
 				return -ENODEV;
 			}
 
@@ -79,15 +122,16 @@ static int __devinit ricoh_mmc_probe(str
 			pci_set_drvdata(pdev, fw_dev);
 
 			printk(KERN_INFO DRIVER_NAME
-			       ": Controller is now disabled.\n");
+			       ": Controller is now disabled (via R5C832).\n");
 
-			break;
+			ctrlfound = 1;
 		}
 	}
 
-	if (pci_get_drvdata(pdev) == NULL) {
+	if (!ctrlfound) {
 		printk(KERN_WARNING DRIVER_NAME
-		       ": Main firewire function not found. Cannot disable controller.\n");
+			": Needed function was not found. " \
+			"Cannot disable controller.\n");
 		return -ENODEV;
 	}
 
@@ -97,20 +141,35 @@ static int __devinit ricoh_mmc_probe(str
 static void __devexit ricoh_mmc_remove(struct pci_dev *pdev)
 {
 	u8 write_enable;
+	u8 write_target;
 	u8 disable;
-	struct pci_dev *fw_dev = NULL;
+	struct pci_dev *ctrl_dev = NULL;
 
-	fw_dev = pci_get_drvdata(pdev);
-	BUG_ON(fw_dev == NULL);
+	ctrl_dev = pci_get_drvdata(pdev);
+	BUG_ON(ctrl_dev == NULL);
 
-	pci_read_config_byte(fw_dev, 0xCA, &write_enable);
-	pci_read_config_byte(fw_dev, 0xCB, &disable);
-	pci_write_config_byte(fw_dev, 0xCA, 0x57);
-	pci_write_config_byte(fw_dev, 0xCB, disable & ~0x02);
-	pci_write_config_byte(fw_dev, 0xCA, write_enable);
+	if (ctrl_dev->device == PCI_DEVICE_ID_RICOH_RL5C476) {
+		pci_read_config_byte(ctrl_dev, 0x8E, &write_enable);
+		pci_write_config_byte(ctrl_dev, 0x8E, 0xAA);
+		pci_read_config_byte(ctrl_dev, 0x8D, &write_target);
+		pci_write_config_byte(ctrl_dev, 0x8D, 0xB7);
+		pci_read_config_byte(ctrl_dev, 0xB7, &disable);
+		pci_write_config_byte(ctrl_dev, 0xB7, disable & ~0x02);
+		pci_write_config_byte(ctrl_dev, 0x8E, write_enable);
+		pci_write_config_byte(ctrl_dev, 0x8D, write_target);
+
+		printk(KERN_INFO DRIVER_NAME
+			": Controller is now re-enabled (via R5L5C476).\n");
+	} else {
+		pci_read_config_byte(ctrl_dev, 0xCA, &write_enable);
+		pci_read_config_byte(ctrl_dev, 0xCB, &disable);
+		pci_write_config_byte(ctrl_dev, 0xCA, 0x57);
+		pci_write_config_byte(ctrl_dev, 0xCB, disable & ~0x02);
+		pci_write_config_byte(ctrl_dev, 0xCA, write_enable);
 
-	printk(KERN_INFO DRIVER_NAME
-	       ": Controller is now re-enabled.\n");
+		printk(KERN_INFO DRIVER_NAME
+			": Controller is now re-enabled (via R5C832).\n");
+	}
 
 	pci_set_drvdata(pdev, NULL);
 }
