Return-Path: <linux-kernel-owner+w=401wt.eu-S1752458AbXE3BqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbXE3BqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 21:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbXE3BqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 21:46:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:30058 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbXE3BqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 21:46:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,590,1170662400"; 
   d="scan'208";a="250979966"
Date: Wed, 30 May 2007 09:45:58 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
       Keith Packard <keithp@keithp.com>
Subject: [resend] [AGPGART] intel_agp: use table for device probe
Message-ID: <20070530014558.GB18034@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
	Keith Packard <keithp@keithp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fixed issues noted by Christoph Hellwig, and I changed device table
scan a bit to allow the case that some models of graphics chips may
have same host bridge type. This type of chip will be added in the future. 

This patch cleans up device probe function. Eric Anholt was the original author.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |  300 ++++++++++++++----------------------------
 1 files changed, 98 insertions(+), 202 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index e12f579..dcb6d4f 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -1717,41 +1717,92 @@ static const struct agp_bridge_driver intel_7505_driver = {
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
-static int find_i810(u16 device)
-{
-	struct pci_dev *i810_dev;
 
-	i810_dev = pci_get_device(PCI_VENDOR_ID_INTEL, device, NULL);
-	if (!i810_dev)
-		return 0;
-	intel_private.pcidev = i810_dev;
-	return 1;
-}
-
-static int find_i830(u16 device)
+static int find_gmch(u16 device)
 {
-	struct pci_dev *i830_dev;
+	struct pci_dev *gmch_device;
 
-	i830_dev = pci_get_device(PCI_VENDOR_ID_INTEL, device, NULL);
-	if (i830_dev && PCI_FUNC(i830_dev->devfn) != 0) {
-		i830_dev = pci_get_device(PCI_VENDOR_ID_INTEL,
-				device, i830_dev);
+	gmch_device = pci_get_device(PCI_VENDOR_ID_INTEL, device, NULL);
+	if (gmch_device && PCI_FUNC(gmch_device->devfn) != 0) {
+		gmch_device = pci_get_device(PCI_VENDOR_ID_INTEL,
+                                device, gmch_device);
 	}
 
-	if (!i830_dev)
+	if (!gmch_device)
 		return 0;
 
-	intel_private.pcidev = i830_dev;
+	intel_private.pcidev = gmch_device;
 	return 1;
 }
 
+/* Table to describe Intel GMCH and AGP/PCIE GART drivers.  At least one of
+ * driver and gmch_driver must be non-null, and find_gmch will determine
+ * which one should be used if a gmch_chip_id is present.
+ */
+static const struct intel_driver_description {
+	unsigned int chip_id;
+	unsigned int gmch_chip_id;
+	char *name;
+	const struct agp_bridge_driver *driver;
+	const struct agp_bridge_driver *gmch_driver;
+} intel_agp_chipsets[] = {
+	{ PCI_DEVICE_ID_INTEL_82443LX_0, 0, "440LX", &intel_generic_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82443BX_0, 0, "440BX", &intel_generic_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82443GX_0, 0, "440GX", &intel_generic_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82810_MC1, PCI_DEVICE_ID_INTEL_82810_IG1, "i810",
+		NULL, &intel_810_driver },
+	{ PCI_DEVICE_ID_INTEL_82810_MC3, PCI_DEVICE_ID_INTEL_82810_IG3, "i810",
+		NULL, &intel_810_driver },
+	{ PCI_DEVICE_ID_INTEL_82810E_MC, PCI_DEVICE_ID_INTEL_82810E_IG, "i810",
+		NULL, &intel_810_driver },
+	{ PCI_DEVICE_ID_INTEL_82815_MC, PCI_DEVICE_ID_INTEL_82815_CGC, "i815",
+		&intel_810_driver, &intel_815_driver },
+	{ PCI_DEVICE_ID_INTEL_82820_HB, 0, "i820", &intel_820_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82820_UP_HB, 0, "i820", &intel_820_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82830_HB, PCI_DEVICE_ID_INTEL_82830_CGC, "830M",
+		&intel_830mp_driver, &intel_830_driver },
+	{ PCI_DEVICE_ID_INTEL_82840_HB, 0, "i840", &intel_840_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82845_HB, 0, "845G", &intel_845_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82845G_HB, PCI_DEVICE_ID_INTEL_82845G_IG, "830M",
+		&intel_845_driver, &intel_830_driver },
+	{ PCI_DEVICE_ID_INTEL_82850_HB, 0, "i850", &intel_850_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82855PM_HB, 0, "855PM", &intel_845_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82855GM_HB, PCI_DEVICE_ID_INTEL_82855GM_IG, "855GM",
+		&intel_845_driver, &intel_830_driver },
+	{ PCI_DEVICE_ID_INTEL_82860_HB, 0, "i860", &intel_860_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82865_HB, PCI_DEVICE_ID_INTEL_82865_IG, "865",
+		&intel_845_driver, &intel_830_driver },
+	{ PCI_DEVICE_ID_INTEL_82875_HB, 0, "i875", &intel_845_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82915G_HB, PCI_DEVICE_ID_INTEL_82915G_IG, "915G",
+		&intel_845_driver, &intel_915_driver },
+	{ PCI_DEVICE_ID_INTEL_82915GM_HB, PCI_DEVICE_ID_INTEL_82915GM_IG, "915GM",
+		&intel_845_driver, &intel_915_driver },
+	{ PCI_DEVICE_ID_INTEL_82945G_HB, PCI_DEVICE_ID_INTEL_82945G_IG, "945G",
+		&intel_845_driver, &intel_915_driver },
+	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GM_IG, "945GM",
+		&intel_845_driver, &intel_915_driver },
+	{ PCI_DEVICE_ID_INTEL_82946GZ_HB, PCI_DEVICE_ID_INTEL_82946GZ_IG, "946GZ",
+		&intel_845_driver, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_82965G_1_HB, PCI_DEVICE_ID_INTEL_82965G_1_IG, "965G",
+		&intel_845_driver, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_82965Q_HB, PCI_DEVICE_ID_INTEL_82965Q_IG, "965Q",
+		&intel_845_driver, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_82965G_HB, PCI_DEVICE_ID_INTEL_82965G_IG, "965G",
+		&intel_845_driver, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, "965GM",
+		&intel_845_driver, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_7505_0, 0, "E7505", &intel_7505_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_7205_0, 0, "E7205", &intel_7505_driver, NULL },
+	{ 0, 0, NULL, NULL, NULL }
+};
+
 static int __devinit agp_intel_probe(struct pci_dev *pdev,
 				     const struct pci_device_id *ent)
 {
 	struct agp_bridge_data *bridge;
-	char *name = "(unknown)";
 	u8 cap_ptr = 0;
 	struct resource *r;
+	int i;
 
 	cap_ptr = pci_find_capability(pdev, PCI_CAP_ID_AGP);
 
@@ -1759,191 +1810,42 @@ static int __devinit agp_intel_probe(struct pci_dev *pdev,
 	if (!bridge)
 		return -ENOMEM;
 
-	switch (pdev->device) {
-	case PCI_DEVICE_ID_INTEL_82443LX_0:
-		bridge->driver = &intel_generic_driver;
-		name = "440LX";
-		break;
-	case PCI_DEVICE_ID_INTEL_82443BX_0:
-		bridge->driver = &intel_generic_driver;
-		name = "440BX";
-		break;
-	case PCI_DEVICE_ID_INTEL_82443GX_0:
-		bridge->driver = &intel_generic_driver;
-		name = "440GX";
-		break;
-	case PCI_DEVICE_ID_INTEL_82810_MC1:
-		name = "i810";
-		if (!find_i810(PCI_DEVICE_ID_INTEL_82810_IG1))
-			goto fail;
-		bridge->driver = &intel_810_driver;
-		break;
-	case PCI_DEVICE_ID_INTEL_82810_MC3:
-		name = "i810 DC100";
-		if (!find_i810(PCI_DEVICE_ID_INTEL_82810_IG3))
-			goto fail;
-		bridge->driver = &intel_810_driver;
-		break;
-	case PCI_DEVICE_ID_INTEL_82810E_MC:
-		name = "i810 E";
-		if (!find_i810(PCI_DEVICE_ID_INTEL_82810E_IG))
-			goto fail;
-		bridge->driver = &intel_810_driver;
-		break;
-	 case PCI_DEVICE_ID_INTEL_82815_MC:
-		/*
-		 * The i815 can operate either as an i810 style
-		 * integrated device, or as an AGP4X motherboard.
-		 */
-		if (find_i810(PCI_DEVICE_ID_INTEL_82815_CGC))
-			bridge->driver = &intel_810_driver;
-		else
-			bridge->driver = &intel_815_driver;
-		name = "i815";
-		break;
-	case PCI_DEVICE_ID_INTEL_82820_HB:
-	case PCI_DEVICE_ID_INTEL_82820_UP_HB:
-		bridge->driver = &intel_820_driver;
-		name = "i820";
-		break;
-	case PCI_DEVICE_ID_INTEL_82830_HB:
-		if (find_i830(PCI_DEVICE_ID_INTEL_82830_CGC))
-			bridge->driver = &intel_830_driver;
-		else
-			bridge->driver = &intel_830mp_driver;
-		name = "830M";
-		break;
-	case PCI_DEVICE_ID_INTEL_82840_HB:
-		bridge->driver = &intel_840_driver;
-		name = "i840";
-		break;
-	case PCI_DEVICE_ID_INTEL_82845_HB:
-		bridge->driver = &intel_845_driver;
-		name = "i845";
-		break;
-	case PCI_DEVICE_ID_INTEL_82845G_HB:
-		if (find_i830(PCI_DEVICE_ID_INTEL_82845G_IG))
-			bridge->driver = &intel_830_driver;
-		else
-			bridge->driver = &intel_845_driver;
-		name = "845G";
-		break;
-	case PCI_DEVICE_ID_INTEL_82850_HB:
-		bridge->driver = &intel_850_driver;
-		name = "i850";
-		break;
-	case PCI_DEVICE_ID_INTEL_82855PM_HB:
-		bridge->driver = &intel_845_driver;
-		name = "855PM";
-		break;
-	case PCI_DEVICE_ID_INTEL_82855GM_HB:
-		if (find_i830(PCI_DEVICE_ID_INTEL_82855GM_IG)) {
-			bridge->driver = &intel_830_driver;
-			name = "855";
-		} else {
-			bridge->driver = &intel_845_driver;
-			name = "855GM";
-		}
-		break;
-	case PCI_DEVICE_ID_INTEL_82860_HB:
-		bridge->driver = &intel_860_driver;
-		name = "i860";
-		break;
-	case PCI_DEVICE_ID_INTEL_82865_HB:
-		if (find_i830(PCI_DEVICE_ID_INTEL_82865_IG))
-			bridge->driver = &intel_830_driver;
-		else
-			bridge->driver = &intel_845_driver;
-		name = "865";
-		break;
-	case PCI_DEVICE_ID_INTEL_82875_HB:
-		bridge->driver = &intel_845_driver;
-		name = "i875";
-		break;
-	case PCI_DEVICE_ID_INTEL_82915G_HB:
-		if (find_i830(PCI_DEVICE_ID_INTEL_82915G_IG))
-			bridge->driver = &intel_915_driver;
-		else
-			bridge->driver = &intel_845_driver;
-		name = "915G";
-		break;
-	case PCI_DEVICE_ID_INTEL_82915GM_HB:
-		if (find_i830(PCI_DEVICE_ID_INTEL_82915GM_IG))
-			bridge->driver = &intel_915_driver;
-		else
-			bridge->driver = &intel_845_driver;
-		name = "915GM";
-		break;
-	case PCI_DEVICE_ID_INTEL_82945G_HB:
-		if (find_i830(PCI_DEVICE_ID_INTEL_82945G_IG))
-			bridge->driver = &intel_915_driver;
-		else
-			bridge->driver = &intel_845_driver;
-		name = "945G";
-		break;
-	case PCI_DEVICE_ID_INTEL_82945GM_HB:
-		if (find_i830(PCI_DEVICE_ID_INTEL_82945GM_IG))
-			bridge->driver = &intel_915_driver;
-		else
-			bridge->driver = &intel_845_driver;
-		name = "945GM";
-		break;
-	case PCI_DEVICE_ID_INTEL_82946GZ_HB:
-		if (find_i830(PCI_DEVICE_ID_INTEL_82946GZ_IG))
-			bridge->driver = &intel_i965_driver;
-		else
-			bridge->driver = &intel_845_driver;
-		name = "946GZ";
-		break;
-	case PCI_DEVICE_ID_INTEL_82965G_1_HB:
-		if (find_i830(PCI_DEVICE_ID_INTEL_82965G_1_IG))
-			bridge->driver = &intel_i965_driver;
-		else
-			bridge->driver = &intel_845_driver;
-		name = "965G";
-		break;
-	case PCI_DEVICE_ID_INTEL_82965Q_HB:
-		if (find_i830(PCI_DEVICE_ID_INTEL_82965Q_IG))
-			bridge->driver = &intel_i965_driver;
-		else
-			bridge->driver = &intel_845_driver;
-		name = "965Q";
-		break;
-	case PCI_DEVICE_ID_INTEL_82965G_HB:
-		if (find_i830(PCI_DEVICE_ID_INTEL_82965G_IG))
-			bridge->driver = &intel_i965_driver;
-		else
-			bridge->driver = &intel_845_driver;
-		name = "965G";
-		break;
-	case PCI_DEVICE_ID_INTEL_82965GM_HB:
-		if (find_i830(PCI_DEVICE_ID_INTEL_82965GM_IG))
-			bridge->driver = &intel_i965_driver;
-		else
-			bridge->driver = &intel_845_driver;
-		name = "965GM";
-		break;
-	case PCI_DEVICE_ID_INTEL_7505_0:
-		bridge->driver = &intel_7505_driver;
-		name = "E7505";
-		break;
-	case PCI_DEVICE_ID_INTEL_7205_0:
-		bridge->driver = &intel_7505_driver;
-		name = "E7205";
-		break;
-	default:
+	for (i = 0; intel_agp_chipsets[i].name != NULL; i++) {
+		/* In case that multiple models of gfx chip may
+		   stand on same host bridge type, this can be
+		   sure we detect the right IGD. */
+		if ((pdev->device == intel_agp_chipsets[i].chip_id) &&
+			((intel_agp_chipsets[i].gmch_chip_id == 0) ||
+				find_gmch(intel_agp_chipsets[i].gmch_chip_id)))
+			break;
+	}
+
+	if (intel_agp_chipsets[i].name == NULL) {
 		if (cap_ptr)
-			printk(KERN_WARNING PFX "Unsupported Intel chipset (device id: %04x)\n",
-			    pdev->device);
+			printk(KERN_WARNING PFX "Unsupported Intel chipset"
+                               "(device id: %04x)\n", pdev->device);
 		agp_put_bridge(bridge);
 		return -ENODEV;
-	};
+	}
+
+	if (intel_agp_chipsets[i].gmch_chip_id != 0)
+	    bridge->driver = intel_agp_chipsets[i].gmch_driver;
+	else
+	    bridge->driver = intel_agp_chipsets[i].driver;
+
+	if (bridge->driver == NULL) {
+		printk(KERN_WARNING PFX "Failed to find bridge device "
+			"(chip_id: %04x)\n", intel_agp_chipsets[i].gmch_chip_id);
+		agp_put_bridge(bridge);
+		return -ENODEV;
+        }
 
 	bridge->dev = pdev;
 	bridge->capndx = cap_ptr;
 	bridge->dev_private_data = &intel_private;
 
-	printk(KERN_INFO PFX "Detected an Intel %s Chipset.\n", name);
+	printk(KERN_INFO PFX "Detected an Intel %s Chipset.\n",
+		intel_agp_chipsets[i].name);
 
 	/*
 	* The following fixes the case where the BIOS has "forgotten" to
@@ -1979,12 +1881,6 @@ static int __devinit agp_intel_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, bridge);
 	return agp_add_bridge(bridge);
-
-fail:
-	printk(KERN_ERR PFX "Detected an Intel %s chipset, "
-		"but could not find the secondary device.\n", name);
-	agp_put_bridge(bridge);
-	return -ENODEV;
 }
 
 static void __devexit agp_intel_remove(struct pci_dev *pdev)
-- 
1.4.4.4
