Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbXIZEoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbXIZEoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 00:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbXIZEn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 00:43:56 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33646 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbXIZEnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 00:43:55 -0400
Date: Wed, 26 Sep 2007 00:43:54 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070926044354.GA16633@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/pata_sis.c   |    3 ++-
 drivers/ata/sata_sil24.c |   16 ++++++++++++----
 2 files changed, 14 insertions(+), 5 deletions(-)

Tejun Heo (2):
      sata_sil24: fix IRQ clearing race when PCIX_IRQ_WOC is used
      pata_sis: add missing UDMA5 timing value in sis_66_set_dmamode()

diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 2bd7645..cce2834 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -375,8 +375,9 @@ static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
 
+	/* MWDMA 0-2 and UDMA 0-5 */
 	const u16 mwdma_bits[] = { 0x008, 0x302, 0x301 };
-	const u16 udma_bits[]  = { 0xF000, 0xD000, 0xB000, 0xA000, 0x9000};
+	const u16 udma_bits[]  = { 0xF000, 0xD000, 0xB000, 0xA000, 0x9000, 0x8000 };
 
 	pci_read_config_word(pdev, drive_pci, &timing);
 
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index ef83e6b..233e886 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -888,6 +888,16 @@ static inline void sil24_host_intr(struct ata_port *ap)
 	u32 slot_stat, qc_active;
 	int rc;
 
+	/* If PCIX_IRQ_WOC, there's an inherent race window between
+	 * clearing IRQ pending status and reading PORT_SLOT_STAT
+	 * which may cause spurious interrupts afterwards.  This is
+	 * unavoidable and much better than losing interrupts which
+	 * happens if IRQ pending is cleared after reading
+	 * PORT_SLOT_STAT.
+	 */
+	if (ap->flags & SIL24_FLAG_PCIX_IRQ_WOC)
+		writel(PORT_IRQ_COMPLETE, port + PORT_IRQ_STAT);
+
 	slot_stat = readl(port + PORT_SLOT_STAT);
 
 	if (unlikely(slot_stat & HOST_SSTAT_ATTN)) {
@@ -895,9 +905,6 @@ static inline void sil24_host_intr(struct ata_port *ap)
 		return;
 	}
 
-	if (ap->flags & SIL24_FLAG_PCIX_IRQ_WOC)
-		writel(PORT_IRQ_COMPLETE, port + PORT_IRQ_STAT);
-
 	qc_active = slot_stat & ~HOST_SSTAT_ATTN;
 	rc = ata_qc_complete_multiple(ap, qc_active, sil24_finish_qc);
 	if (rc > 0)
@@ -910,7 +917,8 @@ static inline void sil24_host_intr(struct ata_port *ap)
 		return;
 	}
 
-	if (ata_ratelimit())
+	/* spurious interrupts are expected if PCIX_IRQ_WOC */
+	if (!(ap->flags & SIL24_FLAG_PCIX_IRQ_WOC) && ata_ratelimit())
 		ata_port_printk(ap, KERN_INFO, "spurious interrupt "
 			"(slot_stat 0x%x active_tag %d sactive 0x%x)\n",
 			slot_stat, ap->active_tag, ap->sactive);
