Return-Path: <linux-kernel-owner+w=401wt.eu-S935915AbYBAE6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935915AbYBAE6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932427AbYBAEnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:43:22 -0500
Received: from mga10.intel.com ([192.55.52.92]:64964 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758188AbYBAEl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:41:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516615"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [PATCH 26/37] Suspend: Introduce begin() and end() callbacks
Date: Thu, 31 Jan 2008 23:36:57 -0500
Message-Id: <68db114effdf54dd7fc0c724ab2aef5bc98d9c79.1201840183.git.len.brown@intel.com>
X-Mailer: git-send-email 1.5.4.rc5.16.gc0279
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
In-Reply-To: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
References: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

On ACPI systems the target state set by acpi_pm_set_target() is
reset by acpi_pm_finish(), but that need not be called if the
suspend fails.  All platforms that use the .set_target() global
suspend callback are affected by analogous issues.

For this reason, we need an additional global suspend callback that
will reset the target state regardless of whether or not the suspend
is successful.  Also, it is reasonable to rename the .set_target()
callback, since it will be used for a different purpose on ACPI
systems (due to ACPI 1.0x code ordering requirements).

Introduce the global suspend callback .end() to be executed at the
end of the suspend sequence and rename the .set_target() global
suspend callback to .begin().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/arm/mach-at91/pm.c                   |   17 +++++++++++++----
 arch/powerpc/platforms/52xx/lite5200_pm.c |   10 ++++++++--
 drivers/acpi/sleep/main.c                 |   22 ++++++++++++++++++----
 include/linux/suspend.h                   |   29 ++++++++++++++++++-----------
 kernel/power/main.c                       |    9 ++++++---
 5 files changed, 63 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 4b120cc..a67defd 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -52,7 +52,7 @@ static suspend_state_t target_state;
 /*
  * Called after processes are frozen, but before we shutdown devices.
  */
-static int at91_pm_set_target(suspend_state_t state)
+static int at91_pm_begin(suspend_state_t state)
 {
 	target_state = state;
 	return 0;
@@ -202,11 +202,20 @@ error:
 	return 0;
 }
 
+/*
+ * Called right prior to thawing processes.
+ */
+static void at91_pm_end(void)
+{
+	target_state = PM_SUSPEND_ON;
+}
+
 
 static struct platform_suspend_ops at91_pm_ops ={
-	.valid		= at91_pm_valid_state,
-	.set_target	= at91_pm_set_target,
-	.enter		= at91_pm_enter,
+	.valid	= at91_pm_valid_state,
+	.begin	= at91_pm_begin,
+	.enter	= at91_pm_enter,
+	.end	= at91_pm_end,
 };
 
 static int __init at91_pm_init(void)
diff --git a/arch/powerpc/platforms/52xx/lite5200_pm.c b/arch/powerpc/platforms/52xx/lite5200_pm.c
index c0f13e8..41c7fd9 100644
--- a/arch/powerpc/platforms/52xx/lite5200_pm.c
+++ b/arch/powerpc/platforms/52xx/lite5200_pm.c
@@ -31,7 +31,7 @@ static int lite5200_pm_valid(suspend_state_t state)
 	}
 }
 
-static int lite5200_pm_set_target(suspend_state_t state)
+static int lite5200_pm_begin(suspend_state_t state)
 {
 	if (lite5200_pm_valid(state)) {
 		lite5200_pm_target_state = state;
@@ -219,12 +219,18 @@ static void lite5200_pm_finish(void)
 		mpc52xx_pm_finish();
 }
 
+static void lite5200_pm_end(void)
+{
+	lite5200_pm_target_state = PM_SUSPEND_ON;
+}
+
 static struct platform_suspend_ops lite5200_pm_ops = {
 	.valid		= lite5200_pm_valid,
-	.set_target	= lite5200_pm_set_target,
+	.begin		= lite5200_pm_begin,
 	.prepare	= lite5200_pm_prepare,
 	.enter		= lite5200_pm_enter,
 	.finish		= lite5200_pm_finish,
+	.end		= lite5200_pm_end,
 };
 
 int __init lite5200_pm_init(void)
diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index 96d23b3..e2e4e61 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -63,11 +63,11 @@ static u32 acpi_suspend_states[] = {
 static int init_8259A_after_S1;
 
 /**
- *	acpi_pm_set_target - Set the target system sleep state to the state
+ *	acpi_pm_begin - Set the target system sleep state to the state
  *		associated with given @pm_state, if supported.
  */
 
-static int acpi_pm_set_target(suspend_state_t pm_state)
+static int acpi_pm_begin(suspend_state_t pm_state)
 {
 	u32 acpi_state = acpi_suspend_states[pm_state];
 	int error = 0;
@@ -164,7 +164,7 @@ static int acpi_pm_enter(suspend_state_t pm_state)
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
+ *	acpi_pm_end - Finish up suspend sequence.
+ */
+
+static void acpi_pm_end(void)
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
@@ -208,10 +221,11 @@ static int acpi_pm_state_valid(suspend_state_t pm_state)
 
 static struct platform_suspend_ops acpi_pm_ops = {
 	.valid = acpi_pm_state_valid,
-	.set_target = acpi_pm_set_target,
+	.begin = acpi_pm_begin,
 	.prepare = acpi_pm_prepare,
 	.enter = acpi_pm_enter,
 	.finish = acpi_pm_finish,
+	.end = acpi_pm_end,
 };
 
 /*
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 51283e0..a0b1dbb 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
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
+ * @begin: Initialise a transition to given system sleep state.
+ *	@begin() is executed right prior to suspending devices.  The information
+ *	conveyed to the platform code by @begin() should be disregarded by it as
+ *	soon as @end() is executed.  If @begin() fails (ie. returns nonzero),
  *	@prepare(), @enter() and @finish() will not be called by the PM core.
  *	This callback is optional.  However, if it is implemented, the argument
- *	passed to @enter() is meaningless and should be ignored.
+ *	passed to @enter() is redundant and should be ignored.
  *
  * @prepare: Prepare the platform for entering the system sleep state indicated
- *	by @set_target().
+ *	by @begin().
  *	@prepare() is called right after devices have been suspended (ie. the
  *	appropriate .suspend() method has been executed for each device) and
  *	before the nonboot CPUs are disabled (it is executed with IRQs enabled).
@@ -57,8 +55,8 @@ typedef int __bitwise suspend_state_t;
  *	error code otherwise, in which case the system cannot enter the desired
  *	sleep state (@enter() and @finish() will not be called in that case).
  *
- * @enter: Enter the system sleep state indicated by @set_target() or
- *	represented by the argument if @set_target() is not implemented.
+ * @enter: Enter the system sleep state indicated by @begin() or represented by
+ *	the argument if @begin() is not implemented.
  *	This callback is mandatory.  It returns 0 on success or a negative
  *	error code otherwise, in which case the system cannot enter the desired
  *	sleep state.
@@ -69,13 +67,22 @@ typedef int __bitwise suspend_state_t;
  *	This callback is optional, but should be implemented by the platforms
  *	that implement @prepare().  If implemented, it is always called after
  *	@enter() (even if @enter() fails).
+ *
+ * @end: Called by the PM core right after resuming devices, to indicate to
+ *	the platform that the system has returned to the working state or
+ *	the transition to the sleep state has been aborted.
+ *	This callback is optional, but should be implemented by the platforms
+ *	that implement @begin(), but platforms implementing @begin() should
+ *	also provide a @end() which cleans up transitions aborted before
+ *	@enter().
  */
 struct platform_suspend_ops {
 	int (*valid)(suspend_state_t state);
-	int (*set_target)(suspend_state_t state);
+	int (*begin)(suspend_state_t state);
 	int (*prepare)(void);
 	int (*enter)(suspend_state_t state);
 	void (*finish)(void);
+	void (*end)(void);
 };
 
 #ifdef CONFIG_SUSPEND
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 050a607..d9bba45 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -258,10 +258,10 @@ int suspend_devices_and_enter(suspend_state_t state)
 	if (!suspend_ops)
 		return -ENOSYS;
 
-	if (suspend_ops->set_target) {
-		error = suspend_ops->set_target(state);
+	if (suspend_ops->begin) {
+		error = suspend_ops->begin(state);
 		if (error)
-			return error;
+			goto Close;
 	}
 	suspend_console();
 	error = device_suspend(PMSG_SUSPEND);
@@ -294,6 +294,9 @@ int suspend_devices_and_enter(suspend_state_t state)
 	device_resume();
  Resume_console:
 	resume_console();
+ Close:
+	if (suspend_ops->end)
+		suspend_ops->end();
 	return error;
 }
 
-- 
1.5.4.rc5.16.gc0279

