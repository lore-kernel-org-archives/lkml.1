Return-Path: <linux-kernel-owner+w=401wt.eu-S1759219AbYFBRkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219AbYFBRkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbYFBRis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:38:48 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:14474 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758130AbYFBRir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:38:47 -0400
Date: Mon, 2 Jun 2008 21:38:46 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>, Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jochen Friedrich <jochen@scram.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] [WATCHDOG] mpc8xxx_wdt: add support for MPC8xx
	watchdogs
Message-ID: <20080602173846.GF30705@polina.dev.rtsoft.ru>
References: <20080602173726.GA24556@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080602173726.GA24556@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mpc8xxx_wdt driver is using two registers: SWSRR to push magic
numbers, and SWCRR to control the watchdog. Both registers are available
on the MPC8xx, and seem to have the same offsets and semantics as in
MPC83xx/MPC86xx watchdogs. The only difference is prescale value. So this
driver simply works on the MPC8xx CPUs.

One quirk is needed for the MPC8xx, though. It has small prescale value
and slow CPU, so the watchdog resets board prior to the driver has time
to load. To solve this we should split initialization in two steps: start
ping the watchdog early, and register the watchdog userspace interface
later.

MPC823 seem to be the first CPU in MPC8xx line, so we use fsl,mpc823-wdt
compatible matching.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Tested-by: Jochen Friedrich <jochen@scram.de>
---
 drivers/watchdog/Kconfig       |    3 +-
 drivers/watchdog/mpc8xxx_wdt.c |   44 ++++++++++++++++++++++++++++++----------
 2 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 008eaa6..f9e617b 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -684,10 +684,11 @@ config 8xx_WDT
 
 config 8xxx_WDT
 	tristate "MPC8xxx Platform Watchdog Timer"
-	depends on PPC_83xx || PPC_86xx
+	depends on PPC_8xx || PPC_83xx || PPC_86xx
 	help
 	  This driver is for a SoC level watchdog that exists on some
 	  Freescale PowerPC processors. So far this driver supports:
+	  - MPC8xx watchdogs
 	  - MPC83xx watchdogs
 	  - MPC86xx watchdogs
 
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 2f0681f..0f7e165 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -1,5 +1,5 @@
 /*
- * mpc8xxx_wdt.c - MPC83xx/MPC86xx watchdog userspace interface
+ * mpc8xxx_wdt.c - MPC8xx/MPC83xx/MPC86xx watchdog userspace interface
  *
  * Authors: Dave Updegraff <dave@cray.org>
  * 	    Kumar Gala <galak@kernel.crashing.org>
@@ -207,13 +207,6 @@ static int __devinit mpc8xxx_wdt_probe(struct of_device *ofdev,
 		goto err_unmap;
 	}
 
-	ret = misc_register(&mpc8xxx_wdt_miscdev);
-	if (ret) {
-		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
-		goto err_unmap;
-	}
-
 	/* Calculate the timeout in seconds */
 	if (prescale)
 		timeout_sec = (timeout * wdt_type->prescaler) / freq;
@@ -234,6 +227,7 @@ static int __devinit mpc8xxx_wdt_probe(struct of_device *ofdev,
 	return 0;
 err_unmap:
 	iounmap(wd_base);
+	wd_base = NULL;
 	return ret;
 }
 
@@ -261,6 +255,12 @@ static const struct of_device_id mpc8xxx_wdt_match[] = {
 			.hw_enabled = true,
 		},
 	},
+	{
+		.compatible = "fsl,mpc823-wdt",
+		.data = &(struct mpc8xxx_wdt_type) {
+			.prescaler = 0x800,
+		},
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, mpc8xxx_wdt_match);
@@ -275,20 +275,42 @@ static struct of_platform_driver mpc8xxx_wdt_driver = {
 	},
 };
 
+/*
+ * We do wdt initialization in two steps: arch_initcall probes the wdt
+ * very early to start pinging the watchdog (misc devices are not yet
+ * available), and later module_init() just registers the misc device.
+ */
+static int __init mpc8xxx_wdt_init_late(void)
+{
+	int ret;
+
+	if (!wd_base)
+		return -ENODEV;
+
+	ret = misc_register(&mpc8xxx_wdt_miscdev);
+	if (ret) {
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+			WATCHDOG_MINOR, ret);
+		return ret;
+	}
+	return 0;
+}
+module_init(mpc8xxx_wdt_init_late);
+
 static int __init mpc8xxx_wdt_init(void)
 {
 	return of_register_platform_driver(&mpc8xxx_wdt_driver);
 }
+arch_initcall(mpc8xxx_wdt_init);
 
 static void __exit mpc8xxx_wdt_exit(void)
 {
 	of_unregister_platform_driver(&mpc8xxx_wdt_driver);
 }
-
-subsys_initcall(mpc8xxx_wdt_init);
 module_exit(mpc8xxx_wdt_exit);
 
 MODULE_AUTHOR("Dave Updegraff, Kumar Gala");
-MODULE_DESCRIPTION("Driver for watchdog timer in MPC83xx/MPC86xx uProcessors");
+MODULE_DESCRIPTION("Driver for watchdog timer in MPC8xx/MPC83xx/MPC86xx "
+		   "uProcessors");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-- 
1.5.5.1

