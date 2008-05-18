Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbYERSpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbYERSpB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbYERSjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:39:46 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:17236 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbYERSjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Pckl5VDvlkC5Mds14N8VMwShb8gX4uunuKReFQ6ePZyCamZ8l5wuEuzlV8+BuKZeiZDQT1Vaod2eBTxcX6FVAtWhsAkebqJSLl+NxiWPqq7OoWP5h3zoYnAE397OXDPsMJUdXqidYPyNO8GOOGEWXgTHnJYebfG+XUQzSMz66/A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:57:10 +0200
Message-Id: <20080518185710.5636.35408.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 18/40] ide-tape: make pc->idetape_callback void
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |   13 +++++++------
 include/linux/ide.h    |    2 +-
 2 files changed, 8 insertions(+), 7 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -619,7 +619,7 @@ static int idetape_end_request(ide_drive
 	return 0;
 }
 
-static ide_startstop_t ide_tape_callback(ide_drive_t *drive)
+static void ide_tape_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = tape->pc;
@@ -675,8 +675,6 @@ static ide_startstop_t ide_tape_callback
 	}
 
 	idetape_end_request(drive, uptodate, 0);
-
-	return ide_stopped;
 }
 
 static void idetape_init_pc(struct ide_atapi_pc *pc)
@@ -843,7 +841,8 @@ static ide_startstop_t idetape_pc_intr(i
 		if (tape->failed_pc == pc)
 			tape->failed_pc = NULL;
 		/* Command finished - Call the callback function */
-		return pc->idetape_callback(drive);
+		pc->idetape_callback(drive);
+		return ide_stopped;
 	}
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
@@ -1035,7 +1034,8 @@ static ide_startstop_t idetape_issue_pc(
 			pc->error = IDETAPE_ERROR_GENERAL;
 		}
 		tape->failed_pc = NULL;
-		return pc->idetape_callback(drive);
+		pc->idetape_callback(drive);
+		return ide_stopped;
 	}
 	debug_log(DBG_SENSE, "Retry #%d, cmd = %02X\n", pc->retries, pc->c[0]);
 
@@ -1120,7 +1120,8 @@ static ide_startstop_t idetape_media_acc
 		pc->error = IDETAPE_ERROR_GENERAL;
 		tape->failed_pc = NULL;
 	}
-	return pc->idetape_callback(drive);
+	pc->idetape_callback(drive);
+	return ide_stopped;
 }
 
 static void idetape_create_read_cmd(idetape_tape_t *tape,
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -626,7 +626,7 @@ struct ide_atapi_pc {
 	 */
 	u8 pc_buf[256];
 	void (*idefloppy_callback) (ide_drive_t *);
-	ide_startstop_t (*idetape_callback) (ide_drive_t *);
+	void (*idetape_callback) (ide_drive_t *);
 
 	/* idetape only */
 	struct idetape_bh *bh;
