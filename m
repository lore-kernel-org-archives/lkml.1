Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbZDPOsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbZDPOsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZDPOrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:47:55 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44386 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbZDPOrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:47:53 -0400
Date: Thu, 16 Apr 2009 07:47:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeff.chua.linux@gmail.com,
       paulus@samba.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock and RCU (v5)
Message-ID: <20090416144748.GB6924@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <49E5BDF7.8090502@trash.net> <20090415135526.2afc4d18@nehalam> <49E64C91.5020708@cosmosbay.com> <20090415.164811.19905145.davem@davemloft.net> <20090415170111.6e1ca264@nehalam> <alpine.LFD.2.00.0904151705120.4042@localhost.localdomain> <20090415174551.529d241c@nehalam> <49E6BBA9.2030701@cosmosbay.com> <49E7384B.5020707@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49E7384B.5020707@trash.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 03:53:15PM +0200, Patrick McHardy wrote:
> Eric Dumazet wrote:
>> Stephen Hemminger a écrit :
>>> This is an alternative version of ip/ip6/arp tables locking using
>>> per-cpu locks.  This avoids the overhead of synchronize_net() during
>>> update but still removes the expensive rwlock in earlier versions.
>>>
>>> The idea for this came from an earlier version done by Eric Dumazet.
>>> Locking is done per-cpu, the fast path locks on the current cpu
>>> and updates counters.  The slow case involves acquiring the locks on
>>> all cpu's. This version uses RCU for the table->base reference
>>> but per-cpu-lock for counters.
>
>> This version is a regression over 2.6.2[0-9], because of two points
>> 1) Much more atomic ops :
>> Because of additional
>>> +			spin_lock(&__get_cpu_var(ip_tables_lock));
>>>  			ADD_COUNTER(e->counters, ntohs(ip->tot_len), 1);
>>> +			spin_unlock(&__get_cpu_var(ip_tables_lock));
>> added on each counter updates.
>> On many setups, each packet coming in or out of the machine has
>> to update between 2 to 20 rule counters. So to avoid *one* atomic ops
>> of read_unlock(), this v4 version adds 2 to 20 atomic ops...
>
> I agree, this seems to be a step backwards.
>
>> I still not see the problem between the previous version (2.6.2[0-8]) that 
>> had a central
>>  rwlock, that hurted performance on SMP because of cache line ping pong, 
>> and the solution
>> having one rwlock per cpu.
>> We wanted to reduce the cache line ping pong first. This *is* the hurting 
>> point,
>> by an order of magnitude.
>
> Dave doesn't seem to like the rwlock approach.

Well, we don't really need an rwlock, especially given that we really
don't want two "readers" incrementing the same counter concurrently.

A safer approach would be to maintain a flag in the task structure
tracking which (if any) of the per-CPU locks you hold.  Also maintain
a recursion-depth counter.  If the flag says you don't already hold
the lock, set it and acquire the lock.  Either way, increment the
recursion-depth counter:

	if (current->netfilter_lock_held != cur_cpu) {
		BUG_ON(current->netfilter_lock_held != CPU_NONE);
		spin_lock(per_cpu(..., cur_cpu));
		current->netfilter_lock_held = cur_cpu;
	}
	current->netfilter_lock_nesting++;

And reverse the process to unlock:

	if (--current->netfilter_lock_nesting == 0) {
		spin_unlock(per_cpu(..., cur_cpu));
		current->netfilter_lock_held = CPU_NONE;
	}

>                                                I don't see a way to
> do anything asynchronously like call_rcu() to improve this, so to
> bring up one of Stephens suggestions again:
>
>>> >   * use on_each_cpu() somehow to do grace periood?
>
> We could use this to replace the counters, presuming it is
> indeed faster than waiting for a RCU grace period.

One way to accomplish this is to take Mathieu Desnoyers's user-level
RCU implementation and drop it into the kernel, replacing the POSIX
signal handling with on_each_cpu(), smp_call_function(), or whatever.

>> 2) Second problem : Potential OOM
>> About freeing old rules with call_rcu() and/or schedule_work(), this is 
>> going
>> to OOM pretty fast on small appliances with basic firewall setups loading
>> rules one by one, as done by original topic reporter.
>> We had reports from guys using linux with 4MB of available ram (French 
>> provider free.fr on
>> their applicance box), and we had to use SLAB_DESTROY_BY_RCU thing on 
>> conntrack
>>  to avoid OOM for their setups. We dont want to use call_rcu() and queue 
>> 100 or 200 vfree().
>
> Agreed.

This is not a real problem be handled by doing a synchronize_rcu() every
so often as noted in a prior email elsewhere in this thread:

	call_rcu(...);
	if (++count > 50) {
		synchronize_rcu();
		count = 0;
	}

This choice of constant would reduce the grace-period pain to 2% of the
full effect, which should be acceptable, at least if I remember the
original problem report of 0.2 seconds growing to 6.0 seconds -- this
would give you:

	(6.0-0.2)/50+0.2 = .316

I would argue that 100 milliseconds is an OK penalty for a deprecated
feature.  But of course the per-CPU lock approach should avoid even that
penalty, albeit at some per-packet penalty.  However, my guess is that
this per-packet penalty is not measureable at the system level.

And if the penalty of a single uncontended lock -is- measureable, I will
be very quick to offer my congratulations, at least once I get my jaw
off my keyboard.  ;-)

							Thanx, Paul
