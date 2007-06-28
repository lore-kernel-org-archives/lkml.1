Return-Path: <linux-kernel-owner+w=401wt.eu-S1764360AbXF1Rof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764360AbXF1Rof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759676AbXF1Ro1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:44:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50748 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758581AbXF1Ro0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:44:26 -0400
Message-ID: <4683F36D.7080100@garzik.org>
Date: Thu, 28 Jun 2007 13:44:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru> <20070628160001.GA15495@elte.hu>
In-Reply-To: <20070628160001.GA15495@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> But it was not me who claimed that 'workqueues are slow'.

The claim was:  slower than tasklets.


> choice. I am just wondering out loud whether this particular tool, in 
> its current usage pattern, makes much technological sense. My claim is: 
> it could very well be that it doesnt make _much_ sense, and in that case 
> we should provide a non-intrusive migration path away in terms of a 
> compatible API wrapper to a saner (albeit by virtue of trying to emulate 
> an existing API, slower) mechanism. The examples cited so far had the 
> tasklet as an intermediary towards a softirq - what's the technological 
> point in such a splitup?

I already answered that in detail.  In sum, a driver cannot define its 
own softirq.  Softirqs are not modular.

Tasklets are the closest thing to softirqs for a driver.


> The most scalable workloads dont involve any (or many) softirq middlemen 
> at all: you queue work straight from the hardirq context to the target 
> process context. And that's what you want to do _anyway_, because you 
> want to create as little locally cached data for the hardirq context, as 
> the target task could easily be on another CPU. (this is generally true 
> for things like block IO, but it's also true for things like network 
> IO.)
> 
> the most scalable solution would be _for the network adapter to figure 
> out the target CPU for the packet_.

I agree completely.  Wanna implement this?  I will kiss your feet, and 
multi-core CPU vendors will worship you as a demi-god.

Until such time, we must deal with the network stack as it exists today, 
and the network drivers as they exist and work today.


> Not many (if any) such adapters 
> exist at the moment. (as it would involve allocating NR_CPUs irqs to 
> that adapter alone.)

Good news:  this is becoming the norm for modern NICs, especially 10Gbps.

Plenty of NICs already exist that support multiple RX rings (persumably 
one per CPU), and newer NICs will raise individual MSI[-X] interrupts 
based on the RX ring into which a packet was received.

In this area, NIC vendors are way ahead of the Linux net stack.

The Linux net stack is unfortunately not threaded enough to sanely deal 
with dividing /flows/ up across multiple CPUs, even if the NIC does 
support multiple transmit and receive queues.   [side note: initial 
multi-queue TX is being worked on, on netdev]


>> Tasklet is single thread by definition and purpose. Those a few places 
>> where people used tasklets to do per-cpu jobs (RCU f.e.) exist just 
>> because they had troubles with allocating new softirq. [...]
> 
> no. The following tale is the true and only history of the RCU tasklet 
> ;-) The RCU guys first used a tasklet, then noticed its bad scalability 
> (a particular VFS-intense benchmark regressed because only a single CPU 
> would do RCU completion on an 8-way box) so they switched it to a 
> per-cpu tasklet - without realizing that a per-cpu tasklet is in essence 
> a softirq. I pointed it out to them (years down the road ...) then the 
> "convert rcu-tasklet to softirq" patch was born.

You focused on the example rather than the key phrase:  tasklet is 
single thread by definition and purpose.

Wanting to change that without analysis of the impact illustrates the 
apples-to-oranges change being proposed.


> outlined above: if you want good scalability, dont use middlemen :-) 
> Figure out the target task as early as possible and let it do as much of 
> the remaining work as possible. _Increasing_ the amount of cached 
> context (by doing delayed processing in tasklets or even softirqs on the 
> same CPU where the hardirq arrived) only increases the cross-CPU cost. 
> Keeping stuff in a softirq only makes (some) sense as long as you have 
> no target task at all (routing, filtering, etc.).

I do not disagree with these theoretical musings :)

I care the most about the "who will do all this work?" question.  In 
network driver land, these changes impact hot paths.  I am lazy, and 
don't care to revisit each network driver hot path and carefully re-tune 
each based on this proposal.  Who is volunteering?

	Jeff


