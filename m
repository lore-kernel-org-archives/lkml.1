Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbYISLiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbYISLiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 07:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbYISLiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 07:38:13 -0400
Received: from smtp.nokia.com ([192.100.105.134]:49740 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbYISLiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 07:38:08 -0400
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 1/5] watchdog: sync linux-omap changes
Date: Fri, 19 Sep 2008 13:32:35 +0300
Message-Id: <1221820359-8943-2-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.0.1.308.gede4c
In-Reply-To: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com>
X-OriginalArrivalTime: 19 Sep 2008 10:32:44.0592 (UTC) FILETIME=[0D5A4300:01C91A43]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are changes that have been sitting in linux-omap
and were never sent upstream.

Hopefully, it'll never happen again at least for this
driver.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 arch/arm/plat-omap/devices.c |   21 ++--
 drivers/watchdog/omap_wdt.c  |  287 +++++++++++++++++++++++++++---------------
 drivers/watchdog/omap_wdt.h  |   28 ++---
 3 files changed, 205 insertions(+), 131 deletions(-)

diff --git a/arch/arm/plat-omap/devices.c b/arch/arm/plat-omap/devices.c
index bc1cf30..f1eaa44 100644
--- a/arch/arm/plat-omap/devices.c
+++ b/arch/arm/plat-omap/devices.c
@@ -454,16 +454,8 @@ static inline void omap_init_uwire(void) {}
 
 #if	defined(CONFIG_OMAP_WATCHDOG) || defined(CONFIG_OMAP_WATCHDOG_MODULE)
 
-#ifdef CONFIG_ARCH_OMAP24XX
-#define	OMAP_WDT_BASE		0x48022000
-#else
-#define	OMAP_WDT_BASE		0xfffeb000
-#endif
-
 static struct resource wdt_resources[] = {
 	{
-		.start		= OMAP_WDT_BASE,
-		.end		= OMAP_WDT_BASE + 0x4f,
 		.flags		= IORESOURCE_MEM,
 	},
 };
@@ -477,6 +469,19 @@ static struct platform_device omap_wdt_device = {
 
 static void omap_init_wdt(void)
 {
+	if (cpu_is_omap16xx())
+		wdt_resources[0].start = 0xfffeb000;
+	else if (cpu_is_omap2420())
+		wdt_resources[0].start = 0x48022000; /* WDT2 */
+	else if (cpu_is_omap2430())
+		wdt_resources[0].start = 0x49016000; /* WDT2 */
+	else if (cpu_is_omap343x())
+		wdt_resources[0].start = 0x48314000; /* WDT2 */
+	else
+		return;
+
+	wdt_resources[0].end = wdt_resources[0].start + 0x4f;
+
 	(void) platform_device_register(&omap_wdt_device);
 }
 #else
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 3a11dad..e55f2cc 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -1,7 +1,7 @@
 /*
- * linux/drivers/char/watchdog/omap_wdt.c
+ * linux/drivers/watchdog/omap_wdt.c
  *
- * Watchdog driver for the TI OMAP 16xx & 24xx 32KHz (non-secure) watchdog
+ * Watchdog driver for the TI OMAP 16xx & 24xx/34xx 32KHz (non-secure) watchdog
  *
  * Author: MontaVista Software, Inc.
  *	 <gdavis@mvista.com> or <source@mvista.com>
@@ -39,6 +39,7 @@
 #include <linux/platform_device.h>
 #include <linux/moduleparam.h>
 #include <linux/clk.h>
+
 #include <linux/bitops.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
@@ -47,50 +48,63 @@
 
 #include "omap_wdt.h"
 
+static struct platform_device *omap_wdt_dev;
+
 static unsigned timer_margin;
 module_param(timer_margin, uint, 0);
 MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
 
-static int omap_wdt_users;
-static struct clk *armwdt_ck;
-static struct clk *mpu_wdt_ick;
-static struct clk *mpu_wdt_fck;
-
 static unsigned int wdt_trgr_pattern = 0x1234;
 static spinlock_t wdt_lock;
 
-static void omap_wdt_ping(void)
+struct omap_wdt_dev {
+	void __iomem    *base;          /* physical */
+	struct device   *dev;
+	int             omap_wdt_users;
+	struct clk      *armwdt_ck;
+	struct clk      *mpu_wdt_ick;
+	struct clk      *mpu_wdt_fck;
+	struct resource *mem;
+	struct miscdevice omap_wdt_miscdev;
+};
+
+static void omap_wdt_ping(struct omap_wdt_dev *wdev)
 {
+	void __iomem    *base = wdev->base;
 	/* wait for posted write to complete */
-	while ((omap_readl(OMAP_WATCHDOG_WPS)) & 0x08)
+	while ((omap_readl(base + OMAP_WATCHDOG_WPS)) & 0x08)
 		cpu_relax();
 	wdt_trgr_pattern = ~wdt_trgr_pattern;
-	omap_writel(wdt_trgr_pattern, (OMAP_WATCHDOG_TGR));
+	omap_writel(wdt_trgr_pattern, (base + OMAP_WATCHDOG_TGR));
 	/* wait for posted write to complete */
-	while ((omap_readl(OMAP_WATCHDOG_WPS)) & 0x08)
+	while ((omap_readl(base + OMAP_WATCHDOG_WPS)) & 0x08)
 		cpu_relax();
 	/* reloaded WCRR from WLDR */
 }
 
-static void omap_wdt_enable(void)
+static void omap_wdt_enable(struct omap_wdt_dev *wdev)
 {
+	void __iomem *base;
+	base = wdev->base;
 	/* Sequence to enable the watchdog */
-	omap_writel(0xBBBB, OMAP_WATCHDOG_SPR);
-	while ((omap_readl(OMAP_WATCHDOG_WPS)) & 0x10)
+	omap_writel(0xBBBB, base + OMAP_WATCHDOG_SPR);
+	while ((omap_readl(base + OMAP_WATCHDOG_WPS)) & 0x10)
 		cpu_relax();
-	omap_writel(0x4444, OMAP_WATCHDOG_SPR);
-	while ((omap_readl(OMAP_WATCHDOG_WPS)) & 0x10)
+	omap_writel(0x4444, base + OMAP_WATCHDOG_SPR);
+	while ((omap_readl(base + OMAP_WATCHDOG_WPS)) & 0x10)
 		cpu_relax();
 }
 
-static void omap_wdt_disable(void)
+static void omap_wdt_disable(struct omap_wdt_dev *wdev)
 {
+	void __iomem *base;
+	base = wdev->base;
 	/* sequence required to disable watchdog */
-	omap_writel(0xAAAA, OMAP_WATCHDOG_SPR);	/* TIMER_MODE */
-	while (omap_readl(OMAP_WATCHDOG_WPS) & 0x10)
+	omap_writel(0xAAAA, base + OMAP_WATCHDOG_SPR);	/* TIMER_MODE */
+	while (omap_readl(base + OMAP_WATCHDOG_WPS) & 0x10)
 		cpu_relax();
-	omap_writel(0x5555, OMAP_WATCHDOG_SPR);	/* TIMER_MODE */
-	while (omap_readl(OMAP_WATCHDOG_WPS) & 0x10)
+	omap_writel(0x5555, base + OMAP_WATCHDOG_SPR);	/* TIMER_MODE */
+	while (omap_readl(base + OMAP_WATCHDOG_WPS) & 0x10)
 		cpu_relax();
 }
 
@@ -103,15 +117,17 @@ static void omap_wdt_adjust_timeout(unsigned new_timeout)
 	timer_margin = new_timeout;
 }
 
-static void omap_wdt_set_timeout(void)
+static void omap_wdt_set_timeout(struct omap_wdt_dev *wdev)
 {
 	u32 pre_margin = GET_WLDR_VAL(timer_margin);
+	void __iomem *base;
+	base = wdev->base;
 
 	/* just count up at 32 KHz */
-	while (omap_readl(OMAP_WATCHDOG_WPS) & 0x04)
+	while (omap_readl(base + OMAP_WATCHDOG_WPS) & 0x04)
 		cpu_relax();
-	omap_writel(pre_margin, OMAP_WATCHDOG_LDR);
-	while (omap_readl(OMAP_WATCHDOG_WPS) & 0x04)
+	omap_writel(pre_margin, base + OMAP_WATCHDOG_LDR);
+	while (omap_readl(base + OMAP_WATCHDOG_WPS) & 0x04)
 		cpu_relax();
 }
 
@@ -121,65 +137,69 @@ static void omap_wdt_set_timeout(void)
 
 static int omap_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(1, (unsigned long *)&omap_wdt_users))
+	struct omap_wdt_dev *wdev;
+	void __iomem *base;
+	wdev = platform_get_drvdata(omap_wdt_dev);
+	base = wdev->base;
+	if (test_and_set_bit(1, (unsigned long *)&(wdev->omap_wdt_users)))
 		return -EBUSY;
 
 	if (cpu_is_omap16xx())
-		clk_enable(armwdt_ck);	/* Enable the clock */
+		clk_enable(wdev->armwdt_ck);	/* Enable the clock */
 
-	if (cpu_is_omap24xx()) {
-		clk_enable(mpu_wdt_ick);    /* Enable the interface clock */
-		clk_enable(mpu_wdt_fck);    /* Enable the functional clock */
+	if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
+		clk_enable(wdev->mpu_wdt_ick);    /* Enable the interface clock */
+		clk_enable(wdev->mpu_wdt_fck);    /* Enable the functional clock */
 	}
 
 	/* initialize prescaler */
-	while (omap_readl(OMAP_WATCHDOG_WPS) & 0x01)
+	while (omap_readl(base + OMAP_WATCHDOG_WPS) & 0x01)
 		cpu_relax();
-	omap_writel((1 << 5) | (PTV << 2), OMAP_WATCHDOG_CNTRL);
-	while (omap_readl(OMAP_WATCHDOG_WPS) & 0x01)
+	omap_writel((1 << 5) | (PTV << 2), base + OMAP_WATCHDOG_CNTRL);
+	while (omap_readl(base + OMAP_WATCHDOG_WPS) & 0x01)
 		cpu_relax();
 
-	omap_wdt_set_timeout();
-	omap_wdt_enable();
+	file->private_data = (void *) wdev;
+
+	omap_wdt_set_timeout(wdev);
+	omap_wdt_enable(wdev);
 	return nonseekable_open(inode, file);
 }
 
 static int omap_wdt_release(struct inode *inode, struct file *file)
 {
+	struct omap_wdt_dev *wdev;
+	wdev = file->private_data;
 	/*
 	 *      Shut off the timer unless NOWAYOUT is defined.
 	 */
 #ifndef CONFIG_WATCHDOG_NOWAYOUT
-	omap_wdt_disable();
 
-	if (cpu_is_omap16xx()) {
-		clk_disable(armwdt_ck);	/* Disable the clock */
-		clk_put(armwdt_ck);
-		armwdt_ck = NULL;
-	}
+	omap_wdt_disable(wdev);
 
-	if (cpu_is_omap24xx()) {
-		clk_disable(mpu_wdt_ick);	/* Disable the clock */
-		clk_disable(mpu_wdt_fck);	/* Disable the clock */
-		clk_put(mpu_wdt_ick);
-		clk_put(mpu_wdt_fck);
-		mpu_wdt_ick = NULL;
-		mpu_wdt_fck = NULL;
+	if (cpu_is_omap16xx())
+		clk_disable(wdev->armwdt_ck);	/* Disable the clock */
+
+	if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
+		clk_disable(wdev->mpu_wdt_ick);	/* Disable the clock */
+		clk_disable(wdev->mpu_wdt_fck);	/* Disable the clock */
 	}
 #else
 	printk(KERN_CRIT "omap_wdt: Unexpected close, not stopping!\n");
 #endif
-	omap_wdt_users = 0;
+	wdev->omap_wdt_users = 0;
 	return 0;
 }
 
 static ssize_t omap_wdt_write(struct file *file, const char __user *data,
 		size_t len, loff_t *ppos)
 {
+	struct omap_wdt_dev *wdev;
+	wdev = file->private_data;
 	/* Refresh LOAD_TIME. */
 	if (len) {
 		spin_lock(&wdt_lock);
-		omap_wdt_ping();
+		omap_wdt_ping(wdev);
 		spin_unlock(&wdt_lock);
 	}
 	return len;
@@ -188,12 +208,14 @@ static ssize_t omap_wdt_write(struct file *file, const char __user *data,
 static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
+	struct omap_wdt_dev *wdev;
 	int new_margin;
 	static const struct watchdog_info ident = {
 		.identity = "OMAP Watchdog",
 		.options = WDIOF_SETTIMEOUT,
 		.firmware_version = 0,
 	};
+	wdev = file->private_data;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
@@ -210,7 +232,7 @@ static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
 					(int __user *)arg);
 	case WDIOC_KEEPALIVE:
 		spin_lock(&wdt_lock);
-		omap_wdt_ping();
+		omap_wdt_ping(wdev);
 		spin_unlock(&wdt_lock);
 		return 0;
 	case WDIOC_SETTIMEOUT:
@@ -218,19 +240,18 @@ static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
 			return -EFAULT;
 		omap_wdt_adjust_timeout(new_margin);
 
-		spin_lock(&wdt_lock);
-		omap_wdt_disable();
-		omap_wdt_set_timeout();
-		omap_wdt_enable();
+		omap_wdt_disable(wdev);
+		omap_wdt_set_timeout(wdev);
+		omap_wdt_enable(wdev);
 
-		omap_wdt_ping();
-		spin_unlock(&wdt_lock);
+		omap_wdt_ping(wdev);
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
 		return put_user(timer_margin, (int __user *)arg);
 	default:
 		return -ENOTTY;
 	}
+	return 0;
 }
 
 static const struct file_operations omap_wdt_fops = {
@@ -241,96 +262,150 @@ static const struct file_operations omap_wdt_fops = {
 	.release = omap_wdt_release,
 };
 
-static struct miscdevice omap_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &omap_wdt_fops,
-};
 
 static int __init omap_wdt_probe(struct platform_device *pdev)
 {
 	struct resource *res, *mem;
 	int ret;
+	struct omap_wdt_dev *wdev;
 
 	/* reserve static register mappings */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENOENT;
 
+	if (omap_wdt_dev)
+		return -EBUSY;
+
 	mem = request_mem_region(res->start, res->end - res->start + 1,
 				 pdev->name);
 	if (mem == NULL)
 		return -EBUSY;
 
-	platform_set_drvdata(pdev, mem);
-
-	omap_wdt_users = 0;
+	wdev = kzalloc(sizeof(struct omap_wdt_dev), GFP_KERNEL);
+	if (!wdev) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+	wdev->omap_wdt_users = 0;
+	wdev->mem = mem;
 
 	if (cpu_is_omap16xx()) {
-		armwdt_ck = clk_get(&pdev->dev, "armwdt_ck");
-		if (IS_ERR(armwdt_ck)) {
-			ret = PTR_ERR(armwdt_ck);
-			armwdt_ck = NULL;
+		wdev->armwdt_ck = clk_get(&pdev->dev, "armwdt_ck");
+		if (IS_ERR(wdev->armwdt_ck)) {
+			ret = PTR_ERR(wdev->armwdt_ck);
+			wdev->armwdt_ck = NULL;
 			goto fail;
 		}
 	}
 
 	if (cpu_is_omap24xx()) {
-		mpu_wdt_ick = clk_get(&pdev->dev, "mpu_wdt_ick");
-		if (IS_ERR(mpu_wdt_ick)) {
-			ret = PTR_ERR(mpu_wdt_ick);
-			mpu_wdt_ick = NULL;
+		wdev->mpu_wdt_ick = clk_get(&pdev->dev, "mpu_wdt_ick");
+		if (IS_ERR(wdev->mpu_wdt_ick)) {
+			ret = PTR_ERR(wdev->mpu_wdt_ick);
+			wdev->mpu_wdt_ick = NULL;
+			goto fail;
+		}
+		wdev->mpu_wdt_fck = clk_get(&pdev->dev, "mpu_wdt_fck");
+		if (IS_ERR(wdev->mpu_wdt_fck)) {
+			ret = PTR_ERR(wdev->mpu_wdt_fck);
+			wdev->mpu_wdt_fck = NULL;
+			goto fail;
+		}
+	}
+
+	if (cpu_is_omap34xx()) {
+		wdev->mpu_wdt_ick = clk_get(&pdev->dev, "wdt2_ick");
+		if (IS_ERR(wdev->mpu_wdt_ick)) {
+			ret = PTR_ERR(wdev->mpu_wdt_ick);
+			wdev->mpu_wdt_ick = NULL;
 			goto fail;
 		}
-		mpu_wdt_fck = clk_get(&pdev->dev, "mpu_wdt_fck");
-		if (IS_ERR(mpu_wdt_fck)) {
-			ret = PTR_ERR(mpu_wdt_fck);
-			mpu_wdt_fck = NULL;
+		wdev->mpu_wdt_fck = clk_get(&pdev->dev, "wdt2_fck");
+		if (IS_ERR(wdev->mpu_wdt_fck)) {
+			ret = PTR_ERR(wdev->mpu_wdt_fck);
+			wdev->mpu_wdt_fck = NULL;
 			goto fail;
 		}
 	}
+	wdev->base = (void __iomem *) (mem->start);
+	platform_set_drvdata(pdev, wdev);
 
-	omap_wdt_disable();
+	omap_wdt_disable(wdev);
 	omap_wdt_adjust_timeout(timer_margin);
 
-	omap_wdt_miscdev.parent = &pdev->dev;
-	ret = misc_register(&omap_wdt_miscdev);
+	wdev->omap_wdt_miscdev.parent = &pdev->dev;
+	wdev->omap_wdt_miscdev.minor = WATCHDOG_MINOR;
+	wdev->omap_wdt_miscdev.name = "watchdog";
+	wdev->omap_wdt_miscdev.fops = &omap_wdt_fops;
+
+	ret = misc_register(&(wdev->omap_wdt_miscdev));
 	if (ret)
 		goto fail;
 
-	pr_info("OMAP Watchdog Timer: initial timeout %d sec\n", timer_margin);
+	pr_info("OMAP Watchdog Timer Rev 0x%02x: initial timeout %d sec\n",
+		omap_readl(wdev->base + OMAP_WATCHDOG_REV) & 0xFF,
+		timer_margin);
 
 	/* autogate OCP interface clock */
-	omap_writel(0x01, OMAP_WATCHDOG_SYS_CONFIG);
+	omap_writel(0x01, wdev->base + OMAP_WATCHDOG_SYS_CONFIG);
+
+	omap_wdt_dev = pdev;
+
 	return 0;
 
 fail:
-	if (armwdt_ck)
-		clk_put(armwdt_ck);
-	if (mpu_wdt_ick)
-		clk_put(mpu_wdt_ick);
-	if (mpu_wdt_fck)
-		clk_put(mpu_wdt_fck);
-	release_resource(mem);
+	if (wdev) {
+		platform_set_drvdata(pdev, NULL);
+		if (wdev->armwdt_ck)
+			clk_put(wdev->armwdt_ck);
+		if (wdev->mpu_wdt_ick)
+			clk_put(wdev->mpu_wdt_ick);
+		if (wdev->mpu_wdt_fck)
+			clk_put(wdev->mpu_wdt_fck);
+		kfree(wdev);
+	}
+	if (mem) {
+		release_mem_region(res->start, res->end - res->start + 1);
+	}
 	return ret;
 }
 
 static void omap_wdt_shutdown(struct platform_device *pdev)
 {
-	omap_wdt_disable();
+	struct omap_wdt_dev *wdev;
+	wdev = platform_get_drvdata(pdev);
+
+	if (wdev->omap_wdt_users)
+		omap_wdt_disable(wdev);
 }
 
 static int omap_wdt_remove(struct platform_device *pdev)
 {
-	struct resource *mem = platform_get_drvdata(pdev);
-	misc_deregister(&omap_wdt_miscdev);
-	release_resource(mem);
-	if (armwdt_ck)
-		clk_put(armwdt_ck);
-	if (mpu_wdt_ick)
-		clk_put(mpu_wdt_ick);
-	if (mpu_wdt_fck)
-		clk_put(mpu_wdt_fck);
+	struct omap_wdt_dev *wdev;
+	wdev = platform_get_drvdata(pdev);
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!res)
+		return -ENOENT;
+
+	misc_deregister(&(wdev->omap_wdt_miscdev));
+	release_mem_region(res->start, res->end - res->start + 1);
+	platform_set_drvdata(pdev, NULL);
+	if (wdev->armwdt_ck) {
+		clk_put(wdev->armwdt_ck);
+		wdev->armwdt_ck = NULL;
+	}
+	if (wdev->mpu_wdt_ick) {
+		clk_put(wdev->mpu_wdt_ick);
+		wdev->mpu_wdt_ick = NULL;
+	}
+	if (wdev->mpu_wdt_fck) {
+		clk_put(wdev->mpu_wdt_fck);
+		wdev->mpu_wdt_fck = NULL;
+	}
+	kfree(wdev);
+	omap_wdt_dev = NULL;
 	return 0;
 }
 
@@ -344,16 +419,20 @@ static int omap_wdt_remove(struct platform_device *pdev)
 
 static int omap_wdt_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	if (omap_wdt_users)
-		omap_wdt_disable();
+	struct omap_wdt_dev *wdev;
+	wdev = platform_get_drvdata(pdev);
+	if (wdev->omap_wdt_users)
+		omap_wdt_disable(wdev);
 	return 0;
 }
 
 static int omap_wdt_resume(struct platform_device *pdev)
 {
-	if (omap_wdt_users) {
-		omap_wdt_enable();
-		omap_wdt_ping();
+	struct omap_wdt_dev *wdev;
+	wdev = platform_get_drvdata(pdev);
+	if (wdev->omap_wdt_users) {
+		omap_wdt_enable(wdev);
+		omap_wdt_ping(wdev);
 	}
 	return 0;
 }
diff --git a/drivers/watchdog/omap_wdt.h b/drivers/watchdog/omap_wdt.h
index 52a532a..fc02ec6 100644
--- a/drivers/watchdog/omap_wdt.h
+++ b/drivers/watchdog/omap_wdt.h
@@ -30,25 +30,15 @@
 #ifndef _OMAP_WATCHDOG_H
 #define _OMAP_WATCHDOG_H
 
-#define OMAP1610_WATCHDOG_BASE		0xfffeb000
-#define OMAP2420_WATCHDOG_BASE		0x48022000	/*WDT Timer 2 */
-
-#ifdef CONFIG_ARCH_OMAP24XX
-#define OMAP_WATCHDOG_BASE 		OMAP2420_WATCHDOG_BASE
-#else
-#define OMAP_WATCHDOG_BASE 		OMAP1610_WATCHDOG_BASE
-#define RM_RSTST_WKUP			0
-#endif
-
-#define OMAP_WATCHDOG_REV		(OMAP_WATCHDOG_BASE + 0x00)
-#define OMAP_WATCHDOG_SYS_CONFIG	(OMAP_WATCHDOG_BASE + 0x10)
-#define OMAP_WATCHDOG_STATUS		(OMAP_WATCHDOG_BASE + 0x14)
-#define OMAP_WATCHDOG_CNTRL		(OMAP_WATCHDOG_BASE + 0x24)
-#define OMAP_WATCHDOG_CRR		(OMAP_WATCHDOG_BASE + 0x28)
-#define OMAP_WATCHDOG_LDR		(OMAP_WATCHDOG_BASE + 0x2c)
-#define OMAP_WATCHDOG_TGR		(OMAP_WATCHDOG_BASE + 0x30)
-#define OMAP_WATCHDOG_WPS		(OMAP_WATCHDOG_BASE + 0x34)
-#define OMAP_WATCHDOG_SPR		(OMAP_WATCHDOG_BASE + 0x48)
+#define OMAP_WATCHDOG_REV		(0x00)
+#define OMAP_WATCHDOG_SYS_CONFIG	(0x10)
+#define OMAP_WATCHDOG_STATUS		(0x14)
+#define OMAP_WATCHDOG_CNTRL		(0x24)
+#define OMAP_WATCHDOG_CRR		(0x28)
+#define OMAP_WATCHDOG_LDR		(0x2c)
+#define OMAP_WATCHDOG_TGR		(0x30)
+#define OMAP_WATCHDOG_WPS		(0x34)
+#define OMAP_WATCHDOG_SPR		(0x48)
 
 /* Using the prescaler, the OMAP watchdog could go for many
  * months before firing.  These limits work without scaling,
-- 
1.6.0.1.308.gede4c

