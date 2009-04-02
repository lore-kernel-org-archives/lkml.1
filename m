Return-Path: <linux-kernel-owner+w=401wt.eu-S1761057AbZDBGw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761057AbZDBGw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZDBGwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:52:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:45313 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbZDBGwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:52:13 -0400
Message-ID: <49D46096.1040701@kernel.org>
Date: Thu, 02 Apr 2009 15:52:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <ckpL0-3TE-3@gated-at.bofh.it> <ckpL0-3TE-5@gated-at.bofh.it> <ckpL0-3TE-7@gated-at.bofh.it> <ckpL0-3TE-9@gated-at.bofh.it> <ckpL0-3TE-11@gated-at.bofh.it> <ckpL0-3TE-1@gated-at.bofh.it> <cllvN-2Gf-1@gated-at.bofh.it> <49D0D788.6070405@gmail.com> <49D419E8.2080603@kernel.org> <49D4591B.3070807@gmail.com>
In-Reply-To: <49D4591B.3070807@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------000906040507040004080207"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 06:52:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000906040507040004080207
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Niel Lambrechts wrote:
>> Attached is the debug patch.  Please reproduce the problem with the
>> patch applied and post full kernel log.
>>   
> Hi there,
> 
> Here is the output, it took 2 attempts to reproduce the EXT4 corruption
> (clean with errors).

Strange.  Maybe IO commands are getting through while the sdev is
still in quiesce state?  Can you please repeat the test with the
attached patch?

Thanks.

-- 
tejun

--------------000906040507040004080207
Content-Type: text/x-patch;
 name="libata-eh-debug-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata-eh-debug-1.patch"

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 0183131..87f5f4e 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1274,7 +1274,7 @@ void ata_eh_about_to_do(struct ata_link *link, struct ata_device *dev,
 {
 	struct ata_port *ap = link->ap;
 	struct ata_eh_info *ehi = &link->eh_info;
-	struct ata_eh_context *ehc = &link->eh_context;
+	//struct ata_eh_context *ehc = &link->eh_context;
 	unsigned long flags;
 
 	spin_lock_irqsave(ap->lock, flags);
@@ -1284,7 +1284,7 @@ void ata_eh_about_to_do(struct ata_link *link, struct ata_device *dev,
 	/* About to take EH action, set RECOVERED.  Ignore actions on
 	 * slave links as master will do them again.
 	 */
-	if (!(ehc->i.flags & ATA_EHI_QUIET) && link != ap->slave_link)
+	if (/*!(ehc->i.flags & ATA_EHI_QUIET) && */link != ap->slave_link)
 		ap->pflags |= ATA_PFLAG_RECOVERED;
 
 	spin_unlock_irqrestore(ap->lock, flags);
@@ -2017,8 +2017,13 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 
 		/* determine whether the command is worth retrying */
 		if (!(qc->err_mask & AC_ERR_INVALID) &&
-		    ((qc->flags & ATA_QCFLAG_IO) || qc->err_mask != AC_ERR_DEV))
+		    ((qc->flags & ATA_QCFLAG_IO) || qc->err_mask != AC_ERR_DEV)) {
+			ata_dev_printk(qc->dev, KERN_INFO,
+				       "XXX setting retry on qc%d\n", tag);
 			qc->flags |= ATA_QCFLAG_RETRY;
+		} else
+			ata_dev_printk(qc->dev, KERN_INFO,
+				       "XXX no retry for qc%d\n", tag);
 
 		/* accumulate error info */
 		ehc->i.dev = qc->dev;
@@ -2126,8 +2131,8 @@ static void ata_eh_link_report(struct ata_link *link)
 	char tries_buf[6];
 	int tag, nr_failed = 0;
 
-	if (ehc->i.flags & ATA_EHI_QUIET)
-		return;
+	/*if (ehc->i.flags & ATA_EHI_QUIET)
+		return;*/
 
 	desc = NULL;
 	if (ehc->i.desc[0] != '\0')
@@ -2147,8 +2152,8 @@ static void ata_eh_link_report(struct ata_link *link)
 		nr_failed++;
 	}
 
-	if (!nr_failed && !ehc->i.err_mask)
-		return;
+	/*if (!nr_failed && !ehc->i.err_mask)
+		return;*/
 
 	frozen = "";
 	if (ap->pflags & ATA_PFLAG_FROZEN)
@@ -3350,16 +3355,23 @@ void ata_eh_finish(struct ata_port *ap)
 			 * generate sense data in this function,
 			 * considering both err_mask and tf.
 			 */
-			if (qc->flags & ATA_QCFLAG_RETRY)
+			if (qc->flags & ATA_QCFLAG_RETRY) {
+				ata_dev_printk(qc->dev, KERN_INFO, "XXX retrying qc%d, retries=%d allowed=%d\n",
+					       tag, qc->scsicmd->retries, qc->scsicmd->allowed);
 				ata_eh_qc_retry(qc);
-			else
+			} else {
+				ata_dev_printk(qc->dev, KERN_INFO, "XXX terminating qc%d\n", tag);
 				ata_eh_qc_complete(qc);
+			}
 		} else {
 			if (qc->flags & ATA_QCFLAG_SENSE_VALID) {
+				ata_dev_printk(qc->dev, KERN_INFO, "XXX terminating qc%d (SENSE), retries=%d\n",
+					       tag, qc->scsicmd->retries);
 				ata_eh_qc_complete(qc);
 			} else {
 				/* feed zero TF to sense generation */
 				memset(&qc->result_tf, 0, sizeof(qc->result_tf));
+				ata_dev_printk(qc->dev, KERN_INFO, "XXX retrying qc%d (bogus SENSE)\n", tag);
 				ata_eh_qc_retry(qc);
 			}
 		}
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 0c2c73b..608bacd 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1569,13 +1569,16 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
+		printk("XXX scsi_eh_flush_done_q: online=%d(%d) noretry=%d retries=%d allowed=%d\n",
+		       scsi_device_online(scmd->device), scmd->device->sdev_state,
+		       scsi_noretry_cmd(scmd), scmd->retries, scmd->allowed);
 		if (scsi_device_online(scmd->device) &&
 		    !scsi_noretry_cmd(scmd) &&
 		    (++scmd->retries <= scmd->allowed)) {
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
+			/*SCSI_LOG_ERROR_RECOVERY(3, */printk("%s: flush"
 							  " retry cmd: %p\n",
 							  current->comm,
-							  scmd));
+							      scmd)/*)*/;
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
 		} else {
 			/*
@@ -1585,9 +1588,9 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 			 */
 			if (!scmd->result)
 				scmd->result |= (DRIVER_TIMEOUT << 24);
-			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
+			/*SCSI_LOG_ERROR_RECOVERY(3,*/ printk("%s: flush finish"
 							" cmd: %p\n",
-							current->comm, scmd));
+							      current->comm, scmd)/*)*/;
 			scsi_finish_command(scmd);
 		}
 	}

--------------000906040507040004080207--
