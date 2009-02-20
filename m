Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZBTQtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZBTQtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZBTQtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:49:43 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52460 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbZBTQtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:49:42 -0500
Date: Fri, 20 Feb 2009 08:49:39 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090220164939.GI6960@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220134121.GA19575@damson.getinternet.no> <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu> <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com> <20090220160157.GA11294@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220160157.GA11294@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 05:01:57PM +0100, Ingo Molnar wrote:
> 
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> 
> > 2009/2/20 Ingo Molnar <mingo@elte.hu>:
> > >
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > >> ah, indeed:
> > >>
> > >>         list_del_rcu(&va->list);
> > >>
> > >> i suspect it could be hit big time in a workload that opens
> > >> more than 512 files, as expand_files() uses a
> > >> vmalloc()+vfree() pair in that case.
> > >
> > > hm, perhaps it's not a problem after all. The freeing is done
> > > via rcu, and list_del_rcu() leaves the forward pointer intact.
> > 
> > Well, it's not the particular line that you posted, in any case.
> > That's &va->list, but the traversed list is &va->purge_list.
> > 
> > I thought it would be the line:
> > 
> >         call_rcu(&va->rcu_head, rcu_free_va);
> > 
> > (which does kfree() in the callback) that was the problem.
> > 
> > >
> > > So how did it happen that the entry got kfree()d before the loop
> > > was done? We are in a spinlocked section so the CPU should not
> > > have entered rcu processing.
> > 
> > I added some printks to __free_vmap_area() and rcu_free_va(), and it
> > shows that the kfree() is being called immediately (inside the list
> > traversal). So the call_rcu() is happening immediately (or almost
> > immediately).
> > 
> > If I've understood correctly, the RCU processing can happen inside a
> > spinlock, as long as interrupts are enabled. (Won't the timer IRQ
> > trigger softirq processing, which triggers RCU callback processing,
> > for example?)
> > 
> > And interrupts are enabled when this happens: EFLAGS: 00000292
> > 
> > Please correct me if I am wrong!
> 
> The timer irq will do RCU garbage-collection - but only of 
> entries where a grace period has passed.
> 
> Otherwise there would be no point in using RCU at all, if the 
> kfree() can happen immediately. RCU is about delaying action, 
> and doing it at a point in time when we sure are in a quiescent 
> state. (we have done a context-switch or scheduled to idle)

Indeed, preemptable RCU grace periods extend for many milliseconds.

So, Vegard, when you say "immediately", do you mean "within
microseconds" or "faster than my human reflexes can react to"?

						Thanx, Paul

> The question is, is this piece of loop traversal code 
> preemptible? I dont think it is since it's embedded in a 
> spinlock:
> 
>                 spin_lock(&vmap_area_lock);
> -               list_for_each_entry(va, &valist, purge_list)
> +               list_for_each_entry_safe(va, n_va, &valist, purge_list)
>                        	__free_vmap_area(va);
>                 spin_unlock(&vmap_area_lock);
> 
> [ on -rt this could be preemptible and this would be a real fix 
>   there. I just dont see how the kfree() can execute on 
>   mainline. Obviously it did, since you got the kmemcheck 
>   assert. ]
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
