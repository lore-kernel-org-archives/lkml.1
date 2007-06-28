Return-Path: <linux-kernel-owner+w=401wt.eu-S932196AbXF1WQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbXF1WQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764912AbXF1WQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:16:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56816 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764592AbXF1WQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:16:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] PM: Reduce code duplication between main.c and user.c (updated)
Date: Fri, 29 Jun 2007 00:23:23 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706290023.24489.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Update is needed because of pm-introduce-set_target-method-in-pm_ops.patch]
---
From: Rafael J. Wysocki <rjw@sisk.pl>

The SNAPSHOT_S2RAM ioctl code is outdated and it should not duplicate the
suspend code in kernel/power/main.c.  Fix that.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/main.c  |   99 ++++++++++++++++++++++++++++-----------------------
 kernel/power/power.h |    3 +
 kernel/power/user.c  |   38 ++-----------------
 3 files changed, 62 insertions(+), 78 deletions(-)

Index: linux-2.6.22-rc6/kernel/power/main.c
===================================================================
--- linux-2.6.22-rc6.orig/kernel/power/main.c	2007-06-28 23:22:34.000000000 +0200
+++ linux-2.6.22-rc6/kernel/power/main.c	2007-06-28 23:25:24.000000000 +0200
@@ -68,14 +68,11 @@ static inline void pm_finish(suspend_sta
 
 /**
  *	suspend_prepare - Do prep work before entering low-power state.
- *	@state:		State we're entering.
  *
- *	This is common code that is called for each state that we're 
- *	entering. Allocate a console, stop all processes, then make sure
- *	the platform can enter the requested state.
+ *	This is common code that is called for each state that we're entering.
+ *	Run suspend notifiers, allocate a console and stop all processes.
  */
-
-static int suspend_prepare(suspend_state_t state)
+static int suspend_prepare(void)
 {
 	int error;
 	unsigned int free_pages;
@@ -94,43 +91,18 @@ static int suspend_prepare(suspend_state
 		goto Thaw;
 	}
 
-	if ((free_pages = global_page_state(NR_FREE_PAGES))
-			< FREE_PAGE_NUMBER) {
+	free_pages = global_page_state(NR_FREE_PAGES);
+	if (free_pages < FREE_PAGE_NUMBER) {
 		pr_debug("PM: free some memory\n");
 		shrink_all_memory(FREE_PAGE_NUMBER - free_pages);
 		if (nr_free_pages() < FREE_PAGE_NUMBER) {
 			error = -ENOMEM;
 			printk(KERN_ERR "PM: No enough memory\n");
-			goto Thaw;
 		}
 	}
-
-	if (pm_ops->set_target) {
-		error = pm_ops->set_target(state);
-		if (error)
-			goto Thaw;
-	}
-	suspend_console();
-	error = device_suspend(PMSG_SUSPEND);
-	if (error) {
-		printk(KERN_ERR "Some devices failed to suspend\n");
-		goto Resume_console;
-	}
-	if (pm_ops->prepare) {
-		if ((error = pm_ops->prepare(state)))
-			goto Resume_devices;
-	}
-
-	error = disable_nonboot_cpus();
 	if (!error)
 		return 0;
 
-	enable_nonboot_cpus();
-	pm_finish(state);
- Resume_devices:
-	device_resume();
- Resume_console:
-	resume_console();
  Thaw:
 	thaw_processes();
 	pm_restore_console();
@@ -151,6 +123,12 @@ void __attribute__ ((weak)) arch_suspend
 	local_irq_enable();
 }
 
+/**
+ *	suspend_enter - enter the desired system sleep state.
+ *	@state:		state to enter
+ *
+ *	This function should be called after devices have been suspended.
+ */
 int suspend_enter(suspend_state_t state)
 {
 	int error = 0;
@@ -170,21 +148,55 @@ int suspend_enter(suspend_state_t state)
 	return error;
 }
 
+/**
+ *	suspend_devices_and_enter - suspend devices and enter the desired system sleep
+ *			  state.
+ *	@state:		  state to enter
+ */
+int suspend_devices_and_enter(suspend_state_t state)
+{
+	int error;
+
+	if (!pm_ops)
+		return -ENOSYS;
+
+	if (pm_ops->set_target) {
+		error = pm_ops->set_target(state);
+		if (error)
+			return error;
+	}
+	suspend_console();
+	error = device_suspend(PMSG_SUSPEND);
+	if (error) {
+		printk(KERN_ERR "Some devices failed to suspend\n");
+		goto Resume_console;
+	}
+	if (pm_ops->prepare) {
+		error = pm_ops->prepare(state);
+		if (error)
+			goto Resume_devices;
+	}
+	error = disable_nonboot_cpus();
+	if (!error)
+		suspend_enter(state);
+
+	enable_nonboot_cpus();
+	pm_finish(state);
+ Resume_devices:
+	device_resume();
+ Resume_console:
+	resume_console();
+	return error;
+}
 
 /**
  *	suspend_finish - Do final work before exiting suspend sequence.
- *	@state:		State we're coming out of.
  *
  *	Call platform code to clean up, restart processes, and free the 
  *	console that we've allocated. This is not called for suspend-to-disk.
  */
-
-static void suspend_finish(suspend_state_t state)
+static void suspend_finish(void)
 {
-	enable_nonboot_cpus();
-	pm_finish(state);
-	device_resume();
-	resume_console();
 	thaw_processes();
 	pm_restore_console();
 	pm_notifier_call_chain(PM_POST_SUSPEND);
@@ -219,7 +231,6 @@ static inline int valid_state(suspend_st
  *	Then, do the setup for suspend, enter the state, and cleaup (after
  *	we've woken up).
  */
-
 static int enter_state(suspend_state_t state)
 {
 	int error;
@@ -230,14 +241,14 @@ static int enter_state(suspend_state_t s
 		return -EBUSY;
 
 	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
-	if ((error = suspend_prepare(state)))
+	if ((error = suspend_prepare()))
 		goto Unlock;
 
 	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
-	error = suspend_enter(state);
+	error = suspend_devices_and_enter(state);
 
 	pr_debug("PM: Finishing wakeup.\n");
-	suspend_finish(state);
+	suspend_finish();
  Unlock:
 	mutex_unlock(&pm_mutex);
 	return error;
Index: linux-2.6.22-rc6/kernel/power/power.h
===================================================================
--- linux-2.6.22-rc6.orig/kernel/power/power.h	2007-06-28 23:22:34.000000000 +0200
+++ linux-2.6.22-rc6/kernel/power/power.h	2007-06-28 23:25:24.000000000 +0200
@@ -170,7 +170,6 @@ extern int swsusp_resume(void);
 extern int swsusp_read(unsigned int *flags_p);
 extern int swsusp_write(unsigned int flags);
 extern void swsusp_close(void);
-extern int suspend_enter(suspend_state_t state);
 
 struct timeval;
 /* kernel/power/swsusp.c */
@@ -178,6 +177,8 @@ extern void swsusp_show_speed(struct tim
 				unsigned int, char *);
 
 /* kernel/power/main.c */
+extern int suspend_enter(suspend_state_t state);
+extern int suspend_devices_and_enter(suspend_state_t state);
 extern struct blocking_notifier_head pm_chain_head;
 
 static inline int pm_notifier_call_chain(unsigned long val)
Index: linux-2.6.22-rc6/kernel/power/user.c
===================================================================
--- linux-2.6.22-rc6.orig/kernel/power/user.c	2007-06-28 23:22:34.000000000 +0200
+++ linux-2.6.22-rc6/kernel/power/user.c	2007-06-28 23:25:24.000000000 +0200
@@ -255,47 +255,19 @@ static int snapshot_ioctl(struct inode *
 		break;
 
 	case SNAPSHOT_S2RAM:
-		if (!pm_ops) {
-			error = -ENOSYS;
-			break;
-		}
-
 		if (!data->frozen) {
 			error = -EPERM;
 			break;
 		}
-
 		if (!mutex_trylock(&pm_mutex)) {
 			error = -EBUSY;
 			break;
 		}
-
-		if (pm_ops->prepare) {
-			error = pm_ops->prepare(PM_SUSPEND_MEM);
-			if (error)
-				goto OutS3;
-		}
-
-		/* Put devices to sleep */
-		suspend_console();
-		error = device_suspend(PMSG_SUSPEND);
-		if (error) {
-			printk(KERN_ERR "Failed to suspend some devices.\n");
-		} else {
-			error = disable_nonboot_cpus();
-			if (!error) {
-				/* Enter S3, system is already frozen */
-				suspend_enter(PM_SUSPEND_MEM);
-				enable_nonboot_cpus();
-			}
-			/* Wake up devices */
-			device_resume();
-		}
-		resume_console();
-		if (pm_ops->finish)
-			pm_ops->finish(PM_SUSPEND_MEM);
-
- OutS3:
+		/*
+		 * Tasks are frozen and the notifiers have been called with
+		 * PM_HIBERNATION_PREPARE
+		 */
+		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
 		mutex_unlock(&pm_mutex);
 		break;
 
