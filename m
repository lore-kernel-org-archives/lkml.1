Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbZBPAOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbZBPAOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbZBPAMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:12:24 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:35554 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbZBPAMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:12:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Uzc7azOLuABaRAmhwN5y5YL7e8RClszcRMLbv95uIaTz3CeZ18AwlggXyt2jkStXN+
         sz52Hxp+6M1KKOgUt0UWARM56lSHIp76bJNDA08ANWtGsLH+CLc1zp82lsHsPYKapIf/
         dfB9BM19PQapQQfVeBxiPYGtFFi3X0YLlmyzI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:13:49 +0100
Message-Id: <20090216001349.27491.27484.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/20] ide: remove needless ide_dump_status_no_sense() wrapper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: remove needless ide_dump_status_no_sense() wrapper

It makes no sense to check for BSY bit being set as earlier OK_STAT()
check in cdrom_end_request() makes sure that BSY bit is cleared.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -285,13 +285,6 @@ static void cdrom_end_request(ide_drive_
 	ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
 }
 
-static void ide_dump_status_no_sense(ide_drive_t *drive, const char *msg, u8 st)
-{
-	if (st & 0x80)
-		return;
-	ide_dump_status(drive, msg, st);
-}
-
 /*
  * Returns:
  * 0: if the request should be continued.
@@ -434,21 +427,19 @@ static int cdrom_decode_status(ide_drive
 			 * No point in retrying after an illegal request or data
 			 * protect error.
 			 */
-			ide_dump_status_no_sense(drive, "command error", stat);
+			ide_dump_status(drive, "command error", stat);
 			do_end_request = 1;
 		} else if (sense_key == MEDIUM_ERROR) {
 			/*
 			 * No point in re-trying a zillion times on a bad
 			 * sector. If we got here the error is not correctable.
 			 */
-			ide_dump_status_no_sense(drive,
-						 "media error (bad sector)",
-						 stat);
+			ide_dump_status(drive, "media error (bad sector)",
+					stat);
 			do_end_request = 1;
 		} else if (sense_key == BLANK_CHECK) {
 			/* disk appears blank ?? */
-			ide_dump_status_no_sense(drive, "media error (blank)",
-						 stat);
+			ide_dump_status(drive, "media error (blank)", stat);
 			do_end_request = 1;
 		} else if ((err & ~ATA_ABORTED) != 0) {
 			/* go to the default handler for other errors */
