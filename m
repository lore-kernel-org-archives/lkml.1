Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815Ab0ASVWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab0ASVWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597Ab0ASVWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:22:14 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:60378 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755032Ab0ASVWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:22:11 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAL+xVUtbssBB/2dsb2JhbADZawqEKQQ
Date: Tue, 19 Jan 2010 22:22:09 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Mike Frysinger <vapier.adi@gmail.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thierry Reding <thierry.reding@avionic-design.de>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC] [PATCH] change reboot_notifier to platform-shutdown method.
Message-ID: <20100119212209.GF3804@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Can you give comments and test?

Thanks in advance,
Wim.

commit 31088dc041e929453f307f34a90dd8cecacf2fa8
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sat Dec 26 19:13:00 2009 +0000

    [WATCHDOG] change reboot_notifier to platform-shutdown method.
    
    Platform device drivers can use the .shutdown method to handle soft
    shutdown's instead of reboot_notifier's.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 6ce2022..5a73d73 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -20,8 +20,6 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/fs.h>
-#include <linux/notifier.h>
-#include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
@@ -308,26 +306,6 @@ static long bfin_wdt_ioctl(struct file *file,
 	}
 }
 
-/**
- *	bfin_wdt_notify_sys - Notifier Handler
- *	@this: notifier block
- *	@code: notifier event
- *	@unused: unused
- *
- *	Handles specific events, such as turning off the watchdog during a
- *	shutdown event.
- */
-static int bfin_wdt_notify_sys(struct notifier_block *this,
-					unsigned long code, void *unused)
-{
-	stampit();
-
-	if (code == SYS_DOWN || code == SYS_HALT)
-		bfin_wdt_stop();
-
-	return NOTIFY_DONE;
-}
-
 #ifdef CONFIG_PM
 static int state_before_suspend;
 
@@ -394,33 +372,21 @@ static const struct watchdog_info bfin_wdt_info = {
 		    WDIOF_MAGICCLOSE,
 };
 
-static struct notifier_block bfin_wdt_notifier = {
-	.notifier_call = bfin_wdt_notify_sys,
-};
-
 /**
  *	bfin_wdt_probe - Initialize module
  *
- *	Registers the misc device and notifier handler.  Actual device
+ *	Registers the misc device.  Actual device
  *	initialization is handled by bfin_wdt_open().
  */
 static int __devinit bfin_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
 
-	ret = register_reboot_notifier(&bfin_wdt_notifier);
-	if (ret) {
-		pr_devinit(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
-		return ret;
-	}
-
 	ret = misc_register(&bfin_wdt_miscdev);
 	if (ret) {
 		pr_devinit(KERN_ERR PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 				WATCHDOG_MINOR, ret);
-		unregister_reboot_notifier(&bfin_wdt_notifier);
 		return ret;
 	}
 
@@ -433,21 +399,33 @@ static int __devinit bfin_wdt_probe(struct platform_device *pdev)
 /**
  *	bfin_wdt_remove - Initialize module
  *
- *	Unregisters the misc device and notifier handler.  Actual device
+ *	Unregisters the misc device.  Actual device
  *	deinitialization is handled by bfin_wdt_close().
  */
 static int __devexit bfin_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&bfin_wdt_miscdev);
-	unregister_reboot_notifier(&bfin_wdt_notifier);
 	return 0;
 }
 
+/**
+ *	bfin_wdt_shutdown - Soft Shutdown Handler
+ *
+ *	Handles the soft shutdown event.
+ */
+static void bfin_wdt_shutdown(struct platform_device *pdev)
+{
+	stampit();
+
+	bfin_wdt_stop();
+}
+
 static struct platform_device *bfin_wdt_device;
 
 static struct platform_driver bfin_wdt_driver = {
 	.probe     = bfin_wdt_probe,
 	.remove    = __devexit_p(bfin_wdt_remove),
+	.shutdown  = bfin_wdt_shutdown,
 	.suspend   = bfin_wdt_suspend,
 	.resume    = bfin_wdt_resume,
 	.driver    = {
diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index 364cfee..bcfd572 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -13,7 +13,6 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/fs.h>
-#include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/uaccess.h>
 #include <linux/platform_device.h>
@@ -167,14 +166,6 @@ static long txx9wdt_ioctl(struct file *file, unsigned int cmd,
 	}
 }
 
-static int txx9wdt_notify_sys(struct notifier_block *this, unsigned long code,
-	void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT)
-		txx9wdt_stop();
-	return NOTIFY_DONE;
-}
-
 static const struct file_operations txx9wdt_fops = {
 	.owner		=	THIS_MODULE,
 	.llseek		=	no_llseek,
@@ -190,10 +181,6 @@ static struct miscdevice txx9wdt_miscdev = {
 	.fops	=	&txx9wdt_fops,
 };
 
-static struct notifier_block txx9wdt_notifier = {
-	.notifier_call = txx9wdt_notify_sys,
-};
-
 static int __init txx9wdt_probe(struct platform_device *dev)
 {
 	struct resource *res;
@@ -222,13 +209,8 @@ static int __init txx9wdt_probe(struct platform_device *dev)
 	if (!txx9wdt_reg)
 		goto exit_busy;
 
-	ret = register_reboot_notifier(&txx9wdt_notifier);
-	if (ret)
-		goto exit;
-
 	ret = misc_register(&txx9wdt_miscdev);
 	if (ret) {
-		unregister_reboot_notifier(&txx9wdt_notifier);
 		goto exit;
 	}
 
@@ -250,14 +232,19 @@ exit:
 static int __exit txx9wdt_remove(struct platform_device *dev)
 {
 	misc_deregister(&txx9wdt_miscdev);
-	unregister_reboot_notifier(&txx9wdt_notifier);
 	clk_disable(txx9_imclk);
 	clk_put(txx9_imclk);
 	return 0;
 }
 
+static void txx9wdt_shutdown(struct platform_device *dev)
+{
+	txx9wdt_stop();
+}
+
 static struct platform_driver txx9wdt_driver = {
 	.remove = __exit_p(txx9wdt_remove),
+	.shutdown = txx9wdt_shutdown,
 	.driver = {
 		.name = "txx9wdt",
 		.owner = THIS_MODULE,
