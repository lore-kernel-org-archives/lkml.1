Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbYHJPmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbYHJPmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbYHJPjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:39:22 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:10683 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813AbYHJPjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=e6aY9BHBF0jtR2Edic8T/xFlvGAa8x71ZjsbKOXMobdGmIsbSLDIrnHjmSh2FzPAIr
         jlP+l7irBkFEXdJ9zpCxkvswNSgBCaXGJUJv6JChm8KyDZni6NhA8lf8Kqg2J7ilWHf4
         u45ZiZqsahW1B6MNW2Lm4fMGzV3yma9hAmc/c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:37:07 +0200
Message-Id: <20080810153707.16255.15094.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/22] ide: move IDE{FLOPPY,TAPE}_WAIT_CMD defines to <linux/ide.h>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:

* IDE{FLOPPY,TAPE}_WAIT_CMD -> WAIT_{FLOPPY,TAPE}_CMD

* Use enum for WAIT_* defines.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |   13 ++++---------
 drivers/ide/ide-tape.c   |   13 +++----------
 include/linux/ide.h      |   28 ++++++++++++++++++++++------
 3 files changed, 29 insertions(+), 25 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -60,10 +60,6 @@
 #define debug_log(fmt, args...) do {} while (0)
 #endif
 
-
-/* Some drives require a longer irq timeout. */
-#define IDEFLOPPY_WAIT_CMD		(5 * WAIT_CMD)
-
 /*
  * After each failed packet command we issue a request sense command and retry
  * the packet command IDEFLOPPY_MAX_PC_RETRIES times.
@@ -225,7 +221,7 @@ static ide_startstop_t idefloppy_pc_intr
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
 	return ide_pc_intr(drive, floppy->pc, idefloppy_pc_intr,
-			   IDEFLOPPY_WAIT_CMD, NULL, idefloppy_update_buffers,
+			   WAIT_FLOPPY_CMD, NULL, idefloppy_update_buffers,
 			   idefloppy_retry_pc, NULL, ide_io_buffers);
 }
 
@@ -243,10 +239,9 @@ static int idefloppy_transfer_pc(ide_dri
 	drive->hwif->tp_ops->output_data(drive, NULL, floppy->pc->c, 12);
 
 	/* Timeout for the packet command */
-	return IDEFLOPPY_WAIT_CMD;
+	return WAIT_FLOPPY_CMD;
 }
 
-
 /*
  * Called as an interrupt (or directly). When the device says it's ready for a
  * packet, we schedule the packet transfer to occur about 2-3 ticks later in
@@ -271,7 +266,7 @@ static ide_startstop_t idefloppy_start_p
 		timeout = floppy->ticks;
 		expiry = &idefloppy_transfer_pc;
 	} else {
-		timeout = IDEFLOPPY_WAIT_CMD;
+		timeout = WAIT_FLOPPY_CMD;
 		expiry = NULL;
 	}
 
@@ -321,7 +316,7 @@ static ide_startstop_t idefloppy_issue_p
 	pc->retries++;
 
 	return ide_issue_pc(drive, pc, idefloppy_start_pc_transfer,
-			    IDEFLOPPY_WAIT_CMD, NULL);
+			    WAIT_FLOPPY_CMD, NULL);
 }
 
 void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -81,13 +81,6 @@ enum {
 #define IDETAPE_MAX_PC_RETRIES		3
 
 /*
- * Some drives (for example, Seagate STT3401A Travan) require a very long
- * timeout, because they don't return an interrupt or clear their busy bit
- * until after the command completes (even retension commands).
- */
-#define IDETAPE_WAIT_CMD		(900*HZ)
-
-/*
  * The following parameter is used to select the point in the internal tape fifo
  * in which we will start to refill the buffer. Decreasing the following
  * parameter will improve the system's latency and interactive response, while
@@ -663,7 +656,7 @@ static ide_startstop_t idetape_pc_intr(i
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	return ide_pc_intr(drive, tape->pc, idetape_pc_intr, IDETAPE_WAIT_CMD,
+	return ide_pc_intr(drive, tape->pc, idetape_pc_intr, WAIT_TAPE_CMD,
 			   NULL, idetape_update_buffers, idetape_retry_pc,
 			   ide_tape_handle_dsc, ide_tape_io_buffers);
 }
@@ -709,7 +702,7 @@ static ide_startstop_t idetape_transfer_
 	idetape_tape_t *tape = drive->driver_data;
 
 	return ide_transfer_pc(drive, tape->pc, idetape_pc_intr,
-			       IDETAPE_WAIT_CMD, NULL);
+			       WAIT_TAPE_CMD, NULL);
 }
 
 static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
@@ -758,7 +751,7 @@ static ide_startstop_t idetape_issue_pc(
 	pc->retries++;
 
 	return ide_issue_pc(drive, pc, idetape_transfer_pc,
-			    IDETAPE_WAIT_CMD, NULL);
+			    WAIT_TAPE_CMD, NULL);
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -133,12 +133,28 @@ struct ide_io_ports {
 /*
  * Timeouts for various operations:
  */
-#define WAIT_DRQ	(HZ/10)		/* 100msec - spec allows up to 20ms */
-#define WAIT_READY	(5*HZ)		/* 5sec - some laptops are very slow */
-#define WAIT_PIDENTIFY	(10*HZ)	/* 10sec  - should be less than 3ms (?), if all ATAPI CD is closed at boot */
-#define WAIT_WORSTCASE	(30*HZ)	/* 30sec  - worst case when spinning up */
-#define WAIT_CMD	(10*HZ)	/* 10sec  - maximum wait for an IRQ to happen */
-#define WAIT_MIN_SLEEP	(2*HZ/100)	/* 20msec - minimum sleep time */
+enum {
+	/* spec allows up to 20ms */
+	WAIT_DRQ	= HZ / 10,	/* 100ms */
+	/* some laptops are very slow */
+	WAIT_READY	= 5 * HZ,	/* 5s */
+	/* should be less than 3ms (?), if all ATAPI CD is closed at boot */
+	WAIT_PIDENTIFY	= 10 * HZ,	/* 10s */
+	/* worst case when spinning up */
+	WAIT_WORSTCASE	= 30 * HZ,	/* 30s */
+	/* maximum wait for an IRQ to happen */
+	WAIT_CMD	= 10 * HZ,	/* 10s */
+	/* Some drives require a longer IRQ timeout. */
+	WAIT_FLOPPY_CMD	= 50 * HZ,	/* 50s */
+	/*
+	 * Some drives (for example, Seagate STT3401A Travan) require a very
+	 * long timeout, because they don't return an interrupt or clear their
+	 * BSY bit until after the command completes (even retension commands).
+	 */
+	WAIT_TAPE_CMD	= 900 * HZ,	/* 900s */
+	/* minimum sleep time */
+	WAIT_MIN_SLEEP	= HZ / 50,	/* 20ms */
+};
 
 /*
  * Op codes for special requests to be handled by ide_special_rq().
