Return-Path: <linux-kernel-owner+w=401wt.eu-S965188AbXBQL3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188AbXBQL3y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 06:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965201AbXBQL3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 06:29:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45010 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965188AbXBQL3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 06:29:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Date: Sat, 17 Feb 2007 12:24:45 +0100
User-Agent: KMail/1.9.5
Cc: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, oleg@tv-sign.ru,
       Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <200702151431.10068.rjw@sisk.pl> <20070215142542.GA14931@in.ibm.com>
In-Reply-To: <20070215142542.GA14931@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702171224.46626.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 15 February 2007 15:25, Gautham R Shenoy wrote:
> On Thu, Feb 15, 2007 at 02:31:08PM +0100, Rafael J. Wysocki wrote:
> > 
> > So I think tonight I'll start adding try_to_freeze() to the kernel threads that
> > set PF_NOFREEZE.
> 
> cool! While you are at it, let me try to enhance the freezer api's
> to incorporate the PFE_* flags.

Here's a patch that adds try_to_freeze() to all kernel threads that didn't call
it before.  It shouldn't change the behavior of the threads in question, since
they won't be frozen because the are flagged as PF_NOFREEZE (of course
we are going to change this later).

Compile-tested on x86_64 with allmodconfig.

Pavel, do you think we can remove the PF_NOFREEZE from bluetooth, BTW?

 arch/i386/kernel/apm.c              |    2 ++
 drivers/block/loop.c                |    2 ++
 drivers/char/apm-emulation.c        |    3 +++
 drivers/ieee1394/ieee1394_core.c    |    3 +++
 drivers/md/md.c                     |    2 ++
 drivers/mmc/mmc_queue.c             |    3 +++
 drivers/mtd/mtd_blkdevs.c           |    3 +++
 drivers/scsi/libsas/sas_scsi_host.c |    3 +++
 drivers/scsi/scsi_error.c           |    3 +++
 drivers/usb/storage/usb.c           |    2 ++
 kernel/rcutorture.c                 |    2 ++
 kernel/softirq.c                    |    2 ++
 kernel/softlockup.c                 |    2 ++
 kernel/workqueue.c                  |    3 +--
 net/bluetooth/bnep/core.c           |    5 ++++-
 net/bluetooth/cmtp/core.c           |    3 +++
 net/bluetooth/hidp/core.c           |    3 +++
 net/bluetooth/rfcomm/core.c         |    3 +++
 18 files changed, 46 insertions(+), 3 deletions(-)

Index: linux-2.6.20-mm1/arch/i386/kernel/apm.c
===================================================================
--- linux-2.6.20-mm1.orig/arch/i386/kernel/apm.c	2007-02-17 00:43:19.000000000 +0100
+++ linux-2.6.20-mm1/arch/i386/kernel/apm.c	2007-02-17 00:43:31.000000000 +0100
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
Index: linux-2.6.20-mm1/drivers/md/md.c
===================================================================
--- linux-2.6.20-mm1.orig/drivers/md/md.c	2007-02-17 00:43:19.000000000 +0100
+++ linux-2.6.20-mm1/drivers/md/md.c	2007-02-17 00:43:31.000000000 +0100
@@ -4513,6 +4513,8 @@ static int md_thread(void * arg)
 			 || kthread_should_stop(),
 			 thread->timeout);
 
+		try_to_freeze();
+
 		clear_bit(THREAD_WAKEUP, &thread->flags);
 
 		thread->run(thread->mddev);
Index: linux-2.6.20-mm1/drivers/mmc/mmc_queue.c
===================================================================
--- linux-2.6.20-mm1.orig/drivers/mmc/mmc_queue.c	2007-02-17 00:43:19.000000000 +0100
+++ linux-2.6.20-mm1/drivers/mmc/mmc_queue.c	2007-02-17 00:43:31.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -70,6 +71,8 @@ static int mmc_queue_thread(void *d)
 	do {
 		struct request *req = NULL;
 
+		try_to_freeze();
+
 		spin_lock_irq(q->queue_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
 		req = elv_next_request(q);
Index: linux-2.6.20-mm1/drivers/mtd/mtd_blkdevs.c
===================================================================
--- linux-2.6.20-mm1.orig/drivers/mtd/mtd_blkdevs.c	2007-02-17 00:43:19.000000000 +0100
+++ linux-2.6.20-mm1/drivers/mtd/mtd_blkdevs.c	2007-02-17 00:43:31.000000000 +0100
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
Index: linux-2.6.20-mm1/drivers/usb/storage/usb.c
===================================================================
--- linux-2.6.20-mm1.orig/drivers/usb/storage/usb.c	2007-02-17 00:43:19.000000000 +0100
+++ linux-2.6.20-mm1/drivers/usb/storage/usb.c	2007-02-17 11:39:00.000000000 +0100
@@ -304,6 +304,8 @@ static int usb_stor_control_thread(void 
 	current->flags |= PF_NOFREEZE;
 
 	for(;;) {
+		try_to_freeze();
+
 		US_DEBUGP("*** thread sleeping.\n");
 		if(down_interruptible(&us->sema))
 			break;
Index: linux-2.6.20-mm1/drivers/ieee1394/ieee1394_core.c
===================================================================
--- linux-2.6.20-mm1.orig/drivers/ieee1394/ieee1394_core.c	2007-02-15 23:57:01.000000000 +0100
+++ linux-2.6.20-mm1/drivers/ieee1394/ieee1394_core.c	2007-02-17 00:43:31.000000000 +0100
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
Index: linux-2.6.20-mm1/drivers/char/apm-emulation.c
===================================================================
--- linux-2.6.20-mm1.orig/drivers/char/apm-emulation.c	2007-02-15 23:57:00.000000000 +0100
+++ linux-2.6.20-mm1/drivers/char/apm-emulation.c	2007-02-17 00:43:31.000000000 +0100
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
 
Index: linux-2.6.20-mm1/drivers/block/loop.c
===================================================================
--- linux-2.6.20-mm1.orig/drivers/block/loop.c	2007-02-15 23:57:00.000000000 +0100
+++ linux-2.6.20-mm1/drivers/block/loop.c	2007-02-17 00:43:31.000000000 +0100
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
Index: linux-2.6.20-mm1/drivers/scsi/libsas/sas_scsi_host.c
===================================================================
--- linux-2.6.20-mm1.orig/drivers/scsi/libsas/sas_scsi_host.c	2007-02-15 23:57:03.000000000 +0100
+++ linux-2.6.20-mm1/drivers/scsi/libsas/sas_scsi_host.c	2007-02-17 00:43:31.000000000 +0100
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
Index: linux-2.6.20-mm1/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.20-mm1.orig/drivers/scsi/scsi_error.c	2007-02-15 23:57:04.000000000 +0100
+++ linux-2.6.20-mm1/drivers/scsi/scsi_error.c	2007-02-17 00:43:31.000000000 +0100
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
Index: linux-2.6.20-mm1/kernel/softlockup.c
===================================================================
--- linux-2.6.20-mm1.orig/kernel/softlockup.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-mm1/kernel/softlockup.c	2007-02-17 00:43:31.000000000 +0100
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
Index: linux-2.6.20-mm1/kernel/rcutorture.c
===================================================================
--- linux-2.6.20-mm1.orig/kernel/rcutorture.c	2007-02-15 23:57:12.000000000 +0100
+++ linux-2.6.20-mm1/kernel/rcutorture.c	2007-02-17 00:43:31.000000000 +0100
@@ -46,6 +46,7 @@
 #include <linux/byteorder/swabb.h>
 #include <linux/stat.h>
 #include <linux/srcu.h>
+#include <linux/freezer.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
@@ -588,6 +589,7 @@ rcu_torture_writer(void *arg)
 	current->flags |= PF_NOFREEZE;
 
 	do {
+		try_to_freeze();
 		schedule_timeout_uninterruptible(1);
 		if ((rp = rcu_torture_alloc()) == NULL)
 			continue;
Index: linux-2.6.20-mm1/kernel/softirq.c
===================================================================
--- linux-2.6.20-mm1.orig/kernel/softirq.c	2007-02-15 23:57:12.000000000 +0100
+++ linux-2.6.20-mm1/kernel/softirq.c	2007-02-17 00:43:31.000000000 +0100
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
Index: linux-2.6.20-mm1/kernel/workqueue.c
===================================================================
--- linux-2.6.20-mm1.orig/kernel/workqueue.c	2007-02-15 23:57:12.000000000 +0100
+++ linux-2.6.20-mm1/kernel/workqueue.c	2007-02-17 00:49:10.000000000 +0100
@@ -315,8 +315,7 @@ static int worker_thread(void *__cwq)
 	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
 
 	for (;;) {
-		if (cwq->wq->freezeable)
-			try_to_freeze();
+		try_to_freeze();
 
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
 		if (!cwq->should_stop && list_empty(&cwq->worklist))
Index: linux-2.6.20-mm1/net/bluetooth/bnep/core.c
===================================================================
--- linux-2.6.20-mm1.orig/net/bluetooth/bnep/core.c	2007-02-15 23:57:12.000000000 +0100
+++ linux-2.6.20-mm1/net/bluetooth/bnep/core.c	2007-02-17 00:52:14.000000000 +0100
@@ -39,6 +39,7 @@
 #include <linux/errno.h>
 #include <linux/smp_lock.h>
 #include <linux/net.h>
+#include <linux/freezer.h>
 #include <net/sock.h>
 
 #include <linux/socket.h>
@@ -478,6 +479,8 @@ static int bnep_session(void *arg)
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(sk->sk_sleep, &wait);
 	while (!atomic_read(&s->killed)) {
+		try_to_freeze();
+
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		// RX
Index: linux-2.6.20-mm1/net/bluetooth/cmtp/core.c
===================================================================
--- linux-2.6.20-mm1.orig/net/bluetooth/cmtp/core.c	2007-02-15 23:57:12.000000000 +0100
+++ linux-2.6.20-mm1/net/bluetooth/cmtp/core.c	2007-02-17 00:53:09.000000000 +0100
@@ -34,6 +34,7 @@
 #include <linux/ioctl.h>
 #include <linux/file.h>
 #include <linux/init.h>
+#include <linux/freezer.h>
 #include <net/sock.h>
 
 #include <linux/isdn/capilli.h>
@@ -292,6 +293,8 @@ static int cmtp_session(void *arg)
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(sk->sk_sleep, &wait);
 	while (!atomic_read(&session->terminate)) {
+		try_to_freeze();
+
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (sk->sk_state != BT_CONNECTED)
Index: linux-2.6.20-mm1/net/bluetooth/hidp/core.c
===================================================================
--- linux-2.6.20-mm1.orig/net/bluetooth/hidp/core.c	2007-02-15 23:57:12.000000000 +0100
+++ linux-2.6.20-mm1/net/bluetooth/hidp/core.c	2007-02-17 00:53:54.000000000 +0100
@@ -35,6 +35,7 @@
 #include <linux/file.h>
 #include <linux/init.h>
 #include <linux/wait.h>
+#include <linux/freezer.h>
 #include <net/sock.h>
 
 #include <linux/input.h>
@@ -480,6 +481,8 @@ static int hidp_session(void *arg)
 	add_wait_queue(ctrl_sk->sk_sleep, &ctrl_wait);
 	add_wait_queue(intr_sk->sk_sleep, &intr_wait);
 	while (!atomic_read(&session->terminate)) {
+		try_to_freeze();
+
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (ctrl_sk->sk_state != BT_CONNECTED || intr_sk->sk_state != BT_CONNECTED)
Index: linux-2.6.20-mm1/net/bluetooth/rfcomm/core.c
===================================================================
--- linux-2.6.20-mm1.orig/net/bluetooth/rfcomm/core.c	2007-02-15 23:57:12.000000000 +0100
+++ linux-2.6.20-mm1/net/bluetooth/rfcomm/core.c	2007-02-17 00:55:35.000000000 +0100
@@ -37,6 +37,7 @@
 #include <linux/device.h>
 #include <linux/net.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 
 #include <net/sock.h>
 #include <asm/uaccess.h>
@@ -1851,6 +1852,8 @@ static void rfcomm_worker(void)
 	BT_DBG("");
 
 	while (!atomic_read(&terminate)) {
+		try_to_freeze();
+
 		if (!test_bit(RFCOMM_SCHED_WAKEUP, &rfcomm_event)) {
 			/* No pending events. Let's sleep.
 			 * Incoming connections and data will wake us up. */
