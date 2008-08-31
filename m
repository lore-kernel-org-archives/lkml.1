Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbYHaK63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbYHaK63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 06:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757429AbYHaK6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 06:58:21 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:5255 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359AbYHaK6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 06:58:20 -0400
Message-ID: <48BA7944.8070402@colorfullife.com>
Date: Sun, 31 Aug 2008 12:58:12 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, rostedt@goodmis.org,
       peterz@infradead.org
Subject: Re: [PATCH, RFC, tip/core/rcu] v3 scalable classic RCU implementation
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <48B919C2.1040809@cn.fujitsu.com> <48B94BF4.9090103@colorfullife.com> <20080830143438.GF7107@linux.vnet.ibm.com>
In-Reply-To: <20080830143438.GF7107@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
>
>> Perhaps it's possible to rely on CPU_DYING, but I haven't figured out yet 
>> how to handle read-side critical sections in CPU_DYING handlers.
>> Interrupts after CPU_DYING could be handled by rcu_irq_enter(), 
>> rcu_irq_exit() [yes, they exist on x86: the arch code enables the local 
>> interrupts in order to process the currently queued interrupts]
>>     
>
> My feeling is that CPU online/offline will be quite rare, so it should
> be OK to clean up after the races in force_quiescent_state(), which in
> this version is called every three ticks in a given grace period.
>   
If you add failing cpu offline calls, then the problem appears to be 
unsolvable:
If I get it right, the offlining process looks like this:
* one cpu in the system makes the CPU_DOWN_PREPARE notifier call. These 
calls can sleep (e.g. slab sleeps on semaphores). The cpu that goes 
offline is still alive, still doing arbitrary work. cpu_quiet calls on 
behalf of the cpu would be wrong.
* stop_machine: all cpus schedule to a special kernel thread [1], only 
the dying cpu runs.
* The cpu that goes offline calls the CPU_DYING notifiers.
* __cpu_disable(): The cpu that goes offline check if it's possible to 
offline the cpu. At least on i386, this can fail.
On success:
* at least on i386: the cpu that goes offline handles outstanding 
interrupts. I'm not sure, perhaps even softirqs are handled.
* the cpus stopps handling interrupts.
* stop machine leaves, the remaining cpus continue their work.
* The CPU_DEAD notifiers are called. They can sleep.
On failure:
* all cpus continue their work. call_rcu, synchronize_rcu(), ...
* some time later: the CPU_DOWN_FAILED callbacks are called.

Is that description correct?
Then:
- treating a cpu as always quiet after the rcu notifer was called with 
CPU_OFFLINE_PREPARE is wrong: the target cpu still runs normal code: 
user space, kernel space, interrupts, whatever. The target cpu still 
accepts interrupst, thus treating it as "normal" should work.
__cpu_disable() success:
- after CPU_DYING, a cpu is either in an interrupt or outside read-side 
critical sections. Parallel synchronize_rcu() calls are impossible until 
the cpu is dead. call_rcu() is probably possible.
- The CPU_DEAD notifiers are called. a synchronize_rcu() call before the 
rcu notifier is called is possible.
__cpu_disable() failure:
- CPU_DYING is called, but the cpu remains fully alive. The system comes 
fully alive again.
- some time later, CPU_DEAD is called.

With the current CPU_DYING callback, it's impossible to be both 
deadlock-free and race-free with the given conditions. If 
__cpu_disable() succeeds, then the cpu must be treated as gone and 
always idle. If __cpu_disable() fails, then the cpu must be treated as 
fully there. Doing both things at the same time is impossible. Waiting 
until CPU_DOWN_FAILED or CPU_DEAD is called is impossible, too: Either 
synchronize_rcu() in a CPU_DEAD notifier [called before the rcu 
notifier] would deadlock or read-side critical sections on the 
not-killed cpu would race.

What about moving the CPU_DYING notifier calls behind the 
__cpu_disable() call?
Any other solutions?

Btw, as far as I can see, rcupreempt would deadlock if a CPU_DEAD 
notifier uses synchronize_rcu().
Probably noone will ever succeed in triggering the deadlock:
- cpu goes offline.
- the other cpus in the system are restarted.
- one cpu does the CPU_DEAD notifier calls.
- before the rcu notifier is called with CPU_DEAD:
- one CPU_DEAD notifier sleeps.
- while CPU_DEAD is sleeping: on the same cpu: kmem_cache_destroy is 
called. get_online_cpus immediately succeeds.
- kmem_cache_destroy acquires the cache_chain_mutex.
- kmem_cache_destroy does synchronize_rcu(), it sleeps.
- CPU_DEAD processing continues, the slab CPU_DEAD tries to acquire the 
cache_chain_mutex. it sleeps, too.
--> deadlock, because the already dead cpu will never signal itself as 
quiet. Thus synchronize_rcu() will never succeed, thus the slab CPU_DEAD 
notifier will never return, thus rcu_offline_cpu() is never called.

--
    Manfred
[1] open question: with rcu_preempt, is it possible that these cpus 
could be inside read side critical sections?
