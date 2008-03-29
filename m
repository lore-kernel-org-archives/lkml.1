Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbYC2UKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbYC2UKF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 16:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYC2UJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 16:09:53 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53741 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbYC2UJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 16:09:53 -0400
Date: Sat, 29 Mar 2008 16:09:52 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080329200952.GA5206@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c |    2 +-
 drivers/ata/libata-eh.c   |    2 +-
 drivers/ata/pata_sil680.c |    6 +++++-
 include/linux/libata.h    |    2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)

Benjamin Herrenschmidt (1):
      pata_sil680: only enable MMIO on Cell blades

Tejun Heo (1):
      libata: ATA_EHI_LPM should be ATA_EH_LPM

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c4248b3..4851988 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -972,7 +972,7 @@ static void ata_dev_disable_pm(struct ata_device *dev)
 void ata_lpm_schedule(struct ata_port *ap, enum link_pm policy)
 {
 	ap->pm_policy = policy;
-	ap->link.eh_info.action |= ATA_EHI_LPM;
+	ap->link.eh_info.action |= ATA_EH_LPM;
 	ap->link.eh_info.flags |= ATA_EHI_NO_AUTOPSY;
 	ata_port_schedule_eh(ap);
 }
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 681252f..a583032 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2748,7 +2748,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 			ehc->i.flags &= ~ATA_EHI_SETMODE;
 		}
 
-		if (ehc->i.action & ATA_EHI_LPM)
+		if (ehc->i.action & ATA_EH_LPM)
 			ata_link_for_each_dev(dev, link)
 				ata_dev_enable_pm(dev, ap->pm_policy);
 
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 503245a..3988e44 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -269,7 +269,11 @@ static u8 sil680_init_chip(struct pci_dev *pdev, int *try_mmio)
 	dev_dbg(&pdev->dev, "sil680: BA5_EN = %d clock = %02X\n",
 		tmpbyte & 1, tmpbyte & 0x30);
 
-	*try_mmio = (tmpbyte & 1) || pci_resource_start(pdev, 5);
+	*try_mmio = 0;
+#ifdef CONFIG_PPC
+	if (machine_is(cell))
+		*try_mmio = (tmpbyte & 1) || pci_resource_start(pdev, 5);
+#endif
 
 	switch(tmpbyte & 0x30) {
 		case 0x00:
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 269cdba..b064bfe 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -295,6 +295,7 @@ enum {
 	ATA_EH_SOFTRESET	= (1 << 1),
 	ATA_EH_HARDRESET	= (1 << 2),
 	ATA_EH_ENABLE_LINK	= (1 << 3),
+	ATA_EH_LPM		= (1 << 4),  /* link power management action */
 
 	ATA_EH_RESET_MASK	= ATA_EH_SOFTRESET | ATA_EH_HARDRESET,
 	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE,
@@ -304,7 +305,6 @@ enum {
 	ATA_EHI_RESUME_LINK	= (1 << 1),  /* resume link (reset modifier) */
 	ATA_EHI_NO_AUTOPSY	= (1 << 2),  /* no autopsy */
 	ATA_EHI_QUIET		= (1 << 3),  /* be quiet */
-	ATA_EHI_LPM		= (1 << 4),  /* link power management action */
 
 	ATA_EHI_DID_SOFTRESET	= (1 << 16), /* already soft-reset this port */
 	ATA_EHI_DID_HARDRESET	= (1 << 17), /* already soft-reset this port */
