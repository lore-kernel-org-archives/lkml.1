Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbYERSpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbYERSpv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbYERSkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:40:05 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:28172 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbYERSkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:40:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=p3C3rgGtrZQ9fuj/dT7LNVA4BNQIBgUpMF+ypvE8GagdEF1ElutmkOk1UYFw3scVN4BgJTOkYqGGmHAGSnULOzPhB5JfH5WAW0dKblZHOaZioL/jaLRTfrmnN5VmVSMxeISq93wnT2V6Z/hMcA84v/iAH3IV6AMTHtLGLJdK63s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:57:28 +0200
Message-Id: <20080518185728.5636.89098.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 20/40] ide-{floppy,tape}: merge pc->idefloppy_callback and pc->idetape_callback
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge pc->idefloppy_callback and pc->idetape_callback into pc->callback.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |    6 +++---
 drivers/ide/ide-tape.c   |    8 ++++----
 include/linux/ide.h      |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -354,7 +354,7 @@ static void idefloppy_init_pc(struct ide
 	pc->req_xfer = 0;
 	pc->buf = pc->pc_buf;
 	pc->buf_size = IDEFLOPPY_PC_BUFFER_SIZE;
-	pc->idefloppy_callback = &ide_floppy_callback;
+	pc->callback = ide_floppy_callback;
 }
 
 static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
@@ -438,7 +438,7 @@ static ide_startstop_t idefloppy_pc_intr
 		if (floppy->failed_pc == pc)
 			floppy->failed_pc = NULL;
 		/* Command finished - Call the callback function */
-		pc->idefloppy_callback(drive);
+		pc->callback(drive);
 		return ide_stopped;
 	}
 
@@ -612,7 +612,7 @@ static ide_startstop_t idefloppy_issue_p
 		pc->error = IDEFLOPPY_ERROR_GENERAL;
 
 		floppy->failed_pc = NULL;
-		pc->idefloppy_callback(drive);
+		pc->callback(drive);
 		return ide_stopped;
 	}
 
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -687,7 +687,7 @@ static void idetape_init_pc(struct ide_a
 	pc->buf_size = IDETAPE_PC_BUFFER_SIZE;
 	pc->bh = NULL;
 	pc->b_data = NULL;
-	pc->idetape_callback = ide_tape_callback;
+	pc->callback = ide_tape_callback;
 }
 
 static void idetape_create_request_sense_cmd(struct ide_atapi_pc *pc)
@@ -841,7 +841,7 @@ static ide_startstop_t idetape_pc_intr(i
 		if (tape->failed_pc == pc)
 			tape->failed_pc = NULL;
 		/* Command finished - Call the callback function */
-		pc->idetape_callback(drive);
+		pc->callback(drive);
 		return ide_stopped;
 	}
 
@@ -1034,7 +1034,7 @@ static ide_startstop_t idetape_issue_pc(
 			pc->error = IDETAPE_ERROR_GENERAL;
 		}
 		tape->failed_pc = NULL;
-		pc->idetape_callback(drive);
+		pc->callback(drive);
 		return ide_stopped;
 	}
 	debug_log(DBG_SENSE, "Retry #%d, cmd = %02X\n", pc->retries, pc->c[0]);
@@ -1120,7 +1120,7 @@ static ide_startstop_t idetape_media_acc
 		pc->error = IDETAPE_ERROR_GENERAL;
 		tape->failed_pc = NULL;
 	}
-	pc->idetape_callback(drive);
+	pc->callback(drive);
 	return ide_stopped;
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -625,8 +625,8 @@ struct ide_atapi_pc {
 	 * to change/removal later.
 	 */
 	u8 pc_buf[256];
-	void (*idefloppy_callback) (ide_drive_t *);
-	void (*idetape_callback) (ide_drive_t *);
+
+	void (*callback)(ide_drive_t *);
 
 	/* idetape only */
 	struct idetape_bh *bh;
