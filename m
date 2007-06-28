Return-Path: <linux-kernel-owner+w=401wt.eu-S1762832AbXF1PXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762832AbXF1PXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbXF1PXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:23:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49662 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419AbXF1PXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:23:43 -0400
Message-ID: <4683D26C.2080701@garzik.org>
Date: Thu, 28 Jun 2007 11:23:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru>
In-Reply-To: <20070628143850.GA11780@ms2.inr.ac.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Kuznetsov wrote:
> Hello!
> 
>> the context-switch argument i'll believe if i see numbers. You'll 
>> probably need in excess of tens of thousands of irqs/sec to even be able 
>> to measure its overhead. (workqueues are driven by nice kernel threads 
>> so there's no TLB overhead, etc.)
> 
> It was authors of the patch who were supposed to give some numbers,
> at least one or two, just to prove the concept. :-)
> 
> According to my measurements (maybe, wrong) on 2.5GHz P4 tasklet
> schedule and execution eats ~300ns, workqueue eats ~4usec.
> On my 1.8GHz PM notebook (UP kernel), the numbers are 170ns and 1.2usec.

Thanks :)


> Anyway, all the uses of tasklet should be verified:
> 
> The most dubios place is popular Neterion 10Gbit driver, which uses
> tasklet like acenic. But at 10Gbit, multiply acenic numbers and panic. :-)
> 
> Also, there exists some hardware which uses tasklets even harder,
> but I have no idea what real frequencies are: f.e. sundance.
> 
> The case with acenic/s2io is quite special: normally network drivers
> refill queues in irq handlers. It was Jes Sorensen observation
> that offloading refilling from irq improves performance, I do not
> remember numbers. Probably, switching to workqueues will not affect
> performance at all, probably it will just collapse, no idea.

CPUs have gotten so fast now that its quite possible to run the tasklet 
in parallel with the next invocation of the interrupt handler.

But given the amount of tasklet use in network drivers, I do not think 
tasklets can just be magically equated to workqueues, without 
case-by-case analysis.


> Tasklet is single thread by definition and purpose. Those a few places

Indeed!


>> the only remaining argument is latency:
> 
> You could set realtime prioriry by default, not a poor nice -5.
> If some network adapters were killed just because I run some task
> with nice --22, it would be just ridiculous.

Indeed.

	Jeff


