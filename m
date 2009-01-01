Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbZAATFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbZAATFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 14:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZAATFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 14:05:22 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:44950 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZAATFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 14:05:20 -0500
Date: Thu, 1 Jan 2009 20:05:17 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: [PATCH 2.6.28 2/3] EDAC: Use 'overflow' device for binding i82875 EDAC driver
Message-ID: <20090101190517.GB22845@rere.qmqm.pl>
References: <20081223215030.GA32525@rere.qmqm.pl> <20090101190254.GA22845@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090101190254.GA22845@rere.qmqm.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bind i82875 EDAC driver to the 'overflow' device.
Depends on 'Unhide MCH5/6 memory controller configuration device' patch
to work in some cases.

This is rebased against 2.6.28 vanilla kernel.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- orig/drivers/edac/i82875p_edac.c	2008-12-07 01:15:51.000000000 +0100
+++ tmp/drivers/edac/i82875p_edac.c	2008-12-07 13:02:32.000000000 +0100
@@ -30,10 +30,6 @@
 #define i82875p_mc_printk(mci, level, fmt, arg...) \
 	edac_mc_chipset_printk(mci, level, "i82875p", fmt, ##arg)
 
-#ifndef PCI_DEVICE_ID_INTEL_82875_0
-#define PCI_DEVICE_ID_INTEL_82875_0	0x2578
-#endif				/* PCI_DEVICE_ID_INTEL_82875_0 */
-
 #ifndef PCI_DEVICE_ID_INTEL_82875_6
 #define PCI_DEVICE_ID_INTEL_82875_6	0x257e
 #endif				/* PCI_DEVICE_ID_INTEL_82875_6 */
@@ -157,7 +153,7 @@
 };
 
 struct i82875p_pvt {
-	struct pci_dev *ovrfl_pdev;
+	struct pci_dev *mci_pdev;
 	void __iomem *ovrfl_window;
 };
 
@@ -178,18 +174,13 @@
 		.ctl_name = "i82875p"},
 };
 
-static struct pci_dev *mci_pdev;	/* init dev: in case that AGP code has
-					 * already registered driver
-					 */
-
 static struct edac_pci_ctl_info *i82875p_pci;
 
 static void i82875p_get_error_info(struct mem_ctl_info *mci,
 				struct i82875p_error_info *info)
 {
-	struct pci_dev *pdev;
-
-	pdev = to_pci_dev(mci->dev);
+	struct i82875p_pvt *pvt = mci->pvt_info;
+	struct pci_dev *pdev = pvt->mci_pdev;
 
 	/*
 	 * This is a mess because there is no atomic way to read all the
@@ -262,78 +253,6 @@
 	i82875p_process_error_info(mci, &info, 1);
 }
 
-/* Return 0 on success or 1 on failure. */
-static int i82875p_setup_overfl_dev(struct pci_dev *pdev,
-				struct pci_dev **ovrfl_pdev,
-				void __iomem **ovrfl_window)
-{
-	struct pci_dev *dev;
-	void __iomem *window;
-	int err;
-
-	*ovrfl_pdev = NULL;
-	*ovrfl_window = NULL;
-	dev = pci_get_device(PCI_VEND_DEV(INTEL, 82875_6), NULL);
-
-	if (dev == NULL) {
-		/* Intel tells BIOS developers to hide device 6 which
-		 * configures the overflow device access containing
-		 * the DRBs - this is where we expose device 6.
-		 * http://www.x86-secret.com/articles/tweak/pat/patsecrets-2.htm
-		 */
-		pci_write_bits8(pdev, 0xf4, 0x2, 0x2);
-		dev = pci_scan_single_device(pdev->bus, PCI_DEVFN(6, 0));
-
-		if (dev == NULL)
-			return 1;
-
-		err = pci_bus_add_device(dev);
-		if (err) {
-			i82875p_printk(KERN_ERR,
-				"%s(): pci_bus_add_device() Failed\n",
-				__func__);
-		}
-		pci_bus_assign_resources(dev->bus);
-	}
-
-	*ovrfl_pdev = dev;
-
-	if (pci_enable_device(dev)) {
-		i82875p_printk(KERN_ERR, "%s(): Failed to enable overflow "
-			"device\n", __func__);
-		return 1;
-	}
-
-	if (pci_request_regions(dev, pci_name(dev))) {
-#ifdef CORRECT_BIOS
-		goto fail0;
-#endif
-	}
-
-	/* cache is irrelevant for PCI bus reads/writes */
-	window = ioremap_nocache(pci_resource_start(dev, 0),
-				 pci_resource_len(dev, 0));
-
-	if (window == NULL) {
-		i82875p_printk(KERN_ERR, "%s(): Failed to ioremap bar6\n",
-			__func__);
-		goto fail1;
-	}
-
-	*ovrfl_window = window;
-	return 0;
-
-fail1:
-	pci_release_regions(dev);
-
-#ifdef CORRECT_BIOS
-fail0:
-	pci_disable_device(dev);
-#endif
-	/* NOTE: the ovrfl proc entry and pci_dev are intentionally left */
-	return 1;
-}
-
 /* Return 1 if dual channel mode is active.  Else return 0. */
 static inline int dual_channel_active(u32 drc)
 {
@@ -341,7 +260,6 @@
 }
 
 static void i82875p_init_csrows(struct mem_ctl_info *mci,
-				struct pci_dev *pdev,
 				void __iomem * ovrfl_window, u32 drc)
 {
 	struct csrow_info *csrow;
@@ -381,12 +299,12 @@
 	}
 }
 
-static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
+static int i82875p_probe_edac(struct pci_dev *mci_pdev,
+			      struct pci_dev *ovrfl_pdev, int dev_idx)
 {
 	int rc = -ENODEV;
 	struct mem_ctl_info *mci;
 	struct i82875p_pvt *pvt;
-	struct pci_dev *ovrfl_pdev;
 	void __iomem *ovrfl_window;
 	u32 drc;
 	u32 nr_chans;
@@ -394,10 +312,12 @@
 
 	debugf0("%s()\n", __func__);
 
-	ovrfl_pdev = pci_get_device(PCI_VEND_DEV(INTEL, 82875_6), NULL);
+	/* cache is irrelevant for PCI bus reads/writes */
+	ovrfl_window = ioremap_nocache(pci_resource_start(ovrfl_pdev, 0),
+				 pci_resource_len(ovrfl_pdev, 0));
+	if (!ovrfl_window)
+		return -EBUSY;
 
-	if (i82875p_setup_overfl_dev(pdev, &ovrfl_pdev, &ovrfl_window))
-		return -ENODEV;
 	drc = readl(ovrfl_window + I82875P_DRC);
 	nr_chans = dual_channel_active(drc) + 1;
 	mci = edac_mc_alloc(sizeof(*pvt), I82875P_NR_CSROWS(nr_chans),
@@ -412,21 +332,23 @@
 	kobject_get(&mci->edac_mci_kobj);
 
 	debugf3("%s(): init mci\n", __func__);
-	mci->dev = &pdev->dev;
+	mci->dev = &ovrfl_pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
 	mci->edac_cap = EDAC_FLAG_UNKNOWN;
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = I82875P_REVISION;
 	mci->ctl_name = i82875p_devs[dev_idx].ctl_name;
-	mci->dev_name = pci_name(pdev);
+	mci->dev_name = pci_name(mci_pdev);
 	mci->edac_check = i82875p_check;
 	mci->ctl_page_to_phys = NULL;
+
 	debugf3("%s(): init pvt\n", __func__);
-	pvt = (struct i82875p_pvt *)mci->pvt_info;
-	pvt->ovrfl_pdev = ovrfl_pdev;
+	pvt = mci->pvt_info;
+	pvt->mci_pdev = mci_pdev;
 	pvt->ovrfl_window = ovrfl_window;
-	i82875p_init_csrows(mci, pdev, ovrfl_window, drc);
+
+	i82875p_init_csrows(mci, ovrfl_window, drc);
 	i82875p_get_error_info(mci, &discard);	/* clear counters */
 
 	/* Here we assume that we will never see multiple instances of this
@@ -438,7 +360,7 @@
 	}
 
 	/* allocating generic PCI control info */
-	i82875p_pci = edac_pci_create_generic_ctl(&pdev->dev, EDAC_MOD_STR);
+	i82875p_pci = edac_pci_create_generic_ctl(&mci_pdev->dev, EDAC_MOD_STR);
 	if (!i82875p_pci) {
 		printk(KERN_WARNING
 			"%s(): Unable to create PCI control\n",
@@ -458,10 +380,6 @@
 
 fail0:
 	iounmap(ovrfl_window);
-	pci_release_regions(ovrfl_pdev);
-
-	pci_disable_device(ovrfl_pdev);
-	/* NOTE: the ovrfl proc entry and pci_dev are intentionally left */
 	return rc;
 }
 
@@ -469,26 +387,52 @@
 static int __devinit i82875p_init_one(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
+	int mci_devfn = PCI_DEVFN(PCI_SLOT(pdev->devfn), 0);
+	struct pci_dev *mci_pdev;
 	int rc;
 
 	debugf0("%s()\n", __func__);
 	i82875p_printk(KERN_INFO, "i82875p init one\n");
 
-	if (pci_enable_device(pdev) < 0)
-		return -EIO;
+	mci_pdev = pci_get_slot(pdev->bus, mci_devfn);
+	if (!mci_pdev)
+		return -ENODEV;
+
+	rc = pci_enable_device(mci_pdev);
+	if (rc < 0)
+		goto err_out_put1;
+
+	/* XXX looks like something is clearing this bit after early
+	 * quirk phase */
+	pci_write_bits8(pdev, 0xf4, 0x2, 0x2);
 
-	rc = i82875p_probe1(pdev, ent->driver_data);
+	rc = pci_enable_device(pdev);
+	if (rc < 0)
+		goto err_out_put1;
 
-	if (mci_pdev == NULL)
-		mci_pdev = pci_dev_get(pdev);
+	rc = pci_request_regions(pdev, pci_name(pdev));
+	if (rc < 0)
+		goto err_out_noreg;
 
+	rc = i82875p_probe_edac(mci_pdev, pdev, ent->driver_data);
+
+	if (!rc)
+		return 0;
+
+	pci_release_regions(pdev);
+err_out_noreg:
+	pci_disable_device(pdev);
+err_out_put1:
+	pci_dev_put(mci_pdev);
 	return rc;
 }
 
 static void __devexit i82875p_remove_one(struct pci_dev *pdev)
 {
+	int mci_devfn = PCI_DEVFN(PCI_SLOT(pdev->devfn), 0);
+	struct pci_dev *mci_pdev;
 	struct mem_ctl_info *mci;
-	struct i82875p_pvt *pvt = NULL;
+	struct i82875p_pvt *pvt;
 
 	debugf0("%s()\n", __func__);
 
@@ -498,29 +442,19 @@
 	if ((mci = edac_mc_del_mc(&pdev->dev)) == NULL)
 		return;
 
-	pvt = (struct i82875p_pvt *)mci->pvt_info;
+	pvt = mci->pvt_info;
+	iounmap(pvt->ovrfl_window);
 
-	if (pvt->ovrfl_window)
-		iounmap(pvt->ovrfl_window);
-
-	if (pvt->ovrfl_pdev) {
-#ifdef CORRECT_BIOS
-		pci_release_regions(pvt->ovrfl_pdev);
-#endif				/*CORRECT_BIOS */
-		pci_disable_device(pvt->ovrfl_pdev);
-		pci_dev_put(pvt->ovrfl_pdev);
-	}
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	pci_dev_put(pvt->mci_pdev);
 
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id i82875p_pci_tbl[] __devinitdata = {
-	{
-	 PCI_VEND_DEV(INTEL, 82875_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-	 I82875P},
-	{
-	 0,
-	 }			/* 0 terminated list. */
+static DEFINE_PCI_DEVICE_TABLE(i82875p_pci_tbl) = {
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82875_6), I82875P },
+	{ 0, }	 	/* 0 terminated list. */
 };
 
 MODULE_DEVICE_TABLE(pci, i82875p_pci_tbl);
@@ -534,58 +468,19 @@
 
 static int __init i82875p_init(void)
 {
-	int pci_rc;
-
 	debugf3("%s()\n", __func__);
 
-       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
-       opstate_init();
-
-	pci_rc = pci_register_driver(&i82875p_driver);
+	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
+	opstate_init();
 
-	if (pci_rc < 0)
-		goto fail0;
-
-	if (mci_pdev == NULL) {
-		mci_pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
-					PCI_DEVICE_ID_INTEL_82875_0, NULL);
-
-		if (!mci_pdev) {
-			debugf0("875p pci_get_device fail\n");
-			pci_rc = -ENODEV;
-			goto fail1;
-		}
-
-		pci_rc = i82875p_init_one(mci_pdev, i82875p_pci_tbl);
-
-		if (pci_rc < 0) {
-			debugf0("875p init fail\n");
-			pci_rc = -ENODEV;
-			goto fail1;
-		}
-	}
-
-	return 0;
-
-fail1:
-	pci_unregister_driver(&i82875p_driver);
-
-fail0:
-	if (mci_pdev != NULL)
-		pci_dev_put(mci_pdev);
-
-	return pci_rc;
+	return pci_register_driver(&i82875p_driver);
 }
 
 static void __exit i82875p_exit(void)
 {
 	debugf3("%s()\n", __func__);
 
-	i82875p_remove_one(mci_pdev);
-	pci_dev_put(mci_pdev);
-
 	pci_unregister_driver(&i82875p_driver);
-
 }
 
 module_init(i82875p_init);
