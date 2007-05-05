Return-Path: <linux-kernel-owner+w=401wt.eu-S934041AbXEEWRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041AbXEEWRN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 18:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934045AbXEEWRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 18:17:13 -0400
Received: from mail.screens.ru ([213.234.233.54]:34283 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934041AbXEEWRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 18:17:12 -0400
Date: Sun, 6 May 2007 02:17:09 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm] libata-core: convert to use cancel_rearming_delayed_work()
Message-ID: <20070505221709.GA3955@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Compile tested, depends on

	make-cancel_rearming_delayed_work-reliable.patch

We should not use cancel_work_sync(delayed_work->work). This works, but not
good. We can use cancel_rearming_delayed_work(), this also simplifies the
code.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 drivers/ata/libata-core.c |   44 ++++----------------------------------------
 include/linux/libata.h    |    1 -
 2 files changed, 4 insertions(+), 41 deletions(-)

--- OLD/include/linux/libata.h~ATA	2007-04-05 12:20:35.000000000 +0400
+++ OLD/include/linux/libata.h	2007-05-06 01:41:10.000000000 +0400
@@ -192,7 +192,6 @@ enum {
 	ATA_PFLAG_UNLOADING	= (1 << 5), /* module is unloading */
 	ATA_PFLAG_SCSI_HOTPLUG	= (1 << 6), /* SCSI hotplug scheduled */
 
-	ATA_PFLAG_FLUSH_PORT_TASK = (1 << 16), /* flush port task */
 	ATA_PFLAG_SUSPENDED	= (1 << 17), /* port is suspended (power) */
 	ATA_PFLAG_PM_PENDING	= (1 << 18), /* PM operation pending */
 
--- OLD/drivers/ata/libata-core.c~ATA	2007-04-05 12:20:34.000000000 +0400
+++ OLD/drivers/ata/libata-core.c	2007-05-06 01:53:43.000000000 +0400
@@ -1079,18 +1079,11 @@ static unsigned int ata_id_xfermask(cons
 void ata_port_queue_task(struct ata_port *ap, work_func_t fn, void *data,
 			 unsigned long delay)
 {
-	int rc;
-
-	if (ap->pflags & ATA_PFLAG_FLUSH_PORT_TASK)
-		return;
-
 	PREPARE_DELAYED_WORK(&ap->port_task, fn);
 	ap->port_task_data = data;
 
-	rc = queue_delayed_work(ata_wq, &ap->port_task, delay);
-
-	/* rc == 0 means that another user is using port task */
-	WARN_ON(rc == 0);
+	/* may fail if ata_port_flush_task() in progress */
+	queue_delayed_work(ata_wq, &ap->port_task, delay);
 }
 
 /**
@@ -1105,32 +1098,9 @@ void ata_port_queue_task(struct ata_port
  */
 void ata_port_flush_task(struct ata_port *ap)
 {
-	unsigned long flags;
-
 	DPRINTK("ENTER\n");
 
-	spin_lock_irqsave(ap->lock, flags);
-	ap->pflags |= ATA_PFLAG_FLUSH_PORT_TASK;
-	spin_unlock_irqrestore(ap->lock, flags);
-
-	DPRINTK("flush #1\n");
-	cancel_work_sync(&ap->port_task.work); /* akpm: seems unneeded */
-
-	/*
-	 * At this point, if a task is running, it's guaranteed to see
-	 * the FLUSH flag; thus, it will never queue pio tasks again.
-	 * Cancel and flush.
-	 */
-	if (!cancel_delayed_work(&ap->port_task)) {
-		if (ata_msg_ctl(ap))
-			ata_port_printk(ap, KERN_DEBUG, "%s: flush #2\n",
-					__FUNCTION__);
-		cancel_work_sync(&ap->port_task.work);
-	}
-
-	spin_lock_irqsave(ap->lock, flags);
-	ap->pflags &= ~ATA_PFLAG_FLUSH_PORT_TASK;
-	spin_unlock_irqrestore(ap->lock, flags);
+	cancel_rearming_delayed_work(&ap->port_task);
 
 	if (ata_msg_ctl(ap))
 		ata_port_printk(ap, KERN_DEBUG, "%s: EXIT\n", __FUNCTION__);
@@ -6094,13 +6064,7 @@ void ata_port_detach(struct ata_port *ap
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	ata_port_wait_eh(ap);
-
-	/* Flush hotplug task.  The sequence is similar to
-	 * ata_port_flush_task().
-	 */
-	cancel_work_sync(&ap->hotplug_task.work); /* akpm: why? */
-	cancel_delayed_work(&ap->hotplug_task);
-	cancel_work_sync(&ap->hotplug_task.work);
+	cancel_rearming_delayed_work(&ap->hotplug_task);
 
  skip_eh:
 	/* remove the associated SCSI host */

