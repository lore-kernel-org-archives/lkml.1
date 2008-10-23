Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYJWAs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYJWAs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 20:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbYJWAsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 20:48:47 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42377 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbYJWAsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 20:48:46 -0400
Date: Wed, 22 Oct 2008 20:48:45 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20081023004845.GA806@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c |    2 ++
 drivers/ata/libata-eh.c   |   26 +++++++++++++++++---------
 drivers/ata/libata-sff.c  |   11 ++++++++++-
 drivers/ata/sata_via.c    |   35 ++++++++++++++++++++++++++++++++---
 include/linux/libata.h    |    3 +++
 5 files changed, 64 insertions(+), 13 deletions(-)

Tejun Heo (6):
      libata: initialize port_task when !CONFIG_ATA_SFF
      libata-sff: fix ata_sff_post_internal_cmd()
      libata: transfer EHI control flags to slave ehc.i
      libata-eh: fix slave link EH action mask handling
      libata: set device class to NONE if phys_offline
      sata_via: load DEVICE register when CTL changes

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 1ee9499..bbb3cae 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5373,6 +5373,8 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 
 #ifdef CONFIG_ATA_SFF
 	INIT_DELAYED_WORK(&ap->port_task, ata_pio_task);
+#else
+	INIT_DELAYED_WORK(&ap->port_task, NULL);
 #endif
 	INIT_DELAYED_WORK(&ap->hotplug_task, ata_scsi_hotplug);
 	INIT_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index a93247c..5d687d7 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1206,7 +1206,10 @@ void ata_eh_about_to_do(struct ata_link *link, struct ata_device *dev,
 
 	ata_eh_clear_action(link, dev, ehi, action);
 
-	if (!(ehc->i.flags & ATA_EHI_QUIET))
+	/* About to take EH action, set RECOVERED.  Ignore actions on
+	 * slave links as master will do them again.
+	 */
+	if (!(ehc->i.flags & ATA_EHI_QUIET) && link != ap->slave_link)
 		ap->pflags |= ATA_PFLAG_RECOVERED;
 
 	spin_unlock_irqrestore(ap->lock, flags);
@@ -2010,8 +2013,13 @@ void ata_eh_autopsy(struct ata_port *ap)
 		struct ata_eh_context *mehc = &ap->link.eh_context;
 		struct ata_eh_context *sehc = &ap->slave_link->eh_context;
 
+		/* transfer control flags from master to slave */
+		sehc->i.flags |= mehc->i.flags & ATA_EHI_TO_SLAVE_MASK;
+
+		/* perform autopsy on the slave link */
 		ata_eh_link_autopsy(ap->slave_link);
 
+		/* transfer actions from slave to master and clear slave */
 		ata_eh_about_to_do(ap->slave_link, NULL, ATA_EH_ALL_ACTIONS);
 		mehc->i.action		|= sehc->i.action;
 		mehc->i.dev_action[1]	|= sehc->i.dev_action[1];
@@ -2447,14 +2455,14 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		dev->pio_mode = XFER_PIO_0;
 		dev->flags &= ~ATA_DFLAG_SLEEPING;
 
-		if (ata_phys_link_offline(ata_dev_phys_link(dev)))
-			continue;
-
-		/* apply class override */
-		if (lflags & ATA_LFLAG_ASSUME_ATA)
-			classes[dev->devno] = ATA_DEV_ATA;
-		else if (lflags & ATA_LFLAG_ASSUME_SEMB)
-			classes[dev->devno] = ATA_DEV_SEMB_UNSUP; /* not yet */
+		if (!ata_phys_link_offline(ata_dev_phys_link(dev))) {
+			/* apply class override */
+			if (lflags & ATA_LFLAG_ASSUME_ATA)
+				classes[dev->devno] = ATA_DEV_ATA;
+			else if (lflags & ATA_LFLAG_ASSUME_SEMB)
+				classes[dev->devno] = ATA_DEV_SEMB_UNSUP;
+		} else
+			classes[dev->devno] = ATA_DEV_NONE;
 	}
 
 	/* record current link speed */
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 2a4c516..4b47394 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2153,8 +2153,17 @@ void ata_sff_error_handler(struct ata_port *ap)
  */
 void ata_sff_post_internal_cmd(struct ata_queued_cmd *qc)
 {
-	if (qc->ap->ioaddr.bmdma_addr)
+	struct ata_port *ap = qc->ap;
+	unsigned long flags;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	ap->hsm_task_state = HSM_ST_IDLE;
+
+	if (ap->ioaddr.bmdma_addr)
 		ata_bmdma_stop(qc);
+
+	spin_unlock_irqrestore(ap->lock, flags);
 }
 
 /**
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 1cfa745..5b72e73 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -70,6 +70,7 @@ enum {
 static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static int svia_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int svia_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
+static void svia_tf_load(struct ata_port *ap, const struct ata_taskfile *tf);
 static void svia_noop_freeze(struct ata_port *ap);
 static int vt6420_prereset(struct ata_link *link, unsigned long deadline);
 static int vt6421_pata_cable_detect(struct ata_port *ap);
@@ -103,21 +104,26 @@ static struct scsi_host_template svia_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
-static struct ata_port_operations vt6420_sata_ops = {
+static struct ata_port_operations svia_base_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_tf_load		= svia_tf_load,
+};
+
+static struct ata_port_operations vt6420_sata_ops = {
+	.inherits		= &svia_base_ops,
 	.freeze			= svia_noop_freeze,
 	.prereset		= vt6420_prereset,
 };
 
 static struct ata_port_operations vt6421_pata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &svia_base_ops,
 	.cable_detect		= vt6421_pata_cable_detect,
 	.set_piomode		= vt6421_set_pio_mode,
 	.set_dmamode		= vt6421_set_dma_mode,
 };
 
 static struct ata_port_operations vt6421_sata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &svia_base_ops,
 	.scr_read		= svia_scr_read,
 	.scr_write		= svia_scr_write,
 };
@@ -168,6 +174,29 @@ static int svia_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 	return 0;
 }
 
+/**
+ *	svia_tf_load - send taskfile registers to host controller
+ *	@ap: Port to which output is sent
+ *	@tf: ATA taskfile register set
+ *
+ *	Outputs ATA taskfile to standard ATA host controller.
+ *
+ *	This is to fix the internal bug of via chipsets, which will
+ *	reset the device register after changing the IEN bit on ctl
+ *	register.
+ */
+static void svia_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
+{
+	struct ata_taskfile ttf;
+
+	if (tf->ctl != ap->last_ctl)  {
+		ttf = *tf;
+		ttf.flags |= ATA_TFLAG_DEVICE;
+		tf = &ttf;
+	}
+	ata_sff_tf_load(ap, tf);
+}
+
 static void svia_noop_freeze(struct ata_port *ap)
 {
 	/* Some VIA controllers choke if ATA_NIEN is manipulated in
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 947cf84..c261aa0 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -340,6 +340,9 @@ enum {
 
 	ATA_EHI_DID_RESET	= ATA_EHI_DID_SOFTRESET | ATA_EHI_DID_HARDRESET,
 
+	/* mask of flags to transfer *to* the slave link */
+	ATA_EHI_TO_SLAVE_MASK	= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET,
+
 	/* max tries if error condition is still set after ->error_handler */
 	ATA_EH_MAX_TRIES	= 5,
 
