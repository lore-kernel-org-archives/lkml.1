Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbZLRQEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbZLRQEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbZLRQEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:04:53 -0500
Received: from lo.gmane.org ([80.91.229.12]:53129 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbZLRQEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 11:04:53 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@collabora.co.uk>
Subject: Re: 2.6.33-rc1 compile error (geode watchdog / mfgpt related)
Date: Fri, 18 Dec 2009 11:03:58 -0500
Message-ID: <20091218110358.66c4ec17@mycelium.queued.net>
References: <4B2B79D3.1070706@nets.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: wireless.queued.net
In-Reply-To: <4B2B79D3.1070706@nets.rwth-aachen.de>
X-Newsreader: Claws Mail 3.7.3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Cc: linux-geode@bombadil.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 13:47:15 +0100
Arnd Hannemann
<hannemann@nets.rwth-aachen.de> wrote:

> Hi,
> 
> 2.6.33-rc1 does not compile for me:
> 
>   CC      drivers/watchdog/geodewdt.o
> drivers/watchdog/geodewdt.c: In function 'geodewdt_ping':
> drivers/watchdog/geodewdt.c:55: error: implicit declaration of
> function 'geode_mfgpt_write' drivers/watchdog/geodewdt.c: In function
> 'geodewdt_probe': drivers/watchdog/geodewdt.c:220: error: implicit
> declaration of function 'geode_mfgpt_alloc_timer'
> drivers/watchdog/geodewdt.c:235: error: implicit declaration of
> function 'geode_mfgpt_toggle_event' make[2]: ***
> [drivers/watchdog/geodewdt.o] Error 1 make[1]: *** [drivers/watchdog]
> Error 2 make: *** [drivers] Error 2
> 

Whoops, I missed that driver; sorry about that.

The patch below should fix it..



Subject: [PATCH] watchdog: update geodewdt for new MFGPT API

Update to the new cs5535_mfgpt* API.  The geode-specific wording should
eventually be dropped from this driver...

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 drivers/watchdog/Kconfig    |    2 +-
 drivers/watchdog/geodewdt.c |   40 +++++++++++++++++++---------------------
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index da84fd0..088f32f 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -368,7 +368,7 @@ config ALIM7101_WDT
 
 config GEODE_WDT
 	tristate "AMD Geode CS5535/CS5536 Watchdog"
-	depends on MGEODE_LX
+	depends on CS5535_MFGPT
 	help
 	  This driver enables a watchdog capability built into the
 	  CS5535/CS5536 companion chips for the AMD Geode GX and LX
diff --git a/drivers/watchdog/geodewdt.c b/drivers/watchdog/geodewdt.c
index 9acf001..38252ff 100644
--- a/drivers/watchdog/geodewdt.c
+++ b/drivers/watchdog/geodewdt.c
@@ -1,6 +1,7 @@
-/* Watchdog timer for the Geode GX/LX with the CS5535/CS5536 companion chip
+/* Watchdog timer for machines with the CS5535/CS5536 companion chip
  *
  * Copyright (C) 2006-2007, Advanced Micro Devices, Inc.
+ * Copyright (C) 2009  Andres Salomon <dilinger@collabora.co.uk>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -19,7 +20,7 @@
 #include <linux/reboot.h>
 #include <linux/uaccess.h>
 
-#include <asm/geode.h>
+#include <linux/cs5535.h>
 
 #define GEODEWDT_HZ 500
 #define GEODEWDT_SCALE 6
@@ -46,25 +47,25 @@ MODULE_PARM_DESC(nowayout,
 
 static struct platform_device *geodewdt_platform_device;
 static unsigned long wdt_flags;
-static int wdt_timer;
+static struct cs5535_mfgpt_timer *wdt_timer;
 static int safe_close;
 
 static void geodewdt_ping(void)
 {
 	/* Stop the counter */
-	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
+	cs5535_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
 
 	/* Reset the counter */
-	geode_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
+	cs5535_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
 
 	/* Enable the counter */
-	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, MFGPT_SETUP_CNTEN);
+	cs5535_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, MFGPT_SETUP_CNTEN);
 }
 
 static void geodewdt_disable(void)
 {
-	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
-	geode_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
+	cs5535_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
+	cs5535_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
 }
 
 static int geodewdt_set_heartbeat(int val)
@@ -72,10 +73,10 @@ static int geodewdt_set_heartbeat(int val)
 	if (val < 1 || val > GEODEWDT_MAX_SECONDS)
 		return -EINVAL;
 
-	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
-	geode_mfgpt_write(wdt_timer, MFGPT_REG_CMP2, val * GEODEWDT_HZ);
-	geode_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
-	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, MFGPT_SETUP_CNTEN);
+	cs5535_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
+	cs5535_mfgpt_write(wdt_timer, MFGPT_REG_CMP2, val * GEODEWDT_HZ);
+	cs5535_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
+	cs5535_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, MFGPT_SETUP_CNTEN);
 
 	timeout = val;
 	return 0;
@@ -215,28 +216,25 @@ static struct miscdevice geodewdt_miscdev = {
 
 static int __devinit geodewdt_probe(struct platform_device *dev)
 {
-	int ret, timer;
-
-	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
+	int ret;
 
-	if (timer == -1) {
+	wdt_timer = cs5535_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
+	if (!wdt_timer) {
 		printk(KERN_ERR "geodewdt:  No timers were available\n");
 		return -ENODEV;
 	}
 
-	wdt_timer = timer;
-
 	/* Set up the timer */
 
-	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP,
+	cs5535_mfgpt_write(wdt_timer, MFGPT_REG_SETUP,
 			  GEODEWDT_SCALE | (3 << 8));
 
 	/* Set up comparator 2 to reset when the event fires */
-	geode_mfgpt_toggle_event(wdt_timer, MFGPT_CMP2, MFGPT_EVENT_RESET, 1);
+	cs5535_mfgpt_toggle_event(wdt_timer, MFGPT_CMP2, MFGPT_EVENT_RESET, 1);
 
 	/* Set up the initial timeout */
 
-	geode_mfgpt_write(wdt_timer, MFGPT_REG_CMP2,
+	cs5535_mfgpt_write(wdt_timer, MFGPT_REG_CMP2,
 		timeout * GEODEWDT_HZ);
 
 	ret = misc_register(&geodewdt_miscdev);
-- 
1.5.6.5





