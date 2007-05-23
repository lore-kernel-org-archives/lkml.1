Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbXEWXcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbXEWXcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbXEWXby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:31:54 -0400
Received: from mail.screens.ru ([213.234.233.54]:40810 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757103AbXEWXbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:31:53 -0400
Date: Thu, 24 May 2007 03:32:01 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-ID: <20070523233201.GA384@tv-sign.ru>
References: <20070523212902.GA235@tv-sign.ru> <20070523225657.GA26115@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523225657.GA26115@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23, Cliff Wickman wrote:
> 
> On Thu, May 24, 2007 at 01:29:02AM +0400, Oleg Nesterov wrote:
> > Cliff Wickman wrote:
> > >
> > > - * NOTE: interrupts should be disabled by the caller
> > > + * NOTE: interrupts are not disabled by the caller
> > >   */
> > >  static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
> > >  {
> > > @@ -5008,6 +5008,17 @@ restart:
> > >  	if (dest_cpu == NR_CPUS)
> > >  		dest_cpu = any_online_cpu(p->cpus_allowed);
> > >
> > > +	/* try to stay on the same cpuset */
> > > +	if (dest_cpu == NR_CPUS) {
> > > +		/*
> > > +		 * Call to cpuset_cpus_allowed may sleep, so we depend
> > > +		 * on move_task_off_dead_cpu() being called in a non-critical
> > > +		 * region.
> > > +		 */
> > > +		p->cpus_allowed = cpuset_cpus_allowed(p);
> > > +		dest_cpu = any_online_cpu(p->cpus_allowed);
> > > +	}
> > 
> > I know nothing about cpuset.c, a _very_ naive question.
> 
> Paul Jackson is the cpuset guru.

Hopefully Paul can help us...

> > Do we really need task_lock() (used by cpuset_cpus_allowed) here ?
> 
> According to Paul's comment in kernel/cpuset.c
>  * It is ok to first take manage_sem, then nest callback_sem.  We also
>  * require taking task_lock() when dereferencing a tasks cpuset pointer.
> So I'm afraid it is not safe to call guarantee_online_cpus(tsk->cpuset, &mask);
> without it.  Could the task not be exiting?

But how task_lock() can help? cpuset_exit() doesn't take it, it changes ->cpuset
lockless. However, it sets ->cpuset = &top_cpuset, and the comment says:

	* Don't even think about derefencing 'cs' after the cpuset use count
	* goes to zero, except inside a critical section guarded by manage_mutex
	* or callback_mutex.
	     ^^^^^^^^^^^^^^
So, perhaps cpuset_lock() should be enough.

(That said, looking at cpuset_exit() I can't understand why callback_mutex is
 enough. If it is not, cpuset_cpus_allowed() is not safe either).

> > If not, probably we can make this simpler. CPU_DEAD takes cpuset_lock(),
> > move_task_off_dead_cpu() uses guarantee_online_cpus() which doesn't sleep,
> > so we don't need other changes.
> > 
> > Possible?
> > 
> > If not, this patch should also change migrate_dead(), it still calls
> > move_task_off_dead_cpu() with irqs disabled, no?
> 
> Right, the lock is released but I indeed didn't reenable irqs.
> How would you suggest doing that?  The irq state was saved in local
> variable "flags" back in migration_call().

migration_call(CPU_DEAD) is called with irqs enabled.

Oleg.

