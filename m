Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbXKCSOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbXKCSOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 14:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbXKCSN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 14:13:56 -0400
Received: from havoc.gtf.org ([69.61.125.42]:35735 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbXKCSNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 14:13:54 -0400
Date: Sat, 3 Nov 2007 14:13:52 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20071103181352.GA31937@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes, fixes and more fixes.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c  |   38 ++++++++---
 drivers/ata/libata-eh.c    |  148 ++++++++++++++++++++++------------------
 drivers/ata/libata-scsi.c  |    2 +-
 drivers/ata/sata_fsl.c     |  159 +++++++++-----------------------------------
 drivers/ata/sata_promise.c |    2 +-
 include/linux/ata.h        |    6 ++
 6 files changed, 149 insertions(+), 206 deletions(-)

Adrian Bunk (1):
      make ata_scsi_lpm_get() static

Jeff Garzik (4):
      ata/sata_fsl: Remove unnecessary SCR cases
      ata/sata_fsl: cleanup needless casts to/from void __iomem *
      ata/sata_fsl: remove unneeded on-stack copy of FIS
      ata/sata_fsl: remove unneeded sata_fsl_hardreset()

Li Yang (5):
      ata/sata_fsl: Update for ata_link introduction
      ata/sata_fsl: Remove deprecated hooks
      ata/sata_fsl: save irq in private data for irq unmapping
      ata/sata_fsl: Kill ata_sg_is_last()
      ata/sata_fsl: cleanup style problem

Mikael Pettersson (1):
      sata_promise: fix endianess bug in ASIC PRD bug workaround

Stephen Hemminger (1):
      libata: fix docbook

Stephen Rothwell (1):
      libata: suppress two warnings

Tejun Heo (6):
      libata: fix timing computation in ata_eh_reset()
      libata: cosmetic clean up / reorganization of ata_eh_reset()
      libata: more robust reset failure handling
      libata: consider errors not associated with commands for speed down
      libata: request PHY speed configuration on SControl access failure
      libata: don't configure downstream links faster than the upstream link

Tony Battersby (1):
      libata: increase 128 KB / cmd limit for ATAPI tape drives

ashish kalra (3):
      ata/sata_fsl: Move MPC8315DS link speed limit workaround to specific ifdef
      ata/sata_fsl: Remove sending LOG EXT command in sata_fsl_softreset()
      ata/sata_fsl: Remove ata_scsi_suspend/resume callbacks

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 63035d7..164c7d9 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -704,8 +704,8 @@ static int ata_dev_set_dipm(struct ata_device *dev, enum link_pm policy)
 
 /**
  *	ata_dev_enable_pm - enable SATA interface power management
- *	@device - device to enable ipm for
- *	@policy - the link power management policy
+ *	@dev:  device to enable power management
+ *	@policy: the link power management policy
  *
  *	Enable SATA Interface power management.  This will enable
  *	Device Interface Power Management (DIPM) for min_power
@@ -735,9 +735,10 @@ enable_pm_out:
 	return /* rc */;	/* hopefully we can use 'rc' eventually */
 }
 
+#ifdef CONFIG_PM
 /**
  *	ata_dev_disable_pm - disable SATA interface power management
- *	@device - device to enable ipm for
+ *	@dev: device to disable power management
  *
  *	Disable SATA Interface power management.  This will disable
  *	Device Interface Power Management (DIPM) without changing
@@ -755,6 +756,7 @@ static void ata_dev_disable_pm(struct ata_device *dev)
 	if (ap->ops->disable_pm)
 		ap->ops->disable_pm(ap);
 }
+#endif	/* CONFIG_PM */
 
 void ata_lpm_schedule(struct ata_port *ap, enum link_pm policy)
 {
@@ -764,6 +766,7 @@ void ata_lpm_schedule(struct ata_port *ap, enum link_pm policy)
 	ata_port_schedule_eh(ap);
 }
 
+#ifdef CONFIG_PM
 static void ata_lpm_enable(struct ata_host *host)
 {
 	struct ata_link *link;
@@ -789,6 +792,7 @@ static void ata_lpm_disable(struct ata_host *host)
 		ata_lpm_schedule(ap, ap->pm_policy);
 	}
 }
+#endif	/* CONFIG_PM */
 
 
 /**
@@ -2300,6 +2304,10 @@ int ata_dev_configure(struct ata_device *dev)
 		dev->max_sectors = ATA_MAX_SECTORS;
 	}
 
+	if ((dev->class == ATA_DEV_ATAPI) &&
+	    (atapi_command_packet_set(id) == TYPE_TAPE))
+		dev->max_sectors = ATA_MAX_SECTORS_TAPE;
+
 	if (dev->horkage & ATA_HORKAGE_MAX_SEC_128)
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
@@ -2743,17 +2751,27 @@ int sata_down_spd_limit(struct ata_link *link)
 
 static int __sata_set_spd_needed(struct ata_link *link, u32 *scontrol)
 {
-	u32 spd, limit;
+	struct ata_link *host_link = &link->ap->link;
+	u32 limit, target, spd;
+
+	limit = link->sata_spd_limit;
 
-	if (link->sata_spd_limit == UINT_MAX)
-		limit = 0;
+	/* Don't configure downstream link faster than upstream link.
+	 * It doesn't speed up anything and some PMPs choke on such
+	 * configuration.
+	 */
+	if (!ata_is_host_link(link) && host_link->sata_spd)
+		limit &= (1 << host_link->sata_spd) - 1;
+
+	if (limit == UINT_MAX)
+		target = 0;
 	else
-		limit = fls(link->sata_spd_limit);
+		target = fls(limit);
 
 	spd = (*scontrol >> 4) & 0xf;
-	*scontrol = (*scontrol & ~0xf0) | ((limit & 0xf) << 4);
+	*scontrol = (*scontrol & ~0xf0) | ((target & 0xf) << 4);
 
-	return spd != limit;
+	return spd != target;
 }
 
 /**
@@ -2776,7 +2794,7 @@ int sata_set_spd_needed(struct ata_link *link)
 	u32 scontrol;
 
 	if (sata_scr_read(link, SCR_CONTROL, &scontrol))
-		return 0;
+		return 1;
 
 	return __sata_set_spd_needed(link, &scontrol);
 }
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 8d64f8f..ed8813b 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1747,6 +1747,7 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 {
 	struct ata_port *ap = link->ap;
 	struct ata_eh_context *ehc = &link->eh_context;
+	struct ata_device *dev;
 	unsigned int all_err_mask = 0;
 	int tag, is_io = 0;
 	u32 serror;
@@ -1818,18 +1819,24 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 		 (!is_io && (all_err_mask & ~AC_ERR_DEV)))
 		ehc->i.action |= ATA_EH_REVALIDATE;
 
-	/* if we have offending qcs and the associated failed device */
+	/* If we have offending qcs and the associated failed device,
+	 * perform per-dev EH action only on the offending device.
+	 */
 	if (ehc->i.dev) {
-		/* speed down */
-		ehc->i.action |= ata_eh_speed_down(ehc->i.dev, is_io,
-						   all_err_mask);
-
-		/* perform per-dev EH action only on the offending device */
 		ehc->i.dev_action[ehc->i.dev->devno] |=
 			ehc->i.action & ATA_EH_PERDEV_MASK;
 		ehc->i.action &= ~ATA_EH_PERDEV_MASK;
 	}
 
+	/* consider speeding down */
+	dev = ehc->i.dev;
+	if (!dev && ata_link_max_devices(link) == 1 &&
+	    ata_dev_enabled(link->device))
+		dev = link->device;
+
+	if (dev)
+		ehc->i.action |= ata_eh_speed_down(dev, is_io, all_err_mask);
+
 	DPRINTK("EXIT\n");
 }
 
@@ -2065,16 +2072,19 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		 ata_prereset_fn_t prereset, ata_reset_fn_t softreset,
 		 ata_reset_fn_t hardreset, ata_postreset_fn_t postreset)
 {
+	const int max_tries = ARRAY_SIZE(ata_eh_reset_timeouts);
 	struct ata_port *ap = link->ap;
 	struct ata_eh_context *ehc = &link->eh_context;
 	unsigned int *classes = ehc->classes;
+	unsigned int lflags = link->flags;
 	int verbose = !(ehc->i.flags & ATA_EHI_QUIET);
 	int try = 0;
 	struct ata_device *dev;
-	unsigned long deadline;
+	unsigned long deadline, now;
 	unsigned int tmp_action;
 	ata_reset_fn_t reset;
 	unsigned long flags;
+	u32 sstatus;
 	int rc;
 
 	/* about to reset */
@@ -2106,7 +2116,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	/* Determine which reset to use and record in ehc->i.action.
 	 * prereset() may examine and modify it.
 	 */
-	if (softreset && (!hardreset || (!(link->flags & ATA_LFLAG_NO_SRST) &&
+	if (softreset && (!hardreset || (!(lflags & ATA_LFLAG_NO_SRST) &&
 					 !sata_set_spd_needed(link) &&
 					 !(ehc->i.action & ATA_EH_HARDRESET))))
 		tmp_action = ATA_EH_SOFTRESET;
@@ -2181,82 +2191,64 @@ int ata_eh_reset(struct ata_link *link, int classify,
 					"follow-up softreset required "
 					"but no softreset avaliable\n");
 			rc = -EINVAL;
-			goto out;
+			goto fail;
 		}
 
 		ata_eh_about_to_do(link, NULL, ATA_EH_RESET_MASK);
 		rc = ata_do_reset(link, reset, classes, deadline);
-
-		if (rc == 0 && classify && classes[0] == ATA_DEV_UNKNOWN &&
-		    !(link->flags & ATA_LFLAG_ASSUME_CLASS)) {
-			ata_link_printk(link, KERN_ERR,
-					"classification failed\n");
-			rc = -EINVAL;
-			goto out;
-		}
 	}
 
-	/* if we skipped follow-up srst, clear rc */
-	if (rc == -EAGAIN)
-		rc = 0;
-
-	if (rc && rc != -ERESTART && try < ARRAY_SIZE(ata_eh_reset_timeouts)) {
-		unsigned long now = jiffies;
-
-		if (time_before(now, deadline)) {
-			unsigned long delta = deadline - jiffies;
-
-			ata_link_printk(link, KERN_WARNING, "reset failed "
-				"(errno=%d), retrying in %u secs\n",
-				rc, (jiffies_to_msecs(delta) + 999) / 1000);
+	/* -EAGAIN can happen if we skipped followup SRST */
+	if (rc && rc != -EAGAIN)
+		goto fail;
 
-			while (delta)
-				delta = schedule_timeout_uninterruptible(delta);
+	/* was classification successful? */
+	if (classify && classes[0] == ATA_DEV_UNKNOWN &&
+	    !(lflags & ATA_LFLAG_ASSUME_CLASS)) {
+		if (try < max_tries) {
+			ata_link_printk(link, KERN_WARNING,
+					"classification failed\n");
+			rc = -EINVAL;
+			goto fail;
 		}
 
-		if (rc == -EPIPE ||
-		    try == ARRAY_SIZE(ata_eh_reset_timeouts) - 1)
-			sata_down_spd_limit(link);
-		if (hardreset)
-			reset = hardreset;
-		goto retry;
+		ata_link_printk(link, KERN_WARNING,
+				"classfication failed, assuming ATA\n");
+		lflags |= ATA_LFLAG_ASSUME_ATA;
 	}
 
-	if (rc == 0) {
-		u32 sstatus;
+	ata_link_for_each_dev(dev, link) {
+		/* After the reset, the device state is PIO 0 and the
+		 * controller state is undefined.  Reset also wakes up
+		 * drives from sleeping mode.
+		 */
+		dev->pio_mode = XFER_PIO_0;
+		dev->flags &= ~ATA_DFLAG_SLEEPING;
 
-		ata_link_for_each_dev(dev, link) {
-			/* After the reset, the device state is PIO 0
-			 * and the controller state is undefined.
-			 * Reset also wakes up drives from sleeping
-			 * mode.
-			 */
-			dev->pio_mode = XFER_PIO_0;
-			dev->flags &= ~ATA_DFLAG_SLEEPING;
+		if (ata_link_offline(link))
+			continue;
 
-			if (ata_link_offline(link))
-				continue;
+		/* apply class override and convert UNKNOWN to NONE */
+		if (lflags & ATA_LFLAG_ASSUME_ATA)
+			classes[dev->devno] = ATA_DEV_ATA;
+		else if (lflags & ATA_LFLAG_ASSUME_SEMB)
+			classes[dev->devno] = ATA_DEV_SEMB_UNSUP; /* not yet */
+		else if (classes[dev->devno] == ATA_DEV_UNKNOWN)
+			classes[dev->devno] = ATA_DEV_NONE;
+	}
 
-			/* apply class override and convert UNKNOWN to NONE */
-			if (link->flags & ATA_LFLAG_ASSUME_ATA)
-				classes[dev->devno] = ATA_DEV_ATA;
-			else if (link->flags & ATA_LFLAG_ASSUME_SEMB)
-				classes[dev->devno] = ATA_DEV_SEMB_UNSUP; /* not yet */
-			else if (classes[dev->devno] == ATA_DEV_UNKNOWN)
-				classes[dev->devno] = ATA_DEV_NONE;
-		}
+	/* record current link speed */
+	if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0)
+		link->sata_spd = (sstatus >> 4) & 0xf;
 
-		/* record current link speed */
-		if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0)
-			link->sata_spd = (sstatus >> 4) & 0xf;
+	if (postreset)
+		postreset(link, classes);
 
-		if (postreset)
-			postreset(link, classes);
+	/* reset successful, schedule revalidation */
+	ata_eh_done(link, NULL, ehc->i.action & ATA_EH_RESET_MASK);
+	ehc->i.action |= ATA_EH_REVALIDATE;
 
-		/* reset successful, schedule revalidation */
-		ata_eh_done(link, NULL, ehc->i.action & ATA_EH_RESET_MASK);
-		ehc->i.action |= ATA_EH_REVALIDATE;
-	}
+	rc = 0;
  out:
 	/* clear hotplug flag */
 	ehc->i.flags &= ~ATA_EHI_HOTPLUGGED;
@@ -2266,6 +2258,28 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	return rc;
+
+ fail:
+	if (rc == -ERESTART || try >= max_tries)
+		goto out;
+
+	now = jiffies;
+	if (time_before(now, deadline)) {
+		unsigned long delta = deadline - now;
+
+		ata_link_printk(link, KERN_WARNING, "reset failed "
+				"(errno=%d), retrying in %u secs\n",
+				rc, (jiffies_to_msecs(delta) + 999) / 1000);
+
+		while (delta)
+			delta = schedule_timeout_uninterruptible(delta);
+	}
+
+	if (rc == -EPIPE || try == max_tries - 1)
+		sata_down_spd_limit(link);
+	if (hardreset)
+		reset = hardreset;
+	goto retry;
 }
 
 static int ata_eh_revalidate_and_attach(struct ata_link *link,
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index fc89590..245057d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -120,7 +120,7 @@ static const struct {
 	{ MEDIUM_POWER, "medium_power" },
 };
 
-const char *ata_scsi_lpm_get(enum link_pm policy)
+static const char *ata_scsi_lpm_get(enum link_pm policy)
 {
 	int i;
 
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index b4c37b9..d015b4a 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -34,7 +34,8 @@ enum {
 
 	SATA_FSL_HOST_FLAGS	= (ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
-				ATA_FLAG_NCQ  | ATA_FLAG_SKIP_D2H_BSY),
+				ATA_FLAG_NCQ),
+	SATA_FSL_HOST_LFLAGS	= ATA_LFLAG_SKIP_D2H_BSY,
 
 	SATA_FSL_MAX_CMDS	= SATA_FSL_QUEUE_DEPTH,
 	SATA_FSL_CMD_HDR_SIZE	= 16,	/* 4 DWORDS */
@@ -264,10 +265,11 @@ struct sata_fsl_host_priv {
 	void __iomem *hcr_base;
 	void __iomem *ssr_base;
 	void __iomem *csr_base;
+	int irq;
 };
 
 static inline unsigned int sata_fsl_tag(unsigned int tag,
-					void __iomem * hcr_base)
+					void __iomem *hcr_base)
 {
 	/* We let libATA core do actual (queue) tag allocation */
 
@@ -306,7 +308,7 @@ static void sata_fsl_setup_cmd_hdr_entry(struct sata_fsl_port_priv *pp,
 	pp->cmdslot[tag].prde_fis_len =
 	    cpu_to_le32((num_prde << 16) | (fis_len << 2));
 	pp->cmdslot[tag].ttl = cpu_to_le32(data_xfer_len & ~0x03);
-	pp->cmdslot[tag].desc_info = cpu_to_le32((desc_info | (tag & 0x1F)));
+	pp->cmdslot[tag].desc_info = cpu_to_le32(desc_info | (tag & 0x1F));
 
 	VPRINTK("cda=0x%x, prde_fis_len=0x%x, ttl=0x%x, di=0x%x\n",
 		pp->cmdslot[tag].cda,
@@ -316,7 +318,7 @@ static void sata_fsl_setup_cmd_hdr_entry(struct sata_fsl_port_priv *pp,
 }
 
 static unsigned int sata_fsl_fill_sg(struct ata_queued_cmd *qc, void *cmd_desc,
-				     u32 * ttl, dma_addr_t cmd_desc_paddr)
+				     u32 *ttl, dma_addr_t cmd_desc_paddr)
 {
 	struct scatterlist *sg;
 	unsigned int num_prde = 0;
@@ -353,7 +355,7 @@ static unsigned int sata_fsl_fill_sg(struct ata_queued_cmd *qc, void *cmd_desc,
 					"s/g len unaligned : 0x%x\n", sg_len);
 
 		if ((num_prde == (SATA_FSL_MAX_PRD_DIRECT - 1)) &&
-		    !ata_sg_is_last(sg, qc)) {
+		    (qc->n_iter + 1 != qc->n_elem)) {
 			VPRINTK("setting indirect prde\n");
 			prd_ptr_to_indirect_ext = prd;
 			prd->dba = cpu_to_le32(indirect_ext_segment_paddr);
@@ -404,7 +406,7 @@ static void sata_fsl_qc_prep(struct ata_queued_cmd *qc)
 	cd = (struct command_desc *)pp->cmdentry + tag;
 	cd_paddr = pp->cmdentry_paddr + tag * SATA_FSL_CMD_DESC_SIZE;
 
-	ata_tf_to_fis(&qc->tf, 0, 1, (u8 *) & cd->cfis);
+	ata_tf_to_fis(&qc->tf, 0, 1, (u8 *) &cd->cfis);
 
 	VPRINTK("Dumping cfis : 0x%x, 0x%x, 0x%x\n",
 		cd->cfis[0], cd->cfis[1], cd->cfis[2]);
@@ -470,16 +472,10 @@ static int sata_fsl_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
 
 	switch (sc_reg_in) {
 	case SCR_STATUS:
-		sc_reg = 0;
-		break;
 	case SCR_ERROR:
-		sc_reg = 1;
-		break;
 	case SCR_CONTROL:
-		sc_reg = 2;
-		break;
 	case SCR_ACTIVE:
-		sc_reg = 3;
+		sc_reg = sc_reg_in;
 		break;
 	default:
 		return -EINVAL;
@@ -487,7 +483,7 @@ static int sata_fsl_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
 
 	VPRINTK("xx_scr_write, reg_in = %d\n", sc_reg);
 
-	iowrite32(val, (void __iomem *)ssr_base + (sc_reg * 4));
+	iowrite32(val, ssr_base + (sc_reg * 4));
 	return 0;
 }
 
@@ -500,16 +496,10 @@ static int sata_fsl_scr_read(struct ata_port *ap, unsigned int sc_reg_in,
 
 	switch (sc_reg_in) {
 	case SCR_STATUS:
-		sc_reg = 0;
-		break;
 	case SCR_ERROR:
-		sc_reg = 1;
-		break;
 	case SCR_CONTROL:
-		sc_reg = 2;
-		break;
 	case SCR_ACTIVE:
-		sc_reg = 3;
+		sc_reg = sc_reg_in;
 		break;
 	default:
 		return -EINVAL;
@@ -517,7 +507,7 @@ static int sata_fsl_scr_read(struct ata_port *ap, unsigned int sc_reg_in,
 
 	VPRINTK("xx_scr_read, reg_in = %d\n", sc_reg);
 
-	*val = ioread32((void __iomem *)ssr_base + (sc_reg * 4));
+	*val = ioread32(ssr_base + (sc_reg * 4));
 	return 0;
 }
 
@@ -571,7 +561,6 @@ static inline void sata_fsl_cache_taskfile_from_d2h_fis(struct ata_queued_cmd
 							struct ata_port *ap)
 {
 	struct sata_fsl_port_priv *pp = ap->private_data;
-	u8 fis[6 * 4];
 	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
 	void __iomem *hcr_base = host_priv->hcr_base;
 	unsigned int tag = sata_fsl_tag(qc->tag, hcr_base);
@@ -579,8 +568,7 @@ static inline void sata_fsl_cache_taskfile_from_d2h_fis(struct ata_queued_cmd
 
 	cd = pp->cmdentry + tag;
 
-	memcpy(fis, &cd->sfis, 6 * 4);	/* should we use memcpy_from_io() */
-	ata_tf_from_fis(fis, &pp->tf);
+	ata_tf_from_fis(cd->sfis, &pp->tf);
 }
 
 static u8 sata_fsl_check_status(struct ata_port *ap)
@@ -664,6 +652,7 @@ static int sata_fsl_port_start(struct ata_port *ap)
 	VPRINTK("HControl = 0x%x\n", ioread32(hcr_base + HCONTROL));
 	VPRINTK("CHBA  = 0x%x\n", ioread32(hcr_base + CHBA));
 
+#ifdef CONFIG_MPC8315_DS
 	/*
 	 * Workaround for 8315DS board 3gbps link-up issue,
 	 * currently limit SATA port to GEN1 speed
@@ -676,6 +665,7 @@ static int sata_fsl_port_start(struct ata_port *ap)
 	sata_fsl_scr_read(ap, SCR_CONTROL, &temp);
 	dev_printk(KERN_WARNING, dev, "scr_control, speed limited to %x\n",
 			temp);
+#endif
 
 	return 0;
 }
@@ -728,9 +718,10 @@ static unsigned int sata_fsl_dev_classify(struct ata_port *ap)
 	return ata_dev_classify(&tf);
 }
 
-static int sata_fsl_softreset(struct ata_port *ap, unsigned int *class,
+static int sata_fsl_softreset(struct ata_link *link, unsigned int *class,
 			      unsigned long deadline)
 {
+	struct ata_port *ap = link->ap;
 	struct sata_fsl_port_priv *pp = ap->private_data;
 	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
 	void __iomem *hcr_base = host_priv->hcr_base;
@@ -739,10 +730,6 @@ static int sata_fsl_softreset(struct ata_port *ap, unsigned int *class,
 	u8 *cfis;
 	u32 Serror;
 	int i = 0;
-	struct ata_queued_cmd qc;
-	u8 *buf;
-	dma_addr_t dma_address;
-	struct scatterlist *sg;
 	unsigned long start_jiffies;
 
 	DPRINTK("in xx_softreset\n");
@@ -811,7 +798,7 @@ try_offline_again:
 	 */
 
 	temp = ata_wait_register(hcr_base + HSTATUS, 0xFF, 0, 1, 500);
-	if ((!(temp & 0x10)) || ata_port_offline(ap)) {
+	if ((!(temp & 0x10)) || ata_link_offline(link)) {
 		ata_port_printk(ap, KERN_WARNING,
 				"No Device OR PHYRDY change,Hstatus = 0x%x\n",
 				ioread32(hcr_base + HSTATUS));
@@ -842,13 +829,10 @@ try_offline_again:
 	 * reached here, we can send a command to the target device
 	 */
 
-	if (ap->sactive)
-		goto skip_srst_do_ncq_error_handling;
-
 	DPRINTK("Sending SRST/device reset\n");
 
-	ata_tf_init(ap->device, &tf);
-	cfis = (u8 *) & pp->cmdentry->cfis;
+	ata_tf_init(link->device, &tf);
+	cfis = (u8 *) &pp->cmdentry->cfis;
 
 	/* device reset/SRST is a control register update FIS, uses tag0 */
 	sata_fsl_setup_cmd_hdr_entry(pp, 0,
@@ -912,76 +896,13 @@ try_offline_again:
 	 * command bit of the CCreg
 	 */
 	iowrite32(0x01, CC + hcr_base);	/* We know it will be cmd#0 always */
-	goto check_device_signature;
-
-skip_srst_do_ncq_error_handling:
-
-	VPRINTK("Sending read log ext(10h) command\n");
-
-	memset(&qc, 0, sizeof(struct ata_queued_cmd));
-	ata_tf_init(ap->device, &tf);
-
-	tf.command = ATA_CMD_READ_LOG_EXT;
-	tf.lbal = ATA_LOG_SATA_NCQ;
-	tf.nsect = 1;
-	tf.hob_nsect = 0;
-	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_LBA48 | ATA_TFLAG_DEVICE;
-	tf.protocol = ATA_PROT_PIO;
-
-	qc.tag = ATA_TAG_INTERNAL;
-	qc.scsicmd = NULL;
-	qc.ap = ap;
-	qc.dev = ap->device;
-
-	qc.tf = tf;
-	qc.flags |= ATA_QCFLAG_RESULT_TF;
-	qc.dma_dir = DMA_FROM_DEVICE;
-
-	buf = ap->sector_buf;
-	ata_sg_init_one(&qc, buf, 1 * ATA_SECT_SIZE);
-
-	/*
-	 * Need to DMA-map the memory buffer associated with the command
-	 */
-
-	sg = qc.__sg;
-	dma_address = dma_map_single(ap->dev, qc.buf_virt,
-				     sg->length, DMA_FROM_DEVICE);
-
-	sg_dma_address(sg) = dma_address;
-	sg_dma_len(sg) = sg->length;
-
-	VPRINTK("EH, addr = 0x%x, len = 0x%x\n", dma_address, sg->length);
-
-	sata_fsl_qc_prep(&qc);
-	sata_fsl_qc_issue(&qc);
-
-	temp = ata_wait_register(CQ + hcr_base, 0x1, 0x1, 1, 5000);
-	if (temp & 0x1) {
-		VPRINTK("READ_LOG_EXT_10H issue failed\n");
-
-		VPRINTK("READ_LOG@5000,CQ=0x%x,CA=0x%x,CC=0x%x\n",
-			ioread32(CQ + hcr_base),
-			ioread32(CA + hcr_base), ioread32(CC + hcr_base));
-
-		sata_fsl_scr_read(ap, SCR_ERROR, &Serror);
-
-		VPRINTK("HStatus = 0x%x\n", ioread32(hcr_base + HSTATUS));
-		VPRINTK("HControl = 0x%x\n", ioread32(hcr_base + HCONTROL));
-		VPRINTK("Serror = 0x%x\n", Serror);
-		goto err;
-	}
-
-	iowrite32(0x01, CC + hcr_base);	/* We know it will be cmd#0 always */
-
-      check_device_signature:
 
 	DPRINTK("SATA FSL : Now checking device signature\n");
 
 	*class = ATA_DEV_NONE;
 
 	/* Verify if SStatus indicates device presence */
-	if (ata_port_online(ap)) {
+	if (ata_link_online(link)) {
 		/*
 		 * if we are here, device presence has been detected,
 		 * 1st D2H FIS would have been received, but sfis in
@@ -1002,25 +923,13 @@ err:
 	return -EIO;
 }
 
-static int sata_fsl_hardreset(struct ata_port *ap, unsigned int *class,
-			      unsigned long deadline)
-{
-	int retval;
-
-	retval = sata_std_hardreset(ap, class, deadline);
-
-	DPRINTK("SATA FSL : in xx_hardreset, retval = 0x%d\n", retval);
-
-	return retval;
-}
-
 static void sata_fsl_error_handler(struct ata_port *ap)
 {
 
 	DPRINTK("in xx_error_handler\n");
 
 	/* perform recovery */
-	ata_do_eh(ap, ata_std_prereset, sata_fsl_softreset, sata_fsl_hardreset,
+	ata_do_eh(ap, ata_std_prereset, sata_fsl_softreset, sata_std_hardreset,
 		  ata_std_postreset);
 }
 
@@ -1042,7 +951,8 @@ static void sata_fsl_irq_clear(struct ata_port *ap)
 
 static void sata_fsl_error_intr(struct ata_port *ap)
 {
-	struct ata_eh_info *ehi = &ap->eh_info;
+	struct ata_link *link = &ap->link;
+	struct ata_eh_info *ehi = &link->eh_info;
 	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
 	void __iomem *hcr_base = host_priv->hcr_base;
 	u32 hstatus, dereg, cereg = 0, SError = 0;
@@ -1111,7 +1021,7 @@ static void sata_fsl_error_intr(struct ata_port *ap)
 	}
 
 	/* record error info */
-	qc = ata_qc_from_tag(ap, ap->active_tag);
+	qc = ata_qc_from_tag(ap, link->active_tag);
 
 	if (qc) {
 		sata_fsl_cache_taskfile_from_d2h_fis(qc, qc->ap);
@@ -1139,6 +1049,7 @@ static void sata_fsl_qc_complete(struct ata_queued_cmd *qc)
 
 static void sata_fsl_host_intr(struct ata_port *ap)
 {
+	struct ata_link *link = &ap->link;
 	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
 	void __iomem *hcr_base = host_priv->hcr_base;
 	u32 hstatus, qc_active = 0;
@@ -1161,7 +1072,7 @@ static void sata_fsl_host_intr(struct ata_port *ap)
 		return;
 	}
 
-	if (ap->sactive) {	/* only true for NCQ commands */
+	if (link->sactive) {	/* only true for NCQ commands */
 		int i;
 		/* Read command completed register */
 		qc_active = ioread32(hcr_base + CC);
@@ -1190,10 +1101,10 @@ static void sata_fsl_host_intr(struct ata_port *ap)
 
 	} else if (ap->qc_active) {
 		iowrite32(1, hcr_base + CC);
-		qc = ata_qc_from_tag(ap, ap->active_tag);
+		qc = ata_qc_from_tag(ap, link->active_tag);
 
 		DPRINTK("completing non-ncq cmd, tag=%d,CC=0x%x\n",
-			ap->active_tag, ioread32(hcr_base + CC));
+			link->active_tag, ioread32(hcr_base + CC));
 
 		if (qc) {
 			sata_fsl_qc_complete(qc);
@@ -1312,15 +1223,9 @@ static struct scsi_host_template sata_fsl_sht = {
 	.slave_configure = ata_scsi_slave_config,
 	.slave_destroy = ata_scsi_slave_destroy,
 	.bios_param = ata_std_bios_param,
-#ifdef CONFIG_PM
-	.suspend = ata_scsi_device_suspend,
-	.resume = ata_scsi_device_resume,
-#endif
 };
 
 static const struct ata_port_operations sata_fsl_ops = {
-	.port_disable = ata_port_disable,
-
 	.check_status = sata_fsl_check_status,
 	.check_altstatus = sata_fsl_check_status,
 	.dev_select = ata_noop_dev_select,
@@ -1330,8 +1235,6 @@ static const struct ata_port_operations sata_fsl_ops = {
 	.qc_prep = sata_fsl_qc_prep,
 	.qc_issue = sata_fsl_qc_issue,
 	.irq_clear = sata_fsl_irq_clear,
-	.irq_on = ata_dummy_irq_on,
-	.irq_ack = ata_dummy_irq_ack,
 
 	.scr_read = sata_fsl_scr_read,
 	.scr_write = sata_fsl_scr_write,
@@ -1348,6 +1251,7 @@ static const struct ata_port_operations sata_fsl_ops = {
 static const struct ata_port_info sata_fsl_port_info[] = {
 	{
 	 .flags = SATA_FSL_HOST_FLAGS,
+	 .link_flags = SATA_FSL_HOST_LFLAGS,
 	 .pio_mask = 0x1f,	/* pio 0-4 */
 	 .udma_mask = 0x7f,	/* udma 0-6 */
 	 .port_ops = &sata_fsl_ops,
@@ -1398,6 +1302,7 @@ static int sata_fsl_probe(struct of_device *ofdev,
 		dev_printk(KERN_ERR, &ofdev->dev, "invalid irq from platform\n");
 		goto error_exit_with_cleanup;
 	}
+	host_priv->irq = irq;
 
 	/* allocate host structure */
 	host = ata_host_alloc_pinfo(&ofdev->dev, ppi, SATA_FSL_MAX_PORTS);
@@ -1444,7 +1349,7 @@ static int sata_fsl_remove(struct of_device *ofdev)
 
 	dev_set_drvdata(&ofdev->dev, NULL);
 
-	irq_dispose_mapping(host->irq);
+	irq_dispose_mapping(host_priv->irq);
 	iounmap(host_priv->hcr_base);
 	kfree(host_priv);
 
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 825e717..7914def 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -587,7 +587,7 @@ static void pdc_fill_sg(struct ata_queued_cmd *qc)
 			VPRINTK("Splitting last PRD.\n");
 
 			addr = le32_to_cpu(ap->prd[idx - 1].addr);
-			ap->prd[idx - 1].flags_len -= cpu_to_le32(SG_COUNT_ASIC_BUG);
+			ap->prd[idx - 1].flags_len = cpu_to_le32(len - SG_COUNT_ASIC_BUG);
 			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx - 1, addr, SG_COUNT_ASIC_BUG);
 
 			addr = addr + len - SG_COUNT_ASIC_BUG;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 128dc7a..61535e7 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -43,6 +43,7 @@ enum {
 	ATA_MAX_SECTORS_128	= 128,
 	ATA_MAX_SECTORS		= 256,
 	ATA_MAX_SECTORS_LBA48	= 65535,/* TODO: 65536? */
+	ATA_MAX_SECTORS_TAPE	= 65535,
 
 	ATA_ID_WORDS		= 256,
 	ATA_ID_SERNO		= 10,
@@ -544,6 +545,11 @@ static inline int atapi_cdb_len(const u16 *dev_id)
 	}
 }
 
+static inline int atapi_command_packet_set(const u16 *dev_id)
+{
+	return (dev_id[0] >> 8) & 0x1f;
+}
+
 static inline int is_atapi_taskfile(const struct ata_taskfile *tf)
 {
 	return (tf->protocol == ATA_PROT_ATAPI) ||
