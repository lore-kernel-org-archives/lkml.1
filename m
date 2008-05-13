Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbYEMD3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbYEMD3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 23:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbYEMD2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 23:28:53 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62362 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757950AbYEMD2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 23:28:36 -0400
Date: Tue, 13 May 2008 04:26:30 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       David Woodhouse <dwmw2@infradead.org>,
       Jean Delvare <khali@linux-fr.org>, Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>
cc: rtc-linux@googlegroups.com, i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] RTC: Class device support for persistent clock (#2)
Message-ID: <Pine.LNX.4.55.0805130232030.535@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This is a generic implementation of rtc_read_persistent_clock() and
rtc_update_persistent_clock() suitable for platforms to be used for
read_persistent_clock() and update_persistent_clock() calls.  An RTC
device selected by the user with the RTC_HCTOSYS_DEVICE option is used.  

 As rtc_read_persistent_clock() is not available at the time
timekeeping_init() is called, it will now be disabled if the class device
is to be used as a reference.  In this case rtc_hctosys(), already
present, will be used to set up the system time at the late initcall time.  
This call has now been rewritten to make use of
rtc_read_persistent_clock().

 As rtc_set_mmss() used by rtc_update_persistent_clock() may sleep for
some hardware, the call is now made from a work queue scheduled by the
timer originally used for the entire function.  However, following
DavidW's suggestion, the mutex in rtc_set_mmss() is now obtained with
mutex_trylock() a failure of which makes the function terminate, so that
latency from the caller to the point where hardware is accessed is
minimised.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-rtc-persistent-clock-14
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/rtc/Kconfig linux-2.6.26-rc1-20080505/drivers/rtc/Kconfig
--- linux-2.6.26-rc1-20080505.macro/drivers/rtc/Kconfig	2008-05-05 02:55:40.000000000 +0000
+++ linux-2.6.26-rc1-20080505/drivers/rtc/Kconfig	2008-05-05 21:41:34.000000000 +0000
@@ -21,24 +21,30 @@ menuconfig RTC_CLASS
 if RTC_CLASS
 
 config RTC_HCTOSYS
-	bool "Set system time from RTC on startup and resume"
+	bool "Use time from RTC as a reference for the system time"
 	depends on RTC_CLASS = y
 	default y
 	help
-	  If you say yes here, the system time (wall clock) will be set using
-	  the value read from a specified RTC device. This is useful to avoid
-	  unnecessary fsck runs at boot time, and to network better.
+	  If you say yes here, the specified RTC device will be used
+	  as a reference to the system time (wall clock).  The device
+	  will be used to set the system time as required during
+	  startup, suspend and, for platforms that support such usage,
+	  for NTP timekeeping.
+
+	  This is useful to avoid unnecessary fsck runs at boot time,
+	  and to network better.
 
 config RTC_HCTOSYS_DEVICE
-	string "RTC used to set the system time"
+	string "RTC used as a reference for the system time"
 	depends on RTC_HCTOSYS = y
 	default "rtc0"
 	help
-	  The RTC device that will be used to (re)initialize the system
+	  The RTC device that will be used as a reference for the system
 	  clock, usually rtc0.  Initialization is done when the system
-	  starts up, and when it resumes from a low power state.  This
-	  device should record time in UTC, since the kernel won't do
-	  timezone correction.
+	  starts up, and when it resumes from a low power state.  Also,
+	  if supported by the platform, NTP timekeeping uses this device
+	  to record the system time periodically.  This device should
+	  record time in UTC, since the kernel won't do timezone correction.
 
 	  The driver for this RTC device must be loaded before late_initcall
 	  functions run, so it must usually be statically linked.
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/rtc/hctosys.c linux-2.6.26-rc1-20080505/drivers/rtc/hctosys.c
--- linux-2.6.26-rc1-20080505.macro/drivers/rtc/hctosys.c	2008-05-05 02:55:40.000000000 +0000
+++ linux-2.6.26-rc1-20080505/drivers/rtc/hctosys.c	2008-05-11 19:18:19.000000000 +0000
@@ -1,8 +1,9 @@
 /*
- * RTC subsystem, initialize system time on startup
+ * RTC subsystem, persistent clock and startup initialization support
  *
  * Copyright (C) 2005 Tower Technologies
  * Author: Alessandro Zummo <a.zummo@towertech.it>
+ * Copyright (C) 2008  Maciej W. Rozycki
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -22,46 +23,86 @@
  * the best guess is to add 0.5s.
  */
 
-static int __init rtc_hctosys(void)
+/*
+ * Note the unusual API:
+ * zero returned means a failure, anything else is seconds from epoch.
+ */
+unsigned long rtc_read_persistent_clock(void)
 {
-	int err;
-	struct rtc_time tm;
 	struct rtc_device *rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
+	struct rtc_time tm;
+	unsigned long time = 0;
 
 	if (rtc == NULL) {
-		printk("%s: unable to open rtc device (%s)\n",
-			__FILE__, CONFIG_RTC_HCTOSYS_DEVICE);
-		return -ENODEV;
+		printk(KERN_ERR "hctosys: unable to open rtc device (%s)\n",
+		       CONFIG_RTC_HCTOSYS_DEVICE);
+		goto out;
+	}
+	if (rtc_read_time(rtc, &tm) < 0) {
+		dev_err(rtc->dev.parent,
+			"hctosys: unable to read the hardware clock\n");
+		goto out_close;
 	}
+	if (rtc_valid_tm(&tm) < 0) {
+		dev_err(rtc->dev.parent, "hctosys: invalid date/time\n");
+		goto out_close;
+	}
+
+	rtc_tm_to_time(&tm, &time);
+
+out_close:
+	rtc_class_close(rtc);
+out:
+	return time;
+}
+
+int rtc_update_persistent_clock(struct timespec now)
+{
+	struct rtc_device *rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
+	int err;
 
-	err = rtc_read_time(rtc, &tm);
-	if (err == 0) {
-		err = rtc_valid_tm(&tm);
-		if (err == 0) {
-			struct timespec tv;
-
-			tv.tv_nsec = NSEC_PER_SEC >> 1;
-
-			rtc_tm_to_time(&tm, &tv.tv_sec);
-
-			do_settimeofday(&tv);
-
-			dev_info(rtc->dev.parent,
-				"setting system clock to "
-				"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
-				tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
-				tm.tm_hour, tm.tm_min, tm.tm_sec,
-				(unsigned int) tv.tv_sec);
-		}
-		else
+	if (rtc == NULL) {
+		printk(KERN_ERR "hctosys: unable to open rtc device (%s)\n",
+		       CONFIG_RTC_HCTOSYS_DEVICE);
+		err = -ENXIO;
+		goto out;
+	}
+	err = rtc_set_mmss(rtc, now.tv_sec);
+	if (err < 0) {
+		if (err != -EBUSY)
 			dev_err(rtc->dev.parent,
-				"hctosys: invalid date/time\n");
+				"hctosys: unable to set the hardware clock\n");
+		goto out_close;
 	}
-	else
-		dev_err(rtc->dev.parent,
-			"hctosys: unable to read the hardware clock\n");
 
+	err = 0;
+
+out_close:
 	rtc_class_close(rtc);
+out:
+	return err;
+}
+
+static int __init rtc_hctosys(void)
+{
+	struct rtc_time tm;
+	struct timespec tv;
+	unsigned long time;
+
+	time = rtc_read_persistent_clock();
+	if (!time)
+		return -ENODEV;
+
+	tv.tv_nsec = NSEC_PER_SEC >> 1;
+	tv.tv_sec = time;
+	do_settimeofday(&tv);
+
+	rtc_time_to_tm(time, &tm);
+	pr_info("%s: setting system clock to "
+		"%d-%02d-%02d %02d:%02d:%02d UTC (%lu)\n",
+		CONFIG_RTC_HCTOSYS_DEVICE,
+		tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
+		tm.tm_hour, tm.tm_min, tm.tm_sec, (unsigned long)tv.tv_sec);
 
 	return 0;
 }
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/rtc/interface.c linux-2.6.26-rc1-20080505/drivers/rtc/interface.c
--- linux-2.6.26-rc1-20080505.macro/drivers/rtc/interface.c	2008-05-05 02:55:40.000000000 +0000
+++ linux-2.6.26-rc1-20080505/drivers/rtc/interface.c	2008-05-11 19:32:40.000000000 +0000
@@ -64,8 +64,7 @@ int rtc_set_mmss(struct rtc_device *rtc,
 {
 	int err;
 
-	err = mutex_lock_interruptible(&rtc->ops_lock);
-	if (err)
+	if (!mutex_trylock(&rtc->ops_lock))
 		return -EBUSY;
 
 	if (!rtc->ops)
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/include/linux/rtc.h linux-2.6.26-rc1-20080505/include/linux/rtc.h
--- linux-2.6.26-rc1-20080505.macro/include/linux/rtc.h	2008-05-05 02:55:59.000000000 +0000
+++ linux-2.6.26-rc1-20080505/include/linux/rtc.h	2008-05-05 21:10:50.000000000 +0000
@@ -200,6 +200,9 @@ extern int rtc_irq_set_state(struct rtc_
 extern int rtc_irq_set_freq(struct rtc_device *rtc,
 				struct rtc_task *task, int freq);
 
+extern unsigned long rtc_read_persistent_clock(void);
+extern int rtc_update_persistent_clock(struct timespec now);
+
 typedef struct rtc_task {
 	void (*func)(void *private_data);
 	void *private_data;
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/kernel/time/ntp.c linux-2.6.26-rc1-20080505/kernel/time/ntp.c
--- linux-2.6.26-rc1-20080505.macro/kernel/time/ntp.c	2008-05-05 02:56:03.000000000 +0000
+++ linux-2.6.26-rc1-20080505/kernel/time/ntp.c	2008-05-05 21:10:50.000000000 +0000
@@ -3,6 +3,8 @@
  *
  * NTP state machine interfaces and logic.
  *
+ * Copyright (c) 2008  Maciej W. Rozycki
+ *
  * This code was mainly moved from kernel/timer.c and kernel/time.c
  * Please see those files for relevant copyright info and historical
  * changelogs.
@@ -17,6 +19,7 @@
 #include <linux/capability.h>
 #include <linux/math64.h>
 #include <linux/clocksource.h>
+#include <linux/workqueue.h>
 #include <asm/timex.h>
 
 /*
@@ -218,11 +221,13 @@ void second_overflow(void)
 /* Disable the cmos update - used by virtualization and embedded */
 int no_sync_cmos_clock  __read_mostly;
 
-static void sync_cmos_clock(unsigned long dummy);
+static void sync_cmos_clock(unsigned long data);
+static void do_sync_cmos_clock(struct work_struct *work);
 
 static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);
+static DECLARE_WORK(sync_cmos_work, do_sync_cmos_clock);
 
-static void sync_cmos_clock(unsigned long dummy)
+static void do_sync_cmos_clock(struct work_struct *work)
 {
 	struct timespec now, next;
 	int fail = 1;
@@ -261,6 +266,12 @@ static void sync_cmos_clock(unsigned lon
 	mod_timer(&sync_cmos_timer, jiffies + timespec_to_jiffies(&next));
 }
 
+static void sync_cmos_clock(unsigned long data)
+{
+	/* Some implementations of update_persistent_clock() may sleep.  */
+	schedule_work(&sync_cmos_work);
+}
+
 static void notify_cmos_timer(void)
 {
 	if (!no_sync_cmos_clock)
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/kernel/time/timekeeping.c linux-2.6.26-rc1-20080505/kernel/time/timekeeping.c
--- linux-2.6.26-rc1-20080505.macro/kernel/time/timekeeping.c	2008-05-05 02:56:03.000000000 +0000
+++ linux-2.6.26-rc1-20080505/kernel/time/timekeeping.c	2008-05-05 21:10:50.000000000 +0000
@@ -242,7 +242,11 @@ unsigned long __attribute__((weak)) read
 void __init timekeeping_init(void)
 {
 	unsigned long flags;
-	unsigned long sec = read_persistent_clock();
+	unsigned long sec = 0;
+
+#ifndef CONFIG_RTC_HCTOSYS
+	sec = read_persistent_clock();
+#endif
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
