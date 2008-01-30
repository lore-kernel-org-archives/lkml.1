Return-Path: <linux-kernel-owner+w=401wt.eu-S1760474AbYA3NRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760474AbYA3NRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbYA3NRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:17:42 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33840 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755534AbYA3NRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:17:41 -0500
Date: Wed, 30 Jan 2008 14:17:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: sleepy linux self-test
Message-ID: <20080130131748.GA3796@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This version should work, at least it did not fail in my testing. It
does one test 5 second after bootup, then periodically once per 500
seconds. Different parameters are trivial to tweak.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 29cf145..5bbdb70 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -78,7 +78,7 @@ static inline int is_intr(u8 rtc_intr)
 
 /*----------------------------------------------------------------*/
 
-static int cmos_read_time(struct device *dev, struct rtc_time *t)
+int cmos_read_time(struct device *dev, struct rtc_time *t)
 {
 	/* REVISIT:  if the clock has a "century" register, use
 	 * that instead of the heuristic in get_rtc_time().
@@ -170,7 +170,7 @@ static int cmos_read_alarm(struct device
 	return 0;
 }
 
-static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
+int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned char	mon, mday, hrs, min, sec;
@@ -394,6 +394,33 @@ static const struct rtc_class_ops cmos_r
 /*----------------------------------------------------------------*/
 
 static struct cmos_rtc	cmos_rtc;
+static struct device *pc_rtc_device;
+
+int set_alarm(int length)
+{
+	ssize_t retval;
+	unsigned long now, alarm;
+	struct rtc_wkalrm alm;
+
+	retval = cmos_read_time(pc_rtc_device, &alm.time);
+	if (retval < 0) {
+		printk("Auto sleep: can't get time?\n");
+		return retval;
+	}
+	rtc_tm_to_time(&alm.time, &now);
+	printk("Auto sleep: Now %ld\n", now);
+
+	alarm = now+length;
+	rtc_time_to_tm(alarm, &alm.time);
+
+	retval = cmos_set_alarm(pc_rtc_device, &alm);
+	if (retval < 0) {
+		printk("Auto sleep: can't set alarm.\n");
+		return retval;
+	}
+	printk("Auto sleep: Alarm set\n");
+	return 0;
+}
 
 static irqreturn_t cmos_interrupt(int irq, void *p)
 {
@@ -431,6 +458,8 @@ cmos_do_probe(struct device *dev, struct
 	if (cmos_rtc.dev)
 		return -EBUSY;
 
+	pc_rtc_device = dev;
+
 	if (!ports)
 		return -ENODEV;
 
@@ -546,7 +575,7 @@ cleanup0:
 
 static void cmos_do_shutdown(void)
 {
-	unsigned char	rtc_control;
+	unsigned char rtc_control;
 
 	spin_lock_irq(&rtc_lock);
 	rtc_control = CMOS_READ(RTC_CONTROL);
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 8e186c6..b719fd3 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -53,14 +53,20 @@ config PM_TRACE
 	RTC across reboots, so that you can debug a machine that just hangs
 	during suspend (or more commonly, during resume).
 
-	To use this debugging feature you should attempt to suspend the machine,
-	then reboot it, then run
+	To use this debugging feature you should attempt to suspend the
+	machine, then reboot it, then run
 
 		dmesg -s 1000000 | grep 'hash matches'
 
 	CAUTION: this option will cause your machine's real-time clock to be
 	set to an invalid time after a resume.
 
+config PM_SLEEPY_TEST
+	bool "Test suspend/resume during bootup"
+	depends on PM_DEBUG && PM_SLEEP && RTC_DRV_CMOS
+	---help---
+	This option will suspend/resume your machine during bootup.
+
 config PM_SLEEP_SMP
 	bool
 	depends on SUSPEND_SMP_POSSIBLE || HIBERNATION_SMP_POSSIBLE
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index f7dfff2..e5693d6 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -5,7 +5,7 @@ endif
 
 obj-y				:= main.o
 obj-$(CONFIG_PM_LEGACY)		+= pm.o
-obj-$(CONFIG_PM_SLEEP)		+= process.o console.o
+obj-$(CONFIG_PM_SLEEP)		+= process.o console.o sleepy.o
 obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
diff --git a/kernel/power/sleepy.c b/kernel/power/sleepy.c
new file mode 100644
index 0000000..d363260
--- /dev/null
+++ b/kernel/power/sleepy.c
@@ -0,0 +1,39 @@
+/*
+ * Copyright (c) 2007 Pavel Machek <pavel@suse.cz>
+ * 
+ * This file is released under the GPLv2
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/suspend.h>
+#include <linux/kobject.h>
+#include <linux/string.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/cpu.h>
+#include <linux/resume-trace.h>
+#include <linux/freezer.h>
+#include <linux/vmstat.h>
+#include <linux/syscalls.h>
+#include <linux/rtc.h>
+
+#include <asm/percpu.h>
+
+#include "power.h"
+
+extern int set_alarm(int length);
+
+#ifdef CONFIG_PM_SLEEPY_TEST
+static int
+test_sleep(void)
+{
+	set_alarm(5);
+	pm_suspend(PM_SUSPEND_MEM);
+	return 0;
+}
+
+late_initcall(test_sleep);
+#endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
