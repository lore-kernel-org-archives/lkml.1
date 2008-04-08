Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYDHPkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYDHPkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 11:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYDHPkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:40:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54732 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbYDHPkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:40:06 -0400
Date: Tue, 8 Apr 2008 17:39:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader
	decompressor
Message-ID: <20080408153942.GA26932@elte.hu>
References: <20080405013014.478571000@polaris-admin.engr.sgi.com> <20080405013014.693571000@polaris-admin.engr.sgi.com> <20080405134626.GA15894@mailshack.com> <47FA6478.1070301@sgi.com> <20080407214434.GA5296@mailshack.com> <20080408122007.GA11832@mailshack.com> <20080408134112.GA4277@elte.hu> <47FB8AD2.2040201@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FB8AD2.2040201@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> > 
> >> Hi Ingo,
> >>
> >> I see you have applied the following patch to x86#for-akpm. It was 
> >> really ment for testing only. I think you ment to use this one 
> >> instead?
> > 
> > yep, i wanted to see how it holds up in testing - it's OK so far. I've 
> > got your other, fuller one queued up meanwhile - it's not pushed out 
> > yet.
> > 
> > 	Ingo
> 
> I will try it out on my failing case as soon as I can...

more test results: i just booted an allyesconfig 64-bit (MAXSMP, etc.) 
kernel on x86 native hardware successfully - that has Alexander's patch 
included but not your boot tweak. (has all your other patches included)

would you expect a real 4K CPUs system to boot any differently? So early 
during bootup all x86 hardware is just a uniprocessor, so i'd be 
surprised if there was any difference.

[ in any case, if the tweak still makes a real difference for you we can 
  still apply it because it does not hurt anyone - but lets try to avoid 
  black voodoo tweaks as much as possible :) ]

btw,. booting up MAXSMP is pretty impressive:

  CONFIG_NR_CPUS=4096

shows how far Linux scalability has come :)

i've got a bugreport for you though: MAXSMP does not suspend+resume 
correctly ;-) It gets this far:

[  146.348790] PM: Syncing filesystems ... done.
[  146.353488] PM: Preparing system for mem sleep
[  146.360204] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  146.367172] Freezing remaining freezable tasks ... (elapsed 0.93 seconds) done.
[  147.309618] PM: Entering mem sleep
[  147.313032] Suspending console(s)

then reboots spontaneously instead of resuming. (I use the 
suspend+resume self-test feature below to conduct automated 
suspend/resume tests.)

	Ingo

------------------------->
Subject: suspend: sleepy linux self-test
From: David Brownell <david-b@pacbell.net>

See the appended; it includes more of Ingo's suggestions.

Since this is increasingly unrelated to the "sleepy linux" concept
(a version of what systems like OLPC, N700, and N800 are doing), I
got rid of the "sleepy.c" file.

- Dave

============ CUT HERE
Boot-time test for system suspend states (STR or standby).  The generic
RTC framework triggers wakeup alarms, used to exit those states.

  - Measures some aspects of suspend time; uses "jiffies".  This
    should probably use a clocksource instead, since those often
    work properly even while IRQs are disabled.

  - Includes a command line parameter, which needs work yet ... it
    currently turns this test off, but it should also let the target
    state be specified (and maybe even default to "no test").

Lightly tested on an ARM system, which reported that suspending devices
took 7 msec and resuming them took 132 msec:

  * The PCMCIA stack misbehaved a bit.  It didn't finish enumerating
    the card before it suspended, so the wakeup event came from the
    CF card IRQ not from the RTC!

  * The MMC stack misbehaved more seriously.  It wants to remove devices
    during the suspend sequence (quite needlessly, on this hardware),
    which now makes Linux unhappy.

Workaround in both cases was to take the memory card out before booting.

Also includes some Kconfig tweaks to help reduce configuration bugs on
x86, by avoiding the legacy RTC driver when the generic RTC framework
is enabled ... those should become a separate patch.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/char/Kconfig |    5 +
 drivers/rtc/Kconfig  |    1 
 kernel/power/Kconfig |   10 +++
 kernel/power/main.c  |  163 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 178 insertions(+), 1 deletion(-)

Index: linux/drivers/char/Kconfig
===================================================================
--- linux.orig/drivers/char/Kconfig
+++ linux/drivers/char/Kconfig
@@ -704,9 +704,12 @@ config NVRAM
 	  To compile this driver as a module, choose M here: the
 	  module will be called nvram.
 
+comment "You are using the RTC framework, not the legacy CMOS RTC driver"
+	depends on RTC_DRV_CMOS
+
 config RTC
 	tristate "Enhanced Real Time Clock Support"
-	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390
+	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390 && !RTC_DRV_CMOS
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
Index: linux/drivers/rtc/Kconfig
===================================================================
--- linux.orig/drivers/rtc/Kconfig
+++ linux/drivers/rtc/Kconfig
@@ -303,6 +303,7 @@ comment "Platform RTC drivers"
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
 	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS
+	default y if X86
 	help
 	  Say "yes" here to get direct support for the real time clock
 	  found in every PC or ACPI-based system, and some other boards.
Index: linux/kernel/power/Kconfig
===================================================================
--- linux.orig/kernel/power/Kconfig
+++ linux/kernel/power/Kconfig
@@ -104,6 +104,16 @@ config SUSPEND
 	  powered and thus its contents are preserved, such as the
 	  suspend-to-RAM state (e.g. the ACPI S3 state).
 
+config PM_TEST_SUSPEND
+	bool "Test suspend/resume and wakealarm during bootup"
+	depends on SUSPEND && PM_DEBUG && RTC_LIB=y
+	---help---
+	This option will suspend your machine during bootup, and make
+	it wake up a few seconds later using the RTC's wakeup alarm.
+
+	You probably want to have your system's RTC driver statically
+	linked, ensuring that it's available when this test runs.
+
 config SUSPEND_FREEZER
 	bool "Enable freezer for suspend to RAM/standby" \
 		if ARCH_WANTS_FREEZER_CONTROL || BROKEN
Index: linux/kernel/power/main.c
===================================================================
--- linux.orig/kernel/power/main.c
+++ linux/kernel/power/main.c
@@ -132,6 +132,52 @@ static inline int suspend_test(int level
 
 #ifdef CONFIG_SUSPEND
 
+#ifdef CONFIG_PM_TEST_SUSPEND
+
+/*
+ * We test the system suspend code by setting an RTC wakealarm a short
+ * time in the future, then suspending.  Suspending the devices won't
+ * normally take long ... some systems only need a few milliseconds.
+ *
+ * The time it takes is system-specific though, so when we test this
+ * during system bootup we allow a LOT of time.
+ */
+#define TEST_SUSPEND_SECONDS	5
+
+static unsigned long suspend_test_start_time;
+
+static void suspend_test_start(void)
+{
+	/* FIXME Use better timebase than "jiffies", ideally a clocksource.
+	 * What we want is a hardware counter that will work correctly even
+	 * during the irqs-are-off stages of the suspend/resume cycle...
+	 */
+	suspend_test_start_time = jiffies;
+}
+
+static void suspend_test_finish(const char *label)
+{
+	long nj = jiffies - suspend_test_start_time;
+	unsigned msec;
+
+	msec = jiffies_to_msecs((nj >= 0) ? nj : -nj);
+	pr_info("PM: %s took %d.%03d seconds\n", label,
+			msec / 1000, msec % 1000);
+	WARN_ON_ONCE(msec > ((TEST_SUSPEND_SECONDS+5) * 1000));
+}
+
+#else
+
+static void suspend_test_start(void)
+{
+}
+
+static void suspend_test_finish(const char *label)
+{
+}
+
+#endif
+
 /* This is just an arbitrary number */
 #define FREE_PAGE_NUMBER (100)
 
@@ -264,11 +310,14 @@ int suspend_devices_and_enter(suspend_st
 			goto Close;
 	}
 	suspend_console();
+
+	suspend_test_start();
 	error = device_suspend(PMSG_SUSPEND);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to suspend\n");
 		goto Resume_console;
 	}
+	suspend_test_finish("suspend devices");
 
 	if (suspend_test(TEST_DEVICES))
 		goto Resume_devices;
@@ -291,7 +340,9 @@ int suspend_devices_and_enter(suspend_st
 	if (suspend_ops->finish)
 		suspend_ops->finish();
  Resume_devices:
+	suspend_test_start();
 	device_resume();
+	suspend_test_finish("resume devices");
  Resume_console:
 	resume_console();
  Close:
@@ -515,3 +566,115 @@ static int __init pm_init(void)
 }
 
 core_initcall(pm_init);
+
+
+#ifdef CONFIG_PM_TEST_SUSPEND
+
+#include <linux/rtc.h>
+
+/*
+ * To test system suspend, we need a hands-off mechanism to resume the
+ * system.  RTCs with wakeup alarms are the the most common mechanism
+ * that's self-contained.
+ */
+
+static void __init test_wakealarm(struct rtc_device *rtc, suspend_state_t state)
+{
+	static char	err_readtime [] __initdata =
+		KERN_ERR "PM: can't read %s time, err %d\n";
+	static char	err_wakealarm [] __initdata =
+		KERN_ERR "PM: can't set %s wakealarm, err %d\n";
+	static char	err_suspend [] __initdata =
+		KERN_ERR "PM: suspend test failed, error %d\n";
+	static char	info_test [] __initdata =
+		KERN_INFO "PM: test RTC wakeup from '%s' suspend\n";
+
+	unsigned long		now;
+	struct rtc_wkalrm	alm;
+	int			status;
+
+	/* this may fail if the RTC hasn't been initialized */
+	status = rtc_read_time(rtc, &alm.time);
+	if (status < 0) {
+		printk(err_readtime, rtc->dev.bus_id, status);
+		return;
+	}
+	rtc_tm_to_time(&alm.time, &now);
+
+	memset(&alm, 0, sizeof alm);
+	rtc_time_to_tm(now + TEST_SUSPEND_SECONDS, &alm.time);
+	alm.enabled = true;
+
+	status = rtc_set_alarm(rtc, &alm);
+	if (status < 0) {
+		printk(err_wakealarm, rtc->dev.bus_id, status);
+		return;
+	}
+
+	if (state == PM_SUSPEND_MEM) {
+		printk(info_test, pm_states[state]);
+		status = pm_suspend(state);
+		if (status == -ENODEV)
+			state = PM_SUSPEND_STANDBY;
+	}
+	if (state == PM_SUSPEND_STANDBY) {
+		printk(info_test, pm_states[state]);
+		status = pm_suspend(state);
+	}
+	if (status < 0)
+		printk(err_suspend, status);
+}
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
+/*
+ * We normally test Suspend-to-RAM, with standby as a backup when
+ * the system doesn't support that state.  But we also need to be
+ * able to disable the powerup test, and tell it to ignore STR since
+ * the RTC may not work then.
+ */
+static suspend_state_t test_state __initdata = PM_SUSPEND_MEM;
+
+static int __init setup_test_suspend(char *value)
+{
+	/* FIXME accept "standby", etc */
+	test_state = PM_SUSPEND_ON;
+	return 0;
+}
+__setup("test_suspend", setup_test_suspend);
+
+static int __init test_suspend(void)
+{
+	static char	warn_no_rtc[] __initdata =
+		KERN_WARNING "PM: no wakealarm-capable RTC driver is ready\n";
+
+	char			*pony = NULL;
+	struct rtc_device	*rtc = NULL;
+
+	class_find_device(rtc_class, &pony, has_wakealarm);
+	if (pony)
+		rtc = rtc_class_open(pony);
+
+	if (rtc) {
+		if (test_state != PM_SUSPEND_ON)
+			test_wakealarm(rtc, test_state);
+		rtc_class_close(rtc);
+	} else
+		printk(warn_no_rtc);
+
+	return 0;
+}
+late_initcall(test_suspend);
+
+#endif /* CONFIG_PM_TEST_SUSPEND */

