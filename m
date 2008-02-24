Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbYBXSCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbYBXSCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbYBXSB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:01:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:55855 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbYBXSB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:01:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=dg/AmjLuf1fr7uoXrLCYNovp/Vs8xhINABlY96SiDcmrrt7jACsYqlP4nZh9qaXrj81s1unqoAtaFbSCb875cVgH9eyv8c6BnVk6icqmfQBMVqsB6E6o8i8Y3BG0L5dEXjRhePEuHDPdXILrDlXtj4RGPFruxslq9TN3CJYpE8c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: IDE cdrom problem with PLEXTOR DVDR PX-608AL
Date: Sun, 24 Feb 2008 19:16:12 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Brad Rosser <brad.rosser@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <426a98560802232138q41d45d52ta515f1b791e937f4@mail.gmail.com> <20080224173451.GB11998@gollum.tnic>
In-Reply-To: <20080224173451.GB11998@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802241916.12546.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 February 2008, Borislav Petkov wrote:
> On Sun, Feb 24, 2008 at 03:38:34PM +1000, Brad Rosser wrote:

[...]

> > kernel: hda: cdrom_pc_intr: The drive appears confused (ireason =
> > 0x01). Trying to recover by ending request.
> > last message repeated 3 times
> > kernel: ide: failed opcode was: unknown
> > kernel: hda: drive not ready for command
> > kernel: hda: status error: status=0x58 { DriveReady SeekComplete DataRequest }

[...]

> > When I saw the recent message from Hans-Peter Jansen about this exact
> > problem, and Boris's comment that something in interrupt land for the
> > CD driver had been fixed, I thought the latest version of the kernel would
> > rectify matters.  I installed the 2.6.25-rc2 kernel from kernel.org
> > but the problem
> > is still there.

Does the following patch help?

[ It makes ireason handling for REQ_TYPE_ATA_PC requests be the same as
  for other request types so "ireason == 1" quirk is used if needed. ]

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
