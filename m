Return-Path: <linux-kernel-owner+w=401wt.eu-S1751682AbXDNWtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbXDNWtz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 18:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXDNWtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 18:49:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52130 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbXDNWty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 18:49:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [RFD] swsusp problem: Drivers allocate much memory during suspend (was: Re: 2.6.21-rc5: swsusp: Not enough free memory)
Date: Sun, 15 Apr 2007 00:53:16 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       linux-pm@lists.osdl.org, Jiri Slaby <jirislaby@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <460B6E4B.3060004@gmail.com> <20070413221016.GQ28264@elf.ucw.cz> <200704140035.36355.rjw@sisk.pl>
In-Reply-To: <200704140035.36355.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704150053.17182.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, 14 April 2007 00:35, Rafael J. Wysocki wrote:
> On Saturday, 14 April 2007 00:10, Pavel Machek wrote:
[--snip--] 
> > > IMO to really fix the problem, we should let the drivers that need much memory
> > > for suspending allocate it _before_ the memory shrinker is called.  For this
> > > purpose we can use notifiers that will be called before we start the shrinking
> > > of memory.  Namely, if a driver needs to allocate substantial amount
> > > of memory
> > 
> > Yes please. Using that notifier without leaking the memory will be
> > "interesting" but if someone needs so much memory during suspend, let
> > them eat their own complexity.
> 
> Okay, I'm going to prepare a patch along these lines.

The appended patch shows how I think this might look like.

There are a couple of things I'm not sure about in it:
1) Names (if you have better ideas, please tell me)
2) I don't know if SUSPEND_THAW_PREPARE is necessary, at least for now I don't
see any obvious case in which it may be useful, but I've added it for symmetry
3) Perhaps we can use the second argument of raw_notifier_call_chain() to pass
the information of what kind of suspend is going to happen (eg. STD vs STR), in
which case we'll need a second argument for suspend_notifier_call_chain()

Greetings,
Rafael

---
 include/linux/notifier.h |    6 +++++
 include/linux/suspend.h  |   27 ++++++++++++++++++++++---
 kernel/power/Makefile    |    2 -
 kernel/power/disk.c      |   21 ++++++++++++++++++++
 kernel/power/main.c      |   13 ++++++++++++
 kernel/power/notify.c    |   49 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/power.h     |    3 ++
 kernel/power/user.c      |   19 ++++++++++++++++++
 8 files changed, 135 insertions(+), 5 deletions(-)

Index: linux-2.6.21-rc6/kernel/power/notify.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-rc6/kernel/power/notify.c	2007-04-14 23:35:35.000000000 +0200
@@ -0,0 +1,49 @@
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
+	int error;
+
+	mutex_lock(&suspend_notifier_lock);
+	error = raw_notifier_call_chain(&suspend_chain, val, NULL);
+	mutex_unlock(&suspend_notifier_lock);
+	return error;
+}
Index: linux-2.6.21-rc6/include/linux/suspend.h
===================================================================
--- linux-2.6.21-rc6.orig/include/linux/suspend.h	2007-04-14 22:04:58.000000000 +0200
+++ linux-2.6.21-rc6/include/linux/suspend.h	2007-04-14 23:32:18.000000000 +0200
@@ -24,15 +24,16 @@ struct pbe {
 extern void drain_local_pages(void);
 extern void mark_free_pages(struct zone *zone);
 
-#if defined(CONFIG_PM) && defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
+#ifdef CONFIG_PM
+#if defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
 extern int pm_prepare_console(void);
 extern void pm_restore_console(void);
 #else
 static inline int pm_prepare_console(void) { return 0; }
 static inline void pm_restore_console(void) {}
-#endif
+#endif /* defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE) */
 
-#if defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND)
+#ifdef CONFIG_SOFTWARE_SUSPEND
 /* kernel/power/swsusp.c */
 extern int software_suspend(void);
 /* kernel/power/snapshot.c */
@@ -52,7 +53,7 @@ static inline void register_nosave_regio
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
-#endif /* defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND) */
+#endif /* CONFIG_SOFTWARE_SUSPEND */
 
 void save_processor_state(void);
 void restore_processor_state(void);
@@ -60,4 +61,22 @@ struct saved_context;
 void __save_processor_state(struct saved_context *ctxt);
 void __restore_processor_state(struct saved_context *ctxt);
 
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
+#endif
+
 #endif /* _LINUX_SWSUSP_H */
Index: linux-2.6.21-rc6/kernel/power/Makefile
===================================================================
--- linux-2.6.21-rc6.orig/kernel/power/Makefile	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc6/kernel/power/Makefile	2007-04-14 23:34:30.000000000 +0200
@@ -3,7 +3,7 @@ ifeq ($(CONFIG_PM_DEBUG),y)
 EXTRA_CFLAGS	+=	-DDEBUG
 endif
 
-obj-y				:= main.o process.o console.o
+obj-y				:= main.o process.o console.o notify.o
 obj-$(CONFIG_PM_LEGACY)		+= pm.o
 obj-$(CONFIG_SOFTWARE_SUSPEND)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
Index: linux-2.6.21-rc6/kernel/power/power.h
===================================================================
--- linux-2.6.21-rc6.orig/kernel/power/power.h	2007-04-14 23:38:11.000000000 +0200
+++ linux-2.6.21-rc6/kernel/power/power.h	2007-04-14 23:40:07.000000000 +0200
@@ -171,3 +171,6 @@ extern int suspend_enter(suspend_state_t
 struct timeval;
 extern void swsusp_show_speed(struct timeval *, struct timeval *,
 				unsigned int, char *);
+
+/* kernel/power/notify.c */
+extern int suspend_notifier_call_chain(unsigned long val);
Index: linux-2.6.21-rc6/include/linux/notifier.h
===================================================================
--- linux-2.6.21-rc6.orig/include/linux/notifier.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc6/include/linux/notifier.h	2007-04-15 00:31:04.000000000 +0200
@@ -187,5 +187,11 @@ extern int srcu_notifier_call_chain(stru
 #define CPU_DOWN_FAILED		0x0006 /* CPU (unsigned)v NOT going down */
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
 
+#define SUSPEND_PREPARE		0x0002 /* Going to freeze tasks */
+#define SUSPEND_ENTER_PREPARE	0x0003 /* Tasks are frozen, we are suspending */
+#define SUSPEND_THAW_PREPARE	0x0004 /* Going to thaw frozen tasks */
+#define SUSPEND_FINISHED	0x0005 /* Tasks have been thawed */
+#define SUSPEND_RESTORE_PREPARE	0x0006 /* STD restore is going to happen */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
Index: linux-2.6.21-rc6/kernel/power/disk.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/power/disk.c	2007-04-14 21:49:23.000000000 +0200
+++ linux-2.6.21-rc6/kernel/power/disk.c	2007-04-15 00:31:44.000000000 +0200
@@ -100,6 +100,7 @@ static int prepare_processes(void)
 	pm_prepare_console();
 	if (freeze_processes()) {
 		error = -EBUSY;
+		suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 		unprepare_processes();
 	}
 	return error;
@@ -127,6 +128,10 @@ int pm_suspend_disk(void)
 	if (error)
 		goto Exit;
 
+	error = suspend_notifier_call_chain(SUSPEND_PREPARE);
+	if (error)
+		goto Finish;
+
 	error = prepare_processes();
 	if (error)
 		goto Finish;
@@ -137,6 +142,10 @@ int pm_suspend_disk(void)
 		goto Thaw;
 	}
 
+	error = suspend_notifier_call_chain(SUSPEND_ENTER_PREPARE);
+	if (error)
+		goto Thaw;
+
 	/* Free memory before shutting down devices. */
 	error = swsusp_shrink_memory();
 	if (error)
@@ -193,8 +202,10 @@ int pm_suspend_disk(void)
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
@@ -255,6 +266,10 @@ static int software_resume(void)
 	if (error)
 		goto Finish;
 
+	error = suspend_notifier_call_chain(SUSPEND_PREPARE);
+	if (error)
+		goto Done;
+
 	pr_debug("PM: Preparing processes for restore.\n");
 	error = prepare_processes();
 	if (error) {
@@ -271,6 +286,10 @@ static int software_resume(void)
 		goto Thaw;
 	}
 
+	error = suspend_notifier_call_chain(SUSPEND_RESTORE_PREPARE);
+	if (error)
+		goto Thaw;
+
 	pr_debug("PM: Preparing devices for restore.\n");
 
 	suspend_console();
@@ -289,8 +308,10 @@ static int software_resume(void)
 	resume_console();
  Thaw:
 	printk(KERN_ERR "PM: Restore failed, recovering.\n");
+	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 	unprepare_processes();
  Done:
+	suspend_notifier_call_chain(SUSPEND_FINISHED);
 	free_basic_memory_bitmaps();
  Finish:
 	atomic_inc(&snapshot_device_available);
Index: linux-2.6.21-rc6/kernel/power/main.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/power/main.c	2007-04-07 12:15:28.000000000 +0200
+++ linux-2.6.21-rc6/kernel/power/main.c	2007-04-15 00:27:52.000000000 +0200
@@ -69,11 +69,19 @@ static int suspend_prepare(suspend_state
 
 	pm_prepare_console();
 
+	error = suspend_notifier_call_chain(SUSPEND_PREPARE);
+	if (error)
+		goto Finish;
+
 	if (freeze_processes()) {
 		error = -EAGAIN;
 		goto Thaw;
 	}
 
+	error = suspend_notifier_call_chain(SUSPEND_ENTER_PREPARE);
+	if (error)
+		goto Thaw;
+
 	if ((free_pages = global_page_state(NR_FREE_PAGES))
 			< FREE_PAGE_NUMBER) {
 		pr_debug("PM: free some memory\n");
@@ -106,8 +114,11 @@ static int suspend_prepare(suspend_state
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
 
@@ -145,8 +156,10 @@ static void suspend_finish(suspend_state
 	pm_finish(state);
 	device_resume();
 	resume_console();
+	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 	thaw_processes();
 	pm_restore_console();
+	suspend_notifier_call_chain(SUSPEND_FINISHED);
 }
 
 
Index: linux-2.6.21-rc6/kernel/power/user.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/power/user.c	2007-04-14 21:49:23.000000000 +0200
+++ linux-2.6.21-rc6/kernel/power/user.c	2007-04-15 00:38:23.000000000 +0200
@@ -148,6 +148,10 @@ static inline int snapshot_suspend(int p
 	int error;
 
 	mutex_lock(&pm_mutex);
+	error = suspend_notifier_call_chain(SUSPEND_ENTER_PREPARE);
+	if (error)
+		goto Finish;
+
 	/* Free memory before shutting down devices. */
 	error = swsusp_shrink_memory();
 	if (error)
@@ -186,6 +190,10 @@ static inline int snapshot_restore(int p
 
 	mutex_lock(&pm_mutex);
 	pm_prepare_console();
+	error = suspend_notifier_call_chain(SUSPEND_RESTORE_PREPARE);
+	if (error)
+		goto Finish;
+
 	if (platform_suspend) {
 		error = platform_prepare();
 		if (error)
@@ -236,7 +244,12 @@ static int snapshot_ioctl(struct inode *
 		if (data->frozen)
 			break;
 		mutex_lock(&pm_mutex);
+		error = suspend_notifier_call_chain(SUSPEND_PREPARE);
+		if (error)
+			break;
+
 		if (freeze_processes()) {
+			suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 			thaw_processes();
 			error = -EBUSY;
 		}
@@ -249,7 +262,9 @@ static int snapshot_ioctl(struct inode *
 		if (!data->frozen)
 			break;
 		mutex_lock(&pm_mutex);
+		suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 		thaw_processes();
+		suspend_notifier_call_chain(SUSPEND_FINISHED);
 		mutex_unlock(&pm_mutex);
 		data->frozen = 0;
 		break;
@@ -350,6 +365,10 @@ static int snapshot_ioctl(struct inode *
 			break;
 		}
 
+		error = suspend_notifier_call_chain(SUSPEND_ENTER_PREPARE);
+		if (error)
+			break;
+
 		if (pm_ops->prepare) {
 			error = pm_ops->prepare(PM_SUSPEND_MEM);
 			if (error)
