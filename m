Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbZG3Ryq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbZG3Ryq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZG3Ryp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:54:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56045 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbZG3Ryo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:54:44 -0400
Date: Thu, 30 Jul 2009 19:51:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] cpusets: fix deadlock with cpu_down()->cpuset_lock()
Message-ID: <20090730175108.GC3617@redhat.com>
References: <20090729023302.GA8899@redhat.com> <20090729212125.GA16970@redhat.com> <20090729212216.GB16970@redhat.com> <20090729230043.GA28175@redhat.com> <4A70FD26.1010800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A70FD26.1010800@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Lai Jiangshan wrote:
>
> Oleg Nesterov wrote:
> > On 07/29, Oleg Nesterov wrote:
> >> I strongly believe the bug does exist, but this patch needs the review
> >> from maintainers.
> >
> > Yes...
> >
> >> IOW, with this patch migration_call(CPU_DEAD) runs without callback_mutex,
> >> but kernel/cpuset.c always takes get_online_cpus() before callback_mutex.
> >
> > Oh. I'm afraid this is not an option.
> >
> > callback_mutex should nest under cgroup_mutex, but cpu hotplu pathes
> > take cgroup_mutex under cpu_hotplug->lock. Lockdep won't be happy.
> >
> > Oleg.
> >
>
> We have made great effort to remove get_online_cpus() from cgroup_mutex
> critical region.

Agreed.

> We can migrate the owner of callback_mutex in migration_call(CPU_DEAD)
> at first(and then take callback_mutex and migrate others).

Not sure I understand how can we do this. Even if we know the owner
of callback_mutex, if we can migrate it safely without callback_mutex
why we can't migrate other tasks without this lock?

In any case this doesn't look like a clean solution, imho. But I hardly
understand what cpuset is, can't suggest something clever.

I don't really understand why guarantee_online_cpus() needs this mutex,
and I don' understand why it have to check cs->parent.

update_cpumask() doesn't allow to set ->cpus_allowed which does not
intersect with cpu_online_mask (unless cs is empty). This means that
guarantee_online_cpus()->cpumask_intersects() == T is only possible
when we are called from cpu_down() path, right? But can't we just
return cpu_online_mask in this case? I mean,

	static void guarantee_online_cpus(const struct cpuset *cs,
					  struct cpumask *pmask)
	{
		if (cpumask_intersects(cs->cpus_allowed, cpu_online_mask))
			cpumask_and(pmask, cs->cpus_allowed, cpu_online_mask);
		else
			/* !!!!!!!!!!!!!!!!!!!!
			 * cpuset_track_online_cpus(CPU_DEAD)->scan_for_empty_cpusets()
			 * will fix this.
			 */
			cpumask_copy(pmask, cpu_online_mask);
	}

Most probably I missed something, never looked in cpuset.c before.

Oleg.

