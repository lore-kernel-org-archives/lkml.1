Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbZETPcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbZETPcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbZETPcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:32:15 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:60721 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbZETPcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=PiywZIrLc8hkSMcbNRpiXJVvT/9FVlVhrjxgDZsXbkHwogmlKJeUNraV8h1JAx1XvI
         pVvSNs3hByFeZZvReOEBRGt3YbZ/ZDyW8s9yS3hEvmlkIuw5f2kJGJSjTJtL5GEyzwjb
         Sf6osi95BziMsXip76j6WQ4PFG/3BqDo4n+Uk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: skip probe if there are no devices on the port
Date: Wed, 20 May 2009 17:33:06 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-next-20090518-05332-g0707b5a; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905201733.06830.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ide_probe_port() skip probe if ide_port_wait_ready() returns -ENODEV
and print error message instead of debug one if it returns -EBUSY.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
against Linus' tree

 drivers/ide/ide-probe.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -702,8 +702,12 @@ static int ide_probe_port(ide_hwif_t *hw
 	if (irqd)
 		disable_irq(hwif->irq);
 
-	if (ide_port_wait_ready(hwif) == -EBUSY)
-		printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);
+	rc = ide_port_wait_ready(hwif);
+	if (rc == -ENODEV) {
+		printk(KERN_INFO "%s: no devices on the port\n", hwif->name);
+		goto out;
+	} else if (rc == -EBUSY)
+		printk(KERN_ERR "%s: not ready before the probe\n", hwif->name);
 
 	/*
 	 * Second drive should only exist if first drive was found,
@@ -714,7 +718,7 @@ static int ide_probe_port(ide_hwif_t *hw
 		if (drive->dev_flags & IDE_DFLAG_PRESENT)
 			rc = 0;
 	}
-
+out:
 	/*
 	 * Use cached IRQ number. It might be (and is...) changed by probe
 	 * code above
