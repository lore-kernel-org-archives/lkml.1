Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbZBWWup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbZBWWup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 17:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZBWWua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 17:50:30 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:59596 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbZBWWu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 17:50:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=DbreJ77XQS5qCN3rV7C7DMi+SuXfLOt1nJWkCTvHBRA/NWh0qKdIuuH2MO+6RCvAu3
         Ln7cWQlIadNSxR6DrJaT1ZyyJ9PpLrXDE2MGXyixQF0yvzvPBRLuipWEtEB2uq0l5Lse
         70yvSZSFNc8TGLrhqb9uaCjqBnlmpnAGz0hzQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: fix locking in drive_release_dev()
Date: Mon, 23 Feb 2009 23:38:40 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090220-dirty; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902232338.40646.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix locking in drive_release_dev()

* Request queue cleanup should happen before freeing drive->id
  and marking device as non-present.  Fix it.

* Remove superfluous hwif->lock acquiring/releasing.

Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
I noticed this while investigating the host driver removal
issue -- lets also fix/test this one while we are at it...

 drivers/ide/ide-probe.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -937,20 +937,16 @@ EXPORT_SYMBOL_GPL(ide_init_disk);
 static void drive_release_dev (struct device *dev)
 {
 	ide_drive_t *drive = container_of(dev, ide_drive_t, gendev);
-	ide_hwif_t *hwif = drive->hwif;
 
 	ide_proc_unregister_device(drive);
 
-	spin_lock_irq(&hwif->lock);
+	blk_cleanup_queue(drive->queue);
+	drive->queue = NULL;
+
 	kfree(drive->id);
 	drive->id = NULL;
+
 	drive->dev_flags &= ~IDE_DFLAG_PRESENT;
-	/* Messed up locking ... */
-	spin_unlock_irq(&hwif->lock);
-	blk_cleanup_queue(drive->queue);
-	spin_lock_irq(&hwif->lock);
-	drive->queue = NULL;
-	spin_unlock_irq(&hwif->lock);
 
 	complete(&drive->gendev_rel_comp);
 }
