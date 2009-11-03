Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZKCTgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZKCTgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbZKCTgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:36:22 -0500
Received: from havoc.gtf.org ([69.61.125.42]:38130 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbZKCTgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:36:21 -0500
Date: Tue, 3 Nov 2009 14:36:25 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata minor fixes
Message-ID: <20091103193624.GA2027@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A last few bits for 2.6.32 final.  Two vendor-specific tweaks, and
one fix -- NULL deref -- that is far less serious than it may seem from
the one-line summary.

None of these are screamingly urgent or dire, or regression fixes,
so it is not a big deal if you choose not to pull [until 2.6.33].




Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |   40 +++++++++++++++++++++++++++++++++++-----
 drivers/ata/libata-core.c |    9 ++++++---
 drivers/ata/sata_via.c    |    1 -
 3 files changed, 41 insertions(+), 9 deletions(-)

JosephChan@via.com.tw (1):
      sata_via: Remove redundant device ID for VIA VT8261

Julia Lawall (1):
      drivers/ata/libata: Move dereference after NULL test

Mark Nelson (1):
      ahci: Enable SB600 64bit DMA on MSI K9A2 Platinum v2

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a06f5d6..a3241a1 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -2718,6 +2718,30 @@ static bool ahci_sb600_enable_64bit(struct pci_dev *pdev)
 			},
 			.driver_data = "20071026",	/* yyyymmdd */
 		},
+		/*
+		 * All BIOS versions for the MSI K9A2 Platinum (MS-7376)
+		 * support 64bit DMA.
+		 *
+		 * BIOS versions earlier than 1.5 had the Manufacturer DMI
+		 * fields as "MICRO-STAR INTERANTIONAL CO.,LTD".
+		 * This spelling mistake was fixed in BIOS version 1.5, so
+		 * 1.5 and later have the Manufacturer as
+		 * "MICRO-STAR INTERNATIONAL CO.,LTD".
+		 * So try to match on DMI_BOARD_VENDOR of "MICRO-STAR INTER".
+		 *
+		 * BIOS versions earlier than 1.9 had a Board Product Name
+		 * DMI field of "MS-7376". This was changed to be
+		 * "K9A2 Platinum (MS-7376)" in version 1.9, but we can still
+		 * match on DMI_BOARD_NAME of "MS-7376".
+		 */
+		{
+			.ident = "MSI K9A2 Platinum",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR,
+					  "MICRO-STAR INTER"),
+				DMI_MATCH(DMI_BOARD_NAME, "MS-7376"),
+			},
+		},
 		{ }
 	};
 	const struct dmi_system_id *match;
@@ -2729,18 +2753,24 @@ static bool ahci_sb600_enable_64bit(struct pci_dev *pdev)
 	    !match)
 		return false;
 
+	if (!match->driver_data)
+		goto enable_64bit;
+
 	dmi_get_date(DMI_BIOS_DATE, &year, &month, &date);
 	snprintf(buf, sizeof(buf), "%04d%02d%02d", year, month, date);
 
-	if (strcmp(buf, match->driver_data) >= 0) {
-		dev_printk(KERN_WARNING, &pdev->dev, "%s: enabling 64bit DMA\n",
-			   match->ident);
-		return true;
-	} else {
+	if (strcmp(buf, match->driver_data) >= 0)
+		goto enable_64bit;
+	else {
 		dev_printk(KERN_WARNING, &pdev->dev, "%s: BIOS too old, "
 			   "forcing 32bit DMA, update BIOS\n", match->ident);
 		return false;
 	}
+
+enable_64bit:
+	dev_printk(KERN_WARNING, &pdev->dev, "%s: enabling 64bit DMA\n",
+		   match->ident);
+	return true;
 }
 
 static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d7f0f1b..dc72690 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4919,10 +4919,11 @@ struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev)
  */
 void ata_qc_free(struct ata_queued_cmd *qc)
 {
-	struct ata_port *ap = qc->ap;
+	struct ata_port *ap;
 	unsigned int tag;
 
 	WARN_ON_ONCE(qc == NULL); /* ata_qc_from_tag _might_ return NULL */
+	ap = qc->ap;
 
 	qc->flags = 0;
 	tag = qc->tag;
@@ -4934,11 +4935,13 @@ void ata_qc_free(struct ata_queued_cmd *qc)
 
 void __ata_qc_complete(struct ata_queued_cmd *qc)
 {
-	struct ata_port *ap = qc->ap;
-	struct ata_link *link = qc->dev->link;
+	struct ata_port *ap;
+	struct ata_link *link;
 
 	WARN_ON_ONCE(qc == NULL); /* ata_qc_from_tag _might_ return NULL */
 	WARN_ON_ONCE(!(qc->flags & ATA_QCFLAG_ACTIVE));
+	ap = qc->ap;
+	link = qc->dev->link;
 
 	if (likely(qc->flags & ATA_QCFLAG_DMAMAP))
 		ata_sg_clean(qc);
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index bdd43c7..02efd9a 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -93,7 +93,6 @@ static const struct pci_device_id svia_pci_tbl[] = {
 	{ PCI_VDEVICE(VIA, 0x7372), vt6420 },
 	{ PCI_VDEVICE(VIA, 0x5287), vt8251 }, /* 2 sata chnls (Master/Slave) */
 	{ PCI_VDEVICE(VIA, 0x9000), vt8251 },
-	{ PCI_VDEVICE(VIA, 0x9040), vt8251 },
 
 	{ }	/* terminate list */
 };
