Return-Path: <linux-kernel-owner+w=401wt.eu-S1762870AbXFBAkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762870AbXFBAkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760104AbXFBAjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:39:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759953AbXFBAja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:39:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH -mm 1/2] PM: Introduce hibernation and suspend notifiers
Date: Sat, 2 Jun 2007 02:43:19 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
References: <200705272229.21263.rjw@sisk.pl> <200706020241.53788.rjw@sisk.pl>
In-Reply-To: <200706020241.53788.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706020243.20117.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make it possible to register hibernation and suspend notifiers, so that
subsystems can perform hibernation-related or suspend-related operations that
should not be carried out by device drivers' .suspend() and .resume() routines.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/notifiers.txt |   50 ++++++++++++++++++++++++++++++++++++++
 include/linux/notifier.h          |    6 ++++
 include/linux/suspend.h           |   37 +++++++++++++++++++++++++---
 kernel/power/disk.c               |   16 +++++++++---
 kernel/power/main.c               |    9 ++++++
 kernel/power/power.h              |   10 +++++++
 kernel/power/user.c               |   11 ++++++--
 7 files changed, 129 insertions(+), 10 deletions(-)

Index: linux-2.6.22-rc3/include/linux/suspend.h
===================================================================
--- linux-2.6.22-rc3.orig/include/linux/suspend.h	2007-05-31 00:00:38.000000000 +0200
+++ linux-2.6.22-rc3/include/linux/suspend.h	2007-06-01 22:55:01.000000000 +0200
@@ -54,7 +54,8 @@ struct hibernation_ops {
 	void (*restore_cleanup)(void);
 };
 
-#if defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND)
+#ifdef CONFIG_PM
+#ifdef CONFIG_SOFTWARE_SUSPEND
 /* kernel/power/snapshot.c */
 extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
 static inline void register_nosave_region(unsigned long b, unsigned long e)
@@ -72,7 +73,7 @@ extern unsigned long get_safe_page(gfp_t
 
 extern void hibernation_set_ops(struct hibernation_ops *ops);
 extern int hibernate(void);
-#else
+#else /* CONFIG_SOFTWARE_SUSPEND */
 static inline void register_nosave_region(unsigned long b, unsigned long e) {}
 static inline void register_nosave_region_late(unsigned long b, unsigned long e) {}
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
@@ -81,7 +82,7 @@ static inline void swsusp_unset_page_fre
 
 static inline void hibernation_set_ops(struct hibernation_ops *ops) {}
 static inline int hibernate(void) { return -ENOSYS; }
-#endif /* defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND) */
+#endif /* CONFIG_SOFTWARE_SUSPEND */
 
 void save_processor_state(void);
 void restore_processor_state(void);
@@ -89,4 +90,34 @@ struct saved_context;
 void __save_processor_state(struct saved_context *ctxt);
 void __restore_processor_state(struct saved_context *ctxt);
 
+/* kernel/power/main.c */
+extern struct blocking_notifier_head pm_chain_head;
+
+static inline int register_pm_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&pm_chain_head, nb);
+}
+
+static inline int unregister_pm_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&pm_chain_head, nb);
+}
+
+#define pm_notifier(fn, pri) {				\
+	static struct notifier_block fn##_nb =			\
+		{ .notifier_call = fn, .priority = pri };	\
+	register_pm_notifier(&fn##_nb);			\
+}
+#else /* CONFIG_PM */
+static inline int register_pm_notifier(struct notifier_block *nb) {
+	return 0;
+}
+
+static inline int unregister_pm_notifier(struct notifier_block *nb) {
+	return 0;
+}
+
+#define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
+#endif /* CONFIG_PM */
+
 #endif /* _LINUX_SWSUSP_H */
Index: linux-2.6.22-rc3/kernel/power/power.h
===================================================================
--- linux-2.6.22-rc3.orig/kernel/power/power.h	2007-05-31 00:00:38.000000000 +0200
+++ linux-2.6.22-rc3/kernel/power/power.h	2007-06-01 22:55:01.000000000 +0200
@@ -173,5 +173,15 @@ extern void swsusp_close(void);
 extern int suspend_enter(suspend_state_t state);
 
 struct timeval;
+/* kernel/power/swsusp.c */
 extern void swsusp_show_speed(struct timeval *, struct timeval *,
 				unsigned int, char *);
+
+/* kernel/power/main.c */
+extern struct blocking_notifier_head pm_chain_head;
+
+static inline int pm_notifier_call_chain(unsigned long val)
+{
+	return (blocking_notifier_call_chain(&pm_chain_head, val, NULL)
+			== NOTIFY_BAD) ? -EINVAL : 0;
+}
Index: linux-2.6.22-rc3/include/linux/notifier.h
===================================================================
--- linux-2.6.22-rc3.orig/include/linux/notifier.h	2007-05-31 00:00:38.000000000 +0200
+++ linux-2.6.22-rc3/include/linux/notifier.h	2007-06-01 23:01:38.000000000 +0200
@@ -209,5 +209,11 @@ extern int __srcu_notifier_call_chain(st
 #define CPU_DOWN_FAILED_FROZEN	(CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
 #define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
 
+/* Hibernation and suspend events */
+#define PM_HIBERNATION_PREPARE	0x0001 /* Going to hibernate */
+#define PM_POST_HIBERNATION	0x0002 /* Hibernation finished */
+#define PM_SUSPEND_PREPARE	0x0003 /* Going to suspend the system */
+#define PM_POST_SUSPEND		0x0004 /* Suspend finished */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
Index: linux-2.6.22-rc3/kernel/power/disk.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/power/disk.c	2007-05-31 00:00:38.000000000 +0200
+++ linux-2.6.22-rc3/kernel/power/disk.c	2007-06-01 23:05:11.000000000 +0200
@@ -281,9 +281,16 @@ int hibernate(void)
 {
 	int error;
 
+	mutex_lock(&pm_mutex);
 	/* The snapshot device should not be opened while we're running */
-	if (!atomic_add_unless(&snapshot_device_available, -1, 0))
-		return -EBUSY;
+	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
+		error = -EBUSY;
+		goto Unlock;
+	}
+
+	error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
+	if (error)
+		goto Exit;
 
 	/* Allocate memory management structures */
 	error = create_basic_memory_bitmaps();
@@ -294,7 +301,6 @@ int hibernate(void)
 	if (error)
 		goto Finish;
 
-	mutex_lock(&pm_mutex);
 	if (hibernation_mode == HIBERNATION_TESTPROC) {
 		printk("swsusp debug: Waiting for 5 seconds.\n");
 		mdelay(5000);
@@ -316,12 +322,14 @@ int hibernate(void)
 		swsusp_free();
 	}
  Thaw:
-	mutex_unlock(&pm_mutex);
 	unprepare_processes();
  Finish:
 	free_basic_memory_bitmaps();
  Exit:
+	pm_notifier_call_chain(PM_POST_HIBERNATION);
 	atomic_inc(&snapshot_device_available);
+ Unlock:
+	mutex_unlock(&pm_mutex);
 	return error;
 }
 
Index: linux-2.6.22-rc3/kernel/power/main.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/power/main.c	2007-05-31 00:00:38.000000000 +0200
+++ linux-2.6.22-rc3/kernel/power/main.c	2007-06-01 23:08:43.000000000 +0200
@@ -24,6 +24,8 @@
 
 #include "power.h"
 
+BLOCKING_NOTIFIER_HEAD(pm_chain_head);
+
 /*This is just an arbitrary number */
 #define FREE_PAGE_NUMBER (100)
 
@@ -82,6 +84,10 @@ static int suspend_prepare(suspend_state
 	if (!pm_ops || !pm_ops->enter)
 		return -EPERM;
 
+	error = pm_notifier_call_chain(PM_SUSPEND_PREPARE);
+	if (error)
+		goto Finish;
+
 	pm_prepare_console();
 
 	if (freeze_processes()) {
@@ -124,6 +130,8 @@ static int suspend_prepare(suspend_state
  Thaw:
 	thaw_processes();
 	pm_restore_console();
+ Finish:
+	pm_notifier_call_chain(PM_POST_SUSPEND);
 	return error;
 }
 
@@ -175,6 +183,7 @@ static void suspend_finish(suspend_state
 	resume_console();
 	thaw_processes();
 	pm_restore_console();
+	pm_notifier_call_chain(PM_POST_SUSPEND);
 }
 
 
Index: linux-2.6.22-rc3/kernel/power/user.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/power/user.c	2007-05-31 00:00:38.000000000 +0200
+++ linux-2.6.22-rc3/kernel/power/user.c	2007-06-01 23:15:58.000000000 +0200
@@ -149,10 +149,14 @@ static int snapshot_ioctl(struct inode *
 		if (data->frozen)
 			break;
 		mutex_lock(&pm_mutex);
-		if (freeze_processes()) {
-			thaw_processes();
-			error = -EBUSY;
+		error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
+		if (!error) {
+			error = freeze_processes();
+			if (error)
+				thaw_processes();
 		}
+		if (error)
+			pm_notifier_call_chain(PM_POST_HIBERNATION);
 		mutex_unlock(&pm_mutex);
 		if (!error)
 			data->frozen = 1;
@@ -163,6 +167,7 @@ static int snapshot_ioctl(struct inode *
 			break;
 		mutex_lock(&pm_mutex);
 		thaw_processes();
+		pm_notifier_call_chain(PM_POST_HIBERNATION);
 		mutex_unlock(&pm_mutex);
 		data->frozen = 0;
 		break;
Index: linux-2.6.22-rc3/Documentation/power/notifiers.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22-rc3/Documentation/power/notifiers.txt	2007-06-01 23:14:59.000000000 +0200
@@ -0,0 +1,50 @@
+Suspend notifiers
+	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
+
+There are some operations that device drivers may want to carry out in their
+.suspend() routines, but shouldn't, because they can cause the hibernation or
+suspend to fail. For example, a driver may want to allocate a substantial amount
+of memory (like 50 MB) in .suspend(), but that shouldn't be done after the
+swsusp's memory shrinker has run.
+
+Also, there may be some operations, that subsystems want to carry out before a
+hibernation/suspend or after a restore/resume, requiring the system to be fully
+functional, so the drivers' .suspend() and .resume() routines are not suitable
+for this purpose.  For example, device drivers may want to upload firmware to
+their devices after a restore from a hibernation image, but they cannot do it by
+calling request_firmware() from their .resume() routines (user land processes
+are frozen at this point).  The solution may be to load the firmware into
+memory before processes are frozen and upload it from there in the .resume()
+routine.  Of course, a hibernation notifier may be used for this purpose.
+
+The subsystems that have such needs can register suspend notifiers that will be
+called upon the following events by the suspend core:
+
+PM_HIBERNATION_PREPARE	The system is going to hibernate or suspend, tasks will
+			be frozen immediately.
+
+PM_POST_HIBERNATION	The system memory state has been restored from a
+			hibernation image or an error occured during the
+			hibernation.  Device drivers' .resume() callbacks have
+			been executed and tasks have been thawed.
+
+PM_SUSPEND_PREPARE	The system is preparing for a suspend.
+
+PM_POST_SUSPEND		The system has just resumed or an error occured during
+			the suspend.	Device drivers' .resume() callbacks have
+			been executed and tasks have been thawed.
+
+It is generally assumed that whatever the notifiers do for
+PM_HIBERNATION_PREPARE, should be undone for PM_POST_HIBERNATION.  Analogously,
+operations performed for PM_SUSPEND_PREPARE should be reversed for
+PM_POST_SUSPEND.  Additionally, all of the notifiers are called for
+PM_POST_HIBERNATION if one of them fails for PM_HIBERNATION_PREPARE, and
+all of the notifiers are called for PM_POST_SUSPEND if one of them fails for
+PM_SUSPEND_PREPARE.
+
+The hibernation and suspend notifiers are called with pm_mutex held.  They are
+defined in the usual way, but their last argument is meaningless (it is always
+NULL).  To register and/or unregister a suspend notifier use the functions
+register_pm_notifier() and unregister_pm_notifier(), respectively, defined in
+include/linux/suspend.h .  If you don't need to unregister the notifier, you can
+also use the pm_notifier() macro defined in include/linux/suspend.h .

