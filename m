Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbZASOSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbZASOSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZASOOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:14:43 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49200 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZASOOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:14:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ZgqkqwBe/0um28XQB6Q6E+xgTL8ro9GTcwFJZjJrkwI/UuMrHnISM0t4S6Hgogjj86
         dCbFZBnNBGs7LoLl+wXTXrCg8rsmFbyMGpbw9Oy30cGoD8cAQK+V8BnOYutoD9QjQ2om
         oteGS05gq/FGI7APmGtPB2nfwmLLdgjW7FMd0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 15:15:03 +0100
Message-Id: <20090119141503.27613.57510.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
References: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/12] ide: remove no longer needed IRQ auto-probing from try_to_identify()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove no longer needed IRQ auto-probing from try_to_identify()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   46 ++++++----------------------------------------
 1 file changed, 6 insertions(+), 40 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -334,56 +334,22 @@ static int actual_try_to_identify (ide_d
  *	@drive: drive to probe
  *	@cmd: command to use
  *
- *	Issue the identify command and then do IRQ probing to
- *	complete the identification when needed by finding the
- *	IRQ the drive is attached to
+ *	Issue the identify command.
  */
  
 static int try_to_identify (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
-	int retval;
-	int autoprobe = 0;
-	unsigned long cookie = 0;
 
 	/*
-	 * Disable device irq unless we need to
-	 * probe for it. Otherwise we'll get spurious
-	 * interrupts during the identify-phase that
-	 * the irq handler isn't expecting.
+	 * Disable device IRQ.  Otherwise we'll get spurious interrupts
+	 * during the identify phase that the IRQ handler isn't expecting.
 	 */
-	if (hwif->io_ports.ctl_addr) {
-		if (!hwif->irq) {
-			autoprobe = 1;
-			cookie = probe_irq_on();
-		}
-		tp_ops->set_irq(hwif, autoprobe);
-	}
-
-	retval = actual_try_to_identify(drive, cmd);
-
-	if (autoprobe) {
-		int irq;
-
+	if (hwif->io_ports.ctl_addr)
 		tp_ops->set_irq(hwif, 0);
-		/* clear drive IRQ */
-		(void)tp_ops->read_status(hwif);
-		udelay(5);
-		irq = probe_irq_off(cookie);
-		if (!hwif->irq) {
-			if (irq > 0) {
-				hwif->irq = irq;
-			} else {
-				/* Mmmm.. multiple IRQs..
-				 * don't know which was ours
-				 */
-				printk(KERN_ERR "%s: IRQ probe failed (0x%lx)\n",
-					drive->name, cookie);
-			}
-		}
-	}
-	return retval;
+
+	return actual_try_to_identify(drive, cmd);
 }
 
 int ide_busy_sleep(ide_hwif_t *hwif, unsigned long timeout, int altstatus)
