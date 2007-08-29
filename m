Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbXH2KwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbXH2KwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 06:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbXH2KwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 06:52:06 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:52584 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404AbXH2KwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 06:52:05 -0400
Date: Wed, 29 Aug 2007 14:52:04 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Cliff Wickman <cpw@sgi.com>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: cpusets vs cpu-hotplug interaction is broken?
Message-ID: <20070829105204.GA190@tv-sign.ru>
References: <20070825162606.GA2630@tv-sign.ru> <20070828134853.GA204@tv-sign.ru> <20070829085157.GE6832@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070829085157.GE6832@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29, Gautham R Shenoy wrote:
>
> On Tue, Aug 28, 2007 at 05:48:53PM +0400, Oleg Nesterov wrote:
> > (cpu-hotplug experts cc'ed)
> > 
> > On 08/25, Oleg Nesterov wrote:
> > >
> > > After the brief look at kernel/cpuset.c, it seems that attach_task() should
> > > guarantee that the task can't use CPUs outside of cpuset->cpus_allowed.
> > > 
> > > But this looks racy wrt sched_setaffinity() which does
> > > 
> > > 	cpus_allowed = cpuset_cpus_allowed(p);
> > > 	// callback_mutex is free
> > > 	set_cpus_allowed(p);
> > > 
> > > What if attach_task()->set_cpus_allowed() happens in between?
> > 
> > Actually, I think there is another problem, and cpuset_cpus_allowed() is
> > just broken wrt CONFIG_HOTPLUG_CPU.
> > 
> > Suppose that CONFIG_CPUSETS is true, but we don't use cpusets. In that
> > case all tasks in system belong to the top_cpuset (btw, why cpuset_init()
> > sets init_task.cpuset? this was already done by cpuset_init_early()), and
> > we should have the same behaviour as without CONFIG_CPUSETS.
> > 
> > By default, all tasks have ->cpus_allowed = CPU_MASK_ALL inherited from
> > kernel_init(). This means that the task can use the new CPU right after
> > cpu_up().
> > 
> > Now let's suppose that some task does sched_setaffinity(0, CPU_MASK_ALL).
> > In that case, cpuset_cpus_allowed() sets ->cpus_allowed = cpu_online_map,
> > and I think this is just wrong. Now that task doesn't see the new CPUs.
> > 
> 
> Good point! 
> 
> A task's cpu_allowed mask can contain cpus which are offline.
> And if those cpus exist in the intersection of the task's requested mask
> and cpuset's cpu mask, why should we unset the offlined cpus from that 
> intersection? Either way the task is not going to run on the cpus while
> they are in the offlined state.  And on cpu_up, if the cpu is present in
> the task's allowed mask, it can run on that cpu, which is a good thing.
> 
> The two users of cpuset_cpus_allowed - sched_setaffinity and pdflush
> don't seem to require the online cpu information.
> 
> Paul, is there any particular reason why we need guarentee_online_cpus
> to be called in cpuset_cpus_allowed ? 

Note also that cpuset_cpus_allowed()->guarentee_online_cpus() easily allows
the task to escape its ->cpuset, sched_setaffinity(cpumask_of_cpu(OFFLINE_CPU))
is enough.

Another note, http://marc.info/?t=118823976000002 really needs something
like guarentee_online_cpus(). However even in this case we shouldn't afaics
"and" cpuset->cpus_allowed with cpu_online_map.

Oleg.

