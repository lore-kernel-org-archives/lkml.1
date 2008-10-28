Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbYJ1F21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbYJ1F21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 01:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYJ1F2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 01:28:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:55595 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbYJ1F2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 01:28:18 -0400
Message-ID: <4906A370.3000502@colorfullife.com>
Date: Tue, 28 Oct 2008 06:30:24 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
References: <20081012224629.GA7353@linux.vnet.ibm.com> <48F38D73.8040804@colorfullife.com> <20081015011143.GE6874@linux.vnet.ibm.com> <48F5A638.8020003@colorfullife.com> <20081015152637.GA6739@linux.vnet.ibm.com> <48FF73C7.90709@colorfullife.com> <20081022210254.GE6766@linux.vnet.ibm.com> <48FF9A0E.90205@colorfullife.com> <20081027164529.GC6783@linux.vnet.ibm.com> <49061AF0.8070106@colorfullife.com> <20081027235201.GK6783@linux.vnet.ibm.com>
In-Reply-To: <20081027235201.GK6783@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Mon, Oct 27, 2008 at 08:48:00PM +0100, Manfred Spraul wrote:
>   
>> Paul E. McKenney wrote:
>>     
>>> Agreed.  Perhaps a good change to make while introducing stall detection
>>> to preemptable RCU -- there would then be three examples, which should
>>> allow good generalization.
>>>   
>>>       
>> Two implementations. IMHO the current rcu-classic code should be dropped 
>> immediately when you add rcu-tree:
>> rcu-classic is buggy, as far as I can see long-running interrupts on nohz 
>> cpus are not handled correctly. I don't think it makes sense to keep it in 
>> the kernel in parallel to rcu-tree.
>>
>> I would propose that rcu-tree replaces rcu-classic.
>> I'll continue to update rcu-state, I think that it will achieve lower 
>> latency than rcu-tree [average/max time between call_rcu() and destruction 
>> callback] and it doesn't have the irq disabled loop to find the missing 
>> cpus.
>> If I find decent benchmarks where I can quantify the advantages, then I'll 
>> propose to merge rcu-state as a third implementation in addition to 
>> rcu-tree and rcu-preempt.
>>
>> Paul: What do you think?
>>     
>
> In keeping with my reputation as a "conservative programmer", I would
> suggest that rcuclassic.c remain for a year or so.  Distros branching
> off during this time should continue making rcuclassic.c be the default.
> Other uses should have rcutree.c as the default.  At the end of the year,
> we remove rcuclassic.c.
>
> All that said, one attractive aspect of your suggestion is immediately
> removing rcuclassic.c would eliminate the need to do further work on it.  ;-)
>
>   
How do you intend to handle nohz cpus?
I would create a separate patch that removes rcuclassic.c. distros that 
want to keep rcuclassic could just revert that change.

--
    Manfred
> Your benchmarking proposal for rcu-state makes sense to me.
>
> One other possible place for techniques from rcu-state may be in making
> preemptable RCU scale.  This may take some time, as other parts of
> the RT kernel have their limitations, but sooner or later people are
> going to expect real-time response from even the largest machines.
> In addition, preemptable RCU has a number of shorter-term issues:
>
> 1.	RCU-boosting mechanism.  (I need to combine the best of
> 	Steve's and my mechanisms.  The treercu.c effort has been
> 	sort of a warm-up exercise for RCU-boosting.)
>
> 2.	Reducing the latency contribution of the preemptable RCU
> 	state machine (but note that moving this state machine out
> 	of the scheduling-clock irq handler means more stuff to boost).
>
> 3.	Porting the simpler dynticks interface from rcutree to
> 	preemptable RCU.
>
> 4.	Making the preemptable RCU tracing code use seqfile.
>
> Hmmm...  Maybe it is (past) time for me to publish an RCU to-do list?
>
> 							Thanx, Paul
>   

