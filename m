Return-Path: <linux-kernel-owner+w=401wt.eu-S1762544AbYCGS0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762544AbYCGS0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761006AbYCGSZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:25:47 -0500
Received: from nebensachen.de ([195.34.83.29]:40761 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310AbYCGSZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:25:44 -0500
X-Hashcash: 1:20:080307:alan@lxorguk.ukuu.org.uk::iiRhAuTA1nIHBXGK:00000000000000000000000000000000000007pTc
X-Hashcash: 1:20:080307:linux-ide@vger.kernel.org::m8ZAraRq61NDtr3G:0000000000000000000000000000000000006i7Y
X-Hashcash: 1:20:080307:linux-kernel@vger.kernel.org::7ZpuwSqVzfc+bMEL:0000000000000000000000000000000005O7a
X-Hashcash: 1:20:080307:jens.axboe@oracle.com::7aHQQnchuIGb3Eqg:00000000000000000000000000000000000000001N1h
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/4] disk-protect: Add disk shock protection helpers to libata
Message-ID: <20080307181750.9981.88028.stgit@denkblock.local>
References: <87skzgd1zk.fsf@denkblock.local> <20080226123946.75dbe3d2@core>
	<87mypl8p49.fsf@denkblock.local> <20080228111349.6831925c@core>
	<87bq5qfm2v.fsf@denkblock.local>
User-Agent: StGIT/0.12.1
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Mail-Copies-To: nobody
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe
	<jens.axboe@oracle.com>
Date: Fri, 07 Mar 2008 19:25:16 +0100
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some helper functions to libata in order to provide low
level suport for disk shock protection. The user interface to this
functionality will be implemented in the block layer in a subsequent patch.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/ata/libata-core.c |   69 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-eh.c   |    9 ++++++
 drivers/ata/libata-scsi.c |   31 ++++++++++++++++++++
 drivers/ata/libata.h      |    1 +
 include/linux/ata.h       |   12 ++++++++
 include/linux/libata.h    |    4 ++-
 6 files changed, 125 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 6380726..74c3e7e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6634,6 +6634,75 @@ int ata_port_start(struct ata_port *ap)
 }
 
 /**
+ *	ata_protect_dev - Stop I/O to device and unload disk heads
+ *	@dev: Device to be protected
+ *
+ *	Issue an IDLE IMMEDIATE command with UNLOAD FEATURE.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ *
+ *	RETURNS:
+ *	0 on success, -EIO on failure.
+ */
+int ata_protect_dev(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+	struct ata_taskfile tf;
+	unsigned long flags;
+	unsigned int err_mask;
+	int unload = ata_id_has_unload(dev->id);
+	/* We need a mechanism to set unload to 1 for devices that
+	 * support the unload feature of idle immediate but don't
+	 * report that capability in dev->id. Is dev->horkage or
+	 * dev->flags the right place for such a flag?
+	 */
+
+	spin_lock_irqsave(ap->lock, flags);
+	if (unlikely(!(dev->flags & ATA_DFLAG_PROTECTED))) {
+		spin_unlock_irqrestore(ap->lock, flags);
+		goto out;
+	}
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	ata_tf_init(dev, &tf);
+	tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf.protocol |= ATA_PROT_NODATA;
+	if (unload) {
+		tf.command = ATA_CMD_IDLEIMMEDIATE;
+		tf.feature = 0x44;
+		tf.lbal = 0x4c;
+		tf.lbam = 0x4e;
+		tf.lbah = 0x55;
+	} else
+		tf.command = ATA_CMD_STANDBYNOW1;
+
+	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
+	if (err_mask)
+		goto abort;
+
+	if (unload) {
+		if (tf.lbal == 0xc4)
+			ata_dev_printk(dev, KERN_DEBUG,
+				       "head parked\n");
+		else
+			goto abort;
+	} else
+		ata_dev_printk(dev, KERN_DEBUG,
+			       "head park not requested, used standby\n");
+
+out:
+	return 0;
+
+abort:
+	ata_dev_printk(dev, KERN_DEBUG, "head NOT parked\n");
+	spin_lock_irqsave(ap->lock, flags);
+	dev->flags &= ~ATA_DFLAG_PROTECTED;
+	spin_unlock_irqrestore(ap->lock, flags);
+	return -EIO;
+}
+
+/**
  *	ata_dev_init - Initialize an ata_device structure
  *	@dev: Device structure to initialize
  *
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 21a81cd..edb92dc 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2584,6 +2584,15 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 			ata_link_for_each_dev(dev, link)
 				ata_dev_enable_pm(dev, ap->pm_policy);
 
+		ata_link_for_each_dev(dev, link)
+			if (ehc->i.dev_action[dev->devno] & ATA_EH_PROTECT) {
+				ata_eh_about_to_do(link, dev, ATA_EH_PROTECT);
+				rc = ata_protect_dev(dev);
+				if (rc)
+					goto dev_fail;
+				ata_eh_done(link, dev, ATA_EH_PROTECT);
+			}
+
 		/* this link is okay now */
 		ehc->i.flags = 0;
 		continue;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 14daf48..d0fd762 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -856,6 +856,34 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 	}
 }
 
+static void ata_scsi_protect_dev(struct ata_device *dev)
+{
+	struct ata_link *link = dev->link;
+	struct ata_eh_info *ehi = &link->eh_info;
+
+	if (dev->flags & ATA_DFLAG_PROTECTED)
+		return;
+
+	dev->flags |= ATA_DFLAG_PROTECTED;
+	ehi->dev_action[dev->devno] |= ATA_EH_PROTECT;
+	ehi->flags |= ATA_EHI_QUIET;
+	ata_port_schedule_eh(link->ap);
+}
+
+static void ata_scsi_unprotect_dev(struct ata_device *dev)
+{
+	struct ata_link *link = dev->link;
+	struct ata_eh_info *ehi = &link->eh_info;
+
+	if (!(dev->flags & ATA_DFLAG_PROTECTED))
+		return;
+	dev->flags &= ~ATA_DFLAG_PROTECTED;
+
+	ehi->dev_action[dev->devno] |= ATA_EH_REVALIDATE;
+	ehi->flags |= ATA_EHI_QUIET;
+	ata_port_schedule_eh(link->ap);
+}
+
 /**
  *	ata_scsi_slave_config - Set SCSI device attributes
  *	@sdev: SCSI device to examine
@@ -1517,6 +1545,9 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 
 	VPRINTK("ENTER\n");
 
+	if (unlikely(dev->flags & ATA_DFLAG_PROTECTED))
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+
 	qc = ata_scsi_qc_new(dev, cmd, done);
 	if (!qc)
 		goto err_mem;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index bbe59c2..807cf2f 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -95,6 +95,7 @@ extern void ata_dev_select(struct ata_port *ap, unsigned int device,
                            unsigned int wait, unsigned int can_sleep);
 extern void swap_buf_le16(u16 *buf, unsigned int buf_words);
 extern int ata_flush_cache(struct ata_device *dev);
+extern int ata_protect_dev(struct ata_device *dev);
 extern void ata_dev_init(struct ata_device *dev);
 extern void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp);
 extern int sata_link_init_spd(struct ata_link *link);
diff --git a/include/linux/ata.h b/include/linux/ata.h
index e672e80..aa16cbb 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -395,6 +395,18 @@ struct ata_taskfile {
 
 #define ata_id_cdb_intr(id)	(((id)[0] & 0x60) == 0x20)
 
+static inline int ata_id_has_unload(const u16 *id)
+{
+	/* ATA-7 specifies two places to indicate unload feature support.
+	 * Since I don't really understand the difference, I'll just check
+	 * both and only return zero if none of them indicates otherwise. */
+	if ((id[84] & 0xC000) == 0x4000 && id[84] & (1 << 13))
+		return id[84] & (1 << 13);
+	if ((id[87] & 0xC000) == 0x4000)
+		return id[87] & (1 << 13);
+	return 0;
+}
+
 static inline bool ata_id_has_hipm(const u16 *id)
 {
 	u16 val = id[76];
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 124033c..2db23c3 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -147,6 +147,7 @@ enum {
 
 	ATA_DFLAG_DETACH	= (1 << 16),
 	ATA_DFLAG_DETACHED	= (1 << 17),
+	ATA_DFLAG_PROTECTED	= (1 << 18),
 
 	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
 	ATA_DEV_ATA		= 1,	/* ATA device */
@@ -299,9 +300,10 @@ enum {
 	ATA_EH_SOFTRESET	= (1 << 1),
 	ATA_EH_HARDRESET	= (1 << 2),
 	ATA_EH_ENABLE_LINK	= (1 << 3),
+	ATA_EH_PROTECT		= (1 << 4),
 
 	ATA_EH_RESET_MASK	= ATA_EH_SOFTRESET | ATA_EH_HARDRESET,
-	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE,
+	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE | ATA_EH_PROTECT,
 
 	/* ata_eh_info->flags */
 	ATA_EHI_HOTPLUGGED	= (1 << 0),  /* could have been hotplugged */


