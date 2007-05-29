Return-Path: <linux-kernel-owner+w=401wt.eu-S1751768AbXE2WTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbXE2WTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbXE2WTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:19:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39627 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbXE2WTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:19:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm 1/3] PM: Hibernation and suspend notifiers
Date: Wed, 30 May 2007 00:24:31 +0200
User-Agent: KMail/1.9.5
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>
References: <Pine.LNX.4.44L0.0705281155270.22682-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0705281155270.22682-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705300024.32455.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 May 2007 17:56, Alan Stern wrote:
> On Sun, 27 May 2007, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Make it possible to register hibernation and suspend notifiers, so that
> > subsystems can perform hibernation-related or suspend-related operations that
> > should not be carried out by device drivers' .suspend() and .resume() routines.
> 
> > +static DEFINE_MUTEX(pm_notifier_lock);
> > +
> > +static RAW_NOTIFIER_HEAD(pm_chain);
> 
> Is there any particular reason you chose to use a RAW_NOTIFIER_HEAD 
> with an explicit mutex instead of using a BLOCKING_NOTIFIER_HEAD?

Yes, this makes the patch simpler.

I have also followed the Pavel's suggestion to limit the nubmer of events.

Please have a look at the updated version of the patch (appended).

Greetings,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Make it possible to register hibernation and suspend notifiers, so that
subsystems can perform hibernation-related or suspend-related operations that
should not be carried out by device drivers' .suspend() and .resume() routines.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

 Documentation/power/notifiers.txt |   57 ++++++++++++++++++++++++++++++++++++++
 include/linux/notifier.h          |    8 +++++
 include/linux/suspend.h           |   37 ++++++++++++++++++++++--
 kernel/power/disk.c               |   24 ++++++++++++----
 kernel/power/main.c               |   14 +++++++++
 kernel/power/power.h              |   10 ++++++
 kernel/power/user.c               |   11 +++++--
 7 files changed, 150 insertions(+), 11 deletions(-)

Index: linux-2.6.22-rc3/include/linux/suspend.h
===================================================================
--- linux-2.6.22-rc3.orig/include/linux/suspend.h	2007-05-27 19:57:21.000000000 +0200
+++ linux-2.6.22-rc3/include/linux/suspend.h	2007-05-29 22:52:24.000000000 +0200
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
--- linux-2.6.22-rc3.orig/kernel/power/power.h	2007-05-27 19:57:21.000000000 +0200
+++ linux-2.6.22-rc3/kernel/power/power.h	2007-05-29 22:53:12.000000000 +0200
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
--- linux-2.6.22-rc3.orig/include/linux/notifier.h	2007-05-27 19:57:21.000000000 +0200
+++ linux-2.6.22-rc3/include/linux/notifier.h	2007-05-29 22:58:13.000000000 +0200
@@ -209,5 +209,13 @@ extern int __srcu_notifier_call_chain(st
 #define CPU_DOWN_FAILED_FROZEN	(CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
 #define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
 
+/* Hibernation and suspend events */
+#define PM_PRE_FREEZE		0x0001 /* Going to freeze tasks */
+#define PM_POST_THAW		0x0002 /* Tasks have just been thawed */
+#define PM_HIBERNATION_PREPARE	0x0003 /* Tasks frozen, going to hibernate */
+#define PM_POST_HIBERNATION	0x0004 /* Hibernation finished, thawing tasks */
+#define PM_SUSPEND_PREPARE	0x0005 /* Going to suspend the system */
+#define PM_POST_SUSPEND		0x0006 /* Suspend finished */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
Index: linux-2.6.22-rc3/kernel/power/disk.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/power/disk.c	2007-05-27 19:57:21.000000000 +0200
+++ linux-2.6.22-rc3/kernel/power/disk.c	2007-05-30 00:26:41.000000000 +0200
@@ -130,10 +130,14 @@ int hibernation_snapshot(int platform_mo
 {
 	int error;
 
+	error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
+	if (error)
+		return error;
+
 	/* Free memory before shutting down devices. */
 	error = swsusp_shrink_memory();
 	if (error)
-		return error;
+		goto Finish;
 
 	suspend_console();
 	error = device_suspend(PMSG_FREEZE);
@@ -161,6 +165,8 @@ int hibernation_snapshot(int platform_mo
 	device_resume();
  Resume_console:
 	resume_console();
+ Finish:
+	pm_notifier_call_chain(PM_POST_HIBERNATION);
 	return error;
 }
 
@@ -259,12 +265,17 @@ static void unprepare_processes(void)
 {
 	thaw_processes();
 	pm_restore_console();
+	pm_notifier_call_chain(PM_POST_THAW);
 }
 
 static int prepare_processes(void)
 {
 	int error = 0;
 
+	error = pm_notifier_call_chain(PM_PRE_FREEZE);
+	if (error)
+		return error;
+
 	pm_prepare_console();
 	if (freeze_processes()) {
 		error = -EBUSY;
@@ -281,9 +292,12 @@ int hibernate(void)
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
 
 	/* Allocate memory management structures */
 	error = create_basic_memory_bitmaps();
@@ -294,7 +308,6 @@ int hibernate(void)
 	if (error)
 		goto Finish;
 
-	mutex_lock(&pm_mutex);
 	if (hibernation_mode == HIBERNATION_TESTPROC) {
 		printk("swsusp debug: Waiting for 5 seconds.\n");
 		mdelay(5000);
@@ -316,12 +329,13 @@ int hibernate(void)
 		swsusp_free();
 	}
  Thaw:
-	mutex_unlock(&pm_mutex);
 	unprepare_processes();
  Finish:
 	free_basic_memory_bitmaps();
  Exit:
 	atomic_inc(&snapshot_device_available);
+ Unlock:
+	mutex_unlock(&pm_mutex);
 	return error;
 }
 
Index: linux-2.6.22-rc3/kernel/power/main.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/power/main.c	2007-05-27 19:57:21.000000000 +0200
+++ linux-2.6.22-rc3/kernel/power/main.c	2007-05-29 22:54:30.000000000 +0200
@@ -24,6 +24,8 @@
 
 #include "power.h"
 
+BLOCKING_NOTIFIER_HEAD(pm_chain_head);
+
 /*This is just an arbitrary number */
 #define FREE_PAGE_NUMBER (100)
 
@@ -82,6 +84,10 @@ static int suspend_prepare(suspend_state
 	if (!pm_ops || !pm_ops->enter)
 		return -EPERM;
 
+	error = pm_notifier_call_chain(PM_PRE_FREEZE);
+	if (error)
+		return error;
+
 	pm_prepare_console();
 
 	if (freeze_processes()) {
@@ -89,6 +95,10 @@ static int suspend_prepare(suspend_state
 		goto Thaw;
 	}
 
+	error = pm_notifier_call_chain(PM_SUSPEND_PREPARE);
+	if (error)
+		return error;
+
 	if ((free_pages = global_page_state(NR_FREE_PAGES))
 			< FREE_PAGE_NUMBER) {
 		pr_debug("PM: free some memory\n");
@@ -121,9 +131,11 @@ static int suspend_prepare(suspend_state
 	device_resume();
  Resume_console:
 	resume_console();
+	pm_notifier_call_chain(PM_POST_SUSPEND);
  Thaw:
 	thaw_processes();
 	pm_restore_console();
+	pm_notifier_call_chain(PM_POST_THAW);
 	return error;
 }
 
@@ -173,8 +185,10 @@ static void suspend_finish(suspend_state
 	pm_finish(state);
 	device_resume();
 	resume_console();
+	pm_notifier_call_chain(PM_POST_SUSPEND);
 	thaw_processes();
 	pm_restore_console();
+	pm_notifier_call_chain(PM_POST_THAW);
 }
 
 
Index: linux-2.6.22-rc3/kernel/power/user.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/power/user.c	2007-05-27 19:57:21.000000000 +0200
+++ linux-2.6.22-rc3/kernel/power/user.c	2007-05-29 22:35:08.000000000 +0200
@@ -149,9 +149,13 @@ static int snapshot_ioctl(struct inode *
 		if (data->frozen)
 			break;
 		mutex_lock(&pm_mutex);
-		if (freeze_processes()) {
-			thaw_processes();
-			error = -EBUSY;
+		error = pm_notifier_call_chain(PM_PRE_FREEZE);
+		if (!error) {
+			error = freeze_processes();
+			if (error) {
+				thaw_processes();
+				pm_notifier_call_chain(PM_POST_THAW);
+			}
 		}
 		mutex_unlock(&pm_mutex);
 		if (!error)
@@ -163,6 +167,7 @@ static int snapshot_ioctl(struct inode *
 			break;
 		mutex_lock(&pm_mutex);
 		thaw_processes();
+		pm_notifier_call_chain(PM_POST_THAW);
 		mutex_unlock(&pm_mutex);
 		data->frozen = 0;
 		break;
Index: linux-2.6.22-rc3/Documentation/power/notifiers.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22-rc3/Documentation/power/notifiers.txt	2007-05-29 23:04:20.000000000 +0200
@@ -0,0 +1,57 @@
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
+PM_PRE_FREEZE		The system is going to hibernate or suspend, tasks will
+			be frozen immediately
+
+PM_POST_THAW		Tasks have just been thawed after a resume or restore
+			from a hibernation image
+
+PM_HIBERNATION_PREPARE	The system is preparing for hibernation.  Tasks have
+			been frozen, memory is going to be freed and devices
+			are going to be suspended.
+
+PM_POST_HIBERNATION	The system memory state has been restored from a
+			hibernation image or an error occured during the
+			hibernation.  Device drivers' .resume() callbacks have
+			been executed, tasks will be thawed immediately.
+
+PM_SUSPEND_PREPARE	The system is preparing for a suspend.  Tasks have been
+			frozen, devices are going to be suspended.
+
+PM_POST_SUSPEND		The system has just resumed or an error occured during
+			the suspend.	Device drivers' .resume() callbacks have
+			been executed, tasks will be thawed immediately.
+
+It is generally assumed that whatever the notifiers do for PM_PRE_FREEZE,
+should be undone for PM_POST_THAW.  Moreover, what is done for
+PM_HIBERNATION_PREPARE, should be undone for PM_POST_HIBERNATION (eg. if memory
+is allocated for PM_HIBERNATION_PREPARE, it should be freed for
+PM_POST_HIBERNATION).  Analogously, operations performed for PM_SUSPEND_PREPARE
+should be reversed for PM_POST_SUSPEND.
+
+The hibernation and suspend notifiers are called with pm_mutex held.  They are
+defined in the usual way, but their last argument is meaningless (it is always
+NULL).  To register and/or unregister a suspend notifier use the functions
+register_pm_notifier() and unregister_pm_notifier(), respectively, defined in
+include/linux/suspend.h .  If you don't need to unregister the notifier, you can
+also use the pm_notifier() macro defined in include/linux/suspend.h .
