Return-Path: <linux-kernel-owner+w=401wt.eu-S1758419AbYEIWif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419AbYEIWif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 18:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYEIWi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 18:38:26 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:51965 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371AbYEIWiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 18:38:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYEAK5vJEhMROPA/2dsb2JhbACBU6oJ
Date: Fri, 9 May 2008 18:38:23 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, pmckenne@us.ibm.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Using markers w/ preemptible RCU in early code
Message-ID: <20080509223823.GD12311@Krystal>
References: <20080510011357.5466a631@linux360.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080510011357.5466a631@linux360.ro>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:35:15 up 70 days, 18:46,  3 users,  load average: 0.09, 0.20,
	0.23
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> Hello,
> 
> I'm working on the kmemtrace GSoC project and I'm having a little
> problem.
> 
> My code inserts probes during early code (just after kmem_cache_init()).
> This works on the classic RCU. But on the preemptible RCU, this
> triggers BUG()s (supposedly on each probe, there are two), although the
> kernel runs fine:
> 
> > BUG: scheduling while atomic: swapper/0/0x00000002
> > Pid: 0, comm: swapper Not tainted 2.6.25-00002-gf80e324-dirty #16
> > 
> > Call Trace:
> >  [<ffffffff802365f5>] __schedule_bug+0x65/0x70
> >  [<ffffffff804f8bb0>] thread_return+0x346/0x566
> >  [<ffffffff802734ba>] ? get_marker+0x23a/0x260
> >  [<ffffffff8025fbc6>] ? put_online_cpus+0x46/0x70
> >  [<ffffffff80270c88>] __synchronize_sched+0x48/0x80
> >  [<ffffffff802741a2>] marker_probe_register+0x152/0x660
> >  [<ffffffff8029af10>] ? kmemtrace_probe_alloc+0x0/0x1b0
> >  [<ffffffff8029ad6d>] kmemtrace_init+0x4d/0xd0
> >  [<ffffffff80693c05>] start_kernel+0x205/0x300
> >  [<ffffffff806931b2>] _sinittext+0x1b2/0x200
> 
> The is triggered by the following code in marker_probe_register():
> #ifdef CONFIG_PREEMPT_RCU
> 	synchronize_sched();    /* Until we have the call_rcu_sched() */
> #endif
> 
> Since preemption and SMP are disabled during early code, we could do
> something like:
> diff --git a/kernel/marker.c b/kernel/marker.c
> index 005b959..84964dc 100644
> --- a/kernel/marker.c
> +++ b/kernel/marker.c
> @@ -23,6 +23,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/marker.h>
>  #include <linux/err.h>
> +#include <linux/hardirq.h>
>  
>  extern struct marker __start___markers[];
>  extern struct marker __stop___markers[];
> @@ -672,7 +673,9 @@ int marker_probe_register(const char *name, const char *format,
>  	/* write rcu_pending before calling the RCU callback */
>  	smp_wmb();
>  #ifdef CONFIG_PREEMPT_RCU
> -	synchronize_sched();	/* Until we have the call_rcu_sched() */
> +	/* We are not preemptible when registering probes in early code */
> +	if (likely(preemptible()))
> +		synchronize_sched();	/* Until we have the call_rcu_sched() */
>  #endif
>  	call_rcu(&entry->rcu, free_old_closure);

I think call_rcu can become a problem too in that case. It is
responsible for freeing the old closure and I don't think it will be
executed if rcu or the scheduler is not active. Therefore, we should
also do something like :

if (likely(preemptible()))
   call_rcu(&entry->rcu, free_old_closure);
else
   free_old_closure(&entry->rcu);   (modulo passing the right
   parameters..)

All the synchronize_sched, cal_rcu and rcu_barriers should be changed. I
think the rcu_barriers should also have this kind of test to check for
early boot use.

Mathieu

>  end:
> 
> Is this the best approach? marker_probe_register() isn't a hot path, so
> that check won't mess up the performance. Anyway, this works for me.
> 
> 
> 	Eduard
> 
> (forgot LKML, added now.)
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
