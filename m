Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbYJHUcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbYJHUcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 16:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbYJHUbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 16:31:31 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:26067 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbYJHUb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:31:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=GvBmD3r3/cpaRZYEUMTvII4TetYrGBBgcjHtH2BeKAzYe33PxVD5EYKRQP0zG/og/c
         MYjloWjOpEbUiYylBWyxTHd/uMpkuORtX/Zx6//GQSINhw/vYD9izQccBBBE1x27OIVf
         wwCWEFevT+5VYs9KGGRKj8nAxgdbU/u6hHUPo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 08 Oct 2008 22:29:53 +0200
Message-Id: <20081008202953.19112.36835.sendpatchset@localhost.localdomain>
In-Reply-To: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
References: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/7] ide: __ide_port_unregister_devices() doesn't need an ide_lock held
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: __ide_port_unregister_devices() doesn't need an ide_lock held

[ and ide_cfg_mtx mutex provides a sufficient protection for callers ]

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |    7 -------
 1 file changed, 7 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c	2008-09-17 22:17:58.000000000 -0700
+++ b/drivers/ide/ide.c	2008-09-17 22:20:15.000000000 -0700
@@ -130,7 +130,6 @@
 	}
 }
 
-/* Called with ide_lock held. */
 static void __ide_port_unregister_devices(ide_hwif_t *hwif)
 {
 	int i;
@@ -139,10 +138,8 @@
 		ide_drive_t *drive = &hwif->drives[i];
 
 		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
-			spin_unlock_irq(&ide_lock);
 			device_unregister(&drive->gendev);
 			wait_for_completion(&drive->gendev_rel_comp);
-			spin_lock_irq(&ide_lock);
 		}
 	}
 }
@@ -150,11 +147,9 @@
 void ide_port_unregister_devices(ide_hwif_t *hwif)
 {
 	mutex_lock(&ide_cfg_mtx);
-	spin_lock_irq(&ide_lock);
 	__ide_port_unregister_devices(hwif);
 	hwif->present = 0;
 	ide_port_init_devices_data(hwif);
-	spin_unlock_irq(&ide_lock);
 	mutex_unlock(&ide_cfg_mtx);
 }
 EXPORT_SYMBOL_GPL(ide_port_unregister_devices);
@@ -192,12 +187,10 @@
 
 	mutex_lock(&ide_cfg_mtx);
 
-	spin_lock_irq(&ide_lock);
 	if (hwif->present) {
 		__ide_port_unregister_devices(hwif);
 		hwif->present = 0;
 	}
-	spin_unlock_irq(&ide_lock);
 
 	ide_proc_unregister_port(hwif);
 
