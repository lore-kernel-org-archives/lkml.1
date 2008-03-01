Return-Path: <linux-kernel-owner+w=401wt.eu-S934038AbYCABnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038AbYCABnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 20:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760149AbYCABnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 20:43:10 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35861 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758930AbYCABnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 20:43:08 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 1 Mar 2008 02:42:56 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/3] firewire: fw-ohci: PPC PMac platform code
To: linux1394-devel@lists.sourceforge.net
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ac97915a5b51e35b@s5r6.in-berlin.de>
Message-ID: <tkrat.7e8e04e66a38dcd6@s5r6.in-berlin.de>
References: <tkrat.ac97915a5b51e35b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copied from ohci1394.c.  This code is necessary to prevent machine check
exceptions when reloading or resuming the driver.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |   50 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

Index: linux-2.6.25-rc3/drivers/firewire/fw-ohci.c
===================================================================
--- linux-2.6.25-rc3.orig/drivers/firewire/fw-ohci.c
+++ linux-2.6.25-rc3/drivers/firewire/fw-ohci.c
@@ -33,6 +33,10 @@
 #include <asm/page.h>
 #include <asm/system.h>
 
+#ifdef CONFIG_PPC_PMAC
+#include <asm/pmac_feature.h>
+#endif
+
 #include "fw-ohci.h"
 #include "fw-transaction.h"
 
@@ -2057,6 +2061,18 @@ pci_probe(struct pci_dev *dev, const str
 	int err;
 	size_t size;
 
+#ifdef CONFIG_PPC_PMAC
+	/* Necessary on some machines if fw-ohci was loaded/ unloaded before */
+	if (machine_is(powermac)) {
+		struct device_node *ofn = pci_device_to_OF_node(dev);
+
+		if (ofn) {
+			pmac_call_feature(PMAC_FTR_1394_CABLE_POWER, ofn, 0, 1);
+			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 1);
+		}
+	}
+#endif /* CONFIG_PPC_PMAC */
+
 	ohci = kzalloc(sizeof(*ohci), GFP_KERNEL);
 	if (ohci == NULL) {
 		fw_error("Could not malloc fw_ohci data.\n");
@@ -2189,6 +2205,20 @@ static void pci_remove(struct pci_dev *d
 	pci_iounmap(dev, ohci->registers);
 	pci_release_region(dev, 0);
 	pci_disable_device(dev);
+
+#ifdef CONFIG_PPC_PMAC
+	/* On UniNorth, power down the cable and turn off the chip clock
+	 * to save power on laptops */
+	if (machine_is(powermac)) {
+		struct device_node* ofn = pci_device_to_OF_node(dev);
+
+		if (ofn) {
+			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 0);
+			pmac_call_feature(PMAC_FTR_1394_CABLE_POWER, ofn, 0, 0);
+		}
+	}
+#endif /* CONFIG_PPC_PMAC */
+
 	kfree(&ohci->card);
 
 	fw_notify("Removed fw-ohci device.\n");
@@ -2211,6 +2241,16 @@ static int pci_suspend(struct pci_dev *p
 	if (err)
 		fw_error("pci_set_power_state failed with %d\n", err);
 
+/* PowerMac suspend code comes last */
+#ifdef CONFIG_PPC_PMAC
+	if (machine_is(powermac)) {
+		struct device_node *ofn = pci_device_to_OF_node(pdev);
+
+		if (ofn)
+			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 0);
+	}
+#endif /* CONFIG_PPC_PMAC */
+
 	return 0;
 }
 
@@ -2219,6 +2259,16 @@ static int pci_resume(struct pci_dev *pd
 	struct fw_ohci *ohci = pci_get_drvdata(pdev);
 	int err;
 
+/* PowerMac resume code comes first */
+#ifdef CONFIG_PPC_PMAC
+	if (machine_is(powermac)) {
+		struct device_node *ofn = pci_device_to_OF_node(pdev);
+
+		if (ofn)
+			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 1);
+	}
+#endif /* CONFIG_PPC_PMAC */
+
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 	err = pci_enable_device(pdev);

-- 
Stefan Richter
-=====-==--- --== ----=
http://arcgraph.de/sr/

