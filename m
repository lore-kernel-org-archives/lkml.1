Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbZA0BEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbZA0BEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 20:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZA0BE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 20:04:27 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:9423 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZA0BE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 20:04:26 -0500
Subject: [PATCH] rtc: add rtc_systohc for ntp use
From: Ed Swierk <eswierk@aristanetworks.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com, tglx@linutronix.de,
       mingo@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 26 Jan 2009 17:04:22 -0800
Message-Id: <1233018262.14510.111.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following up to Alessandro's RFC of 10 Nov 2008, this patch implements
rtc_systohc() to update the configured rtc device (cmos, i2c, etc.) from
the ntp-synchronized system clock.  It changes the ntp update code to
call rtc_systohc() rather than update_persistent_clock() which (at least
on x86) always updates the cmos rtc.

No attempt is made to compensate for the 500-ms delay imposed when
setting a cmos rtc chip.  If you actually have a cmos rtc you can stick
with the existing code, but at some point it would be nice to unify
these.

Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>

---
Index: linux-2.6.28.2/drivers/rtc/Kconfig
===================================================================
--- linux-2.6.28.2.orig/drivers/rtc/Kconfig
+++ linux-2.6.28.2/drivers/rtc/Kconfig
@@ -30,7 +30,7 @@ config RTC_HCTOSYS
 	  unnecessary fsck runs at boot time, and to network better.
 
 config RTC_HCTOSYS_DEVICE
-	string "RTC used to set the system time"
+	string "RTC used to set the system time on startup and resume"
 	depends on RTC_HCTOSYS = y
 	default "rtc0"
 	help
@@ -52,6 +52,23 @@ config RTC_HCTOSYS_DEVICE
 	  sleep states. Do not specify an RTC here unless it stays powered
 	  during all this system's supported sleep states.
 
+config RTC_SYSTOHC
+	bool "Set RTC from system time in NTP sync mode"
+	depends on RTC_CLASS = y
+	default y
+	help
+	  If you say yes here, the system time (wall clock) will be written
+	  to the hardware clock every 11 minutes, if the kernel is in NTP
+	  mode and your platforms supports it.
+
+config RTC_SYSTOHC_DEVICE
+	string "RTC used to save the system time in NTP sync mode"
+	depends on RTC_SYSTOHC = y
+	default "rtc0"
+	help
+	  The RTC device that will get written with the system time
+	  in NTP mode.
+
 config RTC_DEBUG
 	bool "RTC debug support"
 	depends on RTC_CLASS = y
Index: linux-2.6.28.2/drivers/rtc/Makefile
===================================================================
--- linux-2.6.28.2.orig/drivers/rtc/Makefile
+++ linux-2.6.28.2/drivers/rtc/Makefile
@@ -8,6 +8,7 @@ endif
 
 obj-$(CONFIG_RTC_LIB)		+= rtc-lib.o
 obj-$(CONFIG_RTC_HCTOSYS)	+= hctosys.o
+obj-$(CONFIG_RTC_SYSTOHC)	+= systohc.o
 obj-$(CONFIG_RTC_CLASS)		+= rtc-core.o
 rtc-core-y			:= class.o interface.o
 
Index: linux-2.6.28.2/drivers/rtc/systohc.c
===================================================================
--- /dev/null
+++ linux-2.6.28.2/drivers/rtc/systohc.c
@@ -0,0 +1,36 @@
+/*
+ * RTC subsystem, systohc for ntp use
+ *
+ * Copyright (C) 2008 Tower Technologies
+ * Author: Alessandro Zummo <a.zummo@towertech.it>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/rtc.h>
+
+int rtc_systohc(void)
+{
+	int err;
+	struct rtc_time tm;
+	struct rtc_device *rtc = rtc_class_open(CONFIG_RTC_SYSTOHC_DEVICE);
+
+	if (rtc == NULL) {
+		printk("%s: unable to open rtc device (%s)\n",
+			__FILE__, CONFIG_RTC_SYSTOHC_DEVICE);
+		return -ENODEV;
+	}
+
+	rtc_time_to_tm(get_seconds(), &tm);
+	err = rtc_set_time(rtc, &tm);
+	if (err != 0)
+		dev_err(rtc->dev.parent,
+			"systohc: unable to set the hardware clock\n");
+
+	rtc_class_close(rtc);
+
+	return err;
+}
+EXPORT_SYMBOL(rtc_systohc);
Index: linux-2.6.28.2/kernel/time/ntp.c
===================================================================
--- linux-2.6.28.2.orig/kernel/time/ntp.c
+++ linux-2.6.28.2/kernel/time/ntp.c
@@ -221,17 +221,20 @@ static void sync_cmos_clock(struct work_
 
 static DECLARE_DELAYED_WORK(sync_cmos_work, sync_cmos_clock);
 
+#ifdef CONFIG_RTC_SYSTOHC
+extern int rtc_systohc(void);
+#endif
+
 static void sync_cmos_clock(struct work_struct *work)
 {
+#ifndef CONFIG_RTC_SYSTOHC
 	struct timespec now, next;
 	int fail = 1;
+#endif
 
 	/*
 	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 * This code is run on a timer.  If the clock is set, that timer
-	 * may not expire at the correct time.  Thus, we adjust...
+	 * CMOS clock accordingly every ~11 minutes.
 	 */
 	if (!ntp_synced())
 		/*
@@ -240,6 +243,19 @@ static void sync_cmos_clock(struct work_
 		 */
 		return;
 
+#ifdef CONFIG_RTC_SYSTOHC
+
+	rtc_systohc();
+	schedule_delayed_work(&sync_cmos_work, 660*HZ);
+
+#else
+
+	/*
+	 * Set_rtc_mmss() has to be called as close as possible to 500 ms
+	 * before the new second starts.  This code is run on a timer.
+	 * If the clock is set, that timer may not expire at the correct
+	 * time.  Thus, we adjust...
+	 */
 	getnstimeofday(&now);
 	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
 		fail = update_persistent_clock(now);
@@ -258,6 +274,8 @@ static void sync_cmos_clock(struct work_
 		next.tv_nsec -= NSEC_PER_SEC;
 	}
 	schedule_delayed_work(&sync_cmos_work, timespec_to_jiffies(&next));
+
+#endif
 }
 
 static void notify_cmos_timer(void)


