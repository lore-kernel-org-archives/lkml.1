Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbXA2RUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbXA2RUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbXA2RUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:20:11 -0500
Received: from mail.screens.ru ([213.234.233.54]:38487 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbXA2RUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:20:09 -0500
Date: Mon, 29 Jan 2007 20:19:23 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
Message-ID: <20070129171923.GA138@tv-sign.ru>
References: <20070129011301.GA844@tv-sign.ru> <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29, Christoph Lameter wrote:
>
> On Mon, 29 Jan 2007, Oleg Nesterov wrote:
> 
> > Now,
> > 	static void __devinit start_cpu_timer(int cpu)
> > 	{
> > 		struct delayed_work *reap_work = &per_cpu(reap_work, cpu);
> > 
> > 		if (keventd_up() && reap_work->work.func == NULL) {
> > 			init_reap_node(cpu);
> > 			INIT_DELAYED_WORK(reap_work, cache_reap);
> > 			schedule_delayed_work_on(cpu, reap_work,
> > 						__round_jiffies_relative(HZ, cpu));
> > 		}
> > 	}
> > 
> > This is wrong. Suppose we have a CPU_UP,CPU_DOWN,CPU_UP sequence. The last
> > CPU_UP will not restart a per-cpu "cache_reap timer".
> 
> Why?

Because the last CPU_UP calls start_cpu_timer(), but since ->work.func != NULL
we don't do schedule_delayed_work_on(). I think (if I am right) this is a slab's
bug.

> > With or without recent changes, it is possible that work->func() will run on
> > another CPU (not that to which it was submitted) if CPU goes down. In fact,
> > this can happen while work->func() is running, so even smp_processor_id()
> > is not safe to use in work->func().
> 
> But the work func was scheduled by schedule_delayed_work_on(). Isnt that a 
> general problem with schedule_delayed_work_on() and keventd?

I think this is yet another problem with workqueues/cpu-hotplug interaction.
Probably, the problem is more general. With CONFIG_CPU_HOTPLUG, we can't
garantee that smp_processor_id() is stable even if the thread is pinned to
specific processor.

> > However, cache_reap() seems to wrongly assume that smp_processor_id() is stable,
> > this is the second problem.
> >
> > Is my understanding correct?
>
> cache_reap assumes that the processor id is stable based on the kevent 
> thread being pinned to a processor.

I think cache_reap() is not alone, and this is not its fault.

But please note another minor problem,

	void cache_reap(struct work_struct *unused)
	{
		...

		schedule_delayed_work(&__get_cpu_var(reap_work), ...);
	}

Even if smp_processor_id() was stable during the execution of cache_reap(),
this work_struct can be moved to another CPU if CPU_DEAD happens. We can't
avoid this, and this is correct.

This means that __get_cpu_var(reap_work) returns a "wrong" struct delayed_work.
This is absolutely harmless right now, but may be it's better to use
container_of(unused, struct delayed_work, work).

Oleg.

