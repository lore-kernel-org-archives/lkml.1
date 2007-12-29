Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbXL2I6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbXL2I6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 03:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbXL2I6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 03:58:15 -0500
Received: from usul.saidi.cx ([204.11.33.34]:46033 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752164AbXL2I6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 03:58:15 -0500
X-Greylist: delayed 2777 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Dec 2007 03:58:14 EST
Message-ID: <4776013E.3070806@overt.org>
Date: Sat, 29 Dec 2007 00:11:42 -0800
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071121)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       sdhci-devel@list.drzeus.cx
Subject: [PATCH] mmc: Handle suspend/resume in Ricoh MMC disabler
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pci config space is reinitialised on a suspend/resume cycle, the
disabler needs to work its magic at resume time. For symmetry this
change also explicitly enables the controller at suspend time but
it's not strictly necessary.

Signed-off-by: Philipl Langdale <philipl@overt.org>

--- linux-2.6.24/drivers/mmc/host/ricoh_mmc.c	2007-12-28 17:18:18.000000000 -0800
+++ linux-2.6.24-phil/drivers/mmc/host/ricoh_mmc.c	2007-12-29 00:05:30.000000000 -0800
@@ -41,6 +41,46 @@

  MODULE_DEVICE_TABLE(pci, pci_ids);

+static int ricoh_mmc_disable(struct pci_dev *fw_dev)
+{
+	u8 write_enable;
+	u8 disable;
+
+	pci_read_config_byte(fw_dev, 0xCB, &disable);
+	if (disable & 0x02) {
+		printk(KERN_INFO DRIVER_NAME
+		       ": Controller already disabled. Nothing to do.\n");
+		return -ENODEV;
+	}
+
+	pci_read_config_byte(fw_dev, 0xCA, &write_enable);
+	pci_write_config_byte(fw_dev, 0xCA, 0x57);
+	pci_write_config_byte(fw_dev, 0xCB, disable | 0x02);
+	pci_write_config_byte(fw_dev, 0xCA, write_enable);
+
+	printk(KERN_INFO DRIVER_NAME
+	       ": Controller is now disabled.\n");
+
+	return 0;
+}
+
+static int ricoh_mmc_enable(struct pci_dev *fw_dev)
+{
+	u8 write_enable;
+	u8 disable;
+
+	pci_read_config_byte(fw_dev, 0xCA, &write_enable);
+	pci_read_config_byte(fw_dev, 0xCB, &disable);
+	pci_write_config_byte(fw_dev, 0xCA, 0x57);
+	pci_write_config_byte(fw_dev, 0xCB, disable & ~0x02);
+	pci_write_config_byte(fw_dev, 0xCA, write_enable);
+
+	printk(KERN_INFO DRIVER_NAME
+	       ": Controller is now re-enabled.\n");
+
+	return 0;
+}
+
  static int __devinit ricoh_mmc_probe(struct pci_dev *pdev,
  				     const struct pci_device_id *ent)
  {
@@ -61,26 +101,12 @@
  	while ((fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
  		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
  		    pdev->bus == fw_dev->bus) {
-			u8 write_enable;
-			u8 disable;
-
-			pci_read_config_byte(fw_dev, 0xCB, &disable);
-			if (disable & 0x02) {
-				printk(KERN_INFO DRIVER_NAME
-				       ": Controller already disabled. Nothing to do.\n");
+			if (ricoh_mmc_disable(fw_dev) != 0) {
  				return -ENODEV;
  			}

-			pci_read_config_byte(fw_dev, 0xCA, &write_enable);
-			pci_write_config_byte(fw_dev, 0xCA, 0x57);
-			pci_write_config_byte(fw_dev, 0xCB, disable | 0x02);
-			pci_write_config_byte(fw_dev, 0xCA, write_enable);
-
  			pci_set_drvdata(pdev, fw_dev);

-			printk(KERN_INFO DRIVER_NAME
-			       ": Controller is now disabled.\n");
-
  			break;
  		}
  	}
@@ -96,30 +122,51 @@

  static void __devexit ricoh_mmc_remove(struct pci_dev *pdev)
  {
-	u8 write_enable;
-	u8 disable;
  	struct pci_dev *fw_dev = NULL;

  	fw_dev = pci_get_drvdata(pdev);
  	BUG_ON(fw_dev == NULL);

-	pci_read_config_byte(fw_dev, 0xCA, &write_enable);
-	pci_read_config_byte(fw_dev, 0xCB, &disable);
-	pci_write_config_byte(fw_dev, 0xCA, 0x57);
-	pci_write_config_byte(fw_dev, 0xCB, disable & ~0x02);
-	pci_write_config_byte(fw_dev, 0xCA, write_enable);
-
-	printk(KERN_INFO DRIVER_NAME
-	       ": Controller is now re-enabled.\n");
+	ricoh_mmc_enable(fw_dev);

  	pci_set_drvdata(pdev, NULL);
  }

+static int ricoh_mmc_suspend (struct pci_dev *pdev, pm_message_t state)
+{
+	struct pci_dev *fw_dev = NULL;
+
+	fw_dev = pci_get_drvdata(pdev);
+	BUG_ON(fw_dev == NULL);
+
+	printk(KERN_INFO DRIVER_NAME ": Suspending.\n");
+
+	ricoh_mmc_enable(fw_dev);
+
+	return 0;
+}
+
+static int ricoh_mmc_resume (struct pci_dev *pdev)
+{
+	struct pci_dev *fw_dev = NULL;
+
+	fw_dev = pci_get_drvdata(pdev);
+	BUG_ON(fw_dev == NULL);
+
+	printk(KERN_INFO DRIVER_NAME ": Resuming.\n");
+
+	ricoh_mmc_disable(fw_dev);
+
+	return 0;
+}
+
  static struct pci_driver ricoh_mmc_driver = {
  	.name = 	DRIVER_NAME,
  	.id_table =	pci_ids,
  	.probe = 	ricoh_mmc_probe,
  	.remove =	__devexit_p(ricoh_mmc_remove),
+	.suspend =	ricoh_mmc_suspend,
+	.resume =	ricoh_mmc_resume,
  };

  /*****************************************************************************\
