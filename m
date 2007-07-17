Return-Path: <linux-kernel-owner+w=401wt.eu-S936269AbXGQUnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936269AbXGQUnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934525AbXGQUmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:42:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50052 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764423AbXGQUmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:42:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [Resend][PATCH 4/9] PM: Rename struct pm_ops and related things
Date: Tue, 17 Jul 2007 22:43:06 +0200
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
Message-Id: <200707172243.07862.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The name of 'struct pm_ops' suggests that it is related to the power management
in general, but in fact it is only related to suspend.  Moreover, its name
should indicate what this structure is used for, so it seems reasonable to
change it to 'struct platform_suspend_ops'.  In that case, the name of
the global variable of this type used by the PM core and the names of related
functions should be changed accordingly.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 Documentation/power/interface.txt        |    2 -
 arch/arm/common/sharpsl_pm.c             |    8 +++----
 arch/arm/mach-at91/pm.c                  |    4 +--
 arch/arm/mach-omap1/pm.c                 |    6 ++---
 arch/arm/mach-omap2/pm.c                 |    6 ++---
 arch/arm/mach-pnx4008/pm.c               |    4 +--
 arch/arm/mach-pxa/pxa25x.c               |    6 ++---
 arch/arm/mach-pxa/pxa27x.c               |    4 +--
 arch/arm/mach-sa1100/pm.c                |    6 ++---
 arch/arm/plat-s3c24xx/pm.c               |    6 ++---
 arch/blackfin/mach-common/pm.c           |    4 +--
 arch/powerpc/platforms/52xx/mpc52xx_pm.c |    4 +--
 arch/sh/boards/hp6xx/pm.c                |    6 ++---
 drivers/acpi/sleep/main.c                |    6 ++---
 include/linux/suspend.h                  |   20 +++++++++---------
 kernel/power/main.c                      |   34 +++++++++++++++----------------
 16 files changed, 63 insertions(+), 63 deletions(-)

Index: linux-2.6.22-git5/include/linux/suspend.h
===================================================================
--- linux-2.6.22-git5.orig/include/linux/suspend.h
+++ linux-2.6.22-git5/include/linux/suspend.h
@@ -26,16 +26,16 @@ typedef int __bitwise suspend_state_t;
 #define PM_SUSPEND_MAX		((__force suspend_state_t) 4)
 
 /**
- * struct pm_ops - Callbacks for managing platform dependent system sleep
- *	states.
+ * struct platform_suspend_ops - Callbacks for managing platform dependent
+ *	system sleep states.
  *
  * @valid: Callback to determine if given system sleep state is supported by
  *	the platform.
  *	Valid (ie. supported) states are advertised in /sys/power/state.  Note
  *	that it still may be impossible to enter given system sleep state if the
  *	conditions aren't right.
- *	There is the %pm_valid_only_mem function available that can be assigned
- *	to this if the platform only supports mem sleep.
+ *	There is the %suspend_valid_only_mem function available that can be
+ *	assigned to this if the platform only supports mem sleep.
  *
  * @set_target: Tell the platform which system sleep state is going to be
  *	entered.
@@ -72,7 +72,7 @@ typedef int __bitwise suspend_state_t;
  *	that implement @prepare().  If implemented, it is always called after
  *	@enter() (even if @enter() fails).
  */
-struct pm_ops {
+struct platform_suspend_ops {
 	int (*valid)(suspend_state_t state);
 	int (*set_target)(suspend_state_t state);
 	int (*prepare)(suspend_state_t state);
@@ -80,14 +80,14 @@ struct pm_ops {
 	int (*finish)(suspend_state_t state);
 };
 
-extern struct pm_ops *pm_ops;
+extern struct platform_suspend_ops *suspend_ops;
 
 /**
- * pm_set_ops - set platform dependent power management ops
- * @pm_ops: The new power management operations to set.
+ * suspend_set_ops - set platform dependent suspend operations
+ * @ops: The new suspend operations to set.
  */
-extern void pm_set_ops(struct pm_ops *pm_ops);
-extern int pm_valid_only_mem(suspend_state_t state);
+extern void suspend_set_ops(struct platform_suspend_ops *ops);
+extern int suspend_valid_only_mem(suspend_state_t state);
 
 /**
  * arch_suspend_disable_irqs - disable IRQs for suspend
Index: linux-2.6.22-git5/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.22-git5.orig/drivers/acpi/sleep/main.c
+++ linux-2.6.22-git5/drivers/acpi/sleep/main.c
@@ -21,7 +21,7 @@
 
 u8 sleep_states[ACPI_S_STATE_COUNT];
 
-static struct pm_ops acpi_pm_ops;
+static struct platform_suspend_ops acpi_pm_ops;
 
 extern void do_suspend_lowlevel(void);
 
@@ -193,7 +193,7 @@ static int acpi_pm_state_valid(suspend_s
 	}
 }
 
-static struct pm_ops acpi_pm_ops = {
+static struct platform_suspend_ops acpi_pm_ops = {
 	.valid = acpi_pm_state_valid,
 	.set_target = acpi_pm_set_target,
 	.prepare = acpi_pm_prepare,
@@ -368,7 +368,7 @@ int __init acpi_sleep_init(void)
 	}
 	printk(")\n");
 
-	pm_set_ops(&acpi_pm_ops);
+	suspend_set_ops(&acpi_pm_ops);
 
 #ifdef CONFIG_SOFTWARE_SUSPEND
 	if (sleep_states[ACPI_STATE_S4])
Index: linux-2.6.22-git5/kernel/power/main.c
===================================================================
--- linux-2.6.22-git5.orig/kernel/power/main.c
+++ linux-2.6.22-git5/kernel/power/main.c
@@ -30,28 +30,28 @@ BLOCKING_NOTIFIER_HEAD(pm_chain_head);
 
 DEFINE_MUTEX(pm_mutex);
 
-struct pm_ops *pm_ops;
+struct platform_suspend_ops *suspend_ops;
 
 /**
- *	pm_set_ops - Set the global power method table. 
+ *	suspend_set_ops - Set the global suspend method table.
  *	@ops:	Pointer to ops structure.
  */
 
-void pm_set_ops(struct pm_ops * ops)
+void suspend_set_ops(struct platform_suspend_ops *ops)
 {
 	mutex_lock(&pm_mutex);
-	pm_ops = ops;
+	suspend_ops = ops;
 	mutex_unlock(&pm_mutex);
 }
 
 /**
- * pm_valid_only_mem - generic memory-only valid callback
+ * suspend_valid_only_mem - generic memory-only valid callback
  *
- * pm_ops drivers that implement mem suspend only and only need
+ * Platform drivers that implement mem suspend only and only need
  * to check for that in their .valid callback can use this instead
  * of rolling their own .valid callback.
  */
-int pm_valid_only_mem(suspend_state_t state)
+int suspend_valid_only_mem(suspend_state_t state)
 {
 	return state == PM_SUSPEND_MEM;
 }
@@ -59,8 +59,8 @@ int pm_valid_only_mem(suspend_state_t st
 
 static inline void pm_finish(suspend_state_t state)
 {
-	if (pm_ops->finish)
-		pm_ops->finish(state);
+	if (suspend_ops->finish)
+		suspend_ops->finish(state);
 }
 
 /**
@@ -74,7 +74,7 @@ static int suspend_prepare(void)
 	int error;
 	unsigned int free_pages;
 
-	if (!pm_ops || !pm_ops->enter)
+	if (!suspend_ops || !suspend_ops->enter)
 		return -EPERM;
 
 	error = pm_notifier_call_chain(PM_SUSPEND_PREPARE);
@@ -137,7 +137,7 @@ int suspend_enter(suspend_state_t state)
 		printk(KERN_ERR "Some devices failed to power down\n");
 		goto Done;
 	}
-	error = pm_ops->enter(state);
+	error = suspend_ops->enter(state);
 	device_power_up();
  Done:
 	arch_suspend_enable_irqs();
@@ -154,11 +154,11 @@ int suspend_devices_and_enter(suspend_st
 {
 	int error;
 
-	if (!pm_ops)
+	if (!suspend_ops)
 		return -ENOSYS;
 
-	if (pm_ops->set_target) {
-		error = pm_ops->set_target(state);
+	if (suspend_ops->set_target) {
+		error = suspend_ops->set_target(state);
 		if (error)
 			return error;
 	}
@@ -168,8 +168,8 @@ int suspend_devices_and_enter(suspend_st
 		printk(KERN_ERR "Some devices failed to suspend\n");
 		goto Resume_console;
 	}
-	if (pm_ops->prepare) {
-		error = pm_ops->prepare(state);
+	if (suspend_ops->prepare) {
+		error = suspend_ops->prepare(state);
 		if (error)
 			goto Resume_devices;
 	}
@@ -212,7 +212,7 @@ static inline int valid_state(suspend_st
 	/* All states need lowlevel support and need to be valid
 	 * to the lowlevel implementation, no valid callback
 	 * implies that none are valid. */
-	if (!pm_ops || !pm_ops->valid || !pm_ops->valid(state))
+	if (!suspend_ops || !suspend_ops->valid || !suspend_ops->valid(state))
 		return 0;
 	return 1;
 }
Index: linux-2.6.22-git5/Documentation/power/interface.txt
===================================================================
--- linux-2.6.22-git5.orig/Documentation/power/interface.txt
+++ linux-2.6.22-git5/Documentation/power/interface.txt
@@ -20,7 +20,7 @@ states.
 /sys/power/disk controls the operating mode of the suspend-to-disk
 mechanism. Suspend-to-disk can be handled in several ways. We have a
 few options for putting the system to sleep - using the platform driver
-(e.g. ACPI or other pm_ops), powering off the system or rebooting the
+(e.g. ACPI or other suspend_ops), powering off the system or rebooting the
 system (for testing).
 
 Additionally, /sys/power/disk can be used to turn on one of the two testing
Index: linux-2.6.22-git5/arch/arm/common/sharpsl_pm.c
===================================================================
--- linux-2.6.22-git5.orig/arch/arm/common/sharpsl_pm.c
+++ linux-2.6.22-git5/arch/arm/common/sharpsl_pm.c
@@ -766,9 +766,9 @@ static void sharpsl_apm_get_power_status
 	info->battery_life = sharpsl_pm.battstat.mainbat_percent;
 }
 
-static struct pm_ops sharpsl_pm_ops = {
+static struct platform_suspend_ops sharpsl_pm_ops = {
 	.enter		= corgi_pxa_pm_enter,
-	.valid		= pm_valid_only_mem,
+	.valid		= suspend_valid_only_mem,
 };
 
 static int __init sharpsl_pm_probe(struct platform_device *pdev)
@@ -800,7 +800,7 @@ static int __init sharpsl_pm_probe(struc
 
 	apm_get_power_status = sharpsl_apm_get_power_status;
 
-	pm_set_ops(&sharpsl_pm_ops);
+	suspend_set_ops(&sharpsl_pm_ops);
 
 	mod_timer(&sharpsl_pm.ac_timer, jiffies + msecs_to_jiffies(250));
 
@@ -809,7 +809,7 @@ static int __init sharpsl_pm_probe(struc
 
 static int sharpsl_pm_remove(struct platform_device *pdev)
 {
-	pm_set_ops(NULL);
+	suspend_set_ops(NULL);
 
 	device_remove_file(&pdev->dev, &dev_attr_battery_percentage);
 	device_remove_file(&pdev->dev, &dev_attr_battery_voltage);
Index: linux-2.6.22-git5/arch/arm/mach-at91/pm.c
===================================================================
--- linux-2.6.22-git5.orig/arch/arm/mach-at91/pm.c
+++ linux-2.6.22-git5/arch/arm/mach-at91/pm.c
@@ -198,7 +198,7 @@ error:
 }
 
 
-static struct pm_ops at91_pm_ops ={
+static struct platform_suspend_ops at91_pm_ops ={
 	.valid		= at91_pm_valid_state,
 	.set_target	= at91_pm_set_target,
 	.enter		= at91_pm_enter,
@@ -219,7 +219,7 @@ static int __init at91_pm_init(void)
 	/* Disable SDRAM low-power mode.  Cannot be used with self-refresh. */
 	at91_sys_write(AT91_SDRAMC_LPR, 0);
 
-	pm_set_ops(&at91_pm_ops);
+	suspend_set_ops(&at91_pm_ops);
 
 	return 0;
 }
Index: linux-2.6.22-git5/arch/arm/mach-omap1/pm.c
===================================================================
--- linux-2.6.22-git5.orig/arch/arm/mach-omap1/pm.c
+++ linux-2.6.22-git5/arch/arm/mach-omap1/pm.c
@@ -687,11 +687,11 @@ static struct irqaction omap_wakeup_irq 
 
 
 
-static struct pm_ops omap_pm_ops ={
+static struct platform_suspend_ops omap_pm_ops ={
 	.prepare	= omap_pm_prepare,
 	.enter		= omap_pm_enter,
 	.finish		= omap_pm_finish,
-	.valid		= pm_valid_only_mem,
+	.valid		= suspend_valid_only_mem,
 };
 
 static int __init omap_pm_init(void)
@@ -748,7 +748,7 @@ static int __init omap_pm_init(void)
 	else if (cpu_is_omap16xx())
 		omap_writel(OMAP1610_IDLECT3_VAL, OMAP1610_IDLECT3);
 
-	pm_set_ops(&omap_pm_ops);
+	suspend_set_ops(&omap_pm_ops);
 
 #if defined(DEBUG) && defined(CONFIG_PROC_FS)
 	omap_pm_init_proc();
Index: linux-2.6.22-git5/arch/arm/mach-omap2/pm.c
===================================================================
--- linux-2.6.22-git5.orig/arch/arm/mach-omap2/pm.c
+++ linux-2.6.22-git5/arch/arm/mach-omap2/pm.c
@@ -362,11 +362,11 @@ static int omap2_pm_finish(suspend_state
 	return 0;
 }
 
-static struct pm_ops omap_pm_ops = {
+static struct platform_suspend_ops omap_pm_ops = {
 	.prepare	= omap2_pm_prepare,
 	.enter		= omap2_pm_enter,
 	.finish		= omap2_pm_finish,
-	.valid		= pm_valid_only_mem,
+	.valid		= suspend_valid_only_mem,
 };
 
 int __init omap2_pm_init(void)
@@ -390,7 +390,7 @@ int __init omap2_pm_init(void)
 	omap2_sram_suspend = omap_sram_push(omap24xx_cpu_suspend,
 					    omap24xx_cpu_suspend_sz);
 
-	pm_set_ops(&omap_pm_ops);
+	suspend_set_ops(&omap_pm_ops);
 	pm_idle = omap2_pm_idle;
 
 	pmdomain_init();
Index: linux-2.6.22-git5/arch/arm/mach-pnx4008/pm.c
===================================================================
--- linux-2.6.22-git5.orig/arch/arm/mach-pnx4008/pm.c
+++ linux-2.6.22-git5/arch/arm/mach-pnx4008/pm.c
@@ -117,7 +117,7 @@ static int pnx4008_pm_valid(suspend_stat
 	       (state == PM_SUSPEND_MEM);
 }
 
-static struct pm_ops pnx4008_pm_ops = {
+static struct platform_suspend_ops pnx4008_pm_ops = {
 	.enter = pnx4008_pm_enter,
 	.valid = pnx4008_pm_valid,
 };
@@ -146,7 +146,7 @@ static int __init pnx4008_pm_init(void)
 		return -ENOMEM;
 	}
 
-	pm_set_ops(&pnx4008_pm_ops);
+	suspend_set_ops(&pnx4008_pm_ops);
 	return 0;
 }
 
Index: linux-2.6.22-git5/arch/arm/mach-sa1100/pm.c
===================================================================
--- linux-2.6.22-git5.orig/arch/arm/mach-sa1100/pm.c
+++ linux-2.6.22-git5/arch/arm/mach-sa1100/pm.c
@@ -122,14 +122,14 @@ unsigned long sleep_phys_sp(void *sp)
 	return virt_to_phys(sp);
 }
 
-static struct pm_ops sa11x0_pm_ops = {
+static struct platform_suspend_ops sa11x0_pm_ops = {
 	.enter		= sa11x0_pm_enter,
-	.valid		= pm_valid_only_mem,
+	.valid		= suspend_valid_only_mem,
 };
 
 static int __init sa11x0_pm_init(void)
 {
-	pm_set_ops(&sa11x0_pm_ops);
+	suspend_set_ops(&sa11x0_pm_ops);
 	return 0;
 }
 
Index: linux-2.6.22-git5/arch/arm/plat-s3c24xx/pm.c
===================================================================
--- linux-2.6.22-git5.orig/arch/arm/plat-s3c24xx/pm.c
+++ linux-2.6.22-git5/arch/arm/plat-s3c24xx/pm.c
@@ -612,9 +612,9 @@ static int s3c2410_pm_enter(suspend_stat
 	return 0;
 }
 
-static struct pm_ops s3c2410_pm_ops = {
+static struct platform_suspend_ops s3c2410_pm_ops = {
 	.enter		= s3c2410_pm_enter,
-	.valid		= pm_valid_only_mem,
+	.valid		= suspend_valid_only_mem,
 };
 
 /* s3c2410_pm_init
@@ -628,6 +628,6 @@ int __init s3c2410_pm_init(void)
 {
 	printk("S3C2410 Power Management, (c) 2004 Simtec Electronics\n");
 
-	pm_set_ops(&s3c2410_pm_ops);
+	suspend_set_ops(&s3c2410_pm_ops);
 	return 0;
 }
Index: linux-2.6.22-git5/arch/arm/mach-pxa/pxa25x.c
===================================================================
--- linux-2.6.22-git5.orig/arch/arm/mach-pxa/pxa25x.c
+++ linux-2.6.22-git5/arch/arm/mach-pxa/pxa25x.c
@@ -126,9 +126,9 @@ void pxa_cpu_pm_enter(suspend_state_t st
 	}
 }
 
-static struct pm_ops pxa25x_pm_ops = {
+static struct platform_suspend_ops pxa25x_pm_ops = {
 	.enter		= pxa_pm_enter,
-	.valid		= pm_valid_only_mem,
+	.valid		= suspend_valid_only_mem,
 };
 #endif
 
@@ -159,7 +159,7 @@ static int __init pxa25x_init(void)
 		if ((ret = pxa_init_dma(16)))
 			return ret;
 #ifdef CONFIG_PM
-		pm_set_ops(&pxa25x_pm_ops);
+		suspend_set_ops(&pxa25x_pm_ops);
 #endif
 		ret = platform_add_devices(pxa25x_devices,
 					   ARRAY_SIZE(pxa25x_devices));
Index: linux-2.6.22-git5/arch/arm/mach-pxa/pxa27x.c
===================================================================
--- linux-2.6.22-git5.orig/arch/arm/mach-pxa/pxa27x.c
+++ linux-2.6.22-git5/arch/arm/mach-pxa/pxa27x.c
@@ -160,7 +160,7 @@ static int pxa27x_pm_valid(suspend_state
 	return state == PM_SUSPEND_MEM || state == PM_SUSPEND_STANDBY;
 }
 
-static struct pm_ops pxa27x_pm_ops = {
+static struct platform_suspend_ops pxa27x_pm_ops = {
 	.enter		= pxa_pm_enter,
 	.valid		= pxa27x_pm_valid,
 };
@@ -249,7 +249,7 @@ static int __init pxa27x_init(void)
 		if ((ret = pxa_init_dma(32)))
 			return ret;
 #ifdef CONFIG_PM
-		pm_set_ops(&pxa27x_pm_ops);
+		suspend_set_ops(&pxa27x_pm_ops);
 #endif
 		ret = platform_add_devices(devices, ARRAY_SIZE(devices));
 	}
Index: linux-2.6.22-git5/arch/blackfin/mach-common/pm.c
===================================================================
--- linux-2.6.22-git5.orig/arch/blackfin/mach-common/pm.c
+++ linux-2.6.22-git5/arch/blackfin/mach-common/pm.c
@@ -158,7 +158,7 @@ static int bfin_pm_finish(suspend_state_
 	return 0;
 }
 
-struct pm_ops bfin_pm_ops = {
+struct platform_suspend_ops bfin_pm_ops = {
 	.prepare = bfin_pm_prepare,
 	.enter = bfin_pm_enter,
 	.finish = bfin_pm_finish,
@@ -166,7 +166,7 @@ struct pm_ops bfin_pm_ops = {
 
 static int __init bfin_pm_init(void)
 {
-	pm_set_ops(&bfin_pm_ops);
+	suspend_set_ops(&bfin_pm_ops);
 	return 0;
 }
 
Index: linux-2.6.22-git5/arch/powerpc/platforms/52xx/mpc52xx_pm.c
===================================================================
--- linux-2.6.22-git5.orig/arch/powerpc/platforms/52xx/mpc52xx_pm.c
+++ linux-2.6.22-git5/arch/powerpc/platforms/52xx/mpc52xx_pm.c
@@ -177,7 +177,7 @@ int mpc52xx_pm_finish(suspend_state_t st
 	return 0;
 }
 
-static struct pm_ops mpc52xx_pm_ops = {
+static struct platform_suspend_ops mpc52xx_pm_ops = {
 	.valid		= mpc52xx_pm_valid,
 	.prepare	= mpc52xx_pm_prepare,
 	.enter		= mpc52xx_pm_enter,
@@ -186,6 +186,6 @@ static struct pm_ops mpc52xx_pm_ops = {
 
 int __init mpc52xx_pm_init(void)
 {
-	pm_set_ops(&mpc52xx_pm_ops);
+	suspend_set_ops(&mpc52xx_pm_ops);
 	return 0;
 }
Index: linux-2.6.22-git5/arch/sh/boards/hp6xx/pm.c
===================================================================
--- linux-2.6.22-git5.orig/arch/sh/boards/hp6xx/pm.c
+++ linux-2.6.22-git5/arch/sh/boards/hp6xx/pm.c
@@ -67,14 +67,14 @@ static int hp6x0_pm_enter(suspend_state_
 	return 0;
 }
 
-static struct pm_ops hp6x0_pm_ops = {
+static struct platform_suspend_ops hp6x0_pm_ops = {
 	.enter		= hp6x0_pm_enter,
-	.valid		= pm_valid_only_mem,
+	.valid		= suspend_valid_only_mem,
 };
 
 static int __init hp6x0_pm_init(void)
 {
-	pm_set_ops(&hp6x0_pm_ops);
+	suspend_set_ops(&hp6x0_pm_ops);
 	return 0;
 }
 

