Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbZBTNWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbZBTNWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 08:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZBTNWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 08:22:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59366 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZBTNWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 08:22:10 -0500
Date: Fri, 20 Feb 2009 14:21:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org, arun@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] timers: framework for migration between CPU
Message-ID: <20090220132145.GF26418@elte.hu>
References: <20090220125516.GB10232@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220125516.GB10232@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arun R Bharadwaj <arun@linux.vnet.ibm.com> wrote:

> Hi,
> 
> 
> In an SMP system, tasks are scheduled on different CPUs by the 
> scheduler, interrupts are managed by irqbalancer daemon, but 
> timers are still stuck to the CPUs that they have been 
> initialised.  Timers queued by tasks gets re-queued on the CPU 
> where the task gets to run next, but timers from IRQ context 
> like the ones in device drivers are still stuck on the CPU 
> they were initialised.  This framework will help move all 
> 'movable timers' from one CPU to any other CPU of choice using 
> a sysfs interface.

hm, the intention is good, the concept of migrating timers to 
their target CPU is good as well. We already do some of that for 
regular timers.

But the whole sysfs interface you implemented here is not 
particularly clean nor is it efficient.

The main problem is that timers are really fast-moving entities, 
and so are the tasks they are related to.

Your implementation completely ties the direction of migration 
(the timer scheduling) to a clumsy sysfs interface:

+	if (sscanf(buf, "%d", &target_cpu) && cpu_online(target_cpu)) {
+               ret = count;
+               per_cpu(enable_timer_migration, cpu->sysdev.id) = target_cpu;
+	}

That doesnt really scale and i doubt it works in practice. We 
should not schedule timers via sysfs, we should let the kernel 
do it auomatically. [*]

So what i'd suggest instead is extend the scheduler power-saving 
code, which already identifies a 'load balancer CPU', to also 
attract all attractable sources of timers - automatically. See 
the 'load_balancer' CPU logic in kernel/sched.c.

Does that sound OK to you? I think the end result might even 
give better numbers - and out of box.

I'd also suggest to not do that rather ugly 
enable_timer_migration per-cpu variable, but simply reuse the 
existing nohz.load_balancer as a target CPU.

Also, please base your patches on the latest timer tree (which 
already modified some of this code in this cycle):

  http://people.redhat.com/mingo/tip.git/README

Btw., could you please also fix your mailer to not do this to 
us:

Mail-Followup-To: linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
        ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
        andi@firstfloor.org, venkatesh.pallipadi@intel.com,
        vatsa@linux.vnet.ibm.com, arjan@infradead.org

it messes up the replies.

	Ingo

[*] IRQ migration (where you possibly got the sysfs idea from) 
    is a special case where 'slow scheduling' via a user-space 
    daemon is possible: they are an external source of events 
    and they are concentrators of work. The same concept does 
    not apply to timers, most of which are inherently 
    task-generated.

