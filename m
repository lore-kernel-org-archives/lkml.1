Return-Path: <linux-kernel-owner+w=401wt.eu-S1751271AbZCHGVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271AbZCHGVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 01:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbZCHGVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 01:21:04 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46011 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZCHGVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 01:21:01 -0500
Date: Sat, 7 Mar 2009 22:20:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu_barrier VS cpu_hotplug: Ensure callbacks in dead
	cpu are migrated to online cpu
Message-ID: <20090308062059.GO10625@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <49B2526E.40106@cn.fujitsu.com> <20090307172907.GH10625@linux.vnet.ibm.com> <49B33463.7010300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B33463.7010300@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 10:58:43AM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > On Sat, Mar 07, 2009 at 06:54:38PM +0800, Lai Jiangshan wrote:
> >> [RFC]
> >> I don't like this patch, but I thought for some days and I can't
> >> thought out a better one.
> >>
> >> I'm very hope rcu_barrier() can be called anywhere(any sleepable context).
> >> But get_online_cpus() is a very large lock, it limits rcu_barrier().
> >>
> >> We can avoid get_online_cpus() easily for rcupreempt by using a new rcu_barrier:
> >> void rcu_barrier(void)
> >> {
> >> 	for each rcu_data {
> >> 		lock rcu_data;
> >> 		if rcu_data is not empty, queue a callback for rcu_barrier;
> >> 		unlock rcu_data;
> >> 	}
> >> }
> >> But we cannot use this algorithm for rcuclassic and rcutree,
> >> rcu_data in rcuclassic and rcutree have not a spinlock for queuing callback.
> >>
> >> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> >>
> >> cpu hotplug may be happened asynchronously, some rcu callbacks are maybe
> >> still in dead cpu, rcu_barrier() also needs to wait for these rcu callbacks
> >> to complete, so we must ensure callbacks in dead cpu are migrated to
> >> online cpu.
> > 
> > Hmmm...  I thought that on_each_cpu() took care of interlocking with
> > CPU hotplug via smp_call_function().  During a CPU-hotplug operation,
> > the RCU callbacks do get migrated from the CPU going offline.  Are you
> > seeing a sequence of events that finds a hole in this approach?
> > 
> > Now, if a CPU were to go offline in the middle of smp_call_function()
> > there could be trouble, but I was under the impression that the
> > preempt_disable() in on_each_cpu() prevented this from happening.
> > 
> > So, please tell me more!
> > 
> 
> preempt_disable() ensure online cpu is still online until preempt_enable(),
> but preempt_disable()/preempt_enable() can't ensure rcu callbacks migrated.
> 
> 
> rcu_barrier()			|	_cpu_down()
> 				|		__cpu_die() (cpu D is dead)
> 	........................|............................
> 	on_each_cpu()		|
> 	........................|...........................
> 	wait_for_completion()	|		rcu_offline_cpu() (move cpu D's
> 				|			rcu callbacks to A,B,or C)
> 
> 
> on_each_cpu() does not queue rcu_barrier_callback to cpu D(it's dead).
> So rcu_barrier() will not wait for callbacks which are original at cpu D.
> 
> We need ensure callbacks in dead cpu are migrated to online cpu before
> we call on_each_cpu().

Good catch!!!  I did indeed miss that possibility.  :-/

Hmmmm...  rcu_barrier() already acquires a global mutex, and is an
infrequent operation, so I am not all that worried about the scalability.

But I agree that there should be a better way to do this.  One approach
might be to the dying CPU enqueue the rcu_barrier() callback on its
own list when it goes offline, during the stop_machine() time period.
This enqueuing operation would require some care -- it would be necessary
to check to see if the callback was already on the list, for example,
as well as to properly adjust the rcu_barrier_completion() state.

Of course, it would also be necessary to handle the case where an
rcu_barrier() callback was enqueued when there was no rcu_barrier()
in flight, preferably by preventing this from happening.

An entirely different approach would be to steal a trick from CPU
designers, and use a count of the number of rcu_barrier() calls (this
counter could be a single bit).  Have a per-CPU counter of the number
of callbacks outstanding for each counter value.  Then rcu_barrier()
simply increments the rcu_barrier() counter, and waits until the
number of outstanding callbacks corresponding to the old value drops
to zero.  This would get rid of the need for rcu_barrier() to enqueue
callbacks, preventing the scenario above from arising in the first
place.

Other thoughts?

And again, good catch!!!

						Thanx, Paul
