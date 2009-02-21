Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbZBUJbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbZBUJbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 04:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZBUJbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 04:31:06 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:61465 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZBUJbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 04:31:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MkJWLqiGvrbUt0B5LzyGY/5E+GqV7Yf2GFix7fJBBCl+dniorV/5mfHiIzHs0J5kPS
         n/5+Ie9Njg+0Trq3XUh64HYwtPc5teInz3ONxjSXifnSU4sdaid1OcOBuvv1HPEefEBJ
         5ed1pw/DWY5Ruu8C2fQHlzRBmnCQFLoEk5s08=
MIME-Version: 1.0
In-Reply-To: <20090221014056.GU6960@linux.vnet.ibm.com>
References: <20090220134121.GA19575@damson.getinternet.no>
	 <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu>
	 <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com>
	 <20090220154619.GC6960@linux.vnet.ibm.com>
	 <19f34abd0902201551o65a3650egf29d81e8b6823d67@mail.gmail.com>
	 <20090221014056.GU6960@linux.vnet.ibm.com>
Date: Sat, 21 Feb 2009 10:30:58 +0100
Message-ID: <19f34abd0902210130p62fba6d0n906b321949409578@mail.gmail.com>
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
From: Vegard Nossum <vegard.nossum@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/21 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> This is 4.1 milliseconds, so is quite plausible.  Is the code -really-
> disabling preemption for 4.1 milliseconds?
>
>> [  449.677407] __free_vmap_area(c7806ac0)
>> [  449.680113] rcu_free_va(c7806a80)
>
> 5.4 milliseconds...
>
>> [  449.682821] __free_vmap_area(c7806b00)
>> [  449.684264] rcu_free_va(c7806ac0)
>
> 6.9 milliseconds...
>
>> [  449.686525] __free_vmap_area(c7806b40)
>> [  449.688205] rcu_free_va(c7806b00)
>
> 5.4 milliseconds...
>
>> ...and goes on for a long time, until something triggers this:
>>
>> [  449.902253] rcu_free_va(c7839d00)
>> [  449.903247] WARNING: kmemcheck: Caught 32-bit read from freed
>> memory (c7839d20)
>>
>> ...and finally:
>>
>> [  457.580253] __purge_vmap_area_lazy() end
>> [  457.581201] rcu_free_va(c78974c0)
>
> And I don't see the corresponding __free_vmap_area() for either of the
> above rcu_free_va() calls.  Would you be willing to forward the
> timestamp for the __free_vmap_area() for c7839d20?

I'm sorry. The numbers in paranthesis are the struct vmap_area
pointers, not the actual parameters being passed to the function. So
when we have this:

[  449.696775] __free_vmap_area(c7806c00)
[  449.697274] rcu_free_va(c7806bc0)
[  449.699543] __free_vmap_area(c7806c40)
[  449.701104] rcu_free_va(c7806c00)
[  449.703353] __free_vmap_area(c7806c80)
[  449.704247] rcu_free_va(c7806c40)

rcu_free_va(c7806c00) corresponds to rcu_free_va(c7806c00).

>
>> So this is also what I meant by "immediately": The RCU callbacks are
>> getting called inside the loop, and they're almost always paired with
>> the list removal, or lagging one object behind.
>>
>> My guess is that this code posts "too many callbacks", which would
>> "force the grace period" according to __call_rcu() in
>> kernel/rcutree.c. What do you think about this?
>
> If the code really suppresses preemption across the whole loop, then
> any attempt to force the grace period should fail.  Is it possible that
> preemption is momentarily enabled somewhere within the loop?  Or that
> we are seeing multiple passes through the loop rather than one big long
> pass through the loop?

Multiple passes? No. We have a print-out at the beginning and at the
end, and there's nothing else happening in-between. It doesn't leave
the function __purge_vmap_area_lazy. I don't see preemption being
enabled anywhere in __free_vmap_area (or its calls).

I single-stepped __free_vmap_area, and it will get interrupted. I got
(among other things) this chain of calls:

do_IRQ -> handle_irq -> handle_level_irq -> handle_IRQ_event ->
timer_interrupt -> ... -> run_local_timers -> raise_softirq (nr=1)

And at one point it also calls into RCU machinery:

update_process_times (user_tick=0) at kernel/timer.c:1033
1033            if (rcu_pending(cpu))
(gdb)
rcu_pending (cpu=0) at kernel/rcutree.c:1288
1288            return __rcu_pending(&rcu_state, &per_cpu(rcu_data, cpu)) ||
...
update_process_times (user_tick=0) at kernel/timer.c:1034
1034                    rcu_check_callbacks(cpu, user_tick);
(gdb)
rcu_check_callbacks (cpu=0, user=0) at kernel/rcutree.c:949
949     {
...
rcu_check_callbacks (cpu=0, user=-1049147360) at kernel/rcutree.c:967
967                     rcu_qsctr_inc(cpu);
(gdb)
rcu_qsctr_inc () at include/linux/rcutree.h:253
253             struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
(gdb)
255             rdp->passed_quiesc_completed = rdp->completed;
(gdb)
254             rdp->passed_quiesc = 1;
(gdb)
255             rdp->passed_quiesc_completed = rdp->completed;
(gdb)
rcu_check_callbacks (cpu=0, user=<value optimized out>) at kernel/rcutree.c:979
979                     rcu_bh_qsctr_inc(cpu);
(gdb)
rcu_bh_qsctr_inc () at include/linux/rcutree.h:259
259             struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
(gdb)
261             rdp->passed_quiesc_completed = rdp->completed;
(gdb)
260             rdp->passed_quiesc = 1;
(gdb)
261             rdp->passed_quiesc_completed = rdp->completed;
(gdb)
rcu_check_callbacks (cpu=0, user=<value optimized out>) at kernel/rcutree.c:981
981             raise_softirq(RCU_SOFTIRQ);
(gdb)
raise_softirq (nr=8) at kernel/softirq.c:313
313     {

We also get into __rcu_check_callbacks after a while, with this stacktrace:

#0  do_IRQ (regs=0xc170ddc0) at arch/x86/kernel/irq.c:201
#1  <signal handler called>
#2  0xc1073b7a in __rcu_process_callbacks (rsp=0xc1677060, rdp=0xc1941320)
    at kernel/rcutree.c:1127
#3  0xc1073dbf in rcu_process_callbacks (unused=<value optimized out>)
    at kernel/rcutree.c:1162
#4  0xc103741f in __do_softirq () at kernel/softirq.c:198
#5  0xc10374fd in do_softirq () at kernel/softirq.c:244
#6  0xc1037655 in irq_exit () at kernel/softirq.c:281
#7  0xc100529f in do_IRQ (regs=0xc170de98) at arch/x86/kernel/irq.c:223
#8  <signal handler called>
#9  __free_vmap_area (va=0xc7803a40) at mm/vmalloc.c:411
#10 0xc1096dd9 in __purge_vmap_area_lazy (start=0xc170df10, end=0xc170df0c,
    sync=<value optimized out>, force_flush=0) at mm/vmalloc.c:542
#11 0xc1096f1e in try_purge_vmap_area_lazy () at mm/vmalloc.c:556
#12 free_unmap_vmap_area_noflush (va=<value optimized out>) at mm/vmalloc.c:578
#13 0xc1096f4a in free_unmap_vmap_area () at mm/vmalloc.c:587
#14 remove_vm_area (addr=<value optimized out>) at mm/vmalloc.c:1168
#15 0xc1097005 in __vunmap (addr=0xc7803a40, deallocate_pages=0)
    at mm/vmalloc.c:1194
#16 0xc10970be in vunmap (addr=0xc7803aa0) at mm/vmalloc.c:1253
#17 0xc1008ba5 in text_poke (addr=0xc127ba4f, opcode=0xc170df8f, len=1)
    at arch/x86/kernel/alternative.c:523
#18 0xc1008ca9 in alternatives_smp_unlock (start=<value optimized out>,
    end=0xc1713360, text=0xc1000000 "�\206\021\002", text_end=0xc150250f "")
    at arch/x86/kernel/alternative.c:252
#19 0xc171ef47 in alternative_instructions ()
    at arch/x86/kernel/alternative.c:438
#20 0xc171f991 in check_bugs () at arch/x86/kernel/cpu/bugs.c:168
#21 0xc17148c5 in start_kernel () at init/main.c:687
#22 0xc171409e in i386_start_kernel () at arch/x86/kernel/head32.c:43
#23 0x00000000 in ?? ()

(On a side note, it strikes me that __do_softirq() does
local_irq_enable(), which means that __rcu_process_callbacks() can be
interrupted and the interrupt handler can call rcu_process_callbacks()
again...)

Does this ring any bells or make any sense at all? What else can I do
to help understand what's going on?

This, by the way, happens regardless of whether kmemcheck is used or
not. The only thing I do to trigger this particular behaviour is to
run an SMP kernel on a UP machine, since it will call
alternative_instructions() like we see in the stack trace above.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
