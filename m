Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYHXSZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYHXSZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 14:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYHXSZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 14:25:09 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:9979 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYHXSZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 14:25:08 -0400
Message-ID: <48B1A77E.5070504@colorfullife.com>
Date: Sun, 24 Aug 2008 20:25:02 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
References: <20080821234318.GA1754@linux.vnet.ibm.com> <48B1170C.4050706@colorfullife.com> <20080824163200.GE6851@linux.vnet.ibm.com>
In-Reply-To: <20080824163200.GE6851@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
>>> + */
>>> +struct rcu_node {
>>> +	spinlock_t lock;
>>> +	unsigned long	qsmask;	/* CPUs or groups that need to switch in      */
>>> +				/*  order for current grace period to proceed.*/
>>> +	unsigned long	qsmaskinit;
>>> +				/* Per-GP initialization for qsmask.	      */
>>>   
>>>       
>> I'm not sure if a bitmap is the right storage. If I understand the code 
>> correctly, it contains two information:
>> 1) If the bitmap is clear, then all cpus have completed whatever they need 
>> to do.
>> A counter is more efficient than a bitmap. Especially: It would allow to 
>> choose the optimal fan-out, independent from 32/64 bits.
>> 2) The information if the current cpu must do something to complete the 
>> current period.non
>> This is a local information, usually (always?) only the current cpu needs 
>> to know if it must do something.
>> But this doesn't need to be stored in a shared structure, the information 
>> could be stored in a per-cpu structure.
>>     
>
> I am using the bitmap in force_quiescent_state() to work out who to
> check dynticks and who to send reschedule IPIs to.  I could scan all
> of the per-CPU rcu_data structures, but am assuming that after a few
> jiffies there would typically be relatively few CPUs still needing to do
> a quiescent state.  Given this assumption, on systems with large numbers
> of CPUs, scanning the bitmask greatly reduces the number of cache misses
> compared to scanning the rcu_data structures.
>
>   
It's an optimization question: What is rarer? force_quiescent_state() or 
"normal" cpu_quiet calls.
You have optimized for force_quiescent_state(), I have optimized for 
"normal" cpu_quiet calls. [ok, I admit: force_quiescent_state() is still 
missing in my code].
Do you have any statistics?

--
    Manfred
