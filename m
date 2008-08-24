Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbYHXVTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbYHXVTy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 17:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYHXVTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 17:19:45 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35614 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYHXVTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 17:19:45 -0400
Date: Sun, 24 Aug 2008 14:19:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
Message-ID: <20080824211946.GI6851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <48B1170C.4050706@colorfullife.com> <20080824163200.GE6851@linux.vnet.ibm.com> <48B1A77E.5070504@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B1A77E.5070504@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 08:25:02PM +0200, Manfred Spraul wrote:
> Paul E. McKenney wrote:
>>>> + */
>>>> +struct rcu_node {
>>>> +	spinlock_t lock;
>>>> +	unsigned long	qsmask;	/* CPUs or groups that need to switch in      */
>>>> +				/*  order for current grace period to proceed.*/
>>>> +	unsigned long	qsmaskinit;
>>>> +				/* Per-GP initialization for qsmask.	      */
>>>>         
>>> I'm not sure if a bitmap is the right storage. If I understand the code 
>>> correctly, it contains two information:
>>> 1) If the bitmap is clear, then all cpus have completed whatever they 
>>> need to do.
>>> A counter is more efficient than a bitmap. Especially: It would allow to 
>>> choose the optimal fan-out, independent from 32/64 bits.
>>> 2) The information if the current cpu must do something to complete the 
>>> current period.non
>>> This is a local information, usually (always?) only the current cpu needs 
>>> to know if it must do something.
>>> But this doesn't need to be stored in a shared structure, the information 
>>> could be stored in a per-cpu structure.
>>
>> I am using the bitmap in force_quiescent_state() to work out who to
>> check dynticks and who to send reschedule IPIs to.  I could scan all
>> of the per-CPU rcu_data structures, but am assuming that after a few
>> jiffies there would typically be relatively few CPUs still needing to do
>> a quiescent state.  Given this assumption, on systems with large numbers
>> of CPUs, scanning the bitmask greatly reduces the number of cache misses
>> compared to scanning the rcu_data structures.
>>   
> It's an optimization question: What is rarer? force_quiescent_state() or 
> "normal" cpu_quiet calls.
> You have optimized for force_quiescent_state(), I have optimized for 
> "normal" cpu_quiet calls. [ok, I admit: force_quiescent_state() is still 
> missing in my code].

;-)

> Do you have any statistics?

If the system is completely busy, then I would expect normal cpu_quiet()
calls to be more common.  But if the system were sized for peak
workload, it would spend a fair amount of time with many of the CPUs
idle.  Power-conservation measures would hopefully push the idleness
into single cores/dies/whatever which could then be powered down.

A large fraction of the systems I see have utilizations well under 50%.
And latency concerns would also focus on force_quiescent state.

That said, I haven't had much to do with systems having more than 128
CPUs.

							Thanx, Paul
