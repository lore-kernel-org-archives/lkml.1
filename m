Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbYEZU2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbYEZU2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 16:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbYEZU2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 16:28:00 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:5675 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbYEZU17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 16:27:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=kkERn0vRj8HFQTDlb8SriNYIC0d255AAPFLL4FdSYPzsJXkDZfDbw6sVwCmrJKGnHmffnT/r5dVr+xL5uiCXlYUUV0u5H/Bz5YjZg3WLskkkq5h5VDkDMd0NskAehTa6/HTGeUWffyHDMrsGpipqkpsRejzLkGNltjdLc8d5Msc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: use __generic_unplug_device() in ide_do_drive_cmd() (take 2)
Date: Tue, 27 May 2008 22:01:57 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Borislav Petkov <petkovbb@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805272201.58035.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Call __elv_add_request() with 'plug' == 1 (so the device will be
  plugged) and then use __generic_unplug_device() instead of calling
  ide_do_request() directly.

v2:
* For blk_pm_resume_request() requests the queue is stopped so we
  need to call ->request_fn explicitly.

  Thanks to:
  - Rafael for reporting/bisecting the bug
  - Borislav/Rafael for testing the fix

This is a preparation for converting IDE to use blk_execute_rq().

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
replacement patch

 drivers/ide/ide-io.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1606,8 +1606,11 @@ int ide_do_drive_cmd (ide_drive_t *drive
 	spin_lock_irqsave(&ide_lock, flags);
 	if (action == ide_preempt)
 		hwgroup->rq = NULL;
-	__elv_add_request(drive->queue, rq, where, 0);
-	ide_do_request(hwgroup, IDE_NO_IRQ);
+	__elv_add_request(drive->queue, rq, where, 1);
+	__generic_unplug_device(drive->queue);
+	/* the queue is stopped so it won't be plugged+unplugged */
+	if (blk_pm_resume_request(rq))
+		do_ide_request(drive->queue);
 	spin_unlock_irqrestore(&ide_lock, flags);
 
 	err = 0;
