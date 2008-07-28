Return-Path: <linux-kernel-owner+w=401wt.eu-S1760249AbYG1Unn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249AbYG1Unn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759556AbYG1UnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:43:11 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:16727 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264AbYG1UnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=bVPr22dzalR252TXrd+ntTGH2x/qhBnCy7EydkNqHGkfrwhj3GGx6EVDItLITzpOSO
         3xXndD7qWrEQWj8VfvoJ2eMrXhHgbFTn/b+V+P/UaJVDaOWzUOtVHknQp/z9i/RJrp/D
         zTx8VtKieHb2TaUqmjG909vfvjWrCHdFCpUyE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2008 22:41:08 +0200
Message-Id: <20080728204108.4283.44774.sendpatchset@localhost.localdomain>
In-Reply-To: <20080728204102.4283.74632.sendpatchset@localhost.localdomain>
References: <20080728204102.4283.74632.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/5] cmd640: add __set_prefetch_mode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the common code from check_prefetch()
and set_prefetch_mode() to __set_prefetch_mode().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cmd640.c |   42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -374,6 +374,21 @@ static void cmd640_dump_regs(void)
 }
 #endif
 
+static void __set_prefetch_mode(ide_drive_t *drive, int mode)
+{
+	if (mode) {	/* want prefetch on? */
+#if CMD640_PREFETCH_MASKS
+		drive->no_unmask = 1;
+		drive->unmask = 0;
+#endif
+		drive->no_io_32bit = 0;
+	} else {
+		drive->no_unmask = 0;
+		drive->no_io_32bit = 1;
+		drive->io_32bit = 0;
+	}
+}
+
 #ifndef CONFIG_BLK_DEV_CMD640_ENHANCED
 /*
  * Check whether prefetch is on for a drive,
@@ -383,19 +398,10 @@ static void __init check_prefetch(ide_dr
 {
 	u8 b = get_cmd640_reg(prefetch_regs[index]);
 
-	if (b & prefetch_masks[index]) {	/* is prefetch off? */
-		drive->no_unmask = 0;
-		drive->no_io_32bit = 1;
-		drive->io_32bit = 0;
-	} else {
-#if CMD640_PREFETCH_MASKS
-		drive->no_unmask = 1;
-		drive->unmask = 0;
-#endif
-		drive->no_io_32bit = 0;
-	}
+	__set_prefetch_mode(drive, (b & prefetch_masks[index]) ? 0 : 1);
 }
 #else
+
 /*
  * Sets prefetch mode for a drive.
  */
@@ -407,19 +413,11 @@ static void set_prefetch_mode(ide_drive_
 
 	spin_lock_irqsave(&cmd640_lock, flags);
 	b = __get_cmd640_reg(reg);
-	if (mode) {	/* want prefetch on? */
-#if CMD640_PREFETCH_MASKS
-		drive->no_unmask = 1;
-		drive->unmask = 0;
-#endif
-		drive->no_io_32bit = 0;
+	__set_prefetch_mode(drive, mode);
+	if (mode)
 		b &= ~prefetch_masks[index];	/* enable prefetch */
-	} else {
-		drive->no_unmask = 0;
-		drive->no_io_32bit = 1;
-		drive->io_32bit = 0;
+	else
 		b |= prefetch_masks[index];	/* disable prefetch */
-	}
 	__put_cmd640_reg(reg, b);
 	spin_unlock_irqrestore(&cmd640_lock, flags);
 }
