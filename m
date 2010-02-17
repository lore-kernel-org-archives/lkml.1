Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab0BQNju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:39:50 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38165 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752043Ab0BQNjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:39:48 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/5] libata: Pass host flags into the pci helper
To: jeff@garzik.org.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Date: Wed, 17 Feb 2010 13:15:51 +0000
Message-ID: <20100217131532.16884.21696.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows parallel scan and the like to be set without having to stop
using the existing full helper functions. This patch merely adds the argument
and fixes up the callers. It doesn't undo the special cases already in the
tree or add any new parallel callers.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/ata/ata_generic.c       |    2 +-
 drivers/ata/libata-sff.c        |    6 ++++--
 drivers/ata/pata_acpi.c         |    2 +-
 drivers/ata/pata_ali.c          |    2 +-
 drivers/ata/pata_amd.c          |    2 +-
 drivers/ata/pata_artop.c        |    2 +-
 drivers/ata/pata_atiixp.c       |    2 +-
 drivers/ata/pata_cmd640.c       |    2 +-
 drivers/ata/pata_cmd64x.c       |    2 +-
 drivers/ata/pata_cs5530.c       |    2 +-
 drivers/ata/pata_cs5535.c       |    2 +-
 drivers/ata/pata_cs5536.c       |    2 +-
 drivers/ata/pata_cypress.c      |    2 +-
 drivers/ata/pata_efar.c         |    2 +-
 drivers/ata/pata_hpt366.c       |    2 +-
 drivers/ata/pata_hpt37x.c       |    2 +-
 drivers/ata/pata_hpt3x2n.c      |    2 +-
 drivers/ata/pata_it8213.c       |    2 +-
 drivers/ata/pata_it821x.c       |    2 +-
 drivers/ata/pata_jmicron.c      |    2 +-
 drivers/ata/pata_marvell.c      |    2 +-
 drivers/ata/pata_netcell.c      |    2 +-
 drivers/ata/pata_ns87410.c      |    2 +-
 drivers/ata/pata_ns87415.c      |    2 +-
 drivers/ata/pata_oldpiix.c      |    2 +-
 drivers/ata/pata_opti.c         |    2 +-
 drivers/ata/pata_optidma.c      |    2 +-
 drivers/ata/pata_pdc202xx_old.c |    2 +-
 drivers/ata/pata_piccolo.c      |    2 +-
 drivers/ata/pata_radisys.c      |    2 +-
 drivers/ata/pata_rz1000.c       |    2 +-
 drivers/ata/pata_sc1200.c       |    2 +-
 drivers/ata/pata_serverworks.c  |    2 +-
 drivers/ata/pata_sil680.c       |    2 +-
 drivers/ata/pata_sis.c          |    2 +-
 drivers/ata/pata_sl82c105.c     |    2 +-
 drivers/ata/pata_triflex.c      |    2 +-
 drivers/ata/pata_via.c          |    2 +-
 include/linux/libata.h          |    4 ++--
 39 files changed, 43 insertions(+), 41 deletions(-)


diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index abae7d5..7b605e5 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -156,7 +156,7 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 			return rc;
 		pcim_pin_device(dev);
 	}
-	return ata_pci_sff_init_one(dev, ppi, &generic_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &generic_sht, NULL, 0);
 }
 
 static struct pci_device_id ata_generic[] = {
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index fa18482..e0df1d3 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -3061,6 +3061,7 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_activate_host);
  *	@ppi: array of port_info, must be enough for two ports
  *	@sht: scsi_host_template to use when registering the host
  *	@host_priv: host private_data
+ *	@hflag: host flags
  *
  *	This is a helper function which can be called from a driver's
  *	xxx_init_one() probe function if the hardware uses traditional
@@ -3081,8 +3082,8 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_activate_host);
  *	Zero on success, negative on errno-based value on error.
  */
 int ata_pci_sff_init_one(struct pci_dev *pdev,
-			 const struct ata_port_info * const *ppi,
-			 struct scsi_host_template *sht, void *host_priv)
+		 const struct ata_port_info * const *ppi,
+		 struct scsi_host_template *sht, void *host_priv, int hflag)
 {
 	struct device *dev = &pdev->dev;
 	const struct ata_port_info *pi = NULL;
@@ -3117,6 +3118,7 @@ int ata_pci_sff_init_one(struct pci_dev *pdev,
 	if (rc)
 		goto out;
 	host->private_data = host_priv;
+	host->flags |= hflag;
 
 	pci_set_master(pdev);
 	rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index 6c5765b..d33f87f 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -260,7 +260,7 @@ static int pacpi_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 			return rc;
 		pcim_pin_device(pdev);
 	}
-	return ata_pci_sff_init_one(pdev, ppi, &pacpi_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &pacpi_sht, NULL, 0);
 }
 
 static const struct pci_device_id pacpi_pci_tbl[] = {
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 940bead..e79cb78 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -585,7 +585,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	        	ppi[0] = &info_20_udma;
 	}
 
-	return ata_pci_sff_init_one(pdev, ppi, &ali_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &ali_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 15faa9b..c128106 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -576,7 +576,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* And fire it up */
-	return ata_pci_sff_init_one(pdev, ppi, &amd_sht, hpriv);
+	return ata_pci_sff_init_one(pdev, ppi, &amd_sht, hpriv, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 31a28f1..6ed1de5 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -423,7 +423,7 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 
 	BUG_ON(ppi[0] == NULL);
 
-	return ata_pci_sff_init_one(pdev, ppi, &artop_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &artop_sht, NULL, 0);
 }
 
 static const struct pci_device_id artop_pci_tbl[] = {
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 3ded0e8..ec44a12 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -238,7 +238,7 @@ static int atiixp_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (!pci_test_config_bits(pdev, &atiixp_enable_bits[i]))
 			ppi[i] = &ata_dummy_port_info;
 
-	return ata_pci_sff_init_one(pdev, ppi, &atiixp_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &atiixp_sht, NULL, 0);
 }
 
 static const struct pci_device_id atiixp[] = {
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index 8a4b990..29d8bf6 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -224,7 +224,7 @@ static int cmd640_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	cmd640_hardware_init(pdev);
 
-	return ata_pci_sff_init_one(pdev, ppi, &cmd640_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &cmd640_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 305a473..5a438c4 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -368,7 +368,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
 #endif
 
-	return ata_pci_sff_init_one(pdev, ppi, &cmd64x_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &cmd64x_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index a299607..5244053 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -325,7 +325,7 @@ static int cs5530_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ppi[1] = &info_palmax_secondary;
 
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(pdev, ppi, &cs5530_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &cs5530_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index fe10ffd..0c470e7 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -199,7 +199,7 @@ static int cs5535_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	rdmsr(ATAC_CH0D1_PIO, timings, dummy);
 	if (CS5535_BAD_PIO(timings))
 		wrmsr(ATAC_CH0D1_PIO, 0xF7F4F7F4UL, 0);
-	return ata_pci_sff_init_one(dev, ppi, &cs5535_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &cs5535_sht, NULL, 0);
 }
 
 static const struct pci_device_id cs5535[] = {
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index c90a033..f354db9 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -261,7 +261,7 @@ static int cs5536_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		return -ENODEV;
 	}
 
-	return ata_pci_sff_init_one(dev, ppi, &cs5536_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &cs5536_sht, NULL, 0);
 }
 
 static const struct pci_device_id cs5536[] = {
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index ff6c37d..0fcc096 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -138,7 +138,7 @@ static int cy82c693_init_one(struct pci_dev *pdev, const struct pci_device_id *i
 	if (PCI_FUNC(pdev->devfn) != 1)
 		return -ENODEV;
 
-	return ata_pci_sff_init_one(pdev, ppi, &cy82c693_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &cy82c693_sht, NULL, 0);
 }
 
 static const struct pci_device_id cy82c693[] = {
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index fedc121..9f55541 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -263,7 +263,7 @@ static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &efar_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &efar_sht, NULL, 0);
 }
 
 static const struct pci_device_id efar_pci_tbl[] = {
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 6bb4b52..66a7036 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -362,7 +362,7 @@ static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 			break;
 	}
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(dev, ppi, &hpt36x_sht, hpriv);
+	return ata_pci_sff_init_one(dev, ppi, &hpt36x_sht, hpriv, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index ba398bd..3cf48b8 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -989,7 +989,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	}
 
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(dev, ppi, &hpt37x_sht, private_data);
+	return ata_pci_sff_init_one(dev, ppi, &hpt37x_sht, private_data, 0);
 }
 
 static const struct pci_device_id hpt37x[] = {
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index c396a94..c69c871 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -549,7 +549,7 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		outb(inb(iobase + 0x9c) | 0x04, iobase + 0x9c);
 
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(dev, ppi, &hpt3x2n_sht, hpriv);
+	return ata_pci_sff_init_one(dev, ppi, &hpt3x2n_sht, hpriv, 0);
 }
 
 static const struct pci_device_id hpt3x2n[] = {
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index 378be4f..daace8f 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -274,7 +274,7 @@ static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &it8213_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &it8213_sht, NULL, 0);
 }
 
 static const struct pci_device_id it8213_pci_tbl[] = {
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index bc5801d..a3aef1f 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -934,7 +934,7 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		else
 			ppi[0] = &info_smart;
 	}
-	return ata_pci_sff_init_one(pdev, ppi, &it821x_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &it821x_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index ba43bd3..a28382b 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -145,7 +145,7 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	return ata_pci_sff_init_one(pdev, ppi, &jmicron_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &jmicron_sht, NULL, 0);
 }
 
 static const struct pci_device_id jmicron_pci_tbl[] = {
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 4031bfd..8da0c82 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -154,7 +154,7 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 		return -ENODEV;
 	}
 #endif
-	return ata_pci_sff_init_one(pdev, ppi, &marvell_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &marvell_sht, NULL, 0);
 }
 
 static const struct pci_device_id marvell_pci_tbl[] = {
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index 7472fad..5fea4d7 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -83,7 +83,7 @@ static int netcell_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	ata_pci_bmdma_clear_simplex(pdev);
 
 	/* And let the library code do the work */
-	return ata_pci_sff_init_one(pdev, port_info, &netcell_sht, NULL);
+	return ata_pci_sff_init_one(pdev, port_info, &netcell_sht, NULL, 0);
 }
 
 static const struct pci_device_id netcell_pci_tbl[] = {
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index 7d2a866..205c3d2 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -149,7 +149,7 @@ static int ns87410_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.port_ops = &ns87410_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
-	return ata_pci_sff_init_one(dev, ppi, &ns87410_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &ns87410_sht, NULL, 0);
 }
 
 static const struct pci_device_id ns87410[] = {
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index 6f7c647..ed46f57 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -381,7 +381,7 @@ static int ns87415_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 
 	ns87415_fixup(pdev);
 
-	return ata_pci_sff_init_one(pdev, ppi, &ns87415_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &ns87415_sht, NULL, 0);
 }
 
 static const struct pci_device_id ns87415_pci_tbl[] = {
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index f49c60f..1fd531a 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -249,7 +249,7 @@ static int oldpiix_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &oldpiix_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &oldpiix_sht, NULL, 0);
 }
 
 static const struct pci_device_id oldpiix_pci_tbl[] = {
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index c4f436a..f2dedbb 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -173,7 +173,7 @@ static int opti_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &dev->dev, "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(dev, ppi, &opti_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &opti_sht, NULL, 0);
 }
 
 static const struct pci_device_id opti[] = {
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index ab36c1b..58d32f2 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -430,7 +430,7 @@ static int optidma_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (optiplus_with_udma(dev))
 		ppi[0] = &info_82c700_udma;
 
-	return ata_pci_sff_init_one(dev, ppi, &optidma_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &optidma_sht, NULL, 0);
 }
 
 static const struct pci_device_id optidma[] = {
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index 28e42eb..0731e90 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -338,7 +338,7 @@ static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id
 				return -ENODEV;
 		}
 	}
-	return ata_pci_sff_init_one(dev, ppi, &pdc202xx_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &pdc202xx_sht, NULL, 0);
 }
 
 static const struct pci_device_id pdc202xx[] = {
diff --git a/drivers/ata/pata_piccolo.c b/drivers/ata/pata_piccolo.c
index 38bd4f1..05c85a8 100644
--- a/drivers/ata/pata_piccolo.c
+++ b/drivers/ata/pata_piccolo.c
@@ -96,7 +96,7 @@ static int ata_tosh_init_one(struct pci_dev *dev, const struct pci_device_id *id
 	};
 	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
 	/* Just one port for the moment */
-	return ata_pci_sff_init_one(dev, ppi, &tosh_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &tosh_sht, NULL, 0);
 }
 
 static struct pci_device_id ata_tosh[] = {
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 7390e2d..c376682 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -228,7 +228,7 @@ static int radisys_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &radisys_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &radisys_sht, NULL, 0);
 }
 
 static const struct pci_device_id radisys_pci_tbl[] = {
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index ab4e6cc..5f83a76 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -96,7 +96,7 @@ static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 	printk_once(KERN_DEBUG DRV_NAME " version " DRV_VERSION "\n");
 
 	if (rz1000_fifo_disable(pdev) == 0)
-		return ata_pci_sff_init_one(pdev, ppi, &rz1000_sht, NULL);
+		return ata_pci_sff_init_one(pdev, ppi, &rz1000_sht, NULL, 0);
 
 	printk(KERN_ERR DRV_NAME ": failed to disable read-ahead on chipset..\n");
 	/* Not safe to use so skip */
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index 8739ccc..2cc3463 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -238,7 +238,7 @@ static int sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	return ata_pci_sff_init_one(dev, ppi, &sc1200_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &sc1200_sht, NULL, 0);
 }
 
 static const struct pci_device_id sc1200[] = {
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 6714adf..8745349 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -461,7 +461,7 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 	if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE)
 		ata_pci_bmdma_clear_simplex(pdev);
 
-	return ata_pci_sff_init_one(pdev, ppi, &serverworks_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &serverworks_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 065339d..43faf10 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -378,7 +378,7 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 				 IRQF_SHARED, &sil680_sht);
 
 use_ioports:
-	return ata_pci_sff_init_one(pdev, ppi, &sil680_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &sil680_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 3d9a940..aca9064 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -828,7 +828,7 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	sis_fixup(pdev, chipset);
 
-	return ata_pci_sff_init_one(pdev, ppi, &sis_sht, chipset);
+	return ata_pci_sff_init_one(pdev, ppi, &sis_sht, chipset, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 29f733c..733b042 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -316,7 +316,7 @@ static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id
 	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
 	pci_write_config_dword(dev, 0x40, val);
 
-	return ata_pci_sff_init_one(dev, ppi, &sl82c105_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &sl82c105_sht, NULL, 0);
 }
 
 static const struct pci_device_id sl82c105[] = {
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index 1a40ded..61520dc 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -202,7 +202,7 @@ static int triflex_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &dev->dev, "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(dev, ppi, &triflex_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &triflex_sht, NULL, 0);
 }
 
 static const struct pci_device_id triflex[] = {
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 671e0cb..eb29a38 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -623,7 +623,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* We have established the device type, now fire it up */
-	return ata_pci_sff_init_one(pdev, ppi, &via_sht, (void *)config);
+	return ata_pci_sff_init_one(pdev, ppi, &via_sht, (void *)config, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/include/linux/libata.h b/include/linux/libata.h
index ac70e4d..18fb694 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1646,8 +1646,8 @@ extern int ata_pci_sff_activate_host(struct ata_host *host,
 				     irq_handler_t irq_handler,
 				     struct scsi_host_template *sht);
 extern int ata_pci_sff_init_one(struct pci_dev *pdev,
-				const struct ata_port_info * const * ppi,
-				struct scsi_host_template *sht, void *host_priv);
+		const struct ata_port_info * const * ppi,
+		struct scsi_host_template *sht, void *host_priv, int hflags);
 #endif /* CONFIG_PCI */
 
 /**

