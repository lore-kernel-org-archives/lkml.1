Return-Path: <linux-kernel-owner+w=401wt.eu-S1765045AbXGNU0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765045AbXGNU0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762510AbXGNU0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:26:34 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:39483 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760137AbXGNU0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:26:33 -0400
Date: Sat, 14 Jul 2007 16:26:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] Thread Migration Preemption - v4
Message-ID: <20070714202631.GS6975@Krystal>
References: <20070706060257.GA188@tv-sign.ru> <20070706142339.GA32754@Krystal> <20070706145634.GA198@tv-sign.ru> <20070711044915.GA4025@Krystal> <20070711163648.GA232@tv-sign.ru> <20070714184237.GI6975@Krystal> <1184441406.5284.79.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1184441406.5284.79.camel@lappy>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:25:32 up 7 days, 10:30,  2 users,  load average: 0.10, 0.22, 0.25
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Sat, 2007-07-14 at 14:42 -0400, Mathieu Desnoyers wrote:
> 
> > Note: (or we could say FIXME)
> > Is we ever want to check migration pending in assembly code, we will have to
> > make sure we test the right thread flag bits on each architectures. Care should
> > also be taken to check that the thread flags used won't trigger false positives
> > in non selective asm thread flag checks.
> > 
> > FIXME (HOTPLUG) :
> > 
> > > >     /* Affinity changed (again). */
> > > >     if (!cpu_isset(dest_cpu, p->cpus_allowed))
> > > >             goto out;
> > > >  
> > > >     on_rq = p->se.on_rq;
> > > > +#ifdef CONFIG_PREEMPT
> > > > +   if (!on_rq && task_thread_info(p)->migrate_count)
> > > > +           goto out;
> > > > +#endif
> > > 
> > > This means that move_task_off_dead_cpu() will spin until the task will be
> > > scheduled
> > > on the dead CPU. Given that we hold tasklist_lock and irqs are disabled, this
> > > may
> > > never happen.
> > >
> > 
> > Yes. My idea to fix this issue is the following:
> > 
> > If a thread has non zero migrate_count, we should still move it to a
> > different CPU upon hotplug cpu removal, even if this thread resists
> > migration. Care should be taken to send _all_ such threads to the _same_
> > CPU so they don't race for the per-cpu ressources. Does it make sense ?
> > 
> > We would have to keep the CPU affinity of the threads running on the
> > wrong CPU until they end their migrate disabled section, so that we can
> > put them back on their original CPU if it goes back online, otherwise we
> > could end up with concurrent per-cpu variables accesses.
> > 
> > (I'll wait for reply before coding a solution for this CPU HOTPLUG
> > related problem)
> 
> What would, aside from technical issues, be the problem with making
> migration_disable() delay CPU_DOWN until migration_enable()?
> 

Because if we thing a little further, migration disabling could be a
very interesting way to provide cheap per-cpu data structure access to
user-space. But we would not want user-space processes to hold CPU_DOWN
forever...

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
