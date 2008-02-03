Return-Path: <linux-kernel-owner+w=401wt.eu-S935291AbYBCMXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935291AbYBCMXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 07:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762881AbYBCMXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 07:23:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39584 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762580AbYBCMXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 07:23:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] sleepy linux self-test
Date: Sun, 3 Feb 2008 13:21:26 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
References: <20080130131748.GA3796@elf.ucw.cz> <20080203070554.GA11780@elte.hu> <200802022332.58034.david-b@pacbell.net>
In-Reply-To: <200802022332.58034.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802031321.27828.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 3 of February 2008, David Brownell wrote:
> On Saturday 02 February 2008, Ingo Molnar wrote:
> > randconfig testing found the following build failure:
> > 
> > kernel/built-in.o: In function `be_sleepy':
> > sleepy.c:(.init.text+0x1952): undefined reference to `rtc_class'
> > sleepy.c:(.init.text+0x1963): undefined reference to `rtc_class_open'
> 
> Because:
> 
> > CONFIG_RTC_LIB=m
> 
> I think that the wakealarm test:
> 
> > +config PM_WAKEALARM_TEST
> > +       bool "Test suspend/resume and wakealarm during bootup"
> > +       depends on SUSPEND && PM_DEBUG && RTC_LIB

I guess it also should depend on CONFIG_RTC_DRV_CMOS (not being a module)
and !CONFIG_RTC.

> should depend on RTC_LIB=y ... which will prevent that build error,
> but would still allow the RTC to live in a module.
> 
> Updated patch appended ... it should address most config issues.
> 
> - Dave
> 
> 
> ====== CUT HERE
> Updated verion of Pavel's "sleepy" test.  This version doesn't depend on
> x86-specific RTC support, or suspend-to-RAM capability, and describes
> itself a bit better.
> 
> Partially tested on an ARM board ... for some reason system sleep states
> are currently broken on that system (new behavior since 2.6.24), so this
> won't yet complete.
> 
> Note a generic glitch:  the message strings aren't in the same section
> as the function using them, so this has a bigger runtime footprint than
> it should ...
> 
> ---
>  drivers/char/Kconfig  |    5 +-
>  drivers/rtc/Kconfig   |    1 
>  kernel/power/Kconfig  |   17 ++++++-
>  kernel/power/Makefile |    2 
>  kernel/power/sleepy.c |  113 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 134 insertions(+), 4 deletions(-)
> 
> --- g26.orig/drivers/char/Kconfig	2008-02-02 22:42:15.000000000 -0800
> +++ g26/drivers/char/Kconfig	2008-02-02 22:51:53.000000000 -0800
> @@ -715,9 +715,12 @@ config NVRAM
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called nvram.
>  
> +comment "You are using the RTC framework, not the legacy CMOS RTC driver"
> +	depends on RTC_DRV_CMOS
> +
>  config RTC
>  	tristate "Enhanced Real Time Clock Support"
> -	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390
> +	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390 && !RTC_DRV_CMOS
>  	---help---
>  	  If you say Y here and create a character special file /dev/rtc with
>  	  major number 10 and minor number 135 using mknod ("man mknod"), you
> --- g26.orig/drivers/rtc/Kconfig	2008-02-02 22:37:28.000000000 -0800
> +++ g26/drivers/rtc/Kconfig	2008-02-02 22:38:23.000000000 -0800
> @@ -281,6 +281,7 @@ comment "Platform RTC drivers"
>  config RTC_DRV_CMOS
>  	tristate "PC-style 'CMOS'"
>  	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS
> +	default y if X86
>  	help
>  	  Say "yes" here to get direct support for the real time clock
>  	  found in every PC or ACPI-based system, and some other boards.
> --- g26.orig/kernel/power/Kconfig	2008-02-02 22:30:21.000000000 -0800
> +++ g26/kernel/power/Kconfig	2008-02-02 23:28:56.000000000 -0800
> @@ -1,3 +1,6 @@
> +#
> +# Note that power management involves more than just system sleep states...
> +#
>  config PM
>  	bool "Power Management support"
>  	depends on !IA64_HP_SIM
> @@ -74,8 +77,8 @@ config PM_TRACE_RTC
>  	RTC across reboots, so that you can debug a machine that just hangs
>  	during suspend (or more commonly, during resume).
>  
> -	To use this debugging feature you should attempt to suspend the machine,
> -	then reboot it, then run
> +	To use this debugging feature you should attempt to suspend the
> +	machine, then reboot it, then run
>  
>  		dmesg -s 1000000 | grep 'hash matches'
>  
> @@ -104,6 +107,16 @@ config SUSPEND
>  	  powered and thus its contents are preserved, such as the
>  	  suspend-to-RAM state (e.g. the ACPI S3 state).
>  
> +config PM_WAKEALARM_TEST
> +	bool "Test suspend/resume and wakealarm during bootup"
> +	depends on SUSPEND && PM_DEBUG && RTC_LIB=y
> +	---help---
> +	This option will suspend your machine during bootup, and make
> +	it wake up a few seconds later using the RTC's wakeup alarm.
> +
> +	You probably want to have your system's RTC driver statically
> +	linked, ensuring that it's available when this test runs.
> +
>  config SUSPEND_FREEZER
>  	bool "Enable freezer for suspend to RAM/standby" \
>  		if ARCH_WANTS_FREEZER_CONTROL || BROKEN
> --- g26.orig/kernel/power/Makefile	2008-02-02 22:30:21.000000000 -0800
> +++ g26/kernel/power/Makefile	2008-02-02 22:37:18.000000000 -0800
> @@ -5,7 +5,7 @@ endif
>  
>  obj-y				:= main.o
>  obj-$(CONFIG_PM_LEGACY)		+= pm.o
> -obj-$(CONFIG_PM_SLEEP)		+= process.o console.o
> +obj-$(CONFIG_PM_SLEEP)		+= process.o console.o sleepy.o
>  obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
>  
>  obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ g26/kernel/power/sleepy.c	2008-02-02 23:29:53.000000000 -0800
> @@ -0,0 +1,113 @@
> +/*
> + * Copyright (c) 2007 Pavel Machek <pavel@suse.cz>
> + * Copyright (c) 2008 David Brownell
> + *
> + * This file is released under the GPLv2
> + */
> +
> +#include <linux/module.h>
> +#include <linux/suspend.h>
> +#include <linux/kobject.h>
> +#include <linux/string.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/console.h>
> +#include <linux/cpu.h>
> +#include <linux/resume-trace.h>
> +#include <linux/freezer.h>
> +#include <linux/vmstat.h>
> +#include <linux/syscalls.h>
> +#include <linux/rtc.h>
> +
> +#include <asm/percpu.h>
> +
> +#include "power.h"
> +
> +
> +static struct rtc_device *rtc;
> +static suspend_state_t sleepy_state;
> +
> +static int __init has_wakealarm(struct device *dev, void *name_ptr)
> +{
> +	struct rtc_device *candidate = to_rtc_device(dev);
> +
> +	if (!candidate->ops->set_alarm)
> +		return 0;
> +	if (!device_may_wakeup(candidate->dev.parent))
> +		return 0;
> +
> +	*(char **)name_ptr = dev->bus_id;
> +	return 1;
> +}
> +
> +#ifdef CONFIG_PM_WAKEALARM_TEST
> +
> +/* This needs to be long enough for the system to suspend all its devices
> + * and enter a suspend-to-RAM (or, potentially, standby) state no matter
> + * what else is going on.  But suspending can take arbitrarily long...
> + */
> +#define ALARM_SECONDS	5
> +
> +static void __init test_wakealarm(void)
> +{
> +	unsigned long		now;
> +	struct rtc_wkalrm	alm;
> +	int			status;
> +
> +	/* this may fail if the RTC hasn't been initialized */
> +	status = rtc_read_time(rtc, &alm.time);
> +	if (status < 0) {
> +		pr_err("PM: can't read %s time, err %d\n",
> +				rtc->dev.bus_id, status);
> +		return;
> +	}
> +	rtc_tm_to_time(&alm.time, &now);
> +
> +	memset(&alm, 0, sizeof alm);
> +	rtc_time_to_tm(now + ALARM_SECONDS, &alm.time);
> +	alm.enabled = true;
> +
> +	status = rtc_set_alarm(rtc, &alm);
> +	if (status < 0) {
> +		pr_err("PM: can't set %s wakealarm, err %d\n",
> +				rtc->dev.bus_id, status);
> +		return;
> +	}
> +
> +	pr_info("PM: wakealarm test with Suspend-to-RAM\n");
> +	sleepy_state = PM_SUSPEND_MEM;
> +	status = pm_suspend(sleepy_state);
> +	if (status == -ENODEV) {
> +		pr_warning("PM: no Suspend-To-RAM, trying standby...\n");
> +		sleepy_state = PM_SUSPEND_STANDBY;
> +		status = pm_suspend(sleepy_state);
> +	}
> +	if (status)
> +		pr_err("PM: wakealarm test failed, error %d\n", status);
> +}
> +
> +#else
> +
> +static void __init test_wakealarm(void)
> +{
> +	/* FIXME sleepy_state is PM_SUSPEND_ON; not useful ... */
> +}
> +
> +#endif
> +
> +static int __init be_sleepy(void)
> +{
> +	char *pony = NULL;
> +
> +	class_find_device(rtc_class, &pony, has_wakealarm);
> +	if (pony)
> +		rtc = rtc_class_open(pony);
> +	else
> +		pr_warning("PM: no wakealarm-capable RTC driver is ready\n");
> +
> +	if (rtc)
> +		test_wakealarm();
> +	return 0;
> +}
> +late_initcall(be_sleepy);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
