Return-Path: <linux-kernel-owner+w=401wt.eu-S2992897AbXCCBqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992897AbXCCBqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992896AbXCCBqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:46:08 -0500
Received: from havoc.gtf.org ([69.61.125.42]:34644 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992895AbXCCBqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:46:04 -0500
Date: Fri, 2 Mar 2007 20:46:02 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070303014602.GA10715@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Notes:
1) The patches credited to me are really extractions of Alan's patches.

2) In particular, the 'change master/slave IDENTIFY order' has a wide
(but hopefully not negative) impact, as mentioned in the thread.  Since
pata_* drivers are Officially(tm) considered more experimental than
drivers/ide, and since most SATA devices are one-per-port (no slave),
the biggest consideration is really master/slave on ata_piix.

3) Tejun's CONFIG_PM stuff might look like a cleanup, but IMO it is
indeed a bug fix.  As Nigel C noted in the related thread, this can
probably be cleaned up further with some hopeful macros, but let's go
ahead and get things compiling correctly.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c              |   14 ++++++++++++++
 drivers/ata/ata_generic.c       |    4 ++++
 drivers/ata/ata_piix.c          |    4 ++++
 drivers/ata/libata-core.c       |   32 +++++++++++++++++++++++++++-----
 drivers/ata/libata-eh.c         |   29 +++++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c       |    2 ++
 drivers/ata/pata_ali.c          |    6 ++++++
 drivers/ata/pata_amd.c          |    6 ++++++
 drivers/ata/pata_atiixp.c       |    4 ++++
 drivers/ata/pata_cmd64x.c       |    8 +++++++-
 drivers/ata/pata_cs5520.c       |    6 ++++++
 drivers/ata/pata_cs5530.c       |    6 ++++++
 drivers/ata/pata_cs5535.c       |    4 ++++
 drivers/ata/pata_cypress.c      |    4 ++++
 drivers/ata/pata_efar.c         |    4 ++++
 drivers/ata/pata_hpt366.c       |    7 ++++++-
 drivers/ata/pata_hpt3x3.c       |    6 ++++++
 drivers/ata/pata_it8213.c       |    4 ++++
 drivers/ata/pata_it821x.c       |    6 ++++++
 drivers/ata/pata_jmicron.c      |    7 +++++++
 drivers/ata/pata_legacy.c       |   18 ++++++++++++++++++
 drivers/ata/pata_marvell.c      |    4 ++++
 drivers/ata/pata_mpc52xx.c      |    4 ++++
 drivers/ata/pata_mpiix.c        |    4 ++++
 drivers/ata/pata_netcell.c      |    4 ++++
 drivers/ata/pata_ns87410.c      |    4 ++++
 drivers/ata/pata_oldpiix.c      |    4 ++++
 drivers/ata/pata_opti.c         |    4 ++++
 drivers/ata/pata_optidma.c      |    4 ++++
 drivers/ata/pata_pdc202xx_old.c |    4 ++++
 drivers/ata/pata_qdi.c          |   12 ++++++++----
 drivers/ata/pata_radisys.c      |    4 ++++
 drivers/ata/pata_rz1000.c       |    6 ++++++
 drivers/ata/pata_sc1200.c       |    7 +++++++
 drivers/ata/pata_scc.c          |    2 ++
 drivers/ata/pata_serverworks.c  |    6 ++++++
 drivers/ata/pata_sil680.c       |    8 ++++++++
 drivers/ata/pata_sis.c          |    4 ++++
 drivers/ata/pata_sl82c105.c     |    3 +++
 drivers/ata/pata_triflex.c      |    4 ++++
 drivers/ata/pata_via.c          |    6 ++++++
 drivers/ata/sata_inic162x.c     |    7 ++++++-
 drivers/ata/sata_nv.c           |   16 ++++++++++++++++
 drivers/ata/sata_sil.c          |    2 ++
 drivers/ata/sata_sil24.c        |    2 ++
 include/linux/libata.h          |    7 +++++--
 46 files changed, 299 insertions(+), 14 deletions(-)

Alan Cox (2):
      libata-core: Fix simplex handling
      pata_qdi: Fix initialisation

Jeff Garzik (3):
      [libata] change master/slave IDENTIFY order
      [libata] pata_{legacy,sc1200,sl82c105}: add missing hooks
      [libata] pata_cmd64x: fix driver description in comments

Tejun Heo (3):
      libata: add missing PM callbacks
      libata: add missing CONFIG_PM in LLDs
      libata: add CONFIG_PM to libata core layer

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 1539734..43cc43d 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -219,10 +219,12 @@ static void ahci_thaw(struct ata_port *ap);
 static void ahci_error_handler(struct ata_port *ap);
 static void ahci_vt8251_error_handler(struct ata_port *ap);
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
+#ifdef CONFIG_PM
 static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
 static int ahci_port_resume(struct ata_port *ap);
 static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int ahci_pci_device_resume(struct pci_dev *pdev);
+#endif
 
 static struct scsi_host_template ahci_sht = {
 	.module			= THIS_MODULE,
@@ -241,8 +243,10 @@ static struct scsi_host_template ahci_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.suspend		= ata_scsi_device_suspend,
 	.resume			= ata_scsi_device_resume,
+#endif
 };
 
 static const struct ata_port_operations ahci_ops = {
@@ -271,8 +275,10 @@ static const struct ata_port_operations ahci_ops = {
 	.error_handler		= ahci_error_handler,
 	.post_internal_cmd	= ahci_post_internal_cmd,
 
+#ifdef CONFIG_PM
 	.port_suspend		= ahci_port_suspend,
 	.port_resume		= ahci_port_resume,
+#endif
 
 	.port_start		= ahci_port_start,
 	.port_stop		= ahci_port_stop,
@@ -304,8 +310,10 @@ static const struct ata_port_operations ahci_vt8251_ops = {
 	.error_handler		= ahci_vt8251_error_handler,
 	.post_internal_cmd	= ahci_post_internal_cmd,
 
+#ifdef CONFIG_PM
 	.port_suspend		= ahci_port_suspend,
 	.port_resume		= ahci_port_resume,
+#endif
 
 	.port_start		= ahci_port_start,
 	.port_stop		= ahci_port_stop,
@@ -436,8 +444,10 @@ static struct pci_driver ahci_pci_driver = {
 	.id_table		= ahci_pci_tbl,
 	.probe			= ahci_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend		= ahci_pci_device_suspend,
 	.resume			= ahci_pci_device_resume,
+#endif
 };
 
 
@@ -577,6 +587,7 @@ static void ahci_power_up(void __iomem *port_mmio, u32 cap)
 	writel(cmd | PORT_CMD_ICC_ACTIVE, port_mmio + PORT_CMD);
 }
 
+#ifdef CONFIG_PM
 static void ahci_power_down(void __iomem *port_mmio, u32 cap)
 {
 	u32 cmd, scontrol;
@@ -594,6 +605,7 @@ static void ahci_power_down(void __iomem *port_mmio, u32 cap)
 	cmd &= ~PORT_CMD_SPIN_UP;
 	writel(cmd, port_mmio + PORT_CMD);
 }
+#endif
 
 static void ahci_init_port(void __iomem *port_mmio, u32 cap,
 			   dma_addr_t cmd_slot_dma, dma_addr_t rx_fis_dma)
@@ -1335,6 +1347,7 @@ static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
 	}
 }
 
+#ifdef CONFIG_PM
 static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 {
 	struct ahci_host_priv *hpriv = ap->host->private_data;
@@ -1413,6 +1426,7 @@ static int ahci_pci_device_resume(struct pci_dev *pdev)
 
 	return 0;
 }
+#endif
 
 static int ahci_port_start(struct ata_port *ap)
 {
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index f48b488..d8e7988 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -119,8 +119,10 @@ static struct scsi_host_template generic_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations generic_port_ops = {
@@ -230,8 +232,10 @@ static struct pci_driver ata_generic_pci_driver = {
 	.id_table	= ata_generic,
 	.probe 		= ata_generic_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
+#endif
 };
 
 static int __init ata_generic_init(void)
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 61572d8..dc42ba1 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -253,8 +253,10 @@ static struct pci_driver piix_pci_driver = {
 	.id_table		= piix_pci_tbl,
 	.probe			= piix_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
+#endif
 };
 
 static struct scsi_host_template piix_sht = {
@@ -273,8 +275,10 @@ static struct scsi_host_template piix_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static const struct ata_port_operations piix_pata_ops = {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ac3d120..dc362fa 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1850,8 +1850,11 @@ int ata_bus_probe(struct ata_port *ap)
 	for (i = 0; i < ATA_MAX_DEVICES; i++)
 		ap->device[i].pio_mode = XFER_PIO_0;
 
-	/* read IDENTIFY page and configure devices */
-	for (i = 0; i < ATA_MAX_DEVICES; i++) {
+	/* read IDENTIFY page and configure devices. We have to do the identify
+	   specific sequence bass-ackwards so that PDIAG- is released by
+	   the slave device */
+
+	for (i = ATA_MAX_DEVICES - 1; i >=  0; i--) {
 		dev = &ap->device[i];
 
 		if (tries[i])
@@ -1864,6 +1867,15 @@ int ata_bus_probe(struct ata_port *ap)
 				     dev->id);
 		if (rc)
 			goto fail;
+	}
+
+	/* After the identify sequence we can now set up the devices. We do
+	   this in the normal order so that the user doesn't get confused */
+
+	for(i = 0; i < ATA_MAX_DEVICES; i++) {
+		dev = &ap->device[i];
+		if (!ata_dev_enabled(dev))
+			continue;
 
 		ap->eh_context.i.flags |= ATA_EHI_PRINTINFO;
 		rc = ata_dev_configure(dev);
@@ -2556,12 +2568,11 @@ int ata_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev)
 	 * host channels are not permitted to do so.
 	 */
 	if (used_dma && (ap->host->flags & ATA_HOST_SIMPLEX))
-		ap->host->simplex_claimed = 1;
+		ap->host->simplex_claimed = ap;
 
 	/* step5: chip specific finalisation */
 	if (ap->ops->post_set_mode)
 		ap->ops->post_set_mode(ap);
-
  out:
 	if (rc)
 		*r_failed_dev = dev;
@@ -3444,7 +3455,7 @@ static void ata_dev_xfermask(struct ata_device *dev)
 			       "device is on DMA blacklist, disabling DMA\n");
 	}
 
-	if ((host->flags & ATA_HOST_SIMPLEX) && host->simplex_claimed) {
+	if ((host->flags & ATA_HOST_SIMPLEX) && host->simplex_claimed != ap) {
 		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
 		ata_dev_printk(dev, KERN_WARNING, "simplex DMA is claimed by "
 			       "other device, disabling DMA\n");
@@ -5343,6 +5354,7 @@ int ata_flush_cache(struct ata_device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
 			       unsigned int action, unsigned int ehi_flags,
 			       int wait)
@@ -5458,6 +5470,7 @@ void ata_host_resume(struct ata_host *host)
 			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
 	host->dev->power.power_state = PMSG_ON;
 }
+#endif
 
 /**
  *	ata_port_start - Set port up for dma.
@@ -6093,6 +6106,7 @@ int pci_test_config_bits(struct pci_dev *pdev, const struct pci_bits *bits)
 	return (tmp == bits->val) ? 1 : 0;
 }
 
+#ifdef CONFIG_PM
 void ata_pci_device_do_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
 	pci_save_state(pdev);
@@ -6144,6 +6158,8 @@ int ata_pci_device_resume(struct pci_dev *pdev)
 		ata_host_resume(host);
 	return rc;
 }
+#endif /* CONFIG_PM */
+
 #endif /* CONFIG_PCI */
 
 
@@ -6352,8 +6368,10 @@ EXPORT_SYMBOL_GPL(sata_scr_write);
 EXPORT_SYMBOL_GPL(sata_scr_write_flush);
 EXPORT_SYMBOL_GPL(ata_port_online);
 EXPORT_SYMBOL_GPL(ata_port_offline);
+#ifdef CONFIG_PM
 EXPORT_SYMBOL_GPL(ata_host_suspend);
 EXPORT_SYMBOL_GPL(ata_host_resume);
+#endif /* CONFIG_PM */
 EXPORT_SYMBOL_GPL(ata_id_string);
 EXPORT_SYMBOL_GPL(ata_id_c_string);
 EXPORT_SYMBOL_GPL(ata_id_to_dma_mode);
@@ -6369,16 +6387,20 @@ EXPORT_SYMBOL_GPL(pci_test_config_bits);
 EXPORT_SYMBOL_GPL(ata_pci_init_native_mode);
 EXPORT_SYMBOL_GPL(ata_pci_init_one);
 EXPORT_SYMBOL_GPL(ata_pci_remove_one);
+#ifdef CONFIG_PM
 EXPORT_SYMBOL_GPL(ata_pci_device_do_suspend);
 EXPORT_SYMBOL_GPL(ata_pci_device_do_resume);
 EXPORT_SYMBOL_GPL(ata_pci_device_suspend);
 EXPORT_SYMBOL_GPL(ata_pci_device_resume);
+#endif /* CONFIG_PM */
 EXPORT_SYMBOL_GPL(ata_pci_default_filter);
 EXPORT_SYMBOL_GPL(ata_pci_clear_simplex);
 #endif /* CONFIG_PCI */
 
+#ifdef CONFIG_PM
 EXPORT_SYMBOL_GPL(ata_scsi_device_suspend);
 EXPORT_SYMBOL_GPL(ata_scsi_device_resume);
+#endif /* CONFIG_PM */
 
 EXPORT_SYMBOL_GPL(ata_eng_timeout);
 EXPORT_SYMBOL_GPL(ata_port_schedule_eh);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index cad0d6d..7349c3d 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -52,8 +52,33 @@ enum {
 
 static void __ata_port_freeze(struct ata_port *ap);
 static void ata_eh_finish(struct ata_port *ap);
+#ifdef CONFIG_PM
 static void ata_eh_handle_port_suspend(struct ata_port *ap);
 static void ata_eh_handle_port_resume(struct ata_port *ap);
+static int ata_eh_suspend(struct ata_port *ap,
+			  struct ata_device **r_failed_dev);
+static void ata_eh_prep_resume(struct ata_port *ap);
+static int ata_eh_resume(struct ata_port *ap, struct ata_device **r_failed_dev);
+#else /* CONFIG_PM */
+static void ata_eh_handle_port_suspend(struct ata_port *ap)
+{ }
+
+static void ata_eh_handle_port_resume(struct ata_port *ap)
+{ }
+
+static int ata_eh_suspend(struct ata_port *ap, struct ata_device **r_failed_dev)
+{
+	return 0;
+}
+
+static void ata_eh_prep_resume(struct ata_port *ap)
+{ }
+
+static int ata_eh_resume(struct ata_port *ap, struct ata_device **r_failed_dev)
+{
+	return 0;
+}
+#endif /* CONFIG_PM */
 
 static void ata_ering_record(struct ata_ering *ering, int is_io,
 			     unsigned int err_mask)
@@ -1790,6 +1815,7 @@ static int ata_eh_revalidate_and_attach(struct ata_port *ap,
 	return rc;
 }
 
+#ifdef CONFIG_PM
 /**
  *	ata_eh_suspend - handle suspend EH action
  *	@ap: target host port
@@ -1947,6 +1973,7 @@ static int ata_eh_resume(struct ata_port *ap, struct ata_device **r_failed_dev)
 	DPRINTK("EXIT\n");
 	return 0;
 }
+#endif /* CONFIG_PM */
 
 static int ata_port_nr_enabled(struct ata_port *ap)
 {
@@ -2249,6 +2276,7 @@ void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
 	ata_eh_finish(ap);
 }
 
+#ifdef CONFIG_PM
 /**
  *	ata_eh_handle_port_suspend - perform port suspend operation
  *	@ap: port to suspend
@@ -2364,3 +2392,4 @@ static void ata_eh_handle_port_resume(struct ata_port *ap)
 	}
 	spin_unlock_irqrestore(ap->lock, flags);
 }
+#endif /* CONFIG_PM */
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 00a9a6c..6cc817a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -510,6 +510,7 @@ static void ata_dump_status(unsigned id, struct ata_taskfile *tf)
 	}
 }
 
+#ifdef CONFIG_PM
 /**
  *	ata_scsi_device_suspend - suspend ATA device associated with sdev
  *	@sdev: the SCSI device to suspend
@@ -634,6 +635,7 @@ int ata_scsi_device_resume(struct scsi_device *sdev)
 	sdev->sdev_gendev.power.power_state = PMSG_ON;
 	return 0;
 }
+#endif /* CONFIG_PM */
 
 /**
  *	ata_to_sense_error - convert ATA error to SCSI error
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index a90ed00..11ea552 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -345,8 +345,10 @@ static struct scsi_host_template ali_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 /*
@@ -667,11 +669,13 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ata_pci_init_one(pdev, port_info, 2);
 }
 
+#ifdef CONFIG_PM
 static int ali_reinit_one(struct pci_dev *pdev)
 {
 	ali_init_chipset(pdev);
 	return ata_pci_device_resume(pdev);
 }
+#endif
 
 static const struct pci_device_id ali[] = {
 	{ PCI_VDEVICE(AL, PCI_DEVICE_ID_AL_M5228), },
@@ -685,8 +689,10 @@ static struct pci_driver ali_pci_driver = {
 	.id_table	= ali,
 	.probe 		= ali_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ali_reinit_one,
+#endif
 };
 
 static int __init ali_init(void)
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 3c760d0..1838176 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -334,8 +334,10 @@ static struct scsi_host_template amd_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations amd33_port_ops = {
@@ -663,6 +665,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ata_pci_init_one(pdev, port_info, 2);
 }
 
+#ifdef CONFIG_PM
 static int amd_reinit_one(struct pci_dev *pdev)
 {
 	if (pdev->vendor == PCI_VENDOR_ID_AMD) {
@@ -679,6 +682,7 @@ static int amd_reinit_one(struct pci_dev *pdev)
 	}
 	return ata_pci_device_resume(pdev);
 }
+#endif
 
 static const struct pci_device_id amd[] = {
 	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_COBRA_7401),		0 },
@@ -708,8 +712,10 @@ static struct pci_driver amd_pci_driver = {
 	.id_table	= amd,
 	.probe 		= amd_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= amd_reinit_one,
+#endif
 };
 
 static int __init amd_init(void)
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index c3eb40c..51d9923 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -224,8 +224,10 @@ static struct scsi_host_template atiixp_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations atiixp_port_ops = {
@@ -290,8 +292,10 @@ static struct pci_driver atiixp_pci_driver = {
 	.id_table	= atiixp,
 	.probe 		= atiixp_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.resume		= ata_pci_device_resume,
 	.suspend	= ata_pci_device_suspend,
+#endif
 };
 
 static int __init atiixp_init(void)
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index da09828..5b13bdd 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -1,5 +1,5 @@
 /*
- * pata_cmd64x.c 	- ATI PATA for new ATA layer
+ * pata_cmd64x.c 	- CMD64x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@redhat.com>
  *
@@ -285,8 +285,10 @@ static struct scsi_host_template cmd64x_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations cmd64x_port_ops = {
@@ -479,6 +481,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ata_pci_init_one(pdev, port_info, 2);
 }
 
+#ifdef CONFIG_PM
 static int cmd64x_reinit_one(struct pci_dev *pdev)
 {
 	u8 mrdmode;
@@ -492,6 +495,7 @@ static int cmd64x_reinit_one(struct pci_dev *pdev)
 #endif
 	return ata_pci_device_resume(pdev);
 }
+#endif
 
 static const struct pci_device_id cmd64x[] = {
 	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_643), 0 },
@@ -507,8 +511,10 @@ static struct pci_driver cmd64x_pci_driver = {
 	.id_table	= cmd64x,
 	.probe 		= cmd64x_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= cmd64x_reinit_one,
+#endif
 };
 
 static int __init cmd64x_init(void)
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 8ff2d58..7ef8342 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -167,8 +167,10 @@ static struct scsi_host_template cs5520_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations cs5520_port_ops = {
@@ -308,6 +310,7 @@ static void __devexit cs5520_remove_one(struct pci_dev *pdev)
 	ata_host_detach(host);
 }
 
+#ifdef CONFIG_PM
 /**
  *	cs5520_reinit_one	-	device resume
  *	@pdev: PCI device
@@ -347,6 +350,7 @@ static int cs5520_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 	pci_save_state(pdev);
 	return 0;
 }
+#endif /* CONFIG_PM */
 
 /* For now keep DMA off. We can set it for all but A rev CS5510 once the
    core ATA code can handle it */
@@ -363,8 +367,10 @@ static struct pci_driver cs5520_pci_driver = {
 	.id_table	= pata_cs5520,
 	.probe 		= cs5520_init_one,
 	.remove		= cs5520_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= cs5520_pci_device_suspend,
 	.resume		= cs5520_reinit_one,
+#endif
 };
 
 static int __init cs5520_init(void)
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index 78c7cdf..db63e80 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -188,8 +188,10 @@ static struct scsi_host_template cs5530_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations cs5530_port_ops = {
@@ -376,6 +378,7 @@ static int cs5530_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ata_pci_init_one(pdev, port_info, 2);
 }
 
+#ifdef CONFIG_PM
 static int cs5530_reinit_one(struct pci_dev *pdev)
 {
 	/* If we fail on resume we are doomed */
@@ -383,6 +386,7 @@ static int cs5530_reinit_one(struct pci_dev *pdev)
 		BUG();
 	return ata_pci_device_resume(pdev);
 }
+#endif /* CONFIG_PM */
 
 static const struct pci_device_id cs5530[] = {
 	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5530_IDE), },
@@ -395,8 +399,10 @@ static struct pci_driver cs5530_pci_driver = {
 	.id_table	= cs5530,
 	.probe 		= cs5530_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= cs5530_reinit_one,
+#endif
 };
 
 static int __init cs5530_init(void)
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index 17bc693..1572e5c 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -185,8 +185,10 @@ static struct scsi_host_template cs5535_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations cs5535_port_ops = {
@@ -270,8 +272,10 @@ static struct pci_driver cs5535_pci_driver = {
 	.id_table	= cs5535,
 	.probe 		= cs5535_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
+#endif
 };
 
 static int __init cs5535_init(void)
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index 63f48f0..f69dde5 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -136,8 +136,10 @@ static struct scsi_host_template cy82c693_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations cy82c693_port_ops = {
@@ -206,8 +208,10 @@ static struct pci_driver cy82c693_pci_driver = {
 	.id_table	= cy82c693,
 	.probe 		= cy82c693_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
+#endif
 };
 
 static int __init cy82c693_init(void)
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index c19b6a8..dac7a65 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -234,8 +234,10 @@ static struct scsi_host_template efar_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static const struct ata_port_operations efar_ops = {
@@ -317,8 +319,10 @@ static struct pci_driver efar_pci_driver = {
 	.id_table		= efar_pci_tbl,
 	.probe			= efar_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
+#endif
 };
 
 static int __init efar_init(void)
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index e7d33c6..baf35f8 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -328,8 +328,10 @@ static struct scsi_host_template hpt36x_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 /*
@@ -457,12 +459,13 @@ static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	return ata_pci_init_one(dev, port_info, 2);
 }
 
+#ifdef CONFIG_PM
 static int hpt36x_reinit_one(struct pci_dev *dev)
 {
 	hpt36x_init_chipset(dev);
 	return ata_pci_device_resume(dev);
 }
-
+#endif
 
 static const struct pci_device_id hpt36x[] = {
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT366), },
@@ -474,8 +477,10 @@ static struct pci_driver hpt36x_pci_driver = {
 	.id_table	= hpt36x,
 	.probe 		= hpt36x_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= hpt36x_reinit_one,
+#endif
 };
 
 static int __init hpt36x_init(void)
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index 483ce7c..813485c 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -119,8 +119,10 @@ static struct scsi_host_template hpt3x3_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations hpt3x3_port_ops = {
@@ -206,11 +208,13 @@ static int hpt3x3_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	return ata_pci_init_one(dev, port_info, 2);
 }
 
+#ifdef CONFIG_PM
 static int hpt3x3_reinit_one(struct pci_dev *dev)
 {
 	hpt3x3_init_chipset(dev);
 	return ata_pci_device_resume(dev);
 }
+#endif
 
 static const struct pci_device_id hpt3x3[] = {
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT343), },
@@ -223,8 +227,10 @@ static struct pci_driver hpt3x3_pci_driver = {
 	.id_table	= hpt3x3,
 	.probe 		= hpt3x3_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= hpt3x3_reinit_one,
+#endif
 };
 
 static int __init hpt3x3_init(void)
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index 7eac869..ea73470 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -246,8 +246,10 @@ static struct scsi_host_template it8213_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static const struct ata_port_operations it8213_ops = {
@@ -330,8 +332,10 @@ static struct pci_driver it8213_pci_driver = {
 	.id_table		= it8213_pci_tbl,
 	.probe			= it8213_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
+#endif
 };
 
 static int __init it8213_init(void)
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 903137a..35ecb2b 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -646,8 +646,10 @@ static struct scsi_host_template it821x_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations it821x_smart_port_ops = {
@@ -780,6 +782,7 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ata_pci_init_one(pdev, port_info, 2);
 }
 
+#ifdef CONFIG_PM
 static int it821x_reinit_one(struct pci_dev *pdev)
 {
 	/* Resume - turn raid back off if need be */
@@ -787,6 +790,7 @@ static int it821x_reinit_one(struct pci_dev *pdev)
 		it821x_disable_raid(pdev);
 	return ata_pci_device_resume(pdev);
 }
+#endif
 
 static const struct pci_device_id it821x[] = {
 	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8211), },
@@ -800,8 +804,10 @@ static struct pci_driver it821x_pci_driver = {
 	.id_table	= it821x,
 	.probe 		= it821x_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= it821x_reinit_one,
+#endif
 };
 
 static int __init it821x_init(void)
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 47d0f94..033319e 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -137,6 +137,10 @@ static struct scsi_host_template jmicron_sht = {
 	.slave_destroy		= ata_scsi_slave_destroy,
 	/* Use standard CHS mapping rules */
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
+	.suspend		= ata_scsi_device_suspend,
+	.resume			= ata_scsi_device_resume,
+#endif
 };
 
 static const struct ata_port_operations jmicron_ops = {
@@ -225,8 +229,10 @@ static struct pci_driver jmicron_pci_driver = {
 	.id_table		= jmicron_pci_tbl,
 	.probe			= jmicron_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
+#endif
 };
 
 static int __init jmicron_init(void)
@@ -238,6 +244,7 @@ static void __exit jmicron_exit(void)
 {
 	pci_unregister_driver(&jmicron_pci_driver);
 }
+#endif
 
 module_init(jmicron_init);
 module_exit(jmicron_exit);
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 6ee61c6..fc5b73d 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -186,7 +186,10 @@ static struct ata_port_operations legacy_port_ops = {
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -298,7 +301,10 @@ static struct ata_port_operations pdc20230_port_ops = {
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -350,7 +356,10 @@ static struct ata_port_operations ht6560a_port_ops = {
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -413,7 +422,10 @@ static struct ata_port_operations ht6560b_port_ops = {
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -531,7 +543,10 @@ static struct ata_port_operations opti82c611a_port_ops = {
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -661,7 +676,10 @@ static struct ata_port_operations opti82c46x_port_ops = {
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= opti82c46x_qc_issue_prot,
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 13a70ac..6dd7c4e 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -103,8 +103,10 @@ static struct scsi_host_template marvell_sht = {
 	.slave_destroy		= ata_scsi_slave_destroy,
 	/* Use standard CHS mapping rules */
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static const struct ata_port_operations marvell_ops = {
@@ -199,8 +201,10 @@ static struct pci_driver marvell_pci_driver = {
 	.id_table		= marvell_pci_tbl,
 	.probe			= marvell_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
+#endif
 };
 
 static int __init marvell_init(void)
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 29e1809..f5d8872 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -280,6 +280,10 @@ static struct scsi_host_template mpc52xx_ata_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
+	.suspend		= ata_scsi_device_suspend,
+	.resume			= ata_scsi_device_resume,
+#endif
 };
 
 static struct ata_port_operations mpc52xx_ata_port_ops = {
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index f2e7115..4abe45a 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -165,8 +165,10 @@ static struct scsi_host_template mpiix_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations mpiix_port_ops = {
@@ -270,8 +272,10 @@ static struct pci_driver mpiix_pci_driver = {
 	.id_table	= mpiix,
 	.probe 		= mpiix_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
+#endif
 };
 
 static int __init mpiix_init(void)
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index e8393e1..38f99b3 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -63,8 +63,10 @@ static struct scsi_host_template netcell_sht = {
 	.slave_destroy		= ata_scsi_slave_destroy,
 	/* Use standard CHS mapping rules */
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static const struct ata_port_operations netcell_ops = {
@@ -153,8 +155,10 @@ static struct pci_driver netcell_pci_driver = {
 	.id_table		= netcell_pci_tbl,
 	.probe			= netcell_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
+#endif
 };
 
 static int __init netcell_init(void)
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index 3d1fa48..9944a28 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -157,8 +157,10 @@ static struct scsi_host_template ns87410_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations ns87410_port_ops = {
@@ -212,8 +214,10 @@ static struct pci_driver ns87410_pci_driver = {
 	.id_table	= ns87410,
 	.probe 		= ns87410_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
+#endif
 };
 
 static int __init ns87410_init(void)
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 2389107..da68cd1 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -233,8 +233,10 @@ static struct scsi_host_template oldpiix_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static const struct ata_port_operations oldpiix_pata_ops = {
@@ -316,8 +318,10 @@ static struct pci_driver oldpiix_pci_driver = {
 	.id_table		= oldpiix_pci_tbl,
 	.probe			= oldpiix_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
+#endif
 };
 
 static int __init oldpiix_init(void)
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index 1b3cd53..3fd3a35 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -179,8 +179,10 @@ static struct scsi_host_template opti_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations opti_port_ops = {
@@ -244,8 +246,10 @@ static struct pci_driver opti_pci_driver = {
 	.id_table	= opti,
 	.probe 		= opti_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
+#endif
 };
 
 static int __init opti_init(void)
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index b76c976..9764907 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -360,8 +360,10 @@ static struct scsi_host_template optidma_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations optidma_port_ops = {
@@ -524,8 +526,10 @@ static struct pci_driver optidma_pci_driver = {
 	.id_table	= optidma,
 	.probe 		= optidma_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
+#endif
 };
 
 static int __init optidma_init(void)
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index 8068538..3fb4177 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -267,8 +267,10 @@ static struct scsi_host_template pdc202xx_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations pdc2024x_port_ops = {
@@ -399,8 +401,10 @@ static struct pci_driver pdc202xx_pci_driver = {
 	.id_table	= pdc202xx,
 	.probe 		= pdc202xx_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
+#endif
 };
 
 static int __init pdc202xx_init(void)
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index c2f87da..c381001 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -363,7 +363,8 @@ static __init int qdi_init(void)
 					release_region(port, 2);
 					continue;
 				}
-				ct += qdi_init_one(port, 6500, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04);
+				if (qdi_init_one(port, 6500, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04) == 0)
+					ct++;
 			}
 			if (((r & 0xF0) == 0xA0) || (r & 0xF0) == 0x50) {
 				/* QD6580: dual channel */
@@ -375,11 +376,14 @@ static __init int qdi_init(void)
 				res = inb(port + 3);
 				if (res & 1) {
 					/* Single channel mode */
-					ct += qdi_init_one(port, 6580, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04);
+					if (qdi_init_one(port, 6580, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04))
+						ct++;
 				} else {
 					/* Dual channel mode */
-					ct += qdi_init_one(port, 6580, 0x1F0, 14, r & 0x04);
-					ct += qdi_init_one(port + 2, 6580, 0x170, 15, r & 0x04);
+					if (qdi_init_one(port, 6580, 0x1F0, 14, r & 0x04) == 0)
+						ct++;
+					if (qdi_init_one(port + 2, 6580, 0x170, 15, r & 0x04) == 0)
+						ct++;
 				}
 			}
 		}
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 0d1e571..9a9132c 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -228,8 +228,10 @@ static struct scsi_host_template radisys_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static const struct ata_port_operations radisys_pata_ops = {
@@ -312,8 +314,10 @@ static struct pci_driver radisys_pci_driver = {
 	.id_table		= radisys_pci_tbl,
 	.probe			= radisys_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
+#endif
 };
 
 static int __init radisys_init(void)
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index 60fc598..f522daa 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -94,8 +94,10 @@ static struct scsi_host_template rz1000_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations rz1000_port_ops = {
@@ -178,6 +180,7 @@ static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 	return -ENODEV;
 }
 
+#ifdef CONFIG_PM
 static int rz1000_reinit_one(struct pci_dev *pdev)
 {
 	/* If this fails on resume (which is a "cant happen" case), we
@@ -186,6 +189,7 @@ static int rz1000_reinit_one(struct pci_dev *pdev)
 		panic("rz1000 fifo");
 	return ata_pci_device_resume(pdev);
 }
+#endif
 
 static const struct pci_device_id pata_rz1000[] = {
 	{ PCI_VDEVICE(PCTECH, PCI_DEVICE_ID_PCTECH_RZ1000), },
@@ -199,8 +203,10 @@ static struct pci_driver rz1000_pci_driver = {
 	.id_table	= pata_rz1000,
 	.probe 		= rz1000_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= rz1000_reinit_one,
+#endif
 };
 
 static int __init rz1000_init(void)
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index 58e42fb..93b3ed0 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -194,8 +194,10 @@ static struct scsi_host_template sc1200_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations sc1200_port_ops = {
@@ -210,7 +212,10 @@ static struct ata_port_operations sc1200_port_ops = {
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -266,8 +271,10 @@ static struct pci_driver sc1200_pci_driver = {
 	.id_table	= sc1200,
 	.probe 		= sc1200_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
+#endif
 };
 
 static int __init sc1200_init(void)
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 4586609..f3ed141 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -984,8 +984,10 @@ static struct scsi_host_template scc_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static const struct ata_port_operations scc_pata_ops = {
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index dde7eb9..598eef8 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -319,8 +319,10 @@ static struct scsi_host_template serverworks_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations serverworks_osb4_port_ops = {
@@ -548,6 +550,7 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 	return ata_pci_init_one(pdev, port_info, ports);
 }
 
+#ifdef CONFIG_PM
 static int serverworks_reinit_one(struct pci_dev *pdev)
 {
 	/* Force master latency timer to 64 PCI clocks */
@@ -571,6 +574,7 @@ static int serverworks_reinit_one(struct pci_dev *pdev)
 	}
 	return ata_pci_device_resume(pdev);
 }
+#endif
 
 static const struct pci_device_id serverworks[] = {
 	{ PCI_VDEVICE(SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_OSB4IDE), 0},
@@ -587,8 +591,10 @@ static struct pci_driver serverworks_pci_driver = {
 	.id_table	= serverworks,
 	.probe 		= serverworks_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= serverworks_reinit_one,
+#endif
 };
 
 static int __init serverworks_init(void)
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 1cb67b2..dab2889 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -236,6 +236,10 @@ static struct scsi_host_template sil680_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
+	.suspend		= ata_scsi_device_suspend,
+	.resume			= ata_scsi_device_resume,
+#endif
 };
 
 static struct ata_port_operations sil680_port_ops = {
@@ -377,11 +381,13 @@ static int sil680_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ata_pci_init_one(pdev, port_info, 2);
 }
 
+#ifdef CONFIG_PM
 static int sil680_reinit_one(struct pci_dev *pdev)
 {
 	sil680_init_chip(pdev);
 	return ata_pci_device_resume(pdev);
 }
+#endif
 
 static const struct pci_device_id sil680[] = {
 	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_SII_680), },
@@ -394,8 +400,10 @@ static struct pci_driver sil680_pci_driver = {
 	.id_table	= sil680,
 	.probe 		= sil680_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= sil680_reinit_one,
+#endif
 };
 
 static int __init sil680_init(void)
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index be30092..f482078 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -575,8 +575,10 @@ static struct scsi_host_template sis_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static const struct ata_port_operations sis_133_ops = {
@@ -1032,8 +1034,10 @@ static struct pci_driver sis_pci_driver = {
 	.id_table		= sis_pci_tbl,
 	.probe			= sis_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
 	.resume			= ata_pci_device_resume,
+#endif
 };
 
 static int __init sis_init(void)
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 13e81f0..b681441 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -234,7 +234,10 @@ static struct ata_port_operations sl82c105_port_ops = {
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
 	.error_handler	= sl82c105_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= sl82c105_bmdma_start,
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index 453ab90..71418f2 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -193,8 +193,10 @@ static struct scsi_host_template triflex_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations triflex_port_ops = {
@@ -260,8 +262,10 @@ static struct pci_driver triflex_pci_driver = {
 	.id_table	= triflex,
 	.probe 		= triflex_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
+#endif
 };
 
 static int __init triflex_init(void)
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 20fc2d0..946ade0 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -305,8 +305,10 @@ static struct scsi_host_template via_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
+#endif
 };
 
 static struct ata_port_operations via_port_ops = {
@@ -560,6 +562,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ata_pci_init_one(pdev, port_info, 2);
 }
 
+#ifdef CONFIG_PM
 /**
  *	via_reinit_one		-	reinit after resume
  *	@pdev; PCI device
@@ -592,6 +595,7 @@ static int via_reinit_one(struct pci_dev *pdev)
 	}
 	return ata_pci_device_resume(pdev);
 }
+#endif
 
 static const struct pci_device_id via[] = {
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_82C576_1), },
@@ -607,8 +611,10 @@ static struct pci_driver via_pci_driver = {
 	.id_table	= via,
 	.probe 		= via_init_one,
 	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= via_reinit_one,
+#endif
 };
 
 static int __init via_init(void)
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 31b636f..3193a60 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -135,8 +135,10 @@ static struct scsi_host_template inic_sht = {
 	.slave_configure	= inic_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.suspend		= ata_scsi_device_suspend,
 	.resume			= ata_scsi_device_resume,
+#endif
 };
 
 static const int scr_map[] = {
@@ -632,6 +634,7 @@ static int init_controller(void __iomem *mmio_base, u16 hctl)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static int inic_pci_device_resume(struct pci_dev *pdev)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
@@ -642,7 +645,6 @@ static int inic_pci_device_resume(struct pci_dev *pdev)
 	ata_pci_device_do_resume(pdev);
 
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
-		printk("XXX\n");
 		rc = init_controller(mmio_base, hpriv->cached_hctl);
 		if (rc)
 			return rc;
@@ -652,6 +654,7 @@ static int inic_pci_device_resume(struct pci_dev *pdev)
 
 	return 0;
 }
+#endif
 
 static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
@@ -755,8 +758,10 @@ static const struct pci_device_id inic_pci_tbl[] = {
 static struct pci_driver inic_pci_driver = {
 	.name 		= DRV_NAME,
 	.id_table	= inic_pci_tbl,
+#ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
 	.resume		= inic_pci_device_resume,
+#endif
 	.probe 		= inic_init_one,
 	.remove		= ata_pci_remove_one,
 };
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 30eed12..388d07f 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -230,7 +230,9 @@ struct nv_host_priv {
 
 static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
 static void nv_remove_one (struct pci_dev *pdev);
+#ifdef CONFIG_PM
 static int nv_pci_device_resume(struct pci_dev *pdev);
+#endif
 static void nv_ck804_host_stop(struct ata_host *host);
 static irqreturn_t nv_generic_interrupt(int irq, void *dev_instance);
 static irqreturn_t nv_nf2_interrupt(int irq, void *dev_instance);
@@ -251,8 +253,10 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance);
 static void nv_adma_irq_clear(struct ata_port *ap);
 static int nv_adma_port_start(struct ata_port *ap);
 static void nv_adma_port_stop(struct ata_port *ap);
+#ifdef CONFIG_PM
 static int nv_adma_port_suspend(struct ata_port *ap, pm_message_t mesg);
 static int nv_adma_port_resume(struct ata_port *ap);
+#endif
 static void nv_adma_error_handler(struct ata_port *ap);
 static void nv_adma_host_stop(struct ata_host *host);
 static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc);
@@ -295,8 +299,10 @@ static struct pci_driver nv_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= nv_pci_tbl,
 	.probe			= nv_init_one,
+#ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
 	.resume			= nv_pci_device_resume,
+#endif
 	.remove			= nv_remove_one,
 };
 
@@ -316,8 +322,10 @@ static struct scsi_host_template nv_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.suspend		= ata_scsi_device_suspend,
 	.resume			= ata_scsi_device_resume,
+#endif
 };
 
 static struct scsi_host_template nv_adma_sht = {
@@ -336,8 +344,10 @@ static struct scsi_host_template nv_adma_sht = {
 	.slave_configure	= nv_adma_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.suspend		= ata_scsi_device_suspend,
 	.resume			= ata_scsi_device_resume,
+#endif
 };
 
 static const struct ata_port_operations nv_generic_ops = {
@@ -449,8 +459,10 @@ static const struct ata_port_operations nv_adma_ops = {
 	.scr_write		= nv_scr_write,
 	.port_start		= nv_adma_port_start,
 	.port_stop		= nv_adma_port_stop,
+#ifdef CONFIG_PM
 	.port_suspend		= nv_adma_port_suspend,
 	.port_resume		= nv_adma_port_resume,
+#endif
 	.host_stop		= nv_adma_host_stop,
 };
 
@@ -1003,6 +1015,7 @@ static void nv_adma_port_stop(struct ata_port *ap)
 	writew(0, mmio + NV_ADMA_CTL);
 }
 
+#ifdef CONFIG_PM
 static int nv_adma_port_suspend(struct ata_port *ap, pm_message_t mesg)
 {
 	struct nv_adma_port_priv *pp = ap->private_data;
@@ -1053,6 +1066,7 @@ static int nv_adma_port_resume(struct ata_port *ap)
 
 	return 0;
 }
+#endif
 
 static void nv_adma_setup_port(struct ata_probe_ent *probe_ent, unsigned int port)
 {
@@ -1555,6 +1569,7 @@ static void nv_remove_one (struct pci_dev *pdev)
 	kfree(hpriv);
 }
 
+#ifdef CONFIG_PM
 static int nv_pci_device_resume(struct pci_dev *pdev)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
@@ -1602,6 +1617,7 @@ static int nv_pci_device_resume(struct pci_dev *pdev)
 
 	return 0;
 }
+#endif
 
 static void nv_ck804_host_stop(struct ata_host *host)
 {
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index f7179c6..917b7ea 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -183,8 +183,10 @@ static struct scsi_host_template sil_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.suspend		= ata_scsi_device_suspend,
 	.resume			= ata_scsi_device_resume,
+#endif
 };
 
 static const struct ata_port_operations sil_ops = {
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index b1bab82..75d9615 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -380,8 +380,10 @@ static struct scsi_host_template sil24_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
 	.suspend		= ata_scsi_device_suspend,
 	.resume			= ata_scsi_device_resume,
+#endif
 };
 
 static const struct ata_port_operations sil24_ops = {
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 045fb3a..e3f32f3 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -403,8 +403,7 @@ struct ata_host {
 	void			*private_data;
 	const struct ata_port_operations *ops;
 	unsigned long		flags;
-	int			simplex_claimed;	/* Keep seperate in case we
-							   ever need to do this locked */
+	struct ata_port		*simplex_claimed;	/* channel owning the DMA */
 	struct ata_port		*ports[0];
 };
 
@@ -719,10 +718,12 @@ extern void ata_std_ports(struct ata_ioports *ioaddr);
 extern int ata_pci_init_one (struct pci_dev *pdev, struct ata_port_info **port_info,
 			     unsigned int n_ports);
 extern void ata_pci_remove_one (struct pci_dev *pdev);
+#ifdef CONFIG_PM
 extern void ata_pci_device_do_suspend(struct pci_dev *pdev, pm_message_t mesg);
 extern int __must_check ata_pci_device_do_resume(struct pci_dev *pdev);
 extern int ata_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 extern int ata_pci_device_resume(struct pci_dev *pdev);
+#endif
 extern int ata_pci_clear_simplex(struct pci_dev *pdev);
 #endif /* CONFIG_PCI */
 extern int ata_device_add(const struct ata_probe_ent *ent);
@@ -748,10 +749,12 @@ extern int sata_scr_write(struct ata_port *ap, int reg, u32 val);
 extern int sata_scr_write_flush(struct ata_port *ap, int reg, u32 val);
 extern int ata_port_online(struct ata_port *ap);
 extern int ata_port_offline(struct ata_port *ap);
+#ifdef CONFIG_PM
 extern int ata_scsi_device_resume(struct scsi_device *);
 extern int ata_scsi_device_suspend(struct scsi_device *, pm_message_t mesg);
 extern int ata_host_suspend(struct ata_host *host, pm_message_t mesg);
 extern void ata_host_resume(struct ata_host *host);
+#endif
 extern int ata_ratelimit(void);
 extern int ata_busy_sleep(struct ata_port *ap,
 			  unsigned long timeout_pat, unsigned long timeout);
