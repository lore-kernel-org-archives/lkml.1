Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbYAJWna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbYAJWna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYAJWnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:43:19 -0500
Received: from havoc.gtf.org ([69.61.125.42]:54193 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626AbYAJWnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:43:17 -0500
Date: Thu, 10 Jan 2008 17:43:16 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080110224315.GA6125@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Still working through the backlog, but this is most of the immediate
libata stuff.  I asked DaveM to help out with netdev fixes, so there
shouldn't be much of a 2.6.24-rc backlog at all there (thanks again David).

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 Documentation/kernel-parameters.txt |    8 +++++++
 drivers/ata/libata-eh.c             |   24 +++++++++++++++-------
 drivers/ata/libata-pmp.c            |   12 ++++------
 drivers/ata/libata-scsi.c           |    3 +-
 drivers/ata/libata-sff.c            |    7 ++++-
 drivers/ata/pata_ixp4xx_cf.c        |    3 +-
 drivers/ata/pata_pdc202xx_old.c     |   15 ++++++++++++-
 drivers/ata/sata_qstor.c            |    2 +-
 drivers/ata/sata_sil24.c            |   37 ++++++++++++++++++++++++----------
 9 files changed, 78 insertions(+), 33 deletions(-)

Alan Cox (2):
      libata-sff: PCI IRQ handling fix
      pata_pdc202xx_old: Further fixups

FD Cami (1):
      Update kernel parameter document for libata DMA mode setting knobs.

Gwendal Grignou (1):
      sata_sil24: prevent hba lockup when pass-through ATA commands are used

Ondrej Zary (1):
      libata and starting/stopping ATAPI floppy devices

Rod Whitby (1):
      pata_ixp4xx_cf: fix compilation introduced by ata_port_desc() conversion

Tejun Heo (4):
      sata_qstor: use hardreset instead of softreset
      libata-pmp: 4726 hates SRST
      libata-pmp: propagate timeout to host link
      libata: don't normalize UNKNOWN to NONE after reset

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e5b447a..c417877 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -883,6 +883,14 @@ and is between 256 and 4096 characters. It is defined in the file
 	lapic_timer_c2_ok	[X86-32,x86-64,APIC] trust the local apic timer in
 			C2 power state.
 
+	libata.dma=	[LIBATA] DMA control
+			libata.dma=0	  Disable all PATA and SATA DMA
+			libata.dma=1	  PATA and SATA Disk DMA only
+			libata.dma=2	  ATAPI (CDROM) DMA only
+			libata.dma=4	  Compact Flash DMA only 
+			Combinations also work, so libata.dma=3 enables DMA
+			for disks and CDROMs, but not CFs.
+
 	libata.noacpi	[LIBATA] Disables use of ACPI in libata suspend/resume
 			when set.
 			Format: <int>
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index f0124a8..21a81cd 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1733,11 +1733,15 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 		ehc->i.action &= ~ATA_EH_PERDEV_MASK;
 	}
 
-	/* consider speeding down */
+	/* propagate timeout to host link */
+	if ((all_err_mask & AC_ERR_TIMEOUT) && !ata_is_host_link(link))
+		ap->link.eh_context.i.err_mask |= AC_ERR_TIMEOUT;
+
+	/* record error and consider speeding down */
 	dev = ehc->i.dev;
-	if (!dev && ata_link_max_devices(link) == 1 &&
-	    ata_dev_enabled(link->device))
-		dev = link->device;
+	if (!dev && ((ata_link_max_devices(link) == 1 &&
+		      ata_dev_enabled(link->device))))
+	    dev = link->device;
 
 	if (dev)
 		ehc->i.action |= ata_eh_speed_down(dev, is_io, all_err_mask);
@@ -1759,8 +1763,14 @@ void ata_eh_autopsy(struct ata_port *ap)
 {
 	struct ata_link *link;
 
-	__ata_port_for_each_link(link, ap)
+	ata_port_for_each_link(link, ap)
 		ata_eh_link_autopsy(link);
+
+	/* Autopsy of fanout ports can affect host link autopsy.
+	 * Perform host link autopsy last.
+	 */
+	if (ap->nr_pmp_links)
+		ata_eh_link_autopsy(&ap->link);
 }
 
 /**
@@ -2157,13 +2167,11 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		if (ata_link_offline(link))
 			continue;
 
-		/* apply class override and convert UNKNOWN to NONE */
+		/* apply class override */
 		if (lflags & ATA_LFLAG_ASSUME_ATA)
 			classes[dev->devno] = ATA_DEV_ATA;
 		else if (lflags & ATA_LFLAG_ASSUME_SEMB)
 			classes[dev->devno] = ATA_DEV_SEMB_UNSUP; /* not yet */
-		else if (classes[dev->devno] == ATA_DEV_UNKNOWN)
-			classes[dev->devno] = ATA_DEV_NONE;
 	}
 
 	/* record current link speed */
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index c0c4dbc..caef2bb 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -495,14 +495,12 @@ static void sata_pmp_quirks(struct ata_port *ap)
 			/* SError.N need a kick in the ass to get working */
 			link->flags |= ATA_LFLAG_HRST_TO_RESUME;
 
-			/* class code report is unreliable */
-			if (link->pmp < 5)
-				link->flags |= ATA_LFLAG_ASSUME_ATA;
-
-			/* The config device, which can be either at
-			 * port 0 or 5, locks up on SRST.
+			/* Class code report is unreliable and SRST
+			 * times out under certain configurations.
+			 * Config device can be at port 0 or 5 and
+			 * locks up on SRST.
 			 */
-			if (link->pmp == 0 || link->pmp == 5)
+			if (link->pmp <= 5)
 				link->flags |= ATA_LFLAG_NO_SRST |
 					       ATA_LFLAG_ASSUME_ATA;
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a883bb0..264ae60 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -872,7 +872,8 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 
 	ata_scsi_sdev_config(sdev);
 
-	sdev->manage_start_stop = 1;
+	if (dev->class == ATA_DEV_ATA)
+		sdev->manage_start_stop = 1;
 
 	if (dev)
 		ata_scsi_dev_config(sdev, dev);
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 48acc09..b7ac80b 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -806,7 +806,10 @@ int ata_pci_init_one(struct pci_dev *pdev,
 	if (rc)
 		goto err_out;
 
-	if (!legacy_mode) {
+	if (!legacy_mode && pdev->irq) {
+		/* We may have no IRQ assigned in which case we can poll. This
+		   shouldn't happen on a sane system but robustness is cheap
+		   in this case */
 		rc = devm_request_irq(dev, pdev->irq, pi->port_ops->irq_handler,
 				      IRQF_SHARED, DRV_NAME, host);
 		if (rc)
@@ -814,7 +817,7 @@ int ata_pci_init_one(struct pci_dev *pdev,
 
 		ata_port_desc(host->ports[0], "irq %d", pdev->irq);
 		ata_port_desc(host->ports[1], "irq %d", pdev->irq);
-	} else {
+	} else if (legacy_mode) {
 		if (!ata_port_is_dummy(host->ports[0])) {
 			rc = devm_request_irq(dev, ATA_PRIMARY_IRQ(pdev),
 					      pi->port_ops->irq_handler,
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index fcd532a..120b5bf 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -130,10 +130,11 @@ static struct ata_port_operations ixp4xx_port_ops = {
 	.port_start		= ata_port_start,
 };
 
-static void ixp4xx_setup_port(struct ata_ioports *ioaddr,
+static void ixp4xx_setup_port(struct ata_port *ap,
 			      struct ixp4xx_pata_data *data,
 			      unsigned long raw_cs0, unsigned long raw_cs1)
 {
+	struct ata_ioports *ioaddr = &ap->ioaddr;
 	unsigned long raw_cmd = raw_cs0;
 	unsigned long raw_ctl = raw_cs1 + 0x06;
 
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index bc7c2d5..8f28156 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -215,8 +215,8 @@ static void pdc2026x_bmdma_stop(struct ata_queued_cmd *qc)
 	/* Flip back to 33Mhz for PIO */
 	if (adev->dma_mode >= XFER_UDMA_2)
 		iowrite8(ioread8(clock) & ~sel66, clock);
-
 	ata_bmdma_stop(qc);
+	pdc202xx_set_piomode(ap, adev);
 }
 
 /**
@@ -233,6 +233,17 @@ static void pdc2026x_dev_config(struct ata_device *adev)
 	adev->max_sectors = 256;
 }
 
+static int pdc2026x_port_start(struct ata_port *ap)
+{
+	void __iomem *bmdma = ap->ioaddr.bmdma_addr;
+	if (bmdma) {
+		/* Enable burst mode */
+		u8 burst = ioread8(bmdma + 0x1f);
+		iowrite8(burst | 0x01, bmdma + 0x1f);
+	}
+	return ata_sff_port_start(ap);
+}
+
 static struct scsi_host_template pdc202xx_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -313,7 +324,7 @@ static struct ata_port_operations pdc2026x_port_ops = {
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_sff_port_start,
+	.port_start	= pdc2026x_port_start,
 };
 
 static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 2f1de6e..c68b241 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -270,7 +270,7 @@ static int qs_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 static void qs_error_handler(struct ata_port *ap)
 {
 	qs_enter_reg_mode(ap);
-	ata_do_eh(ap, qs_prereset, ata_std_softreset, NULL,
+	ata_do_eh(ap, qs_prereset, NULL, sata_std_hardreset,
 		  ata_std_postreset);
 }
 
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 96fd526..b4c674d 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -832,16 +832,31 @@ static int sil24_qc_defer(struct ata_queued_cmd *qc)
 	struct ata_link *link = qc->dev->link;
 	struct ata_port *ap = link->ap;
 	u8 prot = qc->tf.protocol;
-	int is_atapi = (prot == ATA_PROT_ATAPI ||
-			prot == ATA_PROT_ATAPI_NODATA ||
-			prot == ATA_PROT_ATAPI_DMA);
-
-	/* ATAPI commands completing with CHECK_SENSE cause various
-	 * weird problems if other commands are active.  PMP DMA CS
-	 * errata doesn't cover all and HSM violation occurs even with
-	 * only one other device active.  Always run an ATAPI command
-	 * by itself.
-	 */
+
+	/*
+	 * There is a bug in the chip:
+	 * Port LRAM Causes the PRB/SGT Data to be Corrupted
+	 * If the host issues a read request for LRAM and SActive registers
+	 * while active commands are available in the port, PRB/SGT data in
+	 * the LRAM can become corrupted. This issue applies only when
+	 * reading from, but not writing to, the LRAM.
+	 *
+	 * Therefore, reading LRAM when there is no particular error [and
+	 * other commands may be outstanding] is prohibited.
+	 *
+	 * To avoid this bug there are two situations where a command must run
+	 * exclusive of any other commands on the port:
+	 *
+	 * - ATAPI commands which check the sense data
+	 * - Passthrough ATA commands which always have ATA_QCFLAG_RESULT_TF
+	 *   set.
+	 *
+ 	 */
+	int is_excl = (prot == ATA_PROT_ATAPI ||
+		       prot == ATA_PROT_ATAPI_NODATA ||
+		       prot == ATA_PROT_ATAPI_DMA ||
+		       (qc->flags & ATA_QCFLAG_RESULT_TF));
+
 	if (unlikely(ap->excl_link)) {
 		if (link == ap->excl_link) {
 			if (ap->nr_active_links)
@@ -849,7 +864,7 @@ static int sil24_qc_defer(struct ata_queued_cmd *qc)
 			qc->flags |= ATA_QCFLAG_CLEAR_EXCL;
 		} else
 			return ATA_DEFER_PORT;
-	} else if (unlikely(is_atapi)) {
+	} else if (unlikely(is_excl)) {
 		ap->excl_link = link;
 		if (ap->nr_active_links)
 			return ATA_DEFER_PORT;
