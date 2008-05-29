Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbYE2XXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbYE2XXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 19:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbYE2XXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 19:23:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754390AbYE2XXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 19:23:24 -0400
Date: Thu, 29 May 2008 16:22:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       mingo@elte.hu, pavel@suse.cz
Subject: Re: [patch 2.6.26-rc4-git] PM: boot time suspend selftest
Message-Id: <20080529162257.03426e48.akpm@linux-foundation.org>
In-Reply-To: <200805291333.42057.david-b@pacbell.net>
References: <200805291333.42057.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 13:33:41 -0700
David Brownell <david-b@pacbell.net> wrote:

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
>
> ...
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

abs()

> +	pr_info("PM: %s took %d.%03d seconds\n", label,
> +			msec / 1000, msec % 1000);

Can it really take a negative amount of time?  If so, this message will
convert that to a positive duration.

Confused.

> +	WARN_ON_ONCE(msec > (TEST_SUSPEND_SECONDS * 1000));

We should have a comment here explaining what we're warning about.  Why
would it take more that five seconds?

Better might be to just add a nice printk - I don't think we need the
stack trace here.

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
>
> ...
>
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

- One tab before the variable space is a waste of space.  Two tabs is
  just extravagant.

- The space before the [] shouldn't be there.  checkpatch misses this.

- This way of defining printk control strings is weird, and will (I
  assume) defeat gcc printk arg checking.

  I _assume_ it was done so that the strings could be moved into
  .init.data, thus saving a few bytes at runtime?

  I wonder if that's a good tradeoff.  It would be nice to teach gcc
  how to do this, but that sounds improbable.

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

I don't think I ever knew what __force does, and whoever added it
forgot to comment it.

<googles>

<finds http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-09/4078.html>

<can't work out why it is used here>

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

whinny.

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

