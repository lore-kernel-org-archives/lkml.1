Return-Path: <linux-kernel-owner+w=401wt.eu-S933118AbXAXHTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118AbXAXHTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 02:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933104AbXAXHTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 02:19:46 -0500
Received: from havoc.gtf.org ([69.61.125.42]:55405 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932968AbXAXHTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 02:19:45 -0500
Date: Wed, 24 Jan 2007 02:19:20 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070124071920.GA32055@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All fixes for ugly bugs and/or regressions.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |   39 +++++++++++----------------------------
 drivers/ata/libata-scsi.c |    2 +-
 drivers/ata/sata_nv.c     |   14 ++++++--------
 include/linux/libata.h    |    2 ++
 4 files changed, 20 insertions(+), 37 deletions(-)

Brian King (2):
      libata: Fixup n_elem initialization
      libata: Initialize qc->pad_len

Robert Hancock (1):
      sata_nv: don't rely on NV_INT_DEV indication with ADMA

Tejun Heo (2):
      ahci: make ULi M5288 ignore interface fatal error bit
      ahci: don't enter slumber on power down

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index b517d24..e3c7b31 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -361,7 +361,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x27c1), board_ahci }, /* ICH7 */
 	{ PCI_VDEVICE(INTEL, 0x27c5), board_ahci }, /* ICH7M */
 	{ PCI_VDEVICE(INTEL, 0x27c3), board_ahci }, /* ICH7R */
-	{ PCI_VDEVICE(AL, 0x5288), board_ahci }, /* ULi M5288 */
+	{ PCI_VDEVICE(AL, 0x5288), board_ahci_ign_iferr }, /* ULi M5288 */
 	{ PCI_VDEVICE(INTEL, 0x2681), board_ahci }, /* ESB2 */
 	{ PCI_VDEVICE(INTEL, 0x2682), board_ahci }, /* ESB2 */
 	{ PCI_VDEVICE(INTEL, 0x2683), board_ahci }, /* ESB2 */
@@ -586,35 +586,18 @@ static void ahci_power_down(void __iomem *port_mmio, u32 cap)
 {
 	u32 cmd, scontrol;
 
-	cmd = readl(port_mmio + PORT_CMD) & ~PORT_CMD_ICC_MASK;
-
-	if (cap & HOST_CAP_SSC) {
-		/* enable transitions to slumber mode */
-		scontrol = readl(port_mmio + PORT_SCR_CTL);
-		if ((scontrol & 0x0f00) > 0x100) {
-			scontrol &= ~0xf00;
-			writel(scontrol, port_mmio + PORT_SCR_CTL);
-		}
-
-		/* put device into slumber mode */
-		writel(cmd | PORT_CMD_ICC_SLUMBER, port_mmio + PORT_CMD);
-
-		/* wait for the transition to complete */
-		ata_wait_register(port_mmio + PORT_CMD, PORT_CMD_ICC_SLUMBER,
-				  PORT_CMD_ICC_SLUMBER, 1, 50);
-	}
+	if (!(cap & HOST_CAP_SSS))
+		return;
 
-	/* put device into listen mode */
-	if (cap & HOST_CAP_SSS) {
-		/* first set PxSCTL.DET to 0 */
-		scontrol = readl(port_mmio + PORT_SCR_CTL);
-		scontrol &= ~0xf;
-		writel(scontrol, port_mmio + PORT_SCR_CTL);
+	/* put device into listen mode, first set PxSCTL.DET to 0 */
+	scontrol = readl(port_mmio + PORT_SCR_CTL);
+	scontrol &= ~0xf;
+	writel(scontrol, port_mmio + PORT_SCR_CTL);
 
-		/* then set PxCMD.SUD to 0 */
-		cmd &= ~PORT_CMD_SPIN_UP;
-		writel(cmd, port_mmio + PORT_CMD);
-	}
+	/* then set PxCMD.SUD to 0 */
+	cmd = readl(port_mmio + PORT_CMD) & ~PORT_CMD_ICC_MASK;
+	cmd &= ~PORT_CMD_SPIN_UP;
+	writel(cmd, port_mmio + PORT_CMD);
 }
 
 static void ahci_init_port(void __iomem *port_mmio, u32 cap,
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 836947d..7cc5a4a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -372,7 +372,7 @@ struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 		if (cmd->use_sg) {
 			qc->__sg = (struct scatterlist *) cmd->request_buffer;
 			qc->n_elem = cmd->use_sg;
-		} else {
+		} else if (cmd->request_bufflen) {
 			qc->__sg = &qc->sgent;
 			qc->n_elem = 1;
 		}
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index f6d498e..f7a963e 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -700,7 +700,6 @@ static void nv_adma_check_cpb(struct ata_port *ap, int cpb_num, int force_err)
 static int nv_host_intr(struct ata_port *ap, u8 irq_stat)
 {
 	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->active_tag);
-	int handled;
 
 	/* freeze if hotplugged */
 	if (unlikely(irq_stat & (NV_INT_ADDED | NV_INT_REMOVED))) {
@@ -719,13 +718,7 @@ static int nv_host_intr(struct ata_port *ap, u8 irq_stat)
 	}
 
 	/* handle interrupt */
-	handled = ata_host_intr(ap, qc);
-	if (unlikely(!handled)) {
-		/* spurious, clear it */
-		ata_check_status(ap);
-	}
-
-	return 1;
+	return ata_host_intr(ap, qc);
 }
 
 static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
@@ -752,6 +745,11 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 			if (pp->flags & NV_ADMA_PORT_REGISTER_MODE) {
 				u8 irq_stat = readb(host->mmio_base + NV_INT_STATUS_CK804)
 					>> (NV_INT_PORT_SHIFT * i);
+				if(ata_tag_valid(ap->active_tag))
+					/** NV_INT_DEV indication seems unreliable at times
+					    at least in ADMA mode. Force it on always when a
+					    command is active, to prevent losing interrupts. */
+					irq_stat |= NV_INT_DEV;
 				handled += nv_host_intr(ap, irq_stat);
 				continue;
 			}
diff --git a/include/linux/libata.h b/include/linux/libata.h
index e53a13b..f7f268e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1149,7 +1149,9 @@ static inline void ata_qc_reinit(struct ata_queued_cmd *qc)
 	qc->cursect = qc->cursg = qc->cursg_ofs = 0;
 	qc->nsect = 0;
 	qc->nbytes = qc->curbytes = 0;
+	qc->n_elem = 0;
 	qc->err_mask = 0;
+	qc->pad_len = 0;
 
 	ata_tf_init(qc->dev, &qc->tf);
 
