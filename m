Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbYJIIQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbYJIIQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 04:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbYJIIQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 04:16:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36075 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbYJIIQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 04:16:15 -0400
Date: Thu, 9 Oct 2008 10:22:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, dipankar@in.ibm.com
Subject: Re: RCU hang on cpu re-hotplug with 2.6.27rc8
Message-ID: <20081009082230.GE24560@one.firstfloor.org>
References: <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org> <20081007163401.GJ6384@linux.vnet.ibm.com> <20081007210947.GP20740@one.firstfloor.org> <20081007212215.GN6384@linux.vnet.ibm.com> <20081009013321.GA11291@linux.vnet.ibm.com> <20081009045646.GB24560@one.firstfloor.org> <alpine.LFD.2.00.0810090921320.3237@apollo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810090921320.3237@apollo>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 09:24:51AM +0200, Thomas Gleixner wrote:
> On Thu, 9 Oct 2008, Andi Kleen wrote:
> > It actually does. The stall detector makes the online echo return after three seconds,
> > although it's not 100% clear to me why.
> > 
> > here's the backtrace
> > 
> > RCU detected CPU 14 stall (t=4295149800/5928 jiffies)
> > Pid: 0, comm: swapper Not tainted 2.6.27-rc9 #5
> > 
> > Call Trace:
> >  <IRQ>  [<ffffffff8025d188>] __rcu_pending+0x6e/0x1d9
> >  [<ffffffff8025d329>] rcu_pending+0x36/0x6e
> >  [<ffffffff8023b480>] update_process_times+0x37/0x5b
> >  [<ffffffff8024be72>] tick_periodic+0x68/0x74
> >  [<ffffffff8024be9f>] tick_handle_periodic+0x21/0x66
> >  [<ffffffff8021bcd2>] smp_apic_timer_interrupt+0x8a/0xa8
> >  [<ffffffff8020bfe6>] apic_timer_interrupt+0x66/0x70
> >  <EOI>  [<ffffffff803adb39>] ? acpi_safe_halt+0x2b/0x3e
> >  [<ffffffff803adbfa>] ? acpi_idle_enter_c1+0xae/0x102
> >  [<ffffffff804ffdd6>] ? cpuidle_idle_call+0x70/0xa2
> >  [<ffffffff8020a097>] ? cpu_idle+0x7e/0x9c
> >  [<ffffffff805bef4a>] ? start_secondary+0x157/0x15c
> > 
> > Timer issue?
> 
> Hmm, this is periodic mode so rather unlikely, but who knows. Does
> this happen with nohz and/or highres as well ?

With nohz/highres enabled it takes much longer to trigger. Normally
it happened near always on the first try, now I had to let a loop
run for several minutes to trigger it.

But the strange thing is that the stall detector doesn't detect
the hotplugged CPUs stalling now, but other unrelated ones.
I only hotplug 14/15, but it reports 3 and 4. In periodic 
mode the correct CPUs were reported.

-Andi

Here are the backtraces


Switched to high resolution mode on CPU 14
CPU 15 is now offline
RCU detected CPU 3 stall (t=4294999688/3809 jiffies)
Pid: 0, comm: swapper Not tainted 2.6.27-rc9 #6

Call Trace:
 <IRQ>  [<ffffffff8025f474>] __rcu_pending+0x6e/0x1d9
 [<ffffffff8025f615>] rcu_pending+0x36/0x6e
 [<ffffffff8023bc5d>] update_process_times+0x37/0x5b
 [<ffffffff8024de88>] tick_sched_timer+0x81/0xb5
 [<ffffffff80247538>] __run_hrtimer+0x56/0x96
 [<ffffffff80248002>] hrtimer_interrupt+0xe6/0x14d
 [<ffffffff8021bcd2>] smp_apic_timer_interrupt+0x8a/0xa8
 [<ffffffff8020bff6>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff803b0254>] ? acpi_idle_enter_bm+0x2a2/0x312
 [<ffffffff803b024a>] ? acpi_idle_enter_bm+0x298/0x312
 [<ffffffff805020c2>] ? cpuidle_idle_call+0x70/0xa2
 [<ffffffff8020a0a1>] ? cpu_idle+0x88/0xae
 [<ffffffff805c137a>] ? start_secondary+0x157/0x15c

RCU detected CPU 3 stall (t=4295007688/1250 jiffies)
Pid: 0, comm: swapper Not tainted 2.6.27-rc9 #6

Call Trace:
 <IRQ>  [<ffffffff8025f474>] __rcu_pending+0x6e/0x1d9
 [<ffffffff8025f615>] rcu_pending+0x36/0x6e
 [<ffffffff8023bc5d>] update_process_times+0x37/0x5b
 [<ffffffff8024de88>] tick_sched_timer+0x81/0xb5
 [<ffffffff80247538>] __run_hrtimer+0x56/0x96
 [<ffffffff80248002>] hrtimer_interrupt+0xe6/0x14d
 [<ffffffff8021bcd2>] smp_apic_timer_interrupt+0x8a/0xa8
 [<ffffffff8020bff6>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff803b0254>] ? acpi_idle_enter_bm+0x2a2/0x312
 [<ffffffff803b024a>] ? acpi_idle_enter_bm+0x298/0x312
 [<ffffffff805020c2>] ? cpuidle_idle_call+0x70/0xa2
 [<ffffffff8020a0a1>] ? cpu_idle+0x88/0xae
 [<ffffffff805c137a>] ? start_secondary+0x157/0x15c

RCU detected CPU 3 stall (t=4295012121/2548 jiffies)
Pid: 0, comm: swapper Not tainted 2.6.27-rc9 #6

Call Trace:
 <IRQ>  [<ffffffff8025f474>] __rcu_pending+0x6e/0x1d9
 [<ffffffff8025f640>] rcu_pending+0x61/0x6e
 [<ffffffff8023bc5d>] update_process_times+0x37/0x5b
 [<ffffffff8024de88>] tick_sched_timer+0x81/0xb5
 [<ffffffff80247538>] __run_hrtimer+0x56/0x96
 [<ffffffff80248002>] hrtimer_interrupt+0xe6/0x14d
 [<ffffffff8021bcd2>] smp_apic_timer_interrupt+0x8a/0xa8
 [<ffffffff8020bff6>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff803b0254>] ? acpi_idle_enter_bm+0x2a2/0x312
 [<ffffffff803b024a>] ? acpi_idle_enter_bm+0x298/0x312
 [<ffffffff805020c2>] ? cpuidle_idle_call+0x70/0xa2
 [<ffffffff8020a0a1>] ? cpu_idle+0x88/0xae
 [<ffffffff805c137a>] ? start_secondary+0x157/0x15c

RCU detected CPU 2 stall (t=4295014976/874 jiffies)
Pid: 0, comm: swapper Not tainted 2.6.27-rc9 #6

Call Trace:
 <IRQ> <3>RCU detected CPU 3 stall (t=4295014976/874 jiffies)
 [<ffffffff8025f474>] __rcu_pending+0x6e/0x1d9
 [<ffffffff8025f615>] rcu_pending+0x36/0x6e
 [<ffffffff8023bc5d>] update_process_times+0x37/0x5b
 [<ffffffff8024de88>] tick_sched_timer+0x81/0xb5
 [<ffffffff80247538>] __run_hrtimer+0x56/0x96
 [<ffffffff80248002>] hrtimer_interrupt+0xe6/0x14d
 [<ffffffff8021bcd2>] smp_apic_timer_interrupt+0x8a/0xa8
Pid: 0, comm: swapper Not tainted 2.6.27-rc9 #6

Call Trace:
 <IRQ>  [<ffffffff8020bff6>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8024e1b0>] ? tick_nohz_restart_sched_tick+0x15e/0x165
 [<ffffffff8025f474>] __rcu_pending+0x6e/0x1d9
 [<ffffffff8025f615>] rcu_pending+0x36/0x6e
 [<ffffffff8023bc5d>] update_process_times+0x37/0x5b
 [<ffffffff8024de88>] tick_sched_timer+0x81/0xb5
 [<ffffffff80247538>] __run_hrtimer+0x56/0x96
 [<ffffffff80248002>] hrtimer_interrupt+0xe6/0x14d
 [<ffffffff8021bcd2>] smp_apic_timer_interrupt+0x8a/0xa8
 [<ffffffff8020a0bd>] ? cpu_idle+0xa4/0xae
 [<ffffffff805c137a>] ? start_secondary+0x157/0x15c
 [<ffffffff8020bff6>] apic_timer_interrupt+0x66/0x70

 <EOI>  [<ffffffff803b0254>] ? acpi_idle_enter_bm+0x2a2/0x312
 [<ffffffff803b024a>] ? acpi_idle_enter_bm+0x298/0x312
 [<ffffffff805020c2>] ? cpuidle_idle_call+0x70/0xa2
 [<ffffffff8020a0a1>] ? cpu_idle+0x88/0xae
 [<ffffffff805c137a>] ? start_secondary+0x157/0x15c

RCU detected CPU 4 stall (t=4295019871/4894 jiffies)
Pid: 0, comm: swapper Not tainted 2.6.27-rc9 #6

Call Trace:
 <IRQ>  [<ffffffff8025f474>] __rcu_pending+0x6e/0x1d9
 [<ffffffff8025f615>] rcu_pending+0x36/0x6e
 [<ffffffff8023bc5d>] update_process_times+0x37/0x5b
 [<ffffffff8024de88>] tick_sched_timer+0x81/0xb5
 [<ffffffff80247538>] __run_hrtimer+0x56/0x96
RCU detected CPU 6 stall (t=4295019871/4894 jiffies)
Pid: 0, comm: swapper Not tainted 2.6.27-rc9 #6

Call Trace:
 <IRQ>  [<ffffffff8025f474>] __rcu_pending+0x6e/0x1d9
 [<ffffffff80248002>] hrtimer_interrupt+0xe6/0x14d
 [<ffffffff8021bcd2>] smp_apic_timer_interrupt+0x8a/0xa8
 [<ffffffff8020bff6>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff803b0254>] ? acpi_idle_enter_bm+0x2a2/0x312
 [<ffffffff8025f615>] rcu_pending+0x36/0x6e
 [<ffffffff8023bc5d>] update_process_times+0x37/0x5b
 [<ffffffff8024de88>] tick_sched_timer+0x81/0xb5
 [<ffffffff80247538>] __run_hrtimer+0x56/0x96
 [<ffffffff80248002>] hrtimer_interrupt+0xe6/0x14d
 [<ffffffff8021bcd2>] smp_apic_timer_interrupt+0x8a/0xa8
 [<ffffffff8020bff6>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8024e1b0>] ? tick_nohz_restart_sched_tick+0x15e/0x165
 [<ffffffff803b024a>] ? acpi_idle_enter_bm+0x298/0x312
 [<ffffffff805020c2>] ? cpuidle_idle_call+0x70/0xa2
 [<ffffffff8020a0a1>] ? cpu_idle+0x88/0xae
 [<ffffffff805c137a>] ? start_secondary+0x157/0x15c

 [<ffffffff8020a0bd>] ? cpu_idle+0xa4/0xae
 [<ffffffff805c137a>] ? start_secondary+0x157/0x15c


-- 
ak@linux.intel.com
