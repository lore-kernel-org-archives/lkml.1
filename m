Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358Ab0ARAx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab0ARAx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218Ab0ARAxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:53:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:54465 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281Ab0ARAxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:53:49 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 31/40] libata: take advantage of cmwq and remove concurrency limitations
Date: Mon, 18 Jan 2010 09:57:43 +0900
Message-Id: <1263776272-382-32-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libata has two concurrency related limitations.

a. ata_wq which is used for polling PIO has single thread per CPU.  If
   there are multiple devices doing polling PIO on the same CPU, they
   can't be executed simultaneously.

b. ata_aux_wq which is used for SCSI probing has single thread.  In
   cases where SCSI probing is stalled for extended period of time
   which is possible for ATAPI devices, this will stall all probing.

#a is solved by increasing maximum concurrency of ata_wq.  Please note
that polling PIO might be used under allocation path and thus needs to
be served by a separate wq with a rescuer.

#b is solved by using the default wq instead and achieving exclusion
via per-port mutex.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>
---
 drivers/ata/libata-core.c |   19 ++-----------------
 drivers/ata/libata-eh.c   |    4 ++--
 drivers/ata/libata-scsi.c |   11 ++++++-----
 drivers/ata/libata.h      |    1 -
 include/linux/libata.h    |    2 ++
 5 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 22ff51b..de91814 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -97,8 +97,6 @@ static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 unsigned int ata_print_id = 1;
 static struct workqueue_struct *ata_wq;
 
-struct workqueue_struct *ata_aux_wq;
-
 struct ata_force_param {
 	const char	*name;
 	unsigned int	cbl;
@@ -5681,6 +5679,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 #else
 	INIT_DELAYED_WORK(&ap->port_task, NULL);
 #endif
+	mutex_init(&ap->scsi_scan_mutex);
 	INIT_DELAYED_WORK(&ap->hotplug_task, ata_scsi_hotplug);
 	INIT_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
 	INIT_LIST_HEAD(&ap->eh_done_q);
@@ -6616,26 +6615,13 @@ static int __init ata_init(void)
 {
 	ata_parse_force_param();
 
-	/*
-	 * FIXME: In UP case, there is only one workqueue thread and if you
-	 * have more than one PIO device, latency is bloody awful, with
-	 * occasional multi-second "hiccups" as one PIO device waits for
-	 * another.  It's an ugly wart that users DO occasionally complain
-	 * about; luckily most users have at most one PIO polled device.
-	 */
-	ata_wq = create_workqueue("ata");
+	ata_wq = __create_workqueue("ata", WQ_RESCUER, WQ_MAX_ACTIVE);
 	if (!ata_wq)
 		goto free_force_tbl;
 
-	ata_aux_wq = create_singlethread_workqueue("ata_aux");
-	if (!ata_aux_wq)
-		goto free_wq;
-
 	printk(KERN_DEBUG "libata version " DRV_VERSION " loaded.\n");
 	return 0;
 
-free_wq:
-	destroy_workqueue(ata_wq);
 free_force_tbl:
 	kfree(ata_force_tbl);
 	return -ENOMEM;
@@ -6645,7 +6631,6 @@ static void __exit ata_exit(void)
 {
 	kfree(ata_force_tbl);
 	destroy_workqueue(ata_wq);
-	destroy_workqueue(ata_aux_wq);
 }
 
 subsys_initcall(ata_init);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 0ea97c9..73735ab 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -727,7 +727,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 	if (ap->pflags & ATA_PFLAG_LOADING)
 		ap->pflags &= ~ATA_PFLAG_LOADING;
 	else if (ap->pflags & ATA_PFLAG_SCSI_HOTPLUG)
-		queue_delayed_work(ata_aux_wq, &ap->hotplug_task, 0);
+		schedule_delayed_work(&ap->hotplug_task, 0);
 
 	if (ap->pflags & ATA_PFLAG_RECOVERED)
 		ata_port_printk(ap, KERN_INFO, "EH complete\n");
@@ -2938,7 +2938,7 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 			ehc->i.flags |= ATA_EHI_SETMODE;
 
 			/* schedule the scsi_rescan_device() here */
-			queue_work(ata_aux_wq, &(ap->scsi_rescan_task));
+			schedule_work(&(ap->scsi_rescan_task));
 		} else if (dev->class == ATA_DEV_UNKNOWN &&
 			   ehc->tries[dev->devno] &&
 			   ata_class_enabled(ehc->classes[dev->devno])) {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f4ea5a8..08e2ef8 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3408,8 +3408,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 				"                  switching to async\n");
 	}
 
-	queue_delayed_work(ata_aux_wq, &ap->hotplug_task,
-			   round_jiffies_relative(HZ));
+	schedule_delayed_work(&ap->hotplug_task, round_jiffies_relative(HZ));
 }
 
 /**
@@ -3555,6 +3554,7 @@ void ata_scsi_hotplug(struct work_struct *work)
 	}
 
 	DPRINTK("ENTER\n");
+	mutex_lock(&ap->scsi_scan_mutex);
 
 	/* Unplug detached devices.  We cannot use link iterator here
 	 * because PMP links have to be scanned even if PMP is
@@ -3568,6 +3568,7 @@ void ata_scsi_hotplug(struct work_struct *work)
 	/* scan for new ones */
 	ata_scsi_scan_host(ap, 0);
 
+	mutex_unlock(&ap->scsi_scan_mutex);
 	DPRINTK("EXIT\n");
 }
 
@@ -3646,9 +3647,7 @@ static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
  *	@work: Pointer to ATA port to perform scsi_rescan_device()
  *
  *	After ATA pass thru (SAT) commands are executed successfully,
- *	libata need to propagate the changes to SCSI layer.  This
- *	function must be executed from ata_aux_wq such that sdev
- *	attach/detach don't race with rescan.
+ *	libata need to propagate the changes to SCSI layer.
  *
  *	LOCKING:
  *	Kernel thread context (may sleep).
@@ -3661,6 +3660,7 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 	struct ata_device *dev;
 	unsigned long flags;
 
+	mutex_lock(&ap->scsi_scan_mutex);
 	spin_lock_irqsave(ap->lock, flags);
 
 	ata_for_each_link(link, ap, EDGE) {
@@ -3680,6 +3680,7 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 	}
 
 	spin_unlock_irqrestore(ap->lock, flags);
+	mutex_unlock(&ap->scsi_scan_mutex);
 }
 
 /**
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 823e630..4da2105 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -65,7 +65,6 @@ enum {
 };
 
 extern unsigned int ata_print_id;
-extern struct workqueue_struct *ata_aux_wq;
 extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 6a9c4dd..c4fd18e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -749,6 +749,8 @@ struct ata_port {
 
 	void			*port_task_data;
 	struct delayed_work	port_task;
+
+	struct mutex		scsi_scan_mutex;
 	struct delayed_work	hotplug_task;
 	struct work_struct	scsi_rescan_task;
 
-- 
1.6.4.2

