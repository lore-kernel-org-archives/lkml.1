Return-Path: <linux-kernel-owner+w=401wt.eu-S1761054AbXF1PSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761054AbXF1PSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbXF1PSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:18:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49612 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363AbXF1PSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:18:07 -0400
Message-ID: <4683D11B.8050608@garzik.org>
Date: Thu, 28 Jun 2007 11:17:47 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu>
In-Reply-To: <20070628092340.GB23566@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Tasklets fill a niche not filled by either workqueues (slower, 
>> requiring context switches, and possibly much latency is all wq's 
>> processes are active) [...]
> 
> ... workqueues are also possibly much more scalable (percpu workqueues 
> are easy without changing anything in your code but the call where you 
> create the workqueue).

All that scalability is just overhead, and overkill, for what 
tasklets/softirqs are used for.


> the context-switch argument i'll believe if i see numbers. You'll 
> probably need in excess of tens of thousands of irqs/sec to even be able 
> to measure its overhead. (workqueues are driven by nice kernel threads 
> so there's no TLB overhead, etc.)

As Alexey said...  I would have thought YOU needed to provide numbers, 
rather than just handwaving as justification for tasklet removal.


> the only remaining argument is latency: but workqueues are already 
> pretty high-prio (with a default priority of nice -5) - and you can 
> increase it even further. You can make it SCHED_FIFO prio 98 if latency 
> is so important.

You skipped the very relevant latency killer:  N threads in wq, and you 
submit the (N+1)th task.

I just cannot see how that is acceptable replacement for a network 
driver that uses tasklets.  Who wants to wait that long for packet RX or TX?


> Tasklets on the other hand are _unconditionally_ 
> high-priority. So this argument is more of an arms-race argument: "i 
> want _my_ processing to be done immediately!". The fact that workqueues 
> can be preempted and that their priorities can be adjusted flexibly is 
> an optional _bonus_, not a disadvantage. If low-prio workqueues hurts 
> your workflow, make them high-prio.

How about letting us stick with a solution that is WORKING now?

Of course tasklets are unconditionally high priority.  So are hardirqs. 
  So are softirqs.  This is not a problem, this is an expected and 
assumed-upon feature of the system.


>> And moving code -back- into hardirq is just the wrong thing to do, 
>> usually.
> 
> agreed - except if the in-tasklet processing is really thin and there's 
> already a softirq layer in the workflow. (which the case was for the 
> example that was cited.) In such a case moving either to the hardirq or 
> to the softirq looks like the right thing - instead of the tasklet 
> intermediary.

Wrong, for all the examples I care about -- drivers.  Network drivers in 
particular.  Just look at the comment in include/linux/interrupt.h if it 
wasn't clear:

/* PLEASE, avoid to allocate new softirqs, if you need not _really_ high
    frequency threaded job scheduling. For almost all the purposes
    tasklets are more than enough. F.e. all serial device BHs et
    al. should be converted to tasklets, not to softirqs.
  */

There is a good reason for this advice, as hinted at by the code 
immediately following the comment:

	enum
	{
	        HI_SOFTIRQ=0,
	        TIMER_SOFTIRQ,
	        NET_TX_SOFTIRQ,
	        NET_RX_SOFTIRQ,
	        BLOCK_SOFTIRQ,
	        TASKLET_SOFTIRQ,
	        SCHED_SOFTIRQ,
	#ifdef CONFIG_HIGH_RES_TIMERS
	        HRTIMER_SOFTIRQ,
	#endif
	};

softirqs cannot really be used by drivers, because they are not modular. 
  They are a scarce resource in any case.

Guess what?  All this is why we have tasklets.

tasklet != workqueue

	Jeff


