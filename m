Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbYB2VEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbYB2VEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYB2VDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:03:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58316 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758946AbYB2VDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:03:50 -0500
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>
In-Reply-To: <47C87084.3090208@qualcomm.com>
References: <20080227222103.673194000@chello.nl>
	 <1204311351.6243.130.camel@lappy> <20080229190223.GA17820@elte.hu>
	 <47C87084.3090208@qualcomm.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 22:03:00 +0100
Message-Id: <1204318980.6243.133.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 12:52 -0800, Max Krasnyanskiy wrote:
> Ingo Molnar wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> >> @@ -174,11 +174,20 @@ struct irq_desc {
> >>  #ifdef CONFIG_PROC_FS
> >>  	struct proc_dir_entry	*dir;
> >>  #endif
> >> +#ifdef CONFIG_CPUSETS
> >> +	struct cpuset		*cs;
> >> +#endif
> > 
> > i like this approach - it makes irqs more resource-alike and attaches 
> > them to a specific resource control group.
> > 
> > So if /cgroup/boot is changed to have less CPUs then the "default" irqs 
> > move along with it.
> > 
> > but if an isolated RT domain has specific irqs attached to it (say the 
> > IRQ of some high-speed data capture device), then the irqs would move 
> > together with that domain.
> > 
> > irqs are no longer a bolted-upon concept, but more explicitly managed.
> > 
> > [ If you boot-test it and if Paul agrees with the general approach then
> >   i could even apply it to sched-devel.git ;-) ]
> 
> Believe it or not but I like it too :).
> Now we're talking different approach compared to the cpu_isolated_map since 
> with this patch cpu_system_map is no longer needed.
> I've been playing with latest sched-devel tree and while I think we'll endup 
> adding a lot more code, doing it with the cpuset is definitely more flexible.
> This way we can provide more fine grain control of what part of the "system" 
> services are allowed to run on a cpuset. Rather that "catch all" system flag.
> 
> Current sched-devel tree does not provide complete isolation at this point. 
> There are still many things here and there that need to be added/fixed.
> Having finer control here helps.
> 
> One concern I have is that this API conflicts with /proc/irq/X/smp_affinity.
> ie Setting smp_affinity manually will override affinity set by the cpuset.
> In other words I think
> 	int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
> now needs to make sure that cpumask does not have cpus that do not belong to 
> the cpuset this irq belongs to. Just like sched_setaffinity() does for the tasks.

The patch also needs to handle group destruction too; currently it
leaves cpuset pointers dangling. So it would either have to refuse
removing a group when there are still irqs associated, or move them to
the parent.

But yeah, this was just a quick hack to show the idea, glad you like it.
Will try to flesh it out a bit in the coming week.

