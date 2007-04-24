Return-Path: <linux-kernel-owner+w=401wt.eu-S1031070AbXDXLWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031070AbXDXLWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 07:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031071AbXDXLWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 07:22:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37050 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031070AbXDXLWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 07:22:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 3/3] PM: Introduce suspend notifiers (rev. 2)
Date: Tue, 24 Apr 2007 13:26:04 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
References: <200704222010.21999.rjw@sisk.pl> <200704222048.08911.rjw@sisk.pl> <20070424032835.5b102d1a.akpm@linux-foundation.org>
In-Reply-To: <20070424032835.5b102d1a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704241326.05219.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 24 April 2007 12:28, Andrew Morton wrote:
> On Sun, 22 Apr 2007 20:48:08 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Make it possible to register suspend notifiers so that subsystems can perform
> > suspend-related operations that should not be carried out by device drivers'
> > .suspend() and .resume() routines.
> 
> x86_64 allnoconfig:
> 
> arch/x86_64/kernel/e820.c: In function 'e820_mark_nosave_regions':
> arch/x86_64/kernel/e820.c:279: warning: implicit declaration of function 'register_nosave_region'
> arch/x86_64/kernel/built-in.o: In function `e820_mark_nosave_regions':
> : undefined reference to `register_nosave_region'
> arch/x86_64/kernel/built-in.o: In function `e820_mark_nosave_regions':
> : undefined reference to `register_nosave_region'

Ouch, I tried to be too smart.  Fixed.

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Make it possible to register suspend notifiers so that subsystems can perform
suspend-related operations that should not be carried out by device drivers'
.suspend() and .resume() routines.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/suspend-notifiers.txt |   48 ++++++++++++++++++++++++++++
 include/linux/notifier.h                  |    6 +++
 include/linux/suspend.h                   |   19 +++++++++++
 kernel/power/Makefile                     |    2 -
 kernel/power/disk.c                       |   23 ++++++++++++-
 kernel/power/main.c                       |   16 ++++++++-
 kernel/power/notify.c                     |   51 ++++++++++++++++++++++++++++++
 kernel/power/power.h                      |    3 +
 kernel/power/user.c                       |   45 ++++++++++++++++++++------
 9 files changed, 199 insertions(+), 14 deletions(-)

Index: linux-2.6.21-rc6-mm1/kernel/power/notify.c
===================================================================
--- /dev/null
+++ linux-2.6.21-rc6-mm1/kernel/power/notify.c
@@ -0,0 +1,51 @@
+/*
+ * linux/kernel/power/notify.c
+ *
+ * This file contains functions used for registering and calling suspend
+ * notifiers that can be used by subsystems for carrying out some special
+ * suspend-related operations.
+ *
+ * Copyright (C) 2007 Rafael J. Wysocki <rjw@sisk.pl>
+ *
+ * This file is released under the GPLv2.
+ *
+ */
+
+#include <linux/smp.h>
+#include <linux/notifier.h>
+#include <linux/module.h>
+#include <linux/suspend.h>
+
+static DEFINE_MUTEX(suspend_notifier_lock);
+
+static RAW_NOTIFIER_HEAD(suspend_chain);
+
+int register_suspend_notifier(struct notifier_block *nb)
+{
+	int ret;
+	mutex_lock(&suspend_notifier_lock);
+	ret = raw_notifier_chain_register(&suspend_chain, nb);
+	mutex_unlock(&suspend_notifier_lock);
+	return ret;
+}
+EXPORT_SYMBOL(register_suspend_notifier);
+
+void unregister_suspend_notifier(struct notifier_block *nb)
+{
+	mutex_lock(&suspend_notifier_lock);
+	raw_notifier_chain_unregister(&suspend_chain, nb);
+	mutex_unlock(&suspend_notifier_lock);
+}
+EXPORT_SYMBOL(unregister_suspend_notifier);
+
+int suspend_notifier_call_chain(unsigned long val)
+{
+	int error = 0;
+
+	mutex_lock(&suspend_notifier_lock);
+	if (raw_notifier_call_chain(&suspend_chain, val, NULL) == NOTIFY_BAD)
+		error = -EINVAL;
+
+	mutex_unlock(&suspend_notifier_lock);
+	return error;
+}
Index: linux-2.6.21-rc6-mm1/include/linux/suspend.h
===================================================================
--- linux-2.6.21-rc6-mm1.orig/include/linux/suspend.h
+++ linux-2.6.21-rc6-mm1/include/linux/suspend.h
@@ -60,4 +60,23 @@ struct saved_context;
 void __save_processor_state(struct saved_context *ctxt);
 void __restore_processor_state(struct saved_context *ctxt);
 
+#ifdef CONFIG_PM
+int register_suspend_notifier(struct notifier_block *nb);
+void unregister_suspend_notifier(struct notifier_block *nb);
+
+#define suspend_notifier(fn, pri) {				\
+	static struct notifier_block fn##_nb =			\
+		{ .notifier_call = fn, .priority = pri };	\
+	register_suspend_notifier(&fn##_nb);			\
+}
+#else /* CONFIG_PM */
+static inline int register_suspend_notifier(struct notifier_block *nb) {
+	return 0;
+}
+static inline void unregister_suspend_notifier(struct notifier_block *nb) {
+}
+
+#define suspend_notifier(fn, pri)	do { (void)(fn); } while (0)
+#endif /* CONFIG_PM */
+
 #endif /* _LINUX_SWSUSP_H */
Index: linux-2.6.21-rc6-mm1/kernel/power/Makefile
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/power/Makefile
+++ linux-2.6.21-rc6-mm1/kernel/power/Makefile
@@ -3,7 +3,7 @@ ifeq ($(CONFIG_PM_DEBUG),y)
 EXTRA_CFLAGS	+=	-DDEBUG
 endif
 
-obj-y				:= main.o process.o console.o
+obj-y				:= main.o process.o console.o notify.o
 obj-$(CONFIG_PM_LEGACY)		+= pm.o
 obj-$(CONFIG_SOFTWARE_SUSPEND)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
Index: linux-2.6.21-rc6-mm1/kernel/power/power.h
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/power/power.h
+++ linux-2.6.21-rc6-mm1/kernel/power/power.h
@@ -170,3 +170,6 @@ extern int suspend_enter(suspend_state_t
 struct timeval;
 extern void swsusp_show_speed(struct timeval *, struct timeval *,
 				unsigned int, char *);
+
+/* kernel/power/notify.c */
+extern int suspend_notifier_call_chain(unsigned long val);
Index: linux-2.6.21-rc6-mm1/include/linux/notifier.h
===================================================================
--- linux-2.6.21-rc6-mm1.orig/include/linux/notifier.h
+++ linux-2.6.21-rc6-mm1/include/linux/notifier.h
@@ -209,5 +209,11 @@ extern int __srcu_notifier_call_chain(st
 #define CPU_DOWN_FAILED_FROZEN	(CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
 #define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
 
+#define SUSPEND_PREPARE		0x0002 /* Going to freeze tasks */
+#define SUSPEND_ENTER_PREPARE	0x0003 /* Tasks are frozen, we are suspending */
+#define SUSPEND_THAW_PREPARE	0x0004 /* Going to thaw frozen tasks */
+#define SUSPEND_FINISHED	0x0005 /* Tasks have been thawed */
+#define SUSPEND_RESTORE_PREPARE	0x0006 /* STD restore is going to happen */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
Index: linux-2.6.21-rc6-mm1/kernel/power/disk.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/power/disk.c
+++ linux-2.6.21-rc6-mm1/kernel/power/disk.c
@@ -139,10 +139,18 @@ int pm_suspend_disk(void)
 	if (error)
 		goto Exit;
 
+	error = suspend_notifier_call_chain(SUSPEND_PREPARE);
+	if (error)
+		goto Finish;
+
 	error = prepare_processes();
 	if (error)
 		goto Finish;
 
+	error = suspend_notifier_call_chain(SUSPEND_ENTER_PREPARE);
+	if (error)
+		goto Thaw;
+
 	if (pm_disk_mode == PM_DISK_TESTPROC) {
 		printk("swsusp debug: Waiting for 5 seconds.\n");
 		mdelay(5000);
@@ -205,8 +213,10 @@ int pm_suspend_disk(void)
 	device_resume();
 	resume_console();
  Thaw:
+	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 	unprepare_processes();
  Finish:
+	suspend_notifier_call_chain(SUSPEND_FINISHED);
 	free_basic_memory_bitmaps();
  Exit:
 	atomic_inc(&snapshot_device_available);
@@ -267,6 +277,10 @@ static int software_resume(void)
 	if (error)
 		goto Finish;
 
+	error = suspend_notifier_call_chain(SUSPEND_PREPARE);
+	if (error)
+		goto Done;
+
 	pr_debug("PM: Preparing processes for restore.\n");
 	error = prepare_processes();
 	if (error) {
@@ -279,9 +293,13 @@ static int software_resume(void)
 	error = swsusp_read();
 	if (error) {
 		swsusp_free();
-		goto Thaw;
+		goto Unprepare;
 	}
 
+	error = suspend_notifier_call_chain(SUSPEND_RESTORE_PREPARE);
+	if (error)
+		goto Thaw;
+
 	pr_debug("PM: Preparing devices for restore.\n");
 
 	suspend_console();
@@ -299,9 +317,12 @@ static int software_resume(void)
 	device_resume();
 	resume_console();
  Thaw:
+	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
+ Unprepare:
 	printk(KERN_ERR "PM: Restore failed, recovering.\n");
 	unprepare_processes();
  Done:
+	suspend_notifier_call_chain(SUSPEND_FINISHED);
 	free_basic_memory_bitmaps();
  Finish:
 	atomic_inc(&snapshot_device_available);
Index: linux-2.6.21-rc6-mm1/kernel/power/main.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/power/main.c
+++ linux-2.6.21-rc6-mm1/kernel/power/main.c
@@ -86,11 +86,20 @@ static int suspend_prepare(suspend_state
 
 	pm_prepare_console();
 
+	error = suspend_notifier_call_chain(SUSPEND_PREPARE);
+	if (error)
+		goto Finish;
+
 	if (freeze_processes()) {
 		error = -EAGAIN;
-		goto Thaw;
+		thaw_processes();
+		goto Finish;
 	}
 
+	error = suspend_notifier_call_chain(SUSPEND_ENTER_PREPARE);
+	if (error)
+		goto Thaw;
+
 	if ((free_pages = global_page_state(NR_FREE_PAGES))
 			< FREE_PAGE_NUMBER) {
 		pr_debug("PM: free some memory\n");
@@ -123,8 +132,11 @@ static int suspend_prepare(suspend_state
 	device_resume();
 	resume_console();
  Thaw:
+	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 	thaw_processes();
+ Finish:
 	pm_restore_console();
+	suspend_notifier_call_chain(SUSPEND_FINISHED);
 	return error;
 }
 
@@ -162,8 +174,10 @@ static void suspend_finish(suspend_state
 	pm_finish(state);
 	device_resume();
 	resume_console();
+	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 	thaw_processes();
 	pm_restore_console();
+	suspend_notifier_call_chain(SUSPEND_FINISHED);
 }
 
 
Index: linux-2.6.21-rc6-mm1/kernel/power/user.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/power/user.c
+++ linux-2.6.21-rc6-mm1/kernel/power/user.c
@@ -75,6 +75,18 @@ static int snapshot_open(struct inode *i
 	return 0;
 }
 
+static void snapshot_unfreeze(struct snapshot_data *data)
+{
+	if (!data->frozen)
+		return;
+
+	mutex_lock(&pm_mutex);
+	thaw_processes();
+	suspend_notifier_call_chain(SUSPEND_FINISHED);
+	mutex_unlock(&pm_mutex);
+	data->frozen = 0;
+}
+
 static int snapshot_release(struct inode *inode, struct file *filp)
 {
 	struct snapshot_data *data;
@@ -83,11 +95,7 @@ static int snapshot_release(struct inode
 	free_basic_memory_bitmaps();
 	data = filp->private_data;
 	free_all_swap_pages(data->swap);
-	if (data->frozen) {
-		mutex_lock(&pm_mutex);
-		thaw_processes();
-		mutex_unlock(&pm_mutex);
-	}
+	snapshot_unfreeze(data);
 	atomic_inc(&snapshot_device_available);
 	return 0;
 }
@@ -147,6 +155,10 @@ static inline int snapshot_suspend(int p
 	int error;
 
 	mutex_lock(&pm_mutex);
+	error = suspend_notifier_call_chain(SUSPEND_ENTER_PREPARE);
+	if (error)
+		goto Finish;
+
 	/* Free memory before shutting down devices. */
 	error = swsusp_shrink_memory();
 	if (error)
@@ -175,6 +187,7 @@ static inline int snapshot_suspend(int p
 	device_resume();
 	resume_console();
  Finish:
+	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 	mutex_unlock(&pm_mutex);
 	return error;
 }
@@ -185,6 +198,10 @@ static inline int snapshot_restore(int p
 
 	mutex_lock(&pm_mutex);
 	pm_prepare_console();
+	error = suspend_notifier_call_chain(SUSPEND_RESTORE_PREPARE);
+	if (error)
+		goto Finish;
+
 	if (platform_suspend) {
 		error = platform_prepare();
 		if (error)
@@ -207,6 +224,7 @@ static inline int snapshot_restore(int p
 	device_resume();
 	resume_console();
  Finish:
+	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 	pm_restore_console();
 	mutex_unlock(&pm_mutex);
 	return error;
@@ -235,8 +253,13 @@ static int snapshot_ioctl(struct inode *
 		if (data->frozen)
 			break;
 		mutex_lock(&pm_mutex);
+		error = suspend_notifier_call_chain(SUSPEND_PREPARE);
+		if (error)
+			break;
+
 		if (freeze_processes()) {
 			thaw_processes();
+			suspend_notifier_call_chain(SUSPEND_FINISHED);
 			error = -EBUSY;
 		}
 		mutex_unlock(&pm_mutex);
@@ -245,12 +268,7 @@ static int snapshot_ioctl(struct inode *
 		break;
 
 	case SNAPSHOT_UNFREEZE:
-		if (!data->frozen)
-			break;
-		mutex_lock(&pm_mutex);
-		thaw_processes();
-		mutex_unlock(&pm_mutex);
-		data->frozen = 0;
+		snapshot_unfreeze(data);
 		break;
 
 	case SNAPSHOT_ATOMIC_SNAPSHOT:
@@ -349,6 +367,10 @@ static int snapshot_ioctl(struct inode *
 			break;
 		}
 
+		error = suspend_notifier_call_chain(SUSPEND_ENTER_PREPARE);
+		if (error)
+			goto OutS3;
+
 		if (pm_ops->prepare) {
 			error = pm_ops->prepare(PM_SUSPEND_MEM);
 			if (error)
@@ -375,6 +397,7 @@ static int snapshot_ioctl(struct inode *
 			pm_ops->finish(PM_SUSPEND_MEM);
 
  OutS3:
+		suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 		mutex_unlock(&pm_mutex);
 		break;
 
Index: linux-2.6.21-rc6-mm1/Documentation/power/suspend-notifiers.txt
===================================================================
--- /dev/null
+++ linux-2.6.21-rc6-mm1/Documentation/power/suspend-notifiers.txt
@@ -0,0 +1,48 @@
+Suspend notifiers
+	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
+
+There are some operations that device drivers may want to carry out in their
+.suspend() routines, but shouldn't, because they can cause a suspend to fail.
+For example, a driver may want to allocate a substantial amount of memory
+(like 50 MB) in .suspend(), but that shouldn't be done after the swsusp's memory
+shrinker has run.  Also, there may be some operations, that subsystems may want
+to carry out before a suspend or after a resume, requiring the system to be
+fully functional, so the drivers' .suspend() and .resume() routines are not
+suitable for this purpose.
+
+The subsystems that have such needs can register suspend notifiers that will be
+notified of the following events by the suspend core:
+
+SUSPEND_PREPARE		the system is going to suspend, tasks will be frozen
+			immediately
+
+SUSPEND_ENTER_PREPARE	tasks have been frozen, memory is going to be freed
+			and devices are going to be suspended
+
+SUSPEND_THAW_PREPARE	devices have been resumed, tasks will be thawed
+			immediately
+
+SUSPEND_FINISHED	the resume is complete, the system is fully functional
+
+SUSPEND_RESTORE_PREPARE	the system is preparing to restore the swsusp's suspend
+			image, tasks have been frozen and devices are going to
+			be suspended
+
+It is generally assumed that whatever the notifiers do for SUSPEND_PREPARE,
+should be undone for SUSPEND_FINISHED, and what is done for
+SUSPEND_ENTER_PREPARE, should be undone for SUSPEND_FINISHED (eg. if memory is
+allocated for SUSPEND_ENTER_PREPARE, it should be freed for SUSPEND_FINISHED).
+Moreover, if the SUSPEND_PREPARE hooks are called, SUSPEND_FINISHED will be
+called too and if SUSPEND_ENTER_PREPARE are called, SUSPEND_THAW_PREPARE will be
+called either, even if the suspend fails.  This way, for example, the memory
+allocated with SUSPEND_ENTER_PREPARE can always be freed with
+SUSPEND_THAW_PREPARE and need not be leaked in case the suspend fails.
+
+The suspend notifiers are called with pm_mutex held.
+
+The suspend notifiers are defined in the usual way, but their last argument is
+meaningless (it is always NULL).  To register and/or unregister a suspend
+notifier use the functions register_suspend_notifier() and
+unregister_suspend_notifier(), respectively, defined in kernel/power/notify.c .
+If you don't need to unregister the notifier, you can also use the
+suspend_notifier() macro defined in include/linux/suspend.h .
