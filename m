Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbYECNMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbYECNMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 09:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757721AbYECNL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 09:11:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:31321 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbYECNLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 09:11:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Cy5KwnZ7bbiX7wxmlhkdi5AxY1VvbBA5Zo39r2ya00YFbqn90KRm0sCmXMuAHhJ6gAHTCB6PzA3qzfVh5tR9+BWQ3bPY8UM8tkRn9w4nlQqde6SR7Sgx4Y6V+lGhbf67kw85fCeMasfpAzGZWJF2r0ywstLLsUc6SuzW6q8SBRk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] ide: use __generic_unplug_device() in ide_do_drive_cmd()
Date: Sat, 3 May 2008 15:27:02 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Borislav Petkov <petkovbb@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805031527.02400.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call __elv_add_request() with 'plug' == 1 (so the device will be
plugged) and then use __generic_unplug_device() instead of calling
ide_do_request() directly.

This is a preparation for converting IDE to use blk_execute_rq().

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
while the change should be OK it is really better to handle it before
the real conversion

 drivers/ide/ide-io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1608,8 +1608,8 @@ int ide_do_drive_cmd (ide_drive_t *drive
 	spin_lock_irqsave(&ide_lock, flags);
 	if (action == ide_preempt)
 		hwgroup->rq = NULL;
-	__elv_add_request(drive->queue, rq, where, 0);
-	ide_do_request(hwgroup, IDE_NO_IRQ);
+	__elv_add_request(drive->queue, rq, where, 1);
+	__generic_unplug_device(drive->queue);
 	spin_unlock_irqrestore(&ide_lock, flags);
 
 	err = 0;
