Return-Path: <linux-kernel-owner+w=401wt.eu-S1765758AbXF2Nlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765758AbXF2Nlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 09:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761094AbXF2Nlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 09:41:32 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:35453 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764286AbXF2Nlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 09:41:31 -0400
Date: Fri, 29 Jun 2007 09:41:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
In-Reply-To: <20070629113423.GA9042@ms2.inr.ac.ru>
Message-ID: <Pine.LNX.4.58.0706290919350.8866@gandalf.stny.rr.com>
References: <20070622040014.234651401@goodmis.org>
 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
 <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
 <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org>
 <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru>
 <20070628160001.GA15495@elte.hu> <20070629113423.GA9042@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 29 Jun 2007, Alexey Kuznetsov wrote:
> Hello!
>
> > I find the 4usecs cost on a P4 interesting and a bit too high - how did
> > you measure it?
>
> Simple and stupid:

Noted ;-)

> static void measure_tasklet0(void)
> {
> 	int i;
> 	int cnt = 0;
> 	DECLARE_TASKLET(test, do_test, 0);
> 	unsigned long start = jiffies;

Not a very accurate measurement (jiffies that is).

>
> 	for (i=0; i<1000000; i++) {
> 		flag = 0;
> 		local_bh_disable();
> 		tasklet_schedule(&test);
> 		local_bh_enable();
> 		while (flag == 0) {
> 			schedule();
> 			cnt++;
> 		} /*while (flag == 0)*/;
> 	}
> 	printk("tasklet0: %lu %d\n", jiffies - start, cnt);
> }
>

[...]

>
> static void measure_workqueue(void)
> {
> 	int i;
> 	int cnt = 0;
> 	unsigned long start;
> 	DECLARE_WORK(test, do_test_wq, 0);
> 	struct workqueue_struct * wq;
>
> 	start = jiffies;
>
> 	wq = create_workqueue("testq");
>
> 	for (i=0; i<1000000; i++) {
> 		flag = 0;
> 		queue_work(wq, &test);
> 		do {
> 			schedule();

Since the work queue *is* a thread, you are running a busy loop here. Even
though you call schedule, this thread still may have quota available, and
will not yeild to the work queue.  Unless ofcourse this caller is of lower
priority. But even then, I'm not sure how quickly the schedule would
choose the work queue.



 > 			cnt++;
> 		} while (flag == 0);
> 	}
> 	printk("wq: %lu %d\n", jiffies - start, cnt);
> 	destroy_workqueue(wq);
> }
>
>
>

> and is easy to remove.
>
> It is sad that some usb drivers started to use this creepy and
> useless thing.
>
>
> > also, the "be afraid of the hardirq or the process context" mantra is
> > overblown as well. If something is too heavy for a hardirq, _it's too
> > heavy for a tasklet too_. Most hardirqs are (or should be) running with
> > interrupts enabled, which makes their difference to softirqs miniscule.
>
> Incorrect.
>
> The difference between softirqs and hardirqs lays not in their "heavyness".
> It is in reentrancy protection, which has to be done with local_irq_disable(),
> unless networking is not isolated from hardirqs. That's all.
> Networking is too hairy to allow to be executed with disabled hardirqs.
> And moving this hairyiness to process context requires
> <irony mode> a little </> more efforts than conversion tasklets to work queues.
>

I do really want to point out something in the Subject line. **RFC**
:-)

I had very little hope for this magic switch to get into mainline. (maybe
get it into -mm)  But the thing was is that tasklets IMHO are over used.
As Ingo said, there are probably only 2 or 3 places in the kernel that a
a switch to work queue conversion couldn't solve. Those places could then
probably be solved by a different design (yes that would take work).

Tasklets are there and people will continue to use them when they
shouldn't for as long as they exist. Tasklets are there because there
wasn't work queues or kthreads at the time of solving the solution that
tasklets solved.

So if you can still keep the same performance without tasklets, I say we
get rid of them. I've also meet too many device driver writers that want
the lowest possible latency for their device, and do so by sacrificing the
latency of other things in the system that may be even more critical.

Also note, that the more tasklets we have, the higher the latency will be
for other tasklets. There's only two prios you can currently give a
tasklet, so competing devices will need to fight each other without the
admin being able to have as much control over the result.

-- Steve

