Return-Path: <linux-kernel-owner+w=401wt.eu-S964826AbXGQUr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826AbXGQUr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935976AbXGQUmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:42:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50083 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935458AbXGQUmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:42:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [Resend][PATCH 5/9] PM: Rework struct platform_suspend_ops
Date: Tue, 17 Jul 2007 22:44:26 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Len Brown <len.brown@intel.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Shaohua Li <shaohua.li@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Paul Mackerras <paulus@samba.org>, Russell King <rmk@arm.linux.org.uk>
References: <200707172236.28895.rjw@sisk.pl>
In-Reply-To: <200707172236.28895.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707172244.27305.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

There is no reason why the .prepare() and .finish() methods in 'struct
platform_suspend_ops' should take any arguments, since architectures
don't use these methods' argument in any practically meaningful way (ie. either
the target system sleep state is conveyed to the platform by .set_target(), or
there is only one suspend state supported and it is indicated to the PM core by
.valid(), or .prepare() and .finish() aren't defined at all).  There also is
no reason why .finish() should return any result.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 arch/arm/mach-omap1/pm.c                 |   20 +-----------
 arch/arm/mach-omap2/pm.c                 |   20 +-----------
 arch/blackfin/mach-common/pm.c           |   49 +++----------------------------
 arch/powerpc/platforms/52xx/mpc52xx_pm.c |    9 +----
 drivers/acpi/sleep/main.c                |    7 +---
 include/asm-arm/arch-pxa/pm.h            |    1 
 include/linux/suspend.h                  |   13 +++-----
 kernel/power/main.c                      |   12 +------
 8 files changed, 24 insertions(+), 107 deletions(-)

Index: linux-2.6.22-git5/include/linux/suspend.h
===================================================================
--- linux-2.6.22-git5.orig/include/linux/suspend.h
+++ linux-2.6.22-git5/include/linux/suspend.h
@@ -45,12 +45,10 @@ typedef int __bitwise suspend_state_t;
  *	@prepare() fails.  If @set_target() fails (ie. returns nonzero),
  *	@prepare(), @enter() and @finish() will not be called by the PM core.
  *	This callback is optional.  However, if it is implemented, the argument
- *	passed to @prepare(), @enter() and @finish() is meaningless and should
- *	be ignored.
+ *	passed to @enter() is meaningless and should be ignored.
  *
  * @prepare: Prepare the platform for entering the system sleep state indicated
- *	by @set_target() or represented by the argument if @set_target() is not
- *	implemented.
+ *	by @set_target().
  *	@prepare() is called right after devices have been suspended (ie. the
  *	appropriate .suspend() method has been executed for each device) and
  *	before the nonboot CPUs are disabled (it is executed with IRQs enabled).
@@ -66,8 +64,7 @@ typedef int __bitwise suspend_state_t;
  *
  * @finish: Called when the system has just left a sleep state, right after
  *	the nonboot CPUs have been enabled and before devices are resumed (it is
- *	executed with IRQs enabled).  If @set_target() is not implemented, the
- *	argument represents the sleep state being left.
+ *	executed with IRQs enabled).
  *	This callback is optional, but should be implemented by the platforms
  *	that implement @prepare().  If implemented, it is always called after
  *	@enter() (even if @enter() fails).
@@ -75,9 +72,9 @@ typedef int __bitwise suspend_state_t;
 struct platform_suspend_ops {
 	int (*valid)(suspend_state_t state);
 	int (*set_target)(suspend_state_t state);
-	int (*prepare)(suspend_state_t state);
+	int (*prepare)(void);
 	int (*enter)(suspend_state_t state);
-	int (*finish)(suspend_state_t state);
+	void (*finish)(void);
 };
 
 extern struct platform_suspend_ops *suspend_ops;
Index: linux-2.6.22-git5/kernel/power/main.c
===================================================================
--- linux-2.6.22-git5.orig/kernel/power/main.c
+++ linux-2.6.22-git5/kernel/power/main.c
@@ -56,13 +56,6 @@ int suspend_valid_only_mem(suspend_state
 	return state == PM_SUSPEND_MEM;
 }
 
-
-static inline void pm_finish(suspend_state_t state)
-{
-	if (suspend_ops->finish)
-		suspend_ops->finish(state);
-}
-
 /**
  *	suspend_prepare - Do prep work before entering low-power state.
  *
@@ -169,7 +162,7 @@ int suspend_devices_and_enter(suspend_st
 		goto Resume_console;
 	}
 	if (suspend_ops->prepare) {
-		error = suspend_ops->prepare(state);
+		error = suspend_ops->prepare();
 		if (error)
 			goto Resume_devices;
 	}
@@ -178,7 +171,8 @@ int suspend_devices_and_enter(suspend_st
 		suspend_enter(state);
 
 	enable_nonboot_cpus();
-	pm_finish(state);
+	if (suspend_ops->finish)
+		suspend_ops->finish();
  Resume_devices:
 	device_resume();
  Resume_console:
Index: linux-2.6.22-git5/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.22-git5.orig/drivers/acpi/sleep/main.c
+++ linux-2.6.22-git5/drivers/acpi/sleep/main.c
@@ -61,13 +61,12 @@ static int acpi_pm_set_target(suspend_st
 
 /**
  *	acpi_pm_prepare - Do preliminary suspend work.
- *	@pm_state: ignored
  *
  *	If necessary, set the firmware waking vector and do arch-specific
  *	nastiness to get the wakeup code to the waking vector.
  */
 
-static int acpi_pm_prepare(suspend_state_t pm_state)
+static int acpi_pm_prepare(void)
 {
 	int error = acpi_sleep_prepare(acpi_target_sleep_state);
 
@@ -137,13 +136,12 @@ static int acpi_pm_enter(suspend_state_t
 
 /**
  *	acpi_pm_finish - Finish up suspend sequence.
- *	@pm_state: ignored
  *
  *	This is called after we wake back up (or if entering the sleep state
  *	failed). 
  */
 
-static int acpi_pm_finish(suspend_state_t pm_state)
+static void acpi_pm_finish(void)
 {
 	u32 acpi_state = acpi_target_sleep_state;
 
@@ -159,7 +157,6 @@ static int acpi_pm_finish(suspend_state_
 		printk("Broken toshiba laptop -> kicking interrupts\n");
 		init_8259A(0);
 	}
-	return 0;
 }
 
 int acpi_suspend(u32 acpi_state)
Index: linux-2.6.22-git5/include/asm-arm/arch-pxa/pm.h
===================================================================
--- linux-2.6.22-git5.orig/include/asm-arm/arch-pxa/pm.h
+++ linux-2.6.22-git5/include/asm-arm/arch-pxa/pm.h
@@ -9,5 +9,4 @@
 
 #include <linux/suspend.h>
 
-extern int pxa_pm_prepare(suspend_state_t state);
 extern int pxa_pm_enter(suspend_state_t state);
Index: linux-2.6.22-git5/arch/arm/mach-omap1/pm.c
===================================================================
--- linux-2.6.22-git5.orig/arch/arm/mach-omap1/pm.c
+++ linux-2.6.22-git5/arch/arm/mach-omap1/pm.c
@@ -613,27 +613,15 @@ static void (*saved_idle)(void) = NULL;
 
 /*
  *	omap_pm_prepare - Do preliminary suspend work.
- *	@state:		suspend state we're entering.
  *
  */
-static int omap_pm_prepare(suspend_state_t state)
+static int omap_pm_prepare(void)
 {
-	int error = 0;
-
 	/* We cannot sleep in idle until we have resumed */
 	saved_idle = pm_idle;
 	pm_idle = NULL;
 
-	switch (state)
-	{
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return error;
+	return 0;
 }
 
 
@@ -661,16 +649,14 @@ static int omap_pm_enter(suspend_state_t
 
 /**
  *	omap_pm_finish - Finish up suspend sequence.
- *	@state:		State we're coming out of.
  *
  *	This is called after we wake back up (or if entering the sleep state
  *	failed).
  */
 
-static int omap_pm_finish(suspend_state_t state)
+static void omap_pm_finish(void)
 {
 	pm_idle = saved_idle;
-	return 0;
 }
 
 
Index: linux-2.6.22-git5/arch/arm/mach-omap2/pm.c
===================================================================
--- linux-2.6.22-git5.orig/arch/arm/mach-omap2/pm.c
+++ linux-2.6.22-git5/arch/arm/mach-omap2/pm.c
@@ -70,25 +70,12 @@ void omap2_pm_idle(void)
 	local_irq_enable();
 }
 
-static int omap2_pm_prepare(suspend_state_t state)
+static int omap2_pm_prepare(void)
 {
-	int error = 0;
-
 	/* We cannot sleep in idle until we have resumed */
 	saved_idle = pm_idle;
 	pm_idle = NULL;
-
-	switch (state)
-	{
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	return error;
+	return 0;
 }
 
 #define INT0_WAKE_MASK	(OMAP_IRQ_BIT(INT_24XX_GPIO_BANK1) |	\
@@ -356,10 +343,9 @@ static int omap2_pm_enter(suspend_state_
 	return ret;
 }
 
-static int omap2_pm_finish(suspend_state_t state)
+static void omap2_pm_finish(void)
 {
 	pm_idle = saved_idle;
-	return 0;
 }
 
 static struct platform_suspend_ops omap_pm_ops = {
Index: linux-2.6.22-git5/arch/blackfin/mach-common/pm.c
===================================================================
--- linux-2.6.22-git5.orig/arch/blackfin/mach-common/pm.c
+++ linux-2.6.22-git5/arch/blackfin/mach-common/pm.c
@@ -89,28 +89,15 @@ void bfin_pm_suspend_standby_enter(void)
 #endif				/* CONFIG_PM_WAKEUP_GPIO_BY_SIC_IWR */
 }
 
-
 /*
- *	bfin_pm_prepare - Do preliminary suspend work.
- *	@state:		suspend state we're entering.
+ *	bfin_pm_valid - Tell the PM core that we only support the standby sleep
+ *			state
+ *	@state:		suspend state we're checking.
  *
  */
-static int bfin_pm_prepare(suspend_state_t state)
+static int bfin_pm_valid(suspend_state_t state)
 {
-	int error = 0;
-
-	switch (state) {
-	case PM_SUSPEND_STANDBY:
-		break;
-
-	case PM_SUSPEND_MEM:
-		return -ENOTSUPP;
-
-	default:
-		return -EINVAL;
-	}
-
-	return error;
+	return (state == PM_SUSPEND_STANDBY);
 }
 
 /*
@@ -135,33 +122,9 @@ static int bfin_pm_enter(suspend_state_t
 	return 0;
 }
 
-/*
- *	bfin_pm_finish - Finish up suspend sequence.
- *	@state:		State we're coming out of.
- *
- *	This is called after we wake back up (or if entering the sleep state
- *	failed).
- */
-static int bfin_pm_finish(suspend_state_t state)
-{
-	switch (state) {
-	case PM_SUSPEND_STANDBY:
-		break;
-
-	case PM_SUSPEND_MEM:
-		return -ENOTSUPP;
-
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 struct platform_suspend_ops bfin_pm_ops = {
-	.prepare = bfin_pm_prepare,
+	.valid = bfin_pm_valid,
 	.enter = bfin_pm_enter,
-	.finish = bfin_pm_finish,
 };
 
 static int __init bfin_pm_init(void)
Index: linux-2.6.22-git5/arch/powerpc/platforms/52xx/mpc52xx_pm.c
===================================================================
--- linux-2.6.22-git5.orig/arch/powerpc/platforms/52xx/mpc52xx_pm.c
+++ linux-2.6.22-git5/arch/powerpc/platforms/52xx/mpc52xx_pm.c
@@ -57,11 +57,8 @@ int mpc52xx_set_wakeup_gpio(u8 pin, u8 l
 	return 0;
 }
 
-int mpc52xx_pm_prepare(suspend_state_t state)
+static int mpc52xx_pm_prepare(void)
 {
-	if (state != PM_SUSPEND_STANDBY)
-		return -EINVAL;
-
 	/* map the whole register space */
 	mbar = mpc52xx_find_and_map("mpc5200");
 	if (!mbar) {
@@ -166,15 +163,13 @@ int mpc52xx_pm_enter(suspend_state_t sta
 	return 0;
 }
 
-int mpc52xx_pm_finish(suspend_state_t state)
+static void mpc52xx_pm_finish(void)
 {
 	/* call board resume code */
 	if (mpc52xx_suspend.board_resume_finish)
 		mpc52xx_suspend.board_resume_finish(mbar);
 
 	iounmap(mbar);
-
-	return 0;
 }
 
 static struct platform_suspend_ops mpc52xx_pm_ops = {

