Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbYF2LBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbYF2LBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758142AbYF2K7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:59:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:55234 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbYF2K7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:59:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=dw6CLdoFZmCmn3l8HHeGP5OD6qPhsxRr+ANfRxpLKYUXSQ4xP7uI+8N5IDRYVsUtG0
         4YE+bhuS9yOee6t9kz3qeS8Bfn3JiueA1/Whd06b7mLzWuFNWHxA9uvCO4Vh+P6XFWVK
         1dTr3Ldt4g3PhDki0iIAF3T+UbtLpS9tN13KU=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 02/16] ide-floppy: use drive->pc_callback instead of pc->callback
Date: Sun, 29 Jun 2008 12:59:05 +0200
Message-Id: <1214737159-1078-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
References: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is important that drive->pc_callback is set prior to enabling IRQs on the
device since this is called from the IRQ handler. Otherwise it hurts as I learnt
the hard way from the several "Kernel panic - not synching: Fatal exception in
interrupt" during the weekend :).

The if-else block in the IRQ handler is only temporary so that bisect searches
don't break and it'll be removed after converting the remainder of the drivers.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c  |   10 ++++++++--
 drivers/ide/ide-floppy.c |    4 ++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 2802031..411443e 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -30,7 +30,10 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	debug_log("Enter %s - interrupt handler\n", __func__);
 
 	if (pc->flags & PC_FLAG_TIMEDOUT) {
-		pc->callback(drive);
+		if (drive->media == ide_floppy)
+			drive->pc_callback(drive);
+		else
+			pc->callback(drive);
 		return ide_stopped;
 	}
 
@@ -96,7 +99,10 @@ cmd_finished:
 			return ide_stopped;
 		}
 		/* Command finished - Call the callback function */
-		pc->callback(drive);
+		if (drive->media == ide_floppy)
+			drive->pc_callback(drive);
+		else
+			pc->callback(drive);
 		return ide_stopped;
 	}
 
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index c7e4433..b5b3191 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -354,7 +354,6 @@ static void idefloppy_init_pc(struct ide_atapi_pc *pc)
 	memset(pc, 0, sizeof(*pc));
 	pc->buf = pc->pc_buf;
 	pc->buf_size = IDEFLOPPY_PC_BUFFER_SIZE;
-	pc->callback = ide_floppy_callback;
 }
 
 static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
@@ -474,7 +473,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		pc->error = IDEFLOPPY_ERROR_GENERAL;
 
 		floppy->failed_pc = NULL;
-		pc->callback(drive);
+		drive->pc_callback(drive);
 		return ide_stopped;
 	}
 
@@ -1039,6 +1038,7 @@ static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 
 	*((u16 *) &gcw) = drive->id->config;
 	floppy->pc = floppy->pc_stack;
+	drive->pc_callback = ide_floppy_callback;
 
 	if (((gcw[0] & 0x60) >> 5) == 1)
 		floppy->flags |= IDEFLOPPY_FLAG_DRQ_INTERRUPT;
-- 
1.5.5.4

