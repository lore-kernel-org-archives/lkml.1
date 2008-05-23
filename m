Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbYEWFCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbYEWFCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 01:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYEWFCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 01:02:13 -0400
Received: from mail.aknet.ru ([78.158.192.26]:61798 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbYEWFCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 01:02:13 -0400
Message-ID: <48364FCC.2060205@aknet.ru>
Date: Fri, 23 May 2008 09:02:04 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [patch] provide rtc_cmos platform device, take 2
References: <200805212334.m4LNY42M006425@imap1.linux-foundation.org>
In-Reply-To: <200805212334.m4LNY42M006425@imap1.linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------050009000402040901010605"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050009000402040901010605
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello.

[forgot to CC this to LKML, doing now]

akpm@linux-foundation.org wrote:
> This patch was dropped because an updated version will be merged
How is the attached one for an updated
version? Please check the compilation
on arm as I haven't done that.

----
Recently (around 2.6.25) I've noticed that RTC no longer works for me.  It
turned out this is because I use pnpacpi=off kernel option to work around
the parport_pc bugs.  I always did so, but RTC used to work fine in the
past, and now it have regressed.

The attached patch fixes the problem by creating the platform device for
the RTC when PNP is disabled.  This may also help running the PNP-enabled
kernel on an older PCs.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Cc: David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>


--------------050009000402040901010605
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


--------------050009000402040901010605--
