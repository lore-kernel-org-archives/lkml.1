Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbYEMODu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbYEMODu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760282AbYEMODk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:03:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34049 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbYEMODh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:03:37 -0400
Date: Tue, 13 May 2008 16:02:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Glauber Costa <gcosta@redhat.com>, Glauber Costa <glommer@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix app crashes after SMP resume
Message-ID: <20080513140237.GA18798@elte.hu>
References: <Pine.LNX.4.64.0805131420030.5781@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805131420030.5781@blonde.site>
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


* Hugh Dickins <hugh@veritas.com> wrote:

> After resume on a 2cpu laptop, kernel builds collapse with a sed hang, 
> sh or make segfault (often on 20295564), real-time signal to cc1 etc.
> 
> Several hurdles to jump, but a manually-assisted bisect led to -rc1's 
> d2bcbad5f3ad38a1c09861bca7e252dde7bb8259 x86: do not zap_low_mappings 
> in __smp_prepare_cpus.  Though the low mappings were removed at 
> bootup, they were left behind (with Global flags helping to keep them 
> in TLB) after resume or cpu online, causing the crashes seen.
> 
> Reinstate zap_low_mappings (with local __flush_tlb_all) for each 
> cpu_up on x86_32.  This used to be serialized by smp_commenced_mask: 
> that's now gone, but a low_mappings flag will do.  No need for 
> native_smp_cpus_done to repeat the zap: let mem_init zap BSP's low 
> mappings just like on UP.
> 
> (In passing, fix error code from native_cpu_up: do_boot_cpu returns a 
> variety of diagnostic values, Dprintk what it says but convert to 
> -EIO. And save_pg_dir separately before zap_low_mappings: doesn't 
> matter now, but zapping twice in succession wiped out resume's 
> swsusp_pg_dir.)
> 
> That worked well on the duo and one quad, but wouldn't boot 3rd or 4th 
> cpu on P4 Xeon, oopsing just after unlock_ipi_call_lock.  The TLB 
> flush IPI now being sent reveals a long-standing bug: the booting cpu 
> has its APIC readied in smp_callin at the top of start_secondary, but 
> isn't put into the cpu_online_map until just before that 
> unlock_ipi_call_lock.
> 
> So native_smp_call_function_mask to online cpus would 
> send_IPI_allbutself, including the cpu just coming up, though it has 
> been excluded from the count to wait for: by the time it handles the 
> IPI, the call data on native_smp_call_function_mask's stack may well 
> have been overwritten.
> 
> So fall back to send_IPI_mask while cpu_online_map does not match 
> cpu_callout_map: perhaps there's a better APICological fix to be made 
> at the start_secondary end, but I wouldn't know that.

applied, thanks Hugh! You've once again proven that you are worth your 
weight in gold and more. Patch looks very clean and simplifies the code.

> I've often wondered: should git reject any commit with "bad" in the 
> id?

hehe :)

ob'note: would be nice to have the suspend+resume self-test/debug patch 
below upstream. It programs the RTC to a 5 second sleep and resumes the 
computer, which then self-wakeups afterwards.

	Ingo

-------------------------------->
Subject: suspend+resume self-test
From: David Brownell <david-b@pacbell.net>

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/power/Kconfig |   10 +++
 kernel/power/main.c  |  163 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 173 insertions(+)

Index: linux/kernel/power/Kconfig
===================================================================
--- linux.orig/kernel/power/Kconfig
+++ linux/kernel/power/Kconfig
@@ -94,6 +94,16 @@ config SUSPEND
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
