Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYGEMve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYGEMve (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 08:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYGEMvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 08:51:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:52909 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbYGEMvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 08:51:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=l6jzeU428LY9UxLBKI4+AiKFiIZsxZHD2bFAI8gV8Ri+Itnu8iSRohyZDJpOKYb3X0
         vMRLu9jXhSK2+ZUuHOJ8Nc4YEix0b+vPRqeagGK1olHp1Y7QRPo7htoAoSICJbjClPvK
         GXq6/yAts4hoU6ppONThMFY7PuLeX4unIa074=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] ide: ide_unregister() warm-plug bugfix
Date: Sat, 5 Jul 2008 14:50:01 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807051450.01321.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ide_unregister() to work for ports with no devices attached to them.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
for 2.6.26

 drivers/ide/ide.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -315,13 +315,14 @@ void ide_unregister(ide_hwif_t *hwif)
 
 	BUG_ON(in_interrupt());
 	BUG_ON(irqs_disabled());
+
 	mutex_lock(&ide_cfg_mtx);
-	spin_lock_irq(&ide_lock);
-	if (!hwif->present)
-		goto abort;
-	__ide_port_unregister_devices(hwif);
-	hwif->present = 0;
 
+	spin_lock_irq(&ide_lock);
+	if (hwif->present) {
+		__ide_port_unregister_devices(hwif);
+		hwif->present = 0;
+	}
 	spin_unlock_irq(&ide_lock);
 
 	ide_proc_unregister_port(hwif);
@@ -359,7 +360,6 @@ void ide_unregister(ide_hwif_t *hwif)
 	/* restore hwif data to pristine status */
 	ide_init_port_data(hwif, hwif->index);
 
-abort:
 	spin_unlock_irq(&ide_lock);
 	mutex_unlock(&ide_cfg_mtx);
 }
