Return-Path: <linux-kernel-owner+w=401wt.eu-S935517AbZDCTvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935517AbZDCTvD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 15:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765369AbZDCTuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 15:50:40 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62482 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZDCTue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 15:50:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=nPOklktMfiF6nIcLpRC8nigPmzgAxd0irVMsBWTpJUgNPjej3HroYULaoVk/IIEck1
         ZMWVkGa2Zg1XMvBnLOQEDnDAp9bw3pK34ORTU62gpRg1MDyMFHuy6zfl0J/Je9ywukNL
         hT9URhny0EL0/CyPyceReGfW4ub2pB3zbI8Ek=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 2/3] ide-cd: cleanup cdrom_decode_status
Date: Fri, 3 Apr 2009 21:39:38 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090402; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1238655519-10074-2-git-send-email-petkovbb@gmail.com> <200904031241.44597.bzolnier@gmail.com> <9ea470500904030703k9285e0eye5487f825df77e6@mail.gmail.com>
In-Reply-To: <9ea470500904030703k9285e0eye5487f825df77e6@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904032139.38756.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009, Borislav Petkov wrote:
> On Fri, Apr 3, 2009 at 12:41 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> > On Friday 03 April 2009, Borislav Petkov wrote:
> >> Hi,
> >>
> >> On Fri, Apr 03, 2009 at 01:08:39AM +0200, Bartlomiej Zolnierkiewicz wrote:
> >> > On Thursday 02 April 2009, Borislav Petkov wrote:
> >> > > - have (almost) equal handling of commands based solely on sense_key
> >> >
> >> > I'm having a VERY hard time trying to review this patch because at
> >> > the same time that codepaths were merged if()s were replaced by switch()
> >> > which in turn resulted in change of intendation... on top of that
> >> > the patch description is very vague about this part of the changes...
> >>
> >> I completely and exactly understand what you are saying :), I thought so
> >> too when I looked at the diffs yesterday. Well, if it's any consolation, the
> >> patches've been tested so they seem to work :). Anyway, split version coming
> >> up...
> >
> > The split version looks exactly the same except ide_cd_breathe() change
> > when it comes to the main part.
> >
> > Did you send the wrong version by any chance?
> 
> No, but I can't split those changes anymore logically. The switch-case handles
> the differentiation based on the sense_key and as such cannot be broken down
> anymore without doing some weird stuff and possibly introducing more bugs and

Since this didn't convince me...

> breaking bisectability. Completely hypothetically: wouldn't a before-after
> juxtaposition of the change make reviewing more easier, for example you
> apply the patch on a different branch and compare the before and the after
> version?

...and this would make me spend a whole weekend trying to track down every
little change in code's behavior I went ahead and re-did your patch splitting
it on a more fine-grained logical changes (posted in separate patchset, while
at it I also fixed REQ_QUIET handling for fs requests).

After that I did a diff between ide-cd.c.old_patch and ide-cd.c.new_patchset
and besides some trivial differences I indeed found some subtle problems...

--- ide-cd.c.old_patch	2009-04-03 18:50:23.000000000 +0200
+++ ide-cd.c.new_patchset	2009-04-03 21:12:02.000000000 +0200
@@ -311,7 +311,7 @@
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
-	int err, sense_key, do_end_request;
+	int err, sense_key, do_end_request = 0;
 
 	/* get the IDE error register */
 	err = ide_read_error(drive);
@@ -331,90 +331,104 @@
 		return 2;
 	}
 
-	/* if we got an error, pass CHECK_CONDITION as the scsi status byte */
+	/* if we got an error, pass CHECK_CONDITION as the SCSI status byte */
 	if (blk_pc_request(rq) && !rq->errors)
 		rq->errors = SAM_STAT_CHECK_CONDITION;
 
 	if (blk_noretry_request(rq))
-			do_end_request = 1;
+		do_end_request = 1;
 
 	switch (sense_key) {
 	case NOT_READY:
-		if (blk_fs_request(rq) && (rq_data_dir(rq) == WRITE)) {
+		if (blk_fs_request(rq) == 0 || rq_data_dir(rq) == READ) {
+			cdrom_saw_media_change(drive);
+
+			if (blk_fs_request(rq) &&
+			    (rq->cmd_flags & REQ_QUIET) == 0)
+				printk(KERN_ERR PFX "%s: tray open\n",
+					drive->name);
+		} else {
 			if (ide_cd_breathe(drive, rq))
 				return 1;
-		} else {
-			cdrom_saw_media_change(drive);
-			printk(KERN_ERR PFX "%s: tray open\n", drive->name);

original code didn't spam logs for pc requests

 		}
 		do_end_request = 1;
 		break;
-
 	case UNIT_ATTENTION:
 		cdrom_saw_media_change(drive);
-		if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC)
+
+		if (blk_fs_request(rq) == 0)
 			return 0;
+		/*
+		 * Arrange to retry the request but be sure to give up if we've
+		 * retried too many times.
+		 */
+		if (++rq->errors > ERROR_MAX)
+			do_end_request = 1;
 		break;
-
 	case ILLEGAL_REQUEST:
-	case DATA_PROTECT:
 		/*
-		 * Don't print error message for this condition since SFF8090i
+		 * Don't print error message for this condition -- SFF8090i
 		 * indicates that 5/24/00 is the correct response to a request
 		 * to close the tray if the drive doesn't have that capability.
 		 *
 		 * cdrom_log_sense() knows this!
 		 */
-		if (rq->cmd[0] != GPCMD_START_STOP_UNIT) {
+		if (rq->cmd[0] == GPCMD_START_STOP_UNIT)

this was checked only for ILLEGAL_REQUEST and not DATA_PROTECT

+			break;
+		/* fall-through */
+	case DATA_PROTECT:
+		/*
+		 * No point in retrying after an illegal request or data
+		 * protect error.
+		 */
+		if ((rq->cmd_flags & REQ_QUIET) == 0)
 			ide_dump_status(drive, "command error", stat);

original code respected REQ_QUIET for pc requests

-			do_end_request = 1;
-		}
+		do_end_request = 1;
 		break;
-
 	case MEDIUM_ERROR:
 		/*
-		 * No point in re-trying a zillion times on a bad sector. If we
-		 * got here the error is not correctable.
+		 * No point in re-trying a zillion times on a bad sector.
+		 * If we got here the error is not correctable.
 		 */
-		ide_dump_status(drive, "media error (bad sector)", stat);
+		if ((rq->cmd_flags & REQ_QUIET) == 0)
+			ide_dump_status(drive, "media error "
+					"(bad sector)", stat);

ditto

 		do_end_request = 1;
 		break;
-
 	case BLANK_CHECK:
-		/* disk appears blank ?? */
-		ide_dump_status(drive, "media error (blank)", stat);
+		/* disk appears blank? */
+		if ((rq->cmd_flags & REQ_QUIET) == 0)
+			ide_dump_status(drive, "media error (blank)",
+					stat);

ditto

 		do_end_request = 1;
 		break;
-
 	default:
+		if (blk_fs_request(rq) == 0)
+			break;
 		if (err & ~ATA_ABORTED) {
 			/* go to the default handler for other errors */
 			ide_error(drive, "cdrom_decode_status", stat);
 			return 1;

we can think about doing this also for pc requests but original code
didn't do it so we shouldn't mix it with purely cleanup changes

-		}
-
-		if (!(rq->cmd_flags & REQ_QUIET)) {
-			ide_dump_status(drive, "command error", stat);
-			blk_dump_rq_flags(rq, PFX "failing rq");
-		}
-
-		do_end_request = 1;

this looks like a real regression -- in such situation original code
ended fs requests only if (++rq->errors > ERROR_MAX)

-		break;
+		} else if (++rq->errors > ERROR_MAX)
+			/* we've racked up too many retries, abort */
+			do_end_request = 1;
 	}
 
-	/* we've racked up too many retries, abort */
-	if (++rq->errors > ERROR_MAX)
+	if (blk_fs_request(rq) == 0) {
+		rq->cmd_flags |= REQ_FAILED;
 		do_end_request = 1;
+	}
 
-	if (do_end_request) {
-		rq->cmd_flags |= REQ_FAILED;

we may set this flag also for fs requests but separate patch is preferred

+	/*
+	 * End a request through request sense analysis when we have sense data.
+	 * We need this in order to perform end of media processing.
+	 */
+	if (do_end_request)
 		goto end_request;
-	}
 
-	/* If we got a CHECK_CONDITION status, queue a request sense command. */
+	/* if we got a CHECK_CONDITION status, queue a request sense command */
 	if (stat & ATA_ERR)
 		cdrom_queue_request_sense(drive, NULL, NULL);
-
 	return 1;
 
 end_request:

