Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbYCALhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbYCALhP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 06:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbYCALg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 06:36:58 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58364 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbYCALg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 06:36:56 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 1 Mar 2008 12:36:42 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/4] ieee1394: ohci1394: refactor probe, remove, suspend,
 resume
To: linux1394-devel@lists.sourceforge.net
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
In-Reply-To: <tkrat.cc6eff0684655cd0@s5r6.in-berlin.de>
Message-ID: <tkrat.116499d7e2edd86b@s5r6.in-berlin.de>
References: <tkrat.ac97915a5b51e35b@s5r6.in-berlin.de>
 <tkrat.7e8e04e66a38dcd6@s5r6.in-berlin.de>
 <1204340392.15052.455.camel@pasglop> <47C90E81.7050603@s5r6.in-berlin.de>
 <tkrat.bc4ca3408428a60b@s5r6.in-berlin.de>
 <tkrat.ffa17a046c55daa9@s5r6.in-berlin.de>
 <tkrat.ff90a1c61d90de61@s5r6.in-berlin.de>
 <tkrat.cc6eff0684655cd0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up shared code and variable names.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/ohci1394.c |  113 +++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 64 deletions(-)

Index: linux/drivers/ieee1394/ohci1394.c
===================================================================
--- linux.orig/drivers/ieee1394/ohci1394.c
+++ linux/drivers/ieee1394/ohci1394.c
@@ -2993,15 +2993,9 @@ do {						\
 	return err;				\
 } while (0)
 
-static int __devinit ohci1394_pci_probe(struct pci_dev *dev,
-					const struct pci_device_id *ent)
-{
-	struct hpsb_host *host;
-	struct ti_ohci *ohci;	/* shortcut to currently handled device */
-	resource_size_t ohci_base;
-
 #ifdef CONFIG_PPC_PMAC
-	/* Necessary on some machines if ohci1394 was loaded/ unloaded before */
+static void ohci1394_pmac_on(struct pci_dev *dev)
+{
 	if (machine_is(powermac)) {
 		struct device_node *ofn = pci_device_to_OF_node(dev);
 
@@ -3010,8 +3004,32 @@ static int __devinit ohci1394_pci_probe(
 			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 1);
 		}
 	}
+}
+
+static void ohci1394_pmac_off(struct pci_dev *dev)
+{
+	if (machine_is(powermac)) {
+		struct device_node *ofn = pci_device_to_OF_node(dev);
+
+		if (ofn) {
+			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 0);
+			pmac_call_feature(PMAC_FTR_1394_CABLE_POWER, ofn, 0, 0);
+		}
+	}
+}
+#else
+#define ohci1394_pmac_on(dev)
+#define ohci1394_pmac_off(dev)
 #endif /* CONFIG_PPC_PMAC */
 
+static int __devinit ohci1394_pci_probe(struct pci_dev *dev,
+					const struct pci_device_id *ent)
+{
+	struct hpsb_host *host;
+	struct ti_ohci *ohci;	/* shortcut to currently handled device */
+	resource_size_t ohci_base;
+
+	ohci1394_pmac_on(dev);
         if (pci_enable_device(dev))
 		FAIL(-ENXIO, "Failed to enable OHCI hardware");
         pci_set_master(dev);
@@ -3203,16 +3221,16 @@ static int __devinit ohci1394_pci_probe(
 #undef FAIL
 }
 
-static void ohci1394_pci_remove(struct pci_dev *pdev)
+static void ohci1394_pci_remove(struct pci_dev *dev)
 {
 	struct ti_ohci *ohci;
-	struct device *dev;
+	struct device *device;
 
-	ohci = pci_get_drvdata(pdev);
+	ohci = pci_get_drvdata(dev);
 	if (!ohci)
 		return;
 
-	dev = get_device(&ohci->host->device);
+	device = get_device(&ohci->host->device);
 
 	switch (ohci->init_state) {
 	case OHCI_INIT_DONE:
@@ -3246,7 +3264,7 @@ static void ohci1394_pci_remove(struct p
 		/* Soft reset before we start - this disables
 		 * interrupts and clears linkEnable and LPS. */
 		ohci_soft_reset(ohci);
-		free_irq(ohci->dev->irq, ohci);
+		free_irq(dev->irq, ohci);
 
 	case OHCI_INIT_HAVE_TXRX_BUFFERS__MAYBE:
 		/* The ohci_soft_reset() stops all DMA contexts, so we
@@ -3257,12 +3275,12 @@ static void ohci1394_pci_remove(struct p
 		free_dma_trm_ctx(&ohci->at_resp_context);
 
 	case OHCI_INIT_HAVE_SELFID_BUFFER:
-		pci_free_consistent(ohci->dev, OHCI1394_SI_DMA_BUF_SIZE,
+		pci_free_consistent(dev, OHCI1394_SI_DMA_BUF_SIZE,
 				    ohci->selfid_buf_cpu,
 				    ohci->selfid_buf_bus);
 
 	case OHCI_INIT_HAVE_CONFIG_ROM_BUFFER:
-		pci_free_consistent(ohci->dev, OHCI_CONFIG_ROM_LEN,
+		pci_free_consistent(dev, OHCI_CONFIG_ROM_LEN,
 				    ohci->csr_config_rom_cpu,
 				    ohci->csr_config_rom_bus);
 
@@ -3270,35 +3288,24 @@ static void ohci1394_pci_remove(struct p
 		iounmap(ohci->registers);
 
 	case OHCI_INIT_HAVE_MEM_REGION:
-		release_mem_region(pci_resource_start(ohci->dev, 0),
+		release_mem_region(pci_resource_start(dev, 0),
 				   OHCI1394_REGISTER_SIZE);
 
-#ifdef CONFIG_PPC_PMAC
-	/* On UniNorth, power down the cable and turn off the chip clock
-	 * to save power on laptops */
-	if (machine_is(powermac)) {
-		struct device_node* ofn = pci_device_to_OF_node(ohci->dev);
-
-		if (ofn) {
-			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 0);
-			pmac_call_feature(PMAC_FTR_1394_CABLE_POWER, ofn, 0, 0);
-		}
-	}
-#endif /* CONFIG_PPC_PMAC */
+		ohci1394_pmac_off(dev);
 
 	case OHCI_INIT_ALLOC_HOST:
-		pci_set_drvdata(ohci->dev, NULL);
+		pci_set_drvdata(dev, NULL);
 	}
 
-	if (dev)
-		put_device(dev);
+	if (device)
+		put_device(device);
 }
 
 #ifdef CONFIG_PM
-static int ohci1394_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int ohci1394_pci_suspend(struct pci_dev *dev, pm_message_t state)
 {
 	int err;
-	struct ti_ohci *ohci = pci_get_drvdata(pdev);
+	struct ti_ohci *ohci = pci_get_drvdata(dev);
 
 	if (!ohci) {
 		printk(KERN_ERR "%s: tried to suspend nonexisting host\n",
@@ -3326,34 +3333,23 @@ static int ohci1394_pci_suspend(struct p
 	ohci_devctl(ohci->host, RESET_BUS, LONG_RESET_NO_FORCE_ROOT);
 	ohci_soft_reset(ohci);
 
-	err = pci_save_state(pdev);
+	err = pci_save_state(dev);
 	if (err) {
 		PRINT(KERN_ERR, "pci_save_state failed with %d", err);
 		return err;
 	}
-	err = pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	err = pci_set_power_state(dev, pci_choose_state(dev, state));
 	if (err)
 		DBGMSG("pci_set_power_state failed with %d", err);
-
-/* PowerMac suspend code comes last */
-#ifdef CONFIG_PPC_PMAC
-	if (machine_is(powermac)) {
-		struct device_node *ofn = pci_device_to_OF_node(pdev);
-
-		if (ofn) {
-			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 0);
-			pmac_call_feature(PMAC_FTR_1394_CABLE_POWER, ofn, 0, 0);
-		}
-	}
-#endif /* CONFIG_PPC_PMAC */
+	ohci1394_pmac_off(dev);
 
 	return 0;
 }
 
-static int ohci1394_pci_resume(struct pci_dev *pdev)
+static int ohci1394_pci_resume(struct pci_dev *dev)
 {
 	int err;
-	struct ti_ohci *ohci = pci_get_drvdata(pdev);
+	struct ti_ohci *ohci = pci_get_drvdata(dev);
 
 	if (!ohci) {
 		printk(KERN_ERR "%s: tried to resume nonexisting host\n",
@@ -3362,21 +3358,10 @@ static int ohci1394_pci_resume(struct pc
 	}
 	DBGMSG("resume called");
 
-/* PowerMac resume code comes first */
-#ifdef CONFIG_PPC_PMAC
-	if (machine_is(powermac)) {
-		struct device_node *ofn = pci_device_to_OF_node(pdev);
-
-		if (ofn) {
-			pmac_call_feature(PMAC_FTR_1394_CABLE_POWER, ofn, 0, 1);
-			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 1);
-		}
-	}
-#endif /* CONFIG_PPC_PMAC */
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	err = pci_enable_device(pdev);
+	ohci1394_pmac_on(dev);
+	pci_set_power_state(dev, PCI_D0);
+	pci_restore_state(dev);
+	err = pci_enable_device(dev);
 	if (err) {
 		PRINT(KERN_ERR, "pci_enable_device failed with %d", err);
 		return err;

-- 
Stefan Richter
-=====-==--- --== ----=
http://arcgraph.de/sr/

