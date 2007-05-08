Return-Path: <linux-kernel-owner+w=401wt.eu-S967677AbXEHNs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967677AbXEHNs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967377AbXEHNs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:48:27 -0400
Received: from mail.screens.ru ([213.234.233.54]:38807 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967355AbXEHNs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:48:26 -0400
Date: Tue, 8 May 2007 17:48:15 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-mm1 hwsusp: BUG at workqueue.c:106
Message-ID: <20070508134815.GA1074@tv-sign.ru>
References: <46403B7F.1050009@gmail.com> <20070508021131.438cee31.akpm@linux-foundation.org> <20070508105528.GA86@tv-sign.ru> <46405A67.8020105@gmail.com> <46406656.9060504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46406656.9060504@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Jiri Slaby wrote:
>
> > Oleg Nesterov napsal(a):
> >>>
> >>>> kernel BUG at /home/l/latest/xxx/kernel/workqueue.c:106!
> >>>> invalid opcode: 0000 [#1]
> >>>> SMP
> >>>> Modules linked in: ipv6 floppy ohci1394 ieee1394 parport_pc parport usbhid
> >>>> ehci_hcd pata_acpi ff_memless sr_mod cdrom
> >>>> CPU:    1
> >>>> EIP:    0060:[<c0132161>]    Not tainted VLI
> >>>> EFLAGS: 00010046   (2.6.21-mm1 #272)
> >>>> EIP is at insert_work+0x6d/0x71
> [...]
> >> --- OLD/kernel/workqueue.c~	2007-05-06 00:01:06.000000000 +0400
> >> +++ OLD/kernel/workqueue.c	2007-05-08 14:50:39.000000000 +0400
> >> @@ -103,7 +103,10 @@ static inline void set_wq_data(struct wo
> >>  {
> >>  	unsigned long new;
> >>  
> >> -	BUG_ON(!work_pending(work));
> >> +	if (!work_pending(work)) {
> >> +		printk(KERN_ERR "BUG: set_wq_data ");
> >> +		print_symbol("%s\n", (unsigned long) work->func);
> >> +	}
> >>  
> >>  	new = (unsigned long) cwq | (1UL << WORK_STRUCT_PENDING);
> >>  	new |= WORK_STRUCT_FLAG_MASK & *work_data_bits(work);
> 
> vmstat_update+0x0/0x2b

Thanks a lot.

I know nothing about hwsusp, to the point I don't even know what it does.
I'll try to do some reading tomorrow.

Right now,

> +static void vmstat_update(struct work_struct *w)
> +{
> +       refresh_cpu_vm_stats(smp_processor_id());
> +       schedule_delayed_work(&__get_cpu_var(vmstat_work),
> +               sysctl_stat_interval);
> +}

This is not precisely correct. We cam schedule the wrong vmstat_work
if this timer/work migrates to another CPU. I'd suggest

	schedule_delayed_work(container_of(w, struct delayed_work, work))

This should not happen because we are doing cancel_rearming_delayed_work()
below, however:

> +       case CPU_DOWN_PREPARE:
> +       case CPU_DOWN_PREPARE_FROZEN:
> +               cancel_rearming_delayed_work(&per_cpu(vmstat_work, cpu));
> +               per_cpu(vmstat_work, cpu).work.func = NULL;
> +       case CPU_DOWN_FAILED:
> +       case CPU_DOWN_FAILED_FROZEN:
> +               start_cpu_timer(cpu);

we need a "break;" before "case CPU_DOWN_FAILED", otherwise we re-start
vmstat_update() immediately.

This is a bug, but I am not sure is this the only problem.

Oleg.

