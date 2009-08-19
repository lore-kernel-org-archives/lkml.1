Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbZHSMAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbZHSMAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZHSMAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:00:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58264 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbZHSMAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:00:37 -0400
Date: Wed, 19 Aug 2009 13:59:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org
Subject: Re: [PATCH -tip/core/rcu 1/6] Cleanups and fixes for RCU in face
	of heavy CPU-hotplug stress
Message-ID: <20090819115952.GC32317@elte.hu>
References: <20090815165153.GA8886@linux.vnet.ibm.com> <1250533487.2709.14.camel@josh-work.beaverton.ibm.com> <20090817192036.GJ6760@linux.vnet.ibm.com> <20090818152643.GA5549@elte.hu> <20090818200701.GG6766@linux.vnet.ibm.com> <20090819060614.GA14383@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090819060614.GA14383@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Tue, Aug 18, 2009 at 01:07:01PM -0700, Paul E. McKenney wrote:
> > On Tue, Aug 18, 2009 at 05:26:43PM +0200, Ingo Molnar wrote:
> > > 
> > > FYI, i've started triggering hangs in -tip testing recently, during 
> > > CPU hotplug tests:
> > > 
> > > [   57.632003] eth0: no IPv6 routers present
> > > [  103.564010] kmemleak: 29 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> > > [  200.380003] Hangcheck: hangcheck value past margin!
> > > [  248.192003] INFO: task S99local:2974 blocked for more than 120 seconds.
> > > [  248.194532] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > [  248.202330] S99local      D 0000000c  6256  2974   2687 0x00000000
> > > [  248.208929]  9c7ebe90 00000086 6b67ef8b 0000000c 9f25a610 81a69869 00000001 820b6990
> > > [  248.216123]  820b6990 820b6990 9c6e4c20 9c6e4eb4 82c78990 00000000 6b993559 0000000c
> > > [  248.220616]  9c7ebe90 8105f22a 9c6e4eb4 9c6e4c20 00000001 9c7ebe98 9c7ebeb4 81a65cb3
> > > [  248.229990] Call Trace:
> > > [  248.234049]  [<81a69869>] ? _spin_unlock_irqrestore+0x22/0x37
> > > [  248.239769]  [<8105f22a>] ? prepare_to_wait+0x48/0x4e
> > > [  248.244796]  [<81a65cb3>] rcu_barrier_cpu_hotplug+0xaa/0xc9
> > > [  248.250343]  [<8105f029>] ? autoremove_wake_function+0x0/0x38
> > > [  248.256063]  [<81062cf2>] notifier_call_chain+0x49/0x71
> > > [  248.261263]  [<81062da0>] raw_notifier_call_chain+0x11/0x13
> > > [  248.266809]  [<81a0b475>] _cpu_down+0x272/0x288
> > > [  248.271316]  [<81a0b4d5>] cpu_down+0x4a/0xa2
> > > [  248.275563]  [<81a0c48a>] store_online+0x2a/0x5e
> > > [  248.280156]  [<81a0c460>] ? store_online+0x0/0x5e
> > > [  248.284836]  [<814ddc35>] sysdev_store+0x20/0x28
> > > [  248.289429]  [<8112e403>] sysfs_write_file+0xb8/0xe3
> > > [  248.294369]  [<8112e34b>] ? sysfs_write_file+0x0/0xe3
> > > [  248.299396]  [<810e4c8f>] vfs_write+0x91/0x120
> > > [  248.303817]  [<810e4dc1>] sys_write+0x40/0x65
> > > [  248.308150]  [<81002d73>] sysenter_do_call+0x12/0x28
> > > 
> > > config and bootlog attached. I'd suspect one of these patches:
> > > 
> > > 684ca5c: rcu: Fix typo in rcu_irq_exit() comment header
> > > b612ba8: rcu: Make rcupreempt_trace.c look at offline CPUs
> > > 8064d54: rcu: Make preemptable RCU scan all CPUs when summing RCU counters
> > > 2e59755: rcu: Simplify RCU CPU-hotplug notification
> > > 799e64f: cpu hotplug: Introduce cpu_notifier() to handle !HOTPLUG_CPU case
> > > 2756962: rcu: Split hierarchical RCU initialization into boot-time and CPU-online piece
> > > 
> > > Any ideas?
> > 
> > Gah...  I thought I had fixed that one!!!  I was seeing a deadlock
> > where rcu_barrier_cpu_hotplug() would register the three RCU callbacks,
> > then wait for them.  But in some situations, it would wait for them in
> > a state such that grace period could not complete.  I convinced myself
> > that moving the wait back from CPU_DEAD to CPU_POST_DEAD solved the
> > problem.
> > 
> > I am going to take a more bullet-proof approach, switching from the
> > wait_completion() form to wait_event(), which will allow me to wait
> > for the previous hotplug operation's callbacks at the beginning of the
> > subsequent hotplug operation.
> > 
> > I reserve the right to insert a short delay in the CPU-hotplug path
> > outside of any locks, but would imagine that people would prefer that
> > I avoid that sort of thing, at least until we have bulk CPU-hotplug
> > operations.
> 
> And here is a patch that is doing well in testing thus far.  (On 
> the other hand tip/core/rcu did fine in my testing.)  I am not 
> 100% confident that this new patch hitting the core 
> RCU/CPU-hotplug issue, but this is in any case helpful in getting 
> an RCU grace period off of the CPU hotunplug critical path.
> 
> Feel free to test if convenient.  The other thing I am 
> considering is moving the registering of the three 
> rcu_migrate_head callbacks from the CPU_DYING notifier to the 
> CPU_POST_DEAD notifier.

Thanks Paul, i've queued it up and started testing it. It took 
quite some time to trigger it so the test period needed will be 
measured in days (perhaps up to a week), not minutes or hours.

	Ingo
