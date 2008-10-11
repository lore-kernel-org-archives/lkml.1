Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbYJKOU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbYJKOU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 10:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYJKOUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 10:20:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:23635 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbYJKOUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 10:20:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Pm/pU7JzSVKn3hT5y05Zr34WYumErMeFRcqKPjOihU2cA46AeH5QRnQkDehzTulSoA
         wGuAXitqyvHahmNSHbq7po3m5hr7qubJBw1+cvdAqVm91H0EZH1fpvdnOxg7ZPePkJlC
         et4TyA14g+2g35bwXxToAn/kC7esa8iTCXDBA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ide: don't execute the next queued command from the hard-IRQ context
Date: Sat, 11 Oct 2008 16:17:50 +0200
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810111617.51298.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: don't execute the next queued command from the hard-IRQ context

* Tell the block layer that we are not done handling requests by using
  blk_plug_device() in ide_do_request() (request handling function)
  and ide_timer_expiry() (timeout handler) if the queue is not empty.

* Remove optimization which directly calls ide_do_request() for the next
  queued command from the ide_intr() (IRQ handler) and ide_timer_expiry().

* Remove no longer needed IRQ masking from ide_do_request() - in case of
  IDE ports needing serialization disable_irq_nosync()/enable_irq() was
  used for the (possibly shared) IRQ of the other IDE port.

* Put the misplaced comment in the right place in ide_do_request().

* Drop no longer needed 'int masked_irq' argument from ide_do_request().

* Merge ide_do_request() into do_ide_request().

* Remove no longer needed IDE_NO_IRQ define.

While at it:

* Don't use HWGROUP() macro in do_ide_request().

* Use __func__ in ide_intr().

This patch reduces IRQ hadling latency for IDE and improves the system-wide
handling of shared IRQs (which should result in more timeout resistant and
stable IDE systems).  It also makes it possible to do some further changes
later (i.e. replace some busy-waiting delays with sleeping equivalents).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
on top of per-hwgroup locks patch and with a special dedication to people
complaining about improving IDE ;)

 drivers/ide/ide-io.c |   59 ++++++++++++++++++++++-----------------------------
 include/linux/ide.h  |    7 ------
 2 files changed, 26 insertions(+), 40 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -939,8 +939,10 @@ repeat:	
  * the driver.  This makes the driver much more friendlier to shared IRQs
  * than previous designs, while remaining 100% (?) SMP safe and capable.
  */
-static void ide_do_request (ide_hwgroup_t *hwgroup, int masked_irq)
+void do_ide_request(struct request_queue *q)
 {
+	ide_drive_t	*orig_drive = q->queuedata;
+	ide_hwgroup_t	*hwgroup = orig_drive->hwif->hwgroup;
 	ide_drive_t	*drive;
 	ide_hwif_t	*hwif;
 	struct request	*rq;
@@ -999,8 +1001,11 @@ static void ide_do_request (ide_hwgroup_
 			}
 
 			/* no more work for this hwgroup (for now) */
-			return;
+			goto plug_device;
 		}
+
+		if (drive != orig_drive)
+			goto plug_device;
 	again:
 		hwif = HWIF(drive);
 		if (hwgroup->hwif->sharing_irq && hwif != hwgroup->hwif) {
@@ -1055,41 +1060,27 @@ static void ide_do_request (ide_hwgroup_
 				goto again;
 			/* We clear busy, there should be no pending ATA command at this point. */
 			hwgroup->busy = 0;
-			break;
+			goto plug_device;
 		}
 
 		hwgroup->rq = rq;
 
-		/*
-		 * Some systems have trouble with IDE IRQs arriving while
-		 * the driver is still setting things up.  So, here we disable
-		 * the IRQ used by this interface while the request is being started.
-		 * This may look bad at first, but pretty much the same thing
-		 * happens anyway when any interrupt comes in, IDE or otherwise
-		 *  -- the kernel masks the IRQ while it is being handled.
-		 */
-		if (masked_irq != IDE_NO_IRQ && hwif->irq != masked_irq)
-			disable_irq_nosync(hwif->irq);
 		spin_unlock(&hwgroup->lock);
+		/* allow other IRQs while we start this request */
 		local_irq_enable_in_hardirq();
-			/* allow other IRQs while we start this request */
 		startstop = start_request(drive, rq);
 		spin_lock_irq(&hwgroup->lock);
-		if (masked_irq != IDE_NO_IRQ && hwif->irq != masked_irq)
-			enable_irq(hwif->irq);
-		if (startstop == ide_stopped)
+
+		if (startstop == ide_stopped) {
 			hwgroup->busy = 0;
+			goto plug_device;
+		}
 	}
-}
+	return;
 
-/*
- * Passes the stuff to ide_do_request
- */
-void do_ide_request(struct request_queue *q)
-{
-	ide_drive_t *drive = q->queuedata;
-
-	ide_do_request(HWGROUP(drive), IDE_NO_IRQ);
+plug_device:
+	if (!elv_queue_empty(orig_drive->queue))
+		blk_plug_device(orig_drive->queue);
 }
 
 /*
@@ -1241,11 +1232,13 @@ void ide_timer_expiry (unsigned long dat
 			drive->service_time = jiffies - drive->service_start;
 			spin_lock_irq(&hwgroup->lock);
 			enable_irq(hwif->irq);
-			if (startstop == ide_stopped)
+			if (startstop == ide_stopped) {
 				hwgroup->busy = 0;
+				if (!elv_queue_empty(drive->queue))
+					blk_plug_device(drive->queue);
+			}
 		}
 	}
-	ide_do_request(hwgroup, IDE_NO_IRQ);
 	spin_unlock_irqrestore(&hwgroup->lock, flags);
 }
 
@@ -1438,11 +1431,11 @@ irqreturn_t ide_intr (int irq, void *dev
 	if (startstop == ide_stopped) {
 		if (hwgroup->handler == NULL) {	/* paranoia */
 			hwgroup->busy = 0;
-			ide_do_request(hwgroup, hwif->irq);
-		} else {
-			printk(KERN_ERR "%s: ide_intr: huh? expected NULL handler "
-				"on exit\n", drive->name);
-		}
+			if (!elv_queue_empty(drive->queue))
+				blk_plug_device(drive->queue);
+		} else
+			printk(KERN_ERR "%s: %s: huh? expected NULL handler "
+					"on exit\n", __func__, drive->name);
 	}
 out_handled:
 	irq_ret = IRQ_HANDLED;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -32,13 +32,6 @@
 # define SUPPORT_VLB_SYNC 1
 #endif
 
-/*
- * Used to indicate "no IRQ", should be a value that cannot be an IRQ
- * number.
- */
- 
-#define IDE_NO_IRQ		(-1)
-
 typedef unsigned char	byte;	/* used everywhere */
 
 /*
