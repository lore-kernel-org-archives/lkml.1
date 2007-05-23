Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbXEWW5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbXEWW5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbXEWW46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:56:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42464 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755981AbXEWW46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:56:58 -0400
Date: Wed, 23 May 2007 17:56:57 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-ID: <20070523225657.GA26115@sgi.com>
References: <20070523212902.GA235@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523212902.GA235@tv-sign.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, May 24, 2007 at 01:29:02AM +0400, Oleg Nesterov wrote:
> Cliff Wickman wrote:
> >
> > In order to do this, move_task_off_dead_cpu() must make a call to
> > cpuset_cpus_allowed(), which may block.
> >
> > move_task_off_dead_cpu() has been within a critical region when called
> > from migrate_live_tasks().  So this patch also changes migrate_live_tasks()
> > to enable interrupts before calling move_task_off_dead_cpu().
> > Since the tasklist_lock is dropped, the list scan must be restarted from
> > the top.
> >
> > [... snip ...]
> >
> > - * NOTE: interrupts should be disabled by the caller
> > + * NOTE: interrupts are not disabled by the caller
> >   */
> >  static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
> >  {
> > @@ -5008,6 +5008,17 @@ restart:
> >  	if (dest_cpu == NR_CPUS)
> >  		dest_cpu = any_online_cpu(p->cpus_allowed);
> >
> > +	/* try to stay on the same cpuset */
> > +	if (dest_cpu == NR_CPUS) {
> > +		/*
> > +		 * Call to cpuset_cpus_allowed may sleep, so we depend
> > +		 * on move_task_off_dead_cpu() being called in a non-critical
> > +		 * region.
> > +		 */
> > +		p->cpus_allowed = cpuset_cpus_allowed(p);
> > +		dest_cpu = any_online_cpu(p->cpus_allowed);
> > +	}
> 
> I know nothing about cpuset.c, a _very_ naive question.

Paul Jackson is the cpuset guru.
 
> Do we really need task_lock() (used by cpuset_cpus_allowed) here ?

According to Paul's comment in kernel/cpuset.c
 * It is ok to first take manage_sem, then nest callback_sem.  We also
 * require taking task_lock() when dereferencing a tasks cpuset pointer.
So I'm afraid it is not safe to call guarantee_online_cpus(tsk->cpuset, &mask);
without it.  Could the task not be exiting?

> If not, probably we can make this simpler. CPU_DEAD takes cpuset_lock(),
> move_task_off_dead_cpu() uses guarantee_online_cpus() which doesn't sleep,
> so we don't need other changes.
> 
> Possible?
> 
> If not, this patch should also change migrate_dead(), it still calls
> move_task_off_dead_cpu() with irqs disabled, no?

Right, the lock is released but I indeed didn't reenable irqs.
How would you suggest doing that?  The irq state was saved in local
variable "flags" back in migration_call().

> 
> Oleg.

-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
