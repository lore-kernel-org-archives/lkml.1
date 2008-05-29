Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbYE2VBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbYE2VBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYE2VBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:01:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40915 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYE2VA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:00:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.26-rc4-git] PM: boot time suspend selftest
Date: Thu, 29 May 2008 23:01:41 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: lkml <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@suse.cz>
References: <200805291333.42057.david-b@pacbell.net>
In-Reply-To: <200805291333.42057.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805292301.42244.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 29 of May 2008, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Boot-time test for system suspend states (STR or standby).  The generic
> RTC framework triggers wakeup alarms, which are used to exit those states.
> 
>   - Measures some aspects of suspend time ... this uses "jiffies" until
>     someone converts it to use a timebase that works properly even while
>     timer IRQs are disabled. 
> 
>   - Triggered by a command line parameter.  By default nothing even
>     vaguely troublesome will happen, but "test_suspend=mem" will give
>     you a brief STR test during system boot.  (Or you may need to use
>     "test_suspend=standby" instead, if your hardware needs that.)
> 
> This isn't without problems.  It fires early enough during boot that for
> example both PCMCIA and MMC stacks have misbehaved.  The workaround in
> those cases was to boot without such media cards inserted.

Two questions:

1) How is it related to the analogous patch in the Ingo's tree?
2) Does it apply to the current linux-next?

Thanks,
Rafael


> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> I've used this on some ARM boards, and Ingo says it's been a big
> help avoiding (upstream) regressions for x86.git work.  Based on
> some early work from Pavel, who wanted a pony.  ;)
> 
>  Documentation/kernel-parameters.txt |    9 +
>  kernel/power/Kconfig                |   11 ++
>  kernel/power/main.c                 |  185 ++++++++++++++++++++++++++++++++++
>  3 files changed, 204 insertions(+), 1 deletion(-)
> 
> --- a/Documentation/kernel-parameters.txt	2008-05-29 13:14:07.000000000 -0700
> +++ b/Documentation/kernel-parameters.txt	2008-05-29 13:14:08.000000000 -0700
> @@ -87,7 +87,8 @@ parameter is applicable:
>  	SH	SuperH architecture is enabled.
>  	SMP	The kernel is an SMP kernel.
>  	SPARC	Sparc architecture is enabled.
> -	SWSUSP	Software suspend is enabled.
> +	SWSUSP	Software suspend (hibernation) is enabled.
> +	SUSPEND	System suspend states are enabled.
>  	TS	Appropriate touchscreen support is enabled.
>  	USB	USB support is enabled.
>  	USBHID	USB Human Interface Device support is enabled.
> @@ -2035,6 +2036,12 @@ and is between 256 and 4096 characters. 
>  
>  	tdfx=		[HW,DRM]
>  
> +	test_suspend=	[SUSPEND]
> +			Specify "mem" (for Suspend-to-RAM) or "standby" (for
> +			standby suspend) as the system sleep state to briefly
> +			enter during system startup.  The system is woken from
> +			this state using a wakeup-capable RTC alarm.
> +
>  	thash_entries=	[KNL,NET]
>  			Set number of hash buckets for TCP connection
>  
> --- a/kernel/power/Kconfig	2008-05-29 13:14:07.000000000 -0700
> +++ b/kernel/power/Kconfig	2008-05-29 13:14:08.000000000 -0700
> @@ -94,6 +94,17 @@ config SUSPEND
>  	  powered and thus its contents are preserved, such as the
>  	  suspend-to-RAM state (e.g. the ACPI S3 state).
>  
> +config PM_TEST_SUSPEND
> +	bool "Test suspend/resume and wakealarm during bootup"
> +	depends on SUSPEND && PM_DEBUG && RTC_LIB=y
> +	---help---
> +	This option will let you suspend your machine during bootup, and
> +	make it wake up a few seconds later using an RTC wakeup alarm.
> +	Enable this with a kernel parameter like "test_suspend=mem".
> +
> +	You probably want to have your system's RTC driver statically
> +	linked, ensuring that it's available when this test runs.
> +
>  config SUSPEND_FREEZER
>  	bool "Enable freezer for suspend to RAM/standby" \
>  		if ARCH_WANTS_FREEZER_CONTROL || BROKEN
> --- a/kernel/power/main.c	2008-05-29 13:14:07.000000000 -0700
> +++ b/kernel/power/main.c	2008-05-29 13:14:08.000000000 -0700
> @@ -132,6 +132,52 @@ static inline int suspend_test(int level
>  
>  #ifdef CONFIG_SUSPEND
>  
> +#ifdef CONFIG_PM_TEST_SUSPEND
> +
> +/*
> + * We test the system suspend code by setting an RTC wakealarm a short
> + * time in the future, then suspending.  Suspending the devices won't
> + * normally take long ... some systems only need a few milliseconds.
> + *
> + * The time it takes is system-specific though, so when we test this
> + * during system bootup we allow a LOT of time.
> + */
> +#define TEST_SUSPEND_SECONDS	5
> +
> +static unsigned long suspend_test_start_time;
> +
> +static void suspend_test_start(void)
> +{
> +	/* FIXME Use better timebase than "jiffies", ideally a clocksource.
> +	 * What we want is a hardware counter that will work correctly even
> +	 * during the irqs-are-off stages of the suspend/resume cycle...
> +	 */
> +	suspend_test_start_time = jiffies;
> +}
> +
> +static void suspend_test_finish(const char *label)
> +{
> +	long nj = jiffies - suspend_test_start_time;
> +	unsigned msec;
> +
> +	msec = jiffies_to_msecs((nj >= 0) ? nj : -nj);
> +	pr_info("PM: %s took %d.%03d seconds\n", label,
> +			msec / 1000, msec % 1000);
> +	WARN_ON_ONCE(msec > (TEST_SUSPEND_SECONDS * 1000));
> +}
> +
> +#else
> +
> +static void suspend_test_start(void)
> +{
> +}
> +
> +static void suspend_test_finish(const char *label)
> +{
> +}
> +
> +#endif
> +
>  /* This is just an arbitrary number */
>  #define FREE_PAGE_NUMBER (100)
>  
> @@ -264,11 +310,14 @@ int suspend_devices_and_enter(suspend_st
>  			goto Close;
>  	}
>  	suspend_console();
> +
> +	suspend_test_start();
>  	error = device_suspend(PMSG_SUSPEND);
>  	if (error) {
>  		printk(KERN_ERR "PM: Some devices failed to suspend\n");
>  		goto Resume_console;
>  	}
> +	suspend_test_finish("suspend devices");
>  
>  	if (suspend_test(TEST_DEVICES))
>  		goto Resume_devices;
> @@ -291,7 +340,9 @@ int suspend_devices_and_enter(suspend_st
>  	if (suspend_ops->finish)
>  		suspend_ops->finish();
>   Resume_devices:
> +	suspend_test_start();
>  	device_resume();
> +	suspend_test_finish("resume devices");
>   Resume_console:
>  	resume_console();
>   Close:
> @@ -515,3 +566,137 @@ static int __init pm_init(void)
>  }
>  
>  core_initcall(pm_init);
> +
> +
> +#ifdef CONFIG_PM_TEST_SUSPEND
> +
> +#include <linux/rtc.h>
> +
> +/*
> + * To test system suspend, we need a hands-off mechanism to resume the
> + * system.  RTCs wake alarms are a common self-contained mechanism.
> + */
> +
> +static void __init test_wakealarm(struct rtc_device *rtc, suspend_state_t state)
> +{
> +	static char		err_readtime [] __initdata =
> +		KERN_ERR "PM: can't read %s time, err %d\n";
> +	static char		err_wakealarm [] __initdata =
> +		KERN_ERR "PM: can't set %s wakealarm, err %d\n";
> +	static char		err_suspend [] __initdata =
> +		KERN_ERR "PM: suspend test failed, error %d\n";
> +	static char		info_test [] __initdata =
> +		KERN_INFO "PM: test RTC wakeup from '%s' suspend\n";
> +
> +	unsigned long		now;
> +	struct rtc_wkalrm	alm;
> +	int			status;
> +
> +	/* this may fail if the RTC hasn't been initialized */
> +	status = rtc_read_time(rtc, &alm.time);
> +	if (status < 0) {
> +		printk(err_readtime, rtc->dev.bus_id, status);
> +		return;
> +	}
> +	rtc_tm_to_time(&alm.time, &now);
> +
> +	memset(&alm, 0, sizeof alm);
> +	rtc_time_to_tm(now + TEST_SUSPEND_SECONDS, &alm.time);
> +	alm.enabled = true;
> +
> +	status = rtc_set_alarm(rtc, &alm);
> +	if (status < 0) {
> +		printk(err_wakealarm, rtc->dev.bus_id, status);
> +		return;
> +	}
> +
> +	if (state == PM_SUSPEND_MEM) {
> +		printk(info_test, pm_states[state]);
> +		status = pm_suspend(state);
> +		if (status == -ENODEV)
> +			state = PM_SUSPEND_STANDBY;
> +	}
> +	if (state == PM_SUSPEND_STANDBY) {
> +		printk(info_test, pm_states[state]);
> +		status = pm_suspend(state);
> +	}
> +	if (status < 0)
> +		printk(err_suspend, status);
> +}
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
> +/*
> + * Kernel options like "test_suspend=mem" force suspend/resume sanity tests
> + * at startup time.  They're normally disabled, for faster boot and because
> + * we can't know which states really work on this particular system.
> + */
> +static suspend_state_t test_state __initdata = PM_SUSPEND_ON;
> +
> +static char warn_bad_state[] __initdata =
> +	KERN_WARNING "PM: can't test '%s' suspend state\n";
> +
> +static int __init setup_test_suspend(char *value)
> +{
> +	unsigned i;
> +
> +	/* "=mem" ==> "mem" */
> +	value++;
> +	for (i = 0; i < PM_SUSPEND_MAX; i++) {
> +		if (!pm_states[i])
> +			continue;
> +		if (strcmp(pm_states[i], value) != 0)
> +			continue;
> +		test_state = (__force suspend_state_t) i;
> +		return 0;
> +	}
> +	printk(warn_bad_state, value);
> +	return 0;
> +}
> +__setup("test_suspend", setup_test_suspend);
> +
> +static int __init test_suspend(void)
> +{
> +	static char		warn_no_rtc[] __initdata =
> +		KERN_WARNING "PM: no wakealarm-capable RTC driver is ready\n";
> +
> +	char			*pony = NULL;
> +	struct rtc_device	*rtc = NULL;
> +
> +	/* PM is initialized by now; is that state testable? */
> +	if (test_state == PM_SUSPEND_ON)
> +		goto done;
> +	if (!valid_state(test_state)) {
> +		printk(warn_bad_state, pm_states[test_state]);
> +		goto done;
> +	}
> +
> +	/* RTCs have initialized by now too ... can we use one? */
> +	class_find_device(rtc_class, &pony, has_wakealarm);
> +	if (pony)
> +		rtc = rtc_class_open(pony);
> +	if (!rtc) {
> +		printk(warn_no_rtc);
> +		goto done;
> +	}
> +
> +	/* go for it */
> +	test_wakealarm(rtc, test_state);
> +	rtc_class_close(rtc);
> +done:
> +	return 0;
> +}
> +late_initcall(test_suspend);
> +
> +#endif /* CONFIG_PM_TEST_SUSPEND */
