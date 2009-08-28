Return-Path: <linux-kernel-owner+w=401wt.eu-S1751504AbZH1Cqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbZH1Cqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 22:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZH1Cqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 22:46:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:54378 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbZH1Cqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 22:46:45 -0400
Message-ID: <4A9744F4.7010208@kernel.org>
Date: Fri, 28 Aug 2009 11:46:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] lockup with the latest kernel
References: <alpine.DEB.2.00.0908191134260.12663@gandalf.stny.rr.com> <alpine.DEB.2.00.0908271836140.26718@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908271836140.26718@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 02:46:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Steven Rostedt.

Steven Rostedt wrote:
> commit 02cf94c370e0dc9bf408fe45eb86fe9ad58eaf7f
> Author: Tejun Heo <tj@kernel.org>
> Date:   Wed Jan 21 17:26:06 2009 +0900
> 
>     x86: make x86_32 use tlb_64.c
>     
>     Impact: less contention when issuing invalidate IPI, cleanup
>     
>     Make x86_32 use the same tlb code as 64bit.  The 64bit code uses
>     multiple IPI vectors for tlb shootdown to reduce contention.  This
>     patch makes x86_32 allocate the same 8 IPIs as x86_64 and share the
>     code paths.
>     
>     Note that the usage of asmlinkage is inconsistent for x86_32 and 64
>     and calls for further cleanup.  This has been noted with a FIXME
>     comment in tlb_64.c.
>     
>     Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> I can easily hit this bug at this commit, but I ran for a week on the 
> commit before it. Thus I'm assuming this is the bug (but I'm not 100% 
> sure).

Drat, why does it have to be mine?  ;-)

Joke aside, thank you very much for bisecting it.

...
>> [13288.222084] EIP: 0060:[<c0110821>] EFLAGS: 00000002 CPU: 0
>> [13288.222084] EIP is at default_send_IPI_mask_logical+0x53/0x92
>> [13288.222084] EAX: fffff000 EBX: 000000fd ECX: c042cccc EDX: 00000800
>> [13288.222084] ESI: 00000002 EDI: 00000086 EBP: f7065f10 ESP: f7065f00
>> [13288.222084]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> [13288.222084] Process migration/0 (pid: 3, ti=f7064000 task=f705f0c0 
>> task.ti=f7064000)
>> [13288.222084] Stack:
>> [13288.222084]  c0350550 0000007e efbfea20 c1819c60 f7065f18 c010f1fa 
>> f7065f24 c011b69c
>> [13288.222084]  c0350490 f7065f2c c011b70b f7065f5c c01213d3 00000000 
>> 00000000 00000001
>> [13288.222084]  00000000 00000001 00000000 00000092 c5685f08 c5685f44 
>> 00000003 f7065f64
>> [13288.222084] Call Trace:
>> [13288.222084]  [<c010f1fa>] ? native_smp_send_reschedule+0x44/0x46
>> [13288.222084]  [<c011b69c>] ? resched_task+0x5f/0x62
>> [13288.222084]  [<c011b70b>] ? check_preempt_curr_idle+0x13/0x15
>> [13288.222084]  [<c01213d3>] ? try_to_wake_up+0x1f4/0x228
>> [13288.222084]  [<c0121417>] ? default_wake_function+0x10/0x12
>> [13288.222084]  [<c011a22f>] ? __wake_up_common+0x39/0x61
>> [13288.222084]  [<c011b7da>] ? complete+0x30/0x43
>> [13288.222084]  [<c0123eaa>] ? migration_thread+0x19d/0x1db
>> [13288.222084]  [<c0123d0d>] ? migration_thread+0x0/0x1db
>> [13288.222084]  [<c0137411>] ? kthread+0x4b/0x6f
>> [13288.222084]  [<c01373c6>] ? kthread+0x0/0x6f
>> [13288.222084]  [<c01033cf>] ? kernel_thread_helper+0x7/0x10
>> [13288.222084] Code: eb 27 3b c0 e8 56 62 01 00 a1 88 cd 42 c0 83 fb 02 8b 
>> 50 20 75 10 89 55 f0 ff 90 b8 00 00 00 8b 55 f0 eb 12 f3 90 a1 f4 f8 42 c0 
>> <8b> 80 00 c3 ff ff f6 c4 10 75 ee a1 f4 f8 42 c0 c1 e6 18 2d f0 

   0:   eb 27                   jmp    29 <a+0x29>
   2:   3b c0                   cmp    %eax,%eax
   4:   e8 56 62 01 00          call   1625f <a+0x1625f>
   9:   a1 88 cd 42 c0          mov    0xc042cd88,%eax
   e:   83 fb 02                cmp    $0x2,%ebx
  11:   8b 50 20                mov    0x20(%eax),%edx
  14:   75 10                   jne    26 <a+0x26>
  16:   89 55 f0                mov    %edx,-0x10(%ebp)
  19:   ff 90 b8 00 00 00       call   *0xb8(%eax)
  1f:   8b 55 f0                mov    -0x10(%ebp),%edx
  22:   eb 12                   jmp    36 <a+0x36>
  24:   f3 90                   pause
  26:   a1 f4 f8 42 c0          mov    0xc042f8f4,%eax
  2b:   8b 80 00 c3 ff ff       mov    -0x3d00(%eax),%eax
  31:   f6 c4 10                test   $0x10,%ah
  34:   75 ee                   jne    24 <a+0x24>
  36:   a1 f4 f8 42 c0          mov    0xc042f8f4,%eax
  3b:   c1 e6 18                shl    $0x18,%esi
  3e:   2d                      .byte 0x2d
  3f:   f0                      lock

This is from __default_send_IPI_dest_field() which calls
__xapic_wait_icr_idle() which busy waits for APIC_ICR_BUSY bit to go
off.  The f3 90 is REP; NOP; which is cpu_relax().  The 8b is loading
the apic register to test for the bit.

>> [13288.222093] Pid: 0, comm: swapper Tainted: G      D    (2.6.30-rc6 #3) 
>> Unknown
>> [13288.222093] EIP: 0060:[<c03492d5>] EFLAGS: 00000097 CPU: 1
>> [13288.222093] EIP is at _spin_lock_irq+0x19/0x1f
>> [13288.222093] EAX: c1819c60 EBX: c1819c60 ECX: f708f6b0 EDX: 00007e7d
>> [13288.222093] ESI: c04bfc60 EDI: c04bcd18 EBP: f7093f18 ESP: f7093f18
>> [13288.222093]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> [13288.222093] Process swapper (pid: 0, ti=f7092000 task=f708f500 
>> task.ti=f7092000)
>> [13288.222093] Stack:
>> [13288.222093]  f7093f8c c0347415 f7093f28 c012b204 f708f6b0 c01100ba 
>> c04bcd18 c04bfc60
>> [13288.222093]  f708f6b4 c1816488 00000000 00000001 00000000 f7093f94 
>> f7092000 0000007b
>> [13288.222093]  f708f500 000000d8 00000000 c0468e60 00000001 c1816f8c 
>> f7093f94 c01424e4
>> [13288.222093] Call Trace:
>> [13288.222093]  [<c0347415>] ? __schedule+0xc8/0x855
>> [13288.222093]  [<c012b204>] ? irq_exit+0x39/0x5c
>> [13288.222093]  [<c01100ba>] ? smp_error_interrupt+0x61/0x63
>> [13288.222093]  [<c01424e4>] ? tick_nohz_restart_sched_tick+0x2c/0x139
>> [13288.222093]  [<c0347baf>] ? schedule+0xd/0x1c
>> [13288.222093]  [<c0101c5d>] ? cpu_idle+0x60/0x63
>> [13288.222093]  [<c0344d11>] ? start_secondary+0x195/0x19a
>> [13288.222093] Code: 66 0f c1 10 38 f2 74 06 f3 90 8a 10 eb f6 89 c8 5d c3 
>> 55 89 e5 0f 1f 44 00 00 fa ba 00 01 00 00 f0 66 0f c1 10 38 f2 74 06 f3 90 
>> <8a> 10 eb f6 5d c3 55 89 e5 0f 1f 44 00 00 9c 5a fa f0 83 28 01 
>> [13288.222093] ---[ end trace 94cd80322ca2a919 ]---

This one is in the same wait loop but it's calculating the address of
the apic register to load.

>> [45012.674548] Pid: 0, comm: swapper Not tainted (2.6.31-rc6 #9) Unknown
>> [45012.674548] EIP: 0060:[<c1267059>] EFLAGS: 00000097 CPU: 1
>> [45012.674548] EIP is at _spin_lock_irq+0x15/0x1f
>> [45012.674548] EAX: c1c9a200 EBX: c1c9a200 ECX: f708f550 EDX: 0000a7a6
>> [45012.674548] ESI: 00000001 EDI: f708f708 EBP: f7093f1c ESP: f7093f1c
>> [45012.674548]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> [45012.674548] Process swapper (pid: 0, ti=f7092000 task=f708f550 
>> task.ti=f7092000)
>> [45012.674548] Stack:
>> [45012.674548]  f7093f94 c1265404 c1032f33 f7093f30 c13f0200 f708f704 
>> c10032e6 c13ec1f4
>> [45012.674548] <0> f708f708 c13f0200 00000001 00000000 f7093f94 f7092000 
>> 00000001 0000007b
>> [45012.674548] <0> 000000d8 f708f550 c1395288 00000001 c1c9648c f7093f94 
>> c104babe f7092000
>> [45012.674548] Call Trace:
>> [45012.674548]  [<c1265404>] ? schedule+0xca/0x86c
>> [45012.674548]  [<c1032f33>] ? irq_exit+0x39/0x5c
>> [45012.674548]  [<c10032e6>] ? error_interrupt+0x2a/0x30
>> [45012.674548]  [<c104babe>] ? tick_nohz_restart_sched_tick+0x2c/0x139
>> [45012.674548]  [<c1001c15>] ? cpu_idle+0x60/0x63
>> [45012.674548]  [<c1262bc7>] ? start_secondary+0x195/0x19a
>> [45012.674548] Code: 01 00 00 f0 66 0f c1 10 38 f2 74 06 f3 90 8a 10 eb f6 
>> 89 c8 c9 c3 55 89 e5 0f 1f 44 00 00 fa ba 00 01 00 00 f0 66 0f c1 10 38 f2 
>> <74> 06 f3 90 8a 10 eb f6 c9 c3 55 89 e5 0f 1f 44 00 00 9c 5a fa 

This is cpu1 waiting for cpu0 to release spin_lock_irq() which is
shown below.

>> [45012.674548] ---[ end trace 7323d2c20b35b0b0 ]---
>> [45012.678548] BUG: NMI Watchdog detected LOCKUP on CPU0, ip c1013ff8, 
>> [45012.678548] EIP: 0060:[<c1013ff8>] EFLAGS: 00000002 CPU: 0
>> [45012.678548] EIP is at default_send_IPI_mask_logical+0x5c/0x90
>> [45012.678548] EAX: 000018f0 EBX: 00000082 ECX: c1356b5c EDX: 00000800
>> [45012.678548] ESI: 000000fd EDI: 00000002 EBP: ceaf7e18 ESP: ceaf7e08
>> [45012.678548]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> [45012.678548] Process backup2l (pid: 9294, ti=ceaf6000 task=db276eb0 
>> task.ti=ceaf6000)
>> [45012.678548] Stack:
>> [45012.678548]  c126fcc8 000000a7 db13e9c0 c1c9a200 ceaf7e20 c10127ce 
>> ceaf7e2c c1020ebf
>> [45012.678548] <0> c126fc08 ceaf7e34 c1020f2e ceaf7e64 c1029d20 00000000 
>> 00000000 00000001
>> [45012.678548] <0> 00000001 00000001 00000000 00000086 ce995e40 e1cee7f8 
>> 00000001 ceaf7e6c
>> [45012.678548] Call Trace:
>> [45012.678548]  [<c10127ce>] ? native_smp_send_reschedule+0x44/0x46
>> [45012.678548]  [<c1020ebf>] ? resched_task+0x5f/0x62
>> [45012.678548]  [<c1020f2e>] ? check_preempt_curr_idle+0x13/0x15
>> [45012.678548]  [<c1029d20>] ? try_to_wake_up+0x1f7/0x22b
>> [45012.678548]  [<c1029d64>] ? default_wake_function+0x10/0x12
>> [45012.678548]  [<c1040645>] ? autoremove_wake_function+0x14/0x34
>> [45012.678548]  [<c101e110>] ? __wake_up_common+0x39/0x61
>> [45012.678548]  [<c1021048>] ? __wake_up_sync_key+0x38/0x4a
>> [45012.678548]  [<c1021069>] ? __wake_up_sync+0xf/0x12
>> [45012.678548]  [<c10b0fd8>] ? pipe_release+0x5e/0x92
>> [45012.678548]  [<c10b103c>] ? pipe_write_release+0x14/0x16
>> [45012.678548]  [<c10ac42e>] ? __fput+0xcf/0x177
>> [45012.678548]  [<c10ac4f0>] ? fput+0x1a/0x1c
>> [45012.678548]  [<c10a982d>] ? filp_close+0x56/0x60
>> [45012.678548]  [<c102f56b>] ? put_files_struct+0x5d/0xa1
>> [45012.678548]  [<c102f5ea>] ? exit_files+0x3b/0x40
>> [45012.678548]  [<c1030ca5>] ? do_exit+0x1ae/0x5b3
>> [45012.678548]  [<c103110c>] ? do_group_exit+0x62/0x89
>> [45012.678548]  [<c103114b>] ? sys_exit_group+0x18/0x1c
>> [45012.678548]  [<c1002944>] ? sysenter_do_call+0x12/0x22
>> [45012.678548] Code: a1 18 6c 35 c1 83 fe 02 8b 50 20 75 10 89 55 f0 ff 90 
>> b8 00 00 00 8b 55 f0 eb 12 f3 90 a1 d4 97 35 c1 8b 80 00 c3 ff ff f6 c4 10 
>> <75> ee a1 d4 97 35 c1 c1 e7 18 2d f0 3c 00 00 89 38 89 f0 09 d0 

The same loop but yet different instruction.  It's about to jump back
to cpu_relax().

>> Always happens where one CPU is sending an IPI and the other has the rq 
>> spinlock. Seems to be that the IPI expects the other CPU to not have 
>> interrupts disabled or something?

I'm not too familiar with apics but AFAIK sending IPI isn't an
interlocked operation (not at least at the software level) so I doubt
it has much to do with the other cpu doing or not doing anything.  It
looks like the local apic is stuck hardware-wise.  The only thing the
commit changes is that cpu1 would be using vector 0xf1 instead of 0xf0
together with cpu0.

(reading the doc...) Okay, here's something interesting.  It's from
section 9.8.4 of intel doc 253668.pdf - Intel 64 and IA-32
Architectures Software Developer's Manual Volume 3A: System
Programming Guide, Part 1.

 For the P6 family and Pentium processors, the IRR and ISR registers
 can queue no more than two interrupts per priority level, and will
 reject other interrupts that are received within the same priority
 level.

And from AMD's 24593 - AMD64 Architecture Programmer's Manual Volume
2: System Programming, section 16.6.3.

 No more than two interrupts can be pending for the same interrupt
 vector number. Subsequent interrupt requests to the same interrupt
 vector number will be rejected. See Figure 16-23 on page 445.

We're using the highest single interrupt priority level which starts
at 0xf0 for all IPIs.  This means that upto the ppro on intel and all
AMD processors can deadlock via the apic bus in the following
scenario.

 cpu0					cpu1

					local_irq_disable()
 spin_lock_irqsave(A) and succeeds
					spin_lock_irqsave(A) and waits

					receives 0xf0-ff intr A, accepts

					receives 0xf0-ff intr B, accepts

 sends IPI C
            				receives IPI C, ISR/IRR full, rejects

 processor continues, apic keeps
 retrying IPI C				
					keeps rejecting IPI C
 processor tries to send IPI C again	...
 but APIC_ICR_BUSY never clears.        ...

I don't know why the specific commit triggered this behavior because
it doesn't use more ISR/IRR slots.  It's just using different vectors
in different directions.  The processor either is somehow ending up
sending the invalidate ipi to itself too thus using an extra ISR/IRR
slot or it's the changes in timing which somehow allows the cpu to
accumulate two pending irqs in the highest priority group.  It would
be interesting to print out ISR/IRR while the machine hung from the
NMI handler.

All in all, this resource deadlock involving apic while is cool
definitely is worrying as it looks like it can affect recent amd
processors.  If the analysis is correct, one solution would be
distributing IPI vectors across multiple priority levels.

More ideas?

Thanks.

-- 
tejun
