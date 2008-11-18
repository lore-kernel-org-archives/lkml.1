Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbYKRUXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbYKRUXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 15:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYKRUWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 15:22:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:56076 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYKRUW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 15:22:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=sWZn8FJfTwA3qTVry7ANmS5RnnqafzXoDmaRWU02bEwkt+lcOW0RgkZIMH2od4BDhF
         TedL0SwAaEbzZc98upeuGlc/QCdVftwgpaVO8flg4zbSxhYyXtREb5U1mViotpSFGIXy
         BRp1aqQC7YS/EADIdmoDGOV4JGHSkB/e3ZwZU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] ide: use per-device request queue locks
Date: Tue, 18 Nov 2008 21:19:21 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Elias Oltmanns <eo@nebensachen.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811182119.21286.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move hack for flush requests from choose_drive() to do_ide_request().

* Add ide_plug_device() helper and convert core IDE code from using
  per-hwgroup lock as a request lock to use the ->queue_lock instead.

* Remove no longer needed:
  - choose_drive() function
  - WAKEUP() macro
  - 'sleeping' flag from ide_hwif_t
  - 'service_{start,time}' fields from ide_drive_t

This patch results in much simpler and more maintainable code
(besides being a scalability improvement).

Cc: Elias Oltmanns <eo@nebensachen.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
newer version

 drivers/ide/ide-io.c    |  213 +++++++++++++++---------------------------------
 drivers/ide/ide-park.c  |   13 +-
 drivers/ide/ide-probe.c |    3 
 include/linux/ide.h     |    4 
 4 files changed, 79 insertions(+), 154 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -667,85 +667,10 @@ void ide_stall_queue (ide_drive_t *drive
 	drive->sleep = timeout + jiffies;
 	drive->dev_flags |= IDE_DFLAG_SLEEPING;
 }
-
 EXPORT_SYMBOL(ide_stall_queue);
 
-#define WAKEUP(drive)	((drive)->service_start + 2 * (drive)->service_time)
-
-/**
- *	choose_drive		-	select a drive to service
- *	@hwgroup: hardware group to select on
- *
- *	choose_drive() selects the next drive which will be serviced.
- *	This is necessary because the IDE layer can't issue commands
- *	to both drives on the same cable, unlike SCSI.
- */
- 
-static inline ide_drive_t *choose_drive (ide_hwgroup_t *hwgroup)
-{
-	ide_drive_t *drive, *best;
-
-repeat:	
-	best = NULL;
-	drive = hwgroup->drive;
-
-	/*
-	 * drive is doing pre-flush, ordered write, post-flush sequence. even
-	 * though that is 3 requests, it must be seen as a single transaction.
-	 * we must not preempt this drive until that is complete
-	 */
-	if (blk_queue_flushing(drive->queue)) {
-		/*
-		 * small race where queue could get replugged during
-		 * the 3-request flush cycle, just yank the plug since
-		 * we want it to finish asap
-		 */
-		blk_remove_plug(drive->queue);
-		return drive;
-	}
-
-	do {
-		u8 dev_s = !!(drive->dev_flags & IDE_DFLAG_SLEEPING);
-		u8 best_s = (best && !!(best->dev_flags & IDE_DFLAG_SLEEPING));
-
-		if ((dev_s == 0 || time_after_eq(jiffies, drive->sleep)) &&
-		    !elv_queue_empty(drive->queue)) {
-			if (best == NULL ||
-			    (dev_s && (best_s == 0 || time_before(drive->sleep, best->sleep))) ||
-			    (best_s == 0 && time_before(WAKEUP(drive), WAKEUP(best)))) {
-				if (!blk_queue_plugged(drive->queue))
-					best = drive;
-			}
-		}
-	} while ((drive = drive->next) != hwgroup->drive);
-
-	if (best && (best->dev_flags & IDE_DFLAG_NICE1) &&
-	    (best->dev_flags & IDE_DFLAG_SLEEPING) == 0 &&
-	    best != hwgroup->drive && best->service_time > WAIT_MIN_SLEEP) {
-		long t = (signed long)(WAKEUP(best) - jiffies);
-		if (t >= WAIT_MIN_SLEEP) {
-		/*
-		 * We *may* have some time to spare, but first let's see if
-		 * someone can potentially benefit from our nice mood today..
-		 */
-			drive = best->next;
-			do {
-				if ((drive->dev_flags & IDE_DFLAG_SLEEPING) == 0
-				 && time_before(jiffies - best->service_time, WAKEUP(drive))
-				 && time_before(WAKEUP(drive), jiffies + t))
-				{
-					ide_stall_queue(best, min_t(long, t, 10 * WAIT_MIN_SLEEP));
-					goto repeat;
-				}
-			} while ((drive = drive->next) != best);
-		}
-	}
-	return best;
-}
-
 /*
  * Issue a new request to a drive from hwgroup
- * Caller must have already done spin_lock_irqsave(&hwgroup->lock, ..);
  *
  * A hwgroup is a serialized group of IDE interfaces.  Usually there is
  * exactly one hwif (interface) per hwgroup, but buggy controllers (eg. CMD640)
@@ -757,8 +682,7 @@ repeat:	
  * possibly along with many other devices.  This is especially common in
  * PCI-based systems with off-board IDE controller cards.
  *
- * The IDE driver uses a per-hwgroup spinlock to protect
- * access to the request queues, and to protect the hwgroup->busy flag.
+ * The IDE driver uses a per-hwgroup lock to protect the hwgroup->busy flag.
  *
  * The first thread into the driver for a particular hwgroup sets the
  * hwgroup->busy flag to indicate that this hwgroup is now active,
@@ -780,61 +704,40 @@ repeat:	
  */
 void do_ide_request(struct request_queue *q)
 {
-	ide_drive_t	*orig_drive = q->queuedata;
-	ide_hwgroup_t	*hwgroup = orig_drive->hwif->hwgroup;
-	ide_drive_t	*drive;
-	ide_hwif_t	*hwif;
+	ide_drive_t	*drive = q->queuedata;
+	ide_hwif_t	*hwif = drive->hwif;
+	ide_hwgroup_t	*hwgroup = hwif->hwgroup;
 	struct request	*rq;
 	ide_startstop_t	startstop;
 
-	/* caller must own hwgroup->lock */
-	BUG_ON(!irqs_disabled());
-
-	while (!ide_lock_hwgroup(hwgroup)) {
-		drive = choose_drive(hwgroup);
-		if (drive == NULL) {
-			int sleeping = 0;
-			unsigned long sleep = 0; /* shut up, gcc */
-			hwgroup->rq = NULL;
-			drive = hwgroup->drive;
-			do {
-				if ((drive->dev_flags & IDE_DFLAG_SLEEPING) &&
-				    (sleeping == 0 ||
-				     time_before(drive->sleep, sleep))) {
-					sleeping = 1;
-					sleep = drive->sleep;
-				}
-			} while ((drive = drive->next) != hwgroup->drive);
-			if (sleeping) {
+	/*
+	 * drive is doing pre-flush, ordered write, post-flush sequence. even
+	 * though that is 3 requests, it must be seen as a single transaction.
+	 * we must not preempt this drive until that is complete
+	 */
+	if (blk_queue_flushing(q))
 		/*
-		 * Take a short snooze, and then wake up this hwgroup again.
-		 * This gives other hwgroups on the same a chance to
-		 * play fairly with us, just in case there are big differences
-		 * in relative throughputs.. don't want to hog the cpu too much.
+		 * small race where queue could get replugged during
+		 * the 3-request flush cycle, just yank the plug since
+		 * we want it to finish asap
 		 */
-				if (time_before(sleep, jiffies + WAIT_MIN_SLEEP))
-					sleep = jiffies + WAIT_MIN_SLEEP;
-#if 1
-				if (timer_pending(&hwgroup->timer))
-					printk(KERN_CRIT "ide_set_handler: timer already active\n");
-#endif
-				/* so that ide_timer_expiry knows what to do */
-				hwgroup->sleeping = 1;
-				hwgroup->req_gen_timer = hwgroup->req_gen;
-				mod_timer(&hwgroup->timer, sleep);
-				/* we purposely leave hwgroup locked
-				 * while sleeping */
-			} else
-				ide_unlock_hwgroup(hwgroup);
+		blk_remove_plug(q);
 
-			/* no more work for this hwgroup (for now) */
-			goto plug_device;
-		}
+	spin_unlock_irq(q->queue_lock);
+	spin_lock_irq(&hwgroup->lock);
 
-		if (drive != orig_drive)
-			goto plug_device;
+	/* caller must own hwgroup->lock */
+	BUG_ON(!irqs_disabled());
 
-		hwif = drive->hwif;
+	if (!ide_lock_hwgroup(hwgroup)) {
+		hwgroup->rq = NULL;
+
+		if (drive->dev_flags & IDE_DFLAG_SLEEPING) {
+			if (time_before(drive->sleep, jiffies)) {
+				ide_unlock_hwgroup(hwgroup);
+				goto plug_device;
+			}
+		}
 
 		if (hwif != hwgroup->hwif) {
 			/*
@@ -847,16 +750,20 @@ void do_ide_request(struct request_queue
 		hwgroup->hwif = hwif;
 		hwgroup->drive = drive;
 		drive->dev_flags &= ~(IDE_DFLAG_SLEEPING | IDE_DFLAG_PARKED);
-		drive->service_start = jiffies;
 
+		spin_unlock_irq(&hwgroup->lock);
+		spin_lock_irq(q->queue_lock);
 		/*
 		 * we know that the queue isn't empty, but this can happen
 		 * if the q->prep_rq_fn() decides to kill a request
 		 */
 		rq = elv_next_request(drive->queue);
+		spin_unlock_irq(q->queue_lock);
+		spin_lock_irq(&hwgroup->lock);
+
 		if (!rq) {
 			ide_unlock_hwgroup(hwgroup);
-			break;
+			goto out;
 		}
 
 		/*
@@ -888,15 +795,22 @@ void do_ide_request(struct request_queue
 
 		if (startstop == ide_stopped) {
 			ide_unlock_hwgroup(hwgroup);
-			if (!elv_queue_empty(orig_drive->queue))
-				blk_plug_device(orig_drive->queue);
+			/* give other devices a chance */
+			goto plug_device;
 		}
-	}
+	} else
+		goto plug_device;
+out:
+	spin_unlock_irq(&hwgroup->lock);
+	spin_lock_irq(q->queue_lock);
 	return;
 
 plug_device:
-	if (!elv_queue_empty(orig_drive->queue))
-		blk_plug_device(orig_drive->queue);
+	spin_unlock_irq(&hwgroup->lock);
+	spin_lock_irq(q->queue_lock);
+
+	if (!elv_queue_empty(q))
+		blk_plug_device(q);
 }
 
 /*
@@ -957,6 +871,17 @@ out:
 	return ret;
 }
 
+static void ide_plug_device(ide_drive_t *drive)
+{
+	struct request_queue *q = drive->queue;
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (!elv_queue_empty(q))
+		blk_plug_device(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
 /**
  *	ide_timer_expiry	-	handle lack of an IDE interrupt
  *	@data: timer callback magic (hwgroup)
@@ -974,10 +899,12 @@ out:
 void ide_timer_expiry (unsigned long data)
 {
 	ide_hwgroup_t	*hwgroup = (ide_hwgroup_t *) data;
+	ide_drive_t	*uninitialized_var(drive);
 	ide_handler_t	*handler;
 	ide_expiry_t	*expiry;
 	unsigned long	flags;
 	unsigned long	wait = -1;
+	int		plug_device = 0;
 
 	spin_lock_irqsave(&hwgroup->lock, flags);
 
@@ -989,12 +916,8 @@ void ide_timer_expiry (unsigned long dat
 		 * or we were "sleeping" to give other devices a chance.
 		 * Either way, we don't really want to complain about anything.
 		 */
-		if (hwgroup->sleeping) {
-			hwgroup->sleeping = 0;
-			ide_unlock_hwgroup(hwgroup);
-		}
 	} else {
-		ide_drive_t *drive = hwgroup->drive;
+		drive = hwgroup->drive;
 		if (!drive) {
 			printk(KERN_ERR "ide_timer_expiry: hwgroup->drive was NULL\n");
 			hwgroup->handler = NULL;
@@ -1042,17 +965,18 @@ void ide_timer_expiry (unsigned long dat
 					ide_error(drive, "irq timeout",
 						  hwif->tp_ops->read_status(hwif));
 			}
-			drive->service_time = jiffies - drive->service_start;
 			spin_lock_irq(&hwgroup->lock);
 			enable_irq(hwif->irq);
 			if (startstop == ide_stopped) {
 				ide_unlock_hwgroup(hwgroup);
-				if (!elv_queue_empty(drive->queue))
-					blk_plug_device(drive->queue);
+				plug_device = 1;
 			}
 		}
 	}
 	spin_unlock_irqrestore(&hwgroup->lock, flags);
+
+	if (plug_device)
+		ide_plug_device(drive);
 }
 
 /**
@@ -1146,10 +1070,11 @@ irqreturn_t ide_intr (int irq, void *dev
 	unsigned long flags;
 	ide_hwgroup_t *hwgroup = (ide_hwgroup_t *)dev_id;
 	ide_hwif_t *hwif = hwgroup->hwif;
-	ide_drive_t *drive;
+	ide_drive_t *uninitialized_var(drive);
 	ide_handler_t *handler;
 	ide_startstop_t startstop;
 	irqreturn_t irq_ret = IRQ_NONE;
+	int plug_device = 0;
 
 	spin_lock_irqsave(&hwgroup->lock, flags);
 
@@ -1236,12 +1161,10 @@ irqreturn_t ide_intr (int irq, void *dev
 	 * same irq as is currently being serviced here, and Linux
 	 * won't allow another of the same (on any CPU) until we return.
 	 */
-	drive->service_time = jiffies - drive->service_start;
 	if (startstop == ide_stopped) {
 		if (hwgroup->handler == NULL) {	/* paranoia */
 			ide_unlock_hwgroup(hwgroup);
-			if (!elv_queue_empty(drive->queue))
-				blk_plug_device(drive->queue);
+			plug_device = 1;
 		} else
 			printk(KERN_ERR "%s: %s: huh? expected NULL handler "
 					"on exit\n", __func__, drive->name);
@@ -1250,6 +1173,10 @@ out_handled:
 	irq_ret = IRQ_HANDLED;
 out:
 	spin_unlock_irqrestore(&hwgroup->lock, flags);
+
+	if (plug_device)
+		ide_plug_device(drive);
+
 	return irq_ret;
 }
 
Index: b/drivers/ide/ide-park.c
===================================================================
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -16,16 +16,19 @@ static void issue_park_cmd(ide_drive_t *
 	spin_lock_irq(&hwgroup->lock);
 	if (drive->dev_flags & IDE_DFLAG_PARKED) {
 		int reset_timer = time_before(timeout, drive->sleep);
+		int start_queue = 0;
 
 		drive->sleep = timeout;
 		wake_up_all(&ide_park_wq);
-		if (reset_timer && hwgroup->sleeping &&
-		    del_timer(&hwgroup->timer)) {
-			hwgroup->sleeping = 0;
-			ide_unlock_hwgroup(hwgroup);
+		if (reset_timer && del_timer(&hwgroup->timer))
+			start_queue = 1;
+		spin_unlock_irq(&hwgroup->lock);
+
+		if (start_queue) {
+			spin_lock_irq(q->queue_lock);
 			blk_start_queueing(q);
+			spin_unlock_irq(q->queue_lock);
 		}
-		spin_unlock_irq(&hwgroup->lock);
 		return;
 	}
 	spin_unlock_irq(&hwgroup->lock);
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -880,8 +880,7 @@ static int ide_init_queue(ide_drive_t *d
 	 *	do not.
 	 */
 
-	q = blk_init_queue_node(do_ide_request, &hwif->hwgroup->lock,
-				hwif_to_node(hwif));
+	q = blk_init_queue_node(do_ide_request, NULL, hwif_to_node(hwif));
 	if (!q)
 		return 1;
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -603,8 +603,6 @@ struct ide_drive_s {
 	unsigned long dev_flags;
 
 	unsigned long sleep;		/* sleep until this time */
-	unsigned long service_start;	/* time we started last request */
-	unsigned long service_time;	/* service time of last request */
 	unsigned long timeout;		/* max time to wait for irq */
 
 	special_t	special;	/* special action flags */
@@ -872,8 +870,6 @@ typedef struct hwgroup_s {
 
 		/* BOOL: protects all fields below */
 	volatile int busy;
-		/* BOOL: wake us up on timer expiry */
-	unsigned int sleeping	: 1;
 		/* BOOL: polling active & poll_timeout field valid */
 	unsigned int polling	: 1;
 
