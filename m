Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbZBARwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbZBARwb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbZBARtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:49:32 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:54728 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbZBARt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:49:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Oif2orbow1iKkizrKuByw9vExRx25pxucUdZD6TKBow7gBl5Sgqy9YT/mV3C3IlCo9
         ++LsC/ECML70gjYhyrfH5m5BAQgl+T7kKyYSqaKFWMEkxc5YoYdLHhZmvao4tFhz6q+R
         8aPM4OUBn9ICu/TI6Ik60f/2PY4dlE9iGVOUo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 18:50:19 +0100
Message-Id: <20090201175019.19144.73712.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/15] ide: complete power step in ide_complete_pm_request()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: complete power step in ide_complete_pm_request()

* Complete power step in ide_complete_pm_request().

* Rename ide_complete_pm_request() to ide_complete_pm_rq().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |    8 ++------
 drivers/ide/ide-pm.c |    9 +++++++--
 include/linux/ide.h  |    2 +-
 3 files changed, 10 insertions(+), 9 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -178,11 +178,7 @@ void ide_end_drive_cmd (ide_drive_t *dri
 				kfree(task);
 		}
 	} else if (blk_pm_request(rq)) {
-		struct request_pm_state *pm = rq->data;
-
-		ide_complete_power_step(drive, rq);
-		if (pm->pm_step == IDE_PM_COMPLETED)
-			ide_complete_pm_request(drive, rq);
+		ide_complete_pm_rq(drive, rq);
 		return;
 	}
 
@@ -438,7 +434,7 @@ static ide_startstop_t start_request (id
 			startstop = ide_start_power_step(drive, rq);
 			if (startstop == ide_stopped &&
 			    pm->pm_step == IDE_PM_COMPLETED)
-				ide_complete_pm_request(drive, rq);
+				ide_complete_pm_rq(drive, rq);
 			return startstop;
 		} else if (!rq->rq_disk && blk_special_request(rq))
 			/*
Index: b/drivers/ide/ide-pm.c
===================================================================
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -169,18 +169,23 @@ out_do_tf:
 }
 
 /**
- *	ide_complete_pm_request - end the current Power Management request
+ *	ide_complete_pm_rq - end the current Power Management request
  *	@drive: target drive
  *	@rq: request
  *
  *	This function cleans up the current PM request and stops the queue
  *	if necessary.
  */
-void ide_complete_pm_request(ide_drive_t *drive, struct request *rq)
+void ide_complete_pm_rq(ide_drive_t *drive, struct request *rq)
 {
 	struct request_queue *q = drive->queue;
+	struct request_pm_state *pm = rq->data;
 	unsigned long flags;
 
+	ide_complete_power_step(drive, rq);
+	if (pm->pm_step != IDE_PM_COMPLETED)
+		return;
+
 #ifdef DEBUG_PM
 	printk("%s: completing PM request, %s\n", drive->name,
 	       blk_pm_suspend_request(rq) ? "suspend" : "resume");
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1078,7 +1078,7 @@ int generic_ide_resume(struct device *);
 
 void ide_complete_power_step(ide_drive_t *, struct request *);
 ide_startstop_t ide_start_power_step(ide_drive_t *, struct request *);
-void ide_complete_pm_request(ide_drive_t *, struct request *);
+void ide_complete_pm_rq(ide_drive_t *, struct request *);
 void ide_check_pm_state(ide_drive_t *, struct request *);
 
 /*
