Return-Path: <linux-kernel-owner+w=401wt.eu-S1760344AbYERSrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344AbYERSrn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757027AbYERSku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:40:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:20229 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415AbYERSks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=M2PiegBp8J1gqwsKj9LHfOaP7XKqEzcrXJhBWcRVOLrmE1QXwLsxKHjbPsy1XIjnrFn+xretyOJYW40ThqY1bgHlzv7PjlKzeWE/oHnzgzwTaR7zfcWDs5XwIvq963GyWem6+SBKk2plx+XffKu9lZ6s/eDb1HLLL+9655jhrpQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:58:13 +0200
Message-Id: <20080518185813.5636.39824.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 25/40] ide: add PC_FLAG_ZIP_DRIVE pc flag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PC_FLAG_ZIP_DRIVE pc flag, set it in idefloppy_do_request()
and check for it (instead of checking for IDEFLOPPY_FLAG_ZIP_DRIVE)
in idefloppy_transfer_pc().  This is a preparation for adding
generic ide_transfer_pc() helper.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |    8 ++++++--
 include/linux/ide.h      |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -559,7 +559,7 @@ static ide_startstop_t idefloppy_transfe
 	 * 40 and 50msec work well. idefloppy_pc_intr will not be actually
 	 * used until after the packet is moved in about 50 msec.
 	 */
-	if (floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE) {
+	if (pc->flags & PC_FLAG_ZIP_DRIVE) {
 		timeout = floppy->ticks;
 		expiry = &idefloppy_transfer_pc2;
 	} else {
@@ -575,7 +575,7 @@ static ide_startstop_t idefloppy_transfe
 		hwif->dma_ops->dma_start(drive);
 	}
 
-	if ((floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE) == 0)
+	if ((pc->flags & PC_FLAG_ZIP_DRIVE) == 0)
 		/* Send the actual packet */
 		hwif->output_data(drive, NULL, floppy->pc->c, 12);
 
@@ -826,7 +826,11 @@ static ide_startstop_t idefloppy_do_requ
 		return ide_stopped;
 	}
 
+	if (floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE)
+		pc->flags |= PC_FLAG_ZIP_DRIVE;
+
 	pc->rq = rq;
+
 	return idefloppy_issue_pc(drive, pc);
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -592,6 +592,7 @@ enum {
 	PC_FLAG_WRITING			= (1 << 6),
 	/* command timed out */
 	PC_FLAG_TIMEDOUT		= (1 << 7),
+	PC_FLAG_ZIP_DRIVE		= (1 << 8),
 };
 
 struct ide_atapi_pc {
