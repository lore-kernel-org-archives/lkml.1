Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbXF1XtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbXF1XtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761387AbXF1XtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:49:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48566 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754525AbXF1XtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:49:11 -0400
Date: Thu, 28 Jun 2007 16:48:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Wise <jwise@google.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org,
       thockin@google.com, mikew@google.com, masouds@google.com
Subject: Re: [PATCH] [revised -- version 2] Info dump on Oops or panic()
Message-Id: <20070628164855.012344cd.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706281603590.617@internets.corp.google.com>
References: <Pine.LNX.4.64.0706281502350.617@internets.corp.google.com>
	<20070628221835.GI2784@fattire.cabal.ca>
	<Pine.LNX.4.64.0706281603590.617@internets.corp.google.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 16:12:23 -0700 (PDT)
Joshua Wise <jwise@google.com> wrote:

> Version: 2
> 
> Background:
>   When managing a large number of servers, as Google does, it's sometimes
>   useful to get an "at-a-glance" view of a machine when it crashes. When no
>   other post-mortem is possible, it's often useful to know how long the
>   machine has been powered on, which kernel it was running, and possibly
>   other information that a driver may have logged. Up until now, there was no
>   real way to do this other than to keep statistics outside to the machine.
> 
> Description:
>   This patch adds a call chain to be invoked when the system oopses or
>   panics. Traps have been added to i386 and x86_64 kernels, but it should be
>   trivial to add support for more architectures. Two sample notifiers have
>   been added -- an uptime printer, and a utsname printer for showing various
>   statistics about the running system.
> 
> Remaining issues:
>   * Is do_posix_clock_monotonic_gettime really the right API?
>   * Should this be on by default, or a disablable Kconfig entry?
> 
> Testing:
>   I accidentally built my testing kernel without the IDE drivers. It panic()ed
>   immediately, and informed me that my uptime was 0.38 seconds.
> 
> Credits:
>   This code was mainly written by Mike Waychison <mikew@google.com> and
>   Masoud Sharbiani <masouds@google.com>.
> 
> Changelog:
>   v2 -- fixed some checkpatch issues. Moved dumping to before Oopses, as per
>   the suggestion of Kyle McMartin <kyle@mcmartin.ca>.
> 
> diff --git a/arch/i386/kernel/process.c b/arch/i386/kernel/process.c
> index 06dfa65..f969c04 100644
> --- a/arch/i386/kernel/process.c
> +++ b/arch/i386/kernel/process.c
> @@ -301,6 +301,8 @@ void show_regs(struct pt_regs * regs)
>   {

Your email client is doing space-stuffing.  It's easy enough to fix at this
end, but even easier if you fix it ;)

>   	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
> 
> +	atomic_notifier_call_chain(&info_dumper_list, 0, NULL);
> +

I worry a bit about doing _anything_ extra at oops-time.  It just decreases
the chances of the kernel generating the info which we want.

So...  Please consider abandoning the notifier-chain and just go for a
simple function call.

If people want to add extra goodies later on, well, they need to patch the
kernel anyway so they can patch your newly-added function rather than
hooking into the notifier chain.


>   EXPORT_SYMBOL(cad_pid);
> 
>   /*
> + *	Notifier list for kernel code which wants to printk hardware specific
> + *	information at Oops or panic time.
> + */
> +
> +ATOMIC_NOTIFIER_HEAD(info_dumper_list);
> +EXPORT_SYMBOL(info_dumper_list);

That export isn't needed.

> +/*
> + * Dump out UTS info on oops / panic.
> + */
> +
> +static int dump_utsname(struct notifier_block *self, unsigned long v, void *p)
> +{
> +	printk (KERN_EMERG "%s %s %s %s %s %s\n",
> +		utsname()->sysname,
> +		utsname()->nodename,
> +		utsname()->release,
> +		utsname()->version,
> +		utsname()->machine,
> +		utsname()->domainname);
> +	return 0;
> +}

Again, a deref of current->nsproxy->uts_ns->name at oops-time has risks.

This string could be precalculated, no?

> +static struct notifier_block utsname_notifier;
> +
> +static int __init register_utsname_dump(void) {

<wishes that all nooglers got a copy of K&R>

> +	utsname_notifier.notifier_call = dump_utsname;
> +	atomic_notifier_chain_register(&info_dumper_list, &utsname_notifier);
> +	return 0;
> +}
> +__initcall(register_utsname_dump);

module_init() is a bit more modern, but equivalent.

> +/*
> + * Dump out uptime info on oops / panic.
> + *
> + * FIXME: Should I be just using get_jiffies64()? what if the lock there
> + * is damaged beyond any recognition?
> + */
> +
> +static int dump_uptime(struct notifier_block *self, unsigned long v, void *p)
> +{
> +	struct timespec uptime;
> +	/* The logic below is very much like how kernel
> +	 * prepares /proc/uptime.
> +	 */
> +	do_posix_clock_monotonic_gettime(&uptime);
> +	printk(KERN_EMERG "Uptime (seconds): %lu.%02lu\n",
> +		(unsigned long) uptime.tv_sec,
> +		(uptime.tv_nsec / (NSEC_PER_SEC / 100)));
> +
> +	return 0;
> +}

do_posix_clock_monotonic_gettime() takes xtime_lock.  So if the kernel
oopses while holding xtime_lock we don't get to see the oops.  This is bad.

I don't know what to do here.  It will be hard to find a read-the-time
function which is a) lockless and b) available on all architectures and
configs.

If you can find a way to use plain old jiffies, that'd be good.

> +static struct notifier_block uptime_notifier;
> +
> +static int __init register_uptime_dump(void) {

thwap

> +	uptime_notifier.notifier_call = dump_uptime;
> +	atomic_notifier_chain_register(&info_dumper_list, &uptime_notifier);
> +	return 0;
> +}
> +__initcall(register_uptime_dump);

module_init()
