Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbXENP0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbXENP0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 11:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbXENP0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 11:26:33 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:28519 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbXENP0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 11:26:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=OKeBkaox1LrGe49B4SsV70vq+kzE/UZvPzb8gyd3Yk4ou5SkQ7RBCZAIvEms+orCZ660TbxnypdWyYEcZuEklhtKXh60nK9hgpS+Dfau1caHPk79d6rbcY644ndJ0g0+hAMd9gmdnnjQ8NwDIZdElIZNnWsa5YT6WvSki1g0DcU=
Message-ID: <46487F9A.1080309@gmail.com>
Date: Mon, 14 May 2007 17:26:18 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] libata: fix shutdown warning message printing
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unlocking ap->lock and ssleeping don't work because SCSI commands can
be issued from completion path without context.  Reimplement delayed
completion by allowing translation functions to override
qc->scsidone(), storing the original completion function to
scmd->scsi_done() and overriding qc->scsidone() with a function which
schedules delayed invocation of scmd->scsi_done().

This isn't pretty at all but all the ugly parts are thankfully
contained in the stop translation path where the compat feature is
implemented.

Signed-off-by: Tejun Heo <htejun@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index dd81fa7..07b5a3d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -893,6 +893,23 @@ int ata_scsi_change_queue_depth(struct s
 	return queue_depth;
 }
 
+/* XXX: for ata_spindown_compat */
+static void ata_delayed_done_timerfn(unsigned long arg)
+{
+	struct scsi_cmnd *scmd = (void *)arg;
+
+	scmd->scsi_done(scmd);
+}
+
+/* XXX: for ata_spindown_compat */
+static void ata_delayed_done(struct scsi_cmnd *scmd)
+{
+	static struct timer_list timer;
+
+	setup_timer(&timer, ata_delayed_done_timerfn, (unsigned long)scmd);
+	mod_timer(&timer, jiffies + 5 * HZ);
+}
+
 /**
  *	ata_scsi_start_stop_xlat - Translate SCSI START STOP UNIT command
  *	@qc: Storage for translated ATA taskfile
@@ -952,19 +969,21 @@ static unsigned int ata_scsi_start_stop_
 		if (ata_spindown_compat &&
 		    (system_state == SYSTEM_HALT ||
 		     system_state == SYSTEM_POWER_OFF)) {
-			static int warned = 0;
+			static unsigned long warned = 0;
 
-			if (!warned) {
-				spin_unlock_irq(qc->ap->lock);
+			if (!test_and_set_bit(0, &warned)) {
 				ata_dev_printk(qc->dev, KERN_WARNING,
 					"DISK MIGHT NOT BE SPUN DOWN PROPERLY. "
 					"UPDATE SHUTDOWN UTILITY\n");
 				ata_dev_printk(qc->dev, KERN_WARNING,
 					"For more info, visit "
 					"http://linux-ata.org/shutdown.html\n");
-				warned = 1;
-				ssleep(5);
-				spin_lock_irq(qc->ap->lock);
+
+				/* ->scsi_done is not used, use it for
+				 * delayed completion.
+				 */
+				scmd->scsi_done = qc->scsidone;
+				qc->scsidone = ata_delayed_done;
 			}
 			scmd->result = SAM_STAT_GOOD;
 			return 1;
@@ -1488,14 +1507,14 @@ static int ata_scsi_translate(struct ata
 
 early_finish:
         ata_qc_free(qc);
-	done(cmd);
+	qc->scsidone(cmd);
 	DPRINTK("EXIT - early finish (good or error)\n");
 	return 0;
 
 err_did:
 	ata_qc_free(qc);
 	cmd->result = (DID_ERROR << 16);
-	done(cmd);
+	qc->scsidone(cmd);
 err_mem:
 	DPRINTK("EXIT - internal\n");
 	return 0;
