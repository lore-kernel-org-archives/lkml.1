Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbXL0SBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbXL0SBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbXL0SBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:01:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43403 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbXL0SB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:01:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [RFC][PATCH 1/7] Suspend: Introduce open() and close() callbacks
Date: Thu, 27 Dec 2007 19:13:42 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Arjan van de Ven <arjan@infradead.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Moore, Robert" <robert.moore@intel.com>
References: <200712271903.53961.rjw@sisk.pl>
In-Reply-To: <200712271903.53961.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712271913.43660.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

On ACPI systems the target state set by acpi_pm_set_target() is
reset by acpi_pm_finish(), but that need not be called in the
suspend fails.  For this reason, we need an additional global suspend
callback that will reset the target state regardless of whether or
not the suspend is successful.  Also, it is reasonable to rename the
.set_target() global suspend callback, since it will be used for a
different purpose on ACPI 1.0x systems.

Introduce the global suspend callback .close() to be executed at the
end of the suspend sequence and rename the .set_target() global
suspend callback to .open().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-at91/pm.c                   |    8 ++++----
 arch/powerpc/platforms/52xx/lite5200_pm.c |    4 ++--
 drivers/acpi/sleep/main.c                 |   22 ++++++++++++++++++----
 include/linux/suspend.h                   |   24 ++++++++++++++----------
 kernel/power/main.c                       |    9 ++++++---
 5 files changed, 44 insertions(+), 23 deletions(-)

Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h
+++ linux-2.6/include/linux/suspend.h
@@ -38,18 +38,16 @@ typedef int __bitwise suspend_state_t;
  *	There is the %suspend_valid_only_mem function available that can be
  *	assigned to this if the platform only supports mem sleep.
  *
- * @set_target: Tell the platform which system sleep state is going to be
- *	entered.
- *	@set_target() is executed right prior to suspending devices.  The
- *	information conveyed to the platform code by @set_target() should be
- *	disregarded by the platform as soon as @finish() is executed and if
- *	@prepare() fails.  If @set_target() fails (ie. returns nonzero),
+ * @open: Initialise a transition to given system sleep state.
+ *	@open() is executed right prior to suspending devices.  The information
+ *	conveyed to the platform code by @open() should be disregarded by it as
+ *	soon as @close() is executed.  If @open() fails (ie. returns nonzero),
  *	@prepare(), @enter() and @finish() will not be called by the PM core.
  *	This callback is optional.  However, if it is implemented, the argument
  *	passed to @enter() is meaningless and should be ignored.
  *
  * @prepare: Prepare the platform for entering the system sleep state indicated
- *	by @set_target().
+ *	by @open().
  *	@prepare() is called right after devices have been suspended (ie. the
  *	appropriate .suspend() method has been executed for each device) and
  *	before the nonboot CPUs are disabled (it is executed with IRQs enabled).
@@ -57,8 +55,8 @@ typedef int __bitwise suspend_state_t;
  *	error code otherwise, in which case the system cannot enter the desired
  *	sleep state (@enter() and @finish() will not be called in that case).
  *
- * @enter: Enter the system sleep state indicated by @set_target() or
- *	represented by the argument if @set_target() is not implemented.
+ * @enter: Enter the system sleep state indicated by @open() or represented by
+ *	the argument if @open() is not implemented.
  *	This callback is mandatory.  It returns 0 on success or a negative
  *	error code otherwise, in which case the system cannot enter the desired
  *	sleep state.
@@ -69,13 +67,19 @@ typedef int __bitwise suspend_state_t;
  *	This callback is optional, but should be implemented by the platforms
  *	that implement @prepare().  If implemented, it is always called after
  *	@enter() (even if @enter() fails).
+ *
+ * @close: Called by the PM core right after resuming devices, to indicate to
+ *	the platform that the system has returned to the working state.
+ *	This callback is optional, but should be implemented by the platforms
+ *	that implement @open().
  */
 struct platform_suspend_ops {
 	int (*valid)(suspend_state_t state);
-	int (*set_target)(suspend_state_t state);
+	int (*open)(suspend_state_t state);
 	int (*prepare)(void);
 	int (*enter)(suspend_state_t state);
 	void (*finish)(void);
+	void (*close)(void);
 };
 
 #ifdef CONFIG_SUSPEND
Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c
+++ linux-2.6/drivers/acpi/sleep/main.c
@@ -63,11 +63,11 @@ static u32 acpi_suspend_states[] = {
 static int init_8259A_after_S1;
 
 /**
- *	acpi_pm_set_target - Set the target system sleep state to the state
+ *	acpi_pm_open - Set the target system sleep state to the state
  *		associated with given @pm_state, if supported.
  */
 
-static int acpi_pm_set_target(suspend_state_t pm_state)
+static int acpi_pm_open(suspend_state_t pm_state)
 {
 	u32 acpi_state = acpi_suspend_states[pm_state];
 	int error = 0;
@@ -164,7 +164,7 @@ static int acpi_pm_enter(suspend_state_t
 }
 
 /**
- *	acpi_pm_finish - Finish up suspend sequence.
+ *	acpi_pm_finish - Instruct the platform to leave a sleep state.
  *
  *	This is called after we wake back up (or if entering the sleep state
  *	failed). 
@@ -190,6 +190,19 @@ static void acpi_pm_finish(void)
 #endif
 }
 
+/**
+ *	acpi_pm_close - Finish up suspend sequence.
+ */
+
+static void acpi_pm_close(void)
+{
+	/*
+	 * This is necessary in case acpi_pm_finish() is not called during a
+	 * failing transition to a sleep state.
+	 */
+	acpi_target_sleep_state = ACPI_STATE_S0;
+}
+
 static int acpi_pm_state_valid(suspend_state_t pm_state)
 {
 	u32 acpi_state;
@@ -208,10 +221,11 @@ static int acpi_pm_state_valid(suspend_s
 
 static struct platform_suspend_ops acpi_pm_ops = {
 	.valid = acpi_pm_state_valid,
-	.set_target = acpi_pm_set_target,
+	.open = acpi_pm_open,
 	.prepare = acpi_pm_prepare,
 	.enter = acpi_pm_enter,
 	.finish = acpi_pm_finish,
+	.close = acpi_pm_close,
 };
 
 /*
Index: linux-2.6/arch/arm/mach-at91/pm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-at91/pm.c
+++ linux-2.6/arch/arm/mach-at91/pm.c
@@ -52,7 +52,7 @@ static suspend_state_t target_state;
 /*
  * Called after processes are frozen, but before we shutdown devices.
  */
-static int at91_pm_set_target(suspend_state_t state)
+static int at91_pm_open(suspend_state_t state)
 {
 	target_state = state;
 	return 0;
@@ -199,9 +199,9 @@ error:
 
 
 static struct platform_suspend_ops at91_pm_ops ={
-	.valid		= at91_pm_valid_state,
-	.set_target	= at91_pm_set_target,
-	.enter		= at91_pm_enter,
+	.valid	= at91_pm_valid_state,
+	.open	= at91_pm_open,
+	.enter	= at91_pm_enter,
 };
 
 static int __init at91_pm_init(void)
Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -253,10 +253,10 @@ int suspend_devices_and_enter(suspend_st
 	if (!suspend_ops)
 		return -ENOSYS;
 
-	if (suspend_ops->set_target) {
-		error = suspend_ops->set_target(state);
+	if (suspend_ops->open) {
+		error = suspend_ops->open(state);
 		if (error)
-			return error;
+			goto Close;
 	}
 	suspend_console();
 	error = device_suspend(PMSG_SUSPEND);
@@ -289,6 +289,9 @@ int suspend_devices_and_enter(suspend_st
 	device_resume();
  Resume_console:
 	resume_console();
+ Close:
+	if (suspend_ops->close)
+		suspend_ops->close();
 	return error;
 }
 
Index: linux-2.6/arch/powerpc/platforms/52xx/lite5200_pm.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/52xx/lite5200_pm.c
+++ linux-2.6/arch/powerpc/platforms/52xx/lite5200_pm.c
@@ -31,7 +31,7 @@ static int lite5200_pm_valid(suspend_sta
 	}
 }
 
-static int lite5200_pm_set_target(suspend_state_t state)
+static int lite5200_pm_open(suspend_state_t state)
 {
 	if (lite5200_pm_valid(state)) {
 		lite5200_pm_target_state = state;
@@ -210,7 +210,7 @@ static void lite5200_pm_finish(void)
 
 static struct platform_suspend_ops lite5200_pm_ops = {
 	.valid		= lite5200_pm_valid,
-	.set_target	= lite5200_pm_set_target,
+	.open		= lite5200_pm_open,
 	.prepare	= lite5200_pm_prepare,
 	.enter		= lite5200_pm_enter,
 	.finish		= lite5200_pm_finish,
