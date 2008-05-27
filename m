Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbYE0Lby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbYE0Lby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 07:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbYE0Lbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 07:31:46 -0400
Received: from smtp09.mtu.ru ([62.5.255.13]:52433 "EHLO smtp09.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799AbYE0Lbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 07:31:46 -0400
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 May 2008 07:31:45 EDT
Message-ID: <483BEF1A.3080808@aknet.ru>
Date: Tue, 27 May 2008 15:23:06 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: ambx1@neo.rr.com, bjorn.helgaas@hp.com, david-b@pacbell.net, mingo@elte.hu,
       tglx@linutronix.de, dbrownell@users.sourceforge.net,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: [patch][resend] provide rtc_cmos platform device, take 2
References: <200805212334.m4LNY42M006425@imap1.linux-foundation.org>
In-Reply-To: <200805212334.m4LNY42M006425@imap1.linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------040408090606020006010905"
X-DCC-STREAM-Metrics: smtp09.mtu.ru; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040408090606020006010905
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello.

akpm@linux-foundation.org wrote:
> This patch was dropped because an updated version will be merged
How is the attached one for an updated
version?

----
RTC doesn't work with pnpacpi=off.
The attached patch fixes the problem by creating the platform device for
the RTC when PNP is disabled. This may also help running the PNP-enabled
kernel on an older PCs.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Cc: David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
CC: Russell King <rmk+lkml@arm.linux.org.uk>

--------------040408090606020006010905
Content-Type: text/x-patch;
 name="rtc_platf1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rtc_platf1.diff"

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 9615eee..01459d2 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -4,9 +4,12 @@
 #include <linux/acpi.h>
 #include <linux/bcd.h>
 #include <linux/mc146818rtc.h>
+#include <linux/platform_device.h>
+#include <linux/pnp.h>
 
 #include <asm/time.h>
 #include <asm/vsyscall.h>
+#include <asm/mc146818rtc.h>
 
 #ifdef CONFIG_X86_32
 /*
@@ -197,3 +200,35 @@ unsigned long long native_read_tsc(void)
 }
 EXPORT_SYMBOL(native_read_tsc);
 
+
+static struct resource rtc_resources[] = {
+	[0] = {
+		.start	= RTC_PORT(0),
+		.end	= RTC_PORT(1),
+		.flags	= IORESOURCE_IO,
+	},
+	[1] = {
+		.start	= RTC_IRQ,
+		.end	= RTC_IRQ,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device rtc_device = {
+	.name		= "rtc_cmos",
+	.id		= -1,
+	.resource	= rtc_resources,
+	.num_resources	= ARRAY_SIZE(rtc_resources),
+};
+
+static __init int add_rtc_cmos(void)
+{
+#ifdef CONFIG_PNP
+	if (!pnp_platform_devices)
+		platform_device_register(&rtc_device);
+#else
+	platform_device_register(&rtc_device);
+#endif /* CONFIG_PNP */
+	return 0;
+}
+device_initcall(add_rtc_cmos);
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index d060a06..d7bb9ba 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -905,19 +905,7 @@ static struct pnp_driver cmos_pnp_driver = {
 	.resume		= cmos_pnp_resume,
 };
 
-static int __init cmos_init(void)
-{
-	return pnp_register_driver(&cmos_pnp_driver);
-}
-module_init(cmos_init);
-
-static void __exit cmos_exit(void)
-{
-	pnp_unregister_driver(&cmos_pnp_driver);
-}
-module_exit(cmos_exit);
-
-#else	/* no PNP */
+#endif	/* CONFIG_PNP */
 
 /*----------------------------------------------------------------*/
 
@@ -958,20 +946,33 @@ static struct platform_driver cmos_platform_driver = {
 
 static int __init cmos_init(void)
 {
+#ifdef	CONFIG_PNP
+	if (pnp_platform_devices)
+		return pnp_register_driver(&cmos_pnp_driver);
+	else
+		return platform_driver_probe(&cmos_platform_driver,
+			cmos_platform_probe);
+#else
 	return platform_driver_probe(&cmos_platform_driver,
 			cmos_platform_probe);
+#endif /* CONFIG_PNP */
 }
 module_init(cmos_init);
 
 static void __exit cmos_exit(void)
 {
+#ifdef	CONFIG_PNP
+	if (pnp_platform_devices)
+		pnp_unregister_driver(&cmos_pnp_driver);
+	else
+		platform_driver_unregister(&cmos_platform_driver);
+#else
 	platform_driver_unregister(&cmos_platform_driver);
+#endif /* CONFIG_PNP */
 }
 module_exit(cmos_exit);
 
 
-#endif	/* !PNP */
-
 MODULE_AUTHOR("David Brownell");
 MODULE_DESCRIPTION("Driver for PC-style 'CMOS' RTCs");
 MODULE_LICENSE("GPL");


--------------040408090606020006010905--
