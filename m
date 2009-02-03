Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbZBCE16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbZBCE16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZBCE1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:27:47 -0500
Received: from havoc.gtf.org ([69.61.125.42]:40341 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZBCE1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:27:44 -0500
Date: Mon, 2 Feb 2009 23:27:42 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20090203042742.GA5295@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) 8-patch patchset from Tejun to fix eSata cable flakiness and
   WD My Book issues

2) A CompactFlash (CFA) identification fix, which also affects
   drivers/ide, since drivers/ide shares some definitions with libata
   via include/linux/ata.h.

Other minor fixes, and an AHCI workaround for staggered spin-up ("SSS")
from Arjan related to the async stuff.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |    9 ++++-
 drivers/ata/libata-core.c |   96 +++++++++++++++++++++++++++++++++-----------
 drivers/ata/libata-eh.c   |   87 +++++++++++++++++++++++++++++++++++++----
 drivers/ata/libata-pmp.c  |    2 +-
 drivers/ata/libata-scsi.c |    1 +
 drivers/ata/libata.h      |    4 +-
 drivers/ata/sata_mv.c     |    4 +-
 drivers/ata/sata_nv.c     |    7 +++-
 drivers/ata/sata_sil.c    |    2 +-
 include/linux/ata.h       |   15 +++++--
 include/linux/libata.h    |   19 +++++----
 11 files changed, 193 insertions(+), 53 deletions(-)

Arjan van de Ven (1):
      ahci: add a module parameter to ignore the SSS flags for async scanning

Mark Lord (1):
      sata_mv: Fix chip type for Hightpoint RocketRaid 1740/1742

Pasi Kärkkäinen (1):
      [libata] sata_sil: Fix compilation error with libata debugging enabled

Randy Dunlap (1):
      libata: fix kernel-doc warnings

Sergei Shtylyov (1):
      ide/libata: fix ata_id_is_cfa() (take 4)

Tejun Heo (9):
      sata_nv: ck804 has borked hardreset too
      libata: fix EH device failure handling
      libata: move ata_dev_disable() to libata-eh.c
      libata: check onlineness before using SPD in sata_down_spd_limit()
      libata: clear dev->ering in smarter way
      libata: add @spd_limit to sata_down_spd_limit()
      libata: improve probe failure handling
      libata: add no penalty retry request for EH device handling routines
      libata: implement HORKAGE_1_5_GBPS and apply it to WD My Book

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 77bba4c..a603bbf 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -61,9 +61,14 @@
 #define EM_MSG_LED_VALUE_ON           0x00010000
 
 static int ahci_skip_host_reset;
+static int ahci_ignore_sss;
+
 module_param_named(skip_host_reset, ahci_skip_host_reset, int, 0444);
 MODULE_PARM_DESC(skip_host_reset, "skip global host reset (0=don't skip, 1=skip)");
 
+module_param_named(ignore_sss, ahci_ignore_sss, int, 0444);
+MODULE_PARM_DESC(ignore_sss, "Ignore staggered spinup flag (0=don't ignore, 1=ignore)");
+
 static int ahci_enable_alpm(struct ata_port *ap,
 		enum link_pm policy);
 static void ahci_disable_alpm(struct ata_port *ap);
@@ -2692,8 +2697,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	host->iomap = pcim_iomap_table(pdev);
 	host->private_data = hpriv;
 
-	if (!(hpriv->cap & HOST_CAP_SSS))
+	if (!(hpriv->cap & HOST_CAP_SSS) || ahci_ignore_sss)
 		host->flags |= ATA_HOST_PARALLEL_SCAN;
+	else
+		printk(KERN_INFO "ahci: SSS flag set, parallel bus scan disabled\n");
 
 	if (pi.flags & ATA_FLAG_EM)
 		ahci_reset_em(host);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 88c2428..9fbf059 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -164,6 +164,11 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
 
+static bool ata_sstatus_online(u32 sstatus)
+{
+	return (sstatus & 0xf) == 0x3;
+}
+
 /**
  *	ata_link_next - link iteration helper
  *	@link: the previous link, NULL to start
@@ -1015,18 +1020,6 @@ static const char *sata_spd_string(unsigned int spd)
 	return spd_str[spd - 1];
 }
 
-void ata_dev_disable(struct ata_device *dev)
-{
-	if (ata_dev_enabled(dev)) {
-		if (ata_msg_drv(dev->link->ap))
-			ata_dev_printk(dev, KERN_WARNING, "disabled\n");
-		ata_acpi_on_disable(dev);
-		ata_down_xfermask_limit(dev, ATA_DNXFER_FORCE_PIO0 |
-					     ATA_DNXFER_QUIET);
-		dev->class++;
-	}
-}
-
 static int ata_dev_set_dipm(struct ata_device *dev, enum link_pm policy)
 {
 	struct ata_link *link = dev->link;
@@ -2239,6 +2232,40 @@ retry:
 	return rc;
 }
 
+static int ata_do_link_spd_horkage(struct ata_device *dev)
+{
+	struct ata_link *plink = ata_dev_phys_link(dev);
+	u32 target, target_limit;
+
+	if (!sata_scr_valid(plink))
+		return 0;
+
+	if (dev->horkage & ATA_HORKAGE_1_5_GBPS)
+		target = 1;
+	else
+		return 0;
+
+	target_limit = (1 << target) - 1;
+
+	/* if already on stricter limit, no need to push further */
+	if (plink->sata_spd_limit <= target_limit)
+		return 0;
+
+	plink->sata_spd_limit = target_limit;
+
+	/* Request another EH round by returning -EAGAIN if link is
+	 * going faster than the target speed.  Forward progress is
+	 * guaranteed by setting sata_spd_limit to target_limit above.
+	 */
+	if (plink->sata_spd > target) {
+		ata_dev_printk(dev, KERN_INFO,
+			       "applying link speed limit horkage to %s\n",
+			       sata_spd_string(target));
+		return -EAGAIN;
+	}
+	return 0;
+}
+
 static inline u8 ata_dev_knobble(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->link->ap;
@@ -2329,6 +2356,10 @@ int ata_dev_configure(struct ata_device *dev)
 		return 0;
 	}
 
+	rc = ata_do_link_spd_horkage(dev);
+	if (rc)
+		return rc;
+
 	/* let ACPI work its magic */
 	rc = ata_acpi_on_devcfg(dev);
 	if (rc)
@@ -2784,7 +2815,7 @@ int ata_bus_probe(struct ata_port *ap)
 			/* This is the last chance, better to slow
 			 * down than lose it.
 			 */
-			sata_down_spd_limit(&ap->link);
+			sata_down_spd_limit(&ap->link, 0);
 			ata_down_xfermask_limit(dev, ATA_DNXFER_PIO);
 		}
 	}
@@ -2880,21 +2911,27 @@ void ata_port_disable(struct ata_port *ap)
 /**
  *	sata_down_spd_limit - adjust SATA spd limit downward
  *	@link: Link to adjust SATA spd limit for
+ *	@spd_limit: Additional limit
  *
  *	Adjust SATA spd limit of @link downward.  Note that this
  *	function only adjusts the limit.  The change must be applied
  *	using sata_set_spd().
  *
+ *	If @spd_limit is non-zero, the speed is limited to equal to or
+ *	lower than @spd_limit if such speed is supported.  If
+ *	@spd_limit is slower than any supported speed, only the lowest
+ *	supported speed is allowed.
+ *
  *	LOCKING:
  *	Inherited from caller.
  *
  *	RETURNS:
  *	0 on success, negative errno on failure
  */
-int sata_down_spd_limit(struct ata_link *link)
+int sata_down_spd_limit(struct ata_link *link, u32 spd_limit)
 {
 	u32 sstatus, spd, mask;
-	int rc, highbit;
+	int rc, bit;
 
 	if (!sata_scr_valid(link))
 		return -EOPNOTSUPP;
@@ -2903,7 +2940,7 @@ int sata_down_spd_limit(struct ata_link *link)
 	 * If not, use cached value in link->sata_spd.
 	 */
 	rc = sata_scr_read(link, SCR_STATUS, &sstatus);
-	if (rc == 0)
+	if (rc == 0 && ata_sstatus_online(sstatus))
 		spd = (sstatus >> 4) & 0xf;
 	else
 		spd = link->sata_spd;
@@ -2913,8 +2950,8 @@ int sata_down_spd_limit(struct ata_link *link)
 		return -EINVAL;
 
 	/* unconditionally mask off the highest bit */
-	highbit = fls(mask) - 1;
-	mask &= ~(1 << highbit);
+	bit = fls(mask) - 1;
+	mask &= ~(1 << bit);
 
 	/* Mask off all speeds higher than or equal to the current
 	 * one.  Force 1.5Gbps if current SPD is not available.
@@ -2928,6 +2965,15 @@ int sata_down_spd_limit(struct ata_link *link)
 	if (!mask)
 		return -EINVAL;
 
+	if (spd_limit) {
+		if (mask & ((1 << spd_limit) - 1))
+			mask &= (1 << spd_limit) - 1;
+		else {
+			bit = ffs(mask) - 1;
+			mask = 1 << bit;
+		}
+	}
+
 	link->sata_spd_limit = mask;
 
 	ata_link_printk(link, KERN_WARNING, "limiting SATA link speed to %s\n",
@@ -4215,6 +4261,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* Devices that do not need bridging limits applied */
 	{ "MTRON MSP-SATA*",		NULL,	ATA_HORKAGE_BRIDGE_OK, },
 
+	/* Devices which aren't very happy with higher link speeds */
+	{ "WD My Book",			NULL,	ATA_HORKAGE_1_5_GBPS, },
+
 	/* End Marker */
 	{ }
 };
@@ -4709,8 +4758,7 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
 
 /**
  *	ata_qc_new - Request an available ATA command, for queueing
- *	@ap: Port associated with device @dev
- *	@dev: Device from whom we request an available command structure
+ *	@ap: target port
  *
  *	LOCKING:
  *	None.
@@ -5175,7 +5223,7 @@ bool ata_phys_link_online(struct ata_link *link)
 	u32 sstatus;
 
 	if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0 &&
-	    (sstatus & 0xf) == 0x3)
+	    ata_sstatus_online(sstatus))
 		return true;
 	return false;
 }
@@ -5199,7 +5247,7 @@ bool ata_phys_link_offline(struct ata_link *link)
 	u32 sstatus;
 
 	if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0 &&
-	    (sstatus & 0xf) != 0x3)
+	    !ata_sstatus_online(sstatus))
 		return true;
 	return false;
 }
@@ -5412,8 +5460,8 @@ void ata_dev_init(struct ata_device *dev)
 	dev->horkage = 0;
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	memset((void *)dev + ATA_DEVICE_CLEAR_OFFSET, 0,
-	       sizeof(*dev) - ATA_DEVICE_CLEAR_OFFSET);
+	memset((void *)dev + ATA_DEVICE_CLEAR_BEGIN, 0,
+	       ATA_DEVICE_CLEAR_END - ATA_DEVICE_CLEAR_BEGIN);
 	dev->pio_mask = UINT_MAX;
 	dev->mwdma_mask = UINT_MAX;
 	dev->udma_mask = UINT_MAX;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 8147a83..ce2ef04 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -82,6 +82,10 @@ enum {
 	ATA_EH_FASTDRAIN_INTERVAL	=  3000,
 
 	ATA_EH_UA_TRIES			= 5,
+
+	/* probe speed down parameters, see ata_eh_schedule_probe() */
+	ATA_EH_PROBE_TRIAL_INTERVAL	= 60000,	/* 1 min */
+	ATA_EH_PROBE_TRIALS		= 2,
 };
 
 /* The following table determines how we sequence resets.  Each entry
@@ -1176,6 +1180,32 @@ void ata_eh_qc_retry(struct ata_queued_cmd *qc)
 }
 
 /**
+ *	ata_dev_disable - disable ATA device
+ *	@dev: ATA device to disable
+ *
+ *	Disable @dev.
+ *
+ *	Locking:
+ *	EH context.
+ */
+void ata_dev_disable(struct ata_device *dev)
+{
+	if (!ata_dev_enabled(dev))
+		return;
+
+	if (ata_msg_drv(dev->link->ap))
+		ata_dev_printk(dev, KERN_WARNING, "disabled\n");
+	ata_acpi_on_disable(dev);
+	ata_down_xfermask_limit(dev, ATA_DNXFER_FORCE_PIO0 | ATA_DNXFER_QUIET);
+	dev->class++;
+
+	/* From now till the next successful probe, ering is used to
+	 * track probe failures.  Clear accumulated device error info.
+	 */
+	ata_ering_clear(&dev->ering);
+}
+
+/**
  *	ata_eh_detach_dev - detach ATA device
  *	@dev: ATA device to detach
  *
@@ -1849,7 +1879,7 @@ static unsigned int ata_eh_speed_down(struct ata_device *dev,
 	/* speed down? */
 	if (verdict & ATA_EH_SPDN_SPEED_DOWN) {
 		/* speed down SATA link speed if possible */
-		if (sata_down_spd_limit(link) == 0) {
+		if (sata_down_spd_limit(link, 0) == 0) {
 			action |= ATA_EH_RESET;
 			goto done;
 		}
@@ -2601,11 +2631,11 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	}
 
 	if (try == max_tries - 1) {
-		sata_down_spd_limit(link);
+		sata_down_spd_limit(link, 0);
 		if (slave)
-			sata_down_spd_limit(slave);
+			sata_down_spd_limit(slave, 0);
 	} else if (rc == -EPIPE)
-		sata_down_spd_limit(failed_link);
+		sata_down_spd_limit(failed_link, 0);
 
 	if (hardreset)
 		reset = hardreset;
@@ -2744,6 +2774,8 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 						     readid_flags, dev->id);
 			switch (rc) {
 			case 0:
+				/* clear error info accumulated during probe */
+				ata_ering_clear(&dev->ering);
 				new_mask |= 1 << dev->devno;
 				break;
 			case -ENOENT:
@@ -2947,9 +2979,24 @@ static int ata_eh_skip_recovery(struct ata_link *link)
 	return 1;
 }
 
+static int ata_count_probe_trials_cb(struct ata_ering_entry *ent, void *void_arg)
+{
+	u64 interval = msecs_to_jiffies(ATA_EH_PROBE_TRIAL_INTERVAL);
+	u64 now = get_jiffies_64();
+	int *trials = void_arg;
+
+	if (ent->timestamp < now - min(now, interval))
+		return -1;
+
+	(*trials)++;
+	return 0;
+}
+
 static int ata_eh_schedule_probe(struct ata_device *dev)
 {
 	struct ata_eh_context *ehc = &dev->link->eh_context;
+	struct ata_link *link = ata_dev_phys_link(dev);
+	int trials = 0;
 
 	if (!(ehc->i.probe_mask & (1 << dev->devno)) ||
 	    (ehc->did_probe_mask & (1 << dev->devno)))
@@ -2962,6 +3009,25 @@ static int ata_eh_schedule_probe(struct ata_device *dev)
 	ehc->saved_xfer_mode[dev->devno] = 0;
 	ehc->saved_ncq_enabled &= ~(1 << dev->devno);
 
+	/* Record and count probe trials on the ering.  The specific
+	 * error mask used is irrelevant.  Because a successful device
+	 * detection clears the ering, this count accumulates only if
+	 * there are consecutive failed probes.
+	 *
+	 * If the count is equal to or higher than ATA_EH_PROBE_TRIALS
+	 * in the last ATA_EH_PROBE_TRIAL_INTERVAL, link speed is
+	 * forced to 1.5Gbps.
+	 *
+	 * This is to work around cases where failed link speed
+	 * negotiation results in device misdetection leading to
+	 * infinite DEVXCHG or PHRDY CHG events.
+	 */
+	ata_ering_record(&dev->ering, 0, AC_ERR_OTHER);
+	ata_ering_map(&dev->ering, ata_count_probe_trials_cb, &trials);
+
+	if (trials > ATA_EH_PROBE_TRIALS)
+		sata_down_spd_limit(link, 1);
+
 	return 1;
 }
 
@@ -2969,7 +3035,11 @@ static int ata_eh_handle_dev_fail(struct ata_device *dev, int err)
 {
 	struct ata_eh_context *ehc = &dev->link->eh_context;
 
-	ehc->tries[dev->devno]--;
+	/* -EAGAIN from EH routine indicates retry without prejudice.
+	 * The requester is responsible for ensuring forward progress.
+	 */
+	if (err != -EAGAIN)
+		ehc->tries[dev->devno]--;
 
 	switch (err) {
 	case -ENODEV:
@@ -2979,12 +3049,13 @@ static int ata_eh_handle_dev_fail(struct ata_device *dev, int err)
 		/* give it just one more chance */
 		ehc->tries[dev->devno] = min(ehc->tries[dev->devno], 1);
 	case -EIO:
-		if (ehc->tries[dev->devno] == 1 && dev->pio_mode > XFER_PIO_0) {
+		if (ehc->tries[dev->devno] == 1) {
 			/* This is the last chance, better to slow
 			 * down than lose it.
 			 */
-			sata_down_spd_limit(ata_dev_phys_link(dev));
-			ata_down_xfermask_limit(dev, ATA_DNXFER_PIO);
+			sata_down_spd_limit(ata_dev_phys_link(dev), 0);
+			if (dev->pio_mode > XFER_PIO_0)
+				ata_down_xfermask_limit(dev, ATA_DNXFER_PIO);
 		}
 	}
 
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 98ca07a..619f2c3 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -729,7 +729,7 @@ static int sata_pmp_eh_recover_pmp(struct ata_port *ap,
 		if (tries) {
 			/* consecutive revalidation failures? speed down */
 			if (reval_failed)
-				sata_down_spd_limit(link);
+				sata_down_spd_limit(link, 0);
 			else
 				reval_failed = 1;
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3c4c5ae..b9747fa 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -415,6 +415,7 @@ int ata_std_bios_param(struct scsi_device *sdev, struct block_device *bdev,
 
 /**
  *	ata_get_identity - Handler for HDIO_GET_IDENTITY ioctl
+ *	@ap: target port
  *	@sdev: SCSI device to get identify data for
  *	@arg: User buffer area for identify data
  *
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index fe2839e..cea8014 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -79,7 +79,6 @@ extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 			   u64 block, u32 n_block, unsigned int tf_flags,
 			   unsigned int tag);
 extern u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev);
-extern void ata_dev_disable(struct ata_device *dev);
 extern void ata_pio_queue_task(struct ata_port *ap, void *data,
 			       unsigned long delay);
 extern void ata_port_flush_task(struct ata_port *ap);
@@ -100,7 +99,7 @@ extern int ata_dev_reread_id(struct ata_device *dev, unsigned int readid_flags);
 extern int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 			      unsigned int readid_flags);
 extern int ata_dev_configure(struct ata_device *dev);
-extern int sata_down_spd_limit(struct ata_link *link);
+extern int sata_down_spd_limit(struct ata_link *link, u32 spd_limit);
 extern int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel);
 extern void ata_sg_clean(struct ata_queued_cmd *qc);
 extern void ata_qc_free(struct ata_queued_cmd *qc);
@@ -160,6 +159,7 @@ extern void ata_scsi_error(struct Scsi_Host *host);
 extern void ata_port_wait_eh(struct ata_port *ap);
 extern void ata_eh_fastdrain_timerfn(unsigned long arg);
 extern void ata_qc_schedule_eh(struct ata_queued_cmd *qc);
+extern void ata_dev_disable(struct ata_device *dev);
 extern void ata_eh_detach_dev(struct ata_device *dev);
 extern void ata_eh_about_to_do(struct ata_link *link, struct ata_device *dev,
 			       unsigned int action);
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index f2d8a02..4ae1a41 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -663,8 +663,8 @@ static const struct pci_device_id mv_pci_tbl[] = {
 	{ PCI_VDEVICE(MARVELL, 0x5081), chip_508x },
 	/* RocketRAID 1720/174x have different identifiers */
 	{ PCI_VDEVICE(TTI, 0x1720), chip_6042 },
-	{ PCI_VDEVICE(TTI, 0x1740), chip_508x },
-	{ PCI_VDEVICE(TTI, 0x1742), chip_508x },
+	{ PCI_VDEVICE(TTI, 0x1740), chip_6042 },
+	{ PCI_VDEVICE(TTI, 0x1742), chip_6042 },
 
 	{ PCI_VDEVICE(MARVELL, 0x6040), chip_604x },
 	{ PCI_VDEVICE(MARVELL, 0x6041), chip_604x },
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index c49ad0e..444af04 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -436,11 +436,16 @@ static struct ata_port_operations nv_nf2_ops = {
 	.hardreset		= nv_noclassify_hardreset,
 };
 
-/* CK804 finally gets hardreset right */
+/* For initial probing after boot and hot plugging, hardreset mostly
+ * works fine on CK804 but curiously, reprobing on the initial port by
+ * rescanning or rmmod/insmod fails to acquire the initial D2H Reg FIS
+ * in somewhat undeterministic way.  Use noclassify hardreset.
+ */
 static struct ata_port_operations nv_ck804_ops = {
 	.inherits		= &nv_common_ops,
 	.freeze			= nv_ck804_freeze,
 	.thaw			= nv_ck804_thaw,
+	.hardreset		= nv_noclassify_hardreset,
 	.host_stop		= nv_ck804_host_stop,
 };
 
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 9f02959..d009160 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -324,7 +324,7 @@ static void sil_fill_sg(struct ata_queued_cmd *qc)
 
 		prd->addr = cpu_to_le32(addr);
 		prd->flags_len = cpu_to_le32(sg_len);
-		VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, sg_len);
+		VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", si, addr, sg_len);
 
 		last_prd = prd;
 		prd++;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index a53318b..08a86d5 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -731,12 +731,17 @@ static inline int ata_id_current_chs_valid(const u16 *id)
 
 static inline int ata_id_is_cfa(const u16 *id)
 {
-	if (id[ATA_ID_CONFIG] == 0x848A)	/* Standard CF */
+	if (id[ATA_ID_CONFIG] == 0x848A)	/* Traditional CF */
 		return 1;
-	/* Could be CF hiding as standard ATA */
-	if (ata_id_major_version(id) >= 3 &&
-	    id[ATA_ID_COMMAND_SET_1] != 0xFFFF &&
-	   (id[ATA_ID_COMMAND_SET_1] & (1 << 2)))
+	/*
+	 * CF specs don't require specific value in the word 0 anymore and yet
+	 * they forbid to report the ATA version in the word 80 and require the
+	 * CFA feature set support to be indicated in the word 83 in this case.
+	 * Unfortunately, some cards only follow either of this requirements,
+	 * and while those that don't indicate CFA feature support need some
+	 * sort of quirk list, it seems impractical for the ones that do...
+	 */
+	if ((id[ATA_ID_COMMAND_SET_2] & 0xC004) == 0x4004)
 		return 1;
 	return 0;
 }
diff --git a/include/linux/libata.h b/include/linux/libata.h
index bca3ba2..5d87bc0 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -380,6 +380,7 @@ enum {
 	ATA_HORKAGE_ATAPI_MOD16_DMA = (1 << 11), /* use ATAPI DMA for commands
 						    not multiple of 16 bytes */
 	ATA_HORKAGE_FIRMWARE_WARN = (1 << 12),	/* firwmare update warning */
+	ATA_HORKAGE_1_5_GBPS	= (1 << 13),	/* force 1.5 Gbps */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
@@ -580,7 +581,7 @@ struct ata_device {
 	acpi_handle		acpi_handle;
 	union acpi_object	*gtf_cache;
 #endif
-	/* n_sector is used as CLEAR_OFFSET, read comment above CLEAR_OFFSET */
+	/* n_sector is CLEAR_BEGIN, read comment above CLEAR_BEGIN */
 	u64			n_sectors;	/* size of device, if ATA */
 	unsigned int		class;		/* ATA_DEV_xxx */
 	unsigned long		unpark_deadline;
@@ -605,20 +606,22 @@ struct ata_device {
 	u16			heads;		/* Number of heads */
 	u16			sectors;	/* Number of sectors per track */
 
-	/* error history */
-	int			spdn_cnt;
-	struct ata_ering	ering;
-
 	union {
 		u16		id[ATA_ID_WORDS]; /* IDENTIFY xxx DEVICE data */
 		u32		gscr[SATA_PMP_GSCR_DWORDS]; /* PMP GSCR block */
 	};
+
+	/* error history */
+	int			spdn_cnt;
+	/* ering is CLEAR_END, read comment above CLEAR_END */
+	struct ata_ering	ering;
 };
 
-/* Offset into struct ata_device.  Fields above it are maintained
- * acress device init.  Fields below are zeroed.
+/* Fields between ATA_DEVICE_CLEAR_BEGIN and ATA_DEVICE_CLEAR_END are
+ * cleared to zero on ata_dev_init().
  */
-#define ATA_DEVICE_CLEAR_OFFSET		offsetof(struct ata_device, n_sectors)
+#define ATA_DEVICE_CLEAR_BEGIN		offsetof(struct ata_device, n_sectors)
+#define ATA_DEVICE_CLEAR_END		offsetof(struct ata_device, ering)
 
 struct ata_eh_info {
 	struct ata_device	*dev;		/* offending device */
