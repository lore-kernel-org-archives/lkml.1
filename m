Return-Path: <linux-kernel-owner+w=401wt.eu-S1751255AbZGODKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbZGODKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 23:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbZGODJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 23:09:59 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57218 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZGODJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 23:09:58 -0400
Date: Tue, 14 Jul 2009 23:09:57 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20090715030957.GA32701@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |    1 +
 drivers/ata/libata-core.c |   20 ++++++++++++++++++--
 drivers/ata/libata-eh.c   |    4 ++++
 drivers/ata/pata_at91.c   |    3 ++-
 include/linux/libata.h    |    1 +
 5 files changed, 26 insertions(+), 3 deletions(-)

Julia Lawall (1):
      drivers/ata: Move a dereference below a NULL test

Mark Goodwin (1):
      ahci: add device ID for 82801JI sata controller

Tejun Heo (2):
      libata: fix follow-up SRST failure path
      libata: implement and use HORKAGE_NOSETXFER, take#2

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 15a2303..336eb1e 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -513,6 +513,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x502a), board_ahci }, /* Tolapai */
 	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
 	{ PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
+	{ PCI_VDEVICE(INTEL, 0x3a22), board_ahci }, /* ICH10 */
 	{ PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */
 	{ PCI_VDEVICE(INTEL, 0x3b24), board_ahci }, /* PCH RAID */
 	{ PCI_VDEVICE(INTEL, 0x3b25), board_ahci }, /* PCH RAID */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 045a486..2c6aeda 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3392,17 +3392,27 @@ int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel)
 
 static int ata_dev_set_mode(struct ata_device *dev)
 {
+	struct ata_port *ap = dev->link->ap;
 	struct ata_eh_context *ehc = &dev->link->eh_context;
+	const bool nosetxfer = dev->horkage & ATA_HORKAGE_NOSETXFER;
 	const char *dev_err_whine = "";
 	int ign_dev_err = 0;
-	unsigned int err_mask;
+	unsigned int err_mask = 0;
 	int rc;
 
 	dev->flags &= ~ATA_DFLAG_PIO;
 	if (dev->xfer_shift == ATA_SHIFT_PIO)
 		dev->flags |= ATA_DFLAG_PIO;
 
-	err_mask = ata_dev_set_xfermode(dev);
+	if (nosetxfer && ap->flags & ATA_FLAG_SATA && ata_id_is_sata(dev->id))
+		dev_err_whine = " (SET_XFERMODE skipped)";
+	else {
+		if (nosetxfer)
+			ata_dev_printk(dev, KERN_WARNING,
+				       "NOSETXFER but PATA detected - can't "
+				       "skip SETXFER, might malfunction\n");
+		err_mask = ata_dev_set_xfermode(dev);
+	}
 
 	if (err_mask & ~AC_ERR_DEV)
 		goto fail;
@@ -4297,6 +4307,12 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* Devices which aren't very happy with higher link speeds */
 	{ "WD My Book",			NULL,	ATA_HORKAGE_1_5_GBPS, },
 
+	/*
+	 * Devices which choke on SETXFER.  Applies only if both the
+	 * device and controller are SATA.
+	 */
+	{ "PIONEER DVD-RW  DVRTD08",	"1.00",	ATA_HORKAGE_NOSETXFER },
+
 	/* End Marker */
 	{ }
 };
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index fa22f94..1a07c06 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2517,6 +2517,10 @@ int ata_eh_reset(struct ata_link *link, int classify,
 
 			ata_eh_about_to_do(link, NULL, ATA_EH_RESET);
 			rc = ata_do_reset(link, reset, classes, deadline, true);
+			if (rc) {
+				failed_link = link;
+				goto fail;
+			}
 		}
 	} else {
 		if (verbose)
diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index 4b27617..8561a9f 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -312,11 +312,12 @@ err_ide_ioremap:
 static int __devexit pata_at91_remove(struct platform_device *pdev)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	struct at91_ide_info *info = host->private_data;
+	struct at91_ide_info *info;
 	struct device *dev = &pdev->dev;
 
 	if (!host)
 		return 0;
+	info = host->private_data;
 
 	ata_host_detach(host);
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3d501db..79b6d7f 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -385,6 +385,7 @@ enum {
 						    not multiple of 16 bytes */
 	ATA_HORKAGE_FIRMWARE_WARN = (1 << 12),	/* firmware update warning */
 	ATA_HORKAGE_1_5_GBPS	= (1 << 13),	/* force 1.5 Gbps */
+	ATA_HORKAGE_NOSETXFER	= (1 << 14),	/* skip SETXFER, SATA only */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
