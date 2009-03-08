Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbZCHC77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbZCHC77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 21:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbZCHC7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 21:59:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61612 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbZCHC7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 21:59:49 -0500
Message-ID: <49B33463.7010300@cn.fujitsu.com>
Date: Sun, 08 Mar 2009 10:58:43 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu_barrier VS cpu_hotplug: Ensure callbacks in dead
 cpu are migrated to online cpu
References: <49B2526E.40106@cn.fujitsu.com> <20090307172907.GH10625@linux.vnet.ibm.com>
In-Reply-To: <20090307172907.GH10625@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Sat, Mar 07, 2009 at 06:54:38PM +0800, Lai Jiangshan wrote:
>> [RFC]
>> I don't like this patch, but I thought for some days and I can't
>> thought out a better one.
>>
>> I'm very hope rcu_barrier() can be called anywhere(any sleepable context).
>> But get_online_cpus() is a very large lock, it limits rcu_barrier().
>>
>> We can avoid get_online_cpus() easily for rcupreempt by using a new rcu_barrier:
>> void rcu_barrier(void)
>> {
>> 	for each rcu_data {
>> 		lock rcu_data;
>> 		if rcu_data is not empty, queue a callback for rcu_barrier;
>> 		unlock rcu_data;
>> 	}
>> }
>> But we cannot use this algorithm for rcuclassic and rcutree,
>> rcu_data in rcuclassic and rcutree have not a spinlock for queuing callback.
>>
>> From: Lai Jiangshan <laijs@cn.fujitsu.com>
>>
>> cpu hotplug may be happened asynchronously, some rcu callbacks are maybe
>> still in dead cpu, rcu_barrier() also needs to wait for these rcu callbacks
>> to complete, so we must ensure callbacks in dead cpu are migrated to
>> online cpu.
> 
> Hmmm...  I thought that on_each_cpu() took care of interlocking with
> CPU hotplug via smp_call_function().  During a CPU-hotplug operation,
> the RCU callbacks do get migrated from the CPU going offline.  Are you
> seeing a sequence of events that finds a hole in this approach?
> 
> Now, if a CPU were to go offline in the middle of smp_call_function()
> there could be trouble, but I was under the impression that the
> preempt_disable() in on_each_cpu() prevented this from happening.
> 
> So, please tell me more!
> 

preempt_disable() ensure online cpu is still online until preempt_enable(),
but preempt_disable()/preempt_enable() can't ensure rcu callbacks migrated.


rcu_barrier()			|	_cpu_down()
				|		__cpu_die() (cpu D is dead)
	........................|............................
	on_each_cpu()		|
	........................|...........................
	wait_for_completion()	|		rcu_offline_cpu() (move cpu D's
				|			rcu callbacks to A,B,or C)


on_each_cpu() does not queue rcu_barrier_callback to cpu D(it's dead).
So rcu_barrier() will not wait for callbacks which are original at cpu D.

We need ensure callbacks in dead cpu are migrated to online cpu before
we call on_each_cpu().

Thanks, Lai.
