Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbXF1OkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbXF1OkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbXF1OkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:40:16 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:45797 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755053AbXF1OkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:40:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=p8SsQ53hc7UFq/MFpRFRE7fxXwEVGRfmx0wUXGVBAdRHxFo/Bbt3uLSGIZdTLjl/809GVVUW+oXjP3EjwOuUCQ54gsbvlzmRNXPAJjipO7u/5BmpCgqnHjDmJDtCdUOLxcICZyCJghNU3BsHMeoHZTuOh7qu7KUvUiFdQGdG/tg=;
Date: Thu, 28 Jun 2007 18:38:50 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Garzik <jeff@garzik.org>,
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
Message-ID: <20070628143850.GA11780@ms2.inr.ac.ru>
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628092340.GB23566@elte.hu>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> the context-switch argument i'll believe if i see numbers. You'll 
> probably need in excess of tens of thousands of irqs/sec to even be able 
> to measure its overhead. (workqueues are driven by nice kernel threads 
> so there's no TLB overhead, etc.)

It was authors of the patch who were supposed to give some numbers,
at least one or two, just to prove the concept. :-)

According to my measurements (maybe, wrong) on 2.5GHz P4 tasklet
schedule and execution eats ~300ns, workqueue eats ~4usec.
On my 1.8GHz PM notebook (UP kernel), the numbers are 170ns and 1.2usec.

Formally looking awful, this result is positive: tasklets are almost
never used in hot paths. I am sure only about one such place: acenic
driver uses tasklet to refill rx queue. This generates not more than
3000 tasklet schedules per second. Even on P4 it pure workqueue schedule
will eat ~1% of bare cpu ticks.

Anyway, all the uses of tasklet should be verified:

The most dubios place is popular Neterion 10Gbit driver, which uses
tasklet like acenic. But at 10Gbit, multiply acenic numbers and panic. :-)

Also, there exists some hardware which uses tasklets even harder,
but I have no idea what real frequencies are: f.e. sundance.

The case with acenic/s2io is quite special: normally network drivers
refill queues in irq handlers. It was Jes Sorensen observation
that offloading refilling from irq improves performance, I do not
remember numbers. Probably, switching to workqueues will not affect
performance at all, probably it will just collapse, no idea.


> ... workqueues are also possibly much more scalable

I cannot figure out - scale in what direction? :-)
 

>						 (percpu workqueues 
> are easy without changing anything in your code but the call where you 
> create the workqueue).

I do not see how it is related to scalability. And the statement
does not even make sense. The patch already uses per-cpu workqueue
for tasklets, otherwise it would be a disaster: guaranteed cpu non-locality.

Tasklet is single thread by definition and purpose. Those a few places
where people used tasklets to do per-cpu jobs (RCU f.e.) exist just because
they had troubles with allocating new softirq. Workqueues do not make
any difference: tasklet is not workqueue, it is work_struct, and you
still will have to allocate array of per-cpu work structs, everything
remains the same.


> the only remaining argument is latency:

You could set realtime prioriry by default, not a poor nice -5.
If some network adapters were killed just because I run some task
with nice --22, it would be just ridiculous.

Alexey
