Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYKKIGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYKKIGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYKKIGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:06:35 -0500
Received: from havoc.gtf.org ([69.61.125.42]:38032 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbYKKIGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:06:34 -0500
Date: Tue, 11 Nov 2008 03:06:32 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20081111080632.GA22467@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* pata_sch failed to probe and support PATA slave devices... doh
* another 1.5TB drive fix (Roland)
* PMP fix from Tejun
* other minor stuff


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c |    2 +-
 drivers/ata/libata-eh.c   |   21 +++++++++++----------
 drivers/ata/pata_cs5535.c |    1 -
 drivers/ata/pata_cs5536.c |    1 -
 drivers/ata/pata_pcmcia.c |    1 +
 drivers/ata/pata_sch.c    |    2 +-
 6 files changed, 14 insertions(+), 14 deletions(-)

Marc Pignat (1):
      [libata] pata_pcmcia: another memory card support

Mark Salter (1):
      [libata] pata_sch: notice attached slave devices

Qinghuang Feng (1):
      [libata] pata_cs553*.c: cleanup kernel-doc

Roland Dreier (1):
      libata: Avoid overflow in ata_tf_read_block() when tf->hba_lbal > 127

Tejun Heo (1):
      libata: fix last_reset timestamp handling

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 0cd3ad4..4214bfb 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -612,7 +612,7 @@ u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev)
 		if (tf->flags & ATA_TFLAG_LBA48) {
 			block |= (u64)tf->hob_lbah << 40;
 			block |= (u64)tf->hob_lbam << 32;
-			block |= tf->hob_lbal << 24;
+			block |= (u64)tf->hob_lbal << 24;
 		} else
 			block |= (tf->device & 0xf) << 24;
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 8077bdf..32da9a9 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -610,9 +610,6 @@ void ata_scsi_error(struct Scsi_Host *host)
 				if (ata_ncq_enabled(dev))
 					ehc->saved_ncq_enabled |= 1 << devno;
 			}
-
-			/* set last reset timestamp to some time in the past */
-			ehc->last_reset = jiffies - 60 * HZ;
 		}
 
 		ap->pflags |= ATA_PFLAG_EH_IN_PROGRESS;
@@ -2281,17 +2278,21 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	if (link->flags & ATA_LFLAG_NO_SRST)
 		softreset = NULL;
 
-	now = jiffies;
-	deadline = ata_deadline(ehc->last_reset, ATA_EH_RESET_COOL_DOWN);
-	if (time_before(now, deadline))
-		schedule_timeout_uninterruptible(deadline - now);
+	/* make sure each reset attemp is at least COOL_DOWN apart */
+	if (ehc->i.flags & ATA_EHI_DID_RESET) {
+		now = jiffies;
+		WARN_ON(time_after(ehc->last_reset, now));
+		deadline = ata_deadline(ehc->last_reset,
+					ATA_EH_RESET_COOL_DOWN);
+		if (time_before(now, deadline))
+			schedule_timeout_uninterruptible(deadline - now);
+	}
 
 	spin_lock_irqsave(ap->lock, flags);
 	ap->pflags |= ATA_PFLAG_RESETTING;
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	ata_eh_about_to_do(link, NULL, ATA_EH_RESET);
-	ehc->last_reset = jiffies;
 
 	ata_link_for_each_dev(dev, link) {
 		/* If we issue an SRST then an ATA drive (not ATAPI)
@@ -2379,7 +2380,6 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	/*
 	 * Perform reset
 	 */
-	ehc->last_reset = jiffies;
 	if (ata_is_host_link(link))
 		ata_eh_freeze_port(ap);
 
@@ -2391,6 +2391,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 					reset == softreset ? "soft" : "hard");
 
 		/* mark that this EH session started with reset */
+		ehc->last_reset = jiffies;
 		if (reset == hardreset)
 			ehc->i.flags |= ATA_EHI_DID_HARDRESET;
 		else
@@ -2535,7 +2536,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	ata_eh_done(link, NULL, ATA_EH_RESET);
 	if (slave)
 		ata_eh_done(slave, NULL, ATA_EH_RESET);
-	ehc->last_reset = jiffies;
+	ehc->last_reset = jiffies;	/* update to completion time */
 	ehc->i.action |= ATA_EH_REVALIDATE;
 
 	rc = 0;
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index 1b2d4a0..8b236af 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -72,7 +72,6 @@
 /**
  *	cs5535_cable_detect	-	detect cable type
  *	@ap: Port to detect on
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection for ATA66 capable cable. Return a libata
  *	cable type.
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 73f8332..afed929 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -110,7 +110,6 @@ static inline int cs5536_write(struct pci_dev *pdev, int reg, int val)
 /**
  *	cs5536_cable_detect	-	detect cable type
  *	@ap: Port to detect on
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection for ATA66 capable cable. Return a libata
  *	cable type.
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 271cb64..64b2e22 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -416,6 +416,7 @@ static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_PROD_ID1("STI Flash", 0xe4a13209),
 	PCMCIA_DEVICE_PROD_ID12("STI", "Flash 5.0", 0xbf2df18d, 0x8cb57a0e),
 	PCMCIA_MFC_DEVICE_PROD_ID12(1, "SanDisk", "ConnectPlus", 0x7a954bd9, 0x74be00c6),
+	PCMCIA_DEVICE_PROD_ID2("Flash Card", 0x5a362506),
 	PCMCIA_DEVICE_NULL,
 };
 
diff --git a/drivers/ata/pata_sch.c b/drivers/ata/pata_sch.c
index c8cc027..6aeeeeb 100644
--- a/drivers/ata/pata_sch.c
+++ b/drivers/ata/pata_sch.c
@@ -83,7 +83,7 @@ static struct ata_port_operations sch_pata_ops = {
 };
 
 static struct ata_port_info sch_port_info = {
-	.flags		= 0,
+	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= ATA_PIO4,   /* pio0-4 */
 	.mwdma_mask	= ATA_MWDMA2, /* mwdma0-2 */
 	.udma_mask	= ATA_UDMA5,  /* udma0-5 */
