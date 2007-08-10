Return-Path: <linux-kernel-owner+w=401wt.eu-S1762095AbXHJAMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762095AbXHJAMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 20:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756819AbXHJALx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 20:11:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756266AbXHJALw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 20:11:52 -0400
Date: Thu, 9 Aug 2007 17:11:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: josh@freedesktop.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: 2.6.23-rc2-mm1: sleeping function called from invalid context
 at kernel/mutex.c:86
Message-Id: <20070809171128.03f40dff.akpm@linux-foundation.org>
In-Reply-To: <200708100123.07762.m.kozlowski@tuxland.pl>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
	<200708100123.07762.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 01:23:07 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	This probably doesn't have great impact ;) but ...
> To reproduce: run torture tests for RCU and then sysrq+q.
> 
> SysRq : Show Pending Timers
> Timer List Version: v0.3
> HRTIMER_MAX_CLOCK_BASES: 2
> now at 1764338760370 nsecs
> 
> cpu: 0
>  clock 0:
>   .index:      0
>   .resolution: 1 nsecs
>   .get_time:   ktime_get_real
>   .offset:     1186699025823815427 nsecs
> active timers:
>  clock 1:
>   .index:      1
>   .resolution: 1 nsecs
>   .get_time:   ktime_get
>   .offset:     0 nsecs
> active timers:
>  #0: <3>BUG: sleeping function called from invalid context at kernel/mutex.c:86
> in_atomic():1, irqs_disabled():1
> INFO: lockdep is turned off.
> irq event stamp: 0
> hardirqs last  enabled at (0): [<00000000>] 0x0
> hardirqs last disabled at (0): [<c0117def>] copy_process+0x4a8/0x144c
> softirqs last  enabled at (0): [<c0117e0d>] copy_process+0x4c6/0x144c
> softirqs last disabled at (0): [<00000000>] 0x0
>  [<c0104869>] show_trace_log_lvl+0x1a/0x30
>  [<c01053ad>] show_trace+0x12/0x14
>  [<c0105515>] dump_stack+0x15/0x17
>  [<c0114da7>] __might_sleep+0xb7/0xc9
>  [<c0451771>] mutex_lock+0x15/0x1f
>  [<c0141b75>] lookup_module_symbol_name+0x17/0xc0
>  [<c014272a>] lookup_symbol_name+0x3f/0x43
>  [<c013287e>] print_name_offset+0x1f/0x96
>  [<c01330f7>] timer_list_show+0x802/0xcbd
>  [<c01335be>] sysrq_timer_list_show+0xc/0xe
>  [<c02cc4a1>] sysrq_handle_show_timers+0x8/0xa
>  [<c02cc3ac>] __handle_sysrq+0x7b/0x115
>  [<c02cc466>] handle_sysrq+0x20/0x24
>  [<c02c69c1>] kbd_event+0x3a8/0x5c7
>  [<c0362f8f>] input_pass_event+0x8f/0x91
>  [<c0363e77>] input_handle_event+0x98/0x38d
>  [<c0364e6d>] input_event+0x54/0x67
>  [<c03682c2>] atkbd_interrupt+0x200/0x59e
>  [<c0360cd0>] serio_interrupt+0x7c/0x80
>  [<c0361965>] i8042_interrupt+0x17a/0x289
>  [<c0147a5d>] handle_IRQ_event+0x28/0x59
>  [<c01493ca>] handle_level_irq+0xad/0x10b
>  [<c0105a13>] do_IRQ+0x93/0xd0
>  [<c010441e>] common_interrupt+0x2e/0x34
>  [<df39d7e3>] rcu_read_delay+0x8/0x36 [rcutorture]
>  [<df39d99a>] rcu_torture_reader+0x6e/0x169 [rcutorture]
>  [<c012c11e>] kthread+0x36/0x58
>  [<c010451b>] kernel_thread_helper+0x7/0x1c
>  =======================

We seem to have made a mess in there.  timer_list_show() ends up calling
lookup_module_symbol_name(), which takes a mutex.  However print_symbol()
(which is called at oops time, interrupt time, etc) calls
module_address_lookup(), which is basically the same, only it doesn't take
the mutex.

I guess a quicky fix would be to switch
kernel/time/timer_list.c:print_name_offset() from
lookup_module_symbol_name() to module_address_lookup().  But we'd still
have a mess in there.

(adds ccs, runs away)

