Return-Path: <linux-kernel-owner+w=401wt.eu-S932724AbXH3SHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbXH3SHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932350AbXH3SHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:07:06 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33574 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347AbXH3SHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:07:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Konstantin Baydarov <kbaidarov@ru.mvista.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       <vgoyal@in.ibm.com>, "RT" <linux-rt-users@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <ak@suse.de>,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec: reenable HPET before kexec
References: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru>
	<20070823090845.GA13065@in.ibm.com>
	<20070823154936.3b7ae498@windmill.dev.rtsoft.ru>
	<20070827053656.GC9809@in.ibm.com>
	<653FFBB4508B9042B5D43DC9E18836F501522051@scsmsx415.amr.corp.intel.com>
	<20070828165832.5047d4de@windmill.dev.rtsoft.ru>
	<m1ps1532b5.fsf@ebiederm.dsl.xmission.com>
	<20070830200749.2f1f0a18@windmill.dev.rtsoft.ru>
Date: Thu, 30 Aug 2007 12:04:33 -0600
In-Reply-To: <20070830200749.2f1f0a18@windmill.dev.rtsoft.ru> (Konstantin
	Baydarov's message of "Thu, 30 Aug 2007 20:07:49 +0400")
Message-ID: <m1d4x4zyoe.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Baydarov <kbaidarov@ru.mvista.com> writes:

>   Eric, actually calling hpet_disable_int() under
> CLOCK_EVT_MODE_SHUTDOWN is not enough, because
> HPET might not be shutdown at all (we might want to use HPET and don't
> want to use LAPIC timer or in some cases HPET is used as broadcast
> device with LAPIC timers enabled). So, somehow, we should call
> hpet_set_mode with CLOCK_EVT_MODE_SHUTDOWN as an argument before
> machine_kexec. To solve this I've added timekeeping_shutdown() to
> timekeeping.c that calls clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND,
> NULL). Function timekeeping_shutdown() is called from sysdev_shutdown().

Is suspend the right thing?  The fact that time keeping seems
to be reinventing the standard infrastructure for shutting
down instead of just reusing it has me a bit confused.

Regardless hooking into the shutdown is the right thing
to do here.

>   Also If we are adding hpet_disable_int() under
> CLOCK_EVT_MODE_SHUTDOWN we have to add hpet_enable_int under
> CLOCK_EVT_MODE_PERIODIC and CLOCK_EVT_MODE_ONESHOT.

However that works.  I just know that in the device tree we
have shutdown methods that are called on reboot and kexec
and the hpet needs one, and that is where the code belongs.

I was assuming that CLOCK_EVT_MODE_SHUTDOWN just mapped
to the shutdown method of the clock events or something else.
But it shutdown means something different in this context we
can certainly find a better place to hook into the device
tree and call shutdown methods.   Especially if that will
make the code simpler.

>   Also I've added call of hpet_disable_int() to machine_crash_shutdown()
> because, as you said, sysdev_shutdown() won't be called on crash before
> machine_kexec().

This is a design feature.  machine_crash_shutdown is not really 
supposed to disable any hardware.  There is a very minimal set that we
haven't been able to figure out how to get the kernels initialization
routines to deal with properly.  Which is a temporary justification
for not doing more now.  If we can't find anyway to make the
initialization code more robust for the hpet we can revisit this.

>   Also, as we have to make hpet_disable_int() global and call it from
> machine_crash_shutdown(), I suggest not to add hpet_disable_int() under
> CLOCK_EVT_MODE_SHUTDOWN. If we don't add hpet_disable_int() under
> CLOCK_EVT_MODE_SHUTDOWN - patch will be more smaller because we don't
> have to call clockevents_notify() and we don't have to add
> hpet_enable_int. We just have to add hpet_disable_int() call to
> timekeeping_shutdown(). But it's just suggestion - attached patch adds
> hpet_disable_int() under CLOCK_EVT_MODE_SHUTDOWN.

Please remove the CONFIG_KEXEC.  We need to do this on a reboot also
so we don't confuse the BIOS.  BIOS's frequently but not always
can just reset the board to avoid complications like this, but if
we need a shutdown method we need a shutdown method.  The kexec
case just exercises things more.

Please can we ignore the machine_crash_shutdown path for the moment.
And revisit it again after we have the normal case fixed.

Adding hpet_disable_int into timekeeping_shutdown at first glance
looks like a layering and maintenance violation.

Eric

> Here is new version of fix. It still against kernel 2.6.23-rc3. Thanks.
>
> Signed-off-by: Konstantin Baydarov <kbaidarov@ru.mvista.com>
>
>  arch/i386/kernel/crash.c  |    4 ++++
>  arch/i386/kernel/hpet.c   |   33 +++++++++++++++++++++++++++++++++
>  include/asm-i386/hpet.h   |    3 +++
>  kernel/time/timekeeping.c |   13 +++++++++++++
>  4 files changed, 53 insertions(+)
>
> Index: linux-2.6.23-rc3/arch/i386/kernel/hpet.c
> ===================================================================
> --- linux-2.6.23-rc3.orig/arch/i386/kernel/hpet.c
> +++ linux-2.6.23-rc3/arch/i386/kernel/hpet.c
> @@ -144,11 +144,35 @@ static void hpet_enable_int(void)
>  {
>  	unsigned long cfg = hpet_readl(HPET_CFG);
>  
> +#ifdef CONFIG_KEXEC
> +	if (hpet_legacy_int_enabled)
> +		return;
> +#endif

Why do we need this test only for kexec?
> +
>  	cfg |= HPET_CFG_LEGACY;
>  	hpet_writel(cfg, HPET_CFG);
>  	hpet_legacy_int_enabled = 1;
>  }
>  
> +#ifdef CONFIG_KEXEC
> +void hpet_disable_int(void)
> +{
> +	unsigned long cfg;
> +
> +	if (!hpet_legacy_int_enabled)
> +		return;
> +
> +	if (!is_hpet_capable())
> +		return;
> +
> +	cfg = hpet_readl(HPET_CFG);
> +	cfg &= ~HPET_CFG_LEGACY;
> +	hpet_writel(cfg, HPET_CFG);
> +	hpet_legacy_int_enabled = 0;
> +
> +}
> +#endif
> +
>  static void hpet_set_mode(enum clock_event_mode mode,
>  			  struct clock_event_device *evt)
>  {
> @@ -157,6 +181,9 @@ static void hpet_set_mode(enum clock_eve
>  
>  	switch(mode) {
>  	case CLOCK_EVT_MODE_PERIODIC:
> +#ifdef CONFIG_KEXEC
> +		hpet_enable_int();
> +#endif
>  		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * hpet_clockevent.mult;
>  		delta >>= hpet_clockevent.shift;
>  		now = hpet_readl(HPET_COUNTER);
> @@ -176,6 +203,9 @@ static void hpet_set_mode(enum clock_eve
>  		break;
>  
>  	case CLOCK_EVT_MODE_ONESHOT:
> +#ifdef CONFIG_KEXEC
> +		hpet_enable_int();
> +#endif
>  		cfg = hpet_readl(HPET_T0_CFG);
>  		cfg &= ~HPET_TN_PERIODIC;
>  		cfg |= HPET_TN_ENABLE | HPET_TN_32BIT;
> @@ -187,6 +217,9 @@ static void hpet_set_mode(enum clock_eve
>  		cfg = hpet_readl(HPET_T0_CFG);
>  		cfg &= ~HPET_TN_ENABLE;
>  		hpet_writel(cfg, HPET_T0_CFG);
> +#ifdef CONFIG_KEXEC
> +		hpet_disable_int();
> +#endif
>  		break;
>  
>  	case CLOCK_EVT_MODE_RESUME:
> Index: linux-2.6.23-rc3/include/asm-i386/hpet.h
> ===================================================================
> --- linux-2.6.23-rc3.orig/include/asm-i386/hpet.h
> +++ linux-2.6.23-rc3/include/asm-i386/hpet.h
> @@ -66,6 +66,9 @@
>  extern unsigned long hpet_address;
>  extern int is_hpet_enabled(void);
>  extern int hpet_enable(void);
> +#ifdef CONFIG_KEXEC
> +extern void hpet_disable_int(void);
> +#endif
>  
>  #ifdef CONFIG_HPET_EMULATE_RTC
>  
> Index: linux-2.6.23-rc3/arch/i386/kernel/crash.c
> ===================================================================
> --- linux-2.6.23-rc3.orig/arch/i386/kernel/crash.c
> +++ linux-2.6.23-rc3/arch/i386/kernel/crash.c
> @@ -24,6 +24,7 @@
>  #include <asm/apic.h>
>  #include <linux/kdebug.h>
>  #include <asm/smp.h>
> +#include <asm/hpet.h>
>  
>  #include <mach_ipi.h>
>  
> @@ -128,6 +129,9 @@ void machine_crash_shutdown(struct pt_re
>  
>  	/* Make a note of crashing cpu. Will be used in NMI callback.*/
>  	crashing_cpu = safe_smp_processor_id();
> +#ifdef CONFIG_KEXEC
> +	hpet_disable_int();
> +#endif
>  	nmi_shootdown_cpus();
>  	lapic_shutdown();
>  #if defined(CONFIG_X86_IO_APIC)
> Index: linux-2.6.23-rc3/kernel/time/timekeeping.c
> ===================================================================
> --- linux-2.6.23-rc3.orig/kernel/time/timekeeping.c
> +++ linux-2.6.23-rc3/kernel/time/timekeeping.c
> @@ -335,8 +335,21 @@ static int timekeeping_suspend(struct sy
>  	return 0;
>  }
>  
> +#ifdef CONFIG_KEXEC
> +static int timekeeping_shutdown(struct sys_device *dev)
> +{
> +	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
Hmm.  Do we want to add a CLOCK_EVT_NOTIFY_SHUTDOWN?
Would that make anything simpler?
> +//	hpet_disable_int();
> +
> +	return 0;
> +}
> +#endif
> +
>  /* sysfs resume/suspend bits for timekeeping */
>  static struct sysdev_class timekeeping_sysclass = {
> +#ifdef CONFIG_KEXEC
> +	.shutdown	= timekeeping_shutdown,
> +#endif
>  	.resume		= timekeeping_resume,
>  	.suspend	= timekeeping_suspend,
>  	set_kset_name("timekeeping"),
