Return-Path: <linux-kernel-owner+w=401wt.eu-S1759690AbYERSr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690AbYERSr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbYERSkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:40:42 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:20229 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206AbYERSkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:40:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=rHoLn+yNrVTXJmPUNR5oa30PIyP1pJ0t7oOh7580v1dqzneO87Xkr1PX37gaLUUqkU8LNhJZtuMcfr+2tJdb5Ez5oRdTzbfn16iiYuhbrlsRJxaRLDLHnzZtPTJcXc2NYEl6whvf2KxDEZa9Zor7VNBn1n2Ltw97ya6SdWwiEpo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:58:04 +0200
Message-Id: <20080518185804.5636.39075.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 24/40] ide-tape: factor out waiting for good ireason from idetape_transfer_pc()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out waiting for good ireason from idetape_transfer_pc()
to ide_tape_wait_ireason() as a preparation for adding generic
ide_transfer_pc() helper.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -947,21 +947,12 @@ static ide_startstop_t idetape_pc_intr(i
  * again, the callback function will be called and then we will handle the next
  * request.
  */
-static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
+
+static u8 ide_tape_wait_ireason(ide_drive_t *drive, u8 ireason)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	idetape_tape_t *tape = drive->driver_data;
-	struct ide_atapi_pc *pc = tape->pc;
 	int retries = 100;
-	ide_startstop_t startstop;
-	u8 ireason;
 
-	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
-		printk(KERN_ERR "%s: Strange, packet command initiated yet "
-				"DRQ isn't asserted\n", drive->name);
-		return startstop;
-	}
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 	while (retries-- && ((ireason & CD) == 0 || (ireason & IO))) {
 		printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
 				"a packet command, retrying\n", drive->name);
@@ -975,6 +966,27 @@ static ide_startstop_t idetape_transfer_
 			ireason &= ~IO;
 		}
 	}
+
+	return ireason;
+}
+
+static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	idetape_tape_t *tape = drive->driver_data;
+	struct ide_atapi_pc *pc = tape->pc;
+	ide_startstop_t startstop;
+	u8 ireason;
+
+	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
+		printk(KERN_ERR "%s: Strange, packet command initiated yet "
+				"DRQ isn't asserted\n", drive->name);
+		return startstop;
+	}
+
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
+	ireason = ide_tape_wait_ireason(drive, ireason);
+
 	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
 				"a packet command\n", drive->name);
