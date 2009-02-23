Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbZBWIiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbZBWIiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZBWIiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:38:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59432 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbZBWIiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:38:00 -0500
Date: Mon, 23 Feb 2009 09:36:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
	suspend-resume
Message-ID: <20090223083645.GA9582@elte.hu>
References: <200902221837.49396.rjw@sisk.pl> <alpine.LFD.2.00.0902220946070.3111@localhost.localdomain> <200902222342.08285.rjw@sisk.pl> <200902230048.33635.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902230048.33635.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Sunday 22 February 2009, Rafael J. Wysocki wrote:
> > On Sunday 22 February 2009, Linus Torvalds wrote:
> > > 
> > > On Sun, 22 Feb 2009, Rafael J. Wysocki wrote:
> [--snip--]
> > 
> > Thanks a lot for your comments, I'll send an updated patch shortly.
> 
> The updated patch is appended.
> 
> It has been initially tested, but requires more testing, 
> especially with APM, XEN, kexec jump etc.

>  arch/x86/kernel/apm_32.c  |   20 ++++++++++++----
>  drivers/xen/manage.c      |   32 +++++++++++++++----------
>  include/linux/interrupt.h |    3 ++
>  include/linux/irq.h       |    1 
>  kernel/irq/manage.c       |   57 ++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/kexec.c            |   10 ++++----
>  kernel/power/disk.c       |   46 +++++++++++++++++++++++++++++--------
>  kernel/power/main.c       |   20 +++++++++++-----
>  8 files changed, 152 insertions(+), 37 deletions(-)
> 
> Index: linux-2.6/kernel/irq/manage.c
> ===================================================================
> --- linux-2.6.orig/kernel/irq/manage.c
> +++ linux-2.6/kernel/irq/manage.c
> @@ -746,3 +746,60 @@ int request_irq(unsigned int irq, irq_ha
>  	return retval;
>  }
>  EXPORT_SYMBOL(request_irq);
> +
> +#ifdef CONFIG_PM_SLEEP
> +/**
> + *	suspend_device_irqs - disable all currently enabled interrupt lines

Code placement nit: please dont put new #ifdef blocks into the 
core IRQ code, add a kernel/irq/power.c file instead and make 
the kbuild rule depend on PM_SLEEP.

The new suspend_device_irqs() and resume_device_irqs() doesnt 
use any manage.c internals so this should work straight away.

> + *
> + *	During system-wide suspend or hibernation device interrupts need to be
> + *	disabled at the chip level and this function is provided for this
> + *	purpose.  It disables all interrupt lines that are enabled at the
> + *	moment and sets the IRQ_SUSPENDED flag for them.
> + */
> +void suspend_device_irqs(void)
> +{
> +	struct irq_desc *desc;
> +	int irq;
> +
> +	for_each_irq_desc(irq, desc) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&desc->lock, flags);
> +
> +		if (!desc->depth && desc->action
> +		    && !(desc->action->flags & IRQF_TIMER)) {
> +			desc->depth++;
> +			desc->status |= IRQ_DISABLED | IRQ_SUSPENDED;
> +			desc->chip->disable(irq);
> +		}
> +
> +		spin_unlock_irqrestore(&desc->lock, flags);
> +	}
> +
> +	for_each_irq_desc(irq, desc) {
> +		if (desc->status & IRQ_SUSPENDED)
> +			synchronize_irq(irq);
> +	}

Optimization/code-flow nit: a possibility might be to do a 
single loop, i.e. i think it's safe to couple the disable+sync 
bits [as in 99.99% of the cases there will be no in-execution 
irq handlers when we execute this.]

Something like:

		int do_sync = 0;

		spin_lock_irqsave(&desc->lock, flags);

		if (!desc->depth && desc->action
		    && !(desc->action->flags & IRQF_TIMER)) {

			desc->depth++;
			desc->status |= IRQ_DISABLED | IRQ_SUSPENDED;
			desc->chip->disable(irq);
			do_sync = 1;
		}

		spin_unlock_irqrestore(&desc->lock, flags);

		if (do_sync)
			synchronize_irq(irq);

In fact i'd suggest to factor out this logic into a separate 
__suspend_irq(irq) / __resume_irq(irq) inline helper functions. 
(They should be inline for the time being as they are not 
shared-irq-safe so they shouldnt really be exposed to drivers in 
such a singular capacity.)

Doing so will also fix the line-break ugliness of the first 
branch - as in a standalone function the condition fits into a 
single line.

There's a performance reason as well: especially when we have a 
lot of IRQ descriptors that will be about twice as fast. (with a 
large iteration scope this function is cachemiss-limited and 
doing this passes doubles the cachemiss rate.)

> +}
> +EXPORT_SYMBOL_GPL(suspend_device_irqs);
> +
> +/**
> + *	resume_device_irqs - enable interrupts disabled by suspend_device_irqs()
> + *
> + *	Enable all interrupt lines previously disabled by suspend_device_irqs()
> + *	that have the IRQ_SUSPENDED flag set.
> + */
> +void resume_device_irqs(void)
> +{
> +	struct irq_desc *desc;
> +	int irq;
> +
> +	for_each_irq_desc(irq, desc) {
> +		if (!(desc->status & IRQ_SUSPENDED))
> +			continue;
> +		desc->status &= ~IRQ_SUSPENDED;
> +		enable_irq(irq);
> +	}

Robustness+optimization nit: this will work but could be done in 
a nicer way: enable_irq() should auto-clear IRQ_SUSPENDED. (We 
already clear flags there so it's even a tiny bit faster this 
way.)

We definitely dont want IRQ_SUSPENDED to 'leak' out into an 
enabled line, should something call enable_irq() on a suspended 
line. So either make it auto-unsuspend in enable_irq(), or add 
an extra WARN_ON() to enable_irq(), to make sure IRQ_SUSPENDED 
is always off by that time.

> +     arch_suspend_disable_irqs();
> +     BUG_ON(!irqs_disabled());

Please. We just disabled all devices - a BUG_ON() is a very 
counter-productive thing to do here - chances are the user will 
never see anything but a hang. So please turn this into a nice 
WARN_ONCE().

> --- linux-2.6.orig/include/linux/interrupt.h
> +++ linux-2.6/include/linux/interrupt.h
> @@ -470,4 +470,7 @@ extern int early_irq_init(void);
>  extern int arch_early_irq_init(void);
>  extern int arch_init_chip_data(struct irq_desc *desc, int cpu);
>  
> +extern void suspend_device_irqs(void);
> +extern void resume_device_irqs(void);

Header cleanliness nit: please dont just throw new prototypes to 
the tail of headers, but think about where they fit in best, 
logically.

These two new prototypes should go straight after the normal irq 
line state management functions:

  extern void disable_irq_nosync(unsigned int irq);
  extern void disable_irq(unsigned int irq);
  extern void enable_irq(unsigned int irq);

Perhaps also with a comment like this:

/*
 * Note: dont use these functions in driver code - they are for 
 * core kernel use only.
 */

> +++ linux-2.6/kernel/power/main.c
[...]
> +
> + Unlock:
> +	resume_device_irqs();

Small drive-by style nit: while at it could you please fix the 
capitalization and the naming of the label (and all labels in 
this file)? The standard label is "out_unlock". [and 
"err_unlock" for failure cases - but this isnt a failure case.]

There's 43 such bad label names in kernel/power/*.c, see the 
output of:

  git grep '^ [A-Z][a-z].*:$' kernel/power/

> Index: linux-2.6/arch/x86/kernel/apm_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apm_32.c
> +++ linux-2.6/arch/x86/kernel/apm_32.c

> +
> +	suspend_device_irqs();
>  	device_power_down(PMSG_SUSPEND);
> +
> +	local_irq_disable();

hm, this is a very repetitive pattern, all around the various 
suspend/resume variants. Might make sense to make:

  	device_power_down(PMSG_SUSPEND);

do the irq line disabling plus the local irq disabling 
automatically. That also means it cannot be forgotten. The 
symmetric action should happen for PMSG_RESUME.

Is there ever a case where we want a different pattern?

> Index: linux-2.6/drivers/xen/manage.c
> ===================================================================
> --- linux-2.6.orig/drivers/xen/manage.c
> +++ linux-2.6/drivers/xen/manage.c
> @@ -39,12 +39,6 @@ static int xen_suspend(void *data)

> -	if (!*cancelled) {
> -		xen_irq_resume();
> -		xen_console_resume();
> -		xen_timer_resume();

This change needs a second look. xen_suspend() is a 
stop_machine() handler and as such executes on specific CPUs, 
and your change modifies this. OTOH, i had a look at these 
handlers and it all looks safe. Jeremy?

> +resume_devices:
> +	resume_device_irqs();

Small style nit: labels should start with a space character. 
I.e. it should be:

> + resume_devices:
> +	resume_device_irqs();

> +++ linux-2.6/kernel/kexec.c
> @@ -1454,7 +1454,7 @@ int kernel_kexec(void)
>  		if (error)
>  			goto Resume_devices;
>  		device_pm_lock();
> -		local_irq_disable();
> +		suspend_device_irqs();
>  		/* At this point, device_suspend() has been called,
>  		 * but *not* device_power_down(). We *must*
>  		 * device_power_down() now.  Otherwise, drivers for
> @@ -1464,8 +1464,9 @@ int kernel_kexec(void)
>  		 */
>  		error = device_power_down(PMSG_FREEZE);
>  		if (error)
> -			goto Enable_irqs;
> +			goto Resume_irqs;
>  
> +		local_irq_disable();
>  		/* Suspend system devices */
>  		error = sysdev_suspend(PMSG_FREEZE);
>  		if (error)
> @@ -1484,9 +1485,10 @@ int kernel_kexec(void)
>  	if (kexec_image->preserve_context) {
>  		sysdev_resume();
>   Power_up_devices:
> -		device_power_up(PMSG_RESTORE);
> - Enable_irqs:
>  		local_irq_enable();
> +		device_power_up(PMSG_RESTORE);
> + Resume_irqs:
> +		resume_device_irqs();
>  		device_pm_unlock();
>  		enable_nonboot_cpus();
>   Resume_devices:

(same comment about label style applies here too.)

> Index: linux-2.6/include/linux/irq.h
> ===================================================================
> --- linux-2.6.orig/include/linux/irq.h
> +++ linux-2.6/include/linux/irq.h
> @@ -65,6 +65,7 @@ typedef	void (*irq_flow_handler_t)(unsig
>  #define IRQ_SPURIOUS_DISABLED	0x00800000	/* IRQ was disabled by the spurious trap */
>  #define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
>  #define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
> +#define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
>  
>  #ifdef CONFIG_IRQ_PER_CPU
>  # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)

Note, you should probably make PM_SLEEP depend on 
GENERIC_HARDIRQS - as this change will break the build on all 
non-genirq architectures. (sparc, alpha, etc.)

	Ingo
