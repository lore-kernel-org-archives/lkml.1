Return-Path: <linux-kernel-owner+w=401wt.eu-S1761181AbYERSuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761181AbYERSuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757412AbYERSmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:42:11 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:29126 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270AbYERSmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:42:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dqLuxD0Bzn69l553ql4U5RzT1Bjs39o0kgflubOiCJhB450f84zILPVcE2eJ43g/UdpruNVfQjUY3g6+bqB7sz68uNRQzToISTXOUdDxFyYPcanQ5J14miPyFV0p6mAslL6p2jzi/rgXgBZTmgCA99IIRf6BZIJqXAC/DNwqedA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:59:33 +0200
Message-Id: <20080518185933.5636.32787.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 34/40] ide-tape: add ide_tape_io_buffers() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ide_tape_io_buffers() helper which is a wrapper for
  idetape_{in,out}put_buffers() and convert idetape_pc_intr()
  to use it.

* Remove no longer used idetape_io_buf typedef.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>---
---
 drivers/ide/ide-tape.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -780,7 +780,14 @@ static void ide_tape_handle_dsc(ide_driv
 	idetape_postpone_request(drive);
 }
 
-typedef void idetape_io_buf(ide_drive_t *, struct ide_atapi_pc *, unsigned int);
+static void ide_tape_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+				unsigned int bcount, int write)
+{
+	if (write)
+		idetape_output_buffers(drive, pc, bcount);
+	else
+		idetape_input_buffers(drive, pc, bcount);
+}
 
 /*
  * This is the usual interrupt handler which will be called during a packet
@@ -795,7 +802,6 @@ static ide_startstop_t idetape_pc_intr(i
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = tape->pc;
 	xfer_func_t *xferfunc;
-	idetape_io_buf *iobuf;
 	unsigned int temp;
 	u16 bcount;
 	u8 stat, ireason;
@@ -895,15 +901,14 @@ static ide_startstop_t idetape_pc_intr(i
 			debug_log(DBG_SENSE, "The device wants to send us more "
 				"data than expected - allowing transfer\n");
 		}
-		iobuf = &idetape_input_buffers;
 		xferfunc = hwif->input_data;
 	} else {
-		iobuf = &idetape_output_buffers;
 		xferfunc = hwif->output_data;
 	}
 
 	if (pc->bh)
-		iobuf(drive, pc, bcount);
+		ide_tape_io_buffers(drive, pc, bcount,
+				    !!(pc->flags & PC_FLAG_WRITING));
 	else
 		xferfunc(drive, NULL, pc->cur_pos, bcount);
 
