Return-Path: <linux-kernel-owner+w=401wt.eu-S1031353AbXDZRJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031353AbXDZRJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031348AbXDZRIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:08:55 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:35092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031354AbXDZRIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:08:45 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Nick Piggin <npiggin@suse.de>, suspend2-devel@lists.suspend2.net,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20070426113005.GU17387@elf.ucw.cz>
References: <20070425072350.GA6866@ucw.cz>
	 <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
	 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
	 <20070425202741.GC17387@elf.ucw.cz>
	 <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
	 <20070425214420.GG17387@elf.ucw.cz>
	 <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
	 <1177540027.5025.87.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org>
	 <1177583998.6814.42.camel@johannes.berg>
	 <20070426113005.GU17387@elf.ucw.cz>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 18:31:14 +0200
Message-Id: <1177605074.6814.93.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 13:30 +0200, Pavel Machek wrote:

> > From looking at pm_ops which I was recently working with a lot, it seems
> > that it was designed by somebody who was reading the ACPI documentation
> > and was otherwise pretty clueless, even at that level std tries to look
> > like suspend. IMHO that is one of the first things that should be ripped
> > out, no pm_ops for STD, it's a pain to work with.
> 
> That code goes back to Patrick, AFAICT. (And yes, ACPI S3 and ACPI S4
> low-level enter is pretty similar).
> 
> Patches would be welcome

That was easier than I thought. This applies on top of a patch that
makes kernel/power/user.c optional since I had no idea how to fix it,
problems I see:
 * it surfaces kernel implementation details about pm_ops and thus makes
   the whole thing very fragile
 * it has yet another interface (yuck) to determine whether to reboot,
   shut down etc, doesn't use /sys/power/disk
 * I generally had no idea wtf it is doing in some places

Anyway, this patch is only compile tested, it
 * introduces include/linux/hibernate.h with hibernate_ops and
   a new hibernate() function to hibernate the system
 * rips apart a lot of the suspend code and puts it back together using
   the hibernate_ops
 * switches ACPI to hibernate_ops (the only user of pm_ops.pm_disk_mode)
 * might apply/compile against -mm, I have all my and some of Rafael's
   suspend/hibernate work in my tree.
 * breaks user suspend as I noted above
 * is incomplete, somewhere pm_suspend_disk() is still defined iirc

johannes
---
 Documentation/power/userland-swsusp.txt |   26 +++----
 drivers/acpi/sleep/main.c               |   89 ++++++++++++++++++++----
 drivers/acpi/sleep/proc.c               |    3 
 drivers/i2c/chips/tps65010.c            |    2 
 include/linux/hibernate.h               |   36 +++++++++
 include/linux/pm.h                      |   31 --------
 kernel/power/disk.c                     |  117 +++++++++++++++++++-------------
 kernel/power/main.c                     |   47 +++++-------
 kernel/power/power.h                    |   13 ---
 kernel/power/user.c                     |   28 +------
 kernel/sys.c                            |    3 
 11 files changed, 231 insertions(+), 164 deletions(-)

--- wireless-dev.orig/include/linux/pm.h	2007-04-26 18:15:00.440691185 +0200
+++ wireless-dev/include/linux/pm.h	2007-04-26 18:15:09.410691185 +0200
@@ -107,26 +107,11 @@ typedef int __bitwise suspend_state_t;
 #define PM_SUSPEND_ON		((__force suspend_state_t) 0)
 #define PM_SUSPEND_STANDBY	((__force suspend_state_t) 1)
 #define PM_SUSPEND_MEM		((__force suspend_state_t) 3)
-#define PM_SUSPEND_DISK		((__force suspend_state_t) 4)
-#define PM_SUSPEND_MAX		((__force suspend_state_t) 5)
-
-typedef int __bitwise suspend_disk_method_t;
-
-/* invalid must be 0 so struct pm_ops initialisers can leave it out */
-#define PM_DISK_INVALID		((__force suspend_disk_method_t) 0)
-#define	PM_DISK_PLATFORM	((__force suspend_disk_method_t) 1)
-#define	PM_DISK_SHUTDOWN	((__force suspend_disk_method_t) 2)
-#define	PM_DISK_REBOOT		((__force suspend_disk_method_t) 3)
-#define	PM_DISK_TEST		((__force suspend_disk_method_t) 4)
-#define	PM_DISK_TESTPROC	((__force suspend_disk_method_t) 5)
-#define	PM_DISK_MAX		((__force suspend_disk_method_t) 6)
+#define PM_SUSPEND_MAX		((__force suspend_state_t) 4)
 
 /**
  * struct pm_ops - Callbacks for managing platform dependent suspend states.
  * @valid: Callback to determine whether the given state can be entered.
- * 	If %CONFIG_SOFTWARE_SUSPEND is set then %PM_SUSPEND_DISK is
- *	always valid and never passed to this call. If not assigned,
- *	no suspend states are valid.
  *	Valid states are advertised in /sys/power/state but can still
  *	be rejected by prepare or enter if the conditions aren't right.
  *	There is a %pm_valid_only_mem function available that can be assigned
@@ -140,24 +125,12 @@ typedef int __bitwise suspend_disk_metho
  *
  * @finish: Called when the system has left the given state and all devices
  *	are resumed. The return value is ignored.
- *
- * @pm_disk_mode: The generic code always allows one of the shutdown methods
- *	%PM_DISK_SHUTDOWN, %PM_DISK_REBOOT, %PM_DISK_TEST and
- *	%PM_DISK_TESTPROC. If this variable is set, the mode it is set
- *	to is allowed in addition to those modes and is also made default.
- *	When this mode is sent selected, the @prepare call will be called
- *	before suspending to disk (if present), the @enter call should be
- *	present and will be called after all state has been saved and the
- *	machine is ready to be powered off; the @finish callback is called
- *	after state has been restored. All these calls are called with
- *	%PM_SUSPEND_DISK as the state.
  */
 struct pm_ops {
 	int (*valid)(suspend_state_t state);
 	int (*prepare)(suspend_state_t state);
 	int (*enter)(suspend_state_t state);
 	int (*finish)(suspend_state_t state);
-	suspend_disk_method_t pm_disk_mode;
 };
 
 /**
@@ -276,8 +249,6 @@ extern void device_power_up(void);
 extern void device_resume(void);
 
 #ifdef CONFIG_PM
-extern suspend_disk_method_t pm_disk_mode;
-
 extern int device_suspend(pm_message_t state);
 extern int device_prepare_suspend(pm_message_t state);
 
--- wireless-dev.orig/kernel/power/main.c	2007-04-26 18:15:00.790691185 +0200
+++ wireless-dev/kernel/power/main.c	2007-04-26 18:15:09.410691185 +0200
@@ -21,6 +21,7 @@
 #include <linux/resume-trace.h>
 #include <linux/freezer.h>
 #include <linux/vmstat.h>
+#include <linux/hibernate.h>
 
 #include "power.h"
 
@@ -30,7 +31,6 @@
 DEFINE_MUTEX(pm_mutex);
 
 struct pm_ops *pm_ops;
-suspend_disk_method_t pm_disk_mode = PM_DISK_SHUTDOWN;
 
 /**
  *	pm_set_ops - Set the global power method table. 
@@ -41,10 +41,6 @@ void pm_set_ops(struct pm_ops * ops)
 {
 	mutex_lock(&pm_mutex);
 	pm_ops = ops;
-	if (ops && ops->pm_disk_mode != PM_DISK_INVALID) {
-		pm_disk_mode = ops->pm_disk_mode;
-	} else
-		pm_disk_mode = PM_DISK_SHUTDOWN;
 	mutex_unlock(&pm_mutex);
 }
 
@@ -184,24 +180,12 @@ static void suspend_finish(suspend_state
 static const char * const pm_states[PM_SUSPEND_MAX] = {
 	[PM_SUSPEND_STANDBY]	= "standby",
 	[PM_SUSPEND_MEM]	= "mem",
-	[PM_SUSPEND_DISK]	= "disk",
 };
 
 static inline int valid_state(suspend_state_t state)
 {
-	/* Suspend-to-disk does not really need low-level support.
-	 * It can work with shutdown/reboot if needed. If it isn't
-	 * configured, then it cannot be supported.
-	 */
-	if (state == PM_SUSPEND_DISK)
-#ifdef CONFIG_SOFTWARE_SUSPEND
-		return 1;
-#else
-		return 0;
-#endif
-
-	/* all other states need lowlevel support and need to be
-	 * valid to the lowlevel implementation, no valid callback
+	/* All states need lowlevel support and need to be valid
+	 * to the lowlevel implementation, no valid callback
 	 * implies that none are valid. */
 	if (!pm_ops || !pm_ops->valid || !pm_ops->valid(state))
 		return 0;
@@ -229,11 +213,6 @@ static int enter_state(suspend_state_t s
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
-	if (state == PM_SUSPEND_DISK) {
-		error = pm_suspend_disk();
-		goto Unlock;
-	}
-
 	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
 	if ((error = suspend_prepare(state)))
 		goto Unlock;
@@ -251,7 +230,7 @@ static int enter_state(suspend_state_t s
 
 /**
  *	pm_suspend - Externally visible function for suspending system.
- *	@state:		Enumarted value of state to enter.
+ *	@state:		Enumerated value of state to enter.
  *
  *	Determine whether or not value is within range, get state 
  *	structure, and enter (above).
@@ -283,13 +262,19 @@ decl_subsys(power,NULL,NULL);
 static ssize_t state_show(struct subsystem * subsys, char * buf)
 {
 	int i;
-	char * s = buf;
+	char *s = buf;
 
 	for (i = 0; i < PM_SUSPEND_MAX; i++) {
 		if (pm_states[i] && valid_state(i))
-			s += sprintf(s,"%s ", pm_states[i]);
+			s += sprintf(s, "%s ", pm_states[i]);
 	}
-	s += sprintf(s,"\n");
+#ifdef CONFIG_SOFTWARE_SUSPEND
+	s += sprintf(s, "%s\n", "disk");
+#else
+	if (s != buf)
+		/* convert the last space to a newline */
+		*(s-1) = "\n";
+#endif
 	return (s - buf);
 }
 
@@ -304,6 +289,12 @@ static ssize_t state_store(struct subsys
 	p = memchr(buf, '\n', n);
 	len = p ? p - buf : n;
 
+	/* first check hibernate */
+	if (strncmp(buf, "disk", len)) {
+		error = hibernate();
+		return error ? error : n;
+	}
+
 	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
 		if (*s && !strncmp(buf, *s, len))
 			break;
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/include/linux/hibernate.h	2007-04-26 18:21:38.130691185 +0200
@@ -0,0 +1,36 @@
+#ifndef __LINUX_HIBERNATE
+#define __LINUX_HIBERNATE
+/*
+ * hibernate ('suspend to disk') functionality
+ */
+
+/**
+ * struct hibernate_ops - hibernate platform support
+ *
+ * The methods in this structure allow a platform to override what
+ * happens for shutting down the machine when going into hibernation.
+ *
+ * All three methods must be assigned.
+ *
+ * @prepare: prepare system for hibernation
+ * @enter: shut down system after state has been saved to disk
+ * @finish: finish/clean up after state has been reloaded
+ */
+struct hibernate_ops {
+	int (*prepare)(void);
+	int (*enter)(void);
+	void (*finish)(void);
+};
+
+/**
+ * hibernate_set_ops - set the global hibernate operations
+ * @ops: the hibernate operations to use from now on.
+ */
+void hibernate_set_ops(struct hibernate_ops *ops);
+
+/**
+ * hibernate - hibernate the system
+ */
+int hibernate(void);
+
+#endif /* __LINUX_HIBERNATE */
--- wireless-dev.orig/kernel/power/disk.c	2007-04-26 18:15:00.800691185 +0200
+++ wireless-dev/kernel/power/disk.c	2007-04-26 18:15:09.420691185 +0200
@@ -21,45 +21,72 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <linux/hibernate.h>
 
 #include "power.h"
 
 
-static int noresume = 0;
+static int noresume;
 char resume_file[256] = CONFIG_PM_STD_PARTITION;
 dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
 
+static struct hibernate_ops *hibernate_ops;
+static int pm_disk_mode;
+
+enum {
+	PM_DISK_INVALID,
+	PM_DISK_PLATFORM,
+	PM_DISK_TEST,
+	PM_DISK_TESTPROC,
+	PM_DISK_SHUTDOWN,
+	PM_DISK_REBOOT,
+	/* keep last */
+	__PM_DISK_AFTER_LAST
+};
+#define PM_DISK_MAX (__PM_DISK_AFTER_LAST-1)
+#define PM_DISK_FIRST (PM_DISK_INVALID + 1)
+
+void hibernate_set_ops(struct hibernate_ops *ops)
+{
+	BUG_ON(!hibernate_ops->prepare);
+	BUG_ON(!hibernate_ops->enter);
+	BUG_ON(!hibernate_ops->finish);
+	mutex_lock(&pm_mutex);
+	hibernate_ops = ops;
+	mutex_unlock(&pm_mutex);
+}
+
+
 /**
- *	platform_prepare - prepare the machine for hibernation using the
- *	platform driver if so configured and return an error code if it fails
+ *	hibernate_platform_prepare - prepare the machine for hibernation using
+ *	the platform driver if so configured and return an error code if it
+ *	fails.
  */
 
-static inline int platform_prepare(void)
+int hibernate_platform_prepare(void)
 {
-	int error = 0;
-
 	switch (pm_disk_mode) {
 	case PM_DISK_TEST:
 	case PM_DISK_TESTPROC:
 	case PM_DISK_SHUTDOWN:
 	case PM_DISK_REBOOT:
 		break;
-	default:
-		if (pm_ops && pm_ops->prepare)
-			error = pm_ops->prepare(PM_SUSPEND_DISK);
+	case PM_DISK_PLATFORM:
+		if (hibernate_ops)
+			return hibernate_ops->prepare();
 	}
-	return error;
+	return 0;
 }
 
 /**
- *	power_down - Shut machine down for hibernate.
+ *	hibernate_power_down - Shut machine down for hibernate.
  *
  *	Use the platform driver, if configured so; otherwise try
  *	to power off or reboot.
  */
 
-static void power_down(void)
+static void hibernate_power_down(void)
 {
 	switch (pm_disk_mode) {
 	case PM_DISK_TEST:
@@ -70,11 +97,10 @@ static void power_down(void)
 	case PM_DISK_REBOOT:
 		kernel_restart(NULL);
 		break;
-	default:
-		if (pm_ops && pm_ops->enter) {
+	case PM_DISK_PLATFORM:
+		if (hibernate_ops) {
 			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
-			pm_ops->enter(PM_SUSPEND_DISK);
-			break;
+			hibernate_ops->enter();
 		}
 	}
 
@@ -85,7 +111,7 @@ static void power_down(void)
 	while(1);
 }
 
-static inline void platform_finish(void)
+void hibernate_platform_finish(void)
 {
 	switch (pm_disk_mode) {
 	case PM_DISK_TEST:
@@ -93,9 +119,9 @@ static inline void platform_finish(void)
 	case PM_DISK_SHUTDOWN:
 	case PM_DISK_REBOOT:
 		break;
-	default:
-		if (pm_ops && pm_ops->finish)
-			pm_ops->finish(PM_SUSPEND_DISK);
+	case PM_DISK_PLATFORM:
+		if (hibernate_ops)
+			hibernate_ops->finish();
 	}
 }
 
@@ -118,13 +144,13 @@ static int prepare_processes(void)
 }
 
 /**
- *	pm_suspend_disk - The granpappy of hibernation power management.
+ *	hibernate - The granpappy of hibernation power management.
  *
  *	If not, then call swsusp to do its thing, then figure out how
  *	to power down the system.
  */
 
-int pm_suspend_disk(void)
+int hibernate(void)
 {
 	int error;
 
@@ -147,7 +173,7 @@ int pm_suspend_disk(void)
 	if (error)
 		goto Finish;
 
-	error = platform_prepare();
+	error = hibernate_platform_prepare();
 	if (error)
 		goto Finish;
 
@@ -175,13 +201,13 @@ int pm_suspend_disk(void)
 
 	if (in_suspend) {
 		enable_nonboot_cpus();
-		platform_finish();
+		hibernate_platform_finish();
 		device_resume();
 		resume_console();
 		pr_debug("PM: writing image.\n");
 		error = swsusp_write();
 		if (!error)
-			power_down();
+			hibernate_power_down();
 		else {
 			swsusp_free();
 			goto Finish;
@@ -194,7 +220,7 @@ int pm_suspend_disk(void)
  Enable_cpus:
 	enable_nonboot_cpus();
  Resume_devices:
-	platform_finish();
+	hibernate_platform_finish();
 	device_resume();
 	resume_console();
  Finish:
@@ -211,7 +237,7 @@ int pm_suspend_disk(void)
  *	Called as a late_initcall (so all devices are discovered and
  *	initialized), we call swsusp to see if we have a saved image or not.
  *	If so, we quiesce devices, the restore the saved image. We will
- *	return above (in pm_suspend_disk() ) if everything goes well.
+ *	return above (in hibernate() ) if everything goes well.
  *	Otherwise, we fail gracefully and return to the normally
  *	scheduled program.
  *
@@ -311,12 +337,13 @@ static const char * const pm_disk_modes[
  *
  *	Suspend-to-disk can be handled in several ways. We have a few options
  *	for putting the system to sleep - using the platform driver (e.g. ACPI
- *	or other pm_ops), powering off the system or rebooting the system
- *	(for testing) as well as the two test modes.
+ *	or other hibernate_ops), powering off the system or rebooting the
+ *	system (for testing) as well as the two test modes.
  *
  *	The system can support 'platform', and that is known a priori (and
- *	encoded in pm_ops). However, the user may choose 'shutdown' or 'reboot'
- *	as alternatives, as well as the test modes 'test' and 'testproc'.
+ *	encoded by the presence of hibernate_ops). However, the user may choose
+ *	'shutdown' or 'reboot' as alternatives, as well as the test modes 'test'
+ *	and 'testproc'.
  *
  *	show() will display what the mode is currently set to.
  *	store() will accept one of
@@ -328,7 +355,7 @@ static const char * const pm_disk_modes[
  *	'testproc'
  *
  *	It will only change to 'platform' if the system
- *	supports it (as determined from pm_ops->pm_disk_mode).
+ *	supports it (as determined by having hibernate_ops).
  */
 
 static ssize_t disk_show(struct subsystem * subsys, char * buf)
@@ -336,7 +363,7 @@ static ssize_t disk_show(struct subsyste
 	int i;
 	char *start = buf;
 
-	for (i = PM_DISK_PLATFORM; i < PM_DISK_MAX; i++) {
+	for (i = PM_DISK_FIRST; i <= PM_DISK_MAX; i++) {
 		if (!pm_disk_modes[i])
 			continue;
 		switch (i) {
@@ -345,9 +372,8 @@ static ssize_t disk_show(struct subsyste
 		case PM_DISK_TEST:
 		case PM_DISK_TESTPROC:
 			break;
-		default:
-			if (pm_ops && pm_ops->enter &&
-			    (i == pm_ops->pm_disk_mode))
+		case PM_DISK_PLATFORM:
+			if (hibernate_ops)
 				break;
 			/* not a valid mode, continue with loop */
 			continue;
@@ -370,19 +396,19 @@ static ssize_t disk_store(struct subsyst
 	int i;
 	int len;
 	char *p;
-	suspend_disk_method_t mode = 0;
+	int mode = PM_DISK_INVALID;
 
 	p = memchr(buf, '\n', n);
 	len = p ? p - buf : n;
 
 	mutex_lock(&pm_mutex);
-	for (i = PM_DISK_PLATFORM; i < PM_DISK_MAX; i++) {
+	for (i = PM_DISK_FIRST; i < PM_DISK_MAX; i++) {
 		if (!strncmp(buf, pm_disk_modes[i], len)) {
 			mode = i;
 			break;
 		}
 	}
-	if (mode) {
+	if (mode != PM_DISK_INVALID) {
 		switch (mode) {
 		case PM_DISK_SHUTDOWN:
 		case PM_DISK_REBOOT:
@@ -390,19 +416,18 @@ static ssize_t disk_store(struct subsyst
 		case PM_DISK_TESTPROC:
 			pm_disk_mode = mode;
 			break;
-		default:
-			if (pm_ops && pm_ops->enter &&
-			    (mode == pm_ops->pm_disk_mode))
+		case PM_DISK_PLATFORM:
+			if (hibernate_ops)
 				pm_disk_mode = mode;
 			else
 				error = -EINVAL;
 		}
-	} else {
+	} else
 		error = -EINVAL;
-	}
 
-	pr_debug("PM: suspend-to-disk mode set to '%s'\n",
-		 pm_disk_modes[mode]);
+	if (!error)
+		pr_debug("PM: suspend-to-disk mode set to '%s'\n",
+			 pm_disk_modes[mode]);
 	mutex_unlock(&pm_mutex);
 	return error ? error : n;
 }
--- wireless-dev.orig/kernel/power/user.c	2007-04-26 18:15:01.130691185 +0200
+++ wireless-dev/kernel/power/user.c	2007-04-26 18:15:09.420691185 +0200
@@ -128,22 +128,6 @@ static ssize_t snapshot_write(struct fil
 	return res;
 }
 
-static inline int platform_prepare(void)
-{
-	int error = 0;
-
-	if (pm_ops && pm_ops->prepare)
-		error = pm_ops->prepare(PM_SUSPEND_DISK);
-
-	return error;
-}
-
-static inline void platform_finish(void)
-{
-	if (pm_ops && pm_ops->finish)
-		pm_ops->finish(PM_SUSPEND_DISK);
-}
-
 static inline int snapshot_suspend(int platform_suspend)
 {
 	int error;
@@ -155,7 +139,7 @@ static inline int snapshot_suspend(int p
 		goto Finish;
 
 	if (platform_suspend) {
-		error = platform_prepare();
+		error = hibernate_platform_prepare();
 		if (error)
 			goto Finish;
 	}
@@ -172,7 +156,7 @@ static inline int snapshot_suspend(int p
 	enable_nonboot_cpus();
  Resume_devices:
 	if (platform_suspend)
-		platform_finish();
+		hibernate_platform_finish();
 
 	device_resume();
 	resume_console();
@@ -188,7 +172,7 @@ static inline int snapshot_restore(int p
 	mutex_lock(&pm_mutex);
 	pm_prepare_console();
 	if (platform_suspend) {
-		error = platform_prepare();
+		error = hibernate_platform_prepare();
 		if (error)
 			goto Finish;
 	}
@@ -204,7 +188,7 @@ static inline int snapshot_restore(int p
 	enable_nonboot_cpus();
  Resume_devices:
 	if (platform_suspend)
-		platform_finish();
+		hibernate_platform_finish();
 
 	device_resume();
 	resume_console();
@@ -406,13 +390,15 @@ static int snapshot_ioctl(struct inode *
 		case PMOPS_ENTER:
 			if (data->platform_suspend) {
 				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
-				error = pm_ops->enter(PM_SUSPEND_DISK);
+				error = hibernate_ops->enter();
+				/* how can this possibly do the right thing? */
 				error = 0;
 			}
 			break;
 
 		case PMOPS_FINISH:
 			if (data->platform_suspend)
+				/* and why doesn't this invoke anything??? */
 				error = 0;
 
 			break;
--- wireless-dev.orig/Documentation/power/userland-swsusp.txt	2007-04-26 18:15:02.120691185 +0200
+++ wireless-dev/Documentation/power/userland-swsusp.txt	2007-04-26 18:15:09.440691185 +0200
@@ -93,21 +93,23 @@ SNAPSHOT_S2RAM - suspend to RAM; using t
 	to resume the system from RAM if there's enough battery power or restore
 	its state on the basis of the saved suspend image otherwise)
 
-SNAPSHOT_PMOPS - enable the usage of the pmops->prepare, pmops->enter and
-	pmops->finish methods (the in-kernel swsusp knows these as the "platform
-	method") which are needed on many machines to (among others) speed up
-	the resume by letting the BIOS skip some steps or to let the system
-	recognise the correct state of the hardware after the resume (in
-	particular on many machines this ensures that unplugged AC
-	adapters get correctly detected and that kacpid does not run wild after
-	the resume).  The last ioctl() argument can take one of the three
-	values, defined in kernel/power/power.h:
+SNAPSHOT_PMOPS - enable the usage of the hibernate_ops->prepare,
+	hibernate_ops->enter and hibernate_ops->finish methods (the in-kernel
+	swsusp knows these as the "platform method") which are needed on many
+	machines to (among others) speed up the resume by letting the BIOS skip
+	some steps or to let the system recognise the correct state of the
+	hardware after the resume (in particular on many machines this ensures
+	that unplugged AC adapters get correctly detected and that kacpid does
+	not run wild after the resume).  The last ioctl() argument can take one
+	of the three values, defined in kernel/power/power.h:
 	PMOPS_PREPARE - make the kernel carry out the
-		pm_ops->prepare(PM_SUSPEND_DISK) operation
+		hibernate_ops->prepare() operation
 	PMOPS_ENTER - make the kernel power off the system by calling
-		pm_ops->enter(PM_SUSPEND_DISK)
+		hibernate_ops->enter()
 	PMOPS_FINISH - make the kernel carry out the
-		pm_ops->finish(PM_SUSPEND_DISK) operation
+		hibernate_ops->finish() operation
+	Note that the actual constants are misnamed because they surface
+	internal kernel implementation details that have changed.
 
 The device's read() operation can be used to transfer the snapshot image from
 the kernel.  It has the following limitations:
--- wireless-dev.orig/drivers/i2c/chips/tps65010.c	2007-04-26 18:15:02.150691185 +0200
+++ wireless-dev/drivers/i2c/chips/tps65010.c	2007-04-26 18:15:09.440691185 +0200
@@ -354,7 +354,7 @@ static void tps65010_interrupt(struct tp
 			 * also needs to get error handling and probably
 			 * an #ifdef CONFIG_SOFTWARE_SUSPEND
 			 */
-			pm_suspend(PM_SUSPEND_DISK);
+			hibernate();
 #endif
 			poll = 1;
 		}
--- wireless-dev.orig/kernel/sys.c	2007-04-26 18:15:01.310691185 +0200
+++ wireless-dev/kernel/sys.c	2007-04-26 18:15:09.450691185 +0200
@@ -25,6 +25,7 @@
 #include <linux/security.h>
 #include <linux/dcookies.h>
 #include <linux/suspend.h>
+#include <linux/hibernate.h>
 #include <linux/tty.h>
 #include <linux/signal.h>
 #include <linux/cn_proc.h>
@@ -881,7 +882,7 @@ asmlinkage long sys_reboot(int magic1, i
 #ifdef CONFIG_SOFTWARE_SUSPEND
 	case LINUX_REBOOT_CMD_SW_SUSPEND:
 		{
-			int ret = pm_suspend(PM_SUSPEND_DISK);
+			int ret = hibernate();
 			unlock_kernel();
 			return ret;
 		}
--- wireless-dev.orig/drivers/acpi/sleep/main.c	2007-04-26 18:15:02.290691185 +0200
+++ wireless-dev/drivers/acpi/sleep/main.c	2007-04-26 18:15:09.630691185 +0200
@@ -15,6 +15,7 @@
 #include <linux/dmi.h>
 #include <linux/device.h>
 #include <linux/suspend.h>
+#include <linux/hibernate.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include "sleep.h"
@@ -29,7 +30,6 @@ static u32 acpi_suspend_states[] = {
 	[PM_SUSPEND_ON] = ACPI_STATE_S0,
 	[PM_SUSPEND_STANDBY] = ACPI_STATE_S1,
 	[PM_SUSPEND_MEM] = ACPI_STATE_S3,
-	[PM_SUSPEND_DISK] = ACPI_STATE_S4,
 	[PM_SUSPEND_MAX] = ACPI_STATE_S5
 };
 
@@ -94,14 +94,6 @@ static int acpi_pm_enter(suspend_state_t
 		do_suspend_lowlevel();
 		break;
 
-	case PM_SUSPEND_DISK:
-		if (acpi_pm_ops.pm_disk_mode == PM_DISK_PLATFORM)
-			status = acpi_enter_sleep_state(acpi_state);
-		break;
-	case PM_SUSPEND_MAX:
-		acpi_power_off();
-		break;
-
 	default:
 		return -EINVAL;
 	}
@@ -157,12 +149,13 @@ int acpi_suspend(u32 acpi_state)
 	suspend_state_t states[] = {
 		[1] = PM_SUSPEND_STANDBY,
 		[3] = PM_SUSPEND_MEM,
-		[4] = PM_SUSPEND_DISK,
 		[5] = PM_SUSPEND_MAX
 	};
 
 	if (acpi_state < 6 && states[acpi_state])
 		return pm_suspend(states[acpi_state]);
+	if (acpi_state == 4)
+		return hibernate();
 	return -EINVAL;
 }
 
@@ -189,6 +182,71 @@ static struct pm_ops acpi_pm_ops = {
 	.finish = acpi_pm_finish,
 };
 
+#ifdef CONFIG_SOFTWARE_SUSPEND
+static int acpi_hib_prepare(void)
+{
+	return acpi_sleep_prepare(ACPI_STATE_S4);
+}
+
+static int acpi_hib_enter(void)
+{
+	acpi_status status = AE_OK;
+	unsigned long flags = 0;
+	u32 acpi_state = acpi_suspend_states[pm_state];
+
+	ACPI_FLUSH_CPU_CACHE();
+
+	/* Do arch specific saving of state. */
+	int error = acpi_save_state_mem();
+	if (error)
+		return error;
+
+	local_irq_save(flags);
+	acpi_enable_wakeup_device(acpi_state);
+	status = acpi_enter_sleep_state(acpi_state);
+
+	/* ACPI 3.0 specs (P62) says that it's the responsabilty
+	 * of the OSPM to clear the status bit [ implying that the
+	 * POWER_BUTTON event should not reach userspace ]
+	 */
+	if (ACPI_SUCCESS(status) && (acpi_state == ACPI_STATE_S3))
+		acpi_clear_event(ACPI_EVENT_POWER_BUTTON);
+
+	local_irq_restore(flags);
+	printk(KERN_DEBUG "Back to C!\n");
+
+	/* restore processor state
+	 * We should only be here if we're coming back from STR or STD.
+	 * And, in the case of the latter, the memory image should have already
+	 * been loaded from disk.
+	 */
+	acpi_restore_state_mem();
+
+	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
+}
+
+static void acpi_hib_finish(void)
+{
+	acpi_leave_sleep_state(ACPI_STATE_S4);
+	acpi_disable_wakeup_device(ACPI_STATE_S4);
+
+	/* reset firmware waking vector */
+	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
+
+	if (init_8259A_after_S1) {
+		printk("Broken toshiba laptop -> kicking interrupts\n");
+		init_8259A(0);
+	}
+	return 0;
+}
+
+static struct hibernate_ops acpi_hib_ops = {
+	.prepare = acpi_hib_prepare,
+	.enter = acpi_hib_enter,
+	.finish = acpi_hib_finish,
+};
+#endif /* CONFIG_SOFTWARE_SUSPEND */
+
 /*
  * Toshiba fails to preserve interrupts over S1, reinitialization
  * of 8259 is needed after S1 resume.
@@ -227,13 +285,16 @@ int __init acpi_sleep_init(void)
 			sleep_states[i] = 1;
 			printk(" S%d", i);
 		}
-		if (i == ACPI_STATE_S4) {
-			if (sleep_states[i])
-				acpi_pm_ops.pm_disk_mode = PM_DISK_PLATFORM;
-		}
 	}
 	printk(")\n");
 
+#ifdef CONFIG_SOFTWARE_SUSPEND
+	if (sleep_states[ACPI_STATE_S4])
+		hibernate_set_ops(&acpi_hib_ops);
+#else
+	sleep_states[ACPI_STATE_S4] = 0;
+#endif
+
 	pm_set_ops(&acpi_pm_ops);
 	return 0;
 }
--- wireless-dev.orig/kernel/power/power.h	2007-04-26 18:15:01.240691185 +0200
+++ wireless-dev/kernel/power/power.h	2007-04-26 18:15:09.630691185 +0200
@@ -13,16 +13,6 @@ struct swsusp_info {
 
 
 
-#ifdef CONFIG_SOFTWARE_SUSPEND
-extern int pm_suspend_disk(void);
-
-#else
-static inline int pm_suspend_disk(void)
-{
-	return -EPERM;
-}
-#endif
-
 extern struct mutex pm_mutex;
 
 #define power_attr(_name) \
@@ -179,3 +169,6 @@ extern int suspend_enter(suspend_state_t
 struct timeval;
 extern void swsusp_show_speed(struct timeval *, struct timeval *,
 				unsigned int, char *);
+
+extern int hibernate_platform_prepare(void);
+extern void hibernate_platform_finish(void);
--- wireless-dev.orig/drivers/acpi/sleep/proc.c	2007-04-26 18:15:02.720691185 +0200
+++ wireless-dev/drivers/acpi/sleep/proc.c	2007-04-26 18:15:09.630691185 +0200
@@ -1,6 +1,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/suspend.h>
+#include <linux/hibernate.h>
 #include <linux/bcd.h>
 #include <asm/uaccess.h>
 
@@ -60,7 +61,7 @@ acpi_system_write_sleep(struct file *fil
 	state = simple_strtoul(str, NULL, 0);
 #ifdef CONFIG_SOFTWARE_SUSPEND
 	if (state == 4) {
-		error = pm_suspend(PM_SUSPEND_DISK);
+		error = hibernate();
 		goto Done;
 	}
 #endif


