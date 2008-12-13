Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYLMXlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYLMXlq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYLMXkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:40:11 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:21825 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbYLMXkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:40:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=UN5X0I+AnkzPvg0HRsP6mpEOwG5Ry97q4fOrUlg+EwohO9aO4jD0rEqY8J+j0CXwTH
         66z824I1hh+wj7IyvNatSPLppYUfGyoOEFottMOEu2PC2rXhPraLVA6Wh91c22Vu4903
         zcz8f2bkTW/8TskZtvHRvtKvnT5rv8f+MsOsg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 14 Dec 2008 00:39:52 +0100
Message-Id: <20081213233952.4653.95219.sendpatchset@localhost.localdomain>
In-Reply-To: <20081213233925.4653.58008.sendpatchset@localhost.localdomain>
References: <20081213233925.4653.58008.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/6] ide: remove hwgroup->hwif and {drive,hwif}->next
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove hwgroup->hwif and {drive,hwif}->next

* Add 'int port_count' field to ide_hwgroup_t to keep the track
  of the number of ports in the hwgroup.  Then update init_irq()
  and ide_remove_port_from_hwgroup() to use it.

* Remove no longer needed hwgroup->hwif, {drive,hwif}->next,
  ide_add_drive_to_hwgroup() and ide_remove_drive_from_hwgroup()
  (hwgroup->drive now only denotes the currently active device
   in the hwgroup).

* Update locking documentation in <linux/ide.h>.

While at it:

* Rename ->drive field in ide_hwgroup_t to ->cur_dev.

* Use __func__ in ide_timer_expiry().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c    |   12 +++---
 drivers/ide/ide-probe.c |   90 +++---------------------------------------------
 include/linux/ide.h     |   13 +-----
 3 files changed, 15 insertions(+), 100 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -742,12 +742,12 @@ repeat:
 			 * set nIEN for previous port, drives in the
 			 * quirk_list may not like intr setups/cleanups
 			 */
-			if (prev_port && hwgroup->drive->quirk_list == 0)
+			if (prev_port && hwgroup->cur_dev->quirk_list == 0)
 				prev_port->tp_ops->set_irq(prev_port, 0);
 
 			hwif->host->cur_port = hwif;
 		}
-		hwgroup->drive = drive;
+		hwgroup->cur_dev = drive;
 		drive->dev_flags &= ~(IDE_DFLAG_SLEEPING | IDE_DFLAG_PARKED);
 
 		spin_unlock_irq(&hwgroup->lock);
@@ -913,9 +913,9 @@ void ide_timer_expiry (unsigned long dat
 		 * Either way, we don't really want to complain about anything.
 		 */
 	} else {
-		drive = hwgroup->drive;
+		drive = hwgroup->cur_dev;
 		if (!drive) {
-			printk(KERN_ERR "ide_timer_expiry: hwgroup->drive was NULL\n");
+			printk(KERN_ERR "%s: ->cur_dev was NULL\n", __func__);
 			hwgroup->handler = NULL;
 		} else {
 			ide_hwif_t *hwif;
@@ -1033,7 +1033,7 @@ static void unexpected_intr(int irq, ide
  *	places
  *
  *	hwif is the interface in the group currently performing
- *	a command. hwgroup->drive is the drive and hwgroup->handler is
+ *	a command. hwgroup->cur_dev is the drive and hwgroup->handler is
  *	the IRQ handler to call. As we issue a command the handlers
  *	step through multiple states, reassigning the handler to the
  *	next step in the process. Unlike a smart SCSI controller IDE
@@ -1105,7 +1105,7 @@ irqreturn_t ide_intr (int irq, void *dev
 		goto out;
 	}
 
-	drive = hwgroup->drive;
+	drive = hwgroup->cur_dev;
 	if (!drive) {
 		/*
 		 * This should NEVER happen, and there isn't much
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -918,27 +918,9 @@ static int ide_init_queue(ide_drive_t *d
 	return 0;
 }
 
-static void ide_add_drive_to_hwgroup(ide_drive_t *drive)
-{
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
-
-	spin_lock_irq(&hwgroup->lock);
-	if (!hwgroup->drive) {
-		/* first drive for hwgroup. */
-		drive->next = drive;
-		hwgroup->drive = drive;
-		hwgroup->hwif = HWIF(hwgroup->drive);
-	} else {
-		drive->next = hwgroup->drive->next;
-		hwgroup->drive->next = drive;
-	}
-	spin_unlock_irq(&hwgroup->lock);
-}
-
 /*
  * For any present drive:
  * - allocate the block device queue
- * - link drive into the hwgroup
  */
 static int ide_port_setup_devices(ide_hwif_t *hwif)
 {
@@ -961,8 +943,6 @@ static int ide_port_setup_devices(ide_hw
 		}
 
 		j++;
-
-		ide_add_drive_to_hwgroup(drive);
 	}
 	mutex_unlock(&ide_cfg_mtx);
 
@@ -978,33 +958,9 @@ void ide_remove_port_from_hwgroup(ide_hw
 	ide_ports[hwif->index] = NULL;
 
 	spin_lock_irq(&hwgroup->lock);
-	/*
-	 * Remove us from the hwgroup, and free
-	 * the hwgroup if we were the only member
-	 */
-	if (hwif->next == hwif) {
-		BUG_ON(hwgroup->hwif != hwif);
+	/* Free the hwgroup if we were the only member. */
+	if (--hwgroup->port_count == 0)
 		kfree(hwgroup);
-	} else {
-		/* There is another interface in hwgroup.
-		 * Unlink us, and set hwgroup->drive and ->hwif to
-		 * something sane.
-		 */
-		ide_hwif_t *g = hwgroup->hwif;
-
-		while (g->next != hwif)
-			g = g->next;
-		g->next = hwif->next;
-		if (hwgroup->hwif == hwif) {
-			/* Chose a random hwif for hwgroup->hwif.
-			 * It's guaranteed that there are no drives
-			 * left in the hwgroup.
-			 */
-			BUG_ON(hwgroup->drive != NULL);
-			hwgroup->hwif = g;
-		}
-		BUG_ON(hwgroup->hwif == hwif);
-	}
 	spin_unlock_irq(&hwgroup->lock);
 }
 
@@ -1044,20 +1000,9 @@ static int init_irq (ide_hwif_t *hwif)
 	if (match) {
 		hwgroup = match->hwgroup;
 		hwif->hwgroup = hwgroup;
-		/*
-		 * Link us into the hwgroup.
-		 * This must be done early, do ensure that unexpected_intr
-		 * can find the hwif and prevent irq storms.
-		 * No drives are attached to the new hwif, choose_drive
-		 * can't do anything stupid (yet).
-		 * Add ourself as the 2nd entry to the hwgroup->hwif
-		 * linked list, the first entry is the hwif that owns
-		 * hwgroup->handler - do not change that.
-		 */
+
 		spin_lock_irq(&hwgroup->lock);
-		hwif->next = hwgroup->hwif->next;
-		hwgroup->hwif->next = hwif;
-		BUG_ON(hwif->next == hwif);
+		hwgroup->port_count++;
 		spin_unlock_irq(&hwgroup->lock);
 	} else {
 		hwgroup = kmalloc_node(sizeof(*hwgroup), GFP_KERNEL|__GFP_ZERO,
@@ -1068,7 +1013,8 @@ static int init_irq (ide_hwif_t *hwif)
 		spin_lock_init(&hwgroup->lock);
 
 		hwif->hwgroup = hwgroup;
-		hwgroup->hwif = hwif->next = hwif;
+
+		hwgroup->port_count = 1;
 
 		init_timer(&hwgroup->timer);
 		hwgroup->timer.function = &ide_timer_expiry;
@@ -1191,29 +1137,6 @@ void ide_init_disk(struct gendisk *disk,
 
 EXPORT_SYMBOL_GPL(ide_init_disk);
 
-static void ide_remove_drive_from_hwgroup(ide_drive_t *drive)
-{
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
-
-	if (drive == drive->next) {
-		/* special case: last drive from hwgroup. */
-		BUG_ON(hwgroup->drive != drive);
-		hwgroup->drive = NULL;
-	} else {
-		ide_drive_t *walk;
-
-		walk = hwgroup->drive;
-		while (walk->next != drive)
-			walk = walk->next;
-		walk->next = drive->next;
-		if (hwgroup->drive == drive) {
-			hwgroup->drive = drive->next;
-			hwgroup->hwif = hwgroup->drive->hwif;
-		}
-	}
-	BUG_ON(hwgroup->drive == drive);
-}
-
 static void drive_release_dev (struct device *dev)
 {
 	ide_drive_t *drive = container_of(dev, ide_drive_t, gendev);
@@ -1222,7 +1145,6 @@ static void drive_release_dev (struct de
 	ide_proc_unregister_device(drive);
 
 	spin_lock_irq(&hwgroup->lock);
-	ide_remove_drive_from_hwgroup(drive);
 	kfree(drive->id);
 	drive->id = NULL;
 	drive->dev_flags &= ~IDE_DFLAG_PRESENT;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -588,7 +588,6 @@ struct ide_drive_s {
 	struct request_queue	*queue;	/* request queue */
 
 	struct request		*rq;	/* current request */
-	struct ide_drive_s 	*next;	/* circular list of hwgroup drives */
 	void		*driver_data;	/* extra driver data */
 	u16			*id;	/* identification info */
 #ifdef CONFIG_IDE_PROC_FS
@@ -750,7 +749,6 @@ struct ide_dma_ops {
 struct ide_host;
 
 typedef struct hwif_s {
-	struct hwif_s *next;		/* for linked-list in ide_hwgroup_t */
 	struct hwif_s *mate;		/* other hwif from same PCI chip */
 	struct hwgroup_s *hwgroup;	/* actually (ide_hwgroup_t *) */
 	struct proc_dir_entry *proc;	/* /proc/ide/ directory entry */
@@ -874,9 +872,7 @@ typedef struct hwgroup_s {
 	unsigned int polling	: 1;
 
 		/* current drive */
-	ide_drive_t *drive;
-		/* ptr to current hwif in linked-list */
-	ide_hwif_t *hwif;
+	ide_drive_t *cur_dev;
 
 		/* current request */
 	struct request *rq;
@@ -892,6 +888,8 @@ typedef struct hwgroup_s {
 	int req_gen_timer;
 
 	spinlock_t lock;
+
+	int port_count;
 } ide_hwgroup_t;
 
 typedef struct ide_driver_s ide_driver_t;
@@ -1622,12 +1620,7 @@ extern struct mutex ide_cfg_mtx;
 /*
  * Structure locking:
  *
- * ide_cfg_mtx and hwgroup->lock together protect changes to
- * ide_hwif_t->next
- * ide_drive_t->next
- *
  * ide_hwgroup_t->busy: hwgroup->lock
- * ide_hwgroup_t->hwif: hwgroup->lock
  * ide_hwif_t->{hwgroup,mate}: constant, no locking
  * ide_drive_t->hwif: constant, no locking
  */
