Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbZDFTjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbZDFTjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbZDFTjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:39:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:60899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbZDFTjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:39:09 -0400
Message-ID: <49DA5A83.2070002@kernel.org>
Date: Mon, 06 Apr 2009 12:39:47 -0700
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <ckpL0-3TE-3@gated-at.bofh.it> <ckpL0-3TE-5@gated-at.bofh.it> <ckpL0-3TE-7@gated-at.bofh.it> <ckpL0-3TE-9@gated-at.bofh.it> <ckpL0-3TE-11@gated-at.bofh.it> <ckpL0-3TE-1@gated-at.bofh.it> <cllvN-2Gf-1@gated-at.bofh.it> <49D0D788.6070405@gmail.com> <49D419E8.2080603@kernel.org> <49D4591B.3070807@gmail.com> <49D46096.1040701@kernel.org> <49D49B8A.7070408@gmail.com> <49D4C886.1010101@gmail.com> <49D6E7FA.3000306@kernel.org> <49D98C9E.2000507@gmail.com> <49D9D4D8.2020608@kernel.org> <49DA489E.1030801@gmail.com>
In-Reply-To: <49DA489E.1030801@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------050207060705030502050009"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 06 Apr 2009 19:39:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050207060705030502050009
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

Niel Lambrechts wrote:
> On 04/06/2009 12:09 PM, Tejun Heo wrote:
>>> Will the fix naturally make its way into the mainline kernel, or is
>>> there any extra debugging/testing I can help with?
>>>     
>> Well, the problem is the debug patch doesn't actually do anything
>> other than printing out messages.  It could be that the problem is
>> timing dependent (which is likely anyway).  You still can reporduce
>> the problem with the patch, right?
>>   
> Heh? You provided two patches, with the last one you said:

Yeah, the second one actually only added printks to see whether that's
the case.  No behavior change.

>> Strange.  Maybe IO commands are getting through while the sdev is
>> still in quiesce state?  Can you please repeat the test with the
>> attached patch?
>
> With the latter, I have not encountered the original problem i.e. any
> severe EXT4 corruption again, not in 2.6.29 and not in 2.6.29.1.

Eh... so, we're definitely seeing something which is dependent on
timing.

> Do I also need to try the last patch without any debugging messages?

Then there will be nothing left.  :-) Can you please try the attached
patch?  It's still only debug messages but lighter; hopefully, it
won't mask the problem.

Thanks.

-- 
tejun

--------------050207060705030502050009
Content-Type: text/x-patch;
 name="libata-eh-debug-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata-eh-debug-2.patch"

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 0183131..2782bad 100644
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
+			/*ata_dev_printk(qc->dev, KERN_INFO,
+			  "XXX setting retry on qc%d\n", tag);*/
 			qc->flags |= ATA_QCFLAG_RETRY;
+		} else
+			/*ata_dev_printk(qc->dev, KERN_INFO,
+			  "XXX no retry for qc%d\n", tag)*/;
 
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
+				/*ata_dev_printk(qc->dev, KERN_INFO, "XXX retrying qc%d, retries=%d allowed=%d\n",
+				  tag, qc->scsicmd->retries, qc->scsicmd->allowed);*/
 				ata_eh_qc_retry(qc);
-			else
+			} else {
+				/*ata_dev_printk(qc->dev, KERN_INFO, "XXX terminating qc%d\n", tag);*/
 				ata_eh_qc_complete(qc);
+			}
 		} else {
 			if (qc->flags & ATA_QCFLAG_SENSE_VALID) {
+				/*ata_dev_printk(qc->dev, KERN_INFO, "XXX terminating qc%d (SENSE), retries=%d\n",
+				  tag, qc->scsicmd->retries);*/
 				ata_eh_qc_complete(qc);
 			} else {
 				/* feed zero TF to sense generation */
 				memset(&qc->result_tf, 0, sizeof(qc->result_tf));
+				/*ata_dev_printk(qc->dev, KERN_INFO, "XXX retrying qc%d (bogus SENSE)\n", tag);*/
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

--------------050207060705030502050009--
