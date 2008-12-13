Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbYLMXlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbYLMXlc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYLMXkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:40:08 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:35079 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbYLMXkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:40:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=HpLZdiHDsIwpshX2sMcqoKF6gQHkcrT7mGKjVxXuXMt1XkmzUMyxihsvKiCo3Uqnxx
         QhRuJiwg62If7LIkzoT6Wo5+Tg1h4K1/kkSEN1TwXiOEN52DZ7sM7Wc9XG+8zgUIpI6l
         JCI8JEyHRKbo0HvmK5IHHvMUjfFMjzTeDr94s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 14 Dec 2008 00:39:45 +0100
Message-Id: <20081213233945.4653.12564.sendpatchset@localhost.localdomain>
In-Reply-To: <20081213233925.4653.58008.sendpatchset@localhost.localdomain>
References: <20081213233925.4653.58008.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/6] ide: use per-port IRQ handlers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: use per-port IRQ handlers

Use hwif instead of hwgroup as {request,free}_irq()'s cookie,
teach ide_intr() to return early for non-active serialized ports,
modify unexpected_intr() accordingly and then use per-port IRQ
handlers instead of per-hwgroup ones.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c    |   56 ++++++++++++++++++------------------------------
 drivers/ide/ide-probe.c |   21 ++++++------------
 drivers/ide/ide.c       |   17 --------------
 include/linux/ide.h     |    4 +--
 4 files changed, 33 insertions(+), 65 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -723,7 +723,7 @@ void do_ide_request(struct request_queue
 	spin_unlock_irq(q->queue_lock);
 	spin_lock_irq(&hwgroup->lock);
 
-	if (!ide_lock_hwgroup(hwgroup)) {
+	if (!ide_lock_hwgroup(hwgroup, hwif)) {
 		ide_hwif_t *prev_port;
 repeat:
 		prev_port = hwif->host->cur_port;
@@ -1002,44 +1002,30 @@ void ide_timer_expiry (unsigned long dat
  *	before completing the issuance of any new drive command, so we will not
  *	be accidentally invoked as a result of any valid command completion
  *	interrupt.
- *
- *	Note that we must walk the entire hwgroup here. We know which hwif
- *	is doing the current command, but we don't know which hwif burped
- *	mysteriously.
  */
 
 static void unexpected_intr(int irq, ide_hwif_t *hwif)
 {
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
-	u8 stat;
+	u8 stat = hwif->tp_ops->read_status(hwif);
 
-	/*
-	 * handle the unexpected interrupt
-	 */
-	do {
-		if (hwif->irq == irq) {
-			stat = hwif->tp_ops->read_status(hwif);
-
-			if (!OK_STAT(stat, ATA_DRDY, BAD_STAT)) {
-				/* Try to not flood the console with msgs */
-				static unsigned long last_msgtime, count;
-				++count;
-				if (time_after(jiffies, last_msgtime + HZ)) {
-					last_msgtime = jiffies;
-					printk(KERN_ERR "%s%s: unexpected interrupt, "
-						"status=0x%02x, count=%ld\n",
-						hwif->name,
-						(hwif->next==hwgroup->hwif) ? "" : "(?)", stat, count);
-				}
-			}
+	if (!OK_STAT(stat, ATA_DRDY, BAD_STAT)) {
+		/* Try to not flood the console with msgs */
+		static unsigned long last_msgtime, count;
+		++count;
+
+		if (time_after(jiffies, last_msgtime + HZ)) {
+			last_msgtime = jiffies;
+			printk(KERN_ERR "%s: unexpected interrupt, "
+				"status=0x%02x, count=%ld\n",
+				hwif->name, stat, count);
 		}
-	} while ((hwif = hwif->next) != hwgroup->hwif);
+	}
 }
 
 /**
  *	ide_intr	-	default IDE interrupt handler
  *	@irq: interrupt number
- *	@dev_id: hwif group
+ *	@dev_id: hwif
  *	@regs: unused weirdness from the kernel irq layer
  *
  *	This is the default IRQ handler for the IDE layer. You should
@@ -1063,17 +1049,19 @@ static void unexpected_intr(int irq, ide
  
 irqreturn_t ide_intr (int irq, void *dev_id)
 {
-	unsigned long flags;
-	ide_hwgroup_t *hwgroup = (ide_hwgroup_t *)dev_id;
-	ide_hwif_t *hwif = hwgroup->hwif;
+	ide_hwif_t *hwif = (ide_hwif_t *)dev_id;
+	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	ide_drive_t *uninitialized_var(drive);
 	ide_handler_t *handler;
+	unsigned long flags;
 	ide_startstop_t startstop;
 	irqreturn_t irq_ret = IRQ_NONE;
 	int plug_device = 0;
 
-	if (hwif->host->host_flags & IDE_HFLAG_SERIALIZE)
-		hwif = hwif->host->cur_port;
+	if (hwif->host->host_flags & IDE_HFLAG_SERIALIZE) {
+		if (hwif != hwif->host->cur_port)
+			goto out_early;
+	}
 
 	spin_lock_irqsave(&hwgroup->lock, flags);
 
@@ -1172,7 +1160,7 @@ out_handled:
 	irq_ret = IRQ_HANDLED;
 out:
 	spin_unlock_irqrestore(&hwgroup->lock, flags);
-
+out_early:
 	if (plug_device)
 		ide_plug_device(drive);
 
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1022,6 +1022,7 @@ static int init_irq (ide_hwif_t *hwif)
 	unsigned int index;
 	ide_hwgroup_t *hwgroup;
 	ide_hwif_t *match = NULL;
+	int sa = 0;
 
 	mutex_lock(&ide_cfg_mtx);
 	hwif->hwgroup = NULL;
@@ -1076,24 +1077,18 @@ static int init_irq (ide_hwif_t *hwif)
 
 	ide_ports[hwif->index] = hwif;
 
-	/*
-	 * Allocate the irq, if not already obtained for another hwif
-	 */
-	if (!match || match->irq != hwif->irq) {
-		int sa = 0;
 #if defined(__mc68000__)
-		sa = IRQF_SHARED;
+	sa = IRQF_SHARED;
 #endif /* __mc68000__ */
 
-		if (hwif->chipset == ide_pci)
-			sa = IRQF_SHARED;
+	if (hwif->chipset == ide_pci)
+		sa = IRQF_SHARED;
 
-		if (io_ports->ctl_addr)
-			hwif->tp_ops->set_irq(hwif, 1);
+	if (io_ports->ctl_addr)
+		hwif->tp_ops->set_irq(hwif, 1);
 
-		if (request_irq(hwif->irq,&ide_intr,sa,hwif->name,hwgroup))
-	       		goto out_unlink;
-	}
+	if (request_irq(hwif->irq, &ide_intr, sa, hwif->name, hwif))
+		goto out_unlink;
 
 	if (!hwif->rqsize) {
 		if ((hwif->host_flags & IDE_HFLAG_NO_LBA48) ||
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -175,10 +175,6 @@ EXPORT_SYMBOL_GPL(ide_port_unregister_de
 
 void ide_unregister(ide_hwif_t *hwif)
 {
-	ide_hwif_t *g;
-	ide_hwgroup_t *hwgroup;
-	int irq_count = 0;
-
 	BUG_ON(in_interrupt());
 	BUG_ON(irqs_disabled());
 
@@ -191,18 +187,7 @@ void ide_unregister(ide_hwif_t *hwif)
 
 	ide_proc_unregister_port(hwif);
 
-	hwgroup = hwif->hwgroup;
-	/*
-	 * free the irq if we were the only hwif using it
-	 */
-	g = hwgroup->hwif;
-	do {
-		if (g->irq == hwif->irq)
-			++irq_count;
-		g = g->next;
-	} while (g != hwgroup->hwif);
-	if (irq_count == 1)
-		free_irq(hwif->irq, hwgroup);
+	free_irq(hwif->irq, hwif);
 
 	ide_remove_port_from_hwgroup(hwif);
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1274,14 +1274,14 @@ extern void ide_stall_queue(ide_drive_t 
 extern void ide_timer_expiry(unsigned long);
 extern irqreturn_t ide_intr(int irq, void *dev_id);
 
-static inline int ide_lock_hwgroup(ide_hwgroup_t *hwgroup)
+static inline int ide_lock_hwgroup(ide_hwgroup_t *hwgroup, ide_hwif_t *hwif)
 {
 	if (hwgroup->busy)
 		return 1;
 
 	hwgroup->busy = 1;
 	/* for atari only */
-	ide_get_lock(ide_intr, hwgroup);
+	ide_get_lock(ide_intr, hwif);
 
 	return 0;
 }
