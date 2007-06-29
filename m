Return-Path: <linux-kernel-owner+w=401wt.eu-S1762863AbXF2LfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762863AbXF2LfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 07:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbXF2Le7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 07:34:59 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:36857 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756434AbXF2Le6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 07:34:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=mZo6+cwbBsnd+G0XHcO9LBGsfujMIv3YUIxSBHaQD6lvzZG4zzB+EViod8cgyXoY2e1a0AeVUP/2Uyn+DTROFhD9bWZteQ1pTauCWW4WfVQ8hHGBS6jEH0id/G/0NDj+xPq875n1QRPFbBdYH/FtPq8IlpoHhBVCKJdX7Rr2Ons=;
Date: Fri, 29 Jun 2007 15:34:23 +0400
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
Message-ID: <20070629113423.GA9042@ms2.inr.ac.ru>
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru> <20070628160001.GA15495@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628160001.GA15495@elte.hu>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> I find the 4usecs cost on a P4 interesting and a bit too high - how did 
> you measure it?

Simple and stupid:

int flag;

static void do_test(unsigned long dummy)
{
	flag = 1;
}

static void do_test_wq(void *dummy)
{
	flag = 1;
}

static void measure_tasklet0(void)
{
	int i;
	int cnt = 0;
	DECLARE_TASKLET(test, do_test, 0);
	unsigned long start = jiffies;

	for (i=0; i<1000000; i++) {
		flag = 0;
		local_bh_disable();
		tasklet_schedule(&test);
		local_bh_enable();
		while (flag == 0) {
			schedule();
			cnt++;
		} /*while (flag == 0)*/;
	}
	printk("tasklet0: %lu %d\n", jiffies - start, cnt);
}

static void measure_tasklet1(void)
{
	int i;
	int cnt = 0;
	DECLARE_TASKLET(test, do_test, 0);
	unsigned long start = jiffies;

	for (i=0; i<1000000; i++) {
		flag = 0;
		local_bh_disable();
		tasklet_schedule(&test);
		local_bh_enable();
		do {
			schedule();
			cnt++;
		} while (flag == 0);
	}
	printk("tasklet1: %lu %d\n", jiffies - start, cnt);
}

static void measure_workqueue(void)
{
	int i;
	int cnt = 0;
	unsigned long start;
	DECLARE_WORK(test, do_test_wq, 0);
	struct workqueue_struct * wq;

	start = jiffies;

	wq = create_workqueue("testq");

	for (i=0; i<1000000; i++) {
		flag = 0;
		queue_work(wq, &test);
		do {
			schedule();
			cnt++;
		} while (flag == 0);
	}
	printk("wq: %lu %d\n", jiffies - start, cnt);
	destroy_workqueue(wq);
}



> tasklet as an intermediary towards a softirq - what's the technological 
> point in such a splitup?

"... work_struct as intermediary towards a workqueue - what's the technological
point in such a splitup?" Non-sense? Yes, but it is exactly what you said. :-)

softirq is just a context and engine to run something. Exactly like
workqueue task. struct tasklet is work_struct, it is just a thing to run.


> workqueues can be per-cpu - for tasklets to be per-cpu you have to 
> open-code them into per-cpu like rcu-tasklets did

I feel I have to repeat: tasklet==work_struct, workqueue==softirq. 

Essentially, you said that workqueues "scale" in direction of increasing
amount of softirqs. This is _correct_, but the word is different: "flexible"
is the word. What's about performance,scalability blah-blah, workqueues
are definitely worse. And this is OK, you do not need to conceal this.

 This is the price, which we pay for flexibility and to niceness to realtime.

That's what should be said in adverticement notes instead of propaganda.



> Just look at the tasklet_disable() logic.

Do not count this.

Done this way because nobody needed that thing, except for _one_ place
in keyboard/console driver, which was very difficult to fix that time,
when vt code was utterly messy and not smp safe at all.

start_bh_atomic() was successfully killed, but we had to preserve analogue
of disable_bh() with the same semantics for some time.
It is deliberately implemented in a way, which does not impact hot paths
and is easy to remove.

It is sad that some usb drivers started to use this creepy and
useless thing.


> also, the "be afraid of the hardirq or the process context" mantra is 
> overblown as well. If something is too heavy for a hardirq, _it's too 
> heavy for a tasklet too_. Most hardirqs are (or should be) running with 
> interrupts enabled, which makes their difference to softirqs miniscule.

Incorrect.

The difference between softirqs and hardirqs lays not in their "heavyness".
It is in reentrancy protection, which has to be done with local_irq_disable(),
unless networking is not isolated from hardirqs. That's all.
Networking is too hairy to allow to be executed with disabled hardirqs.
And moving this hairyiness to process context requires
<irony mode> a little </> more efforts than conversion tasklets to work queues.


> The most scalable workloads dont involve any (or many) softirq middlemen 
> at all: you queue work straight from the hardirq context to the target 
> process context.

Do you really see something common between this Holy Grail Quest and
tasklets/workqeueus? Come on. :-)

Actually, this is step backwards. Instead of execution in correct
context, you create a new dummy context.  This is the place, where goals
of realtime and Holy Grail Quest split.


> true just as much: tasklets from a totally uninteresting network adapter 
> can kill your latency-sensitive application too.

If I started nice --22 running process I signed to killing latency
of nice 0 processes. But I did not sign for killing network/scsi adapters.
"latency-sensitive application" use real time priority as well,
so that they will compete with tasklets fairly.

