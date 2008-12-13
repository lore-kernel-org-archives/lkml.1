Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYLMXmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYLMXmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYLMXkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:40:17 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63262 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYLMXkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:40:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=X2H1HI3doqJQptKVyXVukixPazWTSWABlFzUyC4iw7Lf3Uj8qbzvhF4qa1U92gCcBS
         zBr1lWvuIUeiL9+sYhJvTIclBygHs1IALoPd8y4BXZXiF5HRfw/mruZmymH2B7GhdlbP
         IHXfaDpCoK0wn1Ne8vmkBmFIISXa8ZfZWYCds=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 14 Dec 2008 00:39:58 +0100
Message-Id: <20081213233958.4653.37722.sendpatchset@localhost.localdomain>
In-Reply-To: <20081213233925.4653.58008.sendpatchset@localhost.localdomain>
References: <20081213233925.4653.58008.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/6] ide: use lock bitops for ports serialization
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: use lock bitops for ports serialization

* Add ->host_busy field to struct ide_host and use it's first bit
  together with lock bitops to provide new ports serialization method.

* Convert core IDE code to use new ide_[un]lock_host() helpers.

  This removes the need for taking hwgroup->lock if host is already
  busy on serialized hosts and makes it possible to merge ide_hwgroup_t
  into ide_hwif_t (done in the later patch).

* Remove no longer needed ide_hwgroup_t.busy and ide_[un]lock_hwgroup().

* Update do_ide_request() documentation.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |   77 ++++++++++++++++++++++++---------------------------
 include/linux/ide.h  |   34 +++-------------------
 2 files changed, 42 insertions(+), 69 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -666,43 +666,36 @@ void ide_stall_queue (ide_drive_t *drive
 }
 EXPORT_SYMBOL(ide_stall_queue);
 
+static inline int ide_lock_host(struct ide_host *host, ide_hwif_t *hwif)
+{
+	int rc = 0;
+
+	if (host->host_flags & IDE_HFLAG_SERIALIZE) {
+		rc = test_and_set_bit_lock(IDE_HOST_BUSY, &host->host_busy);
+		if (rc == 0) {
+			/* for atari only */
+			ide_get_lock(ide_intr, hwif);
+		}
+	}
+	return rc;
+}
+
+static inline void ide_unlock_host(struct ide_host *host)
+{
+	/* for atari only */
+	ide_release_lock();
+	if (host->host_flags & IDE_HFLAG_SERIALIZE)
+		clear_bit_unlock(IDE_HOST_BUSY, &host->host_busy);
+}
+
 /*
  * Issue a new request to a drive from hwgroup
- *
- * A hwgroup is a serialized group of IDE interfaces.  Usually there is
- * exactly one hwif (interface) per hwgroup, but buggy controllers (eg. CMD640)
- * may have both interfaces in a single hwgroup to "serialize" access.
- * Or possibly multiple ISA interfaces can share a common IRQ by being grouped
- * together into one hwgroup for serialized access.
- *
- * Note also that several hwgroups can end up sharing a single IRQ,
- * possibly along with many other devices.  This is especially common in
- * PCI-based systems with off-board IDE controller cards.
- *
- * The IDE driver uses a per-hwgroup lock to protect the hwgroup->busy flag.
- *
- * The first thread into the driver for a particular hwgroup sets the
- * hwgroup->busy flag to indicate that this hwgroup is now active,
- * and then initiates processing of the top request from the request queue.
- *
- * Other threads attempting entry notice the busy setting, and will simply
- * queue their new requests and exit immediately.  Note that hwgroup->busy
- * remains set even when the driver is merely awaiting the next interrupt.
- * Thus, the meaning is "this hwgroup is busy processing a request".
- *
- * When processing of a request completes, the completing thread or IRQ-handler
- * will start the next request from the queue.  If no more work remains,
- * the driver will clear the hwgroup->busy flag and exit.
- *
- * The per-hwgroup spinlock is used to protect all access to the
- * hwgroup->busy flag, but is otherwise not needed for most processing in
- * the driver.  This makes the driver much more friendlier to shared IRQs
- * than previous designs, while remaining 100% (?) SMP safe and capable.
  */
 void do_ide_request(struct request_queue *q)
 {
 	ide_drive_t	*drive = q->queuedata;
 	ide_hwif_t	*hwif = drive->hwif;
+	struct ide_host *host = hwif->host;
 	ide_hwgroup_t	*hwgroup = hwif->hwgroup;
 	struct request	*rq;
 	ide_startstop_t	startstop;
@@ -721,9 +714,13 @@ void do_ide_request(struct request_queue
 		blk_remove_plug(q);
 
 	spin_unlock_irq(q->queue_lock);
+
+	if (ide_lock_host(host, hwif))
+		goto plug_device_2;
+
 	spin_lock_irq(&hwgroup->lock);
 
-	if (!ide_lock_hwgroup(hwgroup, hwif)) {
+	if (1) {
 		ide_hwif_t *prev_port;
 repeat:
 		prev_port = hwif->host->cur_port;
@@ -731,7 +728,7 @@ repeat:
 
 		if (drive->dev_flags & IDE_DFLAG_SLEEPING) {
 			if (time_before(drive->sleep, jiffies)) {
-				ide_unlock_hwgroup(hwgroup);
+				ide_unlock_host(host);
 				goto plug_device;
 			}
 		}
@@ -761,7 +758,7 @@ repeat:
 		spin_lock_irq(&hwgroup->lock);
 
 		if (!rq) {
-			ide_unlock_hwgroup(hwgroup);
+			ide_unlock_host(host);
 			goto out;
 		}
 
@@ -782,7 +779,7 @@ repeat:
 		    blk_pm_request(rq) == 0 &&
 		    (rq->cmd_flags & REQ_PREEMPT) == 0) {
 			/* there should be no pending command at this point */
-			ide_unlock_hwgroup(hwgroup);
+			ide_unlock_host(host);
 			goto plug_device;
 		}
 
@@ -794,8 +791,7 @@ repeat:
 
 		if (startstop == ide_stopped)
 			goto repeat;
-	} else
-		goto plug_device;
+	}
 out:
 	spin_unlock_irq(&hwgroup->lock);
 	spin_lock_irq(q->queue_lock);
@@ -803,6 +799,7 @@ out:
 
 plug_device:
 	spin_unlock_irq(&hwgroup->lock);
+plug_device_2:
 	spin_lock_irq(q->queue_lock);
 
 	if (!elv_queue_empty(q))
@@ -844,9 +841,9 @@ static ide_startstop_t ide_dma_timeout_r
 	ide_dma_off_quietly(drive);
 
 	/*
-	 * un-busy drive etc (hwgroup->busy is cleared on return) and
-	 * make sure request is sane
+	 * un-busy drive etc and make sure request is sane
 	 */
+
 	rq = HWGROUP(drive)->rq;
 
 	if (!rq)
@@ -964,7 +961,7 @@ void ide_timer_expiry (unsigned long dat
 			spin_lock_irq(&hwgroup->lock);
 			enable_irq(hwif->irq);
 			if (startstop == ide_stopped) {
-				ide_unlock_hwgroup(hwgroup);
+				ide_unlock_host(hwif->host);
 				plug_device = 1;
 			}
 		}
@@ -1150,7 +1147,7 @@ irqreturn_t ide_intr (int irq, void *dev
 	 */
 	if (startstop == ide_stopped) {
 		if (hwgroup->handler == NULL) {	/* paranoia */
-			ide_unlock_hwgroup(hwgroup);
+			ide_unlock_host(hwif->host);
 			plug_device = 1;
 		} else
 			printk(KERN_ERR "%s: %s: huh? expected NULL handler "
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -851,8 +851,13 @@ struct ide_host {
 	unsigned long	host_flags;
 	void		*host_priv;
 	ide_hwif_t	*cur_port;	/* for hosts requiring serialization */
+
+	/* used for hosts requiring serialization */
+	volatile long	host_busy;
 };
 
+#define IDE_HOST_BUSY 0
+
 /*
  *  internal ide interrupt handler type
  */
@@ -866,8 +871,6 @@ typedef struct hwgroup_s {
 		/* irq handler, if active */
 	ide_startstop_t	(*handler)(ide_drive_t *);
 
-		/* BOOL: protects all fields below */
-	volatile int busy;
 		/* BOOL: polling active & poll_timeout field valid */
 	unsigned int polling	: 1;
 
@@ -1271,26 +1274,6 @@ extern void ide_stall_queue(ide_drive_t 
 
 extern void ide_timer_expiry(unsigned long);
 extern irqreturn_t ide_intr(int irq, void *dev_id);
-
-static inline int ide_lock_hwgroup(ide_hwgroup_t *hwgroup, ide_hwif_t *hwif)
-{
-	if (hwgroup->busy)
-		return 1;
-
-	hwgroup->busy = 1;
-	/* for atari only */
-	ide_get_lock(ide_intr, hwif);
-
-	return 0;
-}
-
-static inline void ide_unlock_hwgroup(ide_hwgroup_t *hwgroup)
-{
-	/* for atari only */
-	ide_release_lock();
-	hwgroup->busy = 0;
-}
-
 extern void do_ide_request(struct request_queue *);
 
 void ide_init_disk(struct gendisk *, ide_drive_t *);
@@ -1617,13 +1600,6 @@ static inline void ide_set_max_pio(ide_d
 
 extern spinlock_t ide_lock;
 extern struct mutex ide_cfg_mtx;
-/*
- * Structure locking:
- *
- * ide_hwgroup_t->busy: hwgroup->lock
- * ide_hwif_t->{hwgroup,mate}: constant, no locking
- * ide_drive_t->hwif: constant, no locking
- */
 
 #define local_irq_set(flags)	do { local_save_flags((flags)); local_irq_enable_in_hardirq(); } while (0)
 
