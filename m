Return-Path: <linux-kernel-owner+w=401wt.eu-S1760175AbYCALfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbYCALfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 06:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbYCALfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 06:35:43 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58265 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123AbYCALfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 06:35:42 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 1 Mar 2008 12:35:29 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/4] firewire: fw-ohci: refactor probe, remove, suspend,
 resume
To: linux1394-devel@lists.sourceforge.net
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
In-Reply-To: <tkrat.ffa17a046c55daa9@s5r6.in-berlin.de>
Message-ID: <tkrat.ff90a1c61d90de61@s5r6.in-berlin.de>
References: <tkrat.ac97915a5b51e35b@s5r6.in-berlin.de>
 <tkrat.7e8e04e66a38dcd6@s5r6.in-berlin.de>
 <1204340392.15052.455.camel@pasglop> <47C90E81.7050603@s5r6.in-berlin.de>
 <tkrat.bc4ca3408428a60b@s5r6.in-berlin.de>
 <tkrat.ffa17a046c55daa9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up shared code and variable names.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |  100 ++++++++++++++++++---------------------------
 1 file changed, 42 insertions(+), 58 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -2061,17 +2061,9 @@ static const struct fw_card_driver ohci_
 	.stop_iso		= ohci_stop_iso,
 };
 
-static int __devinit
-pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
-{
-	struct fw_ohci *ohci;
-	u32 bus_options, max_receive, link_speed;
-	u64 guid;
-	int err;
-	size_t size;
-
 #ifdef CONFIG_PPC_PMAC
-	/* Necessary on some machines if fw-ohci was loaded/ unloaded before */
+static void ohci_pmac_on(struct pci_dev *dev)
+{
 	if (machine_is(powermac)) {
 		struct device_node *ofn = pci_device_to_OF_node(dev);
 
@@ -2080,8 +2072,35 @@ pci_probe(struct pci_dev *dev, const str
 			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 1);
 		}
 	}
+}
+
+static void ohci_pmac_off(struct pci_dev *dev)
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
+#define ohci_pmac_on(dev)
+#define ohci_pmac_off(dev)
 #endif /* CONFIG_PPC_PMAC */
 
+static int __devinit
+pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
+{
+	struct fw_ohci *ohci;
+	u32 bus_options, max_receive, link_speed;
+	u64 guid;
+	int err;
+	size_t size;
+
+	ohci_pmac_on(dev);
+
 	ohci = kzalloc(sizeof(*ohci), GFP_KERNEL);
 	if (ohci == NULL) {
 		fw_error("Could not malloc fw_ohci data.\n");
@@ -2218,77 +2237,42 @@ static void pci_remove(struct pci_dev *d
 	pci_iounmap(dev, ohci->registers);
 	pci_release_region(dev, 0);
 	pci_disable_device(dev);
-
-#ifdef CONFIG_PPC_PMAC
-	/* On UniNorth, power down the cable and turn off the chip clock
-	 * to save power on laptops */
-	if (machine_is(powermac)) {
-		struct device_node *ofn = pci_device_to_OF_node(dev);
-
-		if (ofn) {
-			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 0);
-			pmac_call_feature(PMAC_FTR_1394_CABLE_POWER, ofn, 0, 0);
-		}
-	}
-#endif /* CONFIG_PPC_PMAC */
-
+	ohci_pmac_off(dev);
 	kfree(&ohci->card);
 
 	fw_notify("Removed fw-ohci device.\n");
 }
 
 #ifdef CONFIG_PM
-static int pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int pci_suspend(struct pci_dev *dev, pm_message_t state)
 {
-	struct fw_ohci *ohci = pci_get_drvdata(pdev);
+	struct fw_ohci *ohci = pci_get_drvdata(dev);
 	int err;
 
 	software_reset(ohci);
-	free_irq(pdev->irq, ohci);
-	err = pci_save_state(pdev);
+	free_irq(dev->irq, ohci);
+	err = pci_save_state(dev);
 	if (err) {
 		fw_error("pci_save_state failed\n");
 		return err;
 	}
-	err = pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	err = pci_set_power_state(dev, pci_choose_state(dev, state));
 	if (err)
 		fw_error("pci_set_power_state failed with %d\n", err);
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
+	ohci_pmac_off(dev);
 
 	return 0;
 }
 
-static int pci_resume(struct pci_dev *pdev)
+static int pci_resume(struct pci_dev *dev)
 {
-	struct fw_ohci *ohci = pci_get_drvdata(pdev);
+	struct fw_ohci *ohci = pci_get_drvdata(dev);
 	int err;
 
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
+	ohci_pmac_on(dev);
+	pci_set_power_state(dev, PCI_D0);
+	pci_restore_state(dev);
+	err = pci_enable_device(dev);
 	if (err) {
 		fw_error("pci_enable_device failed\n");
 		return err;

-- 
Stefan Richter
-=====-==--- --== ----=
http://arcgraph.de/sr/

