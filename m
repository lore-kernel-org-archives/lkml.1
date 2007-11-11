Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbXKKLaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbXKKLaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 06:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbXKKLaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 06:30:22 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35650 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752935AbXKKLaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 06:30:20 -0500
Date: Sun, 11 Nov 2007 12:29:56 +0100
From: Adrian Bunk <bunk@kernel.org>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] libata: remove unused functions
Message-ID: <20071111112956.GM21669@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the following obsolete functions:
- libata-core.c: __sata_phy_reset()
- libata-core.c: sata_phy_reset()
- libata-eh.c: ata_qc_timeout()
- libata-eh.c: ata_eng_timeout()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ata/libata-core.c |   78 -------------------------------
 drivers/ata/libata-eh.c   |   95 --------------------------------------
 include/linux/libata.h    |    4 -
 3 files changed, 177 deletions(-)

7e9868b7e921f3235d044c78f28da8797cc63e5a 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8189803..1584164 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2581,81 +2581,6 @@ void sata_print_link_status(struct ata_link *link)
 }
 
 /**
- *	__sata_phy_reset - Wake/reset a low-level SATA PHY
- *	@ap: SATA port associated with target SATA PHY.
- *
- *	This function issues commands to standard SATA Sxxx
- *	PHY registers, to wake up the phy (and device), and
- *	clear any reset condition.
- *
- *	LOCKING:
- *	PCI/etc. bus probe sem.
- *
- */
-void __sata_phy_reset(struct ata_port *ap)
-{
-	struct ata_link *link = &ap->link;
-	unsigned long timeout = jiffies + (HZ * 5);
-	u32 sstatus;
-
-	if (ap->flags & ATA_FLAG_SATA_RESET) {
-		/* issue phy wake/reset */
-		sata_scr_write_flush(link, SCR_CONTROL, 0x301);
-		/* Couldn't find anything in SATA I/II specs, but
-		 * AHCI-1.1 10.4.2 says at least 1 ms. */
-		mdelay(1);
-	}
-	/* phy wake/clear reset */
-	sata_scr_write_flush(link, SCR_CONTROL, 0x300);
-
-	/* wait for phy to become ready, if necessary */
-	do {
-		msleep(200);
-		sata_scr_read(link, SCR_STATUS, &sstatus);
-		if ((sstatus & 0xf) != 1)
-			break;
-	} while (time_before(jiffies, timeout));
-
-	/* print link status */
-	sata_print_link_status(link);
-
-	/* TODO: phy layer with polling, timeouts, etc. */
-	if (!ata_link_offline(link))
-		ata_port_probe(ap);
-	else
-		ata_port_disable(ap);
-
-	if (ap->flags & ATA_FLAG_DISABLED)
-		return;
-
-	if (ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT)) {
-		ata_port_disable(ap);
-		return;
-	}
-
-	ap->cbl = ATA_CBL_SATA;
-}
-
-/**
- *	sata_phy_reset - Reset SATA bus.
- *	@ap: SATA port associated with target SATA PHY.
- *
- *	This function resets the SATA bus, and then probes
- *	the bus for devices.
- *
- *	LOCKING:
- *	PCI/etc. bus probe sem.
- *
- */
-void sata_phy_reset(struct ata_port *ap)
-{
-	__sata_phy_reset(ap);
-	if (ap->flags & ATA_FLAG_DISABLED)
-		return;
-	ata_bus_reset(ap);
-}
-
-/**
  *	ata_dev_pair		-	return other device on cable
  *	@adev: device
  *
@@ -7653,8 +7578,6 @@ EXPORT_SYMBOL_GPL(ata_dev_disable);
 EXPORT_SYMBOL_GPL(sata_set_spd);
 EXPORT_SYMBOL_GPL(sata_link_debounce);
 EXPORT_SYMBOL_GPL(sata_link_resume);
-EXPORT_SYMBOL_GPL(sata_phy_reset);
-EXPORT_SYMBOL_GPL(__sata_phy_reset);
 EXPORT_SYMBOL_GPL(ata_bus_reset);
 EXPORT_SYMBOL_GPL(ata_std_prereset);
 EXPORT_SYMBOL_GPL(ata_std_softreset);
@@ -7725,7 +7648,6 @@ EXPORT_SYMBOL_GPL(ata_port_desc);
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL_GPL(ata_port_pbar_desc);
 #endif /* CONFIG_PCI */
-EXPORT_SYMBOL_GPL(ata_eng_timeout);
 EXPORT_SYMBOL_GPL(ata_port_schedule_eh);
 EXPORT_SYMBOL_GPL(ata_link_abort);
 EXPORT_SYMBOL_GPL(ata_port_abort);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index ed8813b..0dac69d 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -559,101 +559,6 @@ void ata_port_wait_eh(struct ata_port *ap)
 	}
 }
 
-/**
- *	ata_qc_timeout - Handle timeout of queued command
- *	@qc: Command that timed out
- *
- *	Some part of the kernel (currently, only the SCSI layer)
- *	has noticed that the active command on port @ap has not
- *	completed after a specified length of time.  Handle this
- *	condition by disabling DMA (if necessary) and completing
- *	transactions, with error if necessary.
- *
- *	This also handles the case of the "lost interrupt", where
- *	for some reason (possibly hardware bug, possibly driver bug)
- *	an interrupt was not delivered to the driver, even though the
- *	transaction completed successfully.
- *
- *	TODO: kill this function once old EH is gone.
- *
- *	LOCKING:
- *	Inherited from SCSI layer (none, can sleep)
- */
-static void ata_qc_timeout(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	u8 host_stat = 0, drv_stat;
-	unsigned long flags;
-
-	DPRINTK("ENTER\n");
-
-	ap->hsm_task_state = HSM_ST_IDLE;
-
-	spin_lock_irqsave(ap->lock, flags);
-
-	switch (qc->tf.protocol) {
-
-	case ATA_PROT_DMA:
-	case ATA_PROT_ATAPI_DMA:
-		host_stat = ap->ops->bmdma_status(ap);
-
-		/* before we do anything else, clear DMA-Start bit */
-		ap->ops->bmdma_stop(qc);
-
-		/* fall through */
-
-	default:
-		ata_altstatus(ap);
-		drv_stat = ata_chk_status(ap);
-
-		/* ack bmdma irq events */
-		ap->ops->irq_clear(ap);
-
-		ata_dev_printk(qc->dev, KERN_ERR, "command 0x%x timeout, "
-			       "stat 0x%x host_stat 0x%x\n",
-			       qc->tf.command, drv_stat, host_stat);
-
-		/* complete taskfile transaction */
-		qc->err_mask |= AC_ERR_TIMEOUT;
-		break;
-	}
-
-	spin_unlock_irqrestore(ap->lock, flags);
-
-	ata_eh_qc_complete(qc);
-
-	DPRINTK("EXIT\n");
-}
-
-/**
- *	ata_eng_timeout - Handle timeout of queued command
- *	@ap: Port on which timed-out command is active
- *
- *	Some part of the kernel (currently, only the SCSI layer)
- *	has noticed that the active command on port @ap has not
- *	completed after a specified length of time.  Handle this
- *	condition by disabling DMA (if necessary) and completing
- *	transactions, with error if necessary.
- *
- *	This also handles the case of the "lost interrupt", where
- *	for some reason (possibly hardware bug, possibly driver bug)
- *	an interrupt was not delivered to the driver, even though the
- *	transaction completed successfully.
- *
- *	TODO: kill this function once old EH is gone.
- *
- *	LOCKING:
- *	Inherited from SCSI layer (none, can sleep)
- */
-void ata_eng_timeout(struct ata_port *ap)
-{
-	DPRINTK("ENTER\n");
-
-	ata_qc_timeout(ata_qc_from_tag(ap, ap->link.active_tag));
-
-	DPRINTK("EXIT\n");
-}
-
 static int ata_eh_nr_in_flight(struct ata_port *ap)
 {
 	unsigned int tag;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 56a5673..3f9a6a1 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -771,8 +771,6 @@ static inline int ata_port_is_dummy(struct ata_port *ap)
 
 extern void sata_print_link_status(struct ata_link *link);
 extern void ata_port_probe(struct ata_port *);
-extern void __sata_phy_reset(struct ata_port *ap);
-extern void sata_phy_reset(struct ata_port *ap);
 extern void ata_bus_reset(struct ata_port *ap);
 extern int sata_set_spd(struct ata_link *link);
 extern int sata_link_debounce(struct ata_link *link,
@@ -994,8 +992,6 @@ extern void sata_pmp_do_eh(struct ata_port *ap,
 /*
  * EH
  */
-extern void ata_eng_timeout(struct ata_port *ap);
-
 extern void ata_port_schedule_eh(struct ata_port *ap);
 extern int ata_link_abort(struct ata_link *link);
 extern int ata_port_abort(struct ata_port *ap);

