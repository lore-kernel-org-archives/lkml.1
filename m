Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbXCFVH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbXCFVH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932273AbXCFVH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:07:59 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:60443 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932274AbXCFVH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:07:57 -0500
Message-ID: <45EDD82F.90204@vmware.com>
Date: Tue, 06 Mar 2007 13:07:59 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Zachary Amsden <zach@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       Dan Hecht <dhecht@vmware.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com> <1173178774.24738.311.camel@localhost.localdomain>
In-Reply-To: <1173178774.24738.311.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2007 21:07:55.0329 (UTC) FILETIME=[828DFB10:01C76033]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2007 02:59 AM, Thomas Gleixner wrote:
> On Tue, 2007-03-06 at 00:55 -0800, Zachary Amsden wrote:
>>> a proper CE device also has the added bonus of making high-res timers 
>>> guests work automatically. It should be simple: just pass it through to 
>>> your hypervisor, a hyper-CE-device, like a hyper-clocksource device has 
>>> essentially no guest-side complexity.
>>>   
>> It is not so simple.  In theory it works great.  In reality, the i386 
>> implementation is completely hardwired to work the way hardware works, 
>> and breaking the clockevent code out of the deep ties to the APIC is 
>> extremely non-trivial.  We tried, and could not accomplish it for 2.6.21 
>> because the hrtimers integration was complex, and introduced many bugs 
>> for us.
> 
> Why is this so non-trivial ? All you have to do is _NOT_ register
> PIT/HPET/APIC timers and register a per CPU hyper-CE-device instead,
> which uses the hypervisor timer emulation instead of real hardware.
> 
> clockevents breaks the hardwired assumptions of the old timer code and
> allows you to remove _ALL_ the hardwired hackery in vmitimer.c, i.e.
> stuff like
> 
>        /* Disable PIT. */
>         outb_p(0x3a, PIT_MODE); /* binary, mode 5, LSB/MSB, ch 0 */
> 

Hmm, I think that the (virtual) bios still will set up the PIT ch 0, and 
we still need to stop it.

In any case, clockevents doesn't really make it easier nor harder as far 
as init goes.  In the pre-clockevent days, we replace setup_pit_timer, 
setup_boot_clock, setup_secondary_clock.  With clockevents, I think the 
hook points are the same.  Mostly just need to allow the per-cpu 
lapic_event to be generalized to local_clock_events that can be set to 
whatever device we want.  The other thing on i386 is just some minor 
annoyances due initially setting up only the PIT on cpu0 on irq 0 and 
then later setting up per-cpu timer on lvtt, and making this all place 
nice with paravirt timers.  But these are just details and just require 
some minor changes and will be working, but it just takes some massaging.

So, that is not the real reason to move over the clockevents.  The real 
reason is to use the generic interrupt handlers.  We understand that, 
and will get to that point.  In the mean time, we are harming no one. 
Our code has zero effect when you booting natively or on a non-VMI 
hypervisor.

>> We worked around this by keeping NO_IDLE_HZ support, which now 
>> you deprecated.  So now we are using NO_HZ without a hyper-CE device, 
>> and it is working fine.  We understand the benefits of moving to the CE 
>> model - but it cannot be done overnight.
> 
> This is ugly as hell. NO_HZ enables the dyntick functions in idle(),
> irq_enter() and irq_exit() so the clockevents code is actually invoked.
> I have not looked close enough why this does work at all.
> 

I believe this was just a quick fix in response to Ingo breaking the VMI 
build yesterday by disabling NO_IDLE_HZ on us.  There is no technical 
reason why NO_IDLE_HZ=y can't coexist with NO_HZ.

(The two work okay together because when using NO_IDLE_HZ, the hooks are 
deeper in a custom safe_halt routine which isn't registered when using 
nohz mode at runtime, and conversely, the nohz code is guarded at 
runtime by the ts->nohz_mode.  So, the two really can co-exist at 
compile time).

Again, no one is arguing that we shouldn't move to clockevents, it's 
just a matter of time (sorry, no pun intended).

The vmi-time code was introduced to solve some shortcomings of the old 
(pre-clocksource/clockevents/hrtimer/NO_HZ) i386 timer code that was 
especially painful for virtualization.  Certainly, 
clocksource/clockevents/NO_HZ solves many of the problems (basically, 
moving away from counting interrupts to using time sources).  e.g. xtime 
updating is no longer a worry with the new timeofday/clocksource stuff. 
  But there are some that may not quite be solved, listed below.  (I 
know I'm not telling you anything new, but I might as well flesh it out 
for the other paravirt folks while the code is fresh in my mind):

1) Stolen time (virtual cpu is ready to run but not running): this is 
handled inconsistently between the various clockevent handlers / 
CLOCK_EVT_MODE_ONESHOT combinations:

  a) tick_handle_periodic / CLOCK_EVT_MODE_PERIODIC: depends on how you 
define "periodic" timer in a paravirtual world.  If you do something 
like Xen-style where you send periodic events only to running vcpus, 
then this handler suffers from some of the same problems as the old i386 
timer handler:
   - jiffies updated according to the number of interrupts you get, so 
falls behind monotonic time.  generally, counting timer interrupts is 
bad for paravirt.
   - process time updated according to the number of interrupts, so 
falls behind monotonic time.  This is probably okay though, since it is 
essentially tracking (mono - stolen) time.  I.e. the missing time is stolen.
   - jiffies updated only by boot cpu, which is a problem for paravirt 
since the boot vcpu can be descheduled while the other vcpus are scheduled.
   - can probably just avoid this mode by not advertising PERIODIC 
capability by your clockevent device.

  b) tick_handle_periodic / CLOCK_EVT_MODE_ONESHOT:
   - jiffies updated according to monotonic time since we'll loop to 
catch up the oneshot timer.
   - process time accounted in monotonic time, for the same reason. 
this is probably not what we'd want since it will charge time to 
whatever process happened to be scheduled in the guest during periods of 
stolen time.
   - Same problem about jiffies only updated by one vcpu.

  c) tick_nohz_handler (implies CLOCK_EVT_MODE_ONESHOT):
   - jiffies updated according to monotonic time. this is good.
   - Process time effectively does not count stolen time since 
update_process_times is called once per callback but oneshot expiry is 
advanced into the future.  This is probably the right thing for 
paravirt, but, inconsistent with (b).
   - jiffies updated by all vcpus, which is good.

  d) hrtimer_interrupt (really tick_sched_timer):
   - w.r.t. stolen time, will be similar to (c).  We'll advance the 
sched_timer to the next period in the future, skipping stolen time for 
process accounting.
   - jiffies will be kept up to date with monotonic time.
   - jiffies updated by all vcpus, which is good.

Summary: Cases (c) and (d) should be relatively well behaved for 
paravirt.  So, if we can depend on NO_HZ=y and not being disabled at 
runtime, we should be okay.  We may want to have some knowledge of 
stolen time passed from the hypervisor (if we wanted more accurate 
process time accounting), but this can be put back in later, and isn't 
too important with sample based accounting system like Linux. But, we 
still need to QA all four cases, and all four cases will likely expose 
different bugs due to second order effects.

2) Virtual interrupts have a relatively high overhead as compared with 
native interrupts.  So, in vmitime, we wanted to be able to lower the 
timer interrupt rate at runtime, even if HZ is a compile time constant 
(and set to something high, like 1000hz).  While we could hack this in 
by using evt->min_delta_ns, it wouldn't really work since process time 
accounting would be wrong.  Instead, we should allow the 
tick_sched_timer in cases (c) and (d) to have runtime configurable 
period, and then scale the time value accordingly before passing to 
account_system_time.  This is probably something the Xen folks will want 
also, since I think Xen itself only gets 100hz hard timer, and so it can 
implement at best a oneshot virtual timer with 100hz resolution.  Any 
objections to us doing something like this?

3) clockevent set_next_event interface is suboptimal for paravirt (and 
probably realtime-ish uses).  The problem is that the expiry is passed 
as a relative time.  On paravirt, an arbitrary amount of (stolen) time 
may have passed since the delta was computed and when the timer device 
is programmed, causing that next interrupt to be too far out in the 
future.  It seems a better interface for set_next_event would be to pass 
the current time and the absolute expiry.  Actually, I sent email to 
Thomas and Ingo about this (and some other clockevents/hrtimer feedback) 
in July 2006, but never heard back.  Thoughts?

I think all the other important points that the vmitime code addressed 
are also addressed by clocksource/clockevents/NO_HZ.

Finally, while I agree that writing the clockevent callback code is 
trivial, we will hit bugs when moving over.  It is something we need to 
do, but just takes some time for us to test and shake out the bugs.  For 
example, we are seeing this bug.  It seems to me that tick_sched_timer 
should not be running in softirq context, but only from the 
hrtimer_interrupt.  Is that right?  I'm not sure how we get into this case.

Switched to high resolution mode on CPU 0
------------[ cut here ]------------
kernel BUG at 
/dhecht/linux/testing/torvalds/linux-2.6.21/kernel/posix-cpu-timers.c:1295!
invalid opcode: 0000 [#1]
SMP
Modules linked in:
CPU:    0
EIP:    0062:[<c0137801>]    Not tainted VLI
EFLAGS: 00010202   (2.6.21-rc2-smp #29)
EIP is at run_posix_cpu_timers+0x24/0x6a7
eax: 00000200   ebx: c1405be0   ecx: c1405102   edx: c14051d4
esi: c1405ca0   edi: 77ad5c64   ebp: dfed5a50   esp: dfe81db4
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 006a
Process swapper (pid: 1, ti=dfe80000 task=dfed5a50 task.ti=dfe80000)
Stack: 00000078 c039e760 0000007d c010a885 28f8c4ec 00000000 dfed5a50 
c14051c0
        dfe81df8 c0122ac3 c14051cc 00000003 00000008 c14051d4 dfed5a50 
00000000
        dfe81df4 dfe81df4 c1405be0 c1405ca0 77ad5c64 00000000 c013cd3a 
c1405c18
Call Trace:
  [<c010a885>] sched_clock+0x3d/0x69
  [<c0122ac3>] scheduler_tick+0x52/0xc9
  [<c013cd3a>] tick_sched_timer+0x57/0x9d
  [<c013cce3>] tick_sched_timer+0x0/0x9d
  [<c013936a>] hrtimer_run_queues+0x1c3/0x21d
  [<c012d69b>] run_timer_softirq+0x21/0x177
  [<c012a0bd>] __do_softirq+0x66/0xca
  [<c012a164>] do_softirq+0x43/0x51
  [<c012a26b>] irq_exit+0x38/0x6b
  [<c0107ab5>] do_IRQ+0x82/0x99
  [<c025cf44>] serial8250_console_write+0x129/0x136
  [<c025ec10>] serial8250_console_putchar+0x0/0x78
  [<c0105d13>] common_interrupt+0x23/0x30
  [<c01267f9>] vprintk+0x29b/0x2ca
  [<c02056a8>] idr_get_new_above_int+0x13c/0x216
  [<c0126843>] printk+0x1b/0x1f
  [<c03ebf31>] audit_init+0x26/0x101
  [<c03ebe7e>] ikconfig_init+0x14/0x37
  [<c03da92d>] init+0x145/0x23e
  [<c0104c06>] ret_from_fork+0x6/0x20
  [<c0104d69>] syscall_exit+0x5/0x18
  [<c03da7e8>] init+0x0/0x23e
  [<c03da7e8>] init+0x0/0x23e
  [<c0105fe7>] kernel_thread_helper+0x7/0x10
  =======================
Code: e9 b0 fe ff ff 5b c3 55 57 56 53 83 ec 48 89 c5 8d 44 24 40 89 44 
24 40 89 44 24 44 e8 19 9a ec 3b 90 8d 74 26 00 f6 c4 02 74 04 <0f> 0b 
eb fe 8b 95 24 01 00 00 85 d2 74 10 8b 85 08 01 00 00 03
EIP: [<c0137801>] run_posix_cpu_timers+0x24/0x6a7 SS:ESP 006a:dfe81db4
Kernel panic - not syncing: Fatal exception in interrupt


thanks,
Dan
