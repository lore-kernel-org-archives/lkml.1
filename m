Return-Path: <linux-kernel-owner+w=401wt.eu-S1422989AbXDXSl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422989AbXDXSl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 14:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422998AbXDXSl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 14:41:57 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422989AbXDXSl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 14:41:56 -0400
Date: Tue, 24 Apr 2007 11:41:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.21-rc7-mm1: BUG at init_sched_clock()
Message-Id: <20070424114147.3d9fd54a.akpm@linux-foundation.org>
In-Reply-To: <20070424182358.GA5857@martell.zuzino.mipt.ru>
References: <20070424182358.GA5857@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 22:23:58 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> 	...
> CPU1: Thermal monitoring enabled (TM2)
> Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 02
> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> Brought up 2 CPUs
> migration_cost=9999
> BUG: at arch/x86_64/kernel/../../i386/kernel/sched-clock.c:175 init_sched_clock()
> 
> Call Trace:
>  [<ffffffff8020ae7a>] show_trace+0x34/0x4f
>  [<ffffffff8020aea7>] dump_stack+0x12/0x17
>  [<ffffffff8046dddf>] init_sched_clock+0x59/0x8a
>  [<ffffffff8046a608>] kernel_init+0x167/0x2dc
>  [<ffffffff8020a4c8>] child_rip+0xa/0x12
> 
> It didn't happen in 2.6.21-rc6-mm1 nor in mainline.

It seems to expect that init_sched_clock() will be called before SMP
bringup, but init_sched_clock() should _always_ be called _after_ SMP
bringup - it's core_initcall.  Confused.

> And migration cost was 15.
> However, box boots to the end as usual. /proc/cpuinfo shows 2 CPUs.
> 
> [reboots box]
> Now migration cost is 19999 and same trace.

That's a consequence of the same thing: we need a working sched_clock() to
calibrate the migration costs, but init_sched_clock() hasn't run yet.


> ------------------------------------------------------------------------------
> Should-be-relevant config options:
> 
> CONFIG_X86_64=y
> CONFIG_64BIT=y
> CONFIG_X86=y
> CONFIG_GENERIC_TIME=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_MCORE2=y
> CONFIG_X86_TSC=y
> CONFIG_X86_GOOD_APIC=y
> CONFIG_X86_HT=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_SMP=y
> CONFIG_SCHED_MC=y
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_BKL=y
> CONFIG_NR_CPUS=2
> CONFIG_HPET_TIMER=y
> CONFIG_HZ=100
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_DETECT_SOFTLOCKUP=y

CONFIG_SCHED_SMT and CONFIG_SCHED_MC might be significant here.

Anyway, I'll cc Andi and run away.

