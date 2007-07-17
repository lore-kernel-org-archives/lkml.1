Return-Path: <linux-kernel-owner+w=401wt.eu-S934302AbXGQXNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934302AbXGQXNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbXGQXNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:13:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:51136 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947AbXGQXNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:13:40 -0400
Date: Tue, 17 Jul 2007 16:12:29 -0700 (PDT)
From: Jeremy Katz <jeremy.katz@windriver.com>
X-X-Sender: jkatz@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
In-Reply-To: <1184703427.12353.476.camel@chaos>
Message-ID: <Pine.LNX.4.63.0707171558570.10358@localhost.localdomain>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain> 
 <1184662429.12353.426.camel@chaos>  <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain>
 <1184703427.12353.476.camel@chaos>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 17 Jul 2007 23:12:29.0737 (UTC) FILETIME=[F296E190:01C7C8C7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Thomas Gleixner wrote:

> On Tue, 2007-07-17 at 11:39 -0700, Jeremy Katz wrote:
>> I tried the patch with my test case, but still see the issue.
>> Here's my explanation of the double free race:
>> CPU 0					CPU 1
>> sys_timer_delete():
>>  	lock_timer();
>>  	...
>>  	unlock_timer();			itimer_delete()
>>  	release_posix_timer():			spin_lock_irqsave(timer...)
>>  		...				...
>>  		sigqueue_free()			unlock_timer()
>>  		...				sigqueue_free()
>>  							BUG_ON(!(q->flags...
>
> With 2.6.14 or with current mainline ?

I haven't been keeping notes quite as studiously as I should have been, 
but this just occurred with 2.6.22.1 + the hrt6 patch + your proposed fix:

------------[ cut here ]------------
Kernel BUG at c0125987 [verbose debug info unavailable]
invalid opcode: 0000 [#1]
SMP
Modules linked in:
CPU:    0
EIP:    0060:[<c0125987>]    Not tainted VLI
EFLAGS: 00010246   (2.6.22-hrt1-WR1.4aq_cgl #1)
EIP is at sigqueue_free+0x23/0x72
eax: 00000000   ebx: f713a7d8   ecx: f79e25e0   edx: 00000202
esi: f6f4fa1c   edi: 00000283   ebp: f7207e54   esp: f7207e4c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process hrtm_test (pid: 19369, ti=f7207000 task=f729ea50 task.ti=f7207000)
Stack: 00000202 f6f4fa1c f7207e64 c012c7ca f6f4fa1c f6f4fa24 f7207e78 
c012d110
        f77463c0 f77463fc 00000001 f7207e88 c012d14b f77463c0 f729ea50 
f7207eb4
        c011e57c f729eea4 00000006 f729ea50 f7207ea4 c01244e8 00000006 
f77463c0
Call Trace:
  [<c0103504>] show_trace_log_lvl+0x1a/0x30
  [<c01035bb>] show_stack_log_lvl+0x8d/0xaa
  [<c01037f5>] show_registers+0x1cd/0x2cb
  [<c0103a4a>] die+0x113/0x207
  [<c0395cf5>] do_trap+0x8f/0xc6
  [<c0103d35>] do_invalid_op+0x88/0x92
  [<c0395ac2>] error_code+0x72/0x78
  [<c012c7ca>] release_posix_timer+0x1b/0x7a
  [<c012d110>] itimer_delete+0x9b/0xc0
  [<c012d14b>] exit_itimers+0x16/0x21
  [<c011e57c>] do_exit+0x300/0x3e8
  [<c011e6b2>] do_group_exit+0x29/0x6f
  [<c012643a>] get_signal_to_deliver+0x210/0x298
  [<c010256d>] do_signal+0x5c/0x158
  [<c01026a5>] do_notify_resume+0x3c/0x3f
  [<c0102866>] work_notifysig+0x13/0x19

> I doubt that this can happen, as itimer_delete() is only called, when
> there are no more references to the shared sig struct. At this point no
> other related thread can run sys_timer_delete().

I came to the above explanation after failing to find another path that 
clears the SIGQUEUE_PREALLOC flag.  Some form of memory corruption could 
be to blame.

>> the timer fires during deletion:
>> CPU 0					CPU 1
>> sys_timer_delete():
>>  	lock_timer();
>>  	...
>>  	unlock_timer();			posix_timer_fn()
>>  	release_posix_timer():			spin_lock_irqsave(timer...)
>>  		...				...
>>  		sigqueue_free()			posix_timer_event()
>>  		...					...
>>  							send_sigqueue()
>>  								BUG_ON(!(q->flags
>>
>
> I do not buy that either. In sys_timer_delete() the active timer is
> canceled. If we can not cancel it then we retry until the timer callback
> has been processed. This is even true for 2.6.14 (pre hrtimer).
>
>> --- linux-2.6.14-cgl.original/kernel/posix-timers.c	2007-07-11 16:06:47.000000000 -0700
>> +++ linux-2.6.14-cgl/kernel/posix-timers.c	2007-07-16 15:25:43.000000000 -0700
>> @@ -339,7 +339,9 @@ static int posix_timer_fn(void *data)
>>   	int si_private = 0;
>>   	int ret = HRTIMER_NORESTART;
>>
>> -	spin_lock_irqsave(&timr->it_lock, flags);
>> +	if(lock_timer(timr->it_id, &flags) == NULL) {
>> +		return ret;
>> +	}
>
> This is wrong. You look at something which is not valid anymore, if your
> theory is correct. You are just pampering over the real bug.

Noticed right after I sent the patch out.  My goal was to validate and 
lock the timer through a single interface, but itimer_delete() and 
posix_timer_fn() currently recieve a k_itimer * instead of a timer_t.  I 
should have reworked them.

>> @@ -835,7 +844,9 @@ static inline void itimer_delete(struct
>>   	unsigned long flags;
>>
>>   retry_delete:
>> -	spin_lock_irqsave(&timer->it_lock, flags);
>> +	/* timer already deleted? */
>> +	if (lock_timer(timer->it_id, &flags) == NULL)
>> +		return;
>
> Same here.

Thanks for the reply,
Jeremy
