Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbYERSn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbYERSn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbYERSjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:39:21 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:17569 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467AbYERSjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:39:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=PvHU/SQr2jwdbniL2jeWDXsclpsHJRvRZ0YPfcPqJqHd9yypc6JDyP/MsziQz5+5k0YFGVlHPGd0bptSXHg0w85gQ0xW1mkBpM15PEbviTtR3yfw9xzjqkl33I+t7aJoo8cK15UKa2nYjBkl20sMUbBf9aT/S7Oc2Q8NE7T4zAE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:56:43 +0200
Message-Id: <20080518185643.5636.460.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/40] ide-{floppy,tape,scsi}: log device name instead of driver name
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Log device name instead of driver name in *_pc_intr() and *_transfer_pc*().

While at it:

* Merge two consecutive printk()-s in *_pc_intr() together.

* Replace "floppy"/"tape"/"scsi" references in printk()-s by "device".

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |   35 ++++++++++++++++++-----------------
 drivers/ide/ide-tape.c   |   42 ++++++++++++++++++++++--------------------
 drivers/scsi/ide-scsi.c  |   24 +++++++++++++-----------
 3 files changed, 53 insertions(+), 48 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -438,8 +438,8 @@ static ide_startstop_t idefloppy_pc_intr
 			debug_log("%s: I/O error\n", drive->name);
 			rq->errors++;
 			if (pc->c[0] == GPCMD_REQUEST_SENSE) {
-				printk(KERN_ERR "ide-floppy: I/O error in "
-					"request sense command\n");
+				printk(KERN_ERR "%s: I/O error in request sense"
+						" command\n", drive->name);
 				return ide_do_reset(drive);
 			}
 			/* Retry operation */
@@ -457,8 +457,8 @@ static ide_startstop_t idefloppy_pc_intr
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		printk(KERN_ERR "ide-floppy: The floppy wants to issue "
-			"more interrupts in DMA mode\n");
+		printk(KERN_ERR "%s: The device wants to issue more interrupts "
+				"in DMA mode\n", drive->name);
 		ide_dma_off(drive);
 		return ide_do_reset(drive);
 	}
@@ -470,14 +470,14 @@ static ide_startstop_t idefloppy_pc_intr
 	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 
 	if (ireason & CD) {
-		printk(KERN_ERR "ide-floppy: CoD != 0 in %s\n", __func__);
+		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
 		return ide_do_reset(drive);
 	}
 	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
 		/* Hopefully, we will never get here */
-		printk(KERN_ERR "ide-floppy: We wanted to %s, ",
-				(ireason & IO) ? "Write" : "Read");
-		printk(KERN_ERR "but the floppy wants us to %s !\n",
+		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
+				"to %s!\n", drive->name,
+				(ireason & IO) ? "Write" : "Read",
 				(ireason & IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
@@ -486,9 +486,10 @@ static ide_startstop_t idefloppy_pc_intr
 		temp = pc->xferred + bcount;
 		if (temp > pc->req_xfer) {
 			if (temp > pc->buf_size) {
-				printk(KERN_ERR "ide-floppy: The floppy wants "
-					"to send us more data than expected "
-					"- discarding data\n");
+				printk(KERN_ERR "%s: The device wants to send "
+						"us more data than expected - "
+						"discarding data\n",
+						drive->name);
 				ide_pad_transfer(drive, 0, bcount);
 
 				ide_set_handler(drive,
@@ -497,8 +498,8 @@ static ide_startstop_t idefloppy_pc_intr
 						NULL);
 				return ide_started;
 			}
-			debug_log("The floppy wants to send us more data than"
-					" expected - allowing transfer\n");
+			debug_log("The device wants to send us more data than "
+				  "expected - allowing transfer\n");
 		}
 	}
 	if (pc->flags & PC_FLAG_WRITING)
@@ -552,14 +553,14 @@ static ide_startstop_t idefloppy_transfe
 	u8 ireason;
 
 	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
-		printk(KERN_ERR "ide-floppy: Strange, packet command "
-				"initiated yet DRQ isn't asserted\n");
+		printk(KERN_ERR "%s: Strange, packet command initiated yet "
+				"DRQ isn't asserted\n", drive->name);
 		return startstop;
 	}
 	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 	if ((ireason & CD) == 0 || (ireason & IO)) {
-		printk(KERN_ERR "ide-floppy: (IO,CoD) != (0,1) "
-				"while issuing a packet command\n");
+		printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
+				"a packet command\n", drive->name);
 		return ide_do_reset(drive);
 	}
 	/*
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -776,8 +776,8 @@ static ide_startstop_t idetape_pc_intr(i
 			debug_log(DBG_ERR, "%s: I/O error\n", tape->name);
 
 			if (pc->c[0] == REQUEST_SENSE) {
-				printk(KERN_ERR "ide-tape: I/O error in request"
-						" sense command\n");
+				printk(KERN_ERR "%s: I/O error in request sense"
+						" command\n", drive->name);
 				return ide_do_reset(drive);
 			}
 			debug_log(DBG_ERR, "[cmd %x]: check condition\n",
@@ -805,8 +805,8 @@ static ide_startstop_t idetape_pc_intr(i
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		printk(KERN_ERR "ide-tape: The tape wants to issue more "
-				"interrupts in DMA mode\n");
+		printk(KERN_ERR "%s: The device wants to issue more interrupts "
+				"in DMA mode\n", drive->name);
 		ide_dma_off(drive);
 		return ide_do_reset(drive);
 	}
@@ -817,14 +817,14 @@ static ide_startstop_t idetape_pc_intr(i
 	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 
 	if (ireason & CD) {
-		printk(KERN_ERR "ide-tape: CoD != 0 in %s\n", __func__);
+		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
 		return ide_do_reset(drive);
 	}
 	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
 		/* Hopefully, we will never get here */
-		printk(KERN_ERR "ide-tape: We wanted to %s, ",
-				(ireason & IO) ? "Write" : "Read");
-		printk(KERN_ERR "ide-tape: but the tape wants us to %s !\n",
+		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
+				"to %s!\n", drive->name,
+				(ireason & IO) ? "Write" : "Read",
 				(ireason & IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
@@ -833,15 +833,16 @@ static ide_startstop_t idetape_pc_intr(i
 		temp = pc->xferred + bcount;
 		if (temp > pc->req_xfer) {
 			if (temp > pc->buf_size) {
-				printk(KERN_ERR "ide-tape: The tape wants to "
-					"send us more data than expected "
-					"- discarding data\n");
+				printk(KERN_ERR "%s: The device wants to send "
+						"us more data than expected - "
+						"discarding data\n",
+						drive->name);
 				ide_pad_transfer(drive, 0, bcount);
 				ide_set_handler(drive, &idetape_pc_intr,
 						IDETAPE_WAIT_CMD, NULL);
 				return ide_started;
 			}
-			debug_log(DBG_SENSE, "The tape wants to send us more "
+			debug_log(DBG_SENSE, "The device wants to send us more "
 				"data than expected - allowing transfer\n");
 		}
 		iobuf = &idetape_input_buffers;
@@ -914,26 +915,27 @@ static ide_startstop_t idetape_transfer_
 	u8 ireason;
 
 	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
-		printk(KERN_ERR "ide-tape: Strange, packet command initiated "
-				"yet DRQ isn't asserted\n");
+		printk(KERN_ERR "%s: Strange, packet command initiated yet "
+				"DRQ isn't asserted\n", drive->name);
 		return startstop;
 	}
 	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 	while (retries-- && ((ireason & CD) == 0 || (ireason & IO))) {
-		printk(KERN_ERR "ide-tape: (IO,CoD != (0,1) while issuing "
-				"a packet command, retrying\n");
+		printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
+				"a packet command, retrying\n", drive->name);
 		udelay(100);
 		ireason = hwif->INB(hwif->io_ports.nsect_addr);
 		if (retries == 0) {
-			printk(KERN_ERR "ide-tape: (IO,CoD != (0,1) while "
-					"issuing a packet command, ignoring\n");
+			printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
+					"a packet command, ignoring\n",
+					drive->name);
 			ireason |= CD;
 			ireason &= ~IO;
 		}
 	}
 	if ((ireason & CD) == 0 || (ireason & IO)) {
-		printk(KERN_ERR "ide-tape: (IO,CoD) != (0,1) while issuing "
-				"a packet command\n");
+		printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
+				"a packet command\n", drive->name);
 		return ide_do_reset(drive);
 	}
 	/* Set the interrupt routine */
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -391,7 +391,7 @@ static ide_startstop_t idescsi_pc_intr (
 	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 
 	if (ireason & CD) {
-		printk(KERN_ERR "ide-scsi: CoD != 0 in idescsi_pc_intr\n");
+		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
 		return ide_do_reset (drive);
 	}
 	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
@@ -406,9 +406,10 @@ static ide_startstop_t idescsi_pc_intr (
 		temp = pc->xferred + bcount;
 		if (temp > pc->req_xfer) {
 			if (temp > pc->buf_size) {
-				printk(KERN_ERR "ide-scsi: The scsi wants to "
-					"send us more data than expected "
-					"- discarding data\n");
+				printk(KERN_ERR "%s: The device wants to send "
+						"us more data than expected - "
+						"discarding data\n",
+						drive->name);
 				temp = pc->buf_size - pc->xferred;
 				if (temp) {
 					if (pc->sg)
@@ -417,8 +418,9 @@ static ide_startstop_t idescsi_pc_intr (
 					else
 						hwif->input_data(drive, NULL,
 							pc->cur_pos, temp);
-					printk(KERN_ERR "ide-scsi: transferred"
-							" %d of %d bytes\n",
+					printk(KERN_ERR "%s: transferred %d of "
+							"%d bytes\n",
+							drive->name,
 							temp, bcount);
 				}
 				pc->xferred += temp;
@@ -427,7 +429,7 @@ static ide_startstop_t idescsi_pc_intr (
 				ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 				return ide_started;
 			}
-			debug_log("The scsi wants to send us more data than "
+			debug_log("The device wants to send us more data than "
 				  "expected - allowing transfer\n");
 		}
 		xferfunc = hwif->input_data;
@@ -458,14 +460,14 @@ static ide_startstop_t idescsi_transfer_
 	u8 ireason;
 
 	if (ide_wait_stat(&startstop,drive,DRQ_STAT,BUSY_STAT,WAIT_READY)) {
-		printk(KERN_ERR "ide-scsi: Strange, packet command "
-			"initiated yet DRQ isn't asserted\n");
+		printk(KERN_ERR "%s: Strange, packet command initiated yet "
+				"DRQ isn't asserted\n", drive->name);
 		return startstop;
 	}
 	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 	if ((ireason & CD) == 0 || (ireason & IO)) {
-		printk(KERN_ERR "ide-scsi: (IO,CoD) != (0,1) while "
-				"issuing a packet command\n");
+		printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
+				"a packet command\n", drive->name);
 		return ide_do_reset (drive);
 	}
 
