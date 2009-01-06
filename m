Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZAFSgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZAFSgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbZAFSfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:35:14 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63672 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbZAFSfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:35:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ezlaqn8khOSEa0omrjK2pnJAl1JyZ8V9hG2z+0gmHSajPg2mxaH/L/tUSmYKGbFZQr
         pyNs2MsqyoV1u2yC1M3jlDScD/St4hUEU1dGlUywXnc5/iSUpM6rviy9b112HvDmJKGo
         1g9lkSlawjjuhfVNbg2q0VkZMtbMeHmSG+AGk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 06 Jan 2009 19:35:55 +0100
Message-Id: <20090106183555.21193.22192.sendpatchset@localhost.localdomain>
In-Reply-To: <20090106183520.21193.63704.sendpatchset@localhost.localdomain>
References: <20090106183520.21193.63704.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/9] ide: no need to touch local IRQs in ide_probe_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: no need to touch local IRQs in ide_probe_port()

Remove superfluous local_irq_{save,enable_in_hardirq,restore}() combo.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    6 ------
 1 file changed, 6 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -778,7 +778,6 @@ EXPORT_SYMBOL_GPL(ide_undecoded_slave);
 static int ide_probe_port(ide_hwif_t *hwif)
 {
 	ide_drive_t *drive;
-	unsigned long flags;
 	unsigned int irqd;
 	int i, rc = -ENODEV;
 
@@ -796,9 +795,6 @@ static int ide_probe_port(ide_hwif_t *hw
 	if (irqd)
 		disable_irq(hwif->irq);
 
-	local_irq_save(flags);
-	local_irq_enable_in_hardirq();
-
 	if (ide_port_wait_ready(hwif) == -EBUSY)
 		printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);
 
@@ -812,8 +808,6 @@ static int ide_probe_port(ide_hwif_t *hw
 			rc = 0;
 	}
 
-	local_irq_restore(flags);
-
 	/*
 	 * Use cached IRQ number. It might be (and is...) changed by probe
 	 * code above
