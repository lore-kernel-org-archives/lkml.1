Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbZIKSHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbZIKSHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZIKSHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:07:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbZIKSHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:07:45 -0400
Date: Fri, 11 Sep 2009 20:03:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] resend, cpuset/hotplug fixes
Message-ID: <20090911180304.GA3477@redhat.com>
References: <20090910192153.GA584@redhat.com> <1252615996.7205.99.camel@laptop> <4AA9F902.4030306@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA9F902.4030306@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11, Lai Jiangshan wrote:
>
> I have different concept. cpuset_cpus_allowed() is not called at atomic
> context nor non-preemptable context nor other critical context.
> So it should be allowed to use mutexs. That's what I think.

Well, it is called from non-preemptable context: move_task_off_dead_cpu().
That is why before this patch we had cpuset_cpus_allowed_lock(). And this
imho adds unneeded complications.

And I can't understand why sched_setaffinity() path should take the
global mutex instead of per-cpuset spinlock.

> There is a bug when migration_call() requires a mutex
> before migration has been finished when cpu offline as Oleg described.
>
> Bug this bug is only happened when cpu offline. cpu offline is rare and
> is slowpath. I think we should fix cpu offline and ensure it requires
> the mutex safely.

This is subjective, but I can't agree. I think we should fix cpusets
instead. We should try to avoid the dependencies between different
subsystems as much as possible.

> Oleg's patch moves all dirty things into CPUSET subsystem and makes
> cpuset_cpus_allowed() does not require any mutex and increases CPUSET's
> coupling. I don't feel it's good.

Again, subjective... But I can't understand "increases CPUSET's coupling".

>From my pov, this patch cleanups and simplifies the code. This was the
main motivation, the bugfix is just the "side effect". I don't understand
how this subtle cpuset_lock() can make things better. I can't understand
why we need the global lock to calc cpus_allowed.

> > > cpuset_cpus_allowed() is not only  used for CPU offline.
> > > >
> > > > sched_setaffinity() also uses it.
> >
> > Sure. And it must take get_online_cpus() to avoid the races with hotplug.
>
> Oleg hasn't answered that
> "is it safe when pdflush() calls cpuset_cpus_allowed()?".

Because I didn't see such a question ;) perhaps I missed it previously...

> A patch may be needed to ensure pdflush() calls cpuset_cpus_allowed() safely.

What is wrong with pdflush()->cpuset_cpus_allowed() ? Why this is not safe?

This

	cpuset_cpus_allowed(current, cpus_allowed);
	set_cpus_allowed_ptr(current, cpus_allowed);

looks equally racy, with or without the patch. But this is a bit off-topic,
mm/pdflush.c has gone away.

> One other minor thing:
> Oleg's patch may introduce a trouble in PREEEMPT_RT tree, because
> spinlock in RT is also mutex. Likely I'm wrong.

Yes, probably -rt need raw_lock (as you pointed out).

Oleg.

