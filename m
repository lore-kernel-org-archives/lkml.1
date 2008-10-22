Return-Path: <linux-kernel-owner+w=401wt.eu-S1758982AbYJVUtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbYJVUtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYJVUt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:49:26 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:42511 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758634AbYJVUtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:49:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=EprNeiDlPazNf83RL9VpTPUiY58oGbNhzhOTEWKAjuBhG1fgDrA/mh4vqfGty7cJH2
         kQqtnVuyR3I+YPeyDc5Ow8ecCmWhz8O4BqJLMkVPfj195/psvLG20ym7ZomwZ6OLhlyX
         H11IDNMgRw9/u6q4VnSE36YyoN7D/rZ+9/qRc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] ide: don't execute the next queued command from the hard-IRQ context
Date: Wed, 22 Oct 2008 22:47:17 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200810111617.51298.bzolnier@gmail.com> <200810152106.45728.bzolnier@gmail.com> <87od1cu11b.fsf@denkblock.local>
In-Reply-To: <87od1cu11b.fsf@denkblock.local>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810222247.17800.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2008, Elias Oltmanns wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > On Sunday 12 October 2008, Elias Oltmanns wrote:
> >> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> >
> >> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >> > Subject: [PATCH] ide: don't execute the next queued command from the hard-IRQ context
> >> >
> >> > * Tell the block layer that we are not done handling requests by using
> >> >   blk_plug_device() in ide_do_request() (request handling function)
> >> >   and ide_timer_expiry() (timeout handler) if the queue is not empty.
> >> >
> >> > * Remove optimization which directly calls ide_do_request() for the next
> >> >   queued command from the ide_intr() (IRQ handler) and ide_timer_expiry().
> >> >
> >> > * Remove no longer needed IRQ masking from ide_do_request() - in case of
> >> >   IDE ports needing serialization disable_irq_nosync()/enable_irq() was
> >> >   used for the (possibly shared) IRQ of the other IDE port.
> >> >
> >> > * Put the misplaced comment in the right place in ide_do_request().
> >> >
> >> > * Drop no longer needed 'int masked_irq' argument from ide_do_request().
> >> >
> >> > * Merge ide_do_request() into do_ide_request().
> >> >
> >> > * Remove no longer needed IDE_NO_IRQ define.
> >> >
> >> > While at it:
> >> >
> >> > * Don't use HWGROUP() macro in do_ide_request().
> >> >
> >> > * Use __func__ in ide_intr().
> >> >
> >> > This patch reduces IRQ hadling latency for IDE and improves the system-wide
> >> > handling of shared IRQs (which should result in more timeout resistant and
> >> > stable IDE systems).  It also makes it possible to do some further changes
> >> > later (i.e. replace some busy-waiting delays with sleeping equivalents).
> >> >
> >> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >> > ---
> [...]
> >> > Index: b/drivers/ide/ide-io.c
> >> > ===================================================================
> >> > --- a/drivers/ide/ide-io.c
> >> > +++ b/drivers/ide/ide-io.c
> [...]
> >> >  		startstop = start_request(drive, rq);
> >> >  		spin_lock_irq(&hwgroup->lock);
> >> > -		if (masked_irq != IDE_NO_IRQ && hwif->irq != masked_irq)
> >> > -			enable_irq(hwif->irq);
> >> > -		if (startstop == ide_stopped)
> >> > +
> >> > +		if (startstop == ide_stopped) {
> >> >  			hwgroup->busy = 0;
> >> > +			goto plug_device;
> >> 
> >> This goto statement is wrong. Simply set ->busy to zero and be done with
> >> it. This way, the loop will start again and either elv_next_request()
> >> returns NULL, in which case the queue need not be plugged, or the next
> >> request will be processed immediately, which is exactly what we want.
> >
> > The problem is that the next loop can choose the different drive than
> > the current one so we can end up with the situation where we will "lose"
> > the blk_plug_device() call.
> >
> > I fixed it by just inlining "plug_device" code for now.
> 
> Right, I had missed that. Still, I'm not really convinced yet that this
> is the right way  to handle things. In fact, I believe that the role of
> choose_drive() has changed since it is now called directly from the
> ->request_fn() and it should probably be rewritten and renamed along the
> way. However, this needs further discussion and the issue below has some
> bearing on this too.

Well, in my patch to use per-device request queue lock I was just going
to remove choose_drive() since it should be handled at the block layer
(probably using per-queue io priorites if needed).

---
current draft patch just to visualize the idea

 drivers/ide/ide-io.c    |  172 +++++++++++++++---------------------------------
 drivers/ide/ide-probe.c |    3 
 include/linux/ide.h     |    2 
 3 files changed, 55 insertions(+), 122 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -828,85 +828,10 @@ void ide_stall_queue (ide_drive_t *drive
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
@@ -941,13 +866,15 @@ repeat:	
  */
 void do_ide_request(struct request_queue *q)
 {
-	ide_drive_t	*orig_drive = q->queuedata;
-	ide_hwgroup_t	*hwgroup = orig_drive->hwif->hwgroup;
-	ide_drive_t	*drive;
+	ide_drive_t	*drive = q->queuedata;
+	ide_hwgroup_t	*hwgroup = drive->hwif->hwgroup;
 	ide_hwif_t	*hwif;
 	struct request	*rq;
 	ide_startstop_t	startstop;
 
+	spin_unlock_irq(q->queue_lock);
+	spin_lock_irq(&hwgroup->lock);
+
 	/* for atari only: POSSIBLY BROKEN HERE(?) */
 	ide_get_lock(ide_intr, hwgroup);
 
@@ -956,21 +883,13 @@ void do_ide_request(struct request_queue
 
 	while (!hwgroup->busy) {
 		hwgroup->busy = 1;
-		drive = choose_drive(hwgroup);
-		if (drive == NULL) {
-			int sleeping = 0;
-			unsigned long sleep = 0; /* shut up, gcc */
+
+		if (1) {
 			hwgroup->rq = NULL;
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
+
+			if (drive->dev_flags & IDE_DFLAG_SLEEPING) {
+				unsigned long sleep = drive->sleep;
+
 		/*
 		 * Take a short snooze, and then wake up this hwgroup again.
 		 * This gives other hwgroups on the same a chance to
@@ -989,23 +908,12 @@ void do_ide_request(struct request_queue
 				mod_timer(&hwgroup->timer, sleep);
 				/* we purposely leave hwgroup->busy==1
 				 * while sleeping */
-			} else {
-				/* Ugly, but how can we sleep for the lock
-				 * otherwise? perhaps from tq_disk?
-				 */
 
-				/* for atari only */
-				ide_release_lock();
-				hwgroup->busy = 0;
+				/* no more work for this hwgroup (for now) */
+				goto plug_device;
 			}
-
-			/* no more work for this hwgroup (for now) */
-			goto plug_device;
 		}
 
-		if (drive != orig_drive)
-			goto plug_device;
-
 		hwif = drive->hwif;
 
 		if (hwgroup->hwif->sharing_irq && hwif != hwgroup->hwif) {
@@ -1019,13 +927,17 @@ void do_ide_request(struct request_queue
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
 			hwgroup->busy = 0;
 			break;
@@ -1060,15 +972,21 @@ void do_ide_request(struct request_queue
 
 		if (startstop == ide_stopped) {
 			hwgroup->busy = 0;
-			if (!elv_queue_empty(orig_drive->queue))
-				blk_plug_device(orig_drive->queue);
+			/* give other devices a chance */
+			goto plug_device;
 		}
 	}
+
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
@@ -1129,6 +1047,17 @@ out:
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
@@ -1146,10 +1075,12 @@ out:
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
 
@@ -1166,7 +1097,7 @@ void ide_timer_expiry (unsigned long dat
 			hwgroup->busy = 0;
 		}
 	} else {
-		ide_drive_t *drive = hwgroup->drive;
+		drive = hwgroup->drive;
 		if (!drive) {
 			printk(KERN_ERR "ide_timer_expiry: hwgroup->drive was NULL\n");
 			hwgroup->handler = NULL;
@@ -1217,17 +1148,19 @@ void ide_timer_expiry (unsigned long dat
 					ide_error(drive, "irq timeout",
 						  hwif->tp_ops->read_status(hwif));
 			}
-			drive->service_time = jiffies - drive->service_start;
+
 			spin_lock_irq(&hwgroup->lock);
 			enable_irq(hwif->irq);
 			if (startstop == ide_stopped) {
 				hwgroup->busy = 0;
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
@@ -1321,10 +1254,11 @@ irqreturn_t ide_intr (int irq, void *dev
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
 
@@ -1415,12 +1349,10 @@ irqreturn_t ide_intr (int irq, void *dev
 	 * same irq as is currently being serviced here, and Linux
 	 * won't allow another of the same (on any CPU) until we return.
 	 */
-	drive->service_time = jiffies - drive->service_start;
 	if (startstop == ide_stopped) {
 		if (hwgroup->handler == NULL) {	/* paranoia */
 			hwgroup->busy = 0;
-			if (!elv_queue_empty(drive->queue))
-				blk_plug_device(drive->queue);
+			plug_device = 1;
 		} else
 			printk(KERN_ERR "%s: %s: huh? expected NULL handler "
 					"on exit\n", __func__, drive->name);
@@ -1429,6 +1361,10 @@ out_handled:
 	irq_ret = IRQ_HANDLED;
 out:
 	spin_unlock_irqrestore(&hwgroup->lock, flags);
+
+	if (plug_device)
+		ide_plug_device(drive);
+
 	return irq_ret;
 }
 
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -905,8 +905,7 @@ static int ide_init_queue(ide_drive_t *d
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
@@ -605,8 +605,6 @@ struct ide_drive_s {
 	unsigned long dev_flags;
 
 	unsigned long sleep;		/* sleep until this time */
-	unsigned long service_start;	/* time we started last request */
-	unsigned long service_time;	/* service time of last request */
 	unsigned long timeout;		/* max time to wait for irq */
 
 	special_t	special;	/* special action flags */
