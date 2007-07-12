Return-Path: <linux-kernel-owner+w=401wt.eu-S933220AbXGLUUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbXGLUUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbXGLUUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:20:17 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46759 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbXGLUUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:20:09 -0400
Date: Thu, 12 Jul 2007 16:20:07 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20070712202007.GA4713@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun's Port Multiplier support, one of the larger libata merge items
for 2.6.23, is still pending.  This is mostly cleanups and minor
improvements, though sata_mv received a much-needed facelift.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig        |   10 +-
 drivers/ata/ata_piix.c     |    2 +-
 drivers/ata/libata-core.c  |   74 +---
 drivers/ata/libata-eh.c    |   96 +++---
 drivers/ata/libata-sff.c   |  288 ++-------------
 drivers/ata/pata_hpt3x3.c  |   93 ++++-
 drivers/ata/pata_mpc52xx.c |   18 +-
 drivers/ata/pata_scc.c     |   54 ++-
 drivers/ata/pata_sis.c     |    3 +
 drivers/ata/sata_mv.c      |  887 ++++++++++++++++++++++++++++----------------
 drivers/ata/sata_nv.c      |    2 +-
 drivers/ata/sata_promise.c |   41 ++-
 drivers/ata/sata_sis.c     |    2 +-
 drivers/ata/sata_uli.c     |    2 +-
 drivers/ata/sata_via.c     |    2 +-
 include/linux/ata.h        |   29 ++
 include/linux/libata.h     |   12 +-
 17 files changed, 890 insertions(+), 725 deletions(-)

Akira Iguchi (1):
      pata_scc.c: Workaround for errata A308

Alan Cox (2):
      pata_sis: FIFO whack
      pata_hpt3x3: major reworking and testing

Albert Lee (1):
      libata: remove irq_on from ata_bus_reset() and ata_std_postreset()

Chuck Ebbert (1):
      libata: add another Maxtor drive with broken NCQ to the list

Domen Puncer (1):
      pata_mpc52xx: suspend/resume support

Jeff Garzik (5):
      pata_hpt3x3: fix DMA Kconfig option to actually have a hope of working
      [libata] sata_mv: Minor cleanups and renaming, preparing for new EH & NCQ
      [libata] sata_mv: minor bug fixes, enhancements, and cleanups (prep for new EH)
      [libata] sata_mv: Convert to new exception handling (EH) infrastructure
      [libata] sata_mv: Fix and clean up per-chip-generation tests

Mikael Pettersson (1):
      sata_promise: SATA hotplug support, take 2

Oleg Nesterov (1):
      libata-core: convert to use cancel_rearming_delayed_work()

Prarit Bhargava (1):
      Add Hitachi HDS7250SASUN500G 0621KTAWSD to NCQ blacklist

Tejun Heo (7):
      libata: simplify PCI legacy SFF host handling
      libata: quirk IOMEGA ZIP 250 ATAPI FLOPPY
      libata: clean up horkage handling
      libata: add FUJITSU MHV2080BH to NCQ blacklist
      libata-link: separate out ata_eh_handle_dev_fail()
      libata-link: add PMP related ATA constants
      ata_piix: kill incorrect invalid map value warning

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 4ad8675..d8046a1 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -309,7 +309,7 @@ config PATA_HPT3X2N
 	  If unsure, say N.
 
 config PATA_HPT3X3
-	tristate "HPT 343/363 PATA support (Experimental)"
+	tristate "HPT 343/363 PATA support"
 	depends on PCI
 	help
 	  This option enables support for the HPT 343/363
@@ -317,6 +317,14 @@ config PATA_HPT3X3
 
 	  If unsure, say N.
 
+config PATA_HPT3X3_DMA
+	bool "HPT 343/363 DMA support (Experimental)"
+	depends on PATA_HPT3X3
+	help
+	  This option enables DMA support for the HPT343/363
+	  controllers. Enable with care as there are still some
+	  problems with DMA on this chipset.
+
 config PATA_ISAPNP
 	tristate "ISA Plug and Play PATA support (Experimental)"
 	depends on EXPERIMENTAL && ISAPNP
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 6a3bfef..21a7ca4 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -414,7 +414,7 @@ static const struct piix_map_db ich6m_map_db = {
 	 */
 	.map = {
 		/* PM   PS   SM   SS       MAP */
-		{  P0,  P2,  RV,  RV }, /* 00b */
+		{  P0,  P2,  NA,  NA }, /* 00b */
 		{ IDE, IDE,  P1,  P3 }, /* 01b */
 		{  P0,  P2, IDE, IDE }, /* 10b */
 		{  RV,  RV,  RV,  RV },
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5b25311..88e2dd0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -71,6 +71,7 @@ static unsigned int ata_dev_init_params(struct ata_device *dev,
 					u16 heads, u16 sectors);
 static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
 static void ata_dev_xfermask(struct ata_device *dev);
+static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
 unsigned int ata_print_id = 1;
 static struct workqueue_struct *ata_wq;
@@ -1283,18 +1284,11 @@ static unsigned int ata_id_xfermask(const u16 *id)
 void ata_port_queue_task(struct ata_port *ap, work_func_t fn, void *data,
 			 unsigned long delay)
 {
-	int rc;
-
-	if (ap->pflags & ATA_PFLAG_FLUSH_PORT_TASK)
-		return;
-
 	PREPARE_DELAYED_WORK(&ap->port_task, fn);
 	ap->port_task_data = data;
 
-	rc = queue_delayed_work(ata_wq, &ap->port_task, delay);
-
-	/* rc == 0 means that another user is using port task */
-	WARN_ON(rc == 0);
+	/* may fail if ata_port_flush_task() in progress */
+	queue_delayed_work(ata_wq, &ap->port_task, delay);
 }
 
 /**
@@ -1309,32 +1303,9 @@ void ata_port_queue_task(struct ata_port *ap, work_func_t fn, void *data,
  */
 void ata_port_flush_task(struct ata_port *ap)
 {
-	unsigned long flags;
-
 	DPRINTK("ENTER\n");
 
-	spin_lock_irqsave(ap->lock, flags);
-	ap->pflags |= ATA_PFLAG_FLUSH_PORT_TASK;
-	spin_unlock_irqrestore(ap->lock, flags);
-
-	DPRINTK("flush #1\n");
-	cancel_work_sync(&ap->port_task.work); /* akpm: seems unneeded */
-
-	/*
-	 * At this point, if a task is running, it's guaranteed to see
-	 * the FLUSH flag; thus, it will never queue pio tasks again.
-	 * Cancel and flush.
-	 */
-	if (!cancel_delayed_work(&ap->port_task)) {
-		if (ata_msg_ctl(ap))
-			ata_port_printk(ap, KERN_DEBUG, "%s: flush #2\n",
-					__FUNCTION__);
-		cancel_work_sync(&ap->port_task.work);
-	}
-
-	spin_lock_irqsave(ap->lock, flags);
-	ap->pflags &= ~ATA_PFLAG_FLUSH_PORT_TASK;
-	spin_unlock_irqrestore(ap->lock, flags);
+	cancel_rearming_delayed_work(&ap->port_task);
 
 	if (ata_msg_ctl(ap))
 		ata_port_printk(ap, KERN_DEBUG, "%s: EXIT\n", __FUNCTION__);
@@ -1814,7 +1785,7 @@ static void ata_dev_config_ncq(struct ata_device *dev,
 		desc[0] = '\0';
 		return;
 	}
-	if (ata_device_blacklisted(dev) & ATA_HORKAGE_NONCQ) {
+	if (dev->horkage & ATA_HORKAGE_NONCQ) {
 		snprintf(desc, desc_sz, "NCQ (not used)");
 		return;
 	}
@@ -1863,6 +1834,9 @@ int ata_dev_configure(struct ata_device *dev)
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __FUNCTION__);
 
+	/* set horkage */
+	dev->horkage |= ata_dev_blacklisted(dev);
+
 	/* let ACPI work its magic */
 	rc = ata_acpi_on_devcfg(dev);
 	if (rc)
@@ -2038,7 +2012,7 @@ int ata_dev_configure(struct ata_device *dev)
 		dev->max_sectors = ATA_MAX_SECTORS;
 	}
 
-	if (ata_device_blacklisted(dev) & ATA_HORKAGE_MAX_SEC_128)
+	if (dev->horkage & ATA_HORKAGE_MAX_SEC_128)
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
@@ -3190,9 +3164,6 @@ void ata_bus_reset(struct ata_port *ap)
 	if ((slave_possible) && (err != 0x81))
 		ap->device[1].class = ata_dev_try_classify(ap, 1, &err);
 
-	/* re-enable interrupts */
-	ap->ops->irq_on(ap);
-
 	/* is double-select really necessary? */
 	if (ap->device[1].class != ATA_DEV_NONE)
 		ap->ops->dev_select(ap, 1);
@@ -3577,10 +3548,6 @@ void ata_std_postreset(struct ata_port *ap, unsigned int *classes)
 	if (sata_scr_read(ap, SCR_ERROR, &serror) == 0)
 		sata_scr_write(ap, SCR_ERROR, serror);
 
-	/* re-enable interrupts */
-	if (!ap->ops->error_handler)
-		ap->ops->irq_on(ap);
-
 	/* is double-select really necessary? */
 	if (classes[0] != ATA_DEV_NONE)
 		ap->ops->dev_select(ap, 1);
@@ -3770,6 +3737,8 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "SAMSUNG CD-ROM SN-124","N001",	ATA_HORKAGE_NODMA },
 	{ "Seagate STT20000A", NULL,		ATA_HORKAGE_NODMA },
 	{ "IOMEGA  ZIP 250       ATAPI", NULL,	ATA_HORKAGE_NODMA }, /* temporary fix */
+	{ "IOMEGA  ZIP 250       ATAPI       Floppy",
+				NULL,		ATA_HORKAGE_NODMA },
 
 	/* Weird ATAPI devices */
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 },
@@ -3783,7 +3752,10 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "FUJITSU MHT2060BH",	NULL,		ATA_HORKAGE_NONCQ },
 	/* NCQ is broken */
 	{ "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ },
+	{ "Maxtor 6B200M0",	"BANC1BM0",	ATA_HORKAGE_NONCQ },
 	{ "Maxtor 6B200M0",	"BANC1B10",	ATA_HORKAGE_NONCQ },
+	{ "HITACHI HDS7250SASUN500G 0621KTAWSD", "K2AOAJ0AHITACHI",
+	 ATA_HORKAGE_NONCQ },
 	/* NCQ hard hangs device under heavier load, needs hard power cycle */
 	{ "Maxtor 6B250S0",	"BANC1B70",	ATA_HORKAGE_NONCQ },
 	/* Blacklist entries taken from Silicon Image 3124/3132
@@ -3796,6 +3768,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "HTS541612J9SA00",	"SBDIC7JP",	ATA_HORKAGE_NONCQ, },
 	{ "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
 	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
+	{ "FUJITSU MHV2080BH",	"00840028",	ATA_HORKAGE_NONCQ, },
 
 	/* Devices with NCQ limits */
 
@@ -3803,7 +3776,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ }
 };
 
-unsigned long ata_device_blacklisted(const struct ata_device *dev)
+static unsigned long ata_dev_blacklisted(const struct ata_device *dev)
 {
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
 	unsigned char model_rev[ATA_ID_FW_REV_LEN + 1];
@@ -3833,7 +3806,7 @@ static int ata_dma_blacklisted(const struct ata_device *dev)
 	if ((dev->ap->flags & ATA_FLAG_PIO_POLLING) &&
 	    (dev->flags & ATA_DFLAG_CDB_INTR))
 		return 1;
-	return (ata_device_blacklisted(dev) & ATA_HORKAGE_NODMA) ? 1 : 0;
+	return (dev->horkage & ATA_HORKAGE_NODMA) ? 1 : 0;
 }
 
 /**
@@ -6557,13 +6530,7 @@ void ata_port_detach(struct ata_port *ap)
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	ata_port_wait_eh(ap);
-
-	/* Flush hotplug task.  The sequence is similar to
-	 * ata_port_flush_task().
-	 */
-	cancel_work_sync(&ap->hotplug_task.work); /* akpm: why? */
-	cancel_delayed_work(&ap->hotplug_task);
-	cancel_work_sync(&ap->hotplug_task.work);
+	cancel_rearming_delayed_work(&ap->hotplug_task);
 
  skip_eh:
 	/* remove the associated SCSI host */
@@ -6952,7 +6919,6 @@ EXPORT_SYMBOL_GPL(ata_host_resume);
 EXPORT_SYMBOL_GPL(ata_id_string);
 EXPORT_SYMBOL_GPL(ata_id_c_string);
 EXPORT_SYMBOL_GPL(ata_id_to_dma_mode);
-EXPORT_SYMBOL_GPL(ata_device_blacklisted);
 EXPORT_SYMBOL_GPL(ata_scsi_simulate);
 
 EXPORT_SYMBOL_GPL(ata_pio_need_iordy);
@@ -6961,9 +6927,9 @@ EXPORT_SYMBOL_GPL(ata_timing_merge);
 
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL_GPL(pci_test_config_bits);
-EXPORT_SYMBOL_GPL(ata_pci_init_native_host);
+EXPORT_SYMBOL_GPL(ata_pci_init_sff_host);
 EXPORT_SYMBOL_GPL(ata_pci_init_bmdma);
-EXPORT_SYMBOL_GPL(ata_pci_prepare_native_host);
+EXPORT_SYMBOL_GPL(ata_pci_prepare_sff_host);
 EXPORT_SYMBOL_GPL(ata_pci_init_one);
 EXPORT_SYMBOL_GPL(ata_pci_remove_one);
 #ifdef CONFIG_PM
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 9ee0a8c..9aa62a0 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1897,6 +1897,57 @@ static int ata_eh_skip_recovery(struct ata_port *ap)
 	return 1;
 }
 
+static void ata_eh_handle_dev_fail(struct ata_device *dev, int err)
+{
+	struct ata_port *ap = dev->ap;
+	struct ata_eh_context *ehc = &ap->eh_context;
+
+	ehc->tries[dev->devno]--;
+
+	switch (err) {
+	case -ENODEV:
+		/* device missing or wrong IDENTIFY data, schedule probing */
+		ehc->i.probe_mask |= (1 << dev->devno);
+	case -EINVAL:
+		/* give it just one more chance */
+		ehc->tries[dev->devno] = min(ehc->tries[dev->devno], 1);
+	case -EIO:
+		if (ehc->tries[dev->devno] == 1) {
+			/* This is the last chance, better to slow
+			 * down than lose it.
+			 */
+			sata_down_spd_limit(ap);
+			ata_down_xfermask_limit(dev, ATA_DNXFER_PIO);
+		}
+	}
+
+	if (ata_dev_enabled(dev) && !ehc->tries[dev->devno]) {
+		/* disable device if it has used up all its chances */
+		ata_dev_disable(dev);
+
+		/* detach if offline */
+		if (ata_port_offline(ap))
+			ata_eh_detach_dev(dev);
+
+		/* probe if requested */
+		if ((ehc->i.probe_mask & (1 << dev->devno)) &&
+		    !(ehc->did_probe_mask & (1 << dev->devno))) {
+			ata_eh_detach_dev(dev);
+			ata_dev_init(dev);
+
+			ehc->tries[dev->devno] = ATA_EH_DEV_TRIES;
+			ehc->did_probe_mask |= (1 << dev->devno);
+			ehc->i.action |= ATA_EH_SOFTRESET;
+		}
+	} else {
+		/* soft didn't work?  be haaaaard */
+		if (ehc->i.flags & ATA_EHI_DID_RESET)
+			ehc->i.action |= ATA_EH_HARDRESET;
+		else
+			ehc->i.action |= ATA_EH_SOFTRESET;
+	}
+}
+
 /**
  *	ata_eh_recover - recover host port after error
  *	@ap: host port to recover
@@ -1997,50 +2048,7 @@ static int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 	goto out;
 
  dev_fail:
-	ehc->tries[dev->devno]--;
-
-	switch (rc) {
-	case -ENODEV:
-		/* device missing or wrong IDENTIFY data, schedule probing */
-		ehc->i.probe_mask |= (1 << dev->devno);
-	case -EINVAL:
-		/* give it just one more chance */
-		ehc->tries[dev->devno] = min(ehc->tries[dev->devno], 1);
-	case -EIO:
-		if (ehc->tries[dev->devno] == 1) {
-			/* This is the last chance, better to slow
-			 * down than lose it.
-			 */
-			sata_down_spd_limit(ap);
-			ata_down_xfermask_limit(dev, ATA_DNXFER_PIO);
-		}
-	}
-
-	if (ata_dev_enabled(dev) && !ehc->tries[dev->devno]) {
-		/* disable device if it has used up all its chances */
-		ata_dev_disable(dev);
-
-		/* detach if offline */
-		if (ata_port_offline(ap))
-			ata_eh_detach_dev(dev);
-
-		/* probe if requested */
-		if ((ehc->i.probe_mask & (1 << dev->devno)) &&
-		    !(ehc->did_probe_mask & (1 << dev->devno))) {
-			ata_eh_detach_dev(dev);
-			ata_dev_init(dev);
-
-			ehc->tries[dev->devno] = ATA_EH_DEV_TRIES;
-			ehc->did_probe_mask |= (1 << dev->devno);
-			ehc->i.action |= ATA_EH_SOFTRESET;
-		}
-	} else {
-		/* soft didn't work?  be haaaaard */
-		if (ehc->i.flags & ATA_EHI_DID_RESET)
-			ehc->i.action |= ATA_EH_HARDRESET;
-		else
-			ehc->i.action |= ATA_EH_SOFTRESET;
-	}
+	ata_eh_handle_dev_fail(dev, rc);
 
 	if (ata_port_nr_enabled(ap)) {
 		ata_port_printk(ap, KERN_WARNING, "failed to recover some "
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index fa1c22c..ca7d224 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -604,13 +604,17 @@ int ata_pci_init_bmdma(struct ata_host *host)
 }
 
 /**
- *	ata_pci_init_native_host - acquire native ATA resources and init host
+ *	ata_pci_init_sff_host - acquire native PCI ATA resources and init host
  *	@host: target ATA host
  *
  *	Acquire native PCI ATA resources for @host and initialize the
  *	first two ports of @host accordingly.  Ports marked dummy are
  *	skipped and allocation failure makes the port dummy.
  *
+ *	Note that native PCI resources are valid even for legacy hosts
+ *	as we fix up pdev resources array early in boot, so this
+ *	function can be used for both native and legacy SFF hosts.
+ *
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
  *
@@ -618,7 +622,7 @@ int ata_pci_init_bmdma(struct ata_host *host)
  *	0 if at least one port is initialized, -ENODEV if no port is
  *	available.
  */
-int ata_pci_init_native_host(struct ata_host *host)
+int ata_pci_init_sff_host(struct ata_host *host)
 {
 	struct device *gdev = host->dev;
 	struct pci_dev *pdev = to_pci_dev(gdev);
@@ -673,7 +677,7 @@ int ata_pci_init_native_host(struct ata_host *host)
 }
 
 /**
- *	ata_pci_prepare_native_host - helper to prepare native PCI ATA host
+ *	ata_pci_prepare_sff_host - helper to prepare native PCI ATA host
  *	@pdev: target PCI device
  *	@ppi: array of port_info, must be enough for two ports
  *	@r_host: out argument for the initialized ATA host
@@ -687,9 +691,9 @@ int ata_pci_init_native_host(struct ata_host *host)
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-int ata_pci_prepare_native_host(struct pci_dev *pdev,
-				const struct ata_port_info * const * ppi,
-				struct ata_host **r_host)
+int ata_pci_prepare_sff_host(struct pci_dev *pdev,
+			     const struct ata_port_info * const * ppi,
+			     struct ata_host **r_host)
 {
 	struct ata_host *host;
 	int rc;
@@ -705,7 +709,7 @@ int ata_pci_prepare_native_host(struct pci_dev *pdev,
 		goto err_out;
 	}
 
-	rc = ata_pci_init_native_host(host);
+	rc = ata_pci_init_sff_host(host);
 	if (rc)
 		goto err_out;
 
@@ -730,221 +734,6 @@ int ata_pci_prepare_native_host(struct pci_dev *pdev,
 	return rc;
 }
 
-struct ata_legacy_devres {
-	unsigned int	mask;
-	unsigned long	cmd_port[2];
-	void __iomem *	cmd_addr[2];
-	void __iomem *	ctl_addr[2];
-	unsigned int	irq[2];
-	void *		irq_dev_id[2];
-};
-
-static void ata_legacy_free_irqs(struct ata_legacy_devres *legacy_dr)
-{
-	int i;
-
-	for (i = 0; i < 2; i++) {
-		if (!legacy_dr->irq[i])
-			continue;
-
-		free_irq(legacy_dr->irq[i], legacy_dr->irq_dev_id[i]);
-		legacy_dr->irq[i] = 0;
-		legacy_dr->irq_dev_id[i] = NULL;
-	}
-}
-
-static void ata_legacy_release(struct device *gdev, void *res)
-{
-	struct ata_legacy_devres *this = res;
-	int i;
-
-	ata_legacy_free_irqs(this);
-
-	for (i = 0; i < 2; i++) {
-		if (this->cmd_addr[i])
-			ioport_unmap(this->cmd_addr[i]);
-		if (this->ctl_addr[i])
-			ioport_unmap(this->ctl_addr[i]);
-		if (this->cmd_port[i])
-			release_region(this->cmd_port[i], 8);
-	}
-}
-
-static int ata_init_legacy_port(struct ata_port *ap,
-				struct ata_legacy_devres *legacy_dr)
-{
-	struct ata_host *host = ap->host;
-	int port_no = ap->port_no;
-	unsigned long cmd_port, ctl_port;
-
-	if (port_no == 0) {
-		cmd_port = ATA_PRIMARY_CMD;
-		ctl_port = ATA_PRIMARY_CTL;
-	} else {
-		cmd_port = ATA_SECONDARY_CMD;
-		ctl_port = ATA_SECONDARY_CTL;
-	}
-
-	/* request cmd_port */
-	if (request_region(cmd_port, 8, "libata"))
-		legacy_dr->cmd_port[port_no] = cmd_port;
-	else {
-		dev_printk(KERN_WARNING, host->dev,
-			   "0x%0lX IDE port busy\n", cmd_port);
-		return -EBUSY;
-	}
-
-	/* iomap cmd and ctl ports */
-	legacy_dr->cmd_addr[port_no] = ioport_map(cmd_port, 8);
-	legacy_dr->ctl_addr[port_no] = ioport_map(ctl_port, 1);
-	if (!legacy_dr->cmd_addr[port_no] || !legacy_dr->ctl_addr[port_no]) {
-		dev_printk(KERN_WARNING, host->dev,
-			   "failed to map cmd/ctl ports\n");
-		return -ENOMEM;
-	}
-
-	/* init IO addresses */
-	ap->ioaddr.cmd_addr = legacy_dr->cmd_addr[port_no];
-	ap->ioaddr.altstatus_addr = legacy_dr->ctl_addr[port_no];
-	ap->ioaddr.ctl_addr = legacy_dr->ctl_addr[port_no];
-	ata_std_ports(&ap->ioaddr);
-
-	return 0;
-}
-
-/**
- *	ata_init_legacy_host - acquire legacy ATA resources and init ATA host
- *	@host: target ATA host
- *	@was_busy: out parameter, indicates whether any port was busy
- *
- *	Acquire legacy ATA resources for the first two ports of @host
- *	and initialize it accordingly.  Ports marked dummy are skipped
- *	and resource acquistion failure makes the port dummy.
- *
- *	LOCKING:
- *	Inherited from calling layer (may sleep).
- *
- *	RETURNS:
- *	0 if at least one port is initialized, -ENODEV if no port is
- *	available.
- */
-static int ata_init_legacy_host(struct ata_host *host, int *was_busy)
-{
-	struct device *gdev = host->dev;
-	struct ata_legacy_devres *legacy_dr;
-	int i, rc;
-
-	if (!devres_open_group(gdev, NULL, GFP_KERNEL))
-		return -ENOMEM;
-
-	rc = -ENOMEM;
-	legacy_dr = devres_alloc(ata_legacy_release, sizeof(*legacy_dr),
-				 GFP_KERNEL);
-	if (!legacy_dr)
-		goto err_out;
-	devres_add(gdev, legacy_dr);
-
-	for (i = 0; i < 2; i++) {
-		if (ata_port_is_dummy(host->ports[i]))
-			continue;
-
-		rc = ata_init_legacy_port(host->ports[i], legacy_dr);
-		if (rc == 0)
-			legacy_dr->mask |= 1 << i;
-		else {
-			if (rc == -EBUSY)
-				(*was_busy)++;
-			host->ports[i]->ops = &ata_dummy_port_ops;
-		}
-	}
-
-	if (!legacy_dr->mask) {
-		dev_printk(KERN_ERR, gdev, "no available legacy port\n");
-		return -ENODEV;
-	}
-
-	devres_remove_group(gdev, NULL);
-	return 0;
-
- err_out:
-	devres_release_group(gdev, NULL);
-	return rc;
-}
-
-/**
- *	ata_request_legacy_irqs - request legacy ATA IRQs
- *	@host: target ATA host
- *	@handler: array of IRQ handlers
- *	@irq_flags: array of IRQ flags
- *	@dev_id: array of IRQ dev_ids
- *
- *	Request legacy IRQs for non-dummy legacy ports in @host.  All
- *	IRQ parameters are passed as array to allow ports to have
- *	separate IRQ handlers.
- *
- *	LOCKING:
- *	Inherited from calling layer (may sleep).
- *
- *	RETURNS:
- *	0 on success, -errno otherwise.
- */
-static int ata_request_legacy_irqs(struct ata_host *host,
-				   irq_handler_t const *handler,
-				   const unsigned int *irq_flags,
-				   void * const *dev_id)
-{
-	struct device *gdev = host->dev;
-	struct ata_legacy_devres *legacy_dr;
-	int i, rc;
-
-	legacy_dr = devres_find(host->dev, ata_legacy_release, NULL, NULL);
-	BUG_ON(!legacy_dr);
-
-	for (i = 0; i < 2; i++) {
-		unsigned int irq;
-
-		/* FIXME: ATA_*_IRQ() should take generic device not pci_dev */
-		if (i == 0)
-			irq = ATA_PRIMARY_IRQ(to_pci_dev(gdev));
-		else
-			irq = ATA_SECONDARY_IRQ(to_pci_dev(gdev));
-
-		if (!(legacy_dr->mask & (1 << i)))
-			continue;
-
-		if (!handler[i]) {
-			dev_printk(KERN_ERR, gdev,
-				   "NULL handler specified for port %d\n", i);
-			rc = -EINVAL;
-			goto err_out;
-		}
-
-		rc = request_irq(irq, handler[i], irq_flags[i], DRV_NAME,
-				 dev_id[i]);
-		if (rc) {
-			dev_printk(KERN_ERR, gdev,
-				"irq %u request failed (errno=%d)\n", irq, rc);
-			goto err_out;
-		}
-
-		/* record irq allocation in legacy_dr */
-		legacy_dr->irq[i] = irq;
-		legacy_dr->irq_dev_id[i] = dev_id[i];
-
-		/* only used to print info */
-		if (i == 0)
-			host->irq = irq;
-		else
-			host->irq2 = irq;
-	}
-
-	return 0;
-
- err_out:
-	ata_legacy_free_irqs(legacy_dr);
-	return rc;
-}
-
 /**
  *	ata_pci_init_one - Initialize/register PCI IDE host controller
  *	@pdev: Controller to be initialized
@@ -1029,35 +818,11 @@ int ata_pci_init_one(struct pci_dev *pdev,
 #endif
 	}
 
-	/* alloc and init host */
-	host = ata_host_alloc_pinfo(dev, ppi, 2);
-	if (!host) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "failed to allocate ATA host\n");
-		rc = -ENOMEM;
+	/* prepare host */
+	rc = ata_pci_prepare_sff_host(pdev, ppi, &host);
+	if (rc)
 		goto err_out;
-	}
 
-	if (!legacy_mode) {
-		rc = ata_pci_init_native_host(host);
-		if (rc)
-			goto err_out;
-	} else {
-		int was_busy = 0;
-
-		rc = ata_init_legacy_host(host, &was_busy);
-		if (was_busy)
-			pcim_pin_device(pdev);
-		if (rc)
-			goto err_out;
-
-		/* request respective PCI regions, may fail */
-		rc = pci_request_region(pdev, 1, DRV_NAME);
-		rc = pci_request_region(pdev, 3, DRV_NAME);
-	}
-
-	/* init BMDMA, may fail */
-	ata_pci_init_bmdma(host);
 	pci_set_master(pdev);
 
 	/* start host and request IRQ */
@@ -1068,17 +833,28 @@ int ata_pci_init_one(struct pci_dev *pdev,
 	if (!legacy_mode) {
 		rc = devm_request_irq(dev, pdev->irq, pi->port_ops->irq_handler,
 				      IRQF_SHARED, DRV_NAME, host);
+		if (rc)
+			goto err_out;
 		host->irq = pdev->irq;
 	} else {
-		irq_handler_t handler[2] = { host->ops->irq_handler,
-					     host->ops->irq_handler };
-		unsigned int irq_flags[2] = { IRQF_SHARED, IRQF_SHARED };
-		void *dev_id[2] = { host, host };
+		if (!ata_port_is_dummy(host->ports[0])) {
+			host->irq = ATA_PRIMARY_IRQ(pdev);
+			rc = devm_request_irq(dev, host->irq,
+					      pi->port_ops->irq_handler,
+					      IRQF_SHARED, DRV_NAME, host);
+			if (rc)
+				goto err_out;
+		}
 
-		rc = ata_request_legacy_irqs(host, handler, irq_flags, dev_id);
+		if (!ata_port_is_dummy(host->ports[1])) {
+			host->irq2 = ATA_SECONDARY_IRQ(pdev);
+			rc = devm_request_irq(dev, host->irq2,
+					      pi->port_ops->irq_handler,
+					      IRQF_SHARED, DRV_NAME, host);
+			if (rc)
+				goto err_out;
+		}
 	}
-	if (rc)
-		goto err_out;
 
 	/* register */
 	rc = ata_host_register(host, pi->sht);
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index d928c91..be0f05e 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -23,7 +23,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x3"
-#define DRV_VERSION	"0.4.3"
+#define DRV_VERSION	"0.5.3"
 
 /**
  *	hpt3x3_set_piomode		-	PIO setup
@@ -52,6 +52,7 @@ static void hpt3x3_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	pci_write_config_dword(pdev, 0x48, r2);
 }
 
+#if defined(CONFIG_PATA_HPT3X3_DMA)
 /**
  *	hpt3x3_set_dmamode		-	DMA timing setup
  *	@ap: ATA interface
@@ -59,6 +60,9 @@ static void hpt3x3_set_piomode(struct ata_port *ap, struct ata_device *adev)
  *
  *	Set up the channel for MWDMA or UDMA modes. Much the same as with
  *	PIO, load the mode number and then set MWDMA or UDMA flag.
+ *
+ *	0x44 : bit 0-2 master mode, 3-5 slave mode, etc
+ *	0x48 : bit 4/0 DMA/UDMA bit 5/1 for slave etc
  */
 
 static void hpt3x3_set_dmamode(struct ata_port *ap, struct ata_device *adev)
@@ -76,13 +80,26 @@ static void hpt3x3_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	r2 &= ~(0x11 << dn);	/* Clear MWDMA and UDMA bits */
 
 	if (adev->dma_mode >= XFER_UDMA_0)
-		r2 |= 0x01 << dn;	/* Ultra mode */
+		r2 |= (0x10 << dn);	/* Ultra mode */
 	else
-		r2 |= 0x10 << dn;	/* MWDMA */
+		r2 |= (0x01 << dn);	/* MWDMA */
 
 	pci_write_config_dword(pdev, 0x44, r1);
 	pci_write_config_dword(pdev, 0x48, r2);
 }
+#endif /* CONFIG_PATA_HPT3X3_DMA */
+
+/**
+ *	hpt3x3_atapi_dma	-	ATAPI DMA check
+ *	@qc: Queued command
+ *
+ *	Just say no - we don't do ATAPI DMA
+ */
+
+static int hpt3x3_atapi_dma(struct ata_queued_cmd *qc)
+{
+	return 1;
+}
 
 static struct scsi_host_template hpt3x3_sht = {
 	.module			= THIS_MODULE,
@@ -105,7 +122,9 @@ static struct scsi_host_template hpt3x3_sht = {
 static struct ata_port_operations hpt3x3_port_ops = {
 	.port_disable	= ata_port_disable,
 	.set_piomode	= hpt3x3_set_piomode,
+#if defined(CONFIG_PATA_HPT3X3_DMA)
 	.set_dmamode	= hpt3x3_set_dmamode,
+#endif
 	.mode_filter	= ata_pci_default_filter,
 
 	.tf_load	= ata_tf_load,
@@ -124,6 +143,7 @@ static struct ata_port_operations hpt3x3_port_ops = {
 	.bmdma_start 	= ata_bmdma_start,
 	.bmdma_stop	= ata_bmdma_stop,
 	.bmdma_status 	= ata_bmdma_status,
+	.check_atapi_dma= hpt3x3_atapi_dma,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -158,32 +178,79 @@ static void hpt3x3_init_chipset(struct pci_dev *dev)
 		pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x20);
 }
 
-
 /**
  *	hpt3x3_init_one		-	Initialise an HPT343/363
- *	@dev: PCI device
+ *	@pdev: PCI device
  *	@id: Entry in match table
  *
- *	Perform basic initialisation. The chip has a quirk that it won't
- *	function unless it is at XX00. The old ATA driver touched this up
- *	but we leave it for pci quirks to do properly.
+ *	Perform basic initialisation. We set the device up so we access all
+ *	ports via BAR4. This is neccessary to work around errata.
  */
 
-static int hpt3x3_init_one(struct pci_dev *dev, const struct pci_device_id *id)
+static int hpt3x3_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
+	static int printed_version;
 	static const struct ata_port_info info = {
 		.sht = &hpt3x3_sht,
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
+#if defined(CONFIG_PATA_HPT3X3_DMA)
+		/* Further debug needed */
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x07,
+#endif
 		.port_ops = &hpt3x3_port_ops
 	};
+	/* Register offsets of taskfiles in BAR4 area */
+	static const u8 offset_cmd[2] = { 0x20, 0x28 };
+	static const u8 offset_ctl[2] = { 0x36, 0x3E };
 	const struct ata_port_info *ppi[] = { &info, NULL };
-
-	hpt3x3_init_chipset(dev);
-	/* Now kick off ATA set up */
-	return ata_pci_init_one(dev, ppi);
+	struct ata_host *host;
+	int i, rc;
+	void __iomem *base;
+
+	hpt3x3_init_chipset(pdev);
+
+	if (!printed_version++)
+		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+
+	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 2);
+	if (!host)
+		return -ENOMEM;
+	/* acquire resources and fill host */
+	rc = pcim_enable_device(pdev);
+	if (rc)
+		return rc;
+
+	/* Everything is relative to BAR4 if we set up this way */
+	rc = pcim_iomap_regions(pdev, 1 << 4, DRV_NAME);
+	if (rc == -EBUSY)
+		pcim_pin_device(pdev);
+	if (rc)
+		return rc;
+	host->iomap = pcim_iomap_table(pdev);
+	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
+	if (rc)
+		return rc;
+	rc = pci_set_consistent_dma_mask(pdev, ATA_DMA_MASK);
+	if (rc)
+		return rc;
+
+	base = host->iomap[4];	/* Bus mastering base */
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_ioports *ioaddr = &host->ports[i]->ioaddr;
+
+		ioaddr->cmd_addr = base + offset_cmd[i];
+		ioaddr->altstatus_addr =
+		ioaddr->ctl_addr = base + offset_ctl[i];
+		ioaddr->scr_addr = NULL;
+		ata_std_ports(ioaddr);
+		ioaddr->bmdma_addr = base + 8 * i;
+	}
+	pci_set_master(pdev);
+	return ata_host_activate(host, pdev->irq, ata_interrupt, IRQF_SHARED,
+				 &hpt3x3_sht);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 368fac7..182e83c 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -467,13 +467,27 @@ mpc52xx_ata_remove(struct of_device *op)
 static int
 mpc52xx_ata_suspend(struct of_device *op, pm_message_t state)
 {
-	return 0;	/* FIXME : What to do here ? */
+	struct ata_host *host = dev_get_drvdata(&op->dev);
+
+	return ata_host_suspend(host, state);
 }
 
 static int
 mpc52xx_ata_resume(struct of_device *op)
 {
-	return 0;	/* FIXME : What to do here ? */
+	struct ata_host *host = dev_get_drvdata(&op->dev);
+	struct mpc52xx_ata_priv *priv = host->private_data;
+	int rv;
+
+	rv = mpc52xx_ata_hw_init(priv);
+	if (rv) {
+		printk(KERN_ERR DRV_NAME ": Error during HW init\n");
+		return rv;
+	}
+
+	ata_host_resume(host);
+
+	return 0;
 }
 
 #endif
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 61502bc..c55667e 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -238,6 +238,12 @@ static void scc_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	else
 		offset = 0;	/* 100MHz */
 
+	/* errata A308 workaround: limit ATAPI UDMA mode to UDMA4 */
+	if (adev->class == ATA_DEV_ATAPI && speed > XFER_UDMA_4) {
+		printk(KERN_INFO "%s: limit ATAPI UDMA to UDMA4\n", DRV_NAME);
+		speed = XFER_UDMA_4;
+	}
+
 	if (speed >= XFER_UDMA_0)
 		idx = speed - XFER_UDMA_0;
 	else
@@ -724,22 +730,36 @@ static void scc_bmdma_stop (struct ata_queued_cmd *qc)
 
 static u8 scc_bmdma_status (struct ata_port *ap)
 {
-	u8 host_stat;
 	void __iomem *mmio = ap->ioaddr.bmdma_addr;
-
-	host_stat = in_be32(mmio + SCC_DMA_STATUS);
-
-	/* Workaround for PTERADD: emulate DMA_INTR when
-	 * - IDE_STATUS[ERR] = 1
-	 * - INT_STATUS[INTRQ] = 1
-	 * - DMA_STATUS[IORACTA] = 1
-	 */
-	if (!(host_stat & ATA_DMA_INTR)) {
-		u32 int_status = in_be32(mmio + SCC_DMA_INTST);
-		if (ata_altstatus(ap) & ATA_ERR &&
-		    int_status & INTSTS_INTRQ &&
-		    host_stat & ATA_DMA_ACTIVE)
-			host_stat |= ATA_DMA_INTR;
+	u8 host_stat = in_be32(mmio + SCC_DMA_STATUS);
+	u32 int_status = in_be32(mmio + SCC_DMA_INTST);
+	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->active_tag);
+	static int retry = 0;
+
+	/* return if IOS_SS is cleared */
+	if (!(in_be32(mmio + SCC_DMA_CMD) & ATA_DMA_START))
+		return host_stat;
+
+	/* errata A252,A308 workaround: Step4 */
+	if (ata_altstatus(ap) & ATA_ERR && int_status & INTSTS_INTRQ)
+		return (host_stat | ATA_DMA_INTR);
+
+	/* errata A308 workaround Step5 */
+	if (int_status & INTSTS_IOIRQS) {
+		host_stat |= ATA_DMA_INTR;
+
+		/* We don't check ATAPI DMA because it is limited to UDMA4 */
+		if ((qc->tf.protocol == ATA_PROT_DMA &&
+		     qc->dev->xfer_mode > XFER_UDMA_4)) {
+			if (!(int_status & INTSTS_ACTEINT)) {
+				printk(KERN_WARNING "ata%u: data lost occurred. (ACTEINT==0, retry:%d)\n",
+				       ap->print_id, retry);
+				host_stat |= ATA_DMA_ERR;
+				if (retry++)
+					ap->udma_mask >>= 1;
+			} else
+				retry = 0;
+		}
 	}
 
 	return host_stat;
@@ -892,10 +912,6 @@ static void scc_std_postreset (struct ata_port *ap, unsigned int *classes)
 {
 	DPRINTK("ENTER\n");
 
-	/* re-enable interrupts */
-	if (!ap->ops->error_handler)
-		ap->ops->irq_on(ap);
-
 	/* is double-select really necessary? */
 	if (classes[0] != ATA_DEV_NONE)
 		ap->ops->dev_select(ap, 1);
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 2b45082..657b1ee 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -149,6 +149,9 @@ static int sis_pre_reset(struct ata_port *ap, unsigned long deadline)
 	if (!pci_test_config_bits(pdev, &sis_enable_bits[ap->port_no]))
 		return -ENOENT;
 
+	/* Clear the FIFO settings. We can't enable the FIFO until
+	   we know we are poking at a disk */
+	pci_write_config_byte(pdev, 0x4B, 0);
 	return ata_std_prereset(ap, deadline);
 }
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 3873b29..8a77a0a 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -29,11 +29,6 @@
   I distinctly remember a couple workarounds (one related to PCI-X)
   are still needed.
 
-  2) Convert to LibATA new EH.  Required for hotplug, NCQ, and sane
-  probing/error handling in general.  MUST HAVE.
-
-  3) Add hotplug support (easy, once new-EH support appears)
-
   4) Add NCQ support (easy to intermediate, once new-EH support appears)
 
   5) Investigate problems with PCI Message Signalled Interrupts (MSI).
@@ -108,8 +103,6 @@ enum {
 	MV_SATAHC_ARBTR_REG_SZ	= MV_MINOR_REG_AREA_SZ,		/* arbiter */
 	MV_PORT_REG_SZ		= MV_MINOR_REG_AREA_SZ,
 
-	MV_USE_Q_DEPTH		= ATA_DEF_QUEUE,
-
 	MV_MAX_Q_DEPTH		= 32,
 	MV_MAX_Q_DEPTH_MASK	= MV_MAX_Q_DEPTH - 1,
 
@@ -133,18 +126,22 @@ enum {
 	/* Host Flags */
 	MV_FLAG_DUAL_HC		= (1 << 30),  /* two SATA Host Controllers */
 	MV_FLAG_IRQ_COALESCE	= (1 << 29),  /* IRQ coalescing capability */
-	MV_COMMON_FLAGS		= (ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				   ATA_FLAG_SATA_RESET | ATA_FLAG_MMIO |
-				   ATA_FLAG_NO_ATAPI | ATA_FLAG_PIO_POLLING),
+	MV_COMMON_FLAGS		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO | ATA_FLAG_NO_ATAPI |
+				  ATA_FLAG_PIO_POLLING,
 	MV_6XXX_FLAGS		= MV_FLAG_IRQ_COALESCE,
 
 	CRQB_FLAG_READ		= (1 << 0),
 	CRQB_TAG_SHIFT		= 1,
+	CRQB_IOID_SHIFT		= 6,	/* CRQB Gen-II/IIE IO Id shift */
+	CRQB_HOSTQ_SHIFT	= 17,	/* CRQB Gen-II/IIE HostQueTag shift */
 	CRQB_CMD_ADDR_SHIFT	= 8,
 	CRQB_CMD_CS		= (0x2 << 11),
 	CRQB_CMD_LAST		= (1 << 15),
 
 	CRPB_FLAG_STATUS_SHIFT	= 8,
+	CRPB_IOID_SHIFT_6	= 5,	/* CRPB Gen-II IO Id shift */
+	CRPB_IOID_SHIFT_7	= 7,	/* CRPB Gen-IIE IO Id shift */
 
 	EPRD_FLAG_END_OF_TBL	= (1 << 31),
 
@@ -236,8 +233,10 @@ enum {
 	EDMA_ERR_DEV_DCON	= (1 << 3),
 	EDMA_ERR_DEV_CON	= (1 << 4),
 	EDMA_ERR_SERR		= (1 << 5),
-	EDMA_ERR_SELF_DIS	= (1 << 7),
+	EDMA_ERR_SELF_DIS	= (1 << 7),	/* Gen II/IIE self-disable */
+	EDMA_ERR_SELF_DIS_5	= (1 << 8),	/* Gen I self-disable */
 	EDMA_ERR_BIST_ASYNC	= (1 << 8),
+	EDMA_ERR_TRANS_IRQ_7	= (1 << 8),	/* Gen IIE transprt layer irq */
 	EDMA_ERR_CRBQ_PAR	= (1 << 9),
 	EDMA_ERR_CRPB_PAR	= (1 << 10),
 	EDMA_ERR_INTRL_PAR	= (1 << 11),
@@ -248,13 +247,33 @@ enum {
 	EDMA_ERR_LNK_CTRL_TX	= (0x1f << 21),
 	EDMA_ERR_LNK_DATA_TX	= (0x1f << 26),
 	EDMA_ERR_TRANS_PROTO	= (1 << 31),
-	EDMA_ERR_FATAL		= (EDMA_ERR_D_PAR | EDMA_ERR_PRD_PAR |
-				   EDMA_ERR_DEV_DCON | EDMA_ERR_CRBQ_PAR |
-				   EDMA_ERR_CRPB_PAR | EDMA_ERR_INTRL_PAR |
-				   EDMA_ERR_IORDY | EDMA_ERR_LNK_CTRL_RX_2 |
-				   EDMA_ERR_LNK_DATA_RX |
-				   EDMA_ERR_LNK_DATA_TX |
-				   EDMA_ERR_TRANS_PROTO),
+	EDMA_ERR_OVERRUN_5	= (1 << 5),
+	EDMA_ERR_UNDERRUN_5	= (1 << 6),
+	EDMA_EH_FREEZE		= EDMA_ERR_D_PAR |
+				  EDMA_ERR_PRD_PAR |
+				  EDMA_ERR_DEV_DCON |
+				  EDMA_ERR_DEV_CON |
+				  EDMA_ERR_SERR |
+				  EDMA_ERR_SELF_DIS |
+				  EDMA_ERR_CRBQ_PAR |
+				  EDMA_ERR_CRPB_PAR |
+				  EDMA_ERR_INTRL_PAR |
+				  EDMA_ERR_IORDY |
+				  EDMA_ERR_LNK_CTRL_RX_2 |
+				  EDMA_ERR_LNK_DATA_RX |
+				  EDMA_ERR_LNK_DATA_TX |
+				  EDMA_ERR_TRANS_PROTO,
+	EDMA_EH_FREEZE_5	= EDMA_ERR_D_PAR |
+				  EDMA_ERR_PRD_PAR |
+				  EDMA_ERR_DEV_DCON |
+				  EDMA_ERR_DEV_CON |
+				  EDMA_ERR_OVERRUN_5 |
+				  EDMA_ERR_UNDERRUN_5 |
+				  EDMA_ERR_SELF_DIS_5 |
+				  EDMA_ERR_CRBQ_PAR |
+				  EDMA_ERR_CRPB_PAR |
+				  EDMA_ERR_INTRL_PAR |
+				  EDMA_ERR_IORDY,
 
 	EDMA_REQ_Q_BASE_HI_OFS	= 0x10,
 	EDMA_REQ_Q_IN_PTR_OFS	= 0x14,		/* also contains BASE_LO */
@@ -282,18 +301,18 @@ enum {
 	MV_HP_ERRATA_60X1B2	= (1 << 3),
 	MV_HP_ERRATA_60X1C0	= (1 << 4),
 	MV_HP_ERRATA_XX42A0	= (1 << 5),
-	MV_HP_50XX		= (1 << 6),
-	MV_HP_GEN_IIE		= (1 << 7),
+	MV_HP_GEN_I		= (1 << 6),
+	MV_HP_GEN_II		= (1 << 7),
+	MV_HP_GEN_IIE		= (1 << 8),
 
 	/* Port private flags (pp_flags) */
 	MV_PP_FLAG_EDMA_EN	= (1 << 0),
 	MV_PP_FLAG_EDMA_DS_ACT	= (1 << 1),
+	MV_PP_FLAG_HAD_A_RESET	= (1 << 2),
 };
 
-#define IS_50XX(hpriv) ((hpriv)->hp_flags & MV_HP_50XX)
-#define IS_60XX(hpriv) (((hpriv)->hp_flags & MV_HP_50XX) == 0)
-#define IS_GEN_I(hpriv) IS_50XX(hpriv)
-#define IS_GEN_II(hpriv) IS_60XX(hpriv)
+#define IS_GEN_I(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_I)
+#define IS_GEN_II(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_II)
 #define IS_GEN_IIE(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_IIE)
 
 enum {
@@ -352,6 +371,10 @@ struct mv_port_priv {
 	dma_addr_t		crpb_dma;
 	struct mv_sg		*sg_tbl;
 	dma_addr_t		sg_tbl_dma;
+
+	unsigned int		req_idx;
+	unsigned int		resp_idx;
+
 	u32			pp_flags;
 };
 
@@ -384,14 +407,15 @@ static u32 mv_scr_read(struct ata_port *ap, unsigned int sc_reg_in);
 static void mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
 static u32 mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in);
 static void mv5_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
-static void mv_phy_reset(struct ata_port *ap);
-static void __mv_phy_reset(struct ata_port *ap, int can_sleep);
 static int mv_port_start(struct ata_port *ap);
 static void mv_port_stop(struct ata_port *ap);
 static void mv_qc_prep(struct ata_queued_cmd *qc);
 static void mv_qc_prep_iie(struct ata_queued_cmd *qc);
 static unsigned int mv_qc_issue(struct ata_queued_cmd *qc);
-static void mv_eng_timeout(struct ata_port *ap);
+static void mv_error_handler(struct ata_port *ap);
+static void mv_post_int_cmd(struct ata_queued_cmd *qc);
+static void mv_eh_freeze(struct ata_port *ap);
+static void mv_eh_thaw(struct ata_port *ap);
 static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 
 static void mv5_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
@@ -415,14 +439,31 @@ static void mv6_reset_flash(struct mv_host_priv *hpriv, void __iomem *mmio);
 static void mv_reset_pci_bus(struct pci_dev *pdev, void __iomem *mmio);
 static void mv_channel_reset(struct mv_host_priv *hpriv, void __iomem *mmio,
 			     unsigned int port_no);
-static void mv_stop_and_reset(struct ata_port *ap);
 
-static struct scsi_host_template mv_sht = {
+static struct scsi_host_template mv5_sht = {
+	.module			= THIS_MODULE,
+	.name			= DRV_NAME,
+	.ioctl			= ata_scsi_ioctl,
+	.queuecommand		= ata_scsi_queuecmd,
+	.can_queue		= ATA_DEF_QUEUE,
+	.this_id		= ATA_SHT_THIS_ID,
+	.sg_tablesize		= MV_MAX_SG_CT,
+	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
+	.emulated		= ATA_SHT_EMULATED,
+	.use_clustering		= 1,
+	.proc_name		= DRV_NAME,
+	.dma_boundary		= MV_DMA_BOUNDARY,
+	.slave_configure	= ata_scsi_slave_config,
+	.slave_destroy		= ata_scsi_slave_destroy,
+	.bios_param		= ata_std_bios_param,
+};
+
+static struct scsi_host_template mv6_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.can_queue		= MV_USE_Q_DEPTH,
+	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= MV_MAX_SG_CT,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
@@ -444,19 +485,21 @@ static const struct ata_port_operations mv5_ops = {
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 
-	.phy_reset		= mv_phy_reset,
 	.cable_detect		= ata_cable_sata,
 
 	.qc_prep		= mv_qc_prep,
 	.qc_issue		= mv_qc_issue,
 	.data_xfer		= ata_data_xfer,
 
-	.eng_timeout		= mv_eng_timeout,
-
 	.irq_clear		= mv_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
 
+	.error_handler		= mv_error_handler,
+	.post_internal_cmd	= mv_post_int_cmd,
+	.freeze			= mv_eh_freeze,
+	.thaw			= mv_eh_thaw,
+
 	.scr_read		= mv5_scr_read,
 	.scr_write		= mv5_scr_write,
 
@@ -473,19 +516,21 @@ static const struct ata_port_operations mv6_ops = {
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 
-	.phy_reset		= mv_phy_reset,
 	.cable_detect		= ata_cable_sata,
 
 	.qc_prep		= mv_qc_prep,
 	.qc_issue		= mv_qc_issue,
 	.data_xfer		= ata_data_xfer,
 
-	.eng_timeout		= mv_eng_timeout,
-
 	.irq_clear		= mv_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
 
+	.error_handler		= mv_error_handler,
+	.post_internal_cmd	= mv_post_int_cmd,
+	.freeze			= mv_eh_freeze,
+	.thaw			= mv_eh_thaw,
+
 	.scr_read		= mv_scr_read,
 	.scr_write		= mv_scr_write,
 
@@ -502,19 +547,21 @@ static const struct ata_port_operations mv_iie_ops = {
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 
-	.phy_reset		= mv_phy_reset,
 	.cable_detect		= ata_cable_sata,
 
 	.qc_prep		= mv_qc_prep_iie,
 	.qc_issue		= mv_qc_issue,
 	.data_xfer		= ata_data_xfer,
 
-	.eng_timeout		= mv_eng_timeout,
-
 	.irq_clear		= mv_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
 
+	.error_handler		= mv_error_handler,
+	.post_internal_cmd	= mv_post_int_cmd,
+	.freeze			= mv_eh_freeze,
+	.thaw			= mv_eh_thaw,
+
 	.scr_read		= mv_scr_read,
 	.scr_write		= mv_scr_write,
 
@@ -530,38 +577,38 @@ static const struct ata_port_info mv_port_info[] = {
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_508x */
-		.flags		= (MV_COMMON_FLAGS | MV_FLAG_DUAL_HC),
+		.flags		= MV_COMMON_FLAGS | MV_FLAG_DUAL_HC,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_5080 */
-		.flags		= (MV_COMMON_FLAGS | MV_FLAG_DUAL_HC),
+		.flags		= MV_COMMON_FLAGS | MV_FLAG_DUAL_HC,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_604x */
-		.flags		= (MV_COMMON_FLAGS | MV_6XXX_FLAGS),
+		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_608x */
-		.flags		= (MV_COMMON_FLAGS | MV_6XXX_FLAGS |
-				   MV_FLAG_DUAL_HC),
+		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
+				  MV_FLAG_DUAL_HC,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_6042 */
-		.flags		= (MV_COMMON_FLAGS | MV_6XXX_FLAGS),
+		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
 	},
 	{  /* chip_7042 */
-		.flags		= (MV_COMMON_FLAGS | MV_6XXX_FLAGS),
+		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
@@ -709,6 +756,46 @@ static void mv_irq_clear(struct ata_port *ap)
 {
 }
 
+static void mv_set_edma_ptrs(void __iomem *port_mmio,
+			     struct mv_host_priv *hpriv,
+			     struct mv_port_priv *pp)
+{
+	u32 index;
+
+	/*
+	 * initialize request queue
+	 */
+	index = (pp->req_idx & MV_MAX_Q_DEPTH_MASK) << EDMA_REQ_Q_PTR_SHIFT;
+
+	WARN_ON(pp->crqb_dma & 0x3ff);
+	writel((pp->crqb_dma >> 16) >> 16, port_mmio + EDMA_REQ_Q_BASE_HI_OFS);
+	writelfl((pp->crqb_dma & EDMA_REQ_Q_BASE_LO_MASK) | index,
+		 port_mmio + EDMA_REQ_Q_IN_PTR_OFS);
+
+	if (hpriv->hp_flags & MV_HP_ERRATA_XX42A0)
+		writelfl((pp->crqb_dma & 0xffffffff) | index,
+			 port_mmio + EDMA_REQ_Q_OUT_PTR_OFS);
+	else
+		writelfl(index, port_mmio + EDMA_REQ_Q_OUT_PTR_OFS);
+
+	/*
+	 * initialize response queue
+	 */
+	index = (pp->resp_idx & MV_MAX_Q_DEPTH_MASK) << EDMA_RSP_Q_PTR_SHIFT;
+
+	WARN_ON(pp->crpb_dma & 0xff);
+	writel((pp->crpb_dma >> 16) >> 16, port_mmio + EDMA_RSP_Q_BASE_HI_OFS);
+
+	if (hpriv->hp_flags & MV_HP_ERRATA_XX42A0)
+		writelfl((pp->crpb_dma & 0xffffffff) | index,
+			 port_mmio + EDMA_RSP_Q_IN_PTR_OFS);
+	else
+		writelfl(index, port_mmio + EDMA_RSP_Q_IN_PTR_OFS);
+
+	writelfl((pp->crpb_dma & EDMA_RSP_Q_BASE_LO_MASK) | index,
+		 port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
+}
+
 /**
  *      mv_start_dma - Enable eDMA engine
  *      @base: port base address
@@ -720,9 +807,15 @@ static void mv_irq_clear(struct ata_port *ap)
  *      LOCKING:
  *      Inherited from caller.
  */
-static void mv_start_dma(void __iomem *base, struct mv_port_priv *pp)
+static void mv_start_dma(void __iomem *base, struct mv_host_priv *hpriv,
+			 struct mv_port_priv *pp)
 {
-	if (!(MV_PP_FLAG_EDMA_EN & pp->pp_flags)) {
+	if (!(pp->pp_flags & MV_PP_FLAG_EDMA_EN)) {
+		/* clear EDMA event indicators, if any */
+		writelfl(0, base + EDMA_ERR_IRQ_CAUSE_OFS);
+
+		mv_set_edma_ptrs(base, hpriv, pp);
+
 		writelfl(EDMA_EN, base + EDMA_CMD_OFS);
 		pp->pp_flags |= MV_PP_FLAG_EDMA_EN;
 	}
@@ -739,14 +832,14 @@ static void mv_start_dma(void __iomem *base, struct mv_port_priv *pp)
  *      LOCKING:
  *      Inherited from caller.
  */
-static void mv_stop_dma(struct ata_port *ap)
+static int mv_stop_dma(struct ata_port *ap)
 {
 	void __iomem *port_mmio = mv_ap_base(ap);
 	struct mv_port_priv *pp	= ap->private_data;
 	u32 reg;
-	int i;
+	int i, err = 0;
 
-	if (MV_PP_FLAG_EDMA_EN & pp->pp_flags) {
+	if (pp->pp_flags & MV_PP_FLAG_EDMA_EN) {
 		/* Disable EDMA if active.   The disable bit auto clears.
 		 */
 		writelfl(EDMA_DS, port_mmio + EDMA_CMD_OFS);
@@ -758,16 +851,18 @@ static void mv_stop_dma(struct ata_port *ap)
 	/* now properly wait for the eDMA to stop */
 	for (i = 1000; i > 0; i--) {
 		reg = readl(port_mmio + EDMA_CMD_OFS);
-		if (!(EDMA_EN & reg)) {
+		if (!(reg & EDMA_EN))
 			break;
-		}
+
 		udelay(100);
 	}
 
-	if (EDMA_EN & reg) {
+	if (reg & EDMA_EN) {
 		ata_port_printk(ap, KERN_ERR, "Unable to stop eDMA\n");
-		/* FIXME: Consider doing a reset here to recover */
+		err = -EIO;
 	}
+
+	return err;
 }
 
 #ifdef ATA_DEBUG
@@ -884,12 +979,13 @@ static void mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val)
 		writelfl(val, mv_ap_base(ap) + ofs);
 }
 
-static void mv_edma_cfg(struct mv_host_priv *hpriv, void __iomem *port_mmio)
+static void mv_edma_cfg(struct ata_port *ap, struct mv_host_priv *hpriv,
+			void __iomem *port_mmio)
 {
 	u32 cfg = readl(port_mmio + EDMA_CFG_OFS);
 
 	/* set up non-NCQ EDMA configuration */
-	cfg &= ~(1 << 9);	/* disable equeue */
+	cfg &= ~(1 << 9);	/* disable eQue */
 
 	if (IS_GEN_I(hpriv)) {
 		cfg &= ~0x1f;		/* clear queue depth */
@@ -909,7 +1005,7 @@ static void mv_edma_cfg(struct mv_host_priv *hpriv, void __iomem *port_mmio)
 		cfg |= (1 << 18);	/* enab early completion */
 		cfg |= (1 << 17);	/* enab cut-through (dis stor&forwrd) */
 		cfg &= ~(1 << 16);	/* dis FIS-based switching (for now) */
-		cfg &= ~(EDMA_CFG_NCQ | EDMA_CFG_NCQ_GO_ON_ERR); /* clear NCQ */
+		cfg &= ~(EDMA_CFG_NCQ);	/* clear NCQ */
 	}
 
 	writelfl(cfg, port_mmio + EDMA_CFG_OFS);
@@ -971,28 +1067,9 @@ static int mv_port_start(struct ata_port *ap)
 	pp->sg_tbl = mem;
 	pp->sg_tbl_dma = mem_dma;
 
-	mv_edma_cfg(hpriv, port_mmio);
+	mv_edma_cfg(ap, hpriv, port_mmio);
 
-	writel((pp->crqb_dma >> 16) >> 16, port_mmio + EDMA_REQ_Q_BASE_HI_OFS);
-	writelfl(pp->crqb_dma & EDMA_REQ_Q_BASE_LO_MASK,
-		 port_mmio + EDMA_REQ_Q_IN_PTR_OFS);
-
-	if (hpriv->hp_flags & MV_HP_ERRATA_XX42A0)
-		writelfl(pp->crqb_dma & 0xffffffff,
-			 port_mmio + EDMA_REQ_Q_OUT_PTR_OFS);
-	else
-		writelfl(0, port_mmio + EDMA_REQ_Q_OUT_PTR_OFS);
-
-	writel((pp->crpb_dma >> 16) >> 16, port_mmio + EDMA_RSP_Q_BASE_HI_OFS);
-
-	if (hpriv->hp_flags & MV_HP_ERRATA_XX42A0)
-		writelfl(pp->crpb_dma & 0xffffffff,
-			 port_mmio + EDMA_RSP_Q_IN_PTR_OFS);
-	else
-		writelfl(0, port_mmio + EDMA_RSP_Q_IN_PTR_OFS);
-
-	writelfl(pp->crpb_dma & EDMA_RSP_Q_BASE_LO_MASK,
-		 port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
+	mv_set_edma_ptrs(port_mmio, hpriv, pp);
 
 	/* Don't turn on EDMA here...do it before DMA commands only.  Else
 	 * we'll be unable to send non-data, PIO, etc due to restricted access
@@ -1055,11 +1132,6 @@ static unsigned int mv_fill_sg(struct ata_queued_cmd *qc)
 	return n_sg;
 }
 
-static inline unsigned mv_inc_q_index(unsigned index)
-{
-	return (index + 1) & MV_MAX_Q_DEPTH_MASK;
-}
-
 static inline void mv_crqb_pack_cmd(__le16 *cmdw, u8 data, u8 addr, unsigned last)
 {
 	u16 tmp = data | (addr << CRQB_CMD_ADDR_SHIFT) | CRQB_CMD_CS |
@@ -1088,7 +1160,7 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 	u16 flags = 0;
 	unsigned in_index;
 
- 	if (ATA_PROT_DMA != qc->tf.protocol)
+ 	if (qc->tf.protocol != ATA_PROT_DMA)
 		return;
 
 	/* Fill in command request block
@@ -1097,10 +1169,10 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 		flags |= CRQB_FLAG_READ;
 	WARN_ON(MV_MAX_Q_DEPTH <= qc->tag);
 	flags |= qc->tag << CRQB_TAG_SHIFT;
+	flags |= qc->tag << CRQB_IOID_SHIFT;	/* 50xx appears to ignore this*/
 
-	/* get current queue index from hardware */
-	in_index = (readl(mv_ap_base(ap) + EDMA_REQ_Q_IN_PTR_OFS)
-			>> EDMA_REQ_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK;
+	/* get current queue index from software */
+	in_index = pp->req_idx & MV_MAX_Q_DEPTH_MASK;
 
 	pp->crqb[in_index].sg_addr =
 		cpu_to_le32(pp->sg_tbl_dma & 0xffffffff);
@@ -1180,7 +1252,7 @@ static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
 	unsigned in_index;
 	u32 flags = 0;
 
- 	if (ATA_PROT_DMA != qc->tf.protocol)
+ 	if (qc->tf.protocol != ATA_PROT_DMA)
 		return;
 
 	/* Fill in Gen IIE command request block
@@ -1190,10 +1262,11 @@ static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
 
 	WARN_ON(MV_MAX_Q_DEPTH <= qc->tag);
 	flags |= qc->tag << CRQB_TAG_SHIFT;
+	flags |= qc->tag << CRQB_IOID_SHIFT;	/* "I/O Id" is -really-
+						   what we use as our tag */
 
-	/* get current queue index from hardware */
-	in_index = (readl(mv_ap_base(ap) + EDMA_REQ_Q_IN_PTR_OFS)
-			>> EDMA_REQ_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK;
+	/* get current queue index from software */
+	in_index = pp->req_idx & MV_MAX_Q_DEPTH_MASK;
 
 	crqb = (struct mv_crqb_iie *) &pp->crqb[in_index];
 	crqb->addr = cpu_to_le32(pp->sg_tbl_dma & 0xffffffff);
@@ -1241,83 +1314,41 @@ static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
  */
 static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 {
-	void __iomem *port_mmio = mv_ap_base(qc->ap);
-	struct mv_port_priv *pp = qc->ap->private_data;
-	unsigned in_index;
-	u32 in_ptr;
+	struct ata_port *ap = qc->ap;
+	void __iomem *port_mmio = mv_ap_base(ap);
+	struct mv_port_priv *pp = ap->private_data;
+	struct mv_host_priv *hpriv = ap->host->private_data;
+	u32 in_index;
 
-	if (ATA_PROT_DMA != qc->tf.protocol) {
+	if (qc->tf.protocol != ATA_PROT_DMA) {
 		/* We're about to send a non-EDMA capable command to the
 		 * port.  Turn off EDMA so there won't be problems accessing
 		 * shadow block, etc registers.
 		 */
-		mv_stop_dma(qc->ap);
+		mv_stop_dma(ap);
 		return ata_qc_issue_prot(qc);
 	}
 
-	in_ptr   = readl(port_mmio + EDMA_REQ_Q_IN_PTR_OFS);
-	in_index = (in_ptr >> EDMA_REQ_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK;
+	mv_start_dma(port_mmio, hpriv, pp);
+
+	in_index = pp->req_idx & MV_MAX_Q_DEPTH_MASK;
 
 	/* until we do queuing, the queue should be empty at this point */
 	WARN_ON(in_index != ((readl(port_mmio + EDMA_REQ_Q_OUT_PTR_OFS)
 		>> EDMA_REQ_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK));
 
-	in_index = mv_inc_q_index(in_index);	/* now incr producer index */
+	pp->req_idx++;
 
-	mv_start_dma(port_mmio, pp);
+	in_index = (pp->req_idx & MV_MAX_Q_DEPTH_MASK) << EDMA_REQ_Q_PTR_SHIFT;
 
 	/* and write the request in pointer to kick the EDMA to life */
-	in_ptr &= EDMA_REQ_Q_BASE_LO_MASK;
-	in_ptr |= in_index << EDMA_REQ_Q_PTR_SHIFT;
-	writelfl(in_ptr, port_mmio + EDMA_REQ_Q_IN_PTR_OFS);
+	writelfl((pp->crqb_dma & EDMA_REQ_Q_BASE_LO_MASK) | in_index,
+		 port_mmio + EDMA_REQ_Q_IN_PTR_OFS);
 
 	return 0;
 }
 
 /**
- *      mv_get_crpb_status - get status from most recently completed cmd
- *      @ap: ATA channel to manipulate
- *
- *      This routine is for use when the port is in DMA mode, when it
- *      will be using the CRPB (command response block) method of
- *      returning command completion information.  We check indices
- *      are good, grab status, and bump the response consumer index to
- *      prove that we're up to date.
- *
- *      LOCKING:
- *      Inherited from caller.
- */
-static u8 mv_get_crpb_status(struct ata_port *ap)
-{
-	void __iomem *port_mmio = mv_ap_base(ap);
-	struct mv_port_priv *pp = ap->private_data;
-	unsigned out_index;
-	u32 out_ptr;
-	u8 ata_status;
-
-	out_ptr   = readl(port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
-	out_index = (out_ptr >> EDMA_RSP_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK;
-
-	ata_status = le16_to_cpu(pp->crpb[out_index].flags)
-					>> CRPB_FLAG_STATUS_SHIFT;
-
-	/* increment our consumer index... */
-	out_index = mv_inc_q_index(out_index);
-
-	/* and, until we do NCQ, there should only be 1 CRPB waiting */
-	WARN_ON(out_index != ((readl(port_mmio + EDMA_RSP_Q_IN_PTR_OFS)
-		>> EDMA_RSP_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK));
-
-	/* write out our inc'd consumer index so EDMA knows we're caught up */
-	out_ptr &= EDMA_RSP_Q_BASE_LO_MASK;
-	out_ptr |= out_index << EDMA_RSP_Q_PTR_SHIFT;
-	writelfl(out_ptr, port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
-
-	/* Return ATA status register for completed CRPB */
-	return ata_status;
-}
-
-/**
  *      mv_err_intr - Handle error interrupts on the port
  *      @ap: ATA channel to manipulate
  *      @reset_allowed: bool: 0 == don't trigger from reset here
@@ -1331,30 +1362,191 @@ static u8 mv_get_crpb_status(struct ata_port *ap)
  *      LOCKING:
  *      Inherited from caller.
  */
-static void mv_err_intr(struct ata_port *ap, int reset_allowed)
+static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 {
 	void __iomem *port_mmio = mv_ap_base(ap);
-	u32 edma_err_cause, serr = 0;
+	u32 edma_err_cause, eh_freeze_mask, serr = 0;
+	struct mv_port_priv *pp = ap->private_data;
+	struct mv_host_priv *hpriv = ap->host->private_data;
+	unsigned int edma_enabled = (pp->pp_flags & MV_PP_FLAG_EDMA_EN);
+	unsigned int action = 0, err_mask = 0;
+	struct ata_eh_info *ehi = &ap->eh_info;
 
-	edma_err_cause = readl(port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
+	ata_ehi_clear_desc(ehi);
 
-	if (EDMA_ERR_SERR & edma_err_cause) {
+	if (!edma_enabled) {
+		/* just a guess: do we need to do this? should we
+		 * expand this, and do it in all cases?
+		 */
 		sata_scr_read(ap, SCR_ERROR, &serr);
 		sata_scr_write_flush(ap, SCR_ERROR, serr);
 	}
-	if (EDMA_ERR_SELF_DIS & edma_err_cause) {
-		struct mv_port_priv *pp	= ap->private_data;
-		pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
+
+	edma_err_cause = readl(port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
+
+	ata_ehi_push_desc(ehi, "edma_err 0x%08x", edma_err_cause);
+
+	/*
+	 * all generations share these EDMA error cause bits
+	 */
+
+	if (edma_err_cause & EDMA_ERR_DEV)
+		err_mask |= AC_ERR_DEV;
+	if (edma_err_cause & (EDMA_ERR_D_PAR | EDMA_ERR_PRD_PAR |
+			EDMA_ERR_CRBQ_PAR | EDMA_ERR_CRPB_PAR |
+			EDMA_ERR_INTRL_PAR)) {
+		err_mask |= AC_ERR_ATA_BUS;
+		action |= ATA_EH_HARDRESET;
+		ata_ehi_push_desc(ehi, ", parity error");
+	}
+	if (edma_err_cause & (EDMA_ERR_DEV_DCON | EDMA_ERR_DEV_CON)) {
+		ata_ehi_hotplugged(ehi);
+		ata_ehi_push_desc(ehi, edma_err_cause & EDMA_ERR_DEV_DCON ?
+			", dev disconnect" : ", dev connect");
+	}
+
+	if (IS_GEN_I(hpriv)) {
+		eh_freeze_mask = EDMA_EH_FREEZE_5;
+
+		if (edma_err_cause & EDMA_ERR_SELF_DIS_5) {
+			struct mv_port_priv *pp	= ap->private_data;
+			pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
+			ata_ehi_push_desc(ehi, ", EDMA self-disable");
+		}
+	} else {
+		eh_freeze_mask = EDMA_EH_FREEZE;
+
+		if (edma_err_cause & EDMA_ERR_SELF_DIS) {
+			struct mv_port_priv *pp	= ap->private_data;
+			pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
+			ata_ehi_push_desc(ehi, ", EDMA self-disable");
+		}
+
+		if (edma_err_cause & EDMA_ERR_SERR) {
+			sata_scr_read(ap, SCR_ERROR, &serr);
+			sata_scr_write_flush(ap, SCR_ERROR, serr);
+			err_mask = AC_ERR_ATA_BUS;
+			action |= ATA_EH_HARDRESET;
+		}
 	}
-	DPRINTK(KERN_ERR "ata%u: port error; EDMA err cause: 0x%08x "
-		"SERR: 0x%08x\n", ap->print_id, edma_err_cause, serr);
 
 	/* Clear EDMA now that SERR cleanup done */
 	writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 
-	/* check for fatal here and recover if needed */
-	if (reset_allowed && (EDMA_ERR_FATAL & edma_err_cause))
-		mv_stop_and_reset(ap);
+	if (!err_mask) {
+		err_mask = AC_ERR_OTHER;
+		action |= ATA_EH_HARDRESET;
+	}
+
+	ehi->serror |= serr;
+	ehi->action |= action;
+
+	if (qc)
+		qc->err_mask |= err_mask;
+	else
+		ehi->err_mask |= err_mask;
+
+	if (edma_err_cause & eh_freeze_mask)
+		ata_port_freeze(ap);
+	else
+		ata_port_abort(ap);
+}
+
+static void mv_intr_pio(struct ata_port *ap)
+{
+	struct ata_queued_cmd *qc;
+	u8 ata_status;
+
+	/* ignore spurious intr if drive still BUSY */
+	ata_status = readb(ap->ioaddr.status_addr);
+	if (unlikely(ata_status & ATA_BUSY))
+		return;
+
+	/* get active ATA command */
+	qc = ata_qc_from_tag(ap, ap->active_tag);
+	if (unlikely(!qc))			/* no active tag */
+		return;
+	if (qc->tf.flags & ATA_TFLAG_POLLING)	/* polling; we don't own qc */
+		return;
+
+	/* and finally, complete the ATA command */
+	qc->err_mask |= ac_err_mask(ata_status);
+	ata_qc_complete(qc);
+}
+
+static void mv_intr_edma(struct ata_port *ap)
+{
+	void __iomem *port_mmio = mv_ap_base(ap);
+	struct mv_host_priv *hpriv = ap->host->private_data;
+	struct mv_port_priv *pp = ap->private_data;
+	struct ata_queued_cmd *qc;
+	u32 out_index, in_index;
+	bool work_done = false;
+
+	/* get h/w response queue pointer */
+	in_index = (readl(port_mmio + EDMA_RSP_Q_IN_PTR_OFS)
+			>> EDMA_RSP_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK;
+
+	while (1) {
+		u16 status;
+
+		/* get s/w response queue last-read pointer, and compare */
+		out_index = pp->resp_idx & MV_MAX_Q_DEPTH_MASK;
+		if (in_index == out_index)
+			break;
+
+		 
+		/* 50xx: get active ATA command */
+		if (IS_GEN_I(hpriv)) 
+			qc = ata_qc_from_tag(ap, ap->active_tag);
+
+		/* 60xx: get active ATA command via tag, to enable support
+		 * for queueing.  this works transparently for queued and
+		 * non-queued modes.
+		 */
+		else {
+			unsigned int tag;
+
+			if (IS_GEN_II(hpriv))
+				tag = (le16_to_cpu(pp->crpb[out_index].id)
+					>> CRPB_IOID_SHIFT_6) & 0x3f;
+			else
+				tag = (le16_to_cpu(pp->crpb[out_index].id)
+					>> CRPB_IOID_SHIFT_7) & 0x3f;
+
+			qc = ata_qc_from_tag(ap, tag);
+		}
+
+		/* lower 8 bits of status are EDMA_ERR_IRQ_CAUSE_OFS
+		 * bits (WARNING: might not necessarily be associated
+		 * with this command), which -should- be clear
+		 * if all is well
+		 */
+		status = le16_to_cpu(pp->crpb[out_index].flags);
+		if (unlikely(status & 0xff)) {
+			mv_err_intr(ap, qc);
+			return;
+		}
+
+		/* and finally, complete the ATA command */
+		if (qc) {
+			qc->err_mask |=
+				ac_err_mask(status >> CRPB_FLAG_STATUS_SHIFT);
+			ata_qc_complete(qc);
+		}
+
+		/* advance software response queue pointer, to 
+		 * indicate (after the loop completes) to hardware
+		 * that we have consumed a response queue entry.
+		 */
+		work_done = true;
+		pp->resp_idx++;
+	}
+
+	if (work_done)
+		writelfl((pp->crpb_dma & EDMA_RSP_Q_BASE_LO_MASK) |
+			 (out_index << EDMA_RSP_Q_PTR_SHIFT),
+			 port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
 }
 
 /**
@@ -1377,10 +1569,8 @@ static void mv_host_intr(struct ata_host *host, u32 relevant, unsigned int hc)
 {
 	void __iomem *mmio = host->iomap[MV_PRIMARY_BAR];
 	void __iomem *hc_mmio = mv_hc_base(mmio, hc);
-	struct ata_queued_cmd *qc;
 	u32 hc_irq_cause;
-	int shift, port, port0, hard_port, handled;
-	unsigned int err_mask;
+	int port, port0;
 
 	if (hc == 0)
 		port0 = 0;
@@ -1389,79 +1579,95 @@ static void mv_host_intr(struct ata_host *host, u32 relevant, unsigned int hc)
 
 	/* we'll need the HC success int register in most cases */
 	hc_irq_cause = readl(hc_mmio + HC_IRQ_CAUSE_OFS);
-	if (hc_irq_cause)
-		writelfl(~hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
+	if (!hc_irq_cause)
+		return;
+
+	writelfl(~hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
 
 	VPRINTK("ENTER, hc%u relevant=0x%08x HC IRQ cause=0x%08x\n",
 		hc,relevant,hc_irq_cause);
 
 	for (port = port0; port < port0 + MV_PORTS_PER_HC; port++) {
-		u8 ata_status = 0;
 		struct ata_port *ap = host->ports[port];
 		struct mv_port_priv *pp = ap->private_data;
+		int have_err_bits, hard_port, shift;
+
+		if ((!ap) || (ap->flags & ATA_FLAG_DISABLED))
+			continue;
+
+		shift = port << 1;		/* (port * 2) */
+		if (port >= MV_PORTS_PER_HC) {
+			shift++;	/* skip bit 8 in the HC Main IRQ reg */
+		}
+		have_err_bits = ((PORT0_ERR << shift) & relevant);
+
+		if (unlikely(have_err_bits)) {
+			struct ata_queued_cmd *qc;
+
+			qc = ata_qc_from_tag(ap, ap->active_tag);
+			if (qc && (qc->tf.flags & ATA_TFLAG_POLLING))
+				continue;
+
+			mv_err_intr(ap, qc);
+			continue;
+		}
 
 		hard_port = mv_hardport_from_port(port); /* range 0..3 */
-		handled = 0;	/* ensure ata_status is set if handled++ */
 
-		/* Note that DEV_IRQ might happen spuriously during EDMA,
-		 * and should be ignored in such cases.
-		 * The cause of this is still under investigation.
-		 */
 		if (pp->pp_flags & MV_PP_FLAG_EDMA_EN) {
-			/* EDMA: check for response queue interrupt */
-			if ((CRPB_DMA_DONE << hard_port) & hc_irq_cause) {
-				ata_status = mv_get_crpb_status(ap);
-				handled = 1;
-			}
+			if ((CRPB_DMA_DONE << hard_port) & hc_irq_cause)
+				mv_intr_edma(ap);
 		} else {
-			/* PIO: check for device (drive) interrupt */
-			if ((DEV_IRQ << hard_port) & hc_irq_cause) {
-				ata_status = readb(ap->ioaddr.status_addr);
-				handled = 1;
-				/* ignore spurious intr if drive still BUSY */
-				if (ata_status & ATA_BUSY) {
-					ata_status = 0;
-					handled = 0;
-				}
-			}
+			if ((DEV_IRQ << hard_port) & hc_irq_cause)
+				mv_intr_pio(ap);
 		}
+	}
+	VPRINTK("EXIT\n");
+}
 
-		if (ap && (ap->flags & ATA_FLAG_DISABLED))
-			continue;
+static void mv_pci_error(struct ata_host *host, void __iomem *mmio)
+{
+	struct ata_port *ap;
+	struct ata_queued_cmd *qc;
+	struct ata_eh_info *ehi;
+	unsigned int i, err_mask, printed = 0;
+	u32 err_cause;
 
-		err_mask = ac_err_mask(ata_status);
+	err_cause = readl(mmio + PCI_IRQ_CAUSE_OFS);
 
-		shift = port << 1;		/* (port * 2) */
-		if (port >= MV_PORTS_PER_HC) {
-			shift++;	/* skip bit 8 in the HC Main IRQ reg */
-		}
-		if ((PORT0_ERR << shift) & relevant) {
-			mv_err_intr(ap, 1);
-			err_mask |= AC_ERR_OTHER;
-			handled = 1;
-		}
+	dev_printk(KERN_ERR, host->dev, "PCI ERROR; PCI IRQ cause=0x%08x\n",
+		   err_cause);
+
+	DPRINTK("All regs @ PCI error\n");
+	mv_dump_all_regs(mmio, -1, to_pci_dev(host->dev));
+
+	writelfl(0, mmio + PCI_IRQ_CAUSE_OFS);
 
-		if (handled) {
+	for (i = 0; i < host->n_ports; i++) {
+		ap = host->ports[i];
+		if (!ata_port_offline(ap)) {
+			ehi = &ap->eh_info;
+			ata_ehi_clear_desc(ehi);
+			if (!printed++)
+				ata_ehi_push_desc(ehi,
+					"PCI err cause 0x%08x", err_cause);
+			err_mask = AC_ERR_HOST_BUS;
+			ehi->action = ATA_EH_HARDRESET;
 			qc = ata_qc_from_tag(ap, ap->active_tag);
-			if (qc && (qc->flags & ATA_QCFLAG_ACTIVE)) {
-				VPRINTK("port %u IRQ found for qc, "
-					"ata_status 0x%x\n", port,ata_status);
-				/* mark qc status appropriately */
-				if (!(qc->tf.flags & ATA_TFLAG_POLLING)) {
-					qc->err_mask |= err_mask;
-					ata_qc_complete(qc);
-				}
-			}
+			if (qc)
+				qc->err_mask |= err_mask;
+			else
+				ehi->err_mask |= err_mask;
+
+			ata_port_freeze(ap);
 		}
 	}
-	VPRINTK("EXIT\n");
 }
 
 /**
- *      mv_interrupt -
+ *      mv_interrupt - Main interrupt event handler
  *      @irq: unused
  *      @dev_instance: private data; in this case the host structure
- *      @regs: unused
  *
  *      Read the read only register to determine if any host
  *      controllers have pending interrupts.  If so, call lower level
@@ -1477,7 +1683,6 @@ static irqreturn_t mv_interrupt(int irq, void *dev_instance)
 	struct ata_host *host = dev_instance;
 	unsigned int hc, handled = 0, n_hcs;
 	void __iomem *mmio = host->iomap[MV_PRIMARY_BAR];
-	struct mv_host_priv *hpriv;
 	u32 irq_stat;
 
 	irq_stat = readl(mmio + HC_MAIN_IRQ_CAUSE_OFS);
@@ -1491,34 +1696,21 @@ static irqreturn_t mv_interrupt(int irq, void *dev_instance)
 	n_hcs = mv_get_hc_count(host->ports[0]->flags);
 	spin_lock(&host->lock);
 
+	if (unlikely(irq_stat & PCI_ERR)) {
+		mv_pci_error(host, mmio);
+		handled = 1;
+		goto out_unlock;	/* skip all other HC irq handling */
+	}
+
 	for (hc = 0; hc < n_hcs; hc++) {
 		u32 relevant = irq_stat & (HC0_IRQ_PEND << (hc * HC_SHIFT));
 		if (relevant) {
 			mv_host_intr(host, relevant, hc);
-			handled++;
-		}
-	}
-
-	hpriv = host->private_data;
-	if (IS_60XX(hpriv)) {
-		/* deal with the interrupt coalescing bits */
-		if (irq_stat & (TRAN_LO_DONE | TRAN_HI_DONE | PORTS_0_7_COAL_DONE)) {
-			writelfl(0, mmio + MV_IRQ_COAL_CAUSE_LO);
-			writelfl(0, mmio + MV_IRQ_COAL_CAUSE_HI);
-			writelfl(0, mmio + MV_IRQ_COAL_CAUSE);
+			handled = 1;
 		}
 	}
 
-	if (PCI_ERR & irq_stat) {
-		printk(KERN_ERR DRV_NAME ": PCI ERROR; PCI IRQ cause=0x%08x\n",
-		       readl(mmio + PCI_IRQ_CAUSE_OFS));
-
-		DPRINTK("All regs @ PCI error\n");
-		mv_dump_all_regs(mmio, -1, to_pci_dev(host->dev));
-
-		writelfl(0, mmio + PCI_IRQ_CAUSE_OFS);
-		handled++;
-	}
+out_unlock:
 	spin_unlock(&host->lock);
 
 	return IRQ_RETVAL(handled);
@@ -1907,7 +2099,7 @@ static void mv_channel_reset(struct mv_host_priv *hpriv, void __iomem *mmio,
 
 	writelfl(ATA_RST, port_mmio + EDMA_CMD_OFS);
 
-	if (IS_60XX(hpriv)) {
+	if (IS_GEN_II(hpriv)) {
 		u32 ifctl = readl(port_mmio + SATA_INTERFACE_CTL);
 		ifctl |= (1 << 7);		/* enable gen2i speed */
 		ifctl = (ifctl & 0xfff) | 0x9b1000; /* from chip spec */
@@ -1923,32 +2115,12 @@ static void mv_channel_reset(struct mv_host_priv *hpriv, void __iomem *mmio,
 
 	hpriv->ops->phy_errata(hpriv, mmio, port_no);
 
-	if (IS_50XX(hpriv))
+	if (IS_GEN_I(hpriv))
 		mdelay(1);
 }
 
-static void mv_stop_and_reset(struct ata_port *ap)
-{
-	struct mv_host_priv *hpriv = ap->host->private_data;
-	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
-
-	mv_stop_dma(ap);
-
-	mv_channel_reset(hpriv, mmio, ap->port_no);
-
-	__mv_phy_reset(ap, 0);
-}
-
-static inline void __msleep(unsigned int msec, int can_sleep)
-{
-	if (can_sleep)
-		msleep(msec);
-	else
-		mdelay(msec);
-}
-
 /**
- *      __mv_phy_reset - Perform eDMA reset followed by COMRESET
+ *      mv_phy_reset - Perform eDMA reset followed by COMRESET
  *      @ap: ATA channel to manipulate
  *
  *      Part of this is taken from __sata_phy_reset and modified to
@@ -1958,14 +2130,12 @@ static inline void __msleep(unsigned int msec, int can_sleep)
  *      Inherited from caller.  This is coded to safe to call at
  *      interrupt level, i.e. it does not sleep.
  */
-static void __mv_phy_reset(struct ata_port *ap, int can_sleep)
+static void mv_phy_reset(struct ata_port *ap, unsigned int *class,
+			 unsigned long deadline)
 {
 	struct mv_port_priv *pp	= ap->private_data;
 	struct mv_host_priv *hpriv = ap->host->private_data;
 	void __iomem *port_mmio = mv_ap_base(ap);
-	struct ata_taskfile tf;
-	struct ata_device *dev = &ap->device[0];
-	unsigned long timeout;
 	int retry = 5;
 	u32 sstatus;
 
@@ -1978,22 +2148,21 @@ static void __mv_phy_reset(struct ata_port *ap, int can_sleep)
 	/* Issue COMRESET via SControl */
 comreset_retry:
 	sata_scr_write_flush(ap, SCR_CONTROL, 0x301);
-	__msleep(1, can_sleep);
+	msleep(1);
 
 	sata_scr_write_flush(ap, SCR_CONTROL, 0x300);
-	__msleep(20, can_sleep);
+	msleep(20);
 
-	timeout = jiffies + msecs_to_jiffies(200);
 	do {
 		sata_scr_read(ap, SCR_STATUS, &sstatus);
 		if (((sstatus & 0x3) == 3) || ((sstatus & 0x3) == 0))
 			break;
 
-		__msleep(1, can_sleep);
-	} while (time_before(jiffies, timeout));
+		msleep(1);
+	} while (time_before(jiffies, deadline));
 
 	/* work around errata */
-	if (IS_60XX(hpriv) &&
+	if (IS_GEN_II(hpriv) &&
 	    (sstatus != 0x0) && (sstatus != 0x113) && (sstatus != 0x123) &&
 	    (retry-- > 0))
 		goto comreset_retry;
@@ -2002,13 +2171,8 @@ comreset_retry:
 		"SCtrl 0x%08x\n", mv_scr_read(ap, SCR_STATUS),
 		mv_scr_read(ap, SCR_ERROR), mv_scr_read(ap, SCR_CONTROL));
 
-	if (ata_port_online(ap)) {
-		ata_port_probe(ap);
-	} else {
-		sata_scr_read(ap, SCR_STATUS, &sstatus);
-		ata_port_printk(ap, KERN_INFO,
-				"no device found (phy stat %08x)\n", sstatus);
-		ata_port_disable(ap);
+	if (ata_port_offline(ap)) {
+		*class = ATA_DEV_NONE;
 		return;
 	}
 
@@ -2022,68 +2186,152 @@ comreset_retry:
 		u8 drv_stat = ata_check_status(ap);
 		if ((drv_stat != 0x80) && (drv_stat != 0x7f))
 			break;
-		__msleep(500, can_sleep);
+		msleep(500);
 		if (retry-- <= 0)
 			break;
+		if (time_after(jiffies, deadline))
+			break;
 	}
 
-	tf.lbah = readb(ap->ioaddr.lbah_addr);
-	tf.lbam = readb(ap->ioaddr.lbam_addr);
-	tf.lbal = readb(ap->ioaddr.lbal_addr);
-	tf.nsect = readb(ap->ioaddr.nsect_addr);
+	/* FIXME: if we passed the deadline, the following
+	 * code probably produces an invalid result
+	 */
 
-	dev->class = ata_dev_classify(&tf);
-	if (!ata_dev_enabled(dev)) {
-		VPRINTK("Port disabled post-sig: No device present.\n");
-		ata_port_disable(ap);
-	}
+	/* finally, read device signature from TF registers */
+	*class = ata_dev_try_classify(ap, 0, NULL);
 
 	writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 
-	pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
+	WARN_ON(pp->pp_flags & MV_PP_FLAG_EDMA_EN);
 
 	VPRINTK("EXIT\n");
 }
 
-static void mv_phy_reset(struct ata_port *ap)
+static int mv_prereset(struct ata_port *ap, unsigned long deadline)
 {
-	__mv_phy_reset(ap, 1);
+	struct mv_port_priv *pp	= ap->private_data;
+	struct ata_eh_context *ehc = &ap->eh_context;
+	int rc;
+	
+	rc = mv_stop_dma(ap);
+	if (rc)
+		ehc->i.action |= ATA_EH_HARDRESET;
+
+	if (!(pp->pp_flags & MV_PP_FLAG_HAD_A_RESET)) {
+		pp->pp_flags |= MV_PP_FLAG_HAD_A_RESET;
+		ehc->i.action |= ATA_EH_HARDRESET;
+	}
+
+	/* if we're about to do hardreset, nothing more to do */
+	if (ehc->i.action & ATA_EH_HARDRESET)
+		return 0;
+
+	if (ata_port_online(ap))
+		rc = ata_wait_ready(ap, deadline);
+	else
+		rc = -ENODEV;
+
+	return rc;
 }
 
-/**
- *      mv_eng_timeout - Routine called by libata when SCSI times out I/O
- *      @ap: ATA channel to manipulate
- *
- *      Intent is to clear all pending error conditions, reset the
- *      chip/bus, fail the command, and move on.
- *
- *      LOCKING:
- *      This routine holds the host lock while failing the command.
- */
-static void mv_eng_timeout(struct ata_port *ap)
+static int mv_hardreset(struct ata_port *ap, unsigned int *class,
+			unsigned long deadline)
 {
+	struct mv_host_priv *hpriv = ap->host->private_data;
 	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
-	struct ata_queued_cmd *qc;
-	unsigned long flags;
 
-	ata_port_printk(ap, KERN_ERR, "Entering mv_eng_timeout\n");
-	DPRINTK("All regs @ start of eng_timeout\n");
-	mv_dump_all_regs(mmio, ap->port_no, to_pci_dev(ap->host->dev));
+	mv_stop_dma(ap);
 
-	qc = ata_qc_from_tag(ap, ap->active_tag);
-        printk(KERN_ERR "mmio_base %p ap %p qc %p scsi_cmnd %p &cmnd %p\n",
-	       mmio, ap, qc, qc->scsicmd, &qc->scsicmd->cmnd);
+	mv_channel_reset(hpriv, mmio, ap->port_no);
 
-	spin_lock_irqsave(&ap->host->lock, flags);
-	mv_err_intr(ap, 0);
-	mv_stop_and_reset(ap);
-	spin_unlock_irqrestore(&ap->host->lock, flags);
+	mv_phy_reset(ap, class, deadline);
+
+	return 0;
+}
+
+static void mv_postreset(struct ata_port *ap, unsigned int *classes)
+{
+	u32 serr;
+
+	/* print link status */
+	sata_print_link_status(ap);
+
+	/* clear SError */
+	sata_scr_read(ap, SCR_ERROR, &serr);
+	sata_scr_write_flush(ap, SCR_ERROR, serr);
 
-	WARN_ON(!(qc->flags & ATA_QCFLAG_ACTIVE));
-	if (qc->flags & ATA_QCFLAG_ACTIVE) {
-		qc->err_mask |= AC_ERR_TIMEOUT;
-		ata_eh_qc_complete(qc);
+	/* bail out if no device is present */
+	if (classes[0] == ATA_DEV_NONE && classes[1] == ATA_DEV_NONE) {
+		DPRINTK("EXIT, no device\n");
+		return;
 	}
+
+	/* set up device control */
+	iowrite8(ap->ctl, ap->ioaddr.ctl_addr);
+}
+
+static void mv_error_handler(struct ata_port *ap)
+{
+	ata_do_eh(ap, mv_prereset, ata_std_softreset,
+		  mv_hardreset, mv_postreset);
+}
+
+static void mv_post_int_cmd(struct ata_queued_cmd *qc)
+{
+	mv_stop_dma(qc->ap);
+}
+
+static void mv_eh_freeze(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
+	unsigned int hc = (ap->port_no > 3) ? 1 : 0;
+	u32 tmp, mask;
+	unsigned int shift;
+
+	/* FIXME: handle coalescing completion events properly */
+
+	shift = ap->port_no * 2;
+	if (hc > 0)
+		shift++;
+
+	mask = 0x3 << shift;
+
+	/* disable assertion of portN err, done events */
+	tmp = readl(mmio + HC_MAIN_IRQ_MASK_OFS);
+	writelfl(tmp & ~mask, mmio + HC_MAIN_IRQ_MASK_OFS);
+}
+
+static void mv_eh_thaw(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
+	unsigned int hc = (ap->port_no > 3) ? 1 : 0;
+	void __iomem *hc_mmio = mv_hc_base(mmio, hc);
+	void __iomem *port_mmio = mv_ap_base(ap);
+	u32 tmp, mask, hc_irq_cause;
+	unsigned int shift, hc_port_no = ap->port_no;
+
+	/* FIXME: handle coalescing completion events properly */
+
+	shift = ap->port_no * 2;
+	if (hc > 0) {
+		shift++;
+		hc_port_no -= 4;
+	}
+
+	mask = 0x3 << shift;
+
+	/* clear EDMA errors on this port */
+	writel(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
+
+	/* clear pending irq events */
+	hc_irq_cause = readl(hc_mmio + HC_IRQ_CAUSE_OFS);
+	hc_irq_cause &= ~(1 << hc_port_no);	/* clear CRPB-done */
+	hc_irq_cause &= ~(1 << (hc_port_no + 8)); /* clear Device int */
+	writel(hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
+
+	/* enable assertion of portN err, done events */
+	tmp = readl(mmio + HC_MAIN_IRQ_MASK_OFS);
+	writelfl(tmp | mask, mmio + HC_MAIN_IRQ_MASK_OFS);
 }
 
 /**
@@ -2147,7 +2395,7 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 	switch(board_idx) {
 	case chip_5080:
 		hpriv->ops = &mv5xxx_ops;
-		hp_flags |= MV_HP_50XX;
+		hp_flags |= MV_HP_GEN_I;
 
 		switch (rev_id) {
 		case 0x1:
@@ -2167,7 +2415,7 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 	case chip_504x:
 	case chip_508x:
 		hpriv->ops = &mv5xxx_ops;
-		hp_flags |= MV_HP_50XX;
+		hp_flags |= MV_HP_GEN_I;
 
 		switch (rev_id) {
 		case 0x0:
@@ -2187,6 +2435,7 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 	case chip_604x:
 	case chip_608x:
 		hpriv->ops = &mv6xxx_ops;
+		hp_flags |= MV_HP_GEN_II;
 
 		switch (rev_id) {
 		case 0x7:
@@ -2206,7 +2455,6 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 	case chip_7042:
 	case chip_6042:
 		hpriv->ops = &mv6xxx_ops;
-
 		hp_flags |= MV_HP_GEN_IIE;
 
 		switch (rev_id) {
@@ -2273,7 +2521,7 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 	hpriv->ops->enable_leds(hpriv, mmio);
 
 	for (port = 0; port < host->n_ports; port++) {
-		if (IS_60XX(hpriv)) {
+		if (IS_GEN_II(hpriv)) {
 			void __iomem *port_mmio = mv_port_base(mmio, port);
 
 			u32 ifctl = readl(port_mmio + SATA_INTERFACE_CTL);
@@ -2308,7 +2556,7 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 	/* and unmask interrupt generation for host regs */
 	writelfl(PCI_UNMASK_ALL_IRQS, mmio + PCI_IRQ_MASK_OFS);
 
-	if (IS_50XX(hpriv))
+	if (IS_GEN_I(hpriv))
 		writelfl(~HC_MAIN_MASKED_IRQS_5, mmio + HC_MAIN_IRQ_MASK_OFS);
 	else
 		writelfl(~HC_MAIN_MASKED_IRQS, mmio + HC_MAIN_IRQ_MASK_OFS);
@@ -2426,8 +2674,9 @@ static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	mv_print_info(host);
 
 	pci_set_master(pdev);
+	pci_set_mwi(pdev);
 	return ata_host_activate(host, pdev->irq, mv_interrupt, IRQF_SHARED,
-				 &mv_sht);
+				 IS_GEN_I(hpriv) ? &mv5_sht : &mv6_sht);
 }
 
 static int __init mv_init(void)
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index b265686..db81e3e 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1560,7 +1560,7 @@ static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	ppi[0] = &nv_port_info[type];
-	rc = ata_pci_prepare_native_host(pdev, ppi, &host);
+	rc = ata_pci_prepare_sff_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 2ad5872..d2fcb9a 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -45,7 +45,7 @@
 #include "sata_promise.h"
 
 #define DRV_NAME	"sata_promise"
-#define DRV_VERSION	"2.08"
+#define DRV_VERSION	"2.09"
 
 enum {
 	PDC_MAX_PORTS		= 4,
@@ -716,6 +716,9 @@ static irqreturn_t pdc_interrupt (int irq, void *dev_instance)
 	unsigned int i, tmp;
 	unsigned int handled = 0;
 	void __iomem *mmio_base;
+	unsigned int hotplug_offset, ata_no;
+	u32 hotplug_status;
+	int is_sataii_tx4;
 
 	VPRINTK("ENTER\n");
 
@@ -726,10 +729,20 @@ static irqreturn_t pdc_interrupt (int irq, void *dev_instance)
 
 	mmio_base = host->iomap[PDC_MMIO_BAR];
 
+	/* read and clear hotplug flags for all ports */
+	if (host->ports[0]->flags & PDC_FLAG_GEN_II)
+		hotplug_offset = PDC2_SATA_PLUG_CSR;
+	else
+		hotplug_offset = PDC_SATA_PLUG_CSR;
+	hotplug_status = readl(mmio_base + hotplug_offset);
+	if (hotplug_status & 0xff)
+		writel(hotplug_status | 0xff, mmio_base + hotplug_offset);
+	hotplug_status &= 0xff;	/* clear uninteresting bits */
+
 	/* reading should also clear interrupts */
 	mask = readl(mmio_base + PDC_INT_SEQMASK);
 
-	if (mask == 0xffffffff) {
+	if (mask == 0xffffffff && hotplug_status == 0) {
 		VPRINTK("QUICK EXIT 2\n");
 		return IRQ_NONE;
 	}
@@ -737,16 +750,34 @@ static irqreturn_t pdc_interrupt (int irq, void *dev_instance)
 	spin_lock(&host->lock);
 
 	mask &= 0xffff;		/* only 16 tags possible */
-	if (!mask) {
+	if (mask == 0 && hotplug_status == 0) {
 		VPRINTK("QUICK EXIT 3\n");
 		goto done_irq;
 	}
 
 	writel(mask, mmio_base + PDC_INT_SEQMASK);
 
+	is_sataii_tx4 = pdc_is_sataii_tx4(host->ports[0]->flags);
+
 	for (i = 0; i < host->n_ports; i++) {
 		VPRINTK("port %u\n", i);
 		ap = host->ports[i];
+
+		/* check for a plug or unplug event */
+		ata_no = pdc_port_no_to_ata_no(i, is_sataii_tx4);
+		tmp = hotplug_status & (0x11 << ata_no);
+		if (tmp && ap &&
+		    !(ap->flags & ATA_FLAG_DISABLED)) {
+			struct ata_eh_info *ehi = &ap->eh_info;
+			ata_ehi_clear_desc(ehi);
+			ata_ehi_hotplugged(ehi);
+			ata_ehi_push_desc(ehi, "hotplug_status %#x", tmp);
+			ata_port_freeze(ap);
+			++handled;
+			continue;
+		}
+
+		/* check for a packet interrupt */
 		tmp = mask & (1 << (i + 1));
 		if (tmp && ap &&
 		    !(ap->flags & ATA_FLAG_DISABLED)) {
@@ -902,9 +933,9 @@ static void pdc_host_init(struct ata_host *host)
 	tmp = readl(mmio + hotplug_offset);
 	writel(tmp | 0xff, mmio + hotplug_offset);
 
-	/* mask plug/unplug ints */
+	/* unmask plug/unplug ints */
 	tmp = readl(mmio + hotplug_offset);
-	writel(tmp | 0xff0000, mmio + hotplug_offset);
+	writel(tmp & ~0xff0000, mmio + hotplug_offset);
 
 	/* don't initialise TBG or SLEW on 2nd generation chips */
 	if (is_gen2)
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index fd80bcf..33716b0 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -334,7 +334,7 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		break;
 	}
 
-	rc = ata_pci_prepare_native_host(pdev, ppi, &host);
+	rc = ata_pci_prepare_sff_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index aca7181..b52f83a 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -213,7 +213,7 @@ static int uli_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	host->private_data = hpriv;
 
 	/* the first two ports are standard SFF */
-	rc = ata_pci_init_native_host(host);
+	rc = ata_pci_init_sff_host(host);
 	if (rc)
 		return rc;
 
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index a4c0832..c412447 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -412,7 +412,7 @@ static int vt6420_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
 	struct ata_host *host;
 	int rc;
 
-	rc = ata_pci_prepare_native_host(pdev, ppi, &host);
+	rc = ata_pci_prepare_sff_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 	*r_host = host;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 407dc7e..b5a2016 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -164,6 +164,8 @@ enum {
 	ATA_CMD_SET_MAX		= 0xF9,
 	ATA_CMD_SET_MAX_EXT	= 0x37,
 	ATA_CMD_READ_LOG_EXT	= 0x2f,
+	ATA_CMD_PMP_READ	= 0xE4,
+	ATA_CMD_PMP_WRITE	= 0xE8,
 
 	/* READ_LOG_EXT pages */
 	ATA_LOG_SATA_NCQ	= 0x10,
@@ -212,6 +214,28 @@ enum {
 						   0=to device, 1=to host */
 	ATAPI_CDB_LEN		= 16,
 
+	/* PMP stuff */
+	SATA_PMP_MAX_PORTS	= 15,
+	SATA_PMP_CTRL_PORT	= 15,
+
+	SATA_PMP_GSCR_DWORDS	= 128,
+	SATA_PMP_GSCR_PROD_ID	= 0,
+	SATA_PMP_GSCR_REV	= 1,
+	SATA_PMP_GSCR_PORT_INFO	= 2,
+	SATA_PMP_GSCR_ERROR	= 32,
+	SATA_PMP_GSCR_ERROR_EN	= 33,
+	SATA_PMP_GSCR_FEAT	= 64,
+	SATA_PMP_GSCR_FEAT_EN	= 96,
+
+	SATA_PMP_PSCR_STATUS	= 0,
+	SATA_PMP_PSCR_ERROR	= 1,
+	SATA_PMP_PSCR_CONTROL	= 2,
+
+	SATA_PMP_FEAT_BIST	= (1 << 0),
+	SATA_PMP_FEAT_PMREQ	= (1 << 1),
+	SATA_PMP_FEAT_DYNSSC	= (1 << 2),
+	SATA_PMP_FEAT_NOTIFY	= (1 << 3),
+
 	/* cable types */
 	ATA_CBL_NONE		= 0,
 	ATA_CBL_PATA40		= 1,
@@ -418,4 +442,9 @@ static inline int lba_48_ok(u64 block, u32 n_block)
 	return ((block + n_block - 1) < ((u64)1 << 48)) && (n_block <= 65536);
 }
 
+#define sata_pmp_gscr_vendor(gscr)	((gscr)[SATA_PMP_GSCR_PROD_ID] & 0xffff)
+#define sata_pmp_gscr_devid(gscr)	((gscr)[SATA_PMP_GSCR_PROD_ID] >> 16)
+#define sata_pmp_gscr_rev(gscr)		(((gscr)[SATA_PMP_GSCR_REV] >> 8) & 0xff)
+#define sata_pmp_gscr_ports(gscr)	((gscr)[SATA_PMP_GSCR_PORT_INFO] & 0xf)
+
 #endif /* __LINUX_ATA_H__ */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index a3df646..47cd2a1 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -196,7 +196,6 @@ enum {
 	ATA_PFLAG_SCSI_HOTPLUG	= (1 << 6), /* SCSI hotplug scheduled */
 	ATA_PFLAG_INITIALIZING	= (1 << 7), /* being initialized, don't touch */
 
-	ATA_PFLAG_FLUSH_PORT_TASK = (1 << 16), /* flush port task */
 	ATA_PFLAG_SUSPENDED	= (1 << 17), /* port is suspended (power) */
 	ATA_PFLAG_PM_PENDING	= (1 << 18), /* PM operation pending */
 	ATA_PFLAG_GTM_VALID	= (1 << 19), /* acpi_gtm data valid */
@@ -435,6 +434,7 @@ struct ata_device {
 	struct ata_port		*ap;
 	unsigned int		devno;		/* 0 or 1 */
 	unsigned long		flags;		/* ATA_DFLAG_xxx */
+	unsigned int		horkage;	/* List of broken features */
 	struct scsi_device	*sdev;		/* attached SCSI device */
 #ifdef CONFIG_ATA_ACPI
 	acpi_handle		acpi_handle;
@@ -466,7 +466,6 @@ struct ata_device {
 	/* error history */
 	struct ata_ering	ering;
 	int			spdn_cnt;
-	unsigned int		horkage;	/* List of broken features */
 };
 
 /* Offset into struct ata_device.  Fields above it are maintained
@@ -794,7 +793,6 @@ extern void ata_id_string(const u16 *id, unsigned char *s,
 extern void ata_id_c_string(const u16 *id, unsigned char *s,
 			    unsigned int ofs, unsigned int len);
 extern void ata_id_to_dma_mode(struct ata_device *dev, u8 unknown);
-extern unsigned long ata_device_blacklisted(const struct ata_device *dev);
 extern void ata_bmdma_setup (struct ata_queued_cmd *qc);
 extern void ata_bmdma_start (struct ata_queued_cmd *qc);
 extern void ata_bmdma_stop(struct ata_queued_cmd *qc);
@@ -871,11 +869,11 @@ struct pci_bits {
 	unsigned long		val;
 };
 
-extern int ata_pci_init_native_host(struct ata_host *host);
+extern int ata_pci_init_sff_host(struct ata_host *host);
 extern int ata_pci_init_bmdma(struct ata_host *host);
-extern int ata_pci_prepare_native_host(struct pci_dev *pdev,
-				const struct ata_port_info * const * ppi,
-				struct ata_host **r_host);
+extern int ata_pci_prepare_sff_host(struct pci_dev *pdev,
+				    const struct ata_port_info * const * ppi,
+				    struct ata_host **r_host);
 extern int pci_test_config_bits(struct pci_dev *pdev, const struct pci_bits *bits);
 extern unsigned long ata_pci_default_filter(struct ata_device *, unsigned long);
 #endif /* CONFIG_PCI */
