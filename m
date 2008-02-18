Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbYBRJxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbYBRJxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 04:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYBRJxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:53:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53872 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752014AbYBRJxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:53:07 -0500
Date: Mon, 18 Feb 2008 10:53:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Brownell <david-b@pacbell.net>, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] suspend/resume self-test
Message-ID: <20080218095325.GA7198@elf.ucw.cz>
References: <20080130131748.GA3796@elf.ucw.cz> <20080203070554.GA11780@elte.hu> <200802022332.58034.david-b@pacbell.net> <200802031321.27828.rjw@sisk.pl> <20080203131636.4100828D3E1@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20080218085655.GA6419@elf.ucw.cz> <20080218094650.GA31970@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218094650.GA31970@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Since this is increasingly unrelated to the "sleepy linux" concept 
> > > (a version of what systems like OLPC, N700, and N800 are doing), I 
> > > got rid of the "sleepy.c" file.
> > 
> > What was the decision here? Ingo, did you merge this for 2.6.26, or 
> > just for your test farm?
> 
> it's working fine here, i've had it in my test-setup for a long time, 
> and it triggers every now and then.
> 
> We should merge the patch below. My only gripe that should be solved in 
> an add-on patch is that right now it triggers with an about 1:100 chance 
> in randconfig tests. The reason is the insane amount of user-selected 
> options to get this vital functionality done. Could we _PLEASE_ get a 
> prominent "new, cool RTC driver stuff" config option that just select's 
> all the other options?

Meaning "only 1% of tests have right options for this to trigger"?

> > >  drivers/char/Kconfig |    5 +
> > >  drivers/rtc/Kconfig  |    1 
> > >  kernel/power/Kconfig |   10 +++
> > >  kernel/power/main.c  |  163 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  4 files changed, 178 insertions(+), 1 deletion(-)
> 
> this cannot really go via x86.git.
> 
> Linus, could you please apply the debug patch below? It's really useful 
> and it is catching suspend/resume bugs as well.

Yes, that would be very nice.

> Subject: suspend/resume self-test
> From: David Brownell <david-b@pacbell.net>
> 
> Boot-time test for system suspend states (STR or standby).  The generic
> RTC framework triggers wakeup alarms, used to exit those states.
> 
>   - Measures some aspects of suspend time; uses "jiffies".  This
>     should probably use a clocksource instead, since those often
>     work properly even while IRQs are disabled.
> 
>   - Includes a command line parameter, which needs work yet ... it
>     currently turns this test off, but it should also let the target
>     state be specified (and maybe even default to "no test").
> 
> Lightly tested on an ARM system, which reported that suspending devices
> took 7 msec and resuming them took 132 msec:
> 
>   * The PCMCIA stack misbehaved a bit.  It didn't finish enumerating
>     the card before it suspended, so the wakeup event came from the
>     CF card IRQ not from the RTC!
> 
>   * The MMC stack misbehaved more seriously.  It wants to remove devices
>     during the suspend sequence (quite needlessly, on this hardware),
>     which now makes Linux unhappy.
> 
> Workaround in both cases was to take the memory card out before booting.
> 
> Also includes some Kconfig tweaks to help reduce configuration bugs on
> x86, by avoiding the legacy RTC driver when the generic RTC framework
> is enabled ... those should become a separate patch.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Pavel Machek <pavel@suse.cz>


> ---
>  drivers/char/Kconfig |    5 +
>  drivers/rtc/Kconfig  |    1 
>  kernel/power/Kconfig |   10 +++
>  kernel/power/main.c  |  163 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 178 insertions(+), 1 deletion(-)
> 
> Index: linux/drivers/char/Kconfig
> ===================================================================
> --- linux.orig/drivers/char/Kconfig
> +++ linux/drivers/char/Kconfig
> @@ -706,9 +706,12 @@ config NVRAM
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
> Index: linux/drivers/rtc/Kconfig
> ===================================================================
> --- linux.orig/drivers/rtc/Kconfig
> +++ linux/drivers/rtc/Kconfig
> @@ -294,6 +294,7 @@ comment "Platform RTC drivers"
>  config RTC_DRV_CMOS
>  	tristate "PC-style 'CMOS'"
>  	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS
> +	default y if X86
>  	help
>  	  Say "yes" here to get direct support for the real time clock
>  	  found in every PC or ACPI-based system, and some other boards.
> Index: linux/kernel/power/Kconfig
> ===================================================================
> --- linux.orig/kernel/power/Kconfig
> +++ linux/kernel/power/Kconfig
> @@ -104,6 +104,16 @@ config SUSPEND
>  	  powered and thus its contents are preserved, such as the
>  	  suspend-to-RAM state (e.g. the ACPI S3 state).
>  
> +config PM_TEST_SUSPEND
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
> Index: linux/kernel/power/main.c
> ===================================================================
> --- linux.orig/kernel/power/main.c
> +++ linux/kernel/power/main.c
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
> +	WARN_ON_ONCE(msec > ((TEST_SUSPEND_SECONDS+5) * 1000));
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
> @@ -515,3 +566,115 @@ static int __init pm_init(void)
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
> + * system.  RTCs with wakeup alarms are the the most common mechanism
> + * that's self-contained.
> + */
> +
> +static void __init test_wakealarm(struct rtc_device *rtc, suspend_state_t state)
> +{
> +	static char	err_readtime [] __initdata =
> +		KERN_ERR "PM: can't read %s time, err %d\n";
> +	static char	err_wakealarm [] __initdata =
> +		KERN_ERR "PM: can't set %s wakealarm, err %d\n";
> +	static char	err_suspend [] __initdata =
> +		KERN_ERR "PM: suspend test failed, error %d\n";
> +	static char	info_test [] __initdata =
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
> + * We normally test Suspend-to-RAM, with standby as a backup when
> + * the system doesn't support that state.  But we also need to be
> + * able to disable the powerup test, and tell it to ignore STR since
> + * the RTC may not work then.
> + */
> +static suspend_state_t test_state __initdata = PM_SUSPEND_MEM;
> +
> +static int __init setup_test_suspend(char *value)
> +{
> +	/* FIXME accept "standby", etc */
> +	test_state = PM_SUSPEND_ON;
> +	return 0;
> +}
> +__setup("test_suspend", setup_test_suspend);
> +
> +static int __init test_suspend(void)
> +{
> +	static char	warn_no_rtc[] __initdata =
> +		KERN_WARNING "PM: no wakealarm-capable RTC driver is ready\n";
> +
> +	char			*pony = NULL;
> +	struct rtc_device	*rtc = NULL;
> +
> +	class_find_device(rtc_class, &pony, has_wakealarm);
> +	if (pony)
> +		rtc = rtc_class_open(pony);
> +
> +	if (rtc) {
> +		if (test_state != PM_SUSPEND_ON)
> +			test_wakealarm(rtc, test_state);
> +		rtc_class_close(rtc);
> +	} else
> +		printk(warn_no_rtc);
> +
> +	return 0;
> +}
> +late_initcall(test_suspend);
> +
> +#endif /* CONFIG_PM_TEST_SUSPEND */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
