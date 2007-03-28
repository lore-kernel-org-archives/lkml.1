Return-Path: <linux-kernel-owner+w=401wt.eu-S965744AbXC1UMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965744AbXC1UMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965747AbXC1UMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:12:38 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57522 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965744AbXC1UMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:12:37 -0400
Date: Wed, 28 Mar 2007 13:02:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz =?ISO-8859-1?Q?Koz=5F=5Fowski?= <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@stusta.de>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: 2.6.21-rc5-mm1
Message-Id: <20070328130234.c0a23572.akpm@linux-foundation.org>
In-Reply-To: <200703281844.58698.m.kozlowski@tuxland.pl>
References: <20070326205706.a750bb35.akpm@linux-foundation.org>
	<200703281844.58698.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 18:44:57 +0200
Mariusz Koz__owski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	I run 2.6.21-rc4-mm1 with no hangs for a week.
> Then when 2.6.21-rc5-mm1 showed up so I switched to it. Unfortunately
> today my laptop hunged twice in a similar way as described here:
> 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#1165

It's not good that we went backwards between those two releases.

> 
> The difference is that it happened when I closed the lid in my laptop.
> When reopend it the box was frozen (ACPI?). Again disk I/O was dead
> so nothing was found in syslog.

Adrian, does this look like any of the bugs whcih you're monitoring?

> I tried to reproduce it and capture something with netconsole.
> I tortured the box for a few hours but the system did not hang. I pushed
> the box real hard and what I got was only oom-killer firing etc ;-)
> Anyway I found something else you might be interested in:
> 
> 
> 
> 1) This happened when 'echo 3 > /proc/sys/vm/drop_caches' on really
>    busy system.
> 
>  =======================================================
>  [ INFO: possible circular locking dependency detected ]
>  2.6.21-rc5-mm1 #1
>  -------------------------------------------------------
>  bash/20633 is trying to acquire lock:
>   (&journal->j_list_lock){--..}, at: [<c01bb60e>] journal_try_to_free_buffers+0x151/0x1bc
>  
>  but task is already holding lock:
>   (inode_lock){--..}, at: [<c0187d46>] drop_pagecache+0x58/0xf9

Yeah, that's a lock ranking error in the drop_caches code.  I have a
super-long-term plan to fix it, but in the short term nothing suggests
itself apart from removing the drop_caches code, I'm afraid.

> 
> 2) This was found a couple minutes later when the system was
>    really busy and close to oom condition.
> 
>  INFO: lockdep is turned off.
>  BUG: soft lockup detected on CPU#0!
>   [<c0104614>] show_trace_log_lvl+0x1a/0x30
>   [<c01052c9>] show_trace+0x12/0x14
>   [<c0105355>] dump_stack+0x16/0x18
>   [<c01467a0>] softlockup_tick+0x81/0xa8
>   [<c011e4dc>] run_local_timers+0x12/0x14
>   [<c011e8dd>] update_process_times+0x2b/0x63
>   [<c012e4be>] tick_sched_timer+0x4d/0x9e
>   [<c012af00>] hrtimer_interrupt+0x12e/0x1a6
>   [<c0106f56>] timer_interrupt+0xe/0x15
>   [<c0146af3>] handle_IRQ_event+0x28/0x59
>   [<c01480a7>] handle_level_irq+0x6e/0xe7
>   [<c0105d3e>] do_IRQ+0x3d/0x7f
>   [<c01041b2>] common_interrupt+0x2e/0x34
>   [<c011afef>] do_softirq+0x4d/0x50
>   [<c011b263>] irq_exit+0x7e/0x80
>   [<c0105d43>] do_IRQ+0x42/0x7f
>   [<c01041b2>] common_interrupt+0x2e/0x34
>   [<c0178bf2>] core_sys_select+0x1c6/0x310
>   [<c0179101>] sys_select+0x39/0x18f
>   [<c0103f44>] sysenter_past_esp+0x5d/0x99
>   =======================
>  Clocksource tsc unstable (delta = 9372804176 ns)
>  Time: acpi_pm clocksource has been installed.
> 
> Please find .config attached. Not sure who to CC on this (as usual ;-)).
> 

I do ;)
