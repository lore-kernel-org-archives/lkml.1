Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820Ab0ALTgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0ALTgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 14:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808Ab0ALTga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 14:36:30 -0500
Received: from havoc.gtf.org ([69.61.125.42]:46430 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab0ALTg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 14:36:28 -0500
Date: Tue, 12 Jan 2010 14:36:25 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20100112193625.GA22031@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is one other fix about to go upstream, for a problem discovered by
Russell King related to PATA.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c     |    2 +-
 drivers/ata/libata-core.c  |   38 +++++++++++++++++++++++++++++++-------
 drivers/ata/sata_promise.c |    2 +-
 include/linux/libata.h     |    3 +++
 4 files changed, 36 insertions(+), 9 deletions(-)

Mikael Pettersson (1):
      sata_promise: don't classify overruns as HSM errors

Tejun Heo (2):
      ata_piix: enable 32bit PIO on SATA piix
      libata: retry link resume if necessary

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 19136a7..6f3f225 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -329,7 +329,7 @@ static struct ata_port_operations ich_pata_ops = {
 };
 
 static struct ata_port_operations piix_sata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 };
 
 static struct ata_port_operations piix_sidpr_sata_ops = {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 22ff51b..6728328 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3790,21 +3790,45 @@ int sata_link_debounce(struct ata_link *link, const unsigned long *params,
 int sata_link_resume(struct ata_link *link, const unsigned long *params,
 		     unsigned long deadline)
 {
+	int tries = ATA_LINK_RESUME_TRIES;
 	u32 scontrol, serror;
 	int rc;
 
 	if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
 		return rc;
 
-	scontrol = (scontrol & 0x0f0) | 0x300;
+	/*
+	 * Writes to SControl sometimes get ignored under certain
+	 * controllers (ata_piix SIDPR).  Make sure DET actually is
+	 * cleared.
+	 */
+	do {
+		scontrol = (scontrol & 0x0f0) | 0x300;
+		if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
+			return rc;
+		/*
+		 * Some PHYs react badly if SStatus is pounded
+		 * immediately after resuming.  Delay 200ms before
+		 * debouncing.
+		 */
+		msleep(200);
 
-	if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
-		return rc;
+		/* is SControl restored correctly? */
+		if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
+			return rc;
+	} while ((scontrol & 0xf0f) != 0x300 && --tries);
 
-	/* Some PHYs react badly if SStatus is pounded immediately
-	 * after resuming.  Delay 200ms before debouncing.
-	 */
-	msleep(200);
+	if ((scontrol & 0xf0f) != 0x300) {
+		ata_link_printk(link, KERN_ERR,
+				"failed to resume link (SControl %X)\n",
+				scontrol);
+		return 0;
+	}
+
+	if (tries < ATA_LINK_RESUME_TRIES)
+		ata_link_printk(link, KERN_WARNING,
+				"link resume succeeded after %d retries\n",
+				ATA_LINK_RESUME_TRIES - tries);
 
 	if ((rc = sata_link_debounce(link, params, deadline)))
 		return rc;
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 07d8d00..6330628 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -862,7 +862,7 @@ static void pdc_error_intr(struct ata_port *ap, struct ata_queued_cmd *qc,
 	if (port_status & PDC_DRIVE_ERR)
 		ac_err_mask |= AC_ERR_DEV;
 	if (port_status & (PDC_OVERRUN_ERR | PDC_UNDERRUN_ERR))
-		ac_err_mask |= AC_ERR_HSM;
+		ac_err_mask |= AC_ERR_OTHER;
 	if (port_status & (PDC2_ATA_HBA_ERR | PDC2_ATA_DMA_CNT_ERR))
 		ac_err_mask |= AC_ERR_ATA_BUS;
 	if (port_status & (PDC_PH_ERR | PDC_SH_ERR | PDC_DH_ERR | PDC2_HTO_ERR
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 6a9c4dd..7311225 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -354,6 +354,9 @@ enum {
 	/* max tries if error condition is still set after ->error_handler */
 	ATA_EH_MAX_TRIES	= 5,
 
+	/* sometimes resuming a link requires several retries */
+	ATA_LINK_RESUME_TRIES	= 5,
+
 	/* how hard are we gonna try to probe/recover devices */
 	ATA_PROBE_MAX_TRIES	= 3,
 	ATA_EH_DEV_TRIES	= 3,
