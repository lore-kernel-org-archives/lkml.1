Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbYFLGqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbYFLGqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYFLGlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:41:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:8605 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbYFLGlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=j7p8ayI2A1To7WaItf/hSBNbXKi3tI+xv2+2h/zFGBJVyYKKYVY4sMPgThu71zfl+z
         ljLU3Qvdmd3Iic3qMWNBT3jRz8ZRqjWWiXHCp4LD0U5GuIeCn8R8tqLwR64KmNxcFWHb
         mJMPskofmnZaJ5nclvt8IzqKSv5ad7AleOguw=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 02/18] ide-cd: remove ide_cd_drain_data and ide_cd_pad_transfer
Date: Thu, 12 Jun 2008 08:40:54 +0200
Message-Id: <1213252870-20474-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic ide_pad_transfer() helper instead

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   33 ++++-----------------------------
 1 files changed, 4 insertions(+), 29 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 92a8a36..2f0c9d4 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -599,28 +599,6 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 }
 
 /*
- * Block read functions.
- */
-static void ide_cd_pad_transfer(ide_drive_t *drive, xfer_func_t *xf, int len)
-{
-	while (len > 0) {
-		int dum = 0;
-		xf(drive, NULL, &dum, sizeof(dum));
-		len -= sizeof(dum);
-	}
-}
-
-static void ide_cd_drain_data(ide_drive_t *drive, int nsects)
-{
-	while (nsects > 0) {
-		static char dum[SECTOR_SIZE];
-
-		drive->hwif->input_data(drive, NULL, dum, sizeof(dum));
-		nsects--;
-	}
-}
-
-/*
  * Check the contents of the interrupt reason register from the cdrom
  * and attempt to recover if there are problems.  Returns  0 if everything's
  * ok; nonzero if the request has been terminated.
@@ -635,15 +613,12 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 	if (ireason == (!rw << 1))
 		return 0;
 	else if (ireason == (rw << 1)) {
-		ide_hwif_t *hwif = drive->hwif;
-		xfer_func_t *xf;
 
 		/* whoops... */
 		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
 				drive->name, __func__);
 
-		xf = rw ? hwif->output_data : hwif->input_data;
-		ide_cd_pad_transfer(drive, xf, len);
+		ide_pad_transfer(drive, rw, len);
 	} else  if (rw == 0 && ireason == 1) {
 		/*
 		 * Some drives (ASUS) seem to tell us that status info is
@@ -1006,7 +981,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 					   - bio_cur_sectors(rq->bio),
 					   thislen >> 9);
 			if (nskip > 0) {
-				ide_cd_drain_data(drive, nskip);
+				ide_pad_transfer(drive, write, nskip);
 				rq->current_nr_sectors -= nskip;
 				thislen -= (nskip << 9);
 			}
@@ -1043,7 +1018,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 				 * If the buffers are full, pipe the rest into
 				 * oblivion.
 				 */
-				ide_cd_drain_data(drive, thislen >> 9);
+				ide_pad_transfer(drive, 0, thislen >> 9);
 			else {
 				printk(KERN_ERR "%s: confused, missing data\n",
 						drive->name);
@@ -1091,7 +1066,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 
 	/* pad, if necessary */
 	if (!blk_fs_request(rq) && len > 0)
-		ide_cd_pad_transfer(drive, xferfunc, len);
+		ide_pad_transfer(drive, write, len);
 
 	if (blk_pc_request(rq)) {
 		timeout = rq->timeout;
-- 
1.5.5.1

