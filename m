Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab0BRS7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:59:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:16918 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab0BRS7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:59:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dpUWokLqlQCH8GjHuNSCwn/3taxtarT4ouhnGiMC2vo1IcPAIMw77biXPgaDiNXz8+
         HI29t52AotG8mJQRl9Y8Lv6InvtglMPMOM6NYRjluuJcf9jIpVHkLpSFxDGfzaJ1SOYi
         GZeBJGfeO0i8QYwK0iAye2hNq2ZL8zpyUTSHU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 18 Feb 2010 19:59:22 +0100
Message-Id: <20100218185922.16594.98925.sendpatchset@localhost>
In-Reply-To: <20100218185914.16594.61415.sendpatchset@localhost>
References: <20100218185914.16594.61415.sendpatchset@localhost>
Subject: [PATCH 1/3] libata: pass host flags into __ata_pci_sff_init_one() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] libata: pass host flags into __ata_pci_sff_init_one() helper

This was orginally proposed by Alan Cox but as a change
for ata_pci_sff_init_one() helper function instead of
__ata_pci_sff_init_one() one which casues needless churn
to all host drivers and accidentally breakes few host
drivers which are still on their way upstream.

Allows parallel scan and the like to be set without
having to stop using the existing full helper functions.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/libata-sff.c    |    4 +++-
 drivers/ata/pata_ali.c      |    2 +-
 drivers/ata/pata_amd.c      |    2 +-
 drivers/ata/pata_artop.c    |    2 +-
 drivers/ata/pata_atiixp.c   |   18 ++----------------
 drivers/ata/pata_cmd640.c   |    2 +-
 drivers/ata/pata_cs5530.c   |    2 +-
 drivers/ata/pata_efar.c     |   18 ++----------------
 drivers/ata/pata_hpt366.c   |    2 +-
 drivers/ata/pata_it821x.c   |    2 +-
 drivers/ata/pata_ns87415.c  |    2 +-
 drivers/ata/pata_sl82c105.c |    2 +-
 include/linux/libata.h      |    4 ++--
 13 files changed, 18 insertions(+), 44 deletions(-)

Index: b/drivers/ata/libata-sff.c
===================================================================
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -3009,6 +3009,7 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_activate_h
  *	@sht: scsi_host_template to use when registering the host
  *	@host_priv: host private_data
  *	@init_host: host initialization method (optional)
+ *	@hflag: host flags
  *
  *	This is a helper function which can be called from a driver's
  *	xxx_init_one() probe function if the hardware uses traditional
@@ -3031,7 +3032,7 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_activate_h
 int __ata_pci_sff_init_one(struct pci_dev *pdev,
 			 const struct ata_port_info * const *ppi,
 			 struct scsi_host_template *sht, void *host_priv,
-			 int (*init_host)(struct device *dev))
+			 int (*init_host)(struct device *dev), int hflag)
 {
 	struct device *dev = &pdev->dev;
 	const struct ata_port_info *pi = NULL;
@@ -3068,6 +3069,7 @@ int __ata_pci_sff_init_one(struct pci_de
 
 	host->private_data = host_priv;
 	host->init_host = init_host;
+	host->flags |= hflag;
 
 	pci_set_master(pdev);
 	rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
Index: b/drivers/ata/pata_ali.c
===================================================================
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -316,7 +316,7 @@ static int ali_init_one(struct pci_dev *
 	}
 
 	return __ata_pci_sff_init_one(pdev, ppi, &ali_sht, NULL,
-				      ali_init_chipset);
+				      ali_init_chipset, 0);
 }
 
 static const struct pci_device_id ali[] = {
Index: b/drivers/ata/pata_amd.c
===================================================================
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -494,7 +494,7 @@ static int amd_init_one(struct pci_dev *
 	}
 
 	/* And fire it up */
-	return __ata_pci_sff_init_one(pdev, ppi, &amd_sht, hpriv, amd_fixup);
+	return __ata_pci_sff_init_one(pdev, ppi, &amd_sht, hpriv, amd_fixup, 0);
 }
 
 static const struct pci_device_id amd[] = {
Index: b/drivers/ata/pata_artop.c
===================================================================
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -177,7 +177,7 @@ static int artop_init_one (struct pci_de
 	atp8xx_fixup(&pdev->dev);
 
 	return __ata_pci_sff_init_one(pdev, ppi, &artop_sht, NULL,
-				      atp8xx_fixup);
+				      atp8xx_fixup, 0);
 }
 
 static const struct pci_device_id artop_pci_tbl[] = {
Index: b/drivers/ata/pata_atiixp.c
===================================================================
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -77,23 +77,9 @@ static int atiixp_init_one(struct pci_de
 		.port_ops = &atiixp_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, &info };
-	struct ata_host *host;
-	int rc;
 
-	/* enable device and prepare host */
-	rc = pcim_enable_device(pdev);
-	if (rc)
-		return rc;
-
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
-	if (rc)
-		return rc;
-
-	host->flags |= ATA_HOST_PARALLEL_SCAN;
-
-	pci_set_master(pdev);
-
-	return ata_pci_sff_activate_host(host, ata_sff_interrupt, &atiixp_sht);
+	return __ata_pci_sff_init_one(pdev, ppi, &atiixp_sht, NULL, NULL,
+				      ATA_HOST_PARALLEL_SCAN);
 }
 
 static const struct pci_device_id atiixp[] = {
Index: b/drivers/ata/pata_cmd640.c
===================================================================
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -226,7 +226,7 @@ static int cmd640_init_one(struct pci_de
 	cmd640_hardware_init(&pdev->dev);
 
 	return __ata_pci_sff_init_one(pdev, ppi, &cmd640_sht, NULL,
-				      cmd640_hardware_init);
+				      cmd640_hardware_init, 0);
 }
 
 static const struct pci_device_id cmd640[] = {
Index: b/drivers/ata/pata_cs5530.c
===================================================================
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -150,7 +150,7 @@ static int cs5530_init_one(struct pci_de
 
 	/* Now kick off ATA set up */
 	return __ata_pci_sff_init_one(pdev, ppi, &cs5530_sht, NULL,
-				      cs5530_init_chip);
+				      cs5530_init_chip, 0);
 }
 
 static const struct pci_device_id cs5530[] = {
Index: b/drivers/ata/pata_efar.c
===================================================================
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -89,27 +89,13 @@ static int efar_init_one (struct pci_dev
 		.port_ops	= &efar_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, &info };
-	struct ata_host *host;
-	int rc;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	/* enable device and prepare host */
-	rc = pcim_enable_device(pdev);
-	if (rc)
-		return rc;
-
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
-	if (rc)
-		return rc;
-
-	host->flags |= ATA_HOST_PARALLEL_SCAN;
-
-	pci_set_master(pdev);
-
-	return ata_pci_sff_activate_host(host, ata_sff_interrupt, &efar_sht);
+	return __ata_pci_sff_init_one(pdev, ppi, &efar_sht, NULL, NULL,
+				      ATA_HOST_PARALLEL_SCAN);
 }
 
 static const struct pci_device_id efar_pci_tbl[] = {
Index: b/drivers/ata/pata_hpt366.c
===================================================================
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -413,7 +413,7 @@ static int hpt36x_init_one(struct pci_de
 	}
 	/* Now kick off ATA set up */
 	return __ata_pci_sff_init_one(dev, ppi, &hpt36x_sht, hpriv,
-				      hpt36x_init_chipset);
+				      hpt36x_init_chipset, 0);
 }
 
 static const struct pci_device_id hpt36x[] = {
Index: b/drivers/ata/pata_it821x.c
===================================================================
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -625,7 +625,7 @@ static int it821x_init_one(struct pci_de
 			ppi[0] = &info_smart;
 	}
 	return __ata_pci_sff_init_one(pdev, ppi, &it821x_sht, NULL,
-				      it821x_fixup);
+				      it821x_fixup, 0);
 }
 
 static const struct pci_device_id it821x[] = {
Index: b/drivers/ata/pata_ns87415.c
===================================================================
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -385,7 +385,7 @@ static int ns87415_init_one (struct pci_
 	ns87415_fixup(&pdev->dev);
 
 	return __ata_pci_sff_init_one(pdev, ppi, &ns87415_sht, NULL,
-				      ns87415_fixup);
+				      ns87415_fixup, 0);
 }
 
 static const struct pci_device_id ns87415_pci_tbl[] = {
Index: b/drivers/ata/pata_sl82c105.c
===================================================================
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -222,7 +222,7 @@ static int sl82c105_init_one(struct pci_
 	sl82c105_fixup(&dev->dev);
 
 	return __ata_pci_sff_init_one(dev, ppi, &sl82c105_sht, NULL,
-				      sl82c105_fixup);
+				      sl82c105_fixup, 0);
 }
 
 static const struct pci_device_id sl82c105[] = {
Index: b/include/linux/libata.h
===================================================================
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1605,12 +1605,12 @@ extern int ata_pci_sff_activate_host(str
 extern int __ata_pci_sff_init_one(struct pci_dev *pdev,
 				const struct ata_port_info * const *ppi,
 				struct scsi_host_template *sht, void *host_priv,
-				int (*init_host)(struct device *dev));
+				int (*init_host)(struct device *dev), int hflag);
 static inline int ata_pci_sff_init_one(struct pci_dev *pdev,
 				const struct ata_port_info * const *ppi,
 				struct scsi_host_template *sht, void *host_priv)
 {
-	return __ata_pci_sff_init_one(pdev, ppi, sht, host_priv, NULL);
+	return __ata_pci_sff_init_one(pdev, ppi, sht, host_priv, NULL, 0);
 }
 #endif /* CONFIG_PCI */
 
