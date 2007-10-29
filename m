Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbXJ2Sxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbXJ2Sxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbXJ2Sxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:53:43 -0400
Received: from havoc.gtf.org ([69.61.125.42]:52240 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757238AbXJ2Sxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:53:38 -0400
Date: Mon, 29 Oct 2007 14:53:37 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches 1/2] libata fixes
Message-ID: <20071029185337.GA5241@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


"real" fixes, and checkpatch fixes.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c              |   17 ++---
 drivers/ata/libata-core.c       |  146 +++++++++++++++++++++++---------
 drivers/ata/libata-eh.c         |   25 +++++-
 drivers/ata/libata-scsi.c       |   23 -----
 drivers/ata/pata_acpi.c         |    4 +-
 drivers/ata/pata_ns87415.c      |    2 +
 drivers/ata/pata_optidma.c      |    2 +-
 drivers/ata/pata_pcmcia.c       |   12 ++--
 drivers/ata/pata_pdc2027x.c     |    2 +-
 drivers/ata/pata_pdc202xx_old.c |    4 +-
 drivers/ata/pata_scc.c          |   13 +---
 drivers/ata/pata_via.c          |    2 +-
 drivers/ata/pata_winbond.c      |    2 +-
 drivers/ata/pdc_adma.c          |   12 ++--
 drivers/ata/sata_inic162x.c     |    4 +-
 drivers/ata/sata_mv.c           |    7 +-
 drivers/ata/sata_nv.c           |  120 ++++++++++++++------------
 drivers/ata/sata_promise.c      |   38 +++++----
 drivers/ata/sata_qstor.c        |    3 +-
 drivers/ata/sata_sil.c          |   11 ++-
 drivers/ata/sata_sil24.c        |    9 +-
 drivers/ata/sata_sis.c          |   64 ++++++++-------
 drivers/ata/sata_svw.c          |   10 +-
 drivers/ata/sata_sx4.c          |  177 ++++++++++++++++++++-------------------
 drivers/ata/sata_uli.c          |   18 ++--
 drivers/ata/sata_via.c          |   20 ++--
 drivers/ata/sata_vsc.c          |   15 ++--
 include/linux/ata.h             |    1 +
 include/linux/libata.h          |    9 ++
 29 files changed, 432 insertions(+), 340 deletions(-)

Frank Lichtenheld (1):
      pata_ns87415: define SUPERIO_IDE_MAX_RETRIES

Jeff Garzik (4):
      [libata] fix 'if(' and similar areas that lack whitespace
      [libata] Address some checkpatch-spotted issues
      [libata] sata_nv: fix SWNCQ enabling
      [libata] AHCI: fix newly introduced host-reset bug

Tejun Heo (6):
      libata: relocate and fix post-command processing
      libata: track SLEEP state and issue SRST to wake it up
      libata: implement ata_wait_after_reset()
      libata: relocate forcing PIO0 on reset
      libata: no need to speed down if already at PIO0
      libata: add MAXTOR 7V300F0/VA111900 to NCQ blacklist

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 49cf4cf..c8ab947 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -898,8 +898,10 @@ static int ahci_reset_controller(struct ata_host *host)
 	 * AHCI-specific, such as HOST_RESET.
 	 */
 	tmp = readl(mmio + HOST_CTL);
-	if (!(tmp & HOST_AHCI_EN))
-		writel(tmp | HOST_AHCI_EN, mmio + HOST_CTL);
+	if (!(tmp & HOST_AHCI_EN)) {
+		tmp |= HOST_AHCI_EN;
+		writel(tmp, mmio + HOST_CTL);
+	}
 
 	/* global controller reset */
 	if ((tmp & HOST_RESET) == 0) {
@@ -1153,15 +1155,8 @@ static int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 	tf.ctl &= ~ATA_SRST;
 	ahci_exec_polled_cmd(ap, pmp, &tf, 0, 0, 0);
 
-	/* spec mandates ">= 2ms" before checking status.
-	 * We wait 150ms, because that was the magic delay used for
-	 * ATAPI devices in Hale Landis's ATADRVR, for the period of time
-	 * between when the ATA command register is written, and then
-	 * status is checked.  Because waiting for "a while" before
-	 * checking status is fine, post SRST, we perform this magic
-	 * delay here as well.
-	 */
-	msleep(150);
+	/* wait a while before checking status */
+	ata_wait_after_reset(ap, deadline);
 
 	rc = ata_wait_ready(ap, deadline);
 	/* link occupied, -ENODEV too is an error */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 081e3df..3891cdc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2219,6 +2219,25 @@ int ata_bus_probe(struct ata_port *ap)
 		tries[dev->devno] = ATA_PROBE_MAX_TRIES;
 
  retry:
+	ata_link_for_each_dev(dev, &ap->link) {
+		/* If we issue an SRST then an ATA drive (not ATAPI)
+		 * may change configuration and be in PIO0 timing. If
+		 * we do a hard reset (or are coming from power on)
+		 * this is true for ATA or ATAPI. Until we've set a
+		 * suitable controller mode we should not touch the
+		 * bus as we may be talking too fast.
+		 */
+		dev->pio_mode = XFER_PIO_0;
+
+		/* If the controller has a pio mode setup function
+		 * then use it to set the chipset to rights. Don't
+		 * touch the DMA setup as that will be dealt with when
+		 * configuring devices.
+		 */
+		if (ap->ops->set_piomode)
+			ap->ops->set_piomode(ap, dev);
+	}
+
 	/* reset and determine device classes */
 	ap->ops->phy_reset(ap);
 
@@ -2234,12 +2253,6 @@ int ata_bus_probe(struct ata_port *ap)
 
 	ata_port_probe(ap);
 
-	/* after the reset the device state is PIO 0 and the controller
-	   state is undefined. Record the mode */
-
-	ata_link_for_each_dev(dev, &ap->link)
-		dev->pio_mode = XFER_PIO_0;
-
 	/* read IDENTIFY page and configure devices. We have to do the identify
 	   specific sequence bass-ackwards so that PDIAG- is released by
 	   the slave device */
@@ -3118,6 +3131,55 @@ int ata_busy_sleep(struct ata_port *ap,
 }
 
 /**
+ *	ata_wait_after_reset - wait before checking status after reset
+ *	@ap: port containing status register to be polled
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	After reset, we need to pause a while before reading status.
+ *	Also, certain combination of controller and device report 0xff
+ *	for some duration (e.g. until SATA PHY is up and running)
+ *	which is interpreted as empty port in ATA world.  This
+ *	function also waits for such devices to get out of 0xff
+ *	status.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ */
+void ata_wait_after_reset(struct ata_port *ap, unsigned long deadline)
+{
+	unsigned long until = jiffies + ATA_TMOUT_FF_WAIT;
+
+	if (time_before(until, deadline))
+		deadline = until;
+
+	/* Spec mandates ">= 2ms" before checking status.  We wait
+	 * 150ms, because that was the magic delay used for ATAPI
+	 * devices in Hale Landis's ATADRVR, for the period of time
+	 * between when the ATA command register is written, and then
+	 * status is checked.  Because waiting for "a while" before
+	 * checking status is fine, post SRST, we perform this magic
+	 * delay here as well.
+	 *
+	 * Old drivers/ide uses the 2mS rule and then waits for ready.
+	 */
+	msleep(150);
+
+	/* Wait for 0xff to clear.  Some SATA devices take a long time
+	 * to clear 0xff after reset.  For example, HHD424020F7SV00
+	 * iVDR needs >= 800ms while.  Quantum GoVault needs even more
+	 * than that.
+	 */
+	while (1) {
+		u8 status = ata_chk_status(ap);
+
+		if (status != 0xff || time_after(jiffies, deadline))
+			return;
+
+		msleep(50);
+	}
+}
+
+/**
  *	ata_wait_ready - sleep until BSY clears, or timeout
  *	@ap: port containing status register to be polled
  *	@deadline: deadline jiffies for the operation
@@ -3223,8 +3285,6 @@ static int ata_bus_softreset(struct ata_port *ap, unsigned int devmask,
 			     unsigned long deadline)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
-	struct ata_device *dev;
-	int i = 0;
 
 	DPRINTK("ata%u: bus reset via SRST\n", ap->print_id);
 
@@ -3235,36 +3295,8 @@ static int ata_bus_softreset(struct ata_port *ap, unsigned int devmask,
 	udelay(20);	/* FIXME: flush */
 	iowrite8(ap->ctl, ioaddr->ctl_addr);
 
-	/* If we issued an SRST then an ATA drive (not ATAPI)
-	 * may have changed configuration and be in PIO0 timing. If
-	 * we did a hard reset (or are coming from power on) this is
-	 * true for ATA or ATAPI. Until we've set a suitable controller
-	 * mode we should not touch the bus as we may be talking too fast.
-	 */
-
-	ata_link_for_each_dev(dev, &ap->link)
-		dev->pio_mode = XFER_PIO_0;
-
-	/* If the controller has a pio mode setup function then use
-	   it to set the chipset to rights. Don't touch the DMA setup
-	   as that will be dealt with when revalidating */
-	if (ap->ops->set_piomode) {
-		ata_link_for_each_dev(dev, &ap->link)
-			if (devmask & (1 << i++))
-				ap->ops->set_piomode(ap, dev);
-	}
-
-	/* spec mandates ">= 2ms" before checking status.
-	 * We wait 150ms, because that was the magic delay used for
-	 * ATAPI devices in Hale Landis's ATADRVR, for the period of time
-	 * between when the ATA command register is written, and then
-	 * status is checked.  Because waiting for "a while" before
-	 * checking status is fine, post SRST, we perform this magic
-	 * delay here as well.
-	 *
-	 * Old drivers/ide uses the 2mS rule and then waits for ready
-	 */
-	msleep(150);
+	/* wait a while before checking status */
+	ata_wait_after_reset(ap, deadline);
 
 	/* Before we perform post reset processing we want to see if
 	 * the bus shows 0xFF because the odd clown forgets the D7
@@ -3691,8 +3723,8 @@ int sata_std_hardreset(struct ata_link *link, unsigned int *class,
 		return 0;
 	}
 
-	/* wait a while before checking status, see SRST for more info */
-	msleep(150);
+	/* wait a while before checking status */
+	ata_wait_after_reset(ap, deadline);
 
 	/* If PMP is supported, we have to do follow-up SRST.  Note
 	 * that some PMPs don't send D2H Reg FIS after hardreset at
@@ -3992,6 +4024,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "ST3160812AS",	"3.ADJ",	ATA_HORKAGE_NONCQ, },
 	{ "ST980813AS",		"3.ADB",	ATA_HORKAGE_NONCQ, },
 	{ "SAMSUNG HD401LJ",	"ZZ100-15",	ATA_HORKAGE_NONCQ, },
+	{ "Maxtor 7V300F0",	"VA111900",	ATA_HORKAGE_NONCQ, },
 
 	/* devices which puke on READ_NATIVE_MAX */
 	{ "HDS724040KLSA80",	"KFAOA20N",	ATA_HORKAGE_BROKEN_HPA, },
@@ -5594,6 +5627,9 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 	 * taken care of.
 	 */
 	if (ap->ops->error_handler) {
+		struct ata_device *dev = qc->dev;
+		struct ata_eh_info *ehi = &dev->link->eh_info;
+
 		WARN_ON(ap->pflags & ATA_PFLAG_FROZEN);
 
 		if (unlikely(qc->err_mask))
@@ -5612,6 +5648,27 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 		if (qc->flags & ATA_QCFLAG_RESULT_TF)
 			fill_result_tf(qc);
 
+		/* Some commands need post-processing after successful
+		 * completion.
+		 */
+		switch (qc->tf.command) {
+		case ATA_CMD_SET_FEATURES:
+			if (qc->tf.feature != SETFEATURES_WC_ON &&
+			    qc->tf.feature != SETFEATURES_WC_OFF)
+				break;
+			/* fall through */
+		case ATA_CMD_INIT_DEV_PARAMS: /* CHS translation changed */
+		case ATA_CMD_SET_MULTI: /* multi_count changed */
+			/* revalidate device */
+			ehi->dev_action[dev->devno] |= ATA_EH_REVALIDATE;
+			ata_port_schedule_eh(ap);
+			break;
+
+		case ATA_CMD_SLEEP:
+			dev->flags |= ATA_DFLAG_SLEEPING;
+			break;
+		}
+
 		__ata_qc_complete(qc);
 	} else {
 		if (qc->flags & ATA_QCFLAG_EH_SCHEDULED)
@@ -5749,6 +5806,14 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 		qc->flags &= ~ATA_QCFLAG_DMAMAP;
 	}
 
+	/* if device is sleeping, schedule softreset and abort the link */
+	if (unlikely(qc->dev->flags & ATA_DFLAG_SLEEPING)) {
+		link->eh_info.action |= ATA_EH_SOFTRESET;
+		ata_ehi_push_desc(&link->eh_info, "waking up from sleep");
+		ata_link_abort(link);
+		return;
+	}
+
 	ap->ops->qc_prep(qc);
 
 	qc->err_mask |= ap->ops->qc_issue(qc);
@@ -7326,6 +7391,7 @@ EXPORT_SYMBOL_GPL(ata_port_disable);
 EXPORT_SYMBOL_GPL(ata_ratelimit);
 EXPORT_SYMBOL_GPL(ata_wait_register);
 EXPORT_SYMBOL_GPL(ata_busy_sleep);
+EXPORT_SYMBOL_GPL(ata_wait_after_reset);
 EXPORT_SYMBOL_GPL(ata_wait_ready);
 EXPORT_SYMBOL_GPL(ata_port_queue_task);
 EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 8cb35bb..ec55d63 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2083,6 +2083,25 @@ int ata_eh_reset(struct ata_link *link, int classify,
 
 	ata_eh_about_to_do(link, NULL, ehc->i.action & ATA_EH_RESET_MASK);
 
+	ata_link_for_each_dev(dev, link) {
+		/* If we issue an SRST then an ATA drive (not ATAPI)
+		 * may change configuration and be in PIO0 timing. If
+		 * we do a hard reset (or are coming from power on)
+		 * this is true for ATA or ATAPI. Until we've set a
+		 * suitable controller mode we should not touch the
+		 * bus as we may be talking too fast.
+		 */
+		dev->pio_mode = XFER_PIO_0;
+
+		/* If the controller has a pio mode setup function
+		 * then use it to set the chipset to rights. Don't
+		 * touch the DMA setup as that will be dealt with when
+		 * configuring devices.
+		 */
+		if (ap->ops->set_piomode)
+			ap->ops->set_piomode(ap, dev);
+	}
+
 	/* Determine which reset to use and record in ehc->i.action.
 	 * prereset() may examine and modify it.
 	 */
@@ -2208,9 +2227,11 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		ata_link_for_each_dev(dev, link) {
 			/* After the reset, the device state is PIO 0
 			 * and the controller state is undefined.
-			 * Record the mode.
+			 * Reset also wakes up drives from sleeping
+			 * mode.
 			 */
 			dev->pio_mode = XFER_PIO_0;
+			dev->flags &= ~ATA_DFLAG_SLEEPING;
 
 			if (ata_link_offline(link))
 				continue;
@@ -2416,7 +2437,7 @@ static int ata_eh_handle_dev_fail(struct ata_device *dev, int err)
 		/* give it just one more chance */
 		ehc->tries[dev->devno] = min(ehc->tries[dev->devno], 1);
 	case -EIO:
-		if (ehc->tries[dev->devno] == 1) {
+		if (ehc->tries[dev->devno] == 1 && dev->pio_mode > XFER_PIO_0) {
 			/* This is the last chance, better to slow
 			 * down than lose it.
 			 */
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f5d5420..f752edd 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1361,33 +1361,10 @@ nothing_to_do:
 static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	struct ata_eh_info *ehi = &qc->dev->link->eh_info;
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	u8 *cdb = cmd->cmnd;
 	int need_sense = (qc->err_mask != 0);
 
-	/* We snoop the SET_FEATURES - Write Cache ON/OFF command, and
-	 * schedule EH_REVALIDATE operation to update the IDENTIFY DEVICE
-	 * cache
-	 */
-	if (ap->ops->error_handler && !need_sense) {
-		switch (qc->tf.command) {
-		case ATA_CMD_SET_FEATURES:
-			if ((qc->tf.feature == SETFEATURES_WC_ON) ||
-			    (qc->tf.feature == SETFEATURES_WC_OFF)) {
-				ehi->action |= ATA_EH_REVALIDATE;
-				ata_port_schedule_eh(ap);
-			}
-			break;
-
-		case ATA_CMD_INIT_DEV_PARAMS: /* CHS translation changed */
-		case ATA_CMD_SET_MULTI: /* multi_count changed */
-			ehi->action |= ATA_EH_REVALIDATE;
-			ata_port_schedule_eh(ap);
-			break;
-		}
-	}
-
 	/* For ATA pass thru (SAT) commands, generate a sense block if
 	 * user mandated it or if there's an error.  Note that if we
 	 * generate because the user forced us to, a check condition
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index 0f6f7bc..e4542ab 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -181,7 +181,7 @@ static void pacpi_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	int unit = adev->devno;
 	struct pata_acpi *acpi = ap->private_data;
 
-	if(!(acpi->gtm.flags & 0x10))
+	if (!(acpi->gtm.flags & 0x10))
 		unit = 0;
 
 	/* Now stuff the nS values into the structure */
@@ -202,7 +202,7 @@ static void pacpi_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	int unit = adev->devno;
 	struct pata_acpi *acpi = ap->private_data;
 
-	if(!(acpi->gtm.flags & 0x10))
+	if (!(acpi->gtm.flags & 0x10))
 		unit = 0;
 
 	/* Now stuff the nS values into the structure */
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index b9a17eb..d0e2e50 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -215,6 +215,8 @@ static int ns87415_check_atapi_dma(struct ata_queued_cmd *qc)
 
 #include <asm/superio.h>
 
+#define SUPERIO_IDE_MAX_RETRIES 25
+
 /**
  *	ns87560_read_buggy	-	workaround buggy Super I/O chip
  *	@port: Port to read
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index 6b07b5b..f9b485a 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -449,7 +449,7 @@ static int optiplus_with_udma(struct pci_dev *pdev)
 
 	/* Find function 1 */
 	dev1 = pci_get_device(0x1045, 0xC701, NULL);
-	if(dev1 == NULL)
+	if (dev1 == NULL)
 		return 0;
 
 	/* Rev must be >= 0x10 */
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 5db2013..fd36099 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -74,8 +74,7 @@ static int pcmcia_set_mode(struct ata_link *link, struct ata_device **r_failed_d
 		return ata_do_set_mode(link, r_failed_dev);
 
 	if (memcmp(master->id + ATA_ID_FW_REV,  slave->id + ATA_ID_FW_REV,
-			   ATA_ID_FW_REV_LEN + ATA_ID_PROD_LEN) == 0)
-	{
+			   ATA_ID_FW_REV_LEN + ATA_ID_PROD_LEN) == 0) {
 		/* Suspicious match, but could be two cards from
 		   the same vendor - check serial */
 		if (memcmp(master->id + ATA_ID_SERNO, slave->id + ATA_ID_SERNO,
@@ -248,7 +247,8 @@ static int pcmcia_init_one(struct pcmcia_device *pdev)
 					goto next_entry;
 				io_base = pdev->io.BasePort1;
 				ctl_base = pdev->io.BasePort1 + 0x0e;
-			} else goto next_entry;
+			} else
+				goto next_entry;
 			/* If we've got this far, we're done */
 			break;
 		}
@@ -285,8 +285,8 @@ next_entry:
 		printk(KERN_WARNING DRV_NAME ": second channel not yet supported.\n");
 
 	/*
- 	 *	Having done the PCMCIA plumbing the ATA side is relatively
- 	 *	sane.
+	 *	Having done the PCMCIA plumbing the ATA side is relatively
+	 *	sane.
 	 */
 	ret = -ENOMEM;
 	host = ata_host_alloc(&pdev->dev, 1);
@@ -363,7 +363,7 @@ static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0098, 0x0000),	/* Toshiba */
 	PCMCIA_DEVICE_MANF_CARD(0x00a4, 0x002d),
 	PCMCIA_DEVICE_MANF_CARD(0x00ce, 0x0000),	/* Samsung */
- 	PCMCIA_DEVICE_MANF_CARD(0x0319, 0x0000),	/* Hitachi */
+	PCMCIA_DEVICE_MANF_CARD(0x0319, 0x0000),	/* Hitachi */
 	PCMCIA_DEVICE_MANF_CARD(0x2080, 0x0001),
 	PCMCIA_DEVICE_MANF_CARD(0x4e01, 0x0100),	/* Viking CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x4e01, 0x0200),	/* Lexar, Viking CFA */
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 3d3f155..2622577 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -348,7 +348,7 @@ static unsigned long pdc2027x_mode_filter(struct ata_device *adev, unsigned long
 	ata_id_c_string(pair->id, model_num, ATA_ID_PROD,
 			  ATA_ID_PROD_LEN + 1);
 	/* If the master is a maxtor in UDMA6 then the slave should not use UDMA 6 */
-	if(strstr(model_num, "Maxtor") == 0 && pair->dma_mode == XFER_UDMA_6)
+	if (strstr(model_num, "Maxtor") == 0 && pair->dma_mode == XFER_UDMA_6)
 		mask &= ~ (1 << (6 + ATA_SHIFT_UDMA));
 
 	return ata_pci_default_filter(adev, mask);
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index 65d9516..bc7c2d5 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -351,9 +351,9 @@ static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id
 		struct pci_dev *bridge = dev->bus->self;
 		/* Don't grab anything behind a Promise I2O RAID */
 		if (bridge && bridge->vendor == PCI_VENDOR_ID_INTEL) {
-			if( bridge->device == PCI_DEVICE_ID_INTEL_I960)
+			if (bridge->device == PCI_DEVICE_ID_INTEL_I960)
 				return -ENODEV;
-			if( bridge->device == PCI_DEVICE_ID_INTEL_I960RM)
+			if (bridge->device == PCI_DEVICE_ID_INTEL_I960RM)
 				return -ENODEV;
 		}
 	}
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 5557613..ea2ef9f 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -570,17 +570,8 @@ static unsigned int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
 	udelay(20);
 	out_be32(ioaddr->ctl_addr, ap->ctl);
 
-	/* spec mandates ">= 2ms" before checking status.
-	 * We wait 150ms, because that was the magic delay used for
-	 * ATAPI devices in Hale Landis's ATADRVR, for the period of time
-	 * between when the ATA command register is written, and then
-	 * status is checked.  Because waiting for "a while" before
-	 * checking status is fine, post SRST, we perform this magic
-	 * delay here as well.
-	 *
-	 * Old drivers/ide uses the 2mS rule and then waits for ready
-	 */
-	msleep(150);
+	/* wait a while before checking status */
+	ata_wait_after_reset(ap, deadline);
 
 	/* Before we perform post reset processing we want to see if
 	 * the bus shows 0xFF because the odd clown forgets the D7
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index ea7a9a6..a4175fb 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -176,7 +176,7 @@ static int via_cable_detect(struct ata_port *ap) {
 	if ((config->flags & VIA_UDMA) < VIA_UDMA_66)
 		return ATA_CBL_PATA40;
 	/* UDMA 66 chips have only drive side logic */
-	else if((config->flags & VIA_UDMA) < VIA_UDMA_100)
+	else if ((config->flags & VIA_UDMA) < VIA_UDMA_100)
 		return ATA_CBL_PATA_UNK;
 	/* UDMA 100 or later */
 	pci_read_config_dword(pdev, 0x50, &ata66);
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index 549cbbe..311cdb3 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -279,7 +279,7 @@ static __init int winbond_init(void)
 
 			if (request_region(port, 2, "pata_winbond")) {
 				ret = winbond_init_one(port);
-				if(ret <= 0)
+				if (ret <= 0)
 					release_region(port, 2);
 				else ct+= ret;
 			}
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 199f7e1..bd4c2a3 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -47,10 +47,10 @@
 #define DRV_VERSION	"1.0"
 
 /* macro to calculate base address for ATA regs */
-#define ADMA_ATA_REGS(base,port_no)	((base) + ((port_no) * 0x40))
+#define ADMA_ATA_REGS(base, port_no)	((base) + ((port_no) * 0x40))
 
 /* macro to calculate base address for ADMA regs */
-#define ADMA_REGS(base,port_no)		((base) + 0x80 + ((port_no) * 0x20))
+#define ADMA_REGS(base, port_no)	((base) + 0x80 + ((port_no) * 0x20))
 
 /* macro to obtain addresses from ata_port */
 #define ADMA_PORT_REGS(ap) \
@@ -128,7 +128,7 @@ struct adma_port_priv {
 	adma_state_t		state;
 };
 
-static int adma_ata_init_one (struct pci_dev *pdev,
+static int adma_ata_init_one(struct pci_dev *pdev,
 				const struct pci_device_id *ent);
 static int adma_port_start(struct ata_port *ap);
 static void adma_host_stop(struct ata_host *host);
@@ -340,8 +340,8 @@ static int adma_fill_sg(struct ata_queued_cmd *qc)
 		buf[i++] = 0;	/* pPKLW */
 		buf[i++] = 0;	/* reserved */
 
-		*(__le32 *)(buf + i)
-			= (pFLAGS & pEND) ? 0 : cpu_to_le32(pp->pkt_dma + i + 4);
+		*(__le32 *)(buf + i) =
+			(pFLAGS & pEND) ? 0 : cpu_to_le32(pp->pkt_dma + i + 4);
 		i += 4;
 
 		VPRINTK("PRD[%u] = (0x%lX, 0x%X)\n", i/4,
@@ -617,7 +617,7 @@ static int adma_port_start(struct ata_port *ap)
 		return -ENOMEM;
 	/* paranoia? */
 	if ((pp->pkt_dma & 7) != 0) {
-		printk("bad alignment for pp->pkt_dma: %08x\n",
+		printk(KERN_ERR "bad alignment for pp->pkt_dma: %08x\n",
 						(u32)pp->pkt_dma);
 		return -ENOMEM;
 	}
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 08595f3..323c087 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -143,7 +143,7 @@ static const int scr_map[] = {
 	[SCR_CONTROL]	= 2,
 };
 
-static void __iomem * inic_port_base(struct ata_port *ap)
+static void __iomem *inic_port_base(struct ata_port *ap)
 {
 	return ap->host->iomap[MMIO_BAR] + ap->port_no * PORT_SIZE;
 }
@@ -448,7 +448,7 @@ static int inic_hardreset(struct ata_link *link, unsigned int *class,
 		struct ata_taskfile tf;
 
 		/* wait a while before checking status */
-		msleep(150);
+		ata_wait_after_reset(ap, deadline);
 
 		rc = ata_wait_ready(ap, deadline);
 		/* link occupied, -ENODEV too is an error */
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index b39648f..a43f64d 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1156,7 +1156,7 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
 		last_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
 }
 
-static inline void mv_crqb_pack_cmd(__le16 *cmdw, u8 data, u8 addr, unsigned last)
+static void mv_crqb_pack_cmd(__le16 *cmdw, u8 data, u8 addr, unsigned last)
 {
 	u16 tmp = data | (addr << CRQB_CMD_ADDR_SHIFT) | CRQB_CMD_CS |
 		(last ? CRQB_CMD_LAST : 0);
@@ -2429,7 +2429,7 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 	struct mv_host_priv *hpriv = host->private_data;
 	u32 hp_flags = hpriv->hp_flags;
 
-	switch(board_idx) {
+	switch (board_idx) {
 	case chip_5080:
 		hpriv->ops = &mv5xxx_ops;
 		hp_flags |= MV_HP_GEN_I;
@@ -2510,7 +2510,8 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 		break;
 
 	default:
-		printk(KERN_ERR DRV_NAME ": BUG: invalid board index %u\n", board_idx);
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "BUG: invalid board index %u\n", board_idx);
 		return 1;
 	}
 
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index f1b422f..35b2df2 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -291,7 +291,7 @@ struct nv_swncq_port_priv {
 };
 
 
-#define NV_ADMA_CHECK_INTR(GCTL, PORT) ((GCTL) & ( 1 << (19 + (12 * (PORT)))))
+#define NV_ADMA_CHECK_INTR(GCTL, PORT) ((GCTL) & (1 << (19 + (12 * (PORT)))))
 
 static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 #ifdef CONFIG_PM
@@ -884,8 +884,9 @@ static int nv_adma_check_cpb(struct ata_port *ap, int cpb_num, int force_err)
 			/* Notifier bits set without a command may indicate the drive
 			   is misbehaving. Raise host state machine violation on this
 			   condition. */
-			ata_port_printk(ap, KERN_ERR, "notifier for tag %d with no command?\n",
-				cpb_num);
+			ata_port_printk(ap, KERN_ERR,
+					"notifier for tag %d with no cmd?\n",
+					cpb_num);
 			ehi->err_mask |= AC_ERR_HSM;
 			ehi->action |= ATA_EH_SOFTRESET;
 			ata_port_freeze(ap);
@@ -1012,7 +1013,7 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 				u32 check_commands;
 				int pos, error = 0;
 
-				if(ata_tag_valid(ap->link.active_tag))
+				if (ata_tag_valid(ap->link.active_tag))
 					check_commands = 1 << ap->link.active_tag;
 				else
 					check_commands = ap->link.sactive;
@@ -1021,14 +1022,14 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 				while ((pos = ffs(check_commands)) && !error) {
 					pos--;
 					error = nv_adma_check_cpb(ap, pos,
-						notifier_error & (1 << pos) );
-					check_commands &= ~(1 << pos );
+						notifier_error & (1 << pos));
+					check_commands &= ~(1 << pos);
 				}
 			}
 		}
 	}
 
-	if(notifier_clears[0] || notifier_clears[1]) {
+	if (notifier_clears[0] || notifier_clears[1]) {
 		/* Note: Both notifier clear registers must be written
 		   if either is set, even if one is zero, according to NVIDIA. */
 		struct nv_adma_port_priv *pp = host->ports[0]->private_data;
@@ -1061,7 +1062,7 @@ static void nv_adma_freeze(struct ata_port *ap)
 	tmp = readw(mmio + NV_ADMA_CTL);
 	writew(tmp & ~(NV_ADMA_CTL_AIEN | NV_ADMA_CTL_HOTPLUG_IEN),
 		mmio + NV_ADMA_CTL);
-	readw(mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw(mmio + NV_ADMA_CTL);	/* flush posted write */
 }
 
 static void nv_adma_thaw(struct ata_port *ap)
@@ -1079,7 +1080,7 @@ static void nv_adma_thaw(struct ata_port *ap)
 	tmp = readw(mmio + NV_ADMA_CTL);
 	writew(tmp | (NV_ADMA_CTL_AIEN | NV_ADMA_CTL_HOTPLUG_IEN),
 		mmio + NV_ADMA_CTL);
-	readw(mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw(mmio + NV_ADMA_CTL);	/* flush posted write */
 }
 
 static void nv_adma_irq_clear(struct ata_port *ap)
@@ -1119,7 +1120,7 @@ static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc)
 {
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 
-	if(pp->flags & NV_ADMA_PORT_REGISTER_MODE)
+	if (pp->flags & NV_ADMA_PORT_REGISTER_MODE)
 		ata_bmdma_post_internal_cmd(qc);
 }
 
@@ -1165,7 +1166,7 @@ static int nv_adma_port_start(struct ata_port *ap)
 	pp->cpb_dma = mem_dma;
 
 	writel(mem_dma & 0xFFFFFFFF, 	mmio + NV_ADMA_CPB_BASE_LOW);
-	writel((mem_dma >> 16 ) >> 16,	mmio + NV_ADMA_CPB_BASE_HIGH);
+	writel((mem_dma >> 16) >> 16,	mmio + NV_ADMA_CPB_BASE_HIGH);
 
 	mem     += NV_ADMA_MAX_CPBS * NV_ADMA_CPB_SZ;
 	mem_dma += NV_ADMA_MAX_CPBS * NV_ADMA_CPB_SZ;
@@ -1189,15 +1190,15 @@ static int nv_adma_port_start(struct ata_port *ap)
 
 	/* clear GO for register mode, enable interrupt */
 	tmp = readw(mmio + NV_ADMA_CTL);
-	writew( (tmp & ~NV_ADMA_CTL_GO) | NV_ADMA_CTL_AIEN |
-		 NV_ADMA_CTL_HOTPLUG_IEN, mmio + NV_ADMA_CTL);
+	writew((tmp & ~NV_ADMA_CTL_GO) | NV_ADMA_CTL_AIEN |
+		NV_ADMA_CTL_HOTPLUG_IEN, mmio + NV_ADMA_CTL);
 
 	tmp = readw(mmio + NV_ADMA_CTL);
 	writew(tmp | NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw(mmio + NV_ADMA_CTL);	/* flush posted write */
 	udelay(1);
 	writew(tmp & ~NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw(mmio + NV_ADMA_CTL);	/* flush posted write */
 
 	return 0;
 }
@@ -1237,7 +1238,7 @@ static int nv_adma_port_resume(struct ata_port *ap)
 
 	/* set CPB block location */
 	writel(pp->cpb_dma & 0xFFFFFFFF, 	mmio + NV_ADMA_CPB_BASE_LOW);
-	writel((pp->cpb_dma >> 16 ) >> 16,	mmio + NV_ADMA_CPB_BASE_HIGH);
+	writel((pp->cpb_dma >> 16) >> 16,	mmio + NV_ADMA_CPB_BASE_HIGH);
 
 	/* clear any outstanding interrupt conditions */
 	writew(0xffff, mmio + NV_ADMA_STAT);
@@ -1250,15 +1251,15 @@ static int nv_adma_port_resume(struct ata_port *ap)
 
 	/* clear GO for register mode, enable interrupt */
 	tmp = readw(mmio + NV_ADMA_CTL);
-	writew( (tmp & ~NV_ADMA_CTL_GO) | NV_ADMA_CTL_AIEN |
-		 NV_ADMA_CTL_HOTPLUG_IEN, mmio + NV_ADMA_CTL);
+	writew((tmp & ~NV_ADMA_CTL_GO) | NV_ADMA_CTL_AIEN |
+		NV_ADMA_CTL_HOTPLUG_IEN, mmio + NV_ADMA_CTL);
 
 	tmp = readw(mmio + NV_ADMA_CTL);
 	writew(tmp | NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw(mmio + NV_ADMA_CTL);	/* flush posted write */
 	udelay(1);
 	writew(tmp & ~NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw(mmio + NV_ADMA_CTL);	/* flush posted write */
 
 	return 0;
 }
@@ -1342,7 +1343,8 @@ static void nv_adma_fill_sg(struct ata_queued_cmd *qc, struct nv_adma_cpb *cpb)
 	idx = 0;
 
 	ata_for_each_sg(sg, qc) {
-		aprd = (idx < 5) ? &cpb->aprd[idx] : &pp->aprd[NV_ADMA_SGTBL_LEN * qc->tag + (idx-5)];
+		aprd = (idx < 5) ? &cpb->aprd[idx] :
+			       &pp->aprd[NV_ADMA_SGTBL_LEN * qc->tag + (idx-5)];
 		nv_adma_fill_aprd(qc, sg, idx, aprd);
 		idx++;
 	}
@@ -1359,12 +1361,12 @@ static int nv_adma_use_reg_mode(struct ata_queued_cmd *qc)
 	/* ADMA engine can only be used for non-ATAPI DMA commands,
 	   or interrupt-driven no-data commands, where a result taskfile
 	   is not required. */
-	if((pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
+	if ((pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
 	   (qc->tf.flags & ATA_TFLAG_POLLING) ||
 	   (qc->flags & ATA_QCFLAG_RESULT_TF))
 		return 1;
 
-	if((qc->flags & ATA_QCFLAG_DMAMAP) ||
+	if ((qc->flags & ATA_QCFLAG_DMAMAP) ||
 	   (qc->tf.protocol == ATA_PROT_NODATA))
 		return 0;
 
@@ -1401,14 +1403,14 @@ static void nv_adma_qc_prep(struct ata_queued_cmd *qc)
 
 	nv_adma_tf_to_cpb(&qc->tf, cpb->tf);
 
-	if(qc->flags & ATA_QCFLAG_DMAMAP) {
+	if (qc->flags & ATA_QCFLAG_DMAMAP) {
 		nv_adma_fill_sg(qc, cpb);
 		ctl_flags |= NV_CPB_CTL_APRD_VALID;
 	} else
 		memset(&cpb->aprd[0], 0, sizeof(struct nv_adma_prd) * 5);
 
-	/* Be paranoid and don't let the device see NV_CPB_CTL_CPB_VALID until we are
-	   finished filling in all of the contents */
+	/* Be paranoid and don't let the device see NV_CPB_CTL_CPB_VALID
+	   until we are finished filling in all of the contents */
 	wmb();
 	cpb->ctl_flags = ctl_flags;
 	wmb();
@@ -1435,16 +1437,16 @@ static unsigned int nv_adma_qc_issue(struct ata_queued_cmd *qc)
 	   and (number of cpbs to append -1) in top 8 bits */
 	wmb();
 
-	if(curr_ncq != pp->last_issue_ncq) {
-	   	/* Seems to need some delay before switching between NCQ and non-NCQ
-		   commands, else we get command timeouts and such. */
+	if (curr_ncq != pp->last_issue_ncq) {
+		/* Seems to need some delay before switching between NCQ and
+		   non-NCQ commands, else we get command timeouts and such. */
 		udelay(20);
 		pp->last_issue_ncq = curr_ncq;
 	}
 
 	writew(qc->tag, mmio + NV_ADMA_APPEND);
 
-	DPRINTK("Issued tag %u\n",qc->tag);
+	DPRINTK("Issued tag %u\n", qc->tag);
 
 	return 0;
 }
@@ -1641,12 +1643,12 @@ static void nv_error_handler(struct ata_port *ap)
 static void nv_adma_error_handler(struct ata_port *ap)
 {
 	struct nv_adma_port_priv *pp = ap->private_data;
-	if(!(pp->flags & NV_ADMA_PORT_REGISTER_MODE)) {
+	if (!(pp->flags & NV_ADMA_PORT_REGISTER_MODE)) {
 		void __iomem *mmio = pp->ctl_block;
 		int i;
 		u16 tmp;
 
-		if(ata_tag_valid(ap->link.active_tag) || ap->link.sactive) {
+		if (ata_tag_valid(ap->link.active_tag) || ap->link.sactive) {
 			u32 notifier = readl(mmio + NV_ADMA_NOTIFIER);
 			u32 notifier_error = readl(mmio + NV_ADMA_NOTIFIER_ERROR);
 			u32 gen_ctl = readl(pp->gen_block + NV_ADMA_GEN_CTL);
@@ -1654,16 +1656,17 @@ static void nv_adma_error_handler(struct ata_port *ap)
 			u8 cpb_count = readb(mmio + NV_ADMA_CPB_COUNT);
 			u8 next_cpb_idx = readb(mmio + NV_ADMA_NEXT_CPB_IDX);
 
-			ata_port_printk(ap, KERN_ERR, "EH in ADMA mode, notifier 0x%X "
+			ata_port_printk(ap, KERN_ERR,
+				"EH in ADMA mode, notifier 0x%X "
 				"notifier_error 0x%X gen_ctl 0x%X status 0x%X "
 				"next cpb count 0x%X next cpb idx 0x%x\n",
 				notifier, notifier_error, gen_ctl, status,
 				cpb_count, next_cpb_idx);
 
-			for( i=0;i<NV_ADMA_MAX_CPBS;i++) {
+			for (i = 0; i < NV_ADMA_MAX_CPBS; i++) {
 				struct nv_adma_cpb *cpb = &pp->cpb[i];
-				if( (ata_tag_valid(ap->link.active_tag) && i == ap->link.active_tag) ||
-				    ap->link.sactive & (1 << i) )
+				if ((ata_tag_valid(ap->link.active_tag) && i == ap->link.active_tag) ||
+				    ap->link.sactive & (1 << i))
 					ata_port_printk(ap, KERN_ERR,
 						"CPB %d: ctl_flags 0x%x, resp_flags 0x%x\n",
 						i, cpb->ctl_flags, cpb->resp_flags);
@@ -1673,8 +1676,9 @@ static void nv_adma_error_handler(struct ata_port *ap)
 		/* Push us back into port register mode for error handling. */
 		nv_adma_register_mode(ap);
 
-		/* Mark all of the CPBs as invalid to prevent them from being executed */
-		for( i=0;i<NV_ADMA_MAX_CPBS;i++)
+		/* Mark all of the CPBs as invalid to prevent them from
+		   being executed */
+		for (i = 0; i < NV_ADMA_MAX_CPBS; i++)
 			pp->cpb[i].ctl_flags &= ~NV_CPB_CTL_CPB_VALID;
 
 		/* clear CPB fetch count */
@@ -1683,10 +1687,10 @@ static void nv_adma_error_handler(struct ata_port *ap)
 		/* Reset channel */
 		tmp = readw(mmio + NV_ADMA_CTL);
 		writew(tmp | NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-		readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+		readw(mmio + NV_ADMA_CTL);	/* flush posted write */
 		udelay(1);
 		writew(tmp & ~NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-		readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+		readw(mmio + NV_ADMA_CTL);	/* flush posted write */
 	}
 
 	ata_bmdma_drive_eh(ap, ata_std_prereset, ata_std_softreset,
@@ -2350,9 +2354,9 @@ static irqreturn_t nv_swncq_interrupt(int irq, void *dev_instance)
 	return IRQ_RETVAL(handled);
 }
 
-static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
+static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version = 0;
+	static int printed_version;
 	const struct ata_port_info *ppi[] = { NULL, NULL };
 	struct ata_host *host;
 	struct nv_host_priv *hpriv;
@@ -2364,7 +2368,7 @@ static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
         // Make sure this is a SATA controller by counting the number of bars
         // (NVIDIA SATA controllers will always have six bars).  Otherwise,
         // it's an IDE controller and we ignore it.
-	for (bar=0; bar<6; bar++)
+	for (bar = 0; bar < 6; bar++)
 		if (pci_resource_start(pdev, bar) == 0)
 			return -ENODEV;
 
@@ -2381,6 +2385,14 @@ static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		type = ADMA;
 	}
 
+	if (type == SWNCQ) {
+		if (swncq_enabled)
+			dev_printk(KERN_NOTICE, &pdev->dev,
+				   "Using SWNCQ mode\n");
+		else
+			type = GENERIC;
+	}
+
 	ppi[0] = &nv_port_info[type];
 	rc = ata_pci_prepare_sff_host(pdev, ppi, &host);
 	if (rc)
@@ -2422,10 +2434,8 @@ static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		rc = nv_adma_host_init(host);
 		if (rc)
 			return rc;
-	} else if (type == SWNCQ && swncq_enabled) {
-		dev_printk(KERN_NOTICE, &pdev->dev, "Using SWNCQ mode\n");
+	} else if (type == SWNCQ)
 		nv_swncq_host_init(host);
-	}
 
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, ppi[0]->irq_handler,
@@ -2440,37 +2450,37 @@ static int nv_pci_device_resume(struct pci_dev *pdev)
 	int rc;
 
 	rc = ata_pci_device_do_resume(pdev);
-	if(rc)
+	if (rc)
 		return rc;
 
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
-		if(hpriv->type >= CK804) {
+		if (hpriv->type >= CK804) {
 			u8 regval;
 
 			pci_read_config_byte(pdev, NV_MCP_SATA_CFG_20, &regval);
 			regval |= NV_MCP_SATA_CFG_20_SATA_SPACE_EN;
 			pci_write_config_byte(pdev, NV_MCP_SATA_CFG_20, regval);
 		}
-		if(hpriv->type == ADMA) {
+		if (hpriv->type == ADMA) {
 			u32 tmp32;
 			struct nv_adma_port_priv *pp;
 			/* enable/disable ADMA on the ports appropriately */
 			pci_read_config_dword(pdev, NV_MCP_SATA_CFG_20, &tmp32);
 
 			pp = host->ports[0]->private_data;
-			if(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)
+			if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)
 				tmp32 &= ~(NV_MCP_SATA_CFG_20_PORT0_EN |
-				 	   NV_MCP_SATA_CFG_20_PORT0_PWB_EN);
+					   NV_MCP_SATA_CFG_20_PORT0_PWB_EN);
 			else
 				tmp32 |=  (NV_MCP_SATA_CFG_20_PORT0_EN |
-				 	   NV_MCP_SATA_CFG_20_PORT0_PWB_EN);
+					   NV_MCP_SATA_CFG_20_PORT0_PWB_EN);
 			pp = host->ports[1]->private_data;
-			if(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)
+			if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)
 				tmp32 &= ~(NV_MCP_SATA_CFG_20_PORT1_EN |
-				 	   NV_MCP_SATA_CFG_20_PORT1_PWB_EN);
+					   NV_MCP_SATA_CFG_20_PORT1_PWB_EN);
 			else
 				tmp32 |=  (NV_MCP_SATA_CFG_20_PORT1_EN |
-				 	   NV_MCP_SATA_CFG_20_PORT1_PWB_EN);
+					   NV_MCP_SATA_CFG_20_PORT1_PWB_EN);
 
 			pci_write_config_dword(pdev, NV_MCP_SATA_CFG_20, tmp32);
 		}
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 9032131..deb26f0 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -83,10 +83,12 @@ enum {
 	PDC_PCI_SYS_ERR		= (1 << 22), /* PCI system error */
 	PDC1_PCI_PARITY_ERR	= (1 << 23), /* PCI parity error (from SATA150 driver) */
 	PDC1_ERR_MASK		= PDC1_PCI_PARITY_ERR,
-	PDC2_ERR_MASK		= PDC2_HTO_ERR | PDC2_ATA_HBA_ERR | PDC2_ATA_DMA_CNT_ERR,
-	PDC_ERR_MASK		= (PDC_PH_ERR | PDC_SH_ERR | PDC_DH_ERR | PDC_OVERRUN_ERR
-				   | PDC_UNDERRUN_ERR | PDC_DRIVE_ERR | PDC_PCI_SYS_ERR
-				   | PDC1_ERR_MASK | PDC2_ERR_MASK),
+	PDC2_ERR_MASK		= PDC2_HTO_ERR | PDC2_ATA_HBA_ERR |
+				  PDC2_ATA_DMA_CNT_ERR,
+	PDC_ERR_MASK		= PDC_PH_ERR | PDC_SH_ERR | PDC_DH_ERR |
+				  PDC_OVERRUN_ERR | PDC_UNDERRUN_ERR |
+				  PDC_DRIVE_ERR | PDC_PCI_SYS_ERR |
+				  PDC1_ERR_MASK | PDC2_ERR_MASK,
 
 	board_2037x		= 0,	/* FastTrak S150 TX2plus */
 	board_2037x_pata	= 1,	/* FastTrak S150 TX2plus PATA port */
@@ -695,19 +697,20 @@ static void pdc_irq_clear(struct ata_port *ap)
 	readl(mmio + PDC_INT_SEQMASK);
 }
 
-static inline int pdc_is_sataii_tx4(unsigned long flags)
+static int pdc_is_sataii_tx4(unsigned long flags)
 {
 	const unsigned long mask = PDC_FLAG_GEN_II | PDC_FLAG_4_PORTS;
 	return (flags & mask) == mask;
 }
 
-static inline unsigned int pdc_port_no_to_ata_no(unsigned int port_no, int is_sataii_tx4)
+static unsigned int pdc_port_no_to_ata_no(unsigned int port_no,
+					  int is_sataii_tx4)
 {
 	static const unsigned char sataii_tx4_port_remap[4] = { 3, 1, 0, 2};
 	return is_sataii_tx4 ? sataii_tx4_port_remap[port_no] : port_no;
 }
 
-static irqreturn_t pdc_interrupt (int irq, void *dev_instance)
+static irqreturn_t pdc_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	struct ata_port *ap;
@@ -839,15 +842,16 @@ static unsigned int pdc_qc_issue_prot(struct ata_queued_cmd *qc)
 
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 {
-	WARN_ON (tf->protocol == ATA_PROT_DMA ||
-		 tf->protocol == ATA_PROT_ATAPI_DMA);
+	WARN_ON(tf->protocol == ATA_PROT_DMA ||
+		tf->protocol == ATA_PROT_ATAPI_DMA);
 	ata_tf_load(ap, tf);
 }
 
-static void pdc_exec_command_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
+static void pdc_exec_command_mmio(struct ata_port *ap,
+				  const struct ata_taskfile *tf)
 {
-	WARN_ON (tf->protocol == ATA_PROT_DMA ||
-		 tf->protocol == ATA_PROT_ATAPI_DMA);
+	WARN_ON(tf->protocol == ATA_PROT_DMA ||
+		tf->protocol == ATA_PROT_ATAPI_DMA);
 	ata_exec_command(ap, tf);
 }
 
@@ -870,8 +874,11 @@ static int pdc_check_atapi_dma(struct ata_queued_cmd *qc)
 	}
 	/* -45150 (FFFF4FA2) to -1 (FFFFFFFF) shall use PIO mode */
 	if (scsicmd[0] == WRITE_10) {
-		unsigned int lba;
-		lba = (scsicmd[2] << 24) | (scsicmd[3] << 16) | (scsicmd[4] << 8) | scsicmd[5];
+		unsigned int lba =
+			(scsicmd[2] << 24) |
+			(scsicmd[3] << 16) |
+			(scsicmd[4] << 8) |
+			scsicmd[5];
 		if (lba >= 0xFFFF4FA2)
 			pio = 1;
 	}
@@ -956,7 +963,8 @@ static void pdc_host_init(struct ata_host *host)
 	writel(tmp, mmio + PDC_SLEW_CTL);
 }
 
-static int pdc_ata_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
+static int pdc_ata_init_one(struct pci_dev *pdev,
+			    const struct pci_device_id *ent)
 {
 	static int printed_version;
 	const struct ata_port_info *pi = &pdc_port_info[ent->driver_data];
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index c4c4cd2..6d43ba7 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -113,7 +113,7 @@ struct qs_port_priv {
 
 static int qs_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
 static int qs_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
-static int qs_ata_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
+static int qs_ata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static int qs_port_start(struct ata_port *ap);
 static void qs_host_stop(struct ata_host *host);
 static void qs_phy_reset(struct ata_port *ap);
@@ -135,7 +135,6 @@ static struct scsi_host_template qs_ata_sht = {
 	.sg_tablesize		= QS_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
-	//FIXME .use_clustering		= ATA_SHT_USE_CLUSTERING,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= QS_DMA_BOUNDARY,
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index ea3a0ab..4e6e381 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -111,7 +111,7 @@ enum {
 	SIL_QUIRK_UDMA5MAX	= (1 << 1),
 };
 
-static int sil_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
+static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 #ifdef CONFIG_PM
 static int sil_pci_device_resume(struct pci_dev *pdev);
 #endif
@@ -138,7 +138,7 @@ static const struct pci_device_id sil_pci_tbl[] = {
 
 /* TODO firmware versions should be added - eric */
 static const struct sil_drivelist {
-	const char * product;
+	const char *product;
 	unsigned int quirk;
 } sil_blacklist [] = {
 	{ "ST320012AS",		SIL_QUIRK_MOD15WRITE },
@@ -279,7 +279,7 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, sil_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
-static int slow_down = 0;
+static int slow_down;
 module_param(slow_down, int, 0444);
 MODULE_PARM_DESC(slow_down, "Sledgehammer used to work around random problems, by limiting commands to 15 sectors (0=off, 1=on)");
 
@@ -332,7 +332,8 @@ static int sil_set_mode(struct ata_link *link, struct ata_device **r_failed)
 	return 0;
 }
 
-static inline void __iomem *sil_scr_addr(struct ata_port *ap, unsigned int sc_reg)
+static inline void __iomem *sil_scr_addr(struct ata_port *ap,
+					 unsigned int sc_reg)
 {
 	void __iomem *offset = ap->ioaddr.scr_addr;
 
@@ -643,7 +644,7 @@ static void sil_init_controller(struct ata_host *host)
 	}
 }
 
-static int sil_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
+static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
 	int board_id = ent->driver_data;
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 26ebffc..3c481e0 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -674,7 +674,7 @@ static int sil24_do_softreset(struct ata_link *link, unsigned int *class,
 
 	/* put the port into known state */
 	if (sil24_init_port(ap)) {
-		reason ="port not ready";
+		reason = "port not ready";
 		goto err;
 	}
 
@@ -756,7 +756,8 @@ static int sil24_hardreset(struct ata_link *link, unsigned int *class,
 
 	writel(PORT_CS_DEV_RST, port + PORT_CTRL_STAT);
 	tmp = ata_wait_register(port + PORT_CTRL_STAT,
-				PORT_CS_DEV_RST, PORT_CS_DEV_RST, 10, tout_msec);
+				PORT_CS_DEV_RST, PORT_CS_DEV_RST, 10,
+				tout_msec);
 
 	/* SStatus oscillates between zero and valid status after
 	 * DEV_RST, debounce it.
@@ -1270,7 +1271,7 @@ static void sil24_init_controller(struct ata_host *host)
 						PORT_CS_PORT_RST, 10, 100);
 			if (tmp & PORT_CS_PORT_RST)
 				dev_printk(KERN_ERR, host->dev,
-				           "failed to clear port RST\n");
+					   "failed to clear port RST\n");
 		}
 
 		/* configure port */
@@ -1283,7 +1284,7 @@ static void sil24_init_controller(struct ata_host *host)
 
 static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version = 0;
+	static int printed_version;
 	struct ata_port_info pi = sil24_port_info[ent->driver_data];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
 	void __iomem * const *iomap;
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index f147dc7..a01260a 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -63,17 +63,17 @@ enum {
 	GENCTL_IOMAPPED_SCR	= (1 << 26), /* if set, SCRs are in IO space */
 };
 
-static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
-static int sis_scr_read (struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int sis_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
+static int sis_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
+static int sis_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
 
 static const struct pci_device_id sis_pci_tbl[] = {
-	{ PCI_VDEVICE(SI, 0x0180), sis_180 },		/* SiS 964/180 */
-	{ PCI_VDEVICE(SI, 0x0181), sis_180 },		/* SiS 964/180 */
-	{ PCI_VDEVICE(SI, 0x0182), sis_180 },		/* SiS 965/965L */
-	{ PCI_VDEVICE(SI, 0x0183), sis_180 },		/* SiS 965/965L */
-	{ PCI_VDEVICE(SI, 0x1182), sis_180 },		/* SiS 966/680 */
-	{ PCI_VDEVICE(SI, 0x1183), sis_180 },		/* SiS 966/966L/968/680 */
+	{ PCI_VDEVICE(SI, 0x0180), sis_180 },	/* SiS 964/180 */
+	{ PCI_VDEVICE(SI, 0x0181), sis_180 },	/* SiS 964/180 */
+	{ PCI_VDEVICE(SI, 0x0182), sis_180 },	/* SiS 965/965L */
+	{ PCI_VDEVICE(SI, 0x0183), sis_180 },	/* SiS 965/965L */
+	{ PCI_VDEVICE(SI, 0x1182), sis_180 },	/* SiS 966/680 */
+	{ PCI_VDEVICE(SI, 0x1183), sis_180 },	/* SiS 966/966L/968/680 */
 
 	{ }	/* terminate list */
 };
@@ -149,24 +149,24 @@ static unsigned int get_scr_cfg_addr(struct ata_port *ap, unsigned int sc_reg)
 
 	if (ap->port_no)  {
 		switch (pdev->device) {
-			case 0x0180:
-			case 0x0181:
-				pci_read_config_byte(pdev, SIS_PMR, &pmr);
-				if ((pmr & SIS_PMR_COMBINED) == 0)
-					addr += SIS180_SATA1_OFS;
-				break;
-
-			case 0x0182:
-			case 0x0183:
-			case 0x1182:
-				addr += SIS182_SATA1_OFS;
-				break;
+		case 0x0180:
+		case 0x0181:
+			pci_read_config_byte(pdev, SIS_PMR, &pmr);
+			if ((pmr & SIS_PMR_COMBINED) == 0)
+				addr += SIS180_SATA1_OFS;
+			break;
+
+		case 0x0182:
+		case 0x0183:
+		case 0x1182:
+			addr += SIS182_SATA1_OFS;
+			break;
 		}
 	}
 	return addr;
 }
 
-static u32 sis_scr_cfg_read (struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static u32 sis_scr_cfg_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned int cfg_addr = get_scr_cfg_addr(ap, sc_reg);
@@ -190,7 +190,7 @@ static u32 sis_scr_cfg_read (struct ata_port *ap, unsigned int sc_reg, u32 *val)
 	return 0;
 }
 
-static void sis_scr_cfg_write (struct ata_port *ap, unsigned int sc_reg, u32 val)
+static void sis_scr_cfg_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned int cfg_addr = get_scr_cfg_addr(ap, sc_reg);
@@ -253,7 +253,7 @@ static int sis_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 	return 0;
 }
 
-static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
+static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
 	struct ata_port_info pi = sis_port_info;
@@ -309,29 +309,33 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		} else {
 			dev_printk(KERN_INFO, &pdev->dev,
 				   "Detected SiS 180/181 chipset in combined mode\n");
-			port2_start=0;
+			port2_start = 0;
 			pi.flags |= ATA_FLAG_SLAVE_POSS;
 		}
 		break;
 
 	case 0x0182:
 	case 0x0183:
-		pci_read_config_dword ( pdev, 0x6C, &val);
+		pci_read_config_dword(pdev, 0x6C, &val);
 		if (val & (1L << 31)) {
-			dev_printk(KERN_INFO, &pdev->dev, "Detected SiS 182/965 chipset\n");
+			dev_printk(KERN_INFO, &pdev->dev,
+				   "Detected SiS 182/965 chipset\n");
 			pi.flags |= ATA_FLAG_SLAVE_POSS;
 		} else {
-			dev_printk(KERN_INFO, &pdev->dev, "Detected SiS 182/965L chipset\n");
+			dev_printk(KERN_INFO, &pdev->dev,
+				   "Detected SiS 182/965L chipset\n");
 		}
 		break;
 
 	case 0x1182:
-		dev_printk(KERN_INFO, &pdev->dev, "Detected SiS 1182/966/680 SATA controller\n");
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "Detected SiS 1182/966/680 SATA controller\n");
 		pi.flags |= ATA_FLAG_SLAVE_POSS;
 		break;
 
 	case 0x1183:
-		dev_printk(KERN_INFO, &pdev->dev, "Detected SiS 1183/966/966L/968/680 controller in PATA mode\n");
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "Detected SiS 1183/966/966L/968/680 controller in PATA mode\n");
 		ppi[0] = &sis_info133_for_sata;
 		ppi[1] = &sis_info133_for_sata;
 		break;
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 12d613c..69f651e 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -182,7 +182,7 @@ static void k2_sata_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 		tf->hob_lbal = lbal >> 8;
 		tf->hob_lbam = lbam >> 8;
 		tf->hob_lbah = lbah >> 8;
-        }
+	}
 }
 
 /**
@@ -193,7 +193,7 @@ static void k2_sata_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
  *	spin_lock_irqsave(host lock)
  */
 
-static void k2_bmdma_setup_mmio (struct ata_queued_cmd *qc)
+static void k2_bmdma_setup_mmio(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	unsigned int rw = (qc->tf.flags & ATA_TFLAG_WRITE);
@@ -224,7 +224,7 @@ static void k2_bmdma_setup_mmio (struct ata_queued_cmd *qc)
  *	spin_lock_irqsave(host lock)
  */
 
-static void k2_bmdma_start_mmio (struct ata_queued_cmd *qc)
+static void k2_bmdma_start_mmio(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	void __iomem *mmio = ap->ioaddr.bmdma_addr;
@@ -255,7 +255,7 @@ static void k2_bmdma_start_mmio (struct ata_queued_cmd *qc)
 
 static u8 k2_stat_check_status(struct ata_port *ap)
 {
-       	return readl(ap->ioaddr.status_addr);
+	return readl(ap->ioaddr.status_addr);
 }
 
 #ifdef CONFIG_PPC_OF
@@ -395,7 +395,7 @@ static void k2_sata_setup_port(struct ata_ioports *port, void __iomem *base)
 }
 
 
-static int k2_sata_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
+static int k2_sata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
 	const struct ata_port_info *ppi[] =
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index b6026bc..4d85718 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -212,9 +212,9 @@ struct pdc_host_priv {
 };
 
 
-static int pdc_sata_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
+static int pdc_sata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static void pdc_eng_timeout(struct ata_port *ap);
-static void pdc_20621_phy_reset (struct ata_port *ap);
+static void pdc_20621_phy_reset(struct ata_port *ap);
 static int pdc_port_start(struct ata_port *ap);
 static void pdc20621_qc_prep(struct ata_queued_cmd *qc);
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf);
@@ -320,16 +320,16 @@ static int pdc_port_start(struct ata_port *ap)
 	return 0;
 }
 
-static void pdc_20621_phy_reset (struct ata_port *ap)
+static void pdc_20621_phy_reset(struct ata_port *ap)
 {
 	VPRINTK("ENTER\n");
-        ap->cbl = ATA_CBL_SATA;
-        ata_port_probe(ap);
-        ata_bus_reset(ap);
+	ap->cbl = ATA_CBL_SATA;
+	ata_port_probe(ap);
+	ata_bus_reset(ap);
 }
 
 static inline void pdc20621_ata_sg(struct ata_taskfile *tf, u8 *buf,
-				    	   unsigned int portno,
+				   unsigned int portno,
 					   unsigned int total_len)
 {
 	u32 addr;
@@ -351,7 +351,7 @@ static inline void pdc20621_ata_sg(struct ata_taskfile *tf, u8 *buf,
 }
 
 static inline void pdc20621_host_sg(struct ata_taskfile *tf, u8 *buf,
-				    	    unsigned int portno,
+				    unsigned int portno,
 					    unsigned int total_len)
 {
 	u32 addr;
@@ -711,8 +711,8 @@ static unsigned int pdc20621_qc_issue_prot(struct ata_queued_cmd *qc)
 	return ata_qc_issue_prot(qc);
 }
 
-static inline unsigned int pdc20621_host_intr( struct ata_port *ap,
-                                          struct ata_queued_cmd *qc,
+static inline unsigned int pdc20621_host_intr(struct ata_port *ap,
+					  struct ata_queued_cmd *qc,
 					  unsigned int doing_hdma,
 					  void __iomem *mmio)
 {
@@ -803,7 +803,7 @@ static void pdc20621_irq_clear(struct ata_port *ap)
 	readl(mmio + PDC_20621_SEQMASK);
 }
 
-static irqreturn_t pdc20621_interrupt (int irq, void *dev_instance)
+static irqreturn_t pdc20621_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	struct ata_port *ap;
@@ -836,9 +836,9 @@ static irqreturn_t pdc20621_interrupt (int irq, void *dev_instance)
 		return IRQ_NONE;
 	}
 
-        spin_lock(&host->lock);
+	spin_lock(&host->lock);
 
-        for (i = 1; i < 9; i++) {
+	for (i = 1; i < 9; i++) {
 		port_no = i - 1;
 		if (port_no > 3)
 			port_no -= 4;
@@ -859,7 +859,7 @@ static irqreturn_t pdc20621_interrupt (int irq, void *dev_instance)
 		}
 	}
 
-        spin_unlock(&host->lock);
+	spin_unlock(&host->lock);
 
 	VPRINTK("mask == 0x%x\n", mask);
 
@@ -906,16 +906,16 @@ static void pdc_eng_timeout(struct ata_port *ap)
 
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 {
-	WARN_ON (tf->protocol == ATA_PROT_DMA ||
-		 tf->protocol == ATA_PROT_NODATA);
+	WARN_ON(tf->protocol == ATA_PROT_DMA ||
+		tf->protocol == ATA_PROT_NODATA);
 	ata_tf_load(ap, tf);
 }
 
 
 static void pdc_exec_command_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 {
-	WARN_ON (tf->protocol == ATA_PROT_DMA ||
-		 tf->protocol == ATA_PROT_NODATA);
+	WARN_ON(tf->protocol == ATA_PROT_DMA ||
+		tf->protocol == ATA_PROT_NODATA);
 	ata_exec_command(ap, tf);
 }
 
@@ -953,7 +953,7 @@ static void pdc20621_get_from_dimm(struct ata_host *host, void *psource,
 	mmio += PDC_CHIP0_OFS;
 
 	page_mask = 0x00;
-   	window_size = 0x2000 * 4; /* 32K byte uchar size */
+	window_size = 0x2000 * 4; /* 32K byte uchar size */
 	idx = (u16) (offset / window_size);
 
 	writel(0x01, mmio + PDC_GENERAL_CTLR);
@@ -979,7 +979,7 @@ static void pdc20621_get_from_dimm(struct ata_host *host, void *psource,
 			      window_size / 4);
 		psource += window_size;
 		size -= window_size;
-		idx ++;
+		idx++;
 	}
 
 	if (size) {
@@ -1008,7 +1008,7 @@ static void pdc20621_put_to_dimm(struct ata_host *host, void *psource,
 	mmio += PDC_CHIP0_OFS;
 
 	page_mask = 0x00;
-   	window_size = 0x2000 * 4;       /* 32K byte uchar size */
+	window_size = 0x2000 * 4;       /* 32K byte uchar size */
 	idx = (u16) (offset / window_size);
 
 	writel(((idx) << page_mask), mmio + PDC_DIMM_WINDOW_CTLR);
@@ -1031,7 +1031,7 @@ static void pdc20621_put_to_dimm(struct ata_host *host, void *psource,
 		readl(mmio + PDC_GENERAL_CTLR);
 		psource += window_size;
 		size -= window_size;
-		idx ++;
+		idx++;
 	}
 
 	if (size) {
@@ -1050,7 +1050,7 @@ static unsigned int pdc20621_i2c_read(struct ata_host *host, u32 device,
 	void __iomem *mmio = host->iomap[PDC_MMIO_BAR];
 	u32 i2creg  = 0;
 	u32 status;
-	u32 count =0;
+	u32 count = 0;
 
 	/* hard-code chip #0 */
 	mmio += PDC_CHIP0_OFS;
@@ -1082,21 +1082,21 @@ static unsigned int pdc20621_i2c_read(struct ata_host *host, u32 device,
 
 static int pdc20621_detect_dimm(struct ata_host *host)
 {
-	u32 data=0 ;
+	u32 data = 0;
 	if (pdc20621_i2c_read(host, PDC_DIMM0_SPD_DEV_ADDRESS,
 			     PDC_DIMM_SPD_SYSTEM_FREQ, &data)) {
-   		if (data == 100)
+		if (data == 100)
 			return 100;
-  	} else
+	} else
 		return 0;
 
 	if (pdc20621_i2c_read(host, PDC_DIMM0_SPD_DEV_ADDRESS, 9, &data)) {
-		if(data <= 0x75)
+		if (data <= 0x75)
 			return 133;
-   	} else
+	} else
 		return 0;
 
-   	return 0;
+	return 0;
 }
 
 
@@ -1104,8 +1104,8 @@ static int pdc20621_prog_dimm0(struct ata_host *host)
 {
 	u32 spd0[50];
 	u32 data = 0;
-   	int size, i;
-   	u8 bdimmsize;
+	int size, i;
+	u8 bdimmsize;
 	void __iomem *mmio = host->iomap[PDC_MMIO_BAR];
 	static const struct {
 		unsigned int reg;
@@ -1128,40 +1128,40 @@ static int pdc20621_prog_dimm0(struct ata_host *host)
 	/* hard-code chip #0 */
 	mmio += PDC_CHIP0_OFS;
 
-	for(i=0; i<ARRAY_SIZE(pdc_i2c_read_data); i++)
+	for (i = 0; i < ARRAY_SIZE(pdc_i2c_read_data); i++)
 		pdc20621_i2c_read(host, PDC_DIMM0_SPD_DEV_ADDRESS,
 				  pdc_i2c_read_data[i].reg,
 				  &spd0[pdc_i2c_read_data[i].ofs]);
 
-   	data |= (spd0[4] - 8) | ((spd0[21] != 0) << 3) | ((spd0[3]-11) << 4);
-   	data |= ((spd0[17] / 4) << 6) | ((spd0[5] / 2) << 7) |
+	data |= (spd0[4] - 8) | ((spd0[21] != 0) << 3) | ((spd0[3]-11) << 4);
+	data |= ((spd0[17] / 4) << 6) | ((spd0[5] / 2) << 7) |
 		((((spd0[27] + 9) / 10) - 1) << 8) ;
-   	data |= (((((spd0[29] > spd0[28])
+	data |= (((((spd0[29] > spd0[28])
 		    ? spd0[29] : spd0[28]) + 9) / 10) - 1) << 10;
-   	data |= ((spd0[30] - spd0[29] + 9) / 10 - 2) << 12;
+	data |= ((spd0[30] - spd0[29] + 9) / 10 - 2) << 12;
 
-   	if (spd0[18] & 0x08)
+	if (spd0[18] & 0x08)
 		data |= ((0x03) << 14);
-   	else if (spd0[18] & 0x04)
+	else if (spd0[18] & 0x04)
 		data |= ((0x02) << 14);
-   	else if (spd0[18] & 0x01)
+	else if (spd0[18] & 0x01)
 		data |= ((0x01) << 14);
-   	else
+	else
 		data |= (0 << 14);
 
-  	/*
+	/*
 	   Calculate the size of bDIMMSize (power of 2) and
 	   merge the DIMM size by program start/end address.
 	*/
 
-   	bdimmsize = spd0[4] + (spd0[5] / 2) + spd0[3] + (spd0[17] / 2) + 3;
-   	size = (1 << bdimmsize) >> 20;	/* size = xxx(MB) */
-   	data |= (((size / 16) - 1) << 16);
-   	data |= (0 << 23);
+	bdimmsize = spd0[4] + (spd0[5] / 2) + spd0[3] + (spd0[17] / 2) + 3;
+	size = (1 << bdimmsize) >> 20;	/* size = xxx(MB) */
+	data |= (((size / 16) - 1) << 16);
+	data |= (0 << 23);
 	data |= 8;
-   	writel(data, mmio + PDC_DIMM0_CONTROL);
+	writel(data, mmio + PDC_DIMM0_CONTROL);
 	readl(mmio + PDC_DIMM0_CONTROL);
-   	return size;
+	return size;
 }
 
 
@@ -1172,9 +1172,9 @@ static unsigned int pdc20621_prog_dimm_global(struct ata_host *host)
 	void __iomem *mmio = host->iomap[PDC_MMIO_BAR];
 
 	/* hard-code chip #0 */
-   	mmio += PDC_CHIP0_OFS;
+	mmio += PDC_CHIP0_OFS;
 
-   	/*
+	/*
 	  Set To Default : DIMM Module Global Control Register (0x022259F1)
 	  DIMM Arbitration Disable (bit 20)
 	  DIMM Data/Control Output Driving Selection (bit12 - bit15)
@@ -1193,40 +1193,40 @@ static unsigned int pdc20621_prog_dimm_global(struct ata_host *host)
 		writel(data, mmio + PDC_SDRAM_CONTROL);
 		readl(mmio + PDC_SDRAM_CONTROL);
 		printk(KERN_ERR "Local DIMM ECC Enabled\n");
-   	}
+	}
 
-   	/* DIMM Initialization Select/Enable (bit 18/19) */
-   	data &= (~(1<<18));
-   	data |= (1<<19);
-   	writel(data, mmio + PDC_SDRAM_CONTROL);
+	/* DIMM Initialization Select/Enable (bit 18/19) */
+	data &= (~(1<<18));
+	data |= (1<<19);
+	writel(data, mmio + PDC_SDRAM_CONTROL);
 
-   	error = 1;
-   	for (i = 1; i <= 10; i++) {   /* polling ~5 secs */
+	error = 1;
+	for (i = 1; i <= 10; i++) {   /* polling ~5 secs */
 		data = readl(mmio + PDC_SDRAM_CONTROL);
 		if (!(data & (1<<19))) {
-	   		error = 0;
-	   		break;
+			error = 0;
+			break;
 		}
 		msleep(i*100);
-   	}
-   	return error;
+	}
+	return error;
 }
 
 
 static unsigned int pdc20621_dimm_init(struct ata_host *host)
 {
 	int speed, size, length;
-	u32 addr,spd0,pci_status;
-	u32 tmp=0;
-	u32 time_period=0;
-	u32 tcount=0;
-	u32 ticks=0;
-	u32 clock=0;
-	u32 fparam=0;
+	u32 addr, spd0, pci_status;
+	u32 tmp = 0;
+	u32 time_period = 0;
+	u32 tcount = 0;
+	u32 ticks = 0;
+	u32 clock = 0;
+	u32 fparam = 0;
 	void __iomem *mmio = host->iomap[PDC_MMIO_BAR];
 
 	/* hard-code chip #0 */
-   	mmio += PDC_CHIP0_OFS;
+	mmio += PDC_CHIP0_OFS;
 
 	/* Initialize PLL based upon PCI Bus Frequency */
 
@@ -1254,7 +1254,7 @@ static unsigned int pdc20621_dimm_init(struct ata_host *host)
 	   If SX4 is on PCI-X bus, after 3 seconds, the timer counter
 	   register should be >= (0xffffffff - 3x10^8).
 	*/
-	if(tcount >= PCI_X_TCOUNT) {
+	if (tcount >= PCI_X_TCOUNT) {
 		ticks = (time_period - tcount);
 		VPRINTK("Num counters 0x%x (%d)\n", ticks, ticks);
 
@@ -1285,41 +1285,43 @@ static unsigned int pdc20621_dimm_init(struct ata_host *host)
 	if (!(speed = pdc20621_detect_dimm(host))) {
 		printk(KERN_ERR "Detect Local DIMM Fail\n");
 		return 1;	/* DIMM error */
-   	}
-   	VPRINTK("Local DIMM Speed = %d\n", speed);
+	}
+	VPRINTK("Local DIMM Speed = %d\n", speed);
 
-   	/* Programming DIMM0 Module Control Register (index_CID0:80h) */
+	/* Programming DIMM0 Module Control Register (index_CID0:80h) */
 	size = pdc20621_prog_dimm0(host);
-   	VPRINTK("Local DIMM Size = %dMB\n",size);
+	VPRINTK("Local DIMM Size = %dMB\n", size);
 
-   	/* Programming DIMM Module Global Control Register (index_CID0:88h) */
+	/* Programming DIMM Module Global Control Register (index_CID0:88h) */
 	if (pdc20621_prog_dimm_global(host)) {
 		printk(KERN_ERR "Programming DIMM Module Global Control Register Fail\n");
 		return 1;
-   	}
+	}
 
 #ifdef ATA_VERBOSE_DEBUG
 	{
-		u8 test_parttern1[40] = {0x55,0xAA,'P','r','o','m','i','s','e',' ',
-  				'N','o','t',' ','Y','e','t',' ','D','e','f','i','n','e','d',' ',
- 				 '1','.','1','0',
-  				'9','8','0','3','1','6','1','2',0,0};
+		u8 test_parttern1[40] =
+			{0x55,0xAA,'P','r','o','m','i','s','e',' ',
+			'N','o','t',' ','Y','e','t',' ',
+			'D','e','f','i','n','e','d',' ',
+			'1','.','1','0',
+			'9','8','0','3','1','6','1','2',0,0};
 		u8 test_parttern2[40] = {0};
 
-		pdc20621_put_to_dimm(host, (void *) test_parttern2, 0x10040, 40);
-		pdc20621_put_to_dimm(host, (void *) test_parttern2, 0x40, 40);
+		pdc20621_put_to_dimm(host, test_parttern2, 0x10040, 40);
+		pdc20621_put_to_dimm(host, test_parttern2, 0x40, 40);
 
-		pdc20621_put_to_dimm(host, (void *) test_parttern1, 0x10040, 40);
-		pdc20621_get_from_dimm(host, (void *) test_parttern2, 0x40, 40);
+		pdc20621_put_to_dimm(host, test_parttern1, 0x10040, 40);
+		pdc20621_get_from_dimm(host, test_parttern2, 0x40, 40);
 		printk(KERN_ERR "%x, %x, %s\n", test_parttern2[0],
 		       test_parttern2[1], &(test_parttern2[2]));
-		pdc20621_get_from_dimm(host, (void *) test_parttern2, 0x10040,
+		pdc20621_get_from_dimm(host, test_parttern2, 0x10040,
 				       40);
 		printk(KERN_ERR "%x, %x, %s\n", test_parttern2[0],
 		       test_parttern2[1], &(test_parttern2[2]));
 
-		pdc20621_put_to_dimm(host, (void *) test_parttern1, 0x40, 40);
-		pdc20621_get_from_dimm(host, (void *) test_parttern2, 0x40, 40);
+		pdc20621_put_to_dimm(host, test_parttern1, 0x40, 40);
+		pdc20621_get_from_dimm(host, test_parttern2, 0x40, 40);
 		printk(KERN_ERR "%x, %x, %s\n", test_parttern2[0],
 		       test_parttern2[1], &(test_parttern2[2]));
 	}
@@ -1375,7 +1377,8 @@ static void pdc_20621_init(struct ata_host *host)
 	readl(mmio + PDC_HDMA_CTLSTAT);		/* flush */
 }
 
-static int pdc_sata_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
+static int pdc_sata_init_one(struct pci_dev *pdev,
+			     const struct pci_device_id *ent)
 {
 	static int printed_version;
 	const struct ata_port_info *ppi[] =
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index d394da0..e710e71 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -56,9 +56,9 @@ struct uli_priv {
 	unsigned int		scr_cfg_addr[uli_max_ports];
 };
 
-static int uli_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
-static int uli_scr_read (struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int uli_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int uli_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
+static int uli_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
+static int uli_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
 
 static const struct pci_device_id uli_pci_tbl[] = {
 	{ PCI_VDEVICE(AL, 0x5289), uli_5289 },
@@ -143,7 +143,7 @@ static unsigned int get_scr_cfg_addr(struct ata_port *ap, unsigned int sc_reg)
 	return hpriv->scr_cfg_addr[ap->port_no] + (4 * sc_reg);
 }
 
-static u32 uli_scr_cfg_read (struct ata_port *ap, unsigned int sc_reg)
+static u32 uli_scr_cfg_read(struct ata_port *ap, unsigned int sc_reg)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned int cfg_addr = get_scr_cfg_addr(ap, sc_reg);
@@ -153,7 +153,7 @@ static u32 uli_scr_cfg_read (struct ata_port *ap, unsigned int sc_reg)
 	return val;
 }
 
-static void uli_scr_cfg_write (struct ata_port *ap, unsigned int scr, u32 val)
+static void uli_scr_cfg_write(struct ata_port *ap, unsigned int scr, u32 val)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned int cfg_addr = get_scr_cfg_addr(ap, scr);
@@ -161,7 +161,7 @@ static void uli_scr_cfg_write (struct ata_port *ap, unsigned int scr, u32 val)
 	pci_write_config_dword(pdev, cfg_addr, val);
 }
 
-static int uli_scr_read (struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int uli_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
@@ -170,16 +170,16 @@ static int uli_scr_read (struct ata_port *ap, unsigned int sc_reg, u32 *val)
 	return 0;
 }
 
-static int uli_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int uli_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 {
-	if (sc_reg > SCR_CONTROL)	//SCR_CONTROL=2, SCR_ERROR=1, SCR_STATUS=0
+	if (sc_reg > SCR_CONTROL) //SCR_CONTROL=2, SCR_ERROR=1, SCR_STATUS=0
 		return -EINVAL;
 
 	uli_scr_cfg_write(ap, sc_reg, val);
 	return 0;
 }
 
-static int uli_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
+static int uli_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
 	const struct ata_port_info *ppi[] = { &uli_port_info, NULL };
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index cc6ee08..3ef072f 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -3,7 +3,7 @@
  *
  *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
  * 		   Please ALWAYS copy linux-ide@vger.kernel.org
- 		   on emails.
+ *		   on emails.
  *
  *  Copyright 2003-2004 Red Hat, Inc.  All rights reserved.
  *  Copyright 2003-2004 Jeff Garzik
@@ -69,7 +69,7 @@ enum {
 	SATA_EXT_PHY		= (1 << 6), /* 0==use PATA, 1==ext phy */
 };
 
-static int svia_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
+static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static int svia_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
 static int svia_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
 static void svia_noop_freeze(struct ata_port *ap);
@@ -372,12 +372,12 @@ static const unsigned int vt6421_bar_sizes[] = {
 	16, 16, 16, 16, 32, 128
 };
 
-static void __iomem * svia_scr_addr(void __iomem *addr, unsigned int port)
+static void __iomem *svia_scr_addr(void __iomem *addr, unsigned int port)
 {
 	return addr + (port * 128);
 }
 
-static void __iomem * vt6421_scr_addr(void __iomem *addr, unsigned int port)
+static void __iomem *vt6421_scr_addr(void __iomem *addr, unsigned int port)
 {
 	return addr + (port * 64);
 }
@@ -472,7 +472,7 @@ static void svia_configure(struct pci_dev *pdev)
 	if ((tmp8 & ALL_PORTS) != ALL_PORTS) {
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "enabling SATA channels (0x%x)\n",
-		           (int) tmp8);
+			   (int) tmp8);
 		tmp8 |= ALL_PORTS;
 		pci_write_config_byte(pdev, SATA_CHAN_ENAB, tmp8);
 	}
@@ -482,7 +482,7 @@ static void svia_configure(struct pci_dev *pdev)
 	if ((tmp8 & ALL_PORTS) != ALL_PORTS) {
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "enabling SATA channel interrupts (0x%x)\n",
-		           (int) tmp8);
+			   (int) tmp8);
 		tmp8 |= ALL_PORTS;
 		pci_write_config_byte(pdev, SATA_INT_GATE, tmp8);
 	}
@@ -492,13 +492,13 @@ static void svia_configure(struct pci_dev *pdev)
 	if ((tmp8 & NATIVE_MODE_ALL) != NATIVE_MODE_ALL) {
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "enabling SATA channel native mode (0x%x)\n",
-		           (int) tmp8);
+			   (int) tmp8);
 		tmp8 |= NATIVE_MODE_ALL;
 		pci_write_config_byte(pdev, SATA_NATIVE_MODE, tmp8);
 	}
 }
 
-static int svia_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
+static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
 	unsigned int i;
@@ -525,8 +525,8 @@ static int svia_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 			dev_printk(KERN_ERR, &pdev->dev,
 				"invalid PCI BAR %u (sz 0x%llx, val 0x%llx)\n",
 				i,
-			        (unsigned long long)pci_resource_start(pdev, i),
-			        (unsigned long long)pci_resource_len(pdev, i));
+				(unsigned long long)pci_resource_start(pdev, i),
+				(unsigned long long)pci_resource_len(pdev, i));
 			return -ENODEV;
 		}
 
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 0d9be16..95ae3ed 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -162,7 +162,8 @@ static void vsc_sata_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 	/*
 	 * The only thing the ctl register is used for is SRST.
 	 * That is not enabled or disabled via tf_load.
-	 * However, if ATA_NIEN is changed, then we need to change the interrupt register.
+	 * However, if ATA_NIEN is changed, then we need to change
+	 * the interrupt register.
 	 */
 	if ((tf->ctl & ATA_NIEN) != (ap->last_ctl & ATA_NIEN)) {
 		ap->last_ctl = tf->ctl;
@@ -219,7 +220,7 @@ static void vsc_sata_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 		tf->hob_lbal = lbal >> 8;
 		tf->hob_lbam = lbam >> 8;
 		tf->hob_lbah = lbah >> 8;
-        }
+	}
 }
 
 static inline void vsc_error_intr(u8 port_status, struct ata_port *ap)
@@ -256,9 +257,10 @@ static void vsc_port_intr(u8 port_status, struct ata_port *ap)
 /*
  * vsc_sata_interrupt
  *
- * Read the interrupt register and process for the devices that have them pending.
+ * Read the interrupt register and process for the devices that have
+ * them pending.
  */
-static irqreturn_t vsc_sata_interrupt (int irq, void *dev_instance)
+static irqreturn_t vsc_sata_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	unsigned int i;
@@ -287,7 +289,7 @@ static irqreturn_t vsc_sata_interrupt (int irq, void *dev_instance)
 				handled++;
 			} else
 				dev_printk(KERN_ERR, host->dev,
-					": interrupt from disabled port %d\n", i);
+					"interrupt from disabled port %d\n", i);
 		}
 	}
 
@@ -363,7 +365,8 @@ static void __devinit vsc_sata_setup_port(struct ata_ioports *port,
 }
 
 
-static int __devinit vsc_sata_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
+static int __devinit vsc_sata_init_one(struct pci_dev *pdev,
+				       const struct pci_device_id *ent)
 {
 	static const struct ata_port_info pi = {
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 8263a7b..e21c002 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -180,6 +180,7 @@ enum {
 	ATA_CMD_VERIFY_EXT	= 0x42,
 	ATA_CMD_STANDBYNOW1	= 0xE0,
 	ATA_CMD_IDLEIMMEDIATE	= 0xE1,
+	ATA_CMD_SLEEP		= 0xE6,
 	ATA_CMD_INIT_DEV_PARAMS	= 0x91,
 	ATA_CMD_READ_NATIVE_MAX	= 0xF8,
 	ATA_CMD_READ_NATIVE_MAX_EXT = 0x27,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 6fd24e0..439d40f 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -138,6 +138,7 @@ enum {
 	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
 	ATA_DFLAG_NCQ_OFF	= (1 << 13), /* device limited to non-NCQ mode */
 	ATA_DFLAG_SPUNDOWN	= (1 << 14), /* XXX: for spindown_compat */
+	ATA_DFLAG_SLEEPING	= (1 << 15), /* device is sleeping */
 	ATA_DFLAG_INIT_MASK	= (1 << 16) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 16),
@@ -234,6 +235,13 @@ enum {
 	ATA_TMOUT_INTERNAL	= 30 * HZ,
 	ATA_TMOUT_INTERNAL_QUICK = 5 * HZ,
 
+	/* FIXME: GoVault needs 2s but we can't afford that without
+	 * parallel probing.  800ms is enough for iVDR disk
+	 * HHD424020F7SV00.  Increase to 2secs when parallel probing
+	 * is in place.
+	 */
+	ATA_TMOUT_FF_WAIT	= 4 * HZ / 5,
+
 	/* ATA bus states */
 	BUS_UNKNOWN		= 0,
 	BUS_DMA			= 1,
@@ -799,6 +807,7 @@ extern void ata_host_resume(struct ata_host *host);
 extern int ata_ratelimit(void);
 extern int ata_busy_sleep(struct ata_port *ap,
 			  unsigned long timeout_pat, unsigned long timeout);
+extern void ata_wait_after_reset(struct ata_port *ap, unsigned long deadline);
 extern int ata_wait_ready(struct ata_port *ap, unsigned long deadline);
 extern void ata_port_queue_task(struct ata_port *ap, work_func_t fn,
 				void *data, unsigned long delay);
