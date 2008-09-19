Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbYISKjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYISKjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 06:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYISKi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 06:38:29 -0400
Received: from smtp.nokia.com ([192.100.122.233]:42836 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYISKi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 06:38:27 -0400
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 5/5] watchdog: introduce platform_data and remove cpu conditional code
Date: Fri, 19 Sep 2008 13:32:39 +0300
Message-Id: <1221820359-8943-6-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.0.1.308.gede4c
In-Reply-To: <1221820359-8943-5-git-send-email-felipe.balbi@nokia.com>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com>
 <1221820359-8943-2-git-send-email-felipe.balbi@nokia.com>
 <1221820359-8943-3-git-send-email-felipe.balbi@nokia.com>
 <1221820359-8943-4-git-send-email-felipe.balbi@nokia.com>
 <1221820359-8943-5-git-send-email-felipe.balbi@nokia.com>
X-OriginalArrivalTime: 19 Sep 2008 10:32:44.0749 (UTC) FILETIME=[0D7237D0:01C91A43]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of cpu conditional code.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 arch/arm/plat-omap/devices.c      |   65 +++++++++++++++++--
 drivers/watchdog/omap_wdt.c       |  126 ++++++++++++------------------------
 include/linux/watchdog/omap_wdt.h |   29 +++++++++
 3 files changed, 131 insertions(+), 89 deletions(-)

diff --git a/arch/arm/plat-omap/devices.c b/arch/arm/plat-omap/devices.c
index f1eaa44..d756743 100644
--- a/arch/arm/plat-omap/devices.c
+++ b/arch/arm/plat-omap/devices.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/watchdog/omap_wdt.h>
 
 #include <mach/hardware.h>
 #include <asm/io.h>
@@ -460,6 +461,51 @@ static struct resource wdt_resources[] = {
 	},
 };
 
+static int omap_wdt_set_clock(struct omap_wdt_dev *wdev, int status)
+{
+	if (status) {
+		if (cpu_is_omap16xx())
+			clk_disable(wdev->fck);
+
+		if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
+			clk_disable(wdev->ick);
+			clk_disable(wdev->fck);
+		}
+	} else {
+		if (cpu_is_omap16xx())
+			clk_disable(wdev->fck);
+
+		if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
+			clk_disable(wdev->ick);
+			clk_disable(wdev->fck);
+		}
+	}
+
+	return 0;
+}
+
+static int omap_wdt_get_bootstatus(void)
+{
+	if (cpu_is_omap16xx())
+		return __raw_readw(ARM_SYSST);
+
+#if 0
+	/* REVISIT: When the patch introducing the following function
+	 * gets merged upstream, uncomment this code to enable omap2
+	 * support on omap watchdog driver.
+	 */
+	if (cpu_is_omap24xx())
+		return omap_prcm_get_reset_sources();
+#endif
+
+	return 0;
+}
+
+static struct omap_wdt_platform_data omap_wdt_pdata = {
+	.set_clock	= omap_wdt_set_clock,
+	.get_bootstatus	= omap_wdt_get_bootstatus,
+};
+
 static struct platform_device omap_wdt_device = {
 	.name	   = "omap_wdt",
 	.id	     = -1,
@@ -469,17 +515,26 @@ static struct platform_device omap_wdt_device = {
 
 static void omap_init_wdt(void)
 {
-	if (cpu_is_omap16xx())
+	if (cpu_is_omap16xx()) {
+		omap_wdt_pdata.fck = "armwdt_ck";
 		wdt_resources[0].start = 0xfffeb000;
-	else if (cpu_is_omap2420())
+	} else if (cpu_is_omap2420()) {
+		omap_wdt_pdata.fck = "mpu_wdt_ick";
+		omap_wdt_pdata.ick = "mpu_wdt_fck";
 		wdt_resources[0].start = 0x48022000; /* WDT2 */
-	else if (cpu_is_omap2430())
+	} else if (cpu_is_omap2430()) {
+		omap_wdt_pdata.fck = "mpu_wdt_ick";
+		omap_wdt_pdata.ick = "mpu_wdt_fck";
 		wdt_resources[0].start = 0x49016000; /* WDT2 */
-	else if (cpu_is_omap343x())
+	} else if (cpu_is_omap343x()) {
+		omap_wdt_pdata.fck = "wdt2_ick";
+		omap_wdt_pdata.ick = "wdt2_fck";
 		wdt_resources[0].start = 0x48314000; /* WDT2 */
-	else
+	} else {
 		return;
+	}
 
+	omap_wdt_device.dev.platform_data = &omap_wdt_pdata;
 	wdt_resources[0].end = wdt_resources[0].start + 0x4f;
 
 	(void) platform_device_register(&omap_wdt_device);
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 8b68bc0..c113953 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -47,25 +47,21 @@
 #include <mach/hardware.h>
 #include <mach/prcm.h>
 
-static struct platform_device *omap_wdt_dev;
-
 static unsigned timer_margin;
 module_param(timer_margin, uint, 0);
 MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
 
+static struct platform_device *omap_wdt_dev;
 static unsigned int wdt_trgr_pattern = 0x1234;
 static spinlock_t wdt_lock;
 
-struct omap_wdt_dev {
-	void __iomem    *base;          /* physical */
-	struct device   *dev;
-	int             omap_wdt_users;
-	struct clk      *armwdt_ck;
-	struct clk      *mpu_wdt_ick;
-	struct clk      *mpu_wdt_fck;
-	struct resource *mem;
-	struct miscdevice omap_wdt_miscdev;
-};
+static inline int omap_wdt_set_clock(struct omap_wdt_dev *wdev, int status)
+{
+	if (wdev->set_clock)
+		return wdev->set_clock(wdev, status);
+
+	return 0;
+}
 
 static void omap_wdt_ping(struct omap_wdt_dev *wdev)
 {
@@ -146,13 +142,7 @@ static int omap_wdt_open(struct inode *inode, struct file *file)
 	if (test_and_set_bit(1, (unsigned long *)&(wdev->omap_wdt_users)))
 		return -EBUSY;
 
-	if (cpu_is_omap16xx())
-		clk_enable(wdev->armwdt_ck);	/* Enable the clock */
-
-	if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
-		clk_enable(wdev->mpu_wdt_ick);    /* Enable the interface clock */
-		clk_enable(wdev->mpu_wdt_fck);    /* Enable the functional clock */
-	}
+	omap_wdt_set_clock(wdev, 1);
 
 	/* initialize prescaler */
 	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x01)
@@ -178,16 +168,8 @@ static int omap_wdt_release(struct inode *inode, struct file *file)
 	 *      Shut off the timer unless NOWAYOUT is defined.
 	 */
 #ifndef CONFIG_WATCHDOG_NOWAYOUT
-
 	omap_wdt_disable(wdev);
-
-	if (cpu_is_omap16xx())
-		clk_disable(wdev->armwdt_ck);	/* Disable the clock */
-
-	if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
-		clk_disable(wdev->mpu_wdt_ick);	/* Disable the clock */
-		clk_disable(wdev->mpu_wdt_fck);	/* Disable the clock */
-	}
+	omap_wdt_set_clock(wdev, 1);
 #else
 	printk(KERN_CRIT "omap_wdt: Unexpected close, not stopping!\n");
 #endif
@@ -230,12 +212,8 @@ static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
 	case WDIOC_GETSTATUS:
 		return put_user(0, (int __user *)arg);
 	case WDIOC_GETBOOTSTATUS:
-		if (cpu_is_omap16xx())
-			return put_user(__raw_readw(ARM_SYSST),
-					(int __user *)arg);
-		if (cpu_is_omap24xx())
-			return put_user(omap_prcm_get_reset_sources(),
-					(int __user *)arg);
+		return put_user(wdev->get_bootstatus(),
+				(int __user *)arg);
 	case WDIOC_KEEPALIVE:
 		spin_lock(&wdt_lock);
 		omap_wdt_ping(wdev);
@@ -271,6 +249,7 @@ static const struct file_operations omap_wdt_fops = {
 
 static int __init omap_wdt_probe(struct platform_device *pdev)
 {
+	struct omap_wdt_platform_data *pdata = pdev->dev.platform_data;
 	struct resource *res, *mem;
 	struct omap_wdt_dev *wdev;
 	int ret;
@@ -283,7 +262,7 @@ static int __init omap_wdt_probe(struct platform_device *pdev)
 	}
 
 	if (omap_wdt_dev) {
-		ret - EBUSY;
+		ret = EBUSY;
 		goto err_busy;
 	}
 
@@ -302,45 +281,30 @@ static int __init omap_wdt_probe(struct platform_device *pdev)
 
 	wdev->omap_wdt_users = 0;
 	wdev->mem = mem;
+	wdev->get_bootstatus = pdata->get_bootstatus;
+	wdev->set_clock = pdata->set_clock;
 
-	if (cpu_is_omap16xx()) {
-		wdev->armwdt_ck = clk_get(&pdev->dev, "armwdt_ck");
-		if (IS_ERR(wdev->armwdt_ck)) {
-			ret = PTR_ERR(wdev->armwdt_ck);
-			wdev->armwdt_ck = NULL;
-			goto err_clk;
-		}
+	/* omap1 has only the functional clock so we believe everybody
+	 * will pass that pointer correctly. For the interface clock,
+	 * we check whether that pointer is true to avoid null pointer
+	 * dereferences
+	 */
+	wdev->fck = clk_get(&pdev->dev, pdata->fck);
+	if (IS_ERR(wdev->fck)) {
+		ret = PTR_ERR(wdev->fck);
+		wdev->fck = NULL;
+		goto err_clk;
 	}
 
-	if (cpu_is_omap24xx()) {
-		wdev->mpu_wdt_ick = clk_get(&pdev->dev, "mpu_wdt_ick");
-		if (IS_ERR(wdev->mpu_wdt_ick)) {
-			ret = PTR_ERR(wdev->mpu_wdt_ick);
-			wdev->mpu_wdt_ick = NULL;
-			goto err_clk;
-		}
-		wdev->mpu_wdt_fck = clk_get(&pdev->dev, "mpu_wdt_fck");
-		if (IS_ERR(wdev->mpu_wdt_fck)) {
-			ret = PTR_ERR(wdev->mpu_wdt_fck);
-			wdev->mpu_wdt_fck = NULL;
+	if (pdata->ick) {
+		wdev->ick = clk_get(&pdev->dev, pdata->ick);
+		if (IS_ERR(wdev->ick)) {
+			ret = PTR_ERR(wdev->ick);
+			wdev->ick = NULL;
 			goto err_clk;
 		}
 	}
 
-	if (cpu_is_omap34xx()) {
-		wdev->mpu_wdt_ick = clk_get(&pdev->dev, "wdt2_ick");
-		if (IS_ERR(wdev->mpu_wdt_ick)) {
-			ret = PTR_ERR(wdev->mpu_wdt_ick);
-			wdev->mpu_wdt_ick = NULL;
-			goto err_clk;
-		}
-		wdev->mpu_wdt_fck = clk_get(&pdev->dev, "wdt2_fck");
-		if (IS_ERR(wdev->mpu_wdt_fck)) {
-			ret = PTR_ERR(wdev->mpu_wdt_fck);
-			wdev->mpu_wdt_fck = NULL;
-			goto err_clk;
-		}
-	}
 	wdev->base = ioremap(res->start, res->end - res->start + 1);
 	if (!wdev->base) {
 		ret = -ENOMEM;
@@ -380,12 +344,11 @@ err_ioremap:
 	wdev->base = NULL;
 
 err_clk:
-	if (wdev->armwdt_ck)
-		clk_put(wdev->armwdt_ck);
-	if (wdev->mpu_wdt_ick)
-		clk_put(wdev->mpu_wdt_ick);
-	if (wdev->mpu_wdt_fck)
-		clk_put(wdev->mpu_wdt_fck);
+	if (wdev->fck)
+		clk_put(wdev->fck);
+	if (wdev->ick)
+		clk_put(wdev->ick);
+
 	kfree(wdev);
 
 err_kzalloc:
@@ -417,19 +380,14 @@ static int omap_wdt_remove(struct platform_device *pdev)
 	release_mem_region(res->start, res->end - res->start + 1);
 	platform_set_drvdata(pdev, NULL);
 
-	if (wdev->armwdt_ck) {
-		clk_put(wdev->armwdt_ck);
-		wdev->armwdt_ck = NULL;
-	}
-
-	if (wdev->mpu_wdt_ick) {
-		clk_put(wdev->mpu_wdt_ick);
-		wdev->mpu_wdt_ick = NULL;
+	if (wdev->fck) {
+		clk_put(wdev->fck);
+		wdev->fck = NULL;
 	}
 
-	if (wdev->mpu_wdt_fck) {
-		clk_put(wdev->mpu_wdt_fck);
-		wdev->mpu_wdt_fck = NULL;
+	if (wdev->ick) {
+		clk_put(wdev->ick);
+		wdev->ick = NULL;
 	}
 	iounmap(wdev->base);
 
diff --git a/include/linux/watchdog/omap_wdt.h b/include/linux/watchdog/omap_wdt.h
index 62e6a74..858d9a4 100644
--- a/include/linux/watchdog/omap_wdt.h
+++ b/include/linux/watchdog/omap_wdt.h
@@ -30,6 +30,9 @@
 #ifndef _OMAP_WATCHDOG_H
 #define _OMAP_WATCHDOG_H
 
+#include <linux/clk.h>
+#include <linux/miscdevice.h>
+
 #define OMAP_WATCHDOG_REV		(0x00)
 #define OMAP_WATCHDOG_SYS_CONFIG	(0x10)
 #define OMAP_WATCHDOG_STATUS		(0x14)
@@ -51,4 +54,30 @@
 #define PTV			0	/* prescale */
 #define GET_WLDR_VAL(secs)	(0xffffffff - ((secs) * (32768/(1<<PTV))) + 1)
 
+struct omap_wdt_dev {
+	void __iomem    *base;          /* physical */
+	struct device   *dev;
+	int             omap_wdt_users;
+
+	struct clk      *ick;
+	struct clk      *fck;
+
+	struct resource *mem;
+	struct miscdevice omap_wdt_miscdev;
+
+	/* clock handling */
+	int	(*set_clock)(struct omap_wdt_dev *wdev, int status);
+
+	/* used for put_user() */
+	int	(*get_bootstatus)(void);
+};
+
+struct omap_wdt_platform_data {
+	const char	*ick;
+	const char	*fck;
+
+	int	(*set_clock)(struct omap_wdt_dev *wdev, int status);
+	int	(*get_bootstatus)(void);
+};
+
 #endif				/* _OMAP_WATCHDOG_H */
-- 
1.6.0.1.308.gede4c

