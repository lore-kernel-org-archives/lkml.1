Return-Path: <linux-kernel-owner+w=401wt.eu-S1750936AbXBMUO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbXBMUO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbXBMUO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:14:28 -0500
Received: from mail.screens.ru ([213.234.233.54]:47247 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbXBMUO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:14:27 -0500
Date: Tue, 13 Feb 2007 23:14:10 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] unify flush_work/flush_work_keventd and rename it to cancel_work_sync
Message-ID: <20070213201410.GA204@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

flush_work(wq, work) doesn't need the first parameter, we can use cwq->wq
(this was possible from the very beginnig, I missed this). So we can unify
flush_work_keventd and flush_work.

Also, rename flush_work() to cancel_work_sync() and fix all callers. Perhaps
this is not the best name, but "flush_work" is really bad.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/workqueue.h      |   21 ++++++++++++---------
 kernel/workqueue.c             |   36 +++++++++++++++++-------------------
 fs/aio.c                       |    4 ++--
 block/ll_rw_blk.c              |    2 +-
 drivers/ata/libata-core.c      |    8 ++++----
 drivers/net/e1000/e1000_main.c |    2 +-
 drivers/net/phy/phy.c          |    4 ++--
 drivers/net/tg3.c              |    2 +-
 kernel/relay.c                 |    2 +-
 net/ipv4/ipvs/ip_vs_ctl.c      |    2 +-
 10 files changed, 42 insertions(+), 41 deletions(-)

--- 6.20-rc6-mm3/include/linux/workqueue.h~5_flush	2007-02-12 03:32:22.000000000 +0300
+++ 6.20-rc6-mm3/include/linux/workqueue.h	2007-02-12 03:26:54.000000000 +0300
@@ -168,29 +168,32 @@ extern struct workqueue_struct *__create
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
 extern int FASTCALL(queue_work(struct workqueue_struct *wq, struct work_struct *work));
-extern int FASTCALL(queue_delayed_work(struct workqueue_struct *wq, struct delayed_work *work, unsigned long delay));
+extern int FASTCALL(queue_delayed_work(struct workqueue_struct *wq,
+			struct delayed_work *work, unsigned long delay));
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
-	struct delayed_work *work, unsigned long delay);
+			struct delayed_work *work, unsigned long delay);
+
 extern void FASTCALL(flush_workqueue(struct workqueue_struct *wq));
-extern void flush_work(struct workqueue_struct *wq, struct work_struct *work);
-extern void flush_work_keventd(struct work_struct *work);
+extern void flush_scheduled_work(void);
 
 extern int FASTCALL(schedule_work(struct work_struct *work));
-extern int FASTCALL(schedule_delayed_work(struct delayed_work *work, unsigned long delay));
-
-extern int schedule_delayed_work_on(int cpu, struct delayed_work *work, unsigned long delay);
+extern int FASTCALL(schedule_delayed_work(struct delayed_work *work,
+					unsigned long delay));
+extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
+					unsigned long delay);
 extern int schedule_on_each_cpu(work_func_t func);
-extern void flush_scheduled_work(void);
 extern int current_is_keventd(void);
 extern int keventd_up(void);
 
 extern void init_workqueues(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
+extern void cancel_work_sync(struct work_struct *work);
+
 /*
  * Kill off a pending schedule_delayed_work().  Note that the work callback
  * function may still be running on return from cancel_delayed_work().  Run
- * flush_workqueue() or flush_work() to wait on it.
+ * flush_workqueue() or cancel_work_sync() to wait on it.
  */
 static inline int cancel_delayed_work(struct delayed_work *work)
 {
--- 6.20-rc6-mm3/kernel/workqueue.c~5_flush	2007-02-12 03:30:08.000000000 +0300
+++ 6.20-rc6-mm3/kernel/workqueue.c	2007-02-12 03:26:54.000000000 +0300
@@ -421,23 +421,23 @@ static void wait_on_work(struct cpu_work
 }
 
 /**
- * flush_work - block until a work_struct's callback has terminated
- * @wq: the workqueue on which the work is queued
+ * cancel_work_sync - block until a work_struct's callback has terminated
  * @work: the work which is to be flushed
  *
- * flush_work() will attempt to cancel the work if it is queued.  If the work's
- * callback appears to be running, flush_work() will block until it has
- * completed.
+ * cancel_work_sync() will attempt to cancel the work if it is queued. If the
+ * work's callback appears to be running, cancel_work_sync() will block until
+ * it has completed.
  *
- * flush_work() is designed to be used when the caller is tearing down data
- * structures which the callback function operates upon.  It is expected that,
- * prior to calling flush_work(), the caller has arranged for the work to not
- * be requeued.
+ * cancel_work_sync() is designed to be used when the caller is tearing down
+ * data structures which the callback function operates upon. It is expected
+ * that, prior to calling cancel_work_sync(), the caller has arranged for the
+ * work to not be requeued.
  */
-void flush_work(struct workqueue_struct *wq, struct work_struct *work)
+void cancel_work_sync(struct work_struct *work)
 {
-	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	struct cpu_workqueue_struct *cwq;
+	struct workqueue_struct *wq;
+	const cpumask_t *cpu_map;
 	int cpu;
 
 	might_sleep();
@@ -456,10 +456,13 @@ void flush_work(struct workqueue_struct 
 	work_release(work);
 	spin_unlock_irq(&cwq->lock);
 
+	wq = cwq->wq;
+	cpu_map = wq_cpu_map(wq);
+
 	for_each_cpu_mask(cpu, *cpu_map)
 		wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
-EXPORT_SYMBOL_GPL(flush_work);
+EXPORT_SYMBOL_GPL(cancel_work_sync);
 
 
 static struct workqueue_struct *keventd_wq;
@@ -548,18 +551,13 @@ void flush_scheduled_work(void)
 }
 EXPORT_SYMBOL(flush_scheduled_work);
 
-void flush_work_keventd(struct work_struct *work)
-{
-	flush_work(keventd_wq, work);
-}
-EXPORT_SYMBOL(flush_work_keventd);
-
 /**
  * cancel_rearming_delayed_work - kill off a delayed work whose handler rearms the delayed work.
  * @dwork: the delayed work struct
  *
  * Note that the work callback function may still be running on return from
- * cancel_delayed_work(). Run flush_workqueue() or flush_work() to wait on it.
+ * cancel_delayed_work(). Run flush_workqueue() or cancel_work_sync() to wait
+ * on it.
  */
 void cancel_rearming_delayed_work(struct delayed_work *dwork)
 {
--- 6.20-rc6-mm3/fs/aio.c~6_fix_callers	2007-02-03 20:41:05.000000000 +0300
+++ 6.20-rc6-mm3/fs/aio.c	2007-02-12 03:36:15.000000000 +0300
@@ -351,7 +351,7 @@ void fastcall exit_aio(struct mm_struct 
 		/*
 		 * Ensure we don't leave the ctx on the aio_wq
 		 */
-		flush_work(aio_wq, &ctx->wq.work);
+		cancel_work_sync(&ctx->wq.work);
 
 		if (1 != atomic_read(&ctx->users))
 			printk(KERN_DEBUG
@@ -374,7 +374,7 @@ void fastcall __put_ioctx(struct kioctx 
 	BUG_ON(ctx->reqs_active);
 
 	cancel_delayed_work(&ctx->wq);
-	flush_work(aio_wq, &ctx->wq.work);
+	cancel_work_sync(&ctx->wq.work);
 	aio_free_ring(ctx);
 	mmdrop(ctx->mm);
 	ctx->mm = NULL;
--- 6.20-rc6-mm3/block/ll_rw_blk.c~6_fix_callers	2007-02-03 20:40:45.000000000 +0300
+++ 6.20-rc6-mm3/block/ll_rw_blk.c	2007-02-12 03:36:15.000000000 +0300
@@ -3649,7 +3649,7 @@ EXPORT_SYMBOL(kblockd_schedule_work);
 
 void kblockd_flush_work(struct work_struct *work)
 {
-	flush_work(kblockd_workqueue, work);
+	cancel_work_sync(work);
 }
 EXPORT_SYMBOL(kblockd_flush_work);
 
--- 6.20-rc6-mm3/drivers/ata/libata-core.c~6_fix_callers	2007-02-03 20:40:47.000000000 +0300
+++ 6.20-rc6-mm3/drivers/ata/libata-core.c	2007-02-12 03:36:15.000000000 +0300
@@ -1138,7 +1138,7 @@ void ata_port_flush_task(struct ata_port
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	DPRINTK("flush #1\n");
-	flush_work(ata_wq, &ap->port_task.work); /* akpm: seems unneeded */
+	cancel_work_sync(&ap->port_task.work); /* akpm: seems unneeded */
 
 	/*
 	 * At this point, if a task is running, it's guaranteed to see
@@ -1149,7 +1149,7 @@ void ata_port_flush_task(struct ata_port
 		if (ata_msg_ctl(ap))
 			ata_port_printk(ap, KERN_DEBUG, "%s: flush #2\n",
 					__FUNCTION__);
-		flush_work(ata_wq, &ap->port_task.work);
+		cancel_work_sync(&ap->port_task.work);
 	}
 
 	spin_lock_irqsave(ap->lock, flags);
@@ -5996,9 +5996,9 @@ void ata_port_detach(struct ata_port *ap
 	/* Flush hotplug task.  The sequence is similar to
 	 * ata_port_flush_task().
 	 */
-	flush_work(ata_aux_wq, &ap->hotplug_task.work); /* akpm: why? */
+	cancel_work_sync(&ap->hotplug_task.work); /* akpm: why? */
 	cancel_delayed_work(&ap->hotplug_task);
-	flush_work(ata_aux_wq, &ap->hotplug_task.work);
+	cancel_work_sync(&ap->hotplug_task.work);
 
  skip_eh:
 	/* remove the associated SCSI host */
--- 6.20-rc6-mm3/drivers/net/e1000/e1000_main.c~6_fix_callers	2007-02-03 20:40:58.000000000 +0300
+++ 6.20-rc6-mm3/drivers/net/e1000/e1000_main.c	2007-02-12 03:36:15.000000000 +0300
@@ -1216,7 +1216,7 @@ e1000_remove(struct pci_dev *pdev)
 	int i;
 #endif
 
-	flush_work_keventd(&adapter->reset_task);
+	cancel_work_sync(&adapter->reset_task);
 
 	e1000_release_manageability(adapter);
 
--- 6.20-rc6-mm3/drivers/net/phy/phy.c~6_fix_callers	2007-02-03 20:40:58.000000000 +0300
+++ 6.20-rc6-mm3/drivers/net/phy/phy.c	2007-02-12 03:36:15.000000000 +0300
@@ -585,9 +585,9 @@ int phy_stop_interrupts(struct phy_devic
 
 	/*
 	 * Finish any pending work; we might have been scheduled to be called
-	 * from keventd ourselves, but flush_work_keventd() handles that.
+	 * from keventd ourselves, but cancel_work_sync() handles that.
 	 */
-	flush_work_keventd(&phydev->phy_queue);
+	cancel_work_sync(&phydev->phy_queue);
 
 	free_irq(phydev->irq, phydev);
 
--- 6.20-rc6-mm3/drivers/net/tg3.c~6_fix_callers	2007-02-03 20:40:59.000000000 +0300
+++ 6.20-rc6-mm3/drivers/net/tg3.c	2007-02-12 03:36:15.000000000 +0300
@@ -7336,7 +7336,7 @@ static int tg3_close(struct net_device *
 {
 	struct tg3 *tp = netdev_priv(dev);
 
-	flush_work_keventd(&tp->reset_task);
+	cancel_work_sync(&tp->reset_task);
 
 	netif_stop_queue(dev);
 
--- 6.20-rc6-mm3/kernel/relay.c~6_fix_callers	2007-02-03 20:41:10.000000000 +0300
+++ 6.20-rc6-mm3/kernel/relay.c	2007-02-12 03:36:15.000000000 +0300
@@ -340,7 +340,7 @@ static void __relay_reset(struct rchan_b
 		INIT_DELAYED_WORK(&buf->wake_readers, NULL);
 	} else {
 		cancel_delayed_work(&buf->wake_readers);
-		flush_work_keventd(&buf->wake_readers.work);
+		cancel_work_sync(&buf->wake_readers.work);
 	}
 
 	buf->subbufs_produced = 0;
--- 6.20-rc6-mm3/net/ipv4/ipvs/ip_vs_ctl.c~6_fix_callers	2007-02-10 23:14:41.000000000 +0300
+++ 6.20-rc6-mm3/net/ipv4/ipvs/ip_vs_ctl.c	2007-02-12 03:36:15.000000000 +0300
@@ -2387,7 +2387,7 @@ void ip_vs_control_cleanup(void)
 	EnterFunction(2);
 	ip_vs_trash_cleanup();
 	cancel_rearming_delayed_work(&defense_work);
-	flush_work_keventd(&defense_work.work);
+	cancel_work_sync(&defense_work.work);
 	ip_vs_kill_estimator(&ip_vs_stats);
 	unregister_sysctl_table(sysctl_header);
 	proc_net_remove("ip_vs_stats");

