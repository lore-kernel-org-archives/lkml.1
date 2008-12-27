Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYL0HL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYL0HL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 02:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbYL0HLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 02:11:48 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:44190 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbYL0HLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 02:11:47 -0500
Date: Sat, 27 Dec 2008 12:41:38 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Yinghai Lu <yinghai@kernel.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333
	smp_call_function_mask
Message-ID: <20081227071138.GA4530@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <495153A4.5060201@kernel.org> <20081224163400.GA11562@linux.vnet.ibm.com> <49529CE1.4040005@kernel.org> <20081226091217.GA5100@linux.vnet.ibm.com> <4954AC7B.3020603@kernel.org> <20081226102716.GA31450@uranus.ravnborg.org> <20081226152804.GB5100@linux.vnet.ibm.com> <20081226153318.GA4514@elte.hu> <20081226170452.GC5100@linux.vnet.ibm.com> <20081226181733.GA24439@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081226181733.GA24439@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2008-12-26 19:17:34]:

> 
> * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > > how about the patch below, does that work too? (after removing 
> > > Yinghai's patch)
> > 
> > Hi Ingo,
> > 
> > 	Kernel crashes with the same trace, after the applying the patch.
> 
> okay, thanks - does the below cleaner variant of Yinghai's patch solve the 
> problem too?
> 
> 	Ingo
> 
> -------------------->
> From 9c93fc72ec95dc97d65b840978f9d605f4e5823a Mon Sep 17 00:00:00 2001
> From: Yinghai Lu <yinghai@kernel.org>
> Date: Fri, 26 Dec 2008 02:05:47 -0800
> Subject: [PATCH] sparseirq: work around compiler optimizing away __weak functions
> 
> Impact: fix panic on null pointer with sparseirq
> 
> Some GCC versions seem to inline the weak global function,
> when that function is empty.
> 
> Work it around, by putting a barrier into the function.
> 
> Signed-off-by: Yinghai <yinghai@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  init/main.c         |    9 +++++++++
>  kernel/irq/handle.c |    3 ++-
>  2 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index c1f999a..841d2b2 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -531,20 +531,29 @@ static void __init boot_cpu_init(void)
>  	cpu_set(cpu, cpu_possible_map);
>  }
> 
> +/*
> + * The barriers are needed to keep a GCC bug from optimizing
> + * away these weak functions:
> + */
> +
>  void __init __weak smp_setup_processor_id(void)
>  {
> +	barrier();
>  }
> 
>  void __init __weak thread_info_cache_init(void)
>  {
> +	barrier();
>  }
> 
>  void __init __weak arch_early_irq_init(void)
>  {
> +	barrier();
>  }
> 
>  void __init __weak early_irq_init(void)
>  {
> +	barrier();
>  	arch_early_irq_init();
>  }
> 
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index 06b05a4..a6d16a4 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -86,8 +86,9 @@ void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
>  		desc->kstat_irqs = (unsigned int *)ptr;
>  }
> 
> -void __attribute__((weak)) arch_init_chip_data(struct irq_desc *desc, int cpu)
> +void __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
>  {
> +	barrier();
>  }
> 
>  static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
> --

Hi Ingo,

	Kernel still crashes after applying the patch,

CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ACPI: Core revision 20080926
Setting APIC routing to flat
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff8021f8fd>] add_pin_to_irq_cpu+0x14/0x73
PGD 0 
Oops: 0000 [#1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.28-rc8-autotest-tip #1
RIP: 0010:[<ffffffff8021f8fd>]  [<ffffffff8021f8fd>] add_pin_to_irq_cpu+0x14/0x73
RSP: 0018:ffff88003f9d7e40  EFLAGS: 00010282
RAX: ffffffff806e7300 RBX: 0000000000000001 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000018 R09: 0000000000000002
R10: 000000000000000f R11: ffffffff8021e74a R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff806f1480(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88003f9d6000, task ffff88003f9d8000)
Stack:
 0000000000000000 0000000000000001 ffffffff806e7300 0000000000000001
 0000000000000001 ffffffff8071819e 0000000000000286 0000000000000286
 0000000000010000 0000000000000206 0000000000000002 0000000000000002
Call Trace:
 [<ffffffff8071819e>] setup_IO_APIC+0x12f/0x720
 [<ffffffff80524bf1>] _spin_lock_irqsave+0x9/0xe
 [<ffffffff8022221b>] get_apic_id+0x0/0x9
 [<ffffffff80715087>] native_smp_prepare_cpus+0x256/0x2f1
 [<ffffffff807077c8>] kernel_init+0x50/0x1eb
 [<ffffffff8020ceda>] child_rip+0xa/0x20
 [<ffffffff80707778>] kernel_init+0x0/0x1eb
 [<ffffffff8020ced0>] child_rip+0x0/0x20
Code: 48 c7 c7 9a 29 5f 80 31 c0 e8 83 85 01 00 5b 4c 89 e0 41 5c 41 5d c3 41 55 49 89 fd 89 f7 41 54 41 89 cc 55 89 d5 53 48 83 ec 08 <49> 8b 5d 00 48 85 db 75 35 e8 88 ff ff ff 48 85 c0 75 18 5b 5b 
RIP  [<ffffffff8021f8fd>] add_pin_to_irq_cpu+0x14/0x73
 RSP <ffff88003f9d7e40>
CR2: 0000000000000000
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D    2.6.28-rc8-autotest-tip #1
Call Trace:
 [<ffffffff80237321>] panic+0x86/0x144
 [<ffffffff80236bc8>] mm_release+0x3f/0xd3
 [<ffffffff80238b4f>] exit_fs+0x35/0x46
 [<ffffffff80239fd7>] do_exit+0x75/0x78f
 [<ffffffff805257ae>] oops_end+0xa8/0xad
 [<ffffffff80526ffd>] do_page_fault+0x756/0x80f
 [<ffffffff80524dbf>] page_fault+0x1f/0x30
 [<ffffffff8021e74a>] native_apic_mem_write+0x0/0x9
 [<ffffffff8021f8fd>] add_pin_to_irq_cpu+0x14/0x73
 [<ffffffff8071819e>] setup_IO_APIC+0x12f/0x720
 [<ffffffff80524bf1>] _spin_lock_irqsave+0x9/0xe
 [<ffffffff8022221b>] get_apic_id+0x0/0x9
 [<ffffffff80715087>] native_smp_prepare_cpus+0x256/0x2f1
 [<ffffffff807077c8>] kernel_init+0x50/0x1eb
 [<ffffffff8020ceda>] child_rip+0xa/0x20
 [<ffffffff80707778>] kernel_init+0x0/0x1eb
 [<ffffffff8020ced0>] child_rip+0x0/0x20
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
