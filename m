Return-Path: <linux-kernel-owner+w=401wt.eu-S1764867AbYETS02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764867AbYETS02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbYETS0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:26:16 -0400
Received: from mail.aknet.ru ([78.158.192.26]:53772 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234AbYETS0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:26:15 -0400
Message-ID: <483317B4.7060601@aknet.ru>
Date: Tue, 20 May 2008 22:25:56 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>
CC: dbrownell@users.sourceforge.net
Subject: [patch] provide rtc_cmos platform device
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------020303020107070407030301"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020303020107070407030301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello.

Recently (around 2.6.25) I've noticed
that RTC no longer works for me.
It turned out this is because I use
pnpacpi=off kernel option to work
around the parport_pc bugs.
I always did so, but RTC used to work
fine in the past, and now it have
regressed.

The attached patch fixes the problem
by creating the platform device for
the RTC when PNP is disabled.
This may also help running the
PNP-enabled kernel on an older PCs.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>

--------------020303020107070407030301
Content-Type: text/x-patch;
 name="rtc_platf.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rtc_platf.diff"

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 9615eee..270ee8e 100644
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
+#include <asm/rtc.h>
 
 #ifdef CONFIG_X86_32
 /*
@@ -197,3 +200,31 @@ unsigned long long native_read_tsc(void)
 }
 EXPORT_SYMBOL(native_read_tsc);
 
+
+static struct resource rtc_resources[] = {
+	[0] = {
+		.start	= RTC_PORT_START,
+		.end	= RTC_PORT_END,
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
+	if (!pnp_platform_devices)
+		platform_device_register(&rtc_device);
+	return 0;
+}
+device_initcall(add_rtc_cmos);
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index d060a06..b3ac5a0 100644
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
 
@@ -958,20 +946,24 @@ static struct platform_driver cmos_platform_driver = {
 
 static int __init cmos_init(void)
 {
-	return platform_driver_probe(&cmos_platform_driver,
+	if (pnp_platform_devices)
+		return pnp_register_driver(&cmos_pnp_driver);
+	else
+		return platform_driver_probe(&cmos_platform_driver,
 			cmos_platform_probe);
 }
 module_init(cmos_init);
 
 static void __exit cmos_exit(void)
 {
-	platform_driver_unregister(&cmos_platform_driver);
+	if (pnp_platform_devices)
+		pnp_unregister_driver(&cmos_pnp_driver);
+	else
+		platform_driver_unregister(&cmos_platform_driver);
 }
 module_exit(cmos_exit);
 
 
-#endif	/* !PNP */
-
 MODULE_AUTHOR("David Brownell");
 MODULE_DESCRIPTION("Driver for PC-style 'CMOS' RTCs");
 MODULE_LICENSE("GPL");
diff --git a/include/asm-x86/rtc.h b/include/asm-x86/rtc.h
index f71c3b0..d28ed3e 100644
--- a/include/asm-x86/rtc.h
+++ b/include/asm-x86/rtc.h
@@ -1 +1,5 @@
 #include <asm-generic/rtc.h>
+
+#define RTC_PORT_START 0x70
+#define RTC_PORT_END 0x71
+#define RTC_IRQ 8

--------------020303020107070407030301--
