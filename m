Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbZDQFSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbZDQFSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 01:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbZDQFS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 01:18:29 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:55552 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZDQFS2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 01:18:28 -0400
Message-ID: <49E810B0.9000906@cosmosbay.com>
Date: Fri, 17 Apr 2009 07:16:32 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: paulmck@linux.vnet.ibm.com, David Miller <davem@davemloft.net>,
       kaber@trash.net, torvalds@linux-foundation.org,
       jeff.chua.linux@gmail.com, paulus@samba.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, benh@kernel.crashing.org,
       mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU (v3)
References: <20090415170111.6e1ca264@nehalam>	<alpine.LFD.2.00.0904151705120.4042@localhost.localdomain>	<49E72E83.50702@trash.net>	<20090416.153354.170676392.davem@davemloft.net>	<20090416234955.GL6924@linux.vnet.ibm.com>	<20090417012812.GA25534@linux.vnet.ibm.com> <20090416215033.3e648a7a@nehalam>
In-Reply-To: <20090416215033.3e648a7a@nehalam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 17 Apr 2009 07:16:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger a écrit :
> On Thu, 16 Apr 2009 18:28:12 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
>> On Thu, Apr 16, 2009 at 04:49:55PM -0700, Paul E. McKenney wrote:
>>> On Thu, Apr 16, 2009 at 03:33:54PM -0700, David Miller wrote:
>>>> From: Patrick McHardy <kaber@trash.net>
>>>> Date: Thu, 16 Apr 2009 15:11:31 +0200
>>>>
>>>>> Linus Torvalds wrote:
>>>>>> On Wed, 15 Apr 2009, Stephen Hemminger wrote:
>>>>>>> The counters are the bigger problem, otherwise we could just free
>>>>>>> table
>>>>>>> info via rcu.  Do we really have to support: replace where the counter
>>>>>>> values coming out to user space are always exactly accurate, or is it
>>>>>>> allowed to replace a rule and maybe lose some counter ticks (worst
>>>>>>> case
>>>>>>> NCPU-1).
>>>>>> Why not just read the counters fromt he old one at RCU free time (they
>>>>>> are guaranteed to be stable at that point, since we're all done with
>>>>>> those entries), and apply them at that point to the current setup?
>>>>> We need the counters immediately to copy them to userspace, so waiting
>>>>> for an asynchronous RCU free is not going to work.
>>>> It just occurred to me that since all netfilter packet handling
>>>> goes through one place, we could have a sort-of "netfilter RCU"
>>>> of sorts to solve this problem.
>>> OK, I am putting one together...
>>>
>>> It will be needed sooner or later, though I suspect per-CPU locking
>>> would work fine in this case.
>> And here is a crude first cut.  Untested, probably does not even compile.
>>
>> Straight conversion of Mathieu Desnoyers's user-space RCU implementation
>> at git://lttng.org/userspace-rcu.git to the kernel (and yes, I did help
>> a little, but he must bear the bulk of the guilt).  Pick on srcu.h
>> and srcu.c out of sheer laziness.  User-space testing gives deep
>> sub-microsecond grace-period latencies, so should be fast enough, at
>> least if you don't mind two smp_call_function() invocations per grace
>> period and spinning on each instance of a per-CPU variable.
>>
>> Again, I believe per-CPU locking should work fine for the netfilter
>> counters, but I guess "friends don't let friends use hashed locks".
>> (I would not know for sure, never having used them myself, except of
>> course to protect hash tables.)
>>
>> Most definitely -not- for inclusion at this point.  Next step is to hack
>> up the relevant rcutorture code and watch it explode on contact.  ;-)
>>
>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> I am glad to see this worked on, but would rather not use RCU in this case
> of iptables. It would be good for some of the other long grace period sutff.
> 
> The code to per-cpu entry consolidation by alloc/flip in 2.6.30-rc2 was
> hard to debug and more convoluted so it probably would be a long term maintaince
> nightmare.  The issue was the variable size skip structure so it made
> for lots of iterators, etc. If the non-RCU per-cpu spinlock version is just
> as fast, it is easier to understand.

I agree that for 2.6.30, we could use a per-cpu spinlock as your last patch did,
this would be very risky to push this new RCU right now. 

But this new stuff looks very promising, (no more locked ops on fast path),
and considering new percpu_{add|sub...} infra, very fast :

static inline void rcu_read_unlock_fgp(void)
{
	barrier();
	percpu_sub(rcu_fgp_active_readers, 1); /* one instruction on x86 */
	preempt_enable();
}

I wonder if IPI are really necessary on x86 if we use percpu_sub() since
it already contains a barrier, and rcu_read_lock_fgp(void) also ends with
a barrier() call...

