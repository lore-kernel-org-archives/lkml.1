Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZAMPS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZAMPS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZAMPSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:18:46 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53307 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752637AbZAMPSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:18:45 -0500
Message-ID: <496CB0D2.2010300@sgi.com>
Date: Tue, 13 Jan 2009 07:18:42 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL]: please pull changes for tip/cpus4096
References: <496BF1DC.2080009@sgi.com> <20090113151336.GA5431@elte.hu>
In-Reply-To: <20090113151336.GA5431@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Hi Ingo,
>>
>> This is the same as the previous pull request except that I added 
>> Yinghai's vast improvement to probing for nr_irqs.  Big difference in 
>> runtime memory allocated.
> 
> before moving on, we first need to fix all pending regressions. Such as 
> some MAXSMP fallout from the cpufreq changes:

Ahh, ok, was this in my inbox already?

> 
> [   32.937027] calling  acpi_cpufreq_init+0x0/0x100 @ 1
> [   32.942203] BUG: unable to handle kernel NULL pointer dereference at (null)
> [   32.946003] IP: [<ffffffff80222521>] get_cur_val+0xcc/0x106
> [   32.946003] PGD 0 
> [   32.946003] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
> [   32.946003] last sysfs file: 
> [   32.946003] CPU 1 
> [   32.946003] Pid: 1, comm: swapper Tainted: G        W  2.6.29-rc1-00190-g37a76bd #10
> [   32.946003] RIP: 0010:[<ffffffff80222521>]  [<ffffffff80222521>] get_cur_val+0xcc/0x106
> [   32.946003] RSP: 0018:ffff88003f977b80  EFLAGS: 00010202
> [   32.946003] RAX: 0000000000000001 RBX: ffff8800029c8c80 RCX: 0000000000000008
> [   32.946003] RDX: 0000000000000000 RSI: ffffffff80ce0100 RDI: 0000000000000000
> [   32.946003] RBP: ffff88003f977bd0 R08: 0000000000000004 R09: 0000000000000040
> [   32.946003] R10: 0000000000000060 R11: 0000000081363fa8 R12: ffffffff81c4f0e0
> [   32.946003] R13: ffffffff80ce0100 R14: ffff88003c888a00 R15: 0000000000000000
> [   32.946003] FS:  0000000000000000(0000) GS:ffff88003f802c00(0000) knlGS:0000000000000000
> [   32.946003] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [   32.946003] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> [   32.946003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   32.946003] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   32.946003] Process swapper (pid: 1, threadinfo ffff88003f976000, task ffff88003f978000)
> [   32.946003] Stack:
> [   32.946003]  0000000000000202 0000000000000002 0000000000000001 0000000000000000
> [   32.946003]  0000000000000198 0000000000000002 0000000000000000 00000000002ca5b0
> [   32.946003]  0000000000000000 ffff88003e5533e0 ffff88003f977c00 ffffffff802225e3
> [   32.946003] Call Trace:
> [   32.946003]  [<ffffffff802225e3>] get_cur_freq_on_cpu+0x88/0xd9
> [   32.946003]  [<ffffffff80222ea9>] acpi_cpufreq_cpu_init+0x3ed/0x530
> [   32.946003]  [<ffffffff80ac2d41>] cpufreq_add_dev+0x1bb/0x6dd
> [   32.946003]  [<ffffffff8026fd0e>] ? trace_hardirqs_on+0xd/0xf
> [   32.946003]  [<ffffffff8026fbcd>] ? trace_hardirqs_on_caller+0x1f/0x153
> [   32.946003]  [<ffffffff8026fd0e>] ? trace_hardirqs_on+0xd/0xf
> [   32.946003]  [<ffffffff80ccbc77>] ? mutex_lock_nested+0x2b0/0x2d3
> [   32.946003]  [<ffffffff8026fbcd>] ? trace_hardirqs_on_caller+0x1f/0x153
> [   32.946003]  [<ffffffff80ccbc8b>] ? mutex_lock_nested+0x2c4/0x2d3
> [   32.946003]  [<ffffffff805fd81d>] ? sysdev_driver_register+0x7c/0x11a
> [   32.946003]  [<ffffffff805fd81d>] ? sysdev_driver_register+0x7c/0x11a
> 
> which triggers with latest -git with the attached config, and fixed by the 
> commit below..
> 
> 	Ingo
> 
> -------------------->
>>From 4a922a969cb0190ce4580d4b064e2ac35f3ac9bf Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 13 Jan 2009 16:11:00 +0100
> Subject: [PATCH] x86, cpufreq: remove leftover copymask_copy()
> 
> Impact: fix potential boot crash on MAXSMP
> 
> Remove code left over by:
> 
>   50c668d: Revert "cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read
> 
> That cmd.cpumask is not allocated anymore. No impact on default !MAXSMP
> kernels.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> index 6f11e02..8f3c95c 100644
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -235,8 +235,6 @@ static u32 get_cur_val(const struct cpumask *mask)
>  		return 0;
>  	}
>  
> -	cpumask_copy(cmd.mask, mask);
> -
>  	drv_read(&cmd);
>  
>  	dprintk("get_cur_val = %u\n", cmd.val);
> 

