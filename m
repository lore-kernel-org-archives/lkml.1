Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbXFQSGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbXFQSGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 14:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbXFQSGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 14:06:12 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43645 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbXFQSGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 14:06:11 -0400
Date: Mon, 18 Jun 2007 03:05:52 +0900 (JST)
Message-Id: <20070618.030552.59480211.jet@gyve.org>
To: bzolnier@gmail.com
Cc: cebbert@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] never called printk statement in
 ide-taskfile.c::wait_drive_not_busy
From: Masatake YAMATO <jet@gyve.org>
In-Reply-To: <200706160045.36638.bzolnier@gmail.com>
References: <4665988A.5060902@redhat.com>
	<20070606.023558.230059723.jet@gyve.org>
	<200706160045.36638.bzolnier@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.0.98 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Please re-submit this fix in the form of a patch so I can merge it.

Here it is.


diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 30175c7..aa06daf 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -238,7 +238,7 @@ EXPORT_SYMBOL(task_no_data_intr);
 static u8 wait_drive_not_busy(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	int retries = 100;
+	int retries;
 	u8 stat;
 
 	/*
@@ -246,10 +246,14 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 	 * This can take up to 10 usec, but we will wait max 1 ms
 	 * (drive_cmd_intr() waits that long).
 	 */
-	while (((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) && retries--)
-		udelay(10);
+	for (retries = 0; retries < 100; retries++) {
+		if ((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT)
+			udelay(10);
+		else
+			break;
+	}
 
-	if (!retries)
+	if (stat & BUSY_STAT)
 		printk(KERN_ERR "%s: drive still BUSY!\n", drive->name);
 
 	return stat;
