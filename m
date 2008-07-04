Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYGDNKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYGDNKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbYGDNKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:10:09 -0400
Received: from havoc.gtf.org ([69.61.125.42]:39721 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbYGDNKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:10:08 -0400
Date: Fri, 4 Jul 2008 09:10:05 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes for .26
Message-ID: <20080704131005.GA30768@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The libata-sff change is longer than I'd like for 2.6.26-rc, but it's
all printk changes/additions.  No behavior changes, just improved
diagnostics upon error, something we really need in that area.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c       |    9 +++------
 drivers/ata/libata-sff.c |   30 +++++++++++++++++++++---------
 drivers/ata/sata_mv.c    |    2 +-
 drivers/ata/sata_sil24.c |    1 +
 drivers/ata/sata_uli.c   |    1 +
 5 files changed, 27 insertions(+), 16 deletions(-)

Mark Lord (1):
      sata_mv: safer logic for limit_warnings

Tejun Heo (4):
      sata_uli: hardreset is broken
      sata_sil24: add DID for another adaptec flavor
      ahci: always clear all bits in irq_stat
      libata-sff: improve HSM violation reporting

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6a4a2a2..061817a 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1777,7 +1777,7 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 	struct ahci_host_priv *hpriv;
 	unsigned int i, handled = 0;
 	void __iomem *mmio;
-	u32 irq_stat, irq_ack = 0;
+	u32 irq_stat;
 
 	VPRINTK("ENTER\n");
 
@@ -1809,14 +1809,11 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 					"interrupt on disabled port %u\n", i);
 		}
 
-		irq_ack |= (1 << i);
-	}
-
-	if (irq_ack) {
-		writel(irq_ack, mmio + HOST_IRQ_STAT);
 		handled = 1;
 	}
 
+	writel(irq_stat, mmio + HOST_IRQ_STAT);
+
 	spin_unlock(&host->lock);
 
 	VPRINTK("EXIT\n");
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 215d186..c0908c2 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1094,6 +1094,7 @@ static void ata_hsm_qc_complete(struct ata_queued_cmd *qc, int in_wq)
 int ata_sff_hsm_move(struct ata_port *ap, struct ata_queued_cmd *qc,
 		     u8 status, int in_wq)
 {
+	struct ata_eh_info *ehi = &ap->link.eh_info;
 	unsigned long flags = 0;
 	int poll_next;
 
@@ -1125,9 +1126,12 @@ fsm_start:
 			if (likely(status & (ATA_ERR | ATA_DF)))
 				/* device stops HSM for abort/error */
 				qc->err_mask |= AC_ERR_DEV;
-			else
+			else {
 				/* HSM violation. Let EH handle this */
+				ata_ehi_push_desc(ehi,
+					"ST_FIRST: !(DRQ|ERR|DF)");
 				qc->err_mask |= AC_ERR_HSM;
+			}
 
 			ap->hsm_task_state = HSM_ST_ERR;
 			goto fsm_start;
@@ -1146,9 +1150,9 @@ fsm_start:
 			 * the CDB.
 			 */
 			if (!(qc->dev->horkage & ATA_HORKAGE_STUCK_ERR)) {
-				ata_port_printk(ap, KERN_WARNING,
-						"DRQ=1 with device error, "
-						"dev_stat 0x%X\n", status);
+				ata_ehi_push_desc(ehi, "ST_FIRST: "
+					"DRQ=1 with device error, "
+					"dev_stat 0x%X", status);
 				qc->err_mask |= AC_ERR_HSM;
 				ap->hsm_task_state = HSM_ST_ERR;
 				goto fsm_start;
@@ -1205,9 +1209,9 @@ fsm_start:
 			 * let the EH abort the command or reset the device.
 			 */
 			if (unlikely(status & (ATA_ERR | ATA_DF))) {
-				ata_port_printk(ap, KERN_WARNING, "DRQ=1 with "
-						"device error, dev_stat 0x%X\n",
-						status);
+				ata_ehi_push_desc(ehi, "ST-ATAPI: "
+					"DRQ=1 with device error, "
+					"dev_stat 0x%X", status);
 				qc->err_mask |= AC_ERR_HSM;
 				ap->hsm_task_state = HSM_ST_ERR;
 				goto fsm_start;
@@ -1226,13 +1230,17 @@ fsm_start:
 				if (likely(status & (ATA_ERR | ATA_DF)))
 					/* device stops HSM for abort/error */
 					qc->err_mask |= AC_ERR_DEV;
-				else
+				else {
 					/* HSM violation. Let EH handle this.
 					 * Phantom devices also trigger this
 					 * condition.  Mark hint.
 					 */
+					ata_ehi_push_desc(ehi, "ST-ATA: "
+						"DRQ=1 with device error, "
+						"dev_stat 0x%X", status);
 					qc->err_mask |= AC_ERR_HSM |
 							AC_ERR_NODEV_HINT;
+				}
 
 				ap->hsm_task_state = HSM_ST_ERR;
 				goto fsm_start;
@@ -1257,8 +1265,12 @@ fsm_start:
 					status = ata_wait_idle(ap);
 				}
 
-				if (status & (ATA_BUSY | ATA_DRQ))
+				if (status & (ATA_BUSY | ATA_DRQ)) {
+					ata_ehi_push_desc(ehi, "ST-ATA: "
+						"BUSY|DRQ persists on ERR|DF, "
+						"dev_stat 0x%X", status);
 					qc->err_mask |= AC_ERR_HSM;
+				}
 
 				/* ata_pio_sectors() might change the
 				 * state to HSM_ST_LAST. so, the state
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 28092bc..ad169ff 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1607,7 +1607,7 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 		 * Much of the time, this could just work regardless.
 		 * So for now, just log the incident, and allow the attempt.
 		 */
-		if (limit_warnings && (qc->nbytes / qc->sect_size) > 1) {
+		if (limit_warnings > 0 && (qc->nbytes / qc->sect_size) > 1) {
 			--limit_warnings;
 			ata_link_printk(qc->dev->link, KERN_WARNING, DRV_NAME
 					": attempting PIO w/multiple DRQ: "
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 8ee6b5b..84ffcc2 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -370,6 +370,7 @@ static const struct pci_device_id sil24_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x3124), BID_SIL3124 },
 	{ PCI_VDEVICE(CMD, 0x3132), BID_SIL3132 },
 	{ PCI_VDEVICE(CMD, 0x0242), BID_SIL3132 },
+	{ PCI_VDEVICE(CMD, 0x0244), BID_SIL3132 },
 	{ PCI_VDEVICE(CMD, 0x3131), BID_SIL3131 },
 	{ PCI_VDEVICE(CMD, 0x3531), BID_SIL3131 },
 
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index f277cea..db529b8 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -83,6 +83,7 @@ static struct ata_port_operations uli_ops = {
 	.inherits		= &ata_bmdma_port_ops,
 	.scr_read		= uli_scr_read,
 	.scr_write		= uli_scr_write,
+	.hardreset		= ATA_OP_NULL,
 };
 
 static const struct ata_port_info uli_port_info = {
