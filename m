Return-Path: <linux-kernel-owner+w=401wt.eu-S1751680AbXLAIqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbXLAIqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 03:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbXLAIql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 03:46:41 -0500
Received: from mail.luban.org ([69.60.116.119]:36015 "EHLO mail.luban.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbXLAIqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 03:46:40 -0500
X-Greylist: delayed 1155 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Dec 2007 03:46:40 EST
Message-ID: <47511ADA.20506@luban.org>
Date: Sat, 01 Dec 2007 00:27:06 -0800
From: Vitaly Luban <vitaly@luban.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.2) Gecko/20040805 Netscape/7.2
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Pierre Ossman <drzeus@drzeus.cx>, Vitaly Luban <vitaly@luban.org>
Subject: [PATCH] Tokyo Electron SDIO controller (Ellen) support
Content-Type: multipart/mixed;
 boundary="------------080801090800090004010805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080801090800090004010805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Kernel "pci_ids.h" file has data for that card missing.

Also, Ellen needs some control bits flipped before it functions properly 
as SDIO controller by the spec.
Should apply clenly to Linus and Drzeus trees. Please apply.

Signed-off-by:  Vitaly Luban <vitaly@luban.org>



--------------080801090800090004010805
Content-Type: text/plain;
 name="ellen.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ellen.patch"

--- drzeus/drivers/mmc/host/sdhci.c	2007-11-27 19:51:35.000000000 -0800
+++ linux-2.6.23/drivers/mmc/host/sdhci.c	2007-11-30 18:43:02.000000000 -0800
@@ -97,6 +99,13 @@
 				  SDHCI_QUIRK_RESET_CMD_DATA_ON_IOS,
 	},
 
+        {
+                .vendor         = PCI_VENDOR_ID_TOKYO_ELECTRON,
+                .device         = PCI_DEVICE_ID_ELLEN,
+                .subvendor      = PCI_ANY_ID,
+                .subdevice      = PCI_ANY_ID,
+        },
+
 	{	/* Generic SD host controller */
 		PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8), 0xFFFF00)
 	},
@@ -1205,10 +1214,43 @@
  *                                                                           *
 \*****************************************************************************/
 
+static int __devinit sdhci_ellen_init(struct pci_dev *pdev)
+{
+	int                 ret;
+	unsigned int        config;
+	void __iomem *      ioaddr;
+	 
+	if (pci_resource_flags(pdev, 0) & PCI_BASE_ADDRESS_SPACE)
+		return -ENOMEM;
+	
+	ret = pci_request_region(pdev, 0, "EllenPCI");
+	if (ret)
+		return -ENOMEM;
+	
+	ioaddr = ioremap_nocache(pci_resource_start(pdev, 0), 
+	                         pci_resource_len(pdev, 0));
+	if (!ioaddr) {
+		ret = -ENOMEM;
+		goto release;
+	}
+	
+	/* Do some magic passes to enable Ellen PCI interrupts */
+	config = readw(ioaddr + 0x4c);
+	config |= (1) | (1<<3) | (1<<6);
+	writew(config, ioaddr + 0x4c);
+	/* Retire last write by read */
+	config = readw(ioaddr + 0x4c);
+	
+	iounmap(ioaddr);
+release:
+	pci_release_region(pdev, 0);
+	return ret;
+}
+
 static int __devinit sdhci_probe_slot(struct pci_dev *pdev, int slot)
 {
 	int ret;
-	unsigned int version;
+	unsigned int version, temp, iomemsize;
 	struct sdhci_chip *chip;
 	struct mmc_host *mmc;
 	struct sdhci_host *host;
@@ -1225,6 +1267,15 @@
 
 	first_bar &= PCI_SLOT_INFO_FIRST_BAR_MASK;
 
+	if ((pdev->vendor == PCI_VENDOR_ID_TOKYO_ELECTRON) &&
+	    (pdev->device == PCI_DEVICE_ID_ELLEN)) {
+		first_bar = 2;
+		iomemsize = 0x400;
+	}
+	else {
+		iomemsize = 0x100;
+	}
+
 	if (first_bar > 5) {
 		printk(KERN_ERR DRIVER_NAME ": Invalid first BAR. Aborting.\n");
 		return -ENODEV;
@@ -1235,9 +1286,9 @@
 		return -ENODEV;
 	}
 
-	if (pci_resource_len(pdev, first_bar + slot) != 0x100) {
-		printk(KERN_ERR DRIVER_NAME ": Invalid iomem size. "
-			"You may experience problems.\n");
+	if ((temp = pci_resource_len(pdev, first_bar + slot)) != iomemsize) {
+		printk(KERN_ERR DRIVER_NAME ": Invalid iomem size %x. "
+			"You may experience problems.\n", temp);
 	}
 
 	if ((pdev->class & 0x0000FF) == PCI_SDHCI_IFVENDOR) {
@@ -1526,6 +1577,24 @@
 	chip->pdev = pdev;
 	chip->quirks = ent->driver_data;
 
+	if ((pdev->vendor == PCI_VENDOR_ID_TOKYO_ELECTRON) &&
+	    (pdev->device == PCI_DEVICE_ID_ELLEN)) {
+		ret = pci_read_config_byte(pdev, PCI_CLASS_PROG, &rev);
+		if (ret)
+			goto free;
+		
+		if( rev & 0x1 ) {
+			/* Ellen indicates DMA support by this bit */
+			chip->quirks |= SDHCI_QUIRK_FORCE_DMA;
+		}
+		
+		ret = sdhci_ellen_init(pdev);
+		if (ret) {
+			ret = -ENODEV;
+			goto free;
+		}
+	}
+
 	if (debug_quirks)
 		chip->quirks = debug_quirks;
 
--- drzeus/include/linux/pci_ids.h	2007-11-30 19:15:24.000000000 -0800
+++ linux-2.6.23/include/linux/pci_ids.h	2007-11-30 19:15:01.000000000 -0800
@@ -2057,6 +2057,9 @@
 #define PCI_DEVICE_ID_BCM1250_PCI	0x0001
 #define PCI_DEVICE_ID_BCM1250_HT	0x0002
 
+#define PCI_VENDOR_ID_TOKYO_ELECTRON	0x1679
+#define PCI_DEVICE_ID_ELLEN		0x3000
+
 #define PCI_VENDOR_ID_ATHEROS		0x168c
 
 #define PCI_VENDOR_ID_NETCELL		0x169c

--------------080801090800090004010805--
