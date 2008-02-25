Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYBYNmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYBYNmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 08:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYBYNl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 08:41:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:24720 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbYBYNl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 08:41:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:message-id:content-type;
        b=labJ7QKDJ5xQpbaIPsahCFP8WNzyMpQawsVaHKnKACT/eqjCFW4KOLXPjU39POME0jM8A9YFIbeBo6Hh0Sk8uBFMEpDBH3WZYHFo7MWISUqpzJ0R2LhzP6AUm2dyeynqNULdYl/xy5Ms186Yq/IZtOWnHttcmR04UeU6F2ygH24=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Brad Rosser" <brad.rosser@gmail.com>
Subject: Re: IDE cdrom problem with PLEXTOR DVDR PX-608AL
Date: Mon, 25 Feb 2008 14:56:17 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: petkovbb@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <426a98560802232138q41d45d52ta515f1b791e937f4@mail.gmail.com> <20080224173451.GB11998@gollum.tnic> <426a98560802241758j7a9be21m5eecc120ada804e4@mail.gmail.com>
In-Reply-To: <426a98560802241758j7a9be21m5eecc120ada804e4@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200802251456.17533.bzolnier@gmail.com>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_BkswHrW1RMyWnl4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_BkswHrW1RMyWnl4
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 25 February 2008, Brad Rosser wrote:

[...]

> Bart wrote:
> 
> > Does the following patch help?
> >
> > [ It makes ireason handling for REQ_TYPE_ATA_PC requests be the same as
> > for other request types so "ireason == 1" quirk is used if needed. ]
> 
> I tried to apply the patch but failed; I probably did something wrong.
> I deleted everything in your message above 'Index: b/drivers/ide/ide-cd.c'
> and ran 'patch --dry-run -b -p1 < ../bart_patch'.  This is part of my script
> log:
> 
> root:/usr/src/linux-2.6.25-rc2# pwd
> /usr/src/linux-2.6.25-rc2
> root:/usr/src/linux-2.6.25-rc2# cat ../bart_patch
> Index: b/drivers/ide/ide-cd.c
> ===================================================================
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -670,8 +670,8 @@ static void cdrom_buffer_sectors (ide_dr
>  * and attempt to recover if there are problems.  Returns  0 if everything's
> ...
> ...
> root:/usr/src/linux-2.6.25-rc2# patch --dry-run -b -p1 < ../bart_patch
> patching file drivers/ide/ide-cd.c
> Hunk #1 FAILED at 670.
> Hunk #2 FAILED at 701.
> Hunk #3 FAILED at 1074.
> Hunk #4 FAILED at 1104.
> 4 out of 4 hunks FAILED -- saving rejects to file drivers/ide/ide-cd.c.rej

Same command works just fine for me with 2.6.25-rc2/3.

It could be that the patch got damaged somewhere on the way
(to eleminate this possibility I'm attaching it to this mail).

Thanks,
Bart

--Boundary-00=_BkswHrW1RMyWnl4
Content-Type: text/x-diff;
  charset="utf-8";
  name="ide-cd-fix-ireason-handling-for-req_type_ata_pc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ide-cd-fix-ireason-handling-for-req_type_ata_pc.patch"

---
 drivers/ide/ide-cd.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -670,8 +670,8 @@ static void cdrom_buffer_sectors (ide_dr
  * and attempt to recover if there are problems.  Returns  0 if everything's
  * ok; nonzero if the request has been terminated.
  */
-static
-int ide_cd_check_ireason(ide_drive_t *drive, int len, int ireason, int rw)
+static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
+				int len, int ireason, int rw)
 {
 	/*
 	 * ireason == 0: the drive wants to receive data from us
@@ -701,6 +701,9 @@ int ide_cd_check_ireason(ide_drive_t *dr
 				drive->name, __FUNCTION__, ireason);
 	}
 
+	if (rq->cmd_type == REQ_TYPE_ATA_PC)
+		rq->cmd_flags |= REQ_FAILED;
+
 	cdrom_end_request(drive, 0);
 	return -1;
 }
@@ -1071,11 +1074,11 @@ static ide_startstop_t cdrom_newpc_intr(
 	/*
 	 * check which way to transfer data
 	 */
-	if (blk_fs_request(rq) || blk_pc_request(rq)) {
-		if (ide_cd_check_ireason(drive, len, ireason, write))
-			return ide_stopped;
+	if (ide_cd_check_ireason(drive, rq, len, ireason, write))
+		return ide_stopped;
 
-		if (blk_fs_request(rq) && write == 0) {
+	if (blk_fs_request(rq)) {
+		if (write == 0) {
 			int nskip;
 
 			if (ide_cd_check_transfer_size(drive, len)) {
@@ -1101,16 +1104,9 @@ static ide_startstop_t cdrom_newpc_intr(
 	if (ireason == 0) {
 		write = 1;
 		xferfunc = HWIF(drive)->atapi_output_bytes;
-	} else if (ireason == 2 || (ireason == 1 &&
-		   (blk_fs_request(rq) || blk_pc_request(rq)))) {
+	} else {
 		write = 0;
 		xferfunc = HWIF(drive)->atapi_input_bytes;
-	} else {
-		printk(KERN_ERR "%s: %s: The drive "
-				"appears confused (ireason = 0x%02x). "
-				"Trying to recover by ending request.\n",
-				drive->name, __FUNCTION__, ireason);
-		goto end_request;
 	}
 
 	/*

--Boundary-00=_BkswHrW1RMyWnl4--
