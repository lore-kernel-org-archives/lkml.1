Return-Path: <linux-kernel-owner+w=401wt.eu-S964834AbXBZHVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834AbXBZHVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 02:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964781AbXBZHVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 02:21:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57880 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933785AbXBZHVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 02:21:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@osdl.org>
Subject: [PATCH -mm 6/6] Freezer: Add try_to_freeze calls to all kernel threads
Date: Mon, 26 Feb 2007 08:13:30 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
References: <200702260800.49603.rjw@sisk.pl>
In-Reply-To: <200702260800.49603.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702260813.31932.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add try_to_freeze() calls to the remaining kernel threads that do not call
try_to_freeze() already, although they set PF_NOFREEZE.

In the future we are going to replace PF_NOFREEZE with a set of flags that will
be set to indicate in which situations the task should not be frozen (for
example, there can be a task that should be frozen for the CPU hotplugging and
should not be frozen for the system suspend).  For this reason every kernel
thread should be able to freeze itself (ie. call try_to_freeze()), so that it
can be frozen whenever necessary.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 arch/i386/kernel/apm.c              |    2 ++
 drivers/block/loop.c                |    2 ++
 drivers/char/apm-emulation.c        |    3 +++
 drivers/ieee1394/ieee1394_core.c    |    3 +++
 drivers/md/md.c                     |    2 ++
 drivers/mmc/card/queue.c            |    3 +++
 drivers/mtd/mtd_blkdevs.c           |    3 +++
 drivers/scsi/libsas/sas_scsi_host.c |    3 +++
 drivers/scsi/scsi_error.c           |    3 +++
 drivers/usb/storage/usb.c           |    2 ++
 kernel/softirq.c                    |    2 ++
 kernel/softlockup.c                 |    2 ++
 kernel/workqueue.c                  |    3 +--
 13 files changed, 31 insertions(+), 2 deletions(-)

Index: linux-2.6.20-mm2/arch/i386/kernel/apm.c
===================================================================
--- linux-2.6.20-mm2.orig/arch/i386/kernel/apm.c	2007-02-22 23:48:52.000000000 +0100
+++ linux-2.6.20-mm2/arch/i386/kernel/apm.c	2007-02-23 00:34:25.000000000 +0100
@@ -227,6 +227,7 @@
 #include <linux/dmi.h>
 #include <linux/suspend.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -1402,6 +1403,7 @@ static void apm_mainloop(void)
 	add_wait_queue(&apm_waitqueue, &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
 	for (;;) {
+		try_to_freeze();
 		schedule_timeout(APM_CHECK_TIMEOUT);
 		if (kthread_should_stop())
 			break;
Index: linux-2.6.20-mm2/drivers/md/md.c
===================================================================
--- linux-2.6.20-mm2.orig/drivers/md/md.c	2007-02-22 23:48:52.000000000 +0100
+++ linux-2.6.20-mm2/drivers/md/md.c	2007-02-23 00:34:25.000000000 +0100
@@ -4513,6 +4513,8 @@ static int md_thread(void * arg)
 			 || kthread_should_stop(),
 			 thread->timeout);
 
+		try_to_freeze();
+
 		clear_bit(THREAD_WAKEUP, &thread->flags);
 
 		thread->run(thread->mddev);
Index: linux-2.6.20-mm2/drivers/mmc/card/queue.c
===================================================================
--- linux-2.6.20-mm2.orig/drivers/mmc/card/queue.c	2007-02-22 23:48:52.000000000 +0100
+++ linux-2.6.20-mm2/drivers/mmc/card/queue.c	2007-02-23 00:34:25.000000000 +0100
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -71,6 +72,8 @@ static int mmc_queue_thread(void *d)
 	do {
 		struct request *req = NULL;
 
+		try_to_freeze();
+
 		spin_lock_irq(q->queue_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (!blk_queue_plugged(q))
Index: linux-2.6.20-mm2/drivers/mtd/mtd_blkdevs.c
===================================================================
--- linux-2.6.20-mm2.orig/drivers/mtd/mtd_blkdevs.c	2007-02-22 23:48:52.000000000 +0100
+++ linux-2.6.20-mm2/drivers/mtd/mtd_blkdevs.c	2007-02-23 00:34:25.000000000 +0100
@@ -20,6 +20,7 @@
 #include <linux/hdreg.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 #include <asm/uaccess.h>
 
 static LIST_HEAD(blktrans_majors);
@@ -113,6 +114,8 @@ static int mtd_blktrans_thread(void *arg
 			schedule();
 			remove_wait_queue(&tr->blkcore_priv->thread_wq, &wait);
 
+			try_to_freeze();
+
 			spin_lock_irq(rq->queue_lock);
 
 			continue;
Index: linux-2.6.20-mm2/drivers/usb/storage/usb.c
===================================================================
--- linux-2.6.20-mm2.orig/drivers/usb/storage/usb.c	2007-02-22 23:48:52.000000000 +0100
+++ linux-2.6.20-mm2/drivers/usb/storage/usb.c	2007-02-23 00:34:25.000000000 +0100
@@ -304,6 +304,8 @@ static int usb_stor_control_thread(void 
 	current->flags |= PF_NOFREEZE;
 
 	for(;;) {
+		try_to_freeze();
+
 		US_DEBUGP("*** thread sleeping.\n");
 		if(down_interruptible(&us->sema))
 			break;
Index: linux-2.6.20-mm2/drivers/ieee1394/ieee1394_core.c
===================================================================
--- linux-2.6.20-mm2.orig/drivers/ieee1394/ieee1394_core.c	2007-02-22 23:48:52.000000000 +0100
+++ linux-2.6.20-mm2/drivers/ieee1394/ieee1394_core.c	2007-02-23 00:34:25.000000000 +0100
@@ -35,6 +35,7 @@
 #include <linux/kthread.h>
 #include <linux/preempt.h>
 #include <linux/time.h>
+#include <linux/freezer.h>
 
 #include <asm/system.h>
 #include <asm/byteorder.h>
@@ -1081,6 +1082,8 @@ static int hpsbpkt_thread(void *__hi)
 			complete_routine(complete_data);
 		}
 
+		try_to_freeze();
+
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (!skb_peek(&hpsbpkt_queue))
 			schedule();
Index: linux-2.6.20-mm2/drivers/char/apm-emulation.c
===================================================================
--- linux-2.6.20-mm2.orig/drivers/char/apm-emulation.c	2007-02-22 23:48:52.000000000 +0100
+++ linux-2.6.20-mm2/drivers/char/apm-emulation.c	2007-02-23 00:34:25.000000000 +0100
@@ -27,6 +27,7 @@
 #include <linux/completion.h>
 #include <linux/kthread.h>
 #include <linux/delay.h>
+#include <linux/freezer.h>
 
 #include <asm/system.h>
 
@@ -539,6 +540,8 @@ static int kapmd(void *arg)
 		apm_event_t event;
 		int ret;
 
+		try_to_freeze();
+
 		wait_event_interruptible(kapmd_wait,
 				!queue_empty(&kapmd_queue) || kthread_should_stop());
 
Index: linux-2.6.20-mm2/drivers/block/loop.c
===================================================================
--- linux-2.6.20-mm2.orig/drivers/block/loop.c	2007-02-22 23:48:52.000000000 +0100
+++ linux-2.6.20-mm2/drivers/block/loop.c	2007-02-23 00:34:25.000000000 +0100
@@ -74,6 +74,7 @@
 #include <linux/highmem.h>
 #include <linux/gfp.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 
@@ -580,6 +581,7 @@ static int loop_thread(void *data)
 	set_user_nice(current, -20);
 
 	while (!kthread_should_stop() || lo->lo_bio) {
+		try_to_freeze();
 
 		wait_event_interruptible(lo->lo_event,
 				lo->lo_bio || kthread_should_stop());
Index: linux-2.6.20-mm2/drivers/scsi/libsas/sas_scsi_host.c
===================================================================
--- linux-2.6.20-mm2.orig/drivers/scsi/libsas/sas_scsi_host.c	2007-02-22 23:48:52.000000000 +0100
+++ linux-2.6.20-mm2/drivers/scsi/libsas/sas_scsi_host.c	2007-02-23 00:34:25.000000000 +0100
@@ -39,6 +39,7 @@
 #include <linux/err.h>
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
+#include <linux/freezer.h>
 
 /* ---------- SCSI Host glue ---------- */
 
@@ -875,6 +876,8 @@ static int sas_queue_thread(void *_sas_h
 	complete(&queue_th_comp);
 
 	while (1) {
+		try_to_freeze();
+
 		down_interruptible(&core->queue_thread_sema);
 		sas_queue(sas_ha);
 		if (core->queue_thread_kill)
Index: linux-2.6.20-mm2/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.20-mm2.orig/drivers/scsi/scsi_error.c	2007-02-22 23:48:52.000000000 +0100
+++ linux-2.6.20-mm2/drivers/scsi/scsi_error.c	2007-02-23 00:34:25.000000000 +0100
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <linux/freezer.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1536,6 +1537,8 @@ int scsi_error_handler(void *data)
 	 */
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
+		try_to_freeze();
+
 		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
 		    shost->host_failed != shost->host_busy) {
 			SCSI_LOG_ERROR_RECOVERY(1,
Index: linux-2.6.20-mm2/kernel/softlockup.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/softlockup.c	2007-02-22 23:48:52.000000000 +0100
+++ linux-2.6.20-mm2/kernel/softlockup.c	2007-02-23 00:34:25.000000000 +0100
@@ -13,6 +13,7 @@
 #include <linux/kthread.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
+#include <linux/freezer.h>
 
 static DEFINE_SPINLOCK(print_lock);
 
@@ -93,6 +94,7 @@ static int watchdog(void * __bind_cpu)
 	 * debug-printout triggers in softlockup_tick().
 	 */
 	while (!kthread_should_stop()) {
+		try_to_freeze();
 		set_current_state(TASK_INTERRUPTIBLE);
 		touch_softlockup_watchdog();
 		schedule();
Index: linux-2.6.20-mm2/kernel/softirq.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/softirq.c	2007-02-22 23:48:52.000000000 +0100
+++ linux-2.6.20-mm2/kernel/softirq.c	2007-02-23 00:34:25.000000000 +0100
@@ -18,6 +18,7 @@
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
+#include <linux/freezer.h>
 
 #include <asm/irq.h>
 /*
@@ -494,6 +495,7 @@ static int ksoftirqd(void * __bind_cpu)
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	while (!kthread_should_stop()) {
+		try_to_freeze();
 		preempt_disable();
 		if (!local_softirq_pending()) {
 			preempt_enable_no_resched();
