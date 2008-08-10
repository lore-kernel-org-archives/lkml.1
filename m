Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbYHJPl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbYHJPl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbYHJPip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:38:45 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:13064 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbYHJPin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=xmH4eazIn0CvbRpGhm+pkbjyeI0ZemEKzJ5jn1RB3BXqmitO9GY/ivzhHxbQBgQ6IG
         y2W3pfkplw6TKhF7r8OR2THbb14HJGQVcA1jEYIGwapIv93p2aKXQzA3ZauMkiDoouAs
         udNs6JovifrN0YRMiYJmbu4LEwqtBsIxhCT+g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:36:31 +0200
Message-Id: <20080810153631.16255.44403.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/22] ide-floppy: ->{srfp,wp} -> IDE_AFLAG_{SRFP,WP}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add IDE_AFLAG_{SRFP,WP} drive->atapi_flags and use them
instead of ->{srfp,wp} struct ide_floppy_obj fields.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |   24 ++++++++++++++----------
 include/linux/ide.h      |   16 ++++++++++------
 2 files changed, 24 insertions(+), 16 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -109,10 +109,6 @@ typedef struct ide_floppy_obj {
 	u8 cap_desc[8];
 	/* Copy of the flexible disk page */
 	u8 flexible_disk_page[32];
-	/* Write protect */
-	int wp;
-	/* Supports format progress report */
-	int srfp;
 } idefloppy_floppy_t;
 
 #define IDEFLOPPY_TICKS_DELAY	HZ/20	/* default delay for ZIP 100 (50ms) */
@@ -573,8 +569,14 @@ static int ide_floppy_get_flexible_disk_
 				" parameters\n");
 		return 1;
 	}
-	floppy->wp = !!(pc.buf[3] & 0x80);
-	set_disk_ro(disk, floppy->wp);
+
+	if (pc.buf[3] & 0x80)
+		drive->atapi_flags |= IDE_AFLAG_WP;
+	else
+		drive->atapi_flags &= ~IDE_AFLAG_WP;
+
+	set_disk_ro(disk, !!(drive->atapi_flags & IDE_AFLAG_WP));
+
 	page = &pc.buf[8];
 
 	transfer_rate = be16_to_cpup((__be16 *)&pc.buf[8 + 2]);
@@ -613,7 +615,7 @@ static int idefloppy_get_sfrp_bit(ide_dr
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	struct ide_atapi_pc pc;
 
-	floppy->srfp = 0;
+	drive->atapi_flags &= ~IDE_AFLAG_SRFP;
 
 	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE);
 	pc.flags |= PC_FLAG_SUPPRESS_ERROR;
@@ -621,7 +623,9 @@ static int idefloppy_get_sfrp_bit(ide_dr
 	if (ide_queue_pc_tail(drive, floppy->disk, &pc))
 		return 1;
 
-	floppy->srfp = pc.buf[8 + 2] & 0x40;
+	if (pc.buf[8 + 2] & 0x40)
+		drive->atapi_flags |= IDE_AFLAG_SRFP;
+
 	return 0;
 }
 
@@ -819,7 +823,7 @@ static int ide_floppy_get_format_progres
 	struct ide_atapi_pc pc;
 	int progress_indication = 0x10000;
 
-	if (floppy->srfp) {
+	if (drive->atapi_flags & IDE_AFLAG_SRFP) {
 		idefloppy_create_request_sense_cmd(&pc);
 		if (ide_queue_pc_tail(drive, floppy->disk, &pc))
 			return -EIO;
@@ -1043,7 +1047,7 @@ static int idefloppy_open(struct inode *
 			goto out_put_floppy;
 		}
 
-		if (floppy->wp && (filp->f_mode & 2)) {
+		if ((drive->atapi_flags & IDE_AFLAG_WP) && (filp->f_mode & 2)) {
 			ret = -EROFS;
 			goto out_put_floppy;
 		}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -356,19 +356,23 @@ enum {
 	IDE_AFLAG_CLIK_DRIVE		= (1 << 19),
 	/* Requires BH algorithm for packets */
 	IDE_AFLAG_ZIP_DRIVE		= (1 << 20),
+	/* Write protect */
+	IDE_AFLAG_WP			= (1 << 21),
+	/* Supports format progress report */
+	IDE_AFLAG_SRFP			= (1 << 22),
 
 	/* ide-tape */
-	IDE_AFLAG_IGNORE_DSC		= (1 << 21),
+	IDE_AFLAG_IGNORE_DSC		= (1 << 23),
 	/* 0 When the tape position is unknown */
-	IDE_AFLAG_ADDRESS_VALID		= (1 <<	22),
+	IDE_AFLAG_ADDRESS_VALID		= (1 <<	24),
 	/* Device already opened */
-	IDE_AFLAG_BUSY			= (1 << 23),
+	IDE_AFLAG_BUSY			= (1 << 25),
 	/* Attempt to auto-detect the current user block size */
-	IDE_AFLAG_DETECT_BS		= (1 << 24),
+	IDE_AFLAG_DETECT_BS		= (1 << 26),
 	/* Currently on a filemark */
-	IDE_AFLAG_FILEMARK		= (1 << 25),
+	IDE_AFLAG_FILEMARK		= (1 << 27),
 	/* 0 = no tape is loaded, so we don't rewind after ejecting */
-	IDE_AFLAG_MEDIUM_PRESENT	= (1 << 26)
+	IDE_AFLAG_MEDIUM_PRESENT	= (1 << 28)
 };
 
 struct ide_drive_s {
