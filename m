Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbXDBFhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbXDBFhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXDBFhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:37:34 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:37120 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbXDBFha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:37:30 -0400
Date: Mon, 2 Apr 2007 11:07:05 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: [PATCH 1/8] Enhance process freezer interface for usage beyond software suspend
Message-ID: <20070402053705.GA12962@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402053457.GA9076@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch provides an interface to extend the use of the process
 freezer beyond Suspend.

The tasks can selectively mark themselves to be exempted from specific
freeze events like SUSPEND /KPROBES/CPU_HOTPLUG.

This patch however, *does not* sort non freezable threads into
different categories based on the freeze events. Thus all 
tasks which were previously marked PF_NOFREEZE are now
exempted from freezer using 
	freezer_exempt(FE_ALL);
which means exempt from all kinds of freezes.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

--
 arch/i386/kernel/apm.c              |    2 -
 drivers/block/loop.c                |    2 -
 drivers/char/apm-emulation.c        |    6 ++--
 drivers/ieee1394/ieee1394_core.c    |    2 -
 drivers/md/md.c                     |    2 -
 drivers/mmc/card/queue.c            |    3 +-
 drivers/mtd/mtd_blkdevs.c           |    3 +-
 drivers/scsi/libsas/sas_scsi_host.c |    2 -
 drivers/scsi/scsi_error.c           |    2 -
 drivers/usb/storage/usb.c           |    2 -
 include/linux/freezer.h             |   52 ++++++++++++++++++++++++++++++++----
 include/linux/sched.h               |   15 +++++++++-
 init/do_mounts_initrd.c             |    2 -
 kernel/fork.c                       |    2 -
 kernel/kprobes.c                    |    4 +-
 kernel/power/disk.c                 |    4 +-
 kernel/power/main.c                 |    6 ++--
 kernel/power/process.c              |   29 +++++++++++---------
 kernel/power/user.c                 |    8 ++---
 kernel/rcutorture.c                 |    4 +-
 kernel/sched.c                      |    2 -
 kernel/softirq.c                    |    2 -
 kernel/softlockup.c                 |    2 -
 kernel/workqueue.c                  |    2 -
 24 files changed, 110 insertions(+), 50 deletions(-)

Index: linux-2.6.21-rc5/include/linux/sched.h
===================================================================
--- linux-2.6.21-rc5.orig/include/linux/sched.h
+++ linux-2.6.21-rc5/include/linux/sched.h
@@ -1186,8 +1186,21 @@ static inline void put_task_struct(struc
 #define PF_MEMALLOC	0x00000800	/* Allocating memory */
 #define PF_FLUSHER	0x00001000	/* responsible for disk writeback */
 #define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized before use */
-#define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
+
+/* Per process freezer specific flags */
+#define PF_FE_SUSPEND	0x00008000	/* This thread should not be frozen
+					 * for suspend
+					 */
+
+#define PF_FE_KPROBES	0x00000010	/* This thread should not be frozen
+					 * for Kprobes
+					 */
+
 #define PF_FROZEN	0x00010000	/* frozen for system suspend */
+
+#define PF_FE_ALL	(PF_FE_SUSPEND | PF_FE_KPROBES)
+					/* Exempt from all kinds freeze chills*/
+
 #define PF_FSTRANS	0x00020000	/* inside a filesystem transaction */
 #define PF_KSWAPD	0x00040000	/* I am kswapd */
 #define PF_SWAPOFF	0x00080000	/* I am in swapoff */
Index: linux-2.6.21-rc5/include/linux/freezer.h
===================================================================
--- linux-2.6.21-rc5.orig/include/linux/freezer.h
+++ linux-2.6.21-rc5/include/linux/freezer.h
@@ -2,7 +2,49 @@
 
 #include <linux/sched.h>
 
-#ifdef CONFIG_PM
+#if defined(CONFIG_PM) || defined(CONFIG_HOTPLUG_CPU) || \
+					defined(CONFIG_KPROBES)
+
+/* These are the events which make use of the process freezer */
+#define FE_NONE		0
+#define FE_ALL		PF_FE_ALL
+#define FE_SUSPEND	PF_FE_SUSPEND
+#define FE_KPROBES	PF_FE_KPROBES
+
+/*
+ * Exempt the current process from being frozen for a certain event
+ */
+static inline void freezer_exempt(unsigned long exempt_freeze_event)
+{
+	if (exempt_freeze_event == FE_NONE)
+		current->flags &= ~PF_FE_ALL;
+	else
+		current->flags |= exempt_freeze_event;
+}
+
+/*
+ * Consider the current process to be frozen for a certain event
+ */
+static inline void freezer_consider(unsigned long freeze_event)
+{
+	current->flags &= ~freeze_event;
+}
+
+/*
+ * Check if the process is exempted from freeze for the particular event.
+ */
+static inline int freezer_is_exempted(struct task_struct *p,
+					unsigned long freeze_event)
+{
+	return p->flags & freeze_event;
+}
+
+/* Returns the mask of the events for which this process is freezeable */
+static inline unsigned long freezeable_event_mask(struct task_struct *p)
+{
+	return ~p->flags & PF_FE_ALL;
+}
+
 /*
  * Check if a process has been frozen
  */
@@ -63,8 +105,8 @@ static inline void frozen_process(struct
 }
 
 extern void refrigerator(void);
-extern int freeze_processes(void);
-extern void thaw_processes(void);
+extern int freeze_processes(unsigned long freeze_event);
+extern void thaw_processes(unsigned long freeze_event);
 
 static inline int try_to_freeze(void)
 {
@@ -127,8 +169,8 @@ static inline int thaw_process(struct ta
 static inline void frozen_process(struct task_struct *p) { BUG(); }
 
 static inline void refrigerator(void) {}
-static inline int freeze_processes(void) { BUG(); return 0; }
-static inline void thaw_processes(void) {}
+static inline int freeze_processes(int a) { BUG(); return 1; }
+static inline void thaw_processes(int a) {}
 
 static inline int try_to_freeze(void) { return 0; }
 
Index: linux-2.6.21-rc5/kernel/power/process.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/power/process.c
+++ linux-2.6.21-rc5/kernel/power/process.c
@@ -24,10 +24,10 @@
 #define FREEZER_KERNEL_THREADS 0
 #define FREEZER_USER_SPACE 1
 
-static inline int freezeable(struct task_struct * p)
+static inline int freezeable(struct task_struct * p, unsigned long freeze_event)
 {
 	if ((p == current) ||
-	    (p->flags & PF_NOFREEZE) ||
+	    (freezer_is_exempted(p, freeze_event)) ||
 	    (p->exit_state != 0))
 		return 0;
 	return 1;
@@ -106,7 +106,8 @@ static inline int is_user_space(struct t
 	return ret;
 }
 
-static unsigned int try_to_freeze_tasks(int freeze_user_space)
+static unsigned int try_to_freeze_tasks(int freeze_user_space,
+					unsigned long freeze_event)
 {
 	struct task_struct *g, *p;
 	unsigned long end_time;
@@ -117,7 +118,7 @@ static unsigned int try_to_freeze_tasks(
 		todo = 0;
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (!freezeable(p))
+			if (!freezeable(p, freeze_event))
 				continue;
 
 			if (frozen(p))
@@ -158,7 +159,7 @@ static unsigned int try_to_freeze_tasks(
 				continue;
 
 			task_lock(p);
-			if (freezeable(p) && !frozen(p) &&
+			if (freezeable(p, freeze_event) && !frozen(p) &&
 			    !freezer_should_skip(p))
 				printk(KERN_ERR " %s\n", p->comm);
 
@@ -173,21 +174,23 @@ static unsigned int try_to_freeze_tasks(
 
 /**
  *	freeze_processes - tell processes to enter the refrigerator
+ *	@freeze_event: The system event for which processes are being
+ *			frozen.
  *
  *	Returns 0 on success, or the number of processes that didn't freeze,
  *	although they were told to.
  */
-int freeze_processes(void)
+int freeze_processes(unsigned long freeze_event)
 {
 	unsigned int nr_unfrozen;
 
 	printk("Stopping tasks ... ");
-	nr_unfrozen = try_to_freeze_tasks(FREEZER_USER_SPACE);
+	nr_unfrozen = try_to_freeze_tasks(FREEZER_USER_SPACE, freeze_event);
 	if (nr_unfrozen)
 		return nr_unfrozen;
 
 	sys_sync();
-	nr_unfrozen = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
+	nr_unfrozen = try_to_freeze_tasks(FREEZER_KERNEL_THREADS, freeze_event);
 	if (nr_unfrozen)
 		return nr_unfrozen;
 
@@ -196,13 +199,13 @@ int freeze_processes(void)
 	return 0;
 }
 
-static void thaw_tasks(int thaw_user_space)
+static void thaw_tasks(int thaw_user_space, unsigned long freeze_event)
 {
 	struct task_struct *g, *p;
 
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
-		if (!freezeable(p))
+		if (!freezeable(p, freeze_event))
 			continue;
 
 		if (is_user_space(p) == !thaw_user_space)
@@ -213,11 +216,11 @@ static void thaw_tasks(int thaw_user_spa
 	read_unlock(&tasklist_lock);
 }
 
-void thaw_processes(void)
+void thaw_processes(unsigned long freeze_event)
 {
 	printk("Restarting tasks ... ");
-	thaw_tasks(FREEZER_KERNEL_THREADS);
-	thaw_tasks(FREEZER_USER_SPACE);
+	thaw_tasks(FREEZER_KERNEL_THREADS, freeze_event);
+	thaw_tasks(FREEZER_USER_SPACE, freeze_event);
 	schedule();
 	printk("done.\n");
 }
Index: linux-2.6.21-rc5/kernel/sched.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/sched.c
+++ linux-2.6.21-rc5/kernel/sched.c
@@ -5057,6 +5057,7 @@ static int migration_thread(void *data)
 	BUG_ON(rq->migration_thread != current);
 
 	set_current_state(TASK_INTERRUPTIBLE);
+	freezer_exempt(FE_ALL);
 	while (!kthread_should_stop()) {
 		struct migration_req *req;
 		struct list_head *head;
@@ -5407,7 +5408,6 @@ migration_call(struct notifier_block *nf
 		p = kthread_create(migration_thread, hcpu, "migration/%d",cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
-		p->flags |= PF_NOFREEZE;
 		kthread_bind(p, cpu);
 		/* Must be high prio: stop_machine expects to yield to it. */
 		rq = task_rq_lock(p, &flags);
Index: linux-2.6.21-rc5/kernel/softlockup.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/softlockup.c
+++ linux-2.6.21-rc5/kernel/softlockup.c
@@ -96,7 +96,7 @@ static int watchdog(void * __bind_cpu)
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(FE_ALL);
 
 	/*
 	 * Run briefly once per second to reset the softlockup timestamp.
Index: linux-2.6.21-rc5/kernel/workqueue.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/workqueue.c
+++ linux-2.6.21-rc5/kernel/workqueue.c
@@ -292,7 +292,7 @@ static int worker_thread(void *__cwq)
 	struct k_sigaction sa;
 
 	if (!cwq->wq->freezeable)
-		current->flags |= PF_NOFREEZE;
+		freezer_exempt(FE_ALL);
 
 	/*
 	 * We inherited MPOL_INTERLEAVE from the booting kernel.
Index: linux-2.6.21-rc5/kernel/rcutorture.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/rcutorture.c
+++ linux-2.6.21-rc5/kernel/rcutorture.c
@@ -559,7 +559,7 @@ rcu_torture_fakewriter(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(FE_ALL);
 
 	do {
 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
@@ -590,7 +590,7 @@ rcu_torture_reader(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(FE_ALL);
 
 	do {
 		idx = cur_ops->readlock();
Index: linux-2.6.21-rc5/arch/i386/kernel/apm.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/kernel/apm.c
+++ linux-2.6.21-rc5/arch/i386/kernel/apm.c
@@ -1395,6 +1395,7 @@ static void apm_mainloop(void)
 
 	add_wait_queue(&apm_waitqueue, &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
+	freezer_exempt(FE_ALL);
 	for (;;) {
 		try_to_freeze();
 		schedule_timeout(APM_CHECK_TIMEOUT);
@@ -2315,7 +2316,6 @@ static int __init apm_init(void)
 		remove_proc_entry("apm", NULL);
 		return err;
 	}
-	kapmd_task->flags |= PF_NOFREEZE;
 	wake_up_process(kapmd_task);
 
 	if (num_online_cpus() > 1 && !smp ) {
Index: linux-2.6.21-rc5/drivers/char/apm-emulation.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/char/apm-emulation.c
+++ linux-2.6.21-rc5/drivers/char/apm-emulation.c
@@ -336,7 +336,7 @@ apm_ioctl(struct inode * inode, struct f
 			 * threads.
 			 */
 			flags = current->flags;
-			current->flags |= PF_NOFREEZE;
+			freezer_exempt(FE_ALL);
 
 			wait_event(apm_suspend_waitqueue,
 				   as->suspend_state == SUSPEND_DONE);
@@ -372,7 +372,7 @@ apm_ioctl(struct inode * inode, struct f
 			 * threads.
 			 */
 			flags = current->flags;
-			current->flags |= PF_NOFREEZE;
+			freezer_exempt(FE_ALL);
 
 			wait_event_interruptible(apm_suspend_waitqueue,
 					 as->suspend_state == SUSPEND_DONE);
@@ -536,6 +536,7 @@ static int apm_get_info(char *buf, char 
 
 static int kapmd(void *arg)
 {
+	freezer_exempt(FE_ALL);
 	do {
 		apm_event_t event;
 		int ret;
@@ -601,7 +602,6 @@ static int __init apm_init(void)
 		kapmd_tsk = NULL;
 		return ret;
 	}
-	kapmd_tsk->flags |= PF_NOFREEZE;
 	wake_up_process(kapmd_tsk);
 
 #ifdef CONFIG_PROC_FS
Index: linux-2.6.21-rc5/drivers/block/loop.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/block/loop.c
+++ linux-2.6.21-rc5/drivers/block/loop.c
@@ -587,7 +587,7 @@ static int loop_thread(void *data)
 	 * hence, it mustn't be stopped at all
 	 * because it could be indirectly used during suspension
 	 */
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(FE_ALL);
 
 	set_user_nice(current, -20);
 
Index: linux-2.6.21-rc5/drivers/ieee1394/ieee1394_core.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/ieee1394/ieee1394_core.c
+++ linux-2.6.21-rc5/drivers/ieee1394/ieee1394_core.c
@@ -1134,7 +1134,7 @@ static int hpsbpkt_thread(void *__hi)
 	struct list_head tmp;
 	int may_schedule;
 
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(FE_ALL);
 
 	while (!kthread_should_stop()) {
 
Index: linux-2.6.21-rc5/drivers/md/md.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/md/md.c
+++ linux-2.6.21-rc5/drivers/md/md.c
@@ -4527,7 +4527,7 @@ static int md_thread(void * arg)
 	 * many dirty RAID5 blocks.
 	 */
 
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(FE_ALL);
 	allow_signal(SIGKILL);
 	while (!kthread_should_stop()) {
 
Index: linux-2.6.21-rc5/drivers/mtd/mtd_blkdevs.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/mtd/mtd_blkdevs.c
+++ linux-2.6.21-rc5/drivers/mtd/mtd_blkdevs.c
@@ -82,7 +82,8 @@ static int mtd_blktrans_thread(void *arg
 	struct request_queue *rq = tr->blkcore_priv->rq;
 
 	/* we might get involved when memory gets low, so use PF_MEMALLOC */
-	current->flags |= PF_MEMALLOC | PF_NOFREEZE;
+	current->flags |= PF_MEMALLOC;
+	freezer_exempt(FE_ALL);
 
 	daemonize("%sd", tr->name);
 
Index: linux-2.6.21-rc5/drivers/scsi/libsas/sas_scsi_host.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/scsi/libsas/sas_scsi_host.c
+++ linux-2.6.21-rc5/drivers/scsi/libsas/sas_scsi_host.c
@@ -871,7 +871,7 @@ static int sas_queue_thread(void *_sas_h
 	struct scsi_core *core = &sas_ha->core;
 
 	daemonize("sas_queue_%d", core->shost->host_no);
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(FE_ALL);
 
 	complete(&queue_th_comp);
 
Index: linux-2.6.21-rc5/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/scsi/scsi_error.c
+++ linux-2.6.21-rc5/drivers/scsi/scsi_error.c
@@ -1536,7 +1536,7 @@ int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
 
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(FE_ALL);
 
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
Index: linux-2.6.21-rc5/drivers/usb/storage/usb.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/usb/storage/usb.c
+++ linux-2.6.21-rc5/drivers/usb/storage/usb.c
@@ -301,7 +301,7 @@ static int usb_stor_control_thread(void 
 	struct us_data *us = (struct us_data *)__us;
 	struct Scsi_Host *host = us_to_host(us);
 
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(FE_ALL);
 
 	for(;;) {
 		try_to_freeze();
Index: linux-2.6.21-rc5/init/do_mounts_initrd.c
===================================================================
--- linux-2.6.21-rc5.orig/init/do_mounts_initrd.c
+++ linux-2.6.21-rc5/init/do_mounts_initrd.c
@@ -55,7 +55,7 @@ static void __init handle_initrd(void)
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
 	sys_chroot(".");
 
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(FE_ALL);
 	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
 	if (pid > 0) {
 		while (pid != sys_wait4(-1, NULL, 0, NULL))
Index: linux-2.6.21-rc5/kernel/softirq.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/softirq.c
+++ linux-2.6.21-rc5/kernel/softirq.c
@@ -490,7 +490,7 @@ void __init softirq_init(void)
 static int ksoftirqd(void * __bind_cpu)
 {
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(FE_ALL);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
Index: linux-2.6.21-rc5/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/kprobes.c
+++ linux-2.6.21-rc5/kernel/kprobes.c
@@ -104,7 +104,7 @@ static int __kprobes check_safety(void)
 {
 	int ret = 0;
 #if defined(CONFIG_PREEMPT) && defined(CONFIG_PM)
-	ret = freeze_processes();
+	ret = freeze_processes(FE_KPROBES);
 	if (ret == 0) {
 		struct task_struct *p, *q;
 		do_each_thread(p, q) {
@@ -117,7 +117,7 @@ static int __kprobes check_safety(void)
 		} while_each_thread(p, q);
 	}
 loop_end:
-	thaw_processes();
+	thaw_processes(FE_KPROBES);
 #else
 	synchronize_sched();
 #endif
Index: linux-2.6.21-rc5/kernel/power/disk.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/power/disk.c
+++ linux-2.6.21-rc5/kernel/power/disk.c
@@ -104,7 +104,7 @@ static inline void platform_finish(void)
 
 static void unprepare_processes(void)
 {
-	thaw_processes();
+	thaw_processes(FE_SUSPEND);
 	pm_restore_console();
 }
 
@@ -113,7 +113,7 @@ static int prepare_processes(void)
 	int error = 0;
 
 	pm_prepare_console();
-	if (freeze_processes()) {
+	if (freeze_processes(FE_SUSPEND)) {
 		error = -EBUSY;
 		unprepare_processes();
 	}
Index: linux-2.6.21-rc5/kernel/power/main.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/power/main.c
+++ linux-2.6.21-rc5/kernel/power/main.c
@@ -86,7 +86,7 @@ static int suspend_prepare(suspend_state
 
 	pm_prepare_console();
 
-	if (freeze_processes()) {
+	if (freeze_processes(FE_SUSPEND)) {
 		error = -EAGAIN;
 		goto Thaw;
 	}
@@ -123,7 +123,7 @@ static int suspend_prepare(suspend_state
 	device_resume();
 	resume_console();
  Thaw:
-	thaw_processes();
+	thaw_processes(FE_SUSPEND);
 	pm_restore_console();
 	return error;
 }
@@ -162,7 +162,7 @@ static void suspend_finish(suspend_state
 	pm_finish(state);
 	device_resume();
 	resume_console();
-	thaw_processes();
+	thaw_processes(FE_SUSPEND);
 	pm_restore_console();
 }
 
Index: linux-2.6.21-rc5/kernel/power/user.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/power/user.c
+++ linux-2.6.21-rc5/kernel/power/user.c
@@ -88,7 +88,7 @@ static int snapshot_release(struct inode
 	free_bitmap(data->bitmap);
 	if (data->frozen) {
 		mutex_lock(&pm_mutex);
-		thaw_processes();
+		thaw_processes(FE_SUSPEND);
 		enable_nonboot_cpus();
 		mutex_unlock(&pm_mutex);
 	}
@@ -239,8 +239,8 @@ static int snapshot_ioctl(struct inode *
 		if (data->frozen)
 			break;
 		mutex_lock(&pm_mutex);
-		if (freeze_processes()) {
-			thaw_processes();
+		if (freeze_processes(FE_SUSPEND)) {
+			thaw_processes(FE_SUSPEND);
 			error = -EBUSY;
 		}
 		mutex_unlock(&pm_mutex);
@@ -252,7 +252,7 @@ static int snapshot_ioctl(struct inode *
 		if (!data->frozen)
 			break;
 		mutex_lock(&pm_mutex);
-		thaw_processes();
+		thaw_processes(FE_SUSPEND);
 		mutex_unlock(&pm_mutex);
 		data->frozen = 0;
 		break;
Index: linux-2.6.21-rc5/drivers/mmc/card/queue.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/mmc/card/queue.c
+++ linux-2.6.21-rc5/drivers/mmc/card/queue.c
@@ -66,7 +66,8 @@ static int mmc_queue_thread(void *d)
 	 * Set iothread to ensure that we aren't put to sleep by
 	 * the process freezing.  We handle suspension ourselves.
 	 */
-	current->flags |= PF_MEMALLOC|PF_NOFREEZE;
+	current->flags |= PF_MEMALLOC;
+	freezer_exempt(FE_ALL);
 
 	down(&mq->thread_sem);
 	do {
Index: linux-2.6.21-rc5/kernel/fork.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/fork.c
+++ linux-2.6.21-rc5/kernel/fork.c
@@ -921,7 +921,7 @@ static inline void copy_flags(unsigned l
 {
 	unsigned long new_flags = p->flags;
 
-	new_flags &= ~(PF_SUPERPRIV | PF_NOFREEZE);
+	new_flags &= ~(PF_SUPERPRIV | PF_FE_ALL);
 	new_flags |= PF_FORKNOEXEC;
 	new_flags |= PF_STARTING;
 	p->flags = new_flags;
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
