Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZCIN16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZCIN16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 09:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbZCIN0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:26:37 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35637 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751285AbZCIN03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:26:29 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Kyle McMartin <kyle@mcmartin.ca>
Cc: rtc-linux@googlegroups.com, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Dann Frazier <dannf@dannf.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH 5/7] m68k: Hook up rtc-generic
Date: Mon,  9 Mar 2009 14:26:21 +0100
Message-Id: <1236605183-22718-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1236605183-22718-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1236605183-22718-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1236605183-22718-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1236605183-22718-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1236605183-22718-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k has been a long time user of the generic RTC abstraction, so hook up
rtc-generic:
  - Create the "rtc-generic" platform device if mach_hwclk is set,
  - Add checks for mach_hwclk, in anticipation of RTC chip drivers being moved
    to drivers/rtc/.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 arch/m68k/include/asm/rtc.h |    7 +++++--
 arch/m68k/kernel/time.c     |   18 ++++++++++++++++++
 drivers/rtc/Kconfig         |    2 +-
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/include/asm/rtc.h b/arch/m68k/include/asm/rtc.h
index 5d3e038..a4d08ea 100644
--- a/arch/m68k/include/asm/rtc.h
+++ b/arch/m68k/include/asm/rtc.h
@@ -36,13 +36,16 @@ static inline unsigned int get_rtc_time(struct rtc_time *time)
 	 * RTC has RTC_DAY_OF_WEEK, we ignore it, as it is only updated
 	 * by the RTC when initially set to a non-zero value.
 	 */
-	mach_hwclk(0, time);
+	if (mach_hwclk)
+		mach_hwclk(0, time);
 	return RTC_24H;
 }
 
 static inline int set_rtc_time(struct rtc_time *time)
 {
-	return mach_hwclk(1, time);
+	if (mach_hwclk)
+		return mach_hwclk(1, time);
+	return -EINVAL;
 }
 
 static inline unsigned int get_rtc_ss(void)
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 7db4159..54d9807 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/rtc.h>
+#include <linux/platform_device.h>
 
 #include <asm/machdep.h>
 #include <asm/io.h>
@@ -159,3 +160,20 @@ int do_settimeofday(struct timespec *tv)
 }
 
 EXPORT_SYMBOL(do_settimeofday);
+
+
+static int __init rtc_init(void)
+{
+	struct platform_device *pdev;
+
+	if (!mach_hwclk)
+		return -ENODEV;
+
+	pdev = platform_device_register_simple("rtc-generic", -1, NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	return 0;
+}
+
+module_init(rtc_init);
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index d0aeff2..c8ead87 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -681,7 +681,7 @@ config RTC_DRV_GENERIC
 	tristate "Generic RTC support"
 	# Please consider writing a new RTC driver instead of using the generic
 	# RTC abstraction
-	depends on PARISC
+	depends on PARISC || M68K
 	help
 	  Say Y or M here to enable RTC support on systems using the generic
 	  RTC abstraction. If you do not know what you are doing, you should
-- 
1.6.0.4

