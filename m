Return-Path: <linux-kernel-owner+w=401wt.eu-S1763314AbXF0Vtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763314AbXF0Vtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 17:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbXF0Vtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 17:49:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51553 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbXF0Vtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 17:49:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] PM: Introduce set_target method in pm_ops
Date: Wed, 27 Jun 2007 23:56:28 +0200
User-Agent: KMail/1.9.5
Cc: David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Johannes Berg <johannes@sipsolutions.net>,
       Len Brown <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706272356.29475.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Please consider as 2.6.22 material.]
---
From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 52ade9b3b97fd3bea42842a056fe0786c28d0555 changed the suspend code
ordering to execute pm_ops->prepare() after the device model per-device
.suspend() calls in order to fix some ACPI-related issues.  Unfortunately, it
broke the at91 platform which assumed that pm_ops->prepare() would be called
before suspending devices.

at91 used pm_ops->prepare() to get notified of the target system sleep state, so
that it could use this information while suspending devices.  However, with the
current suspend code ordering pm_ops->prepare() is called too late for this
purpose.  Thus, at91 needs an additional method in 'struct pm_ops' that will
be used for notifying the platform of the target system sleep state.  Moreover,
in the future such a method will also be needed by ACPI.

This patch adds the .set_target() method to 'struct pm_ops' and makes the
suspend code call it, if implemented, before executing the device model
per-device .suspend() calls.  It also modifies the at91 code to implement
pm_ops->set_target() instead of pm_ops->prepare().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 arch/arm/mach-at91/pm.c |    4 +-
 include/linux/pm.h      |   66 +++++++++++++++++++++++++++++++++++-------------
 kernel/power/main.c     |    6 +++-
 3 files changed, 56 insertions(+), 20 deletions(-)

Index: linux-2.6.22-rc6/include/linux/pm.h
===================================================================
--- linux-2.6.22-rc6.orig/include/linux/pm.h	2007-06-25 21:09:18.000000000 +0200
+++ linux-2.6.22-rc6/include/linux/pm.h	2007-06-25 21:09:30.000000000 +0200
@@ -110,37 +110,67 @@ typedef int __bitwise suspend_state_t;
 #define PM_SUSPEND_MAX		((__force suspend_state_t) 4)
 
 /**
- * struct pm_ops - Callbacks for managing platform dependent suspend states.
- * @valid: Callback to determine whether the given state can be entered.
- *	Valid states are advertised in /sys/power/state but can still
- *	be rejected by prepare or enter if the conditions aren't right.
- *	There is a %pm_valid_only_mem function available that can be assigned
- *	to this if you only implement mem sleep.
+ * struct pm_ops - Callbacks for managing platform dependent system sleep
+ *	states.
  *
- * @prepare: Prepare the platform for the given suspend state. Can return a
- *	negative error code if necessary.
- *
- * @enter: Enter the given suspend state, must be assigned. Can return a
- *	negative error code if necessary.
- *
- * @finish: Called when the system has left the given state and all devices
- *	are resumed. The return value is ignored.
+ * @valid: Callback to determine if given system sleep state is supported by
+ *	the platform.
+ *	Valid (ie. supported) states are advertised in /sys/power/state.  Note
+ *	that it still may be impossible to enter given system sleep state if the
+ *	conditions aren't right.
+ *	There is the %pm_valid_only_mem function available that can be assigned
+ *	to this if the platform only supports mem sleep.
+ *
+ * @set_target: Tell the platform which system sleep state is going to be
+ *	entered.
+ *	@set_target() is executed right prior to suspending devices.  The
+ *	information conveyed to the platform code by @set_target() should be
+ *	disregarded by the platform as soon as @finish() is executed and if
+ *	@prepare() fails.  If @set_target() fails (ie. returns nonzero),
+ *	@prepare(), @enter() and @finish() will not be called by the PM core.
+ *	This callback is optional.  However, if it is implemented, the argument
+ *	passed to @prepare(), @enter() and @finish() is meaningless and should
+ *	be ignored.
+ *
+ * @prepare: Prepare the platform for entering the system sleep state indicated
+ *	by @set_target() or represented by the argument if @set_target() is not
+ *	implemented.
+ *	@prepare() is called right after devices have been suspended (ie. the
+ *	appropriate .suspend() method has been executed for each device) and
+ *	before the nonboot CPUs are disabled (it is executed with IRQs enabled).
+ *	This callback is optional.  It returns 0 on success or a negative
+ *	error code otherwise, in which case the system cannot enter the desired
+ *	sleep state (@enter() and @finish() will not be called in that case).
+ *
+ * @enter: Enter the system sleep state indicated by @set_target() or
+ *	represented by the argument if @set_target() is not implemented.
+ *	This callback is mandatory.  It returns 0 on success or a negative
+ *	error code otherwise, in which case the system cannot enter the desired
+ *	sleep state.
+ *
+ * @finish: Called when the system has just left a sleep state, right after
+ *	the nonboot CPUs have been enabled and before devices are resumed (it is
+ *	executed with IRQs enabled).  If @set_target() is not implemented, the
+ *	argument represents the sleep state being left.
+ *	This callback is optional, but should be implemented by the platforms
+ *	that implement @prepare().  If implemented, it is always called after
+ *	@enter() (even if @enter() fails).
  */
 struct pm_ops {
 	int (*valid)(suspend_state_t state);
+	int (*set_target)(suspend_state_t state);
 	int (*prepare)(suspend_state_t state);
 	int (*enter)(suspend_state_t state);
 	int (*finish)(suspend_state_t state);
 };
 
+extern struct pm_ops *pm_ops;
+
 /**
  * pm_set_ops - set platform dependent power management ops
  * @pm_ops: The new power management operations to set.
  */
 extern void pm_set_ops(struct pm_ops *pm_ops);
-extern struct pm_ops *pm_ops;
-extern int pm_suspend(suspend_state_t state);
-
 extern int pm_valid_only_mem(suspend_state_t state);
 
 /**
@@ -161,6 +191,8 @@ extern void arch_suspend_disable_irqs(vo
  */
 extern void arch_suspend_enable_irqs(void);
 
+extern int pm_suspend(suspend_state_t state);
+
 /*
  * Device power management
  */
Index: linux-2.6.22-rc6/kernel/power/main.c
===================================================================
--- linux-2.6.22-rc6.orig/kernel/power/main.c	2007-06-25 21:09:18.000000000 +0200
+++ linux-2.6.22-rc6/kernel/power/main.c	2007-06-25 21:09:30.000000000 +0200
@@ -15,7 +15,6 @@
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/init.h>
-#include <linux/pm.h>
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/resume-trace.h>
@@ -161,6 +160,11 @@ int suspend_devices_and_enter(suspend_st
 	if (!pm_ops)
 		return -ENOSYS;
 
+	if (pm_ops->set_target) {
+		error = pm_ops->set_target(state);
+		if (error)
+			return error;
+	}
 	suspend_console();
 	error = device_suspend(PMSG_SUSPEND);
 	if (error) {
Index: linux-2.6.22-rc6/arch/arm/mach-at91/pm.c
===================================================================
--- linux-2.6.22-rc6.orig/arch/arm/mach-at91/pm.c	2007-06-25 21:09:18.000000000 +0200
+++ linux-2.6.22-rc6/arch/arm/mach-at91/pm.c	2007-06-25 21:09:30.000000000 +0200
@@ -53,7 +53,7 @@ static suspend_state_t target_state;
 /*
  * Called after processes are frozen, but before we shutdown devices.
  */
-static int at91_pm_prepare(suspend_state_t state)
+static int at91_pm_set_target(suspend_state_t state)
 {
 	target_state = state;
 	return 0;
@@ -201,7 +201,7 @@ error:
 
 static struct pm_ops at91_pm_ops ={
 	.valid		= at91_pm_valid_state,
-	.prepare	= at91_pm_prepare,
+	.set_target	= at91_pm_set_target,
 	.enter		= at91_pm_enter,
 };
 

