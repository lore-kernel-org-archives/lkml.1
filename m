Return-Path: <linux-kernel-owner+w=401wt.eu-S1762947AbXFKE7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762947AbXFKE7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 00:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbXFKE73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 00:59:29 -0400
Received: from havoc.gtf.org ([69.61.125.42]:39712 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbXFKE72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 00:59:28 -0400
Date: Mon, 11 Jun 2007 00:59:27 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] more libata fixes
Message-ID: <20070611045927.GA23626@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following is CUMULATIVE to the previous push, but in the same linear
history.  IOW, pulling 'linus-plus-plus' also gets you 'upstream-linus'.
But if you have already pulled 'upstream-linus', you will only receive
these two changesets.

Please pull from branch 'linus-plus-plus' of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git linus-plus-plus

to receive the following changes:

 drivers/ata/libata-core.c |   33 ++++++++++++++++++++-------------
 1 files changed, 20 insertions(+), 13 deletions(-)

Tejun Heo (2):
      libata: force PIO on IOMEGA ZIP 250 ATAPI
      libata: limit post SRST nsect/lbal wait to ~100ms

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4b3c45e..047eabd 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3061,22 +3061,28 @@ static int ata_bus_post_reset(struct ata_port *ap, unsigned int devmask,
 		}
 	}
 
-	/* if device 1 was found in ata_devchk, wait for
-	 * register access, then wait for BSY to clear
+	/* if device 1 was found in ata_devchk, wait for register
+	 * access briefly, then wait for BSY to clear.
 	 */
-	while (dev1) {
-		u8 nsect, lbal;
+	if (dev1) {
+		int i;
 
 		ap->ops->dev_select(ap, 1);
-		nsect = ioread8(ioaddr->nsect_addr);
-		lbal = ioread8(ioaddr->lbal_addr);
-		if ((nsect == 1) && (lbal == 1))
-			break;
-		if (time_after(jiffies, deadline))
-			return -EBUSY;
-		msleep(50);	/* give drive a breather */
-	}
-	if (dev1) {
+
+		/* Wait for register access.  Some ATAPI devices fail
+		 * to set nsect/lbal after reset, so don't waste too
+		 * much time on it.  We're gonna wait for !BSY anyway.
+		 */
+		for (i = 0; i < 2; i++) {
+			u8 nsect, lbal;
+
+			nsect = ioread8(ioaddr->nsect_addr);
+			lbal = ioread8(ioaddr->lbal_addr);
+			if ((nsect == 1) && (lbal == 1))
+				break;
+			msleep(50);	/* give drive a breather */
+		}
+
 		rc = ata_wait_ready(ap, deadline);
 		if (rc) {
 			if (rc != -ENODEV)
@@ -3771,6 +3777,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "_NEC DV5800A", 	NULL,		ATA_HORKAGE_NODMA },
 	{ "SAMSUNG CD-ROM SN-124","N001",	ATA_HORKAGE_NODMA },
 	{ "Seagate STT20000A", NULL,		ATA_HORKAGE_NODMA },
+	{ "IOMEGA  ZIP 250       ATAPI", NULL,	ATA_HORKAGE_NODMA }, /* temporary fix */
 
 	/* Weird ATAPI devices */
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 |
