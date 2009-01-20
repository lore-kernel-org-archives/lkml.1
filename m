Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbZATSR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbZATSR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 13:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbZATSRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 13:17:50 -0500
Received: from relay3.sgi.com ([192.48.171.31]:45773 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753359AbZATSRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 13:17:48 -0500
Message-ID: <49761545.7010609@sgi.com>
Date: Tue, 20 Jan 2009 10:17:41 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Li Zefan <lizf@cn.fujitsu.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Nick Piggin <npiggin@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] kernel BUG at arch/x86/kernel/tlb_32.c:130!
References: <49756F44.6040801@cn.fujitsu.com> <20090120075440.GA29426@elte.hu> <20090120081759.GA30394@elte.hu>
In-Reply-To: <20090120081759.GA30394@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

It seems like a reasonable fix.  One aspect of the previous method
(using a stack cpumask variable) is that the same condition could
occur (the cpu's tlb being flushed is requested to do it after it's
been done.)  Would this then be an error, or just a nop?

Thanks,
Mike
--- 

Ingo Molnar wrote:
...
> 
> Li Zefan, Jaswinder, does the patch below fix it for you?
> 
> 	Ingo
> 
> --------------->
>>From 5766b842b23c6b40935a5f3bd435b2bcdaff2143 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 20 Jan 2009 09:13:15 +0100
> Subject: [PATCH] x86, cpumask: fix tlb flush race
> 
> Impact: fix bootup crash
> 
> The cpumask is now passed in as a reference to mm->cpu_vm_mask, not on
> the stack - hence it is not constant anymore during the TLB flush.
> 
> That way it could race and some static sanity checks would trigger:
> 
> [  238.154287] ------------[ cut here ]------------
> [  238.156039] kernel BUG at arch/x86/kernel/tlb_32.c:130!
> [  238.156039] invalid opcode: 0000 [#1] SMP
> [  238.156039] last sysfs file: /sys/class/net/eth2/address
> [  238.156039] Modules linked in:
> [  238.156039]
> [  238.156039] Pid: 6493, comm: ifup-eth Not tainted (2.6.29-rc2-tip #1) P4DC6
> [  238.156039] EIP: 0060:[<c0118f87>] EFLAGS: 00010202 CPU: 2
> [  238.156039] EIP is at native_flush_tlb_others+0x35/0x158
> [  238.156039] EAX: c0ef972c EBX: f6143301 ECX: 00000000 EDX: 00000000
> [  238.156039] ESI: f61433a8 EDI: f6143200 EBP: f34f3e00 ESP: f34f3df0
> [  238.156039]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [  238.156039] Process ifup-eth (pid: 6493, ti=f34f2000 task=f399ab00 task.ti=f34f2000)
> [  238.156039] Stack:
> [  238.156039]  ffffffff f61433a8 ffffffff f6143200 f34f3e18 c0118e9c 00000000 f6143200
> [  238.156039]  f61433a8 f5bec738 f34f3e28 c0119435 c2b5b830 f6143200 f34f3e34 c01c2dc3
> [  238.156039]  bffd9000 f34f3e60 c01c3051 00000000 ffffffff f34f3e4c 00000000 00000071
> [  238.156039] Call Trace:
> [  238.156039]  [<c0118e9c>] ? flush_tlb_others+0x52/0x5b
> [  238.156039]  [<c0119435>] ? flush_tlb_mm+0x7f/0x8b
> [  238.156039]  [<c01c2dc3>] ? tlb_finish_mmu+0x2d/0x55
> [  238.156039]  [<c01c3051>] ? exit_mmap+0x124/0x170
> [  238.156039]  [<c013e965>] ? mmput+0x40/0xf5
> [  238.156039]  [<c01e4788>] ? flush_old_exec+0x640/0x94b
> [  238.156039]  [<c01ddb4e>] ? fsnotify_access+0x37/0x39
> [  238.156039]  [<c01e3435>] ? kernel_read+0x39/0x4b
> [  238.156039]  [<c021bc8a>] ? load_elf_binary+0x4a1/0x11bb
> [  238.156039]  [<c01c0af9>] ? might_fault+0x51/0x9c
> [  238.156039]  [<c010a2cc>] ? paravirt_read_tsc+0x20/0x4f
> [  238.156039]  [<c010a406>] ? native_sched_clock+0x5d/0x60
> [  238.156039]  [<c01e2fda>] ? search_binary_handler+0xab/0x2c4
> [  238.156039]  [<c021b7e9>] ? load_elf_binary+0x0/0x11bb
> [  238.156039]  [<c04ae9a5>] ? _raw_read_unlock+0x21/0x46
> [  238.156039]  [<c021b7e9>] ? load_elf_binary+0x0/0x11bb
> [  238.156039]  [<c01e2fe1>] ? search_binary_handler+0xb2/0x2c4
> [  238.156039]  [<c01e4076>] ? do_execve+0x21c/0x2ee
> [  238.156039]  [<c01029b7>] ? sys_execve+0x51/0x8c
> [  238.156039]  [<c0103eaf>] ? sysenter_do_call+0x12/0x43
> 
> Fix it by not assuming that the cpumask is constant.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/tlb_32.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
> index ec53818..d37bbfc 100644
> --- a/arch/x86/kernel/tlb_32.c
> +++ b/arch/x86/kernel/tlb_32.c
> @@ -125,9 +125,8 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
>  			     struct mm_struct *mm, unsigned long va)
>  {
>  	/*
> -	 * - mask must exist :)
> +	 * mm must exist :)
>  	 */
> -	BUG_ON(cpumask_empty(cpumask));
>  	BUG_ON(!mm);
>  
>  	/*
> @@ -138,14 +137,18 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
>  	spin_lock(&tlbstate_lock);
>  
>  	cpumask_andnot(flush_cpumask, cpumask, cpumask_of(smp_processor_id()));
> -#ifdef CONFIG_HOTPLUG_CPU
> -	/* If a CPU which we ran on has gone down, OK. */
>  	cpumask_and(flush_cpumask, flush_cpumask, cpu_online_mask);
> +
> +	/*
> +	 * If a task whose mm mask we are looking at has descheduled and
> +	 * has cleared its presence from the mask, or if a CPU which we ran
> +	 * on has gone down then there might be no flush work left:
> +	 */
>  	if (unlikely(cpumask_empty(flush_cpumask))) {
>  		spin_unlock(&tlbstate_lock);
>  		return;
>  	}
> -#endif
> +
>  	flush_mm = mm;
>  	flush_va = va;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

