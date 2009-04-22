Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbZDVIyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbZDVIyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 04:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZDVIyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 04:54:36 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:36788 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZDVIyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 04:54:33 -0400
Message-ID: <49EEDAF0.2010507@cosmosbay.com>
Date: Wed, 22 Apr 2009 10:53:04 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Hemminger <shemminger@vyatta.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, paulmck@linux.vnet.ibm.com,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       kaber@trash.net, jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v11)
References: <20090420103414.1b4c490f@nehalam> <49ECBE0A.7010303@cosmosbay.com> <18924.59347.375292.102385@cargo.ozlabs.ibm.com> <20090420215827.GK6822@linux.vnet.ibm.com> <18924.64032.103954.171918@cargo.ozlabs.ibm.com> <20090420160121.268a8226@nehalam> <alpine.LFD.2.00.0904210831560.2199@localhost.localdomain> <20090421111541.228e977a@nehalam> <20090421191007.GA15485@elte.hu> <49EE2293.4090201@cosmosbay.com> <20090422073524.GA31835@elte.hu>
In-Reply-To: <20090422073524.GA31835@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 22 Apr 2009 10:53:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> Ingo Molnar a écrit :
>>> Why not use the obvious solution: a _single_ wrlock for global 
>>> access and read_can_lock() plus per cpu locks in the fastpath?
>> Obvious is not the qualifier I would use :)
>>
>> Brilliant yes :)
> 
> thanks :)
> 
>>> That way there's no global cacheline bouncing (just the 
>>> _reading_ of a global cacheline - which will be nicely localized 
>>> - on NUMA too) - and we will hold at most 1-2 locks at once!
>>>
>>> Something like:
>>>
>>> 	__cacheline_aligned DEFINE_RWLOCK(global_wrlock);
>>>
>>> 	DEFINE_PER_CPU(rwlock_t local_lock);
>>>
>>>
>>> 	void local_read_lock(void)
>>> 	{
>>> 	again:
>>> 		read_lock(&per_cpu(local_lock, this_cpu));
>> Hmm... here we can see global_wrlock locked by on writer, while 
>> this cpu already called local_read_lock(), and calls again this 
>> function -> Deadlock, because we hold our local_lock locked.
> 
> Yeah, indeed.
> 
> I wasnt really concentrating on the nested case, i was concentrating 
> on the scalability and lock nesting angle. I think the code 
> submitted here looks rather incestous in that regard.
> 
> Allowing nested locking _on the same CPU_ is asking for trouble. Use 
> short critical sections and if there's any exclusion needed, use an 
> irq-safe lock or a softirq-safe lock. Problem solved.
> 
>> Very interesting and could be changed to use spinlock + depth per 
>> cpu.
>>
>> -> we can detect recursion and avoid the deadlock, and we only use 
>> one atomic operation per lock/unlock pair in fastpath (this was 
>> the reason we tried hard to use a percpu spinlock during this 
>> thread)
>>
>>
>> __cacheline_aligned DEFINE_RWLOCK(global_wrlock);
>>
>> struct ingo_local_lock {
>> 	spinlock_t lock;
>> 	int depth;
>> };
>> DEFINE_PER_CPU(struct ingo_local_lock local_lock);
>>
>>
>> void local_read_lock(void)
>> {
>> 	struct ingo_local_lock *lck;
>>
>> 	local_bh_and_preempt_disable();
>> 	lck = &get_cpu_var(local_lock);
>> 	if (++lck->depth > 0) /* already locked */
>> 		return;
>> again:
>> 	spin_lock(&lck->lock);
>>
>> 	if (unlikely(!read_can_lock(&global_wrlock))) {
>> 		spin_unlock(&lck->lock);
>> 		/*
>> 		 * Just wait for any global write activity:
>> 		 */
>> 		read_unlock_wait(&global_wrlock);
>> 		goto again;
>> 	}
>> }
>>
>> void global_write_lock(void)
>> {
>> 	write_lock(&global_wrlock);
>>
>> 	for_each_possible_cpu(i)
>> 		spin_unlock_wait(&per_cpu(local_lock, i));
>> }
>>
>> Hmm ?
> 
> Yeah, this looks IRQ-nesting safe. But i really have to ask: why 
> does this code try so hard to allow same-CPU nesting?
> 
> Nesting on the same CPU is _bad_ for several reasons:
> 
> 1) Performance: it rips apart critical sections cache-wise. Instead 
>    of a nice:
> 
>        C1 ... C2 ... C3 ... C4
> 
>    serial sequence of critical sections, we get:
>  
>        C1A ... ( C2 ) ... C1B ... C3 ... C4
> 
>    Note that C1 got "ripped apart" into C1A and C1B with C2 injected 
>    - reducing cache locality between C1A and C1B. We have to execute
>    C1B no matter what, so we didnt actually win anything in terms of 
>    total work to do, by processing C2 out of order.
> 
>    [ Preemption of work (which this kind of nesting is really about)
>      is _the anti-thesis of performance_, and we try to delay it as
>      much as possible and we try to batch up as much as possible. 
>      For example the CPU scheduler will try _real_ hard to not 
>      preempt a typical workload, as long as external latency 
>      boundaries allow that. ]
> 
> 2) Locking complexity and robustness. Nested locking is rank #1 in
>    terms of introducing regressions into the kernel.
> 
> 3) Instrumentation/checking complexity. Checking locking 
>    dependencies is good and catches a boatload of bugs before they 
>    hit upstream, and nested locks are supported but cause an 
>    exponential explosion in terms of dependencies to check.
> 
>    Also, whenever instrumentation explodes is typically the sign of 
>    some true, physical complexity that has been introduced into the 
>    code. So it often is a canary for a misdesign at a fundamental 
>    level, not a failure in the instrumentation framework.
> 
> In the past i saw lock nesting often used as a wrong solution when 
> the critical sections were too long (causing too long latencies for 
> critical work - e.g. delaying hardirq completion processing 
> unreasonably), or just plain out of confusion about the items above.
> 

I agree with all this Ingo.

> I dont know whether that's the case here - it could be one of the 
> rare exceptions calling for a new locking primitive (which should 
> then be introduced at the core kernel level IMHO) - i dont know the 
> code that well.


The netfilter case is real simple Ingo, (note I did not use "obvious" here ;) )

netfilter in 2.6.2[0-9] used :

CPU 1

sofirq handles one packet from a NIC

ipt_do_table() /* to handle INPUT table for example, or FORWARD */
read_lock_bh(&a_central_and_damn_rwlock)
... parse rules
    -> calling some netfilter sub-function
       re-entering network IP stack to send some packet (say a RST packet)
       ...
       ipt_do_table() /* to handle OUPUT table rules for example */
       read_lock_bh() ; /* WE RECURSE here, but once in a while (if ever) */


This is one of the case, but other can happens with virtual networks, tunnels, ...
and so on. (Stephen had some cases with KVM if I remember well)

If this could be done without recursion, I am pretty sure netfilter
and network guys would have done it. I found Linus reaction quite
shocking IMHO, considering hard work done by all people on this.

I was pleased by your locking schem, that was *very* interesting, even
if not yet ready.

1) We can discuss of how bad recursion is.

We know loopback_xmit() could be way faster if we could avoid queeing packet
to softirq handler.
(Remember you and I suggested this patch some months ago ? Please remember
David rejected this because of recursion and possibility to overflow stack)

So yes, people are aware of recursion problems.

2) We can discuss how bad rwlocks are

We did lot of work on last months to delete some of rwlocks we had in kernel.
UDP stack for example dont use them anymore.

We tried to delete them on x_tables, but we must take care of ipt_do_table() nesting,
that is legal on 2.6.30.
Maybe netfilter guys can work to avoid this nesting on 2.6.31, 
I dont know how hard it is, definitly not 2.6.30 material.

Solutions were discussed many times and Stephen provided 13 versions of the patch.
If this was that obvious, one or two iterations would have been OK.

3) About last patch (v13)
Stephen did not agreed with you (well... maybe after all ..),
he only submitted again a previous version.

With linux-2.6.2[0-9], "iptables -L" used to block all cpus from entering netfilter
because we did a write_lock_bh() on the central rwlock while folding counters.

On v13, we dont try to freeze whole x_table context, but cpu per cpu.
Thats a minor change against previous versions, and should not lead to strange
application behavior. Its so much scalable that we should accept this change.



