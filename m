Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbYC0Dx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbYC0Dx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 23:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbYC0Dxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 23:53:39 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:22965 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbYC0Dxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 23:53:38 -0400
X-IronPort-AV: E=Sophos;i="4.25,562,1199682000"; 
   d="scan'208";a="50841087"
From: Bryan Wu <cooloney@kernel.org>
To: jirislaby@gmail.com, wim@iguana.be
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] Blackfin Watchdog Driver: split platform device/driver registering from actual watchdog device/driver registering so we can cleanly load/unload (v2)
Date: Thu, 27 Mar 2008 11:53:32 -0700
Message-Id: <1206644012-10135-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

v1-v2:
 - fixup __initdata with __initconst and __devinitdata with __devinitconst

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/watchdog/bfin_wdt.c |  111 +++++++++++++++++++++++++++---------------
 1 files changed, 71 insertions(+), 40 deletions(-)

diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 1237113..03b3e3d 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -29,7 +29,8 @@
 
 #define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
 #define stampit() stamp("here i am")
-#define pr_init(fmt, args...) ({ static const __initdata char __fmt[] = fmt; printk(__fmt, ## args); })
+#define pr_devinit(fmt, args...) ({ static const __devinitconst char __fmt[] = fmt; printk(__fmt, ## args); })
+#define pr_init(fmt, args...) ({ static const __initconst char __fmt[] = fmt; printk(__fmt, ## args); })
 
 #define WATCHDOG_NAME "bfin-wdt"
 #define PFX WATCHDOG_NAME ": "
@@ -377,20 +378,6 @@ static int bfin_wdt_resume(struct platform_device *pdev)
 # define bfin_wdt_resume NULL
 #endif
 
-static struct platform_device bfin_wdt_device = {
-	.name          = WATCHDOG_NAME,
-	.id            = -1,
-};
-
-static struct platform_driver bfin_wdt_driver = {
-	.driver    = {
-		.name  = WATCHDOG_NAME,
-		.owner = THIS_MODULE,
-	},
-	.suspend   = bfin_wdt_suspend,
-	.resume    = bfin_wdt_resume,
-};
-
 static const struct file_operations bfin_wdt_fops = {
 	.owner    = THIS_MODULE,
 	.llseek   = no_llseek,
@@ -418,11 +405,67 @@ static struct notifier_block bfin_wdt_notifier = {
 };
 
 /**
- *	bfin_wdt_init - Initialize module
+ *	bfin_wdt_probe - Initialize module
  *
- *	Registers the device and notifier handler. Actual device
+ *	Registers the misc device and notifier handler.  Actual device
  *	initialization is handled by bfin_wdt_open().
  */
+static int __devinit bfin_wdt_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	ret = register_reboot_notifier(&bfin_wdt_notifier);
+	if (ret) {
+		pr_devinit(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n", ret);
+		return ret;
+	}
+
+	ret = misc_register(&bfin_wdt_miscdev);
+	if (ret) {
+		pr_devinit(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
+		unregister_reboot_notifier(&bfin_wdt_notifier);
+		return ret;
+	}
+
+	pr_devinit(KERN_INFO PFX "initialized: timeout=%d sec (nowayout=%d)\n",
+	       timeout, nowayout);
+
+	return 0;
+}
+
+/**
+ *	bfin_wdt_remove - Initialize module
+ *
+ *	Unregisters the misc device and notifier handler.  Actual device
+ *	deinitialization is handled by bfin_wdt_close().
+ */
+static int __devexit bfin_wdt_remove(struct platform_device *pdev)
+{
+	misc_deregister(&bfin_wdt_miscdev);
+	unregister_reboot_notifier(&bfin_wdt_notifier);
+	return 0;
+}
+
+static struct platform_device *bfin_wdt_device;
+
+static struct platform_driver bfin_wdt_driver = {
+	.probe     = bfin_wdt_probe,
+	.remove    = __devexit_p(bfin_wdt_remove),
+	.suspend   = bfin_wdt_suspend,
+	.resume    = bfin_wdt_resume,
+	.driver    = {
+		.name  = WATCHDOG_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+/**
+ *	bfin_wdt_init - Initialize module
+ *
+ *	Checks the module params and registers the platform device & driver.
+ *	Real work is in the platform probe function.
+ */
 static int __init bfin_wdt_init(void)
 {
 	int ret;
@@ -436,44 +479,32 @@ static int __init bfin_wdt_init(void)
 	/* Since this is an on-chip device and needs no board-specific
 	 * resources, we'll handle all the platform device stuff here.
 	 */
-	ret = platform_device_register(&bfin_wdt_device);
-	if (ret)
-		return ret;
-
-	ret = platform_driver_probe(&bfin_wdt_driver, NULL);
-	if (ret)
-		return ret;
-
-	ret = register_reboot_notifier(&bfin_wdt_notifier);
+	ret = platform_driver_register(&bfin_wdt_driver);
 	if (ret) {
-		pr_init(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n", ret);
+		pr_init(KERN_ERR PFX "unable to register driver\n");
 		return ret;
 	}
 
-	ret = misc_register(&bfin_wdt_miscdev);
-	if (ret) {
-		pr_init(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-		       WATCHDOG_MINOR, ret);
-		unregister_reboot_notifier(&bfin_wdt_notifier);
-		return ret;
+	bfin_wdt_device = platform_device_register_simple(WATCHDOG_NAME, -1, NULL, 0);
+	if (IS_ERR(bfin_wdt_device)) {
+		pr_init(KERN_ERR PFX "unable to register device\n");
+		platform_driver_unregister(&bfin_wdt_driver);
+		return PTR_ERR(bfin_wdt_device);
 	}
 
-	pr_init(KERN_INFO PFX "initialized: timeout=%d sec (nowayout=%d)\n",
-	       timeout, nowayout);
-
 	return 0;
 }
 
 /**
  *	bfin_wdt_exit - Deinitialize module
  *
- *	Unregisters the device and notifier handler. Actual device
- *	deinitialization is handled by bfin_wdt_close().
+ *	Back out the platform device & driver steps.  Real work is in the
+ *	platform remove function.
  */
 static void __exit bfin_wdt_exit(void)
 {
-	misc_deregister(&bfin_wdt_miscdev);
-	unregister_reboot_notifier(&bfin_wdt_notifier);
+	platform_device_unregister(bfin_wdt_device);
+	platform_driver_unregister(&bfin_wdt_driver);
 }
 
 module_init(bfin_wdt_init);
-- 
1.5.4.3
