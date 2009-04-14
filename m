Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbZDNJmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbZDNJmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbZDNJjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:39:47 -0400
Received: from mx1.emlix.com ([193.175.82.87]:54193 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbZDNJjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:39:42 -0400
From: Johannes Weiner <jw@emlix.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
       Oskar Schirmer <os@emlix.com>
Subject: [patch 04/12] xtensa: implement ccount calibration for s6000
Date: Tue, 14 Apr 2009 11:41:12 +0200
Message-Id: <1239702080-14355-5-git-send-email-jw@emlix.com>
In-Reply-To: <1239702080-14355-1-git-send-email-jw@emlix.com>
References: <1239702080-14355-1-git-send-email-jw@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oskar Schirmer <os@emlix.com>

Calculate core frequency from timers at boot time
instead of assuming a fixed frequency. This is
useful as the true frequency is set up by the
boot loader, thus variable.

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 arch/xtensa/Kconfig                 |    1 +
 arch/xtensa/variants/s6000/Makefile |    1 +
 arch/xtensa/variants/s6000/delay.c  |   27 +++++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 0 deletions(-)
 create mode 100644 arch/xtensa/variants/s6000/delay.c

diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index fa6dc4d..ac02f3c 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -80,6 +80,7 @@ config XTENSA_VARIANT_S6000
 	bool "s6000 - Stretch software configurable processor"
 	select VARIANT_IRQ_SWITCH
 	select ARCH_REQUIRE_GPIOLIB
+	select XTENSA_CALIBRATE_CCOUNT
 endchoice
 
 config XTENSA_UNALIGNED_USER
diff --git a/arch/xtensa/variants/s6000/Makefile b/arch/xtensa/variants/s6000/Makefile
index 03b3975..d83f380 100644
--- a/arch/xtensa/variants/s6000/Makefile
+++ b/arch/xtensa/variants/s6000/Makefile
@@ -1,3 +1,4 @@
 # s6000 Makefile
 
 obj-y		+= irq.o gpio.o
+obj-$(CONFIG_XTENSA_CALIBRATE_CCOUNT)	+= delay.o
diff --git a/arch/xtensa/variants/s6000/delay.c b/arch/xtensa/variants/s6000/delay.c
new file mode 100644
index 0000000..54b2b57
--- /dev/null
+++ b/arch/xtensa/variants/s6000/delay.c
@@ -0,0 +1,27 @@
+#include <asm/delay.h>
+#include <asm/timex.h>
+#include <asm/io.h>
+#include <variant/hardware.h>
+
+#define LOOPS 10
+void platform_calibrate_ccount(void)
+{
+	u32 uninitialized_var(a);
+	u32 uninitialized_var(u);
+	u32 b;
+	u32 tstamp = S6_REG_GREG1 + S6_GREG1_GLOBAL_TIMER;
+	int i = LOOPS+1;
+	do {
+		u32 t = u;
+		asm volatile(
+		"1:	l32i %0, %2, 0 ;"
+		"	beq %0, %1, 1b ;"
+		: "=&a"(u) : "a"(t), "a"(tstamp));
+		b = xtensa_get_ccount();
+		if (i == LOOPS)
+			a = b;
+	} while (--i >= 0);
+	b -= a;
+	nsec_per_ccount = (LOOPS * 10000) / b;
+	ccount_per_jiffy = b * (100000UL / (LOOPS * HZ));
+}
-- 
1.6.2.107.ge47ee

