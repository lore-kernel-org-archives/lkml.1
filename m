Return-Path: <linux-kernel-owner+w=401wt.eu-S933852AbXGRQKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933852AbXGRQKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760224AbXGRQK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:10:29 -0400
Received: from mail.screens.ru ([213.234.233.54]:46538 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759888AbXGRQK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:10:28 -0400
Date: Wed, 18 Jul 2007 20:11:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jeremy Katz <jeremy.katz@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
Message-ID: <20070718161156.GA761@tv-sign.ru>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain> <1184662429.12353.426.camel@chaos> <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain> <1184703427.12353.476.camel@chaos> <Pine.LNX.4.63.0707171558570.10358@localhost.localdomain> <Pine.LNX.4.63.0707171654020.10358@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0707171654020.10358@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17, Jeremy Katz wrote:
>
> This is with the patch (and 2.6.22.1 and hrt6):
> 
> ------------[ cut here ]------------
> Kernel BUG at c0125adb [verbose debug info unavailable]
> invalid opcode: 0000 [#1]
> SMP
> Modules linked in:
> CPU:    3
> EIP:    0060:[<c0125adb>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.22.1-WR1.4aq_cgl #2)
> EIP is at sigqueue_free+0x23/0x72
> eax: 00000000   ebx: f6eaf1a8   ecx: f6d4b888   edx: 00000202
> esi: f73e2ba8   edi: 00000000   ebp: f7c7bf8c   esp: f7c7bf84
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process hrtm_test (pid: 15340, ti=f7c7b000 task=f6c0f030 task.ti=f7c7b000)
> Stack: 00000202 f73e2ba8 f7c7bf9c c012c941 f73e2ba8 000002fb f7c7bfb0 
> c012d1c0
>        00000286 000002fb 00000000 f7c7b000 c01027ca 000002fb 466afff4 
> 08064190
>        00000000 00000000 ae8d43c8 00000107 ffff007b c010007b 00000000 
> 00000107
> Call Trace:
>  [<c0103504>] show_trace_log_lvl+0x1a/0x30
>  [<c01035bb>] show_stack_log_lvl+0x8d/0xaa
>  [<c01037f5>] show_registers+0x1cd/0x2cb
>  [<c0103a4a>] die+0x113/0x207
>  [<c039aab5>] do_trap+0x8f/0xc6
>  [<c0103d35>] do_invalid_op+0x88/0x92
>  [<c039a882>] error_code+0x72/0x78
>  [<c012c941>] release_posix_timer+0x1b/0x7a
>  [<c012d1c0>] sys_timer_delete+0xd7/0x10c
>  [<c01027ca>] syscall_call+0x7/0xb

This looks really impossible.

I believe I see another bug in sys_timer_create(), but it is not related
to this problem.

sys_timer_create() inserts a partly initialized new_timer into posix_timers_id
and drops idr_lock. Suppose that another thread does sys_timer_delete(). If it
sees ->it_process != NULL, lock_timer() succeeds.

If the timer was not fully initialized at this time (or another CPU sees the
result of STOREs out of order), we can have multiple probles.

list_del() may oops, we can do put_task_struct() before sys_timer_create()
does get_task_struct(), we may leak the task_struct if sys_timer_delete()
doesn't see SIGEV_THREAD_ID yet.


Jeremy, I agree with Thomas that your patch should not be right, but it
does make a difference. Perhaps this is just the timing, but who knows.
Could you add some printk's to be sure that lock_timer() actually fails
while it never should?

Oleg.

