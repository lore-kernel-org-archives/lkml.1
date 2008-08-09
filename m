Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYHIVmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYHIVmy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 17:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYHIVmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 17:42:46 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:48162 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbYHIVmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 17:42:45 -0400
Message-ID: <489E0F5A.8010404@keyaccess.nl>
Date: Sat, 09 Aug 2008 23:42:50 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] WATCHDOG: don't auto-grab eurotechwdt.
Content-Type: multipart/mixed;
 boundary="------------080402090802000107010702"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080402090802000107010702
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

[ Andrew: not submitted ]

Hi Wim.

I'm going over a list of drivers that break the boot of randconfig 
kernels by keeping resources busy:

http://lkml.org/lkml/2008/8/1/96

and eurotechwdt and plain wdt are in that list. Below is an eurotechwdt 
that makes passing in io and irq values mandatory as to keep that from 
happening.

I saw pcwd was already isafied and followed that -- due to the comment 
in eurwdt_release() though, I'm not sure about a .shutdown() method.

Do you want this in the first place? The randconfig testing does find 
actual bugs so it is useful.

I'll do wdt and the other applicable ones in there as well if yes.

Rene.

--------------080402090802000107010702
Content-Type: text/plain;
 name="0001-WATCHDOG-don-t-auto-grab-eurotechwdt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-WATCHDOG-don-t-auto-grab-eurotechwdt.patch"

>From b31c25c371dd33e6316c327f3f143a2e260d866b Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Sat, 9 Aug 2008 23:24:34 +0200
Subject: [PATCH] WATCHDOG: don't auto-grab eurotechwdt.

---
 drivers/watchdog/eurotechwdt.c |   82 +++++++++++++++++++++++++++-------------
 1 files changed, 55 insertions(+), 27 deletions(-)

diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index b14e9d1..c4eb06c 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -56,6 +56,7 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
+#include <linux/isa.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -70,8 +71,8 @@ static char eur_expect_close;
  * You can use eurwdt=x,y to set these now.
  */
 
-static int io = 0x3f0;
-static int irq = 10;
+static int io;			/* 0x3f0 */
+static int irq = -1;		/* 10    */
 static char *ev = "int";
 
 #define WDT_TIMEOUT		60                /* 1 minute */
@@ -95,9 +96,9 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" _
 
 
 module_param(io, int, 0);
-MODULE_PARM_DESC(io, "Eurotech WDT io port (default=0x3f0)");
+MODULE_PARM_DESC(io, "Eurotech WDT io port (mandatory)");
 module_param(irq, int, 0);
-MODULE_PARM_DESC(irq, "Eurotech WDT irq (default=10)");
+MODULE_PARM_DESC(irq, "Eurotech WDT irq (mandatory)");
 module_param(ev, charp, 0);
 MODULE_PARM_DESC(ev, "Eurotech WDT event type (default is `int')");
 
@@ -385,41 +386,28 @@ static struct notifier_block eurwdt_notifier = {
 	.notifier_call = eurwdt_notify_sys,
 };
 
-/**
- * cleanup_module:
- *
- * Unload the watchdog. You cannot do this with any file handles open.
- * If your watchdog is set to continue ticking on close and you unload
- * it, well it keeps ticking. We won't get the interrupt but the board
- * will not touch PC memory so all is fine. You just have to load a new
- * module in 60 seconds or reboot.
- */
-
-static void __exit eurwdt_exit(void)
+static int __devinit eurwdt_isa_match(struct device *dev, unsigned int id)
 {
-	eurwdt_lock_chip();
+	int match = io != 0 && irq != -1;
 
-	misc_deregister(&eurwdt_miscdev);
+	if (!match)
+		dev_err(dev, "please specify io and irq\n");
 
-	unregister_reboot_notifier(&eurwdt_notifier);
-	release_region(io, 2);
-	free_irq(irq, NULL);
+	return match;
 }
 
-/**
- * eurwdt_init:
- *
+/*
  * Set up the WDT watchdog board. After grabbing the resources
  * we require we need also to unlock the device.
  * The open() function will actually kick the board off.
  */
 
-static int __init eurwdt_init(void)
+static int __devinit eurwdt_isa_probe(struct device *dev, unsigned int id)
 {
 	int ret;
 
 	ret = request_irq(irq, eurwdt_interrupt, IRQF_DISABLED, "eurwdt", NULL);
-	if(ret) {
+	if (ret) {
 		printk(KERN_ERR "eurwdt: IRQ %d is not free.\n", irq);
 		goto out;
 	}
@@ -464,8 +452,48 @@ outirq:
 	goto out;
 }
 
-module_init(eurwdt_init);
-module_exit(eurwdt_exit);
+/*
+ * Unload the watchdog. You cannot do this with any file handles open.
+ * If your watchdog is set to continue ticking on close and you unload
+ * it, well it keeps ticking. We won't get the interrupt but the board
+ * will not touch PC memory so all is fine. You just have to load a new
+ * module in 60 seconds or reboot.
+ */
+
+static int __devexit eurwdt_isa_remove(struct device *dev, unsigned int id)
+{
+	eurwdt_lock_chip();
+
+	misc_deregister(&eurwdt_miscdev);
+
+	unregister_reboot_notifier(&eurwdt_notifier);
+	release_region(io, 2);
+	free_irq(irq, NULL);
+	return 0;
+}
+
+static struct isa_driver eurwdt_isa_driver = {
+	.match		= eurwdt_isa_match,
+	.probe		= eurwdt_isa_probe,
+	.remove		= __devexit_p(eurwdt_isa_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "eurwdt",
+	},
+};
+
+static int __init eurwdt_init_module(void)
+{
+	return isa_register_driver(&eurwdt_isa_driver, 1);
+}
+
+static void __exit eurwdt_exit_module(void)
+{
+	isa_unregister_driver(&eurwdt_isa_driver);
+}
+
+module_init(eurwdt_init_module);
+module_exit(eurwdt_exit_module);
 
 MODULE_AUTHOR("Rodolfo Giometti");
 MODULE_DESCRIPTION("Driver for Eurotech CPU-1220/1410 on board watchdog");
-- 
1.5.5


--------------080402090802000107010702--
