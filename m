Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYHFMmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYHFMmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYHFMlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:41:51 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:42048 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbYHFMlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:41:50 -0400
Date: Wed, 6 Aug 2008 16:45:46 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pavel Machek <pavel@suse.cz>
Cc: Zhang Rui <rui.zhang@intel.com>, Gautham R Shenoy <ego@in.ibm.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       harbour@sfinx.od.ua, rjw@sisk.pl
Subject: Re: + pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch added to -mm tree
Message-ID: <20080806124546.GA2033@tv-sign.ru>
References: <200807111846.m6BIkeTj031024@imap1.linux-foundation.org> <20080712162149.GD603@tv-sign.ru> <20080722161900.GA17601@in.ibm.com> <20080724124349.GA182@tv-sign.ru> <1216948649.2669.21.camel@rzhang-dt> <20080725094246.GA110@tv-sign.ru> <20080805195706.GD7939@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805195706.GD7939@elf.ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05, Pavel Machek wrote:
>
> > > > This means that
> > > >
> > > >         pm-schedule-sysrq-poweroff-on-boot-cpu.patch
> > > >
> > > > is not 100% right. It is still possible to hang/deadlock if we race
> > > > with cpu_down(first_cpu(cpu_online_map)).
> > >
> > > Yes, you're right.
> > > But then should we fix disable_nonboot_cpus as well?
> > >
> > > int disable_nonboot_cpus(void)
> > > {
> > >         first_cpu = first_cpu(cpu_online_map);
> > > 	...
> > >
> > >         for_each_online_cpu(cpu) {
> > >                 if (cpu == first_cpu)
> > >                         continue;
> > >                 error = _cpu_down(cpu, 1);
> > > 		...
> > >         }
> > > 	...
> > > }
> >
> > Note that disable_nonboot_cpus() does first_cpu = first_cpu() under
> > cpu_maps_update_begin(), so we can't race with cpu-hotplug.
> >
> > However, this afaics means that its name is wrong, and
> > printk("Disabling non-boot CPUs ...\n") is not right too.
> > What it does is disable_all_but_one_cpus().
>
> I thought that first cpu is defined to be boot cpu?

I don't know, but I don't really understand this low-level code.

Is it documented? This is certainly true on x86, but I don't
understand why this must be true on every arch.

Let's see. start_kernel() does smp_setup_processor_id(). Is it
guaranteed that it chooses the lowest number from cpu_possible_map?
This helper is only defined for voyager, but anyway it is not clear
why start_kernel() must be always called on CPU 0. Otherwise,
the next cpu_up() (from smp_init() or later) can add another CPU
which becomes first_cpu(cpu_online_map).

But, from disable_nonboot_cpus's pov this doesn't matter. Even if
the first cpu must be boot cpu, it can be (in general) cpu_down()'ed.
In that case, when disable_nonboot_cpus() is called,  first_cpu()
returns another value.

Once again, I don't claim this all is wrong.

> > And, it is not clear why disable_nonboot_cpus() assumes that
> > all but first_cpu(cpu_online_map) must have .hotpluggable == 1.
>
> Where does it assume that?
>
> It will fail if some CPUs can't be unplugged, and I'm afraid suspend
> can't work in such case...

Yes I see. But disable_nonboot_cpus() doesn't check .hotpluggable,
it just takes CPU down regardless of .hotpluggable, is it always OK?

Oleg.

