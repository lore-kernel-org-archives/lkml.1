Return-Path: <linux-kernel-owner+w=401wt.eu-S935702AbYBCChe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935702AbYBCChe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 21:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbYBCChZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 21:37:25 -0500
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:43069 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753941AbYBCChX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 21:37:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gDqi36kueJ1txfMIW/uNlo2uErgzjl54tNF3mqNo+2ymg0NN33RcDwwsMHL3G7wGv/rxocL1UzDCW4CebADpcT94gjrwuuJywn++iTA4M5sIonamHJ5/a8kQBhJWVEUxgpBfIEFhMR5hdQdz2y2sjCS0VHX5gbmy61HQZwRHyBs=  ;
X-YMail-OSG: xILA0VcVM1nNAi78V6ZDRlQ_k0dTHSS3Bm2juaj5tSgvMRqDvTPvvSUkDF0UM7ro7kYMCc9_rA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] sleepy linux self-test
Date: Sat, 2 Feb 2008 18:37:17 -0800
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
References: <20080130131748.GA3796@elf.ucw.cz> <20080202193202.GB31621@elf.ucw.cz> <20080202193843.GB32039@elte.hu>
In-Reply-To: <20080202193843.GB32039@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802021837.17777.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > It would have been easier to just use the public interface and 
> > > hard-wire "rtc0".  But going directly to the hardware was dirtier, 
> > > and more in the spirit of "hack that obviously shouldn't go upstream 
> > > until it gets done properly".
> > 
> > Yes, it was "quick and dirty". And I do not think it is going upstream 
> > in this form...?
> 
> which would be a pity - this thing _almost_ started doing suspend and 
> resume cycles on my testsystems, all by itself :-)

OK, here's a version that's cleaner and suspends.  Resuming ...
another story, it's currently broken on this ARM board (no
relationship to this testing code).

Note to Pavel:  yes, the version with the pony *is* better.

- Dave


============ CUT HERE
Updated verion of Pavel's "sleepy" test.  This version doesn't depend on
x86-specific RTC support, or suspend-to-RAM capability, and describes
itself a bit better.

Partially tested on an ARM board ... for some reason system sleep states
are currently broken on that system (new behavior since 2.6.24), so this
won't yet complete.

Note a generic glitch:  the message strings aren't in the same section
as the function using them, so this has a bigger runtime footprint than
it should.

---
 kernel/power/Kconfig  |   14 +++++
 kernel/power/Makefile |    2 
 kernel/power/sleepy.c |  113 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 126 insertions(+), 3 deletions(-)

--- sam9.orig/kernel/power/Kconfig	2008-02-02 03:16:30.000000000 -0800
+++ sam9/kernel/power/Kconfig	2008-02-02 12:47:20.000000000 -0800
@@ -1,3 +1,6 @@
+#
+# Note that power management involves more than just system sleep states...
+#
 config PM
 	bool "Power Management support"
 	depends on !IA64_HP_SIM
@@ -74,8 +77,8 @@ config PM_TRACE_RTC
 	RTC across reboots, so that you can debug a machine that just hangs
 	during suspend (or more commonly, during resume).
 
-	To use this debugging feature you should attempt to suspend the machine,
-	then reboot it, then run
+	To use this debugging feature you should attempt to suspend the
+	machine, then reboot it, then run
 
 		dmesg -s 1000000 | grep 'hash matches'
 
@@ -104,6 +107,13 @@ config SUSPEND
 	  powered and thus its contents are preserved, such as the
 	  suspend-to-RAM state (e.g. the ACPI S3 state).
 
+config PM_WAKEALARM_TEST
+	bool "Test suspend/resume and wakealarm during bootup"
+	depends on SUSPEND && PM_DEBUG && RTC_LIB
+	---help---
+	This option will suspend your machine during bootup, and make
+	it wake up a few seconds later using the RTC's wakeup alarm.
+
 config SUSPEND_FREEZER
 	bool "Enable freezer for suspend to RAM/standby" \
 		if ARCH_WANTS_FREEZER_CONTROL || BROKEN
--- sam9.orig/kernel/power/Makefile	2007-12-20 13:35:13.000000000 -0800
+++ sam9/kernel/power/Makefile	2008-02-02 12:47:20.000000000 -0800
@@ -5,7 +5,7 @@ endif
 
 obj-y				:= main.o
 obj-$(CONFIG_PM_LEGACY)		+= pm.o
-obj-$(CONFIG_PM_SLEEP)		+= process.o console.o
+obj-$(CONFIG_PM_SLEEP)		+= process.o console.o sleepy.o
 obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ sam9/kernel/power/sleepy.c	2008-02-02 18:26:40.000000000 -0800
@@ -0,0 +1,113 @@
+/*
+ * Copyright (c) 2007 Pavel Machek <pavel@suse.cz>
+ * Copyright (c) 2008 David Brownell
+ *
+ * This file is released under the GPLv2
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
+
+static struct rtc_device *rtc;
+static suspend_state_t sleepy_state;
+
+static int __init has_wakealarm(struct device *dev, void *name_ptr)
+{
+	struct rtc_device *candidate = to_rtc_device(dev);
+
+	if (!candidate->ops->set_alarm)
+		return 0;
+	if (!device_may_wakeup(candidate->dev.parent))
+		return 0;
+
+	*(char **)name_ptr = dev->bus_id;
+	return 1;
+}
+
+#ifdef CONFIG_PM_WAKEALARM_TEST
+
+/* This needs to be long enough for the system to suspend all its devices
+ * and enter a suspend-to-RAM (or, potentially, standby) state no matter
+ * what else is going on.  But suspending can take arbitrarily long...
+ */
+#define ALARM_SECONDS	5
+
+static void __init test_wakealarm(void)
+{
+	unsigned long		now;
+	struct rtc_wkalrm	alm;
+	int			status;
+
+	/* this may fail if the RTC hasn't been initialized */
+	status = rtc_read_time(rtc, &alm.time);
+	if (status < 0) {
+		pr_err("PM: can't read %s time, err %d\n",
+				rtc->dev.bus_id, status);
+		return;
+	}
+	rtc_tm_to_time(&alm.time, &now);
+
+	memset(&alm, 0, sizeof alm);
+	rtc_time_to_tm(now + ALARM_SECONDS, &alm.time);
+	alm.enabled = true;
+
+	status = rtc_set_alarm(rtc, &alm);
+	if (status < 0) {
+		pr_err("PM: can't set %s wakealarm, err %d\n",
+				rtc->dev.bus_id, status);
+		return;
+	}
+
+	pr_info("PM: wakealarm test with Suspend-to-RAM\n");
+	sleepy_state = PM_SUSPEND_MEM;
+	status = pm_suspend(sleepy_state);
+	if (status == -ENODEV) {
+		pr_warning("PM: no Suspend-To-RAM, trying standby...\n");
+		sleepy_state = PM_SUSPEND_STANDBY;
+		status = pm_suspend(sleepy_state);
+	}
+	if (status)
+		pr_err("PM: wakealarm test failed, error %d\n", status);
+}
+
+#else
+
+static void __init test_wakealarm(void)
+{
+	/* FIXME sleepy_state is PM_SUSPEND_ON; not useful ... */
+}
+
+#endif
+
+static int __init be_sleepy(void)
+{
+	char *pony = NULL;
+
+	class_find_device(rtc_class, &pony, has_wakealarm);
+	if (pony)
+		rtc = rtc_class_open(pony);
+	else
+		pr_warning("PM: no wakelarm-capable RTC\n");
+
+	if (rtc)
+		test_wakealarm();
+	return 0;
+}
+late_initcall(be_sleepy);
