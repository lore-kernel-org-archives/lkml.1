Return-Path: <linux-kernel-owner+w=401wt.eu-S1762964AbYJJTbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762964AbYJJTbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762633AbYJJTbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:31:09 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:30808 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761686AbYJJTbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:31:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=hnraLgaRO9AOpxumIZiAjHU+O7UT1H3yblhJC/PCCAJnQ5T+AZhazWQ1G13+yiwJG0
         QC2Wiii+a6OZx7O5eayVPq8kkvvvAyNSMLXCLbIyVA6fOoc2ImDNHru6ZIRjO5wne74Y
         x0t51BLaVr7zdRX+axDgy0XrzPm6Wvhckzj6w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: replace the global ide_lock spinlock by per-hwgroup spinlocks
Date: Fri, 10 Oct 2008 21:26:14 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org,
       "Vaibhav V. Nivargi" <vaibhav.nivargi@gmail.com>,
       "Alok N. Kataria" <alokk@calsoftinc.com>,
       Ravikiran Thirumalai <kiran@scalex86.org>,
       Shai Fultheim <shai@scalex86.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810102126.14475.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: replace the global ide_lock spinlock by per-hwgroup spinlocks

Now that (almost) all host drivers have been fixed not to abuse ide_lock
and core code usage of ide_lock has been sanitized we may safely replace
ide_lock by per-hwgroup locks.

This patch is partially based on earlier patch from Ravikiran G Thirumalai.

While at it:
- don't use deprecated HWIF() and HWGROUP() macros
- update locking documentation in ide.h

Cc: Vaibhav V. Nivargi <vaibhav.nivargi@gmail.com>
Cc: Alok N. Kataria <alokk@calsoftinc.com>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Shai Fultheim <shai@scalex86.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
this is against 2.6.27 + pata tree + pre-patchset posted on Wednesday
(http://lkml.org/lkml/2008/10/8/221)

 drivers/ide/ide-io.c         |   33 ++++++++++++++---------------
 drivers/ide/ide-iops.c       |   48 ++++++++++++++++++++-----------------------
 drivers/ide/ide-park.c       |   16 +++++++-------
 drivers/ide/ide-probe.c      |   24 +++++++++++----------
 drivers/ide/ide.c            |    8 ++-----
 drivers/ide/legacy/umc8672.c |   11 ++++++---
 drivers/scsi/ide-scsi.c      |   32 ++++++++++++++++++----------
 include/linux/ide.h          |   12 ++++++----
 8 files changed, 98 insertions(+), 86 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -906,7 +906,7 @@ repeat:	
 
 /*
  * Issue a new request to a drive from hwgroup
- * Caller must have already done spin_lock_irqsave(&ide_lock, ..);
+ * Caller must have already done spin_lock_irqsave(&hwgroup->lock, ..);
  *
  * A hwgroup is a serialized group of IDE interfaces.  Usually there is
  * exactly one hwif (interface) per hwgroup, but buggy controllers (eg. CMD640)
@@ -918,7 +918,7 @@ repeat:	
  * possibly along with many other devices.  This is especially common in
  * PCI-based systems with off-board IDE controller cards.
  *
- * The IDE driver uses the single global ide_lock spinlock to protect
+ * The IDE driver uses a per-hwgroup spinlock to protect
  * access to the request queues, and to protect the hwgroup->busy flag.
  *
  * The first thread into the driver for a particular hwgroup sets the
@@ -934,7 +934,7 @@ repeat:	
  * will start the next request from the queue.  If no more work remains,
  * the driver will clear the hwgroup->busy flag and exit.
  *
- * The ide_lock (spinlock) is used to protect all access to the
+ * The per-hwgroup spinlock is used to protect all access to the
  * hwgroup->busy flag, but is otherwise not needed for most processing in
  * the driver.  This makes the driver much more friendlier to shared IRQs
  * than previous designs, while remaining 100% (?) SMP safe and capable.
@@ -950,7 +950,7 @@ static void ide_do_request (ide_hwgroup_
 	/* for atari only: POSSIBLY BROKEN HERE(?) */
 	ide_get_lock(ide_intr, hwgroup);
 
-	/* caller must own ide_lock */
+	/* caller must own hwgroup->lock */
 	BUG_ON(!irqs_disabled());
 
 	while (!hwgroup->busy) {
@@ -1070,11 +1070,11 @@ static void ide_do_request (ide_hwgroup_
 		 */
 		if (masked_irq != IDE_NO_IRQ && hwif->irq != masked_irq)
 			disable_irq_nosync(hwif->irq);
-		spin_unlock(&ide_lock);
+		spin_unlock(&hwgroup->lock);
 		local_irq_enable_in_hardirq();
 			/* allow other IRQs while we start this request */
 		startstop = start_request(drive, rq);
-		spin_lock_irq(&ide_lock);
+		spin_lock_irq(&hwgroup->lock);
 		if (masked_irq != IDE_NO_IRQ && hwif->irq != masked_irq)
 			enable_irq(hwif->irq);
 		if (startstop == ide_stopped)
@@ -1172,7 +1172,7 @@ void ide_timer_expiry (unsigned long dat
 	unsigned long	flags;
 	unsigned long	wait = -1;
 
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&hwgroup->lock, flags);
 
 	if (((handler = hwgroup->handler) == NULL) ||
 	    (hwgroup->req_gen != hwgroup->req_gen_timer)) {
@@ -1205,7 +1205,7 @@ void ide_timer_expiry (unsigned long dat
 					hwgroup->timer.expires  = jiffies + wait;
 					hwgroup->req_gen_timer = hwgroup->req_gen;
 					add_timer(&hwgroup->timer);
-					spin_unlock_irqrestore(&ide_lock, flags);
+					spin_unlock_irqrestore(&hwgroup->lock, flags);
 					return;
 				}
 			}
@@ -1215,7 +1215,7 @@ void ide_timer_expiry (unsigned long dat
 			 * the handler() function, which means we need to
 			 * globally mask the specific IRQ:
 			 */
-			spin_unlock(&ide_lock);
+			spin_unlock(&hwgroup->lock);
 			hwif  = HWIF(drive);
 			/* disable_irq_nosync ?? */
 			disable_irq(hwif->irq);
@@ -1239,14 +1239,14 @@ void ide_timer_expiry (unsigned long dat
 						  hwif->tp_ops->read_status(hwif));
 			}
 			drive->service_time = jiffies - drive->service_start;
-			spin_lock_irq(&ide_lock);
+			spin_lock_irq(&hwgroup->lock);
 			enable_irq(hwif->irq);
 			if (startstop == ide_stopped)
 				hwgroup->busy = 0;
 		}
 	}
 	ide_do_request(hwgroup, IDE_NO_IRQ);
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&hwgroup->lock, flags);
 }
 
 /**
@@ -1339,14 +1339,13 @@ irqreturn_t ide_intr (int irq, void *dev
 {
 	unsigned long flags;
 	ide_hwgroup_t *hwgroup = (ide_hwgroup_t *)dev_id;
-	ide_hwif_t *hwif;
+	ide_hwif_t *hwif = hwgroup->hwif;
 	ide_drive_t *drive;
 	ide_handler_t *handler;
 	ide_startstop_t startstop;
 	irqreturn_t irq_ret = IRQ_NONE;
 
-	spin_lock_irqsave(&ide_lock, flags);
-	hwif = hwgroup->hwif;
+	spin_lock_irqsave(&hwgroup->lock, flags);
 
 	if (!ide_ack_intr(hwif))
 		goto out;
@@ -1416,7 +1415,7 @@ irqreturn_t ide_intr (int irq, void *dev
 	hwgroup->handler = NULL;
 	hwgroup->req_gen++;
 	del_timer(&hwgroup->timer);
-	spin_unlock(&ide_lock);
+	spin_unlock(&hwgroup->lock);
 
 	if (hwif->port_ops && hwif->port_ops->clear_irq)
 		hwif->port_ops->clear_irq(drive);
@@ -1427,7 +1426,7 @@ irqreturn_t ide_intr (int irq, void *dev
 	/* service this interrupt, may set handler for next interrupt */
 	startstop = handler(drive);
 
-	spin_lock_irq(&ide_lock);
+	spin_lock_irq(&hwgroup->lock);
 	/*
 	 * Note that handler() may have set things up for another
 	 * interrupt to occur soon, but it cannot happen until
@@ -1448,7 +1447,7 @@ irqreturn_t ide_intr (int irq, void *dev
 out_handled:
 	irq_ret = IRQ_HANDLED;
 out:
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&hwgroup->lock, flags);
 	return irq_ret;
 }
 
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -838,10 +838,12 @@ static void __ide_set_handler (ide_drive
 void ide_set_handler (ide_drive_t *drive, ide_handler_t *handler,
 		      unsigned int timeout, ide_expiry_t *expiry)
 {
+	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
 	unsigned long flags;
-	spin_lock_irqsave(&ide_lock, flags);
+
+	spin_lock_irqsave(&hwgroup->lock, flags);
 	__ide_set_handler(drive, handler, timeout, expiry);
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&hwgroup->lock, flags);
 }
 
 EXPORT_SYMBOL(ide_set_handler);
@@ -863,10 +865,11 @@ EXPORT_SYMBOL(ide_set_handler);
 void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
 			 unsigned timeout, ide_expiry_t *expiry)
 {
+	ide_hwif_t *hwif = drive->hwif;
+	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	unsigned long flags;
-	ide_hwif_t *hwif = HWIF(drive);
 
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&hwgroup->lock, flags);
 	__ide_set_handler(drive, handler, timeout, expiry);
 	hwif->tp_ops->exec_command(hwif, cmd);
 	/*
@@ -876,19 +879,20 @@ void ide_execute_command(ide_drive_t *dr
 	 * FIXME: we could skip this delay with care on non shared devices
 	 */
 	ndelay(400);
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&hwgroup->lock, flags);
 }
 EXPORT_SYMBOL(ide_execute_command);
 
 void ide_execute_pkt_cmd(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&hwgroup->lock, flags);
 	hwif->tp_ops->exec_command(hwif, ATA_CMD_PACKET);
 	ndelay(400);
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&hwgroup->lock, flags);
 }
 EXPORT_SYMBOL_GPL(ide_execute_pkt_cmd);
 
@@ -1079,22 +1083,16 @@ static void pre_reset(ide_drive_t *drive
  */
 static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 {
-	unsigned int unit;
-	unsigned long flags, timeout;
-	ide_hwif_t *hwif;
-	ide_hwgroup_t *hwgroup;
-	struct ide_io_ports *io_ports;
-	const struct ide_tp_ops *tp_ops;
+	ide_hwif_t *hwif = drive->hwif;
+	ide_hwgroup_t *hwgroup = hwif->hwgroup;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	const struct ide_port_ops *port_ops;
+	unsigned long flags, timeout;
+	unsigned int unit;
 	DEFINE_WAIT(wait);
 
-	spin_lock_irqsave(&ide_lock, flags);
-	hwif = HWIF(drive);
-	hwgroup = HWGROUP(drive);
-
-	io_ports = &hwif->io_ports;
-
-	tp_ops = hwif->tp_ops;
+	spin_lock_irqsave(&hwgroup->lock, flags);
 
 	/* We must not reset with running handlers */
 	BUG_ON(hwgroup->handler != NULL);
@@ -1109,7 +1107,7 @@ static ide_startstop_t do_reset1 (ide_dr
 		hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
 		hwgroup->polling = 1;
 		__ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
-		spin_unlock_irqrestore(&ide_lock, flags);
+		spin_unlock_irqrestore(&hwgroup->lock, flags);
 		return ide_started;
 	}
 
@@ -1132,9 +1130,9 @@ static ide_startstop_t do_reset1 (ide_dr
 		if (time_before_eq(timeout, now))
 			break;
 
-		spin_unlock_irqrestore(&ide_lock, flags);
+		spin_unlock_irqrestore(&hwgroup->lock, flags);
 		timeout = schedule_timeout_uninterruptible(timeout - now);
-		spin_lock_irqsave(&ide_lock, flags);
+		spin_lock_irqsave(&hwgroup->lock, flags);
 	} while (timeout);
 	finish_wait(&ide_park_wq, &wait);
 
@@ -1146,7 +1144,7 @@ static ide_startstop_t do_reset1 (ide_dr
 		pre_reset(&hwif->drives[unit]);
 
 	if (io_ports->ctl_addr == 0) {
-		spin_unlock_irqrestore(&ide_lock, flags);
+		spin_unlock_irqrestore(&hwgroup->lock, flags);
 		ide_complete_drive_reset(drive, -ENXIO);
 		return ide_stopped;
 	}
@@ -1182,7 +1180,7 @@ static ide_startstop_t do_reset1 (ide_dr
 	if (port_ops && port_ops->resetproc)
 		port_ops->resetproc(drive);
 
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&hwgroup->lock, flags);
 	return ide_started;
 }
 
Index: b/drivers/ide/ide-park.c
===================================================================
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -7,17 +7,16 @@ DECLARE_WAIT_QUEUE_HEAD(ide_park_wq);
 
 static int issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 {
+	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
 	struct request_queue *q = drive->queue;
 	struct request *rq;
 	int rc;
 
 	timeout += jiffies;
-	spin_lock_irq(&ide_lock);
+	spin_lock_irq(&hwgroup->lock);
 	if (drive->dev_flags & IDE_DFLAG_PARKED) {
-		ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
-		int reset_timer;
+		int reset_timer = time_before(timeout, drive->sleep);
 
-		reset_timer = time_before(timeout, drive->sleep);
 		drive->sleep = timeout;
 		wake_up_all(&ide_park_wq);
 		if (reset_timer && hwgroup->sleeping &&
@@ -26,10 +25,10 @@ static int issue_park_cmd(ide_drive_t *d
 			hwgroup->busy = 0;
 			__blk_run_queue(q);
 		}
-		spin_unlock_irq(&ide_lock);
+		spin_unlock_irq(&hwgroup->lock);
 		return 0;
 	}
-	spin_unlock_irq(&ide_lock);
+	spin_unlock_irq(&hwgroup->lock);
 
 	rq = blk_get_request(q, READ, __GFP_WAIT);
 	rq->cmd[0] = REQ_PARK_HEADS;
@@ -61,20 +60,21 @@ ssize_t ide_park_show(struct device *dev
 		      char *buf)
 {
 	ide_drive_t *drive = to_ide_device(dev);
+	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
 	unsigned long now;
 	unsigned int msecs;
 
 	if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD)
 		return -EOPNOTSUPP;
 
-	spin_lock_irq(&ide_lock);
+	spin_lock_irq(&hwgroup->lock);
 	now = jiffies;
 	if (drive->dev_flags & IDE_DFLAG_PARKED &&
 	    time_after(drive->sleep, now))
 		msecs = jiffies_to_msecs(drive->sleep - now);
 	else
 		msecs = 0;
-	spin_unlock_irq(&ide_lock);
+	spin_unlock_irq(&hwgroup->lock);
 
 	return snprintf(buf, 20, "%u\n", msecs);
 }
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -905,7 +905,8 @@ static int ide_init_queue(ide_drive_t *d
 	 *	do not.
 	 */
 
-	q = blk_init_queue_node(do_ide_request, &ide_lock, hwif_to_node(hwif));
+	q = blk_init_queue_node(do_ide_request, &hwif->hwgroup->lock,
+				hwif_to_node(hwif));
 	if (!q)
 		return 1;
 
@@ -946,7 +947,7 @@ static void ide_add_drive_to_hwgroup(ide
 {
 	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
 
-	spin_lock_irq(&ide_lock);
+	spin_lock_irq(&hwgroup->lock);
 	if (!hwgroup->drive) {
 		/* first drive for hwgroup. */
 		drive->next = drive;
@@ -956,7 +957,7 @@ static void ide_add_drive_to_hwgroup(ide
 		drive->next = hwgroup->drive->next;
 		hwgroup->drive->next = drive;
 	}
-	spin_unlock_irq(&ide_lock);
+	spin_unlock_irq(&hwgroup->lock);
 }
 
 /*
@@ -1001,7 +1002,7 @@ void ide_remove_port_from_hwgroup(ide_hw
 
 	ide_ports[hwif->index] = NULL;
 
-	spin_lock_irq(&ide_lock);
+	spin_lock_irq(&hwgroup->lock);
 	/*
 	 * Remove us from the hwgroup, and free
 	 * the hwgroup if we were the only member
@@ -1029,7 +1030,7 @@ void ide_remove_port_from_hwgroup(ide_hw
 		}
 		BUG_ON(hwgroup->hwif == hwif);
 	}
-	spin_unlock_irq(&ide_lock);
+	spin_unlock_irq(&hwgroup->lock);
 }
 
 /*
@@ -1091,11 +1092,11 @@ static int init_irq (ide_hwif_t *hwif)
 		 * linked list, the first entry is the hwif that owns
 		 * hwgroup->handler - do not change that.
 		 */
-		spin_lock_irq(&ide_lock);
+		spin_lock_irq(&hwgroup->lock);
 		hwif->next = hwgroup->hwif->next;
 		hwgroup->hwif->next = hwif;
 		BUG_ON(hwif->next == hwif);
-		spin_unlock_irq(&ide_lock);
+		spin_unlock_irq(&hwgroup->lock);
 	} else {
 		hwgroup = kmalloc_node(sizeof(*hwgroup), GFP_KERNEL|__GFP_ZERO,
 				       hwif_to_node(hwif));
@@ -1262,20 +1263,21 @@ static void ide_remove_drive_from_hwgrou
 static void drive_release_dev (struct device *dev)
 {
 	ide_drive_t *drive = container_of(dev, ide_drive_t, gendev);
+	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
 
 	ide_proc_unregister_device(drive);
 
-	spin_lock_irq(&ide_lock);
+	spin_lock_irq(&hwgroup->lock);
 	ide_remove_drive_from_hwgroup(drive);
 	kfree(drive->id);
 	drive->id = NULL;
 	drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 	/* Messed up locking ... */
-	spin_unlock_irq(&ide_lock);
+	spin_unlock_irq(&hwgroup->lock);
 	blk_cleanup_queue(drive->queue);
-	spin_lock_irq(&ide_lock);
+	spin_lock_irq(&hwgroup->lock);
 	drive->queue = NULL;
-	spin_unlock_irq(&ide_lock);
+	spin_unlock_irq(&hwgroup->lock);
 
 	complete(&drive->gendev_rel_comp);
 }
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -74,9 +74,6 @@ static const u8 ide_hwif_to_major[] = { 
 
 DEFINE_MUTEX(ide_cfg_mtx);
 
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(ide_lock);
-EXPORT_SYMBOL(ide_lock);
-
 static void ide_port_init_devices_data(ide_hwif_t *);
 
 /*
@@ -333,6 +330,7 @@ static int set_pio_mode_abuse(ide_hwif_t
 static int set_pio_mode(ide_drive_t *drive, int arg)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 
 	if (arg < 0 || arg > 255)
@@ -347,9 +345,9 @@ static int set_pio_mode(ide_drive_t *dri
 			unsigned long flags;
 
 			/* take lock for IDE_DFLAG_[NO_]UNMASK/[NO_]IO_32BIT */
-			spin_lock_irqsave(&ide_lock, flags);
+			spin_lock_irqsave(&hwgroup->lock, flags);
 			port_ops->set_pio_mode(drive, arg);
-			spin_unlock_irqrestore(&ide_lock, flags);
+			spin_unlock_irqrestore(&hwgroup->lock, flags);
 		} else
 			port_ops->set_pio_mode(drive, arg);
 	} else {
Index: b/drivers/ide/legacy/umc8672.c
===================================================================
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -107,18 +107,21 @@ static void umc_set_speeds(u8 speeds[])
 static void umc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	unsigned long flags;
+	ide_hwgroup_t *mate_hwgroup = hwif->mate ? hwif->mate->hwgroup : NULL;
+	unsigned long uninitialized_var(flags);
 
 	printk("%s: setting umc8672 to PIO mode%d (speed %d)\n",
 		drive->name, pio, pio_to_umc[pio]);
-	spin_lock_irqsave(&ide_lock, flags);
-	if (hwif->mate && hwif->mate->hwgroup->handler) {
+	if (mate_hwgroup)
+		spin_lock_irqsave(&mate_hwgroup->lock, flags);
+	if (mate_hwgroup && mate_hwgroup->handler) {
 		printk(KERN_ERR "umc8672: other interface is busy: exiting tune_umc()\n");
 	} else {
 		current_speeds[drive->name[2] - 'a'] = pio_to_umc[pio];
 		umc_set_speeds(current_speeds);
 	}
-	spin_unlock_irqrestore(&ide_lock, flags);
+	if (mate_hwgroup)
+		spin_unlock_irqrestore(&mate_hwgroup->lock, flags);
 }
 
 static const struct ide_port_ops umc8672_port_ops = {
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -584,6 +584,8 @@ static int idescsi_eh_abort (struct scsi
 {
 	idescsi_scsi_t *scsi  = scsihost_to_idescsi(cmd->device->host);
 	ide_drive_t    *drive = scsi->drive;
+	ide_hwif_t     *hwif;
+	ide_hwgroup_t  *hwgroup;
 	int		busy;
 	int             ret   = FAILED;
 
@@ -600,13 +602,16 @@ static int idescsi_eh_abort (struct scsi
 		goto no_drive;
 	}
 
-	/* First give it some more time, how much is "right" is hard to say :-( */
+	hwif = drive->hwif;
+	hwgroup = hwif->hwgroup;
 
-	busy = ide_wait_not_busy(HWIF(drive), 100);	/* FIXME - uses mdelay which causes latency? */
+	/* First give it some more time, how much is "right" is hard to say :-(
+	   FIXME - uses mdelay which causes latency? */
+	busy = ide_wait_not_busy(hwif, 100);
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log))
 		printk (KERN_WARNING "ide-scsi: drive did%s become ready\n", busy?" not":"");
 
-	spin_lock_irq(&ide_lock);
+	spin_lock_irq(&hwgroup->lock);
 
 	/* If there is no pc running we're done (our interrupt took care of it) */
 	pc = drive->pc;
@@ -635,7 +640,7 @@ static int idescsi_eh_abort (struct scsi
 	}
 
 ide_unlock:
-	spin_unlock_irq(&ide_lock);
+	spin_unlock_irq(&hwgroup->lock);
 no_drive:
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log))
 		printk (KERN_WARNING "ide-scsi: abort returns %s\n", ret == SUCCESS?"success":"failed");
@@ -648,6 +653,7 @@ static int idescsi_eh_reset (struct scsi
 	struct request *req;
 	idescsi_scsi_t *scsi  = scsihost_to_idescsi(cmd->device->host);
 	ide_drive_t    *drive = scsi->drive;
+	ide_hwgroup_t  *hwgroup;
 	int             ready = 0;
 	int             ret   = SUCCESS;
 
@@ -664,14 +670,18 @@ static int idescsi_eh_reset (struct scsi
 		return FAILED;
 	}
 
+	hwgroup = drive->hwif->hwgroup;
+
 	spin_lock_irq(cmd->device->host->host_lock);
-	spin_lock(&ide_lock);
+	spin_lock(&hwgroup->lock);
 
 	pc = drive->pc;
+	if (pc)
+		req = pc->rq;
 
-	if (pc == NULL || (req = pc->rq) != HWGROUP(drive)->rq || !HWGROUP(drive)->handler) {
+	if (pc == NULL || req != hwgroup->rq || hwgroup->handler == NULL) {
 		printk (KERN_WARNING "ide-scsi: No active request in idescsi_eh_reset\n");
-		spin_unlock(&ide_lock);
+		spin_unlock(&hwgroup->lock);
 		spin_unlock_irq(cmd->device->host->host_lock);
 		return FAILED;
 	}
@@ -691,10 +701,10 @@ static int idescsi_eh_reset (struct scsi
 			BUG();
 	}
 
-	HWGROUP(drive)->rq = NULL;
-	HWGROUP(drive)->handler = NULL;
-	HWGROUP(drive)->busy = 1;		/* will set this to zero when ide reset finished */
-	spin_unlock(&ide_lock);
+	hwgroup->rq = NULL;
+	hwgroup->handler = NULL;
+	hwgroup->busy = 1; /* will set this to zero when ide reset finished */
+	spin_unlock(&hwgroup->lock);
 
 	ide_do_reset(drive);
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -909,6 +909,8 @@ typedef struct hwgroup_s {
 
 	int req_gen;
 	int req_gen_timer;
+
+	spinlock_t lock;
 } ide_hwgroup_t;
 
 typedef struct ide_driver_s ide_driver_t;
@@ -1600,13 +1602,13 @@ extern struct mutex ide_cfg_mtx;
 /*
  * Structure locking:
  *
- * ide_cfg_mtx and ide_lock together protect changes to
- * ide_hwif_t->{next,hwgroup}
+ * ide_cfg_mtx and hwgroup->lock together protect changes to
+ * ide_hwif_t->next
  * ide_drive_t->next
  *
- * ide_hwgroup_t->busy: ide_lock
- * ide_hwgroup_t->hwif: ide_lock
- * ide_hwif_t->mate: constant, no locking
+ * ide_hwgroup_t->busy: hwgroup->lock
+ * ide_hwgroup_t->hwif: hwgroup->lock
+ * ide_hwif_t->{hwgroup,mate}: constant, no locking
  * ide_drive_t->hwif: constant, no locking
  */
 
