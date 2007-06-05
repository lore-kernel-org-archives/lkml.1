Return-Path: <linux-kernel-owner+w=401wt.eu-S1762845AbXFECYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762845AbXFECYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 22:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbXFECYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 22:24:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757468AbXFECYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 22:24:16 -0400
Date: Tue, 05 Jun 2007 11:21:24 +0900 (JST)
Message-Id: <20070605.112124.28713903.jet@gyve.org>
To: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] never called printk statement in
 ide-taskfile.c::wait_drive_not_busy
From: Masatake YAMATO <jet@gyve.org>
X-Mailer: Mew version 5.2 on Emacs 22.0.98 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Patches appended to this mail fixes a bug explained below.
There are two ways to fix the bug. PLEASE CHOOSE BETTER ONE.


Look at wait_drive_not_busy in drivers/ide/ide-taskfile.c:

    static u8 wait_drive_not_busy(ide_drive_t *drive)
    {
	    ide_hwif_t *hwif = HWIF(drive);
	    int retries = 100;
	    u8 stat;

	    /*
	     * Last sector was transfered, wait until drive is ready.
	     * This can take up to 10 usec, but we will wait max 1 ms
	     * (drive_cmd_intr() waits that long).
	     */
	    while (((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) && retries--)
		    udelay(10);

	    if (!retries)
		    printk(KERN_ERR "%s: drive still BUSY!\n", drive->name);

	    return stat;
    }

`printk' is never called because `retries' never holds zero at the
outside of `while' loop: when `retries' holds zero at the while's loop
condition, `retries' will hold -1 at the if condition.

I'm not on this mailing list, so add my address to Cc: when you reply to me.


Signed-off-by: Masatake YAMATO <jet@gyve.org>


diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 30175c7..a74df05 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -246,7 +246,7 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 	 * This can take up to 10 usec, but we will wait max 1 ms
 	 * (drive_cmd_intr() waits that long).
 	 */
-	while (((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) && retries--)
+	while (((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) && --retries)
 		udelay(10);
 
 	if (!retries)


diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 30175c7..5e05311 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -249,7 +249,7 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 	while (((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) && retries--)
 		udelay(10);
 
-	if (!retries)
+	if (retries < 0)
 		printk(KERN_ERR "%s: drive still BUSY!\n", drive->name);
 
 	return stat;
