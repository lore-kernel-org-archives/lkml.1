Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab0BXQBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 11:01:36 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42885 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab0BXQBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 11:01:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=who2ldKsIT4hQdhVqB67VmwGp2TVqgYf6trF8tg7ekpArOAElK+VrsYKdjsphLiYbS
         9ygvSrM86pDiy/YyAN7fEo8AFzJp2Xm9gGYl6cUV8Z2hZOo1AGBUFaKn7AB9Gq+W7uDN
         NYHSp1paeBCxl3wuqivvmte6BBELrjmy/pfQs=
MIME-Version: 1.0
In-Reply-To: <20100223155217.GA7210@Krystal>
References: <alpine.LFD.2.00.1002161727570.2811@localhost.localdomain>
	 <alpine.LFD.2.00.1002161757050.2811@localhost.localdomain>
	 <20100216170540.GA28039@Krystal>
	 <f5a7b3811002170236i6c560eadp2de7deb10082db4f@mail.gmail.com>
	 <20100217230854.GA25636@Krystal>
	 <f5a7b3811002220737r502e75c1w5ab5a64b6cc27b68@mail.gmail.com>
	 <f5a7b3811002230329w64cabac9lff95a40cb5e7dfa5@mail.gmail.com>
	 <20100223123016.GA12857@Krystal>
	 <f5a7b3811002230735p2eb90904l33e8090ade66fc14@mail.gmail.com>
	 <20100223155217.GA7210@Krystal>
Date: Wed, 24 Feb 2010 21:31:32 +0530
Message-ID: <f5a7b3811002240801q2f3022cdjbc5020059b9e650f@mail.gmail.com>
Subject: Re: LTTng 0.193 fixes RT kernel support
From: naresh kamboju <naresh.kernel@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 9:22 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> * naresh kamboju (naresh.kernel@gmail.com) wrote:
>> On Tue, Feb 23, 2010 at 6:00 PM, Mathieu Desnoyers
>> >>
>> >> with out this patch on SMP reported the previous bug as BUG: sleeping
>> >> function called from invalid context at kernel/rtmutex.c:685
>> >>
>> >> However, i'll investigate.
>> >
>> > Hrm, we should turn the arch/{arm/mach-omap2,x86/kernel}/trace-clock.c:
>> > trace_clock_lock into a mutex, and kernel/trace/trace-clock-32-to-64.c:
>> > synthetic_tsc_lock into a mutex too.
>>
>> I have modified kernel/trace/trace-clock-32-to-64.c spin_lock to
>> mutex_lock to all the calls
>>
>> -static DEFINE_SPINLOCK(synthetic_tsc_lock);
>> +static DEFINE_MUTEX(synthetic_tsc_lock);
>>
>> -       spin_lock(&synthetic_tsc_lock);
>> +       mutex_lock(&synthetic_tsc_lock);
>>
>> for arch/{arm/mach-omap2/kernel}/trace-clock.c is already modified as
>> above from the patch
>> omap-trace-clock-fix-mutex.patch
>> from LTTng patches 02-Feb-2009.
>> this patch was prepared by you to fix
>> BUG: sleeping function called from invalid context at kernel/mutex.c:207.
>>
>> Still reporting same bug at my end :-(
>>
>> let me try in all possible ways.
>
Hi Mathieu,

> Please note that at the end of 2009, I moved the ARM LTTng omap trace clock to a
> neater per-cpu design.
yes.
i'll review per-cpu related patch and investigating.
> So it's possible that the old implementation you use has
> problems with the mutex. This could be fixed with the newer implementation.

currently i am using lttng-0.158 version patches of course these are OCT-2009.
now i'll check the with latest LTTng version patches and changes made
in latest repo.

>
> If you can tell us more about the BUG you get with the mutex-based synthetic tsc
> (what the callers are) I could tell you if this problem really goes away in
> newer version.

As I said previously, i was able to fix this BUG on ARM-UP kernels
after your fix patches :-)
currently checking the what could the issue making BUG on ARM-SMP,
doing workarounds on what are the function calls are differing in the
context of smp call which are making delay in spin locks and how the
lttng will lookafter timing issues w.r.t to RT kernels when i execute
lttng test cases.

If you have any inputs regarding lttng vs timers n locking, please welcome :-)

FYI
of course,  it would be difficult to have same env to reproduce this
BUG at your end just want to share my analysis report.

generic_smp_call_function_single_interrupt ---------- kernel/smp.c
|
\/
disable_synthetic_tsc_ip ----------------------------------
kernel/trace/trace-clock-32-to-64.c
|
\/
del_timer ------------------------------------------------- kernel/timer.c
|
\/
lock_timer_base ---------------------------------------  kernel/timer.c
|
\/
rt_spin_lock --------------------------------kernel/rtmutex.c
 |
\/
__might_sleep ------------------------ kernel/sched.c


BUG: sleeping function called from invalid context at kernel/rtmutex.c:685
in_atomic(): 1, irqs_disabled(): 128, pid: 720, name: lttd
Backtrace:
[<c002d434>] (dump_backtrace+0x0/0x10c) from [<c03a75d8>] (dump_stack+0x18/0x1c)
 r7:000002ad r6:c045da78 r5:00001116 r4:c04ba400
[<c03a75c0>] (dump_stack+0x0/0x1c) from [<c0041028>] (__might_sleep+0x120/0x14c)
[<c0040f08>] (__might_sleep+0x0/0x14c) from [<c03a9b18>]
(rt_spin_lock+0x38/0x68)
 r7:ce319d04 r6:c0763660 r5:c05107a0 r4:c05107a0
[<c03a9ae0>] (rt_spin_lock+0x0/0x68) from [<c00570b0>]
(lock_timer_base+0x30/0x54)
 r4:c05107a0
[<c0057080>] (lock_timer_base+0x0/0x54) from [<c00571b4>] (del_timer+0x2c/0x6c)
 r8:c0023570 r7:ce319d38 r6:00740000 r5:ceb19ca4 r4:c0763660
[<c0057188>] (del_timer+0x0/0x6c) from [<c008e5ec>]
(disable_synthetic_tsc_ipi+0x24/0x30)
 r5:ceb19ca4 r4:00000001
[<c008e5c8>] (disable_synthetic_tsc_ipi+0x0/0x30) from [<c0072e00>]
(generic_smp_call_function_single_interrupt+0x98/0xf4)
[<c0072d68>] (generic_smp_call_function_single_interrupt+0x0/0xf4)
from [<c0028368>] (do_IPI+0xc8/0x15c)
[<c00282a0>] (do_IPI+0x0/0x15c) from [<c00280c4>] (_text+0xc4/0x128)

Thank you.

Best regards
Naresh Kamboju
>
> Thanks,
>
> Mathieu
>\
