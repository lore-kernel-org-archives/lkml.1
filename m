Return-Path: <linux-kernel-owner+w=401wt.eu-S1762094AbYBBNtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762094AbYBBNtj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 08:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYBBNtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 08:49:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50997 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbYBBNtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 08:49:31 -0500
Date: Sat, 2 Feb 2008 14:49:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: sleepy linux self-test
Message-ID: <20080202134909.GB925@elte.hu>
References: <20080130131748.GA3796@elf.ucw.cz> <20080130193626.GA15384@elte.hu> <20080130232606.GB5937@elf.ucw.cz> <20080201142255.GA26232@elte.hu> <20080202124540.GA25773@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202124540.GA25773@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> > could you send me a clean patch against mainline please? The above 
> > chunk didnt apply because there's no ksleepyd (only test_sleep()). 
> > Thanks,
> 
> Ok, here's full patch. Good luck,

thanks. Find below it rebased against latest -git. (there was a trivial 
merge reject in power/Kconfig)

	Ingo

---
 drivers/rtc/rtc-cmos.c |   38 ++++++++++++++++++++++++++++++++++---
 kernel/power/Kconfig   |   10 +++++++--
 kernel/power/Makefile  |    2 -
 kernel/power/sleepy.c  |   50 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+), 6 deletions(-)

Index: linux/drivers/rtc/rtc-cmos.c
===================================================================
--- linux.orig/drivers/rtc/rtc-cmos.c
+++ linux/drivers/rtc/rtc-cmos.c
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
@@ -394,6 +394,35 @@ static const struct rtc_class_ops cmos_r
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
+	if (!pc_rtc_device)
+		return -EFAULT;
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
@@ -431,6 +460,8 @@ cmos_do_probe(struct device *dev, struct
 	if (cmos_rtc.dev)
 		return -EBUSY;
 
+	pc_rtc_device = dev;
+
 	if (!ports)
 		return -ENODEV;
 
@@ -546,7 +577,7 @@ cleanup0:
 
 static void cmos_do_shutdown(void)
 {
-	unsigned char	rtc_control;
+	unsigned char rtc_control;
 
 	spin_lock_irq(&rtc_lock);
 	rtc_control = CMOS_READ(RTC_CONTROL);
@@ -561,6 +592,7 @@ static void __exit cmos_do_remove(struct
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	struct resource *ports;
 
+	pc_rtc_device = NULL;
 	cmos_do_shutdown();
 
 	if (is_valid_irq(cmos->irq))
Index: linux/kernel/power/Kconfig
===================================================================
--- linux.orig/kernel/power/Kconfig
+++ linux/kernel/power/Kconfig
@@ -74,14 +74,20 @@ config PM_TRACE_RTC
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
 	depends on SMP
Index: linux/kernel/power/Makefile
===================================================================
--- linux.orig/kernel/power/Makefile
+++ linux/kernel/power/Makefile
@@ -5,7 +5,7 @@ endif
 
 obj-y				:= main.o
 obj-$(CONFIG_PM_LEGACY)		+= pm.o
-obj-$(CONFIG_PM_SLEEP)		+= process.o console.o
+obj-$(CONFIG_PM_SLEEP)		+= process.o console.o sleepy.o
 obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
Index: linux/kernel/power/sleepy.c
===================================================================
--- /dev/null
+++ linux/kernel/power/sleepy.c
@@ -0,0 +1,50 @@
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
+#include <linux/kthread.h>
+
+#include <asm/percpu.h>
+
+#include "power.h"
+
+extern int set_alarm(int length);
+
+int ksleepyd(void *data)
+{
+	msleep(5000);
+	while (1) {
+		if (set_alarm(5))
+			return -EFAULT;
+		pm_suspend(PM_SUSPEND_MEM);
+		msleep(500000);
+	}
+}
+
+#ifdef CONFIG_PM_SLEEPY_TEST
+static int
+test_sleep(void)
+{
+	wake_up_process(kthread_create(ksleepyd, NULL, "ksleepyd"));
+	return 0;
+}
+
+late_initcall(test_sleep);
+#endif
