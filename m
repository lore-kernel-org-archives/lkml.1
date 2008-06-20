Return-Path: <linux-kernel-owner+w=401wt.eu-S1762899AbYFTVgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762899AbYFTVgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761643AbYFTVcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:32:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:5898 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761629AbYFTVct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:32:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=UL3GstHC9EVnwgACnnVvMzpjChS5SYbcl5xm7+4GJoCSxSExfP1C+sMzCWiJLVWpBm
         bN1nNKxcix4AsU6O9OlQSH5usMjkL+oApQMLkq67aDz2bdjDbegxY/8Ihoa+7dzjjPH4
         TpIMGo88IJJ7Agh+q5Q9Ndz014M9Qpota9qDc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:34:45 +0200
Message-Id: <20080620213445.13202.61145.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/18] ide: use ->tf_load in actual_try_to_identify()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert actual_try_to_identify() to use ->tf_load instead of ->OUTB.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -290,9 +290,15 @@ static int actual_try_to_identify (ide_d
 	/* set features register for atapi
 	 * identify command to be sure of reply
 	 */
-	if ((cmd == WIN_PIDENTIFY))
-		/* disable dma & overlap */
-		hwif->OUTB(0, io_ports->feature_addr);
+	if (cmd == WIN_PIDENTIFY) {
+		ide_task_t task;
+
+		memset(&task, 0, sizeof(task));
+		/* disable DMA & overlap */
+		task.tf_flags = IDE_TFLAG_OUT_FEATURE;
+
+		drive->hwif->tf_load(drive, &task);
+	}
 
 	/* ask drive for ID */
 	hwif->exec_command(hwif, cmd);
