Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbYL0LVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbYL0LVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 06:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbYL0LVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 06:21:36 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:59937 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbYL0LVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 06:21:34 -0500
Date: Sat, 27 Dec 2008 16:51:25 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333
	smp_call_function_mask
Message-ID: <20081227112125.GB4530@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <4954AC7B.3020603@kernel.org> <20081226102716.GA31450@uranus.ravnborg.org> <20081226152804.GB5100@linux.vnet.ibm.com> <20081226153318.GA4514@elte.hu> <20081226170452.GC5100@linux.vnet.ibm.com> <20081226181733.GA24439@elte.hu> <20081227071138.GA4530@linux.vnet.ibm.com> <4955DBBC.4070508@kernel.org> <20081227083758.GA12138@elte.hu> <20081227083936.GA12609@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081227083936.GA12609@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2008-12-27 09:39:36]:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> > > +extern int arch_init_chip_data(struct irq_desc *desc, int cpu);
> > 
> > when you change a function declaration's return type, you _must_ double 
> > check whether you properly updated all instances of that function. In 
> > this case you forgot about the io_apic.c instance.
> 
> the corrected patch is below.
> 
> 	Ingo
>

> --------------->
> From d353c528bbb29be434f7688cba9b59781e9151e3 Mon Sep 17 00:00:00 2001
> From: Yinghai Lu <yinghai@kernel.org>
> Date: Fri, 26 Dec 2008 02:05:47 -0800
> Subject: [PATCH] sparseirq: work around compiler optimizing away __weak functions
> 
> Impact: fix panic on null pointer with sparseirq
> 
> Some GCC versions seem to inline the weak global function,
> when that function is empty.
> 
> Work it around, by making the functions return a (dummy) integer.
> 
> Signed-off-by: Yinghai <yinghai@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/io_apic.c |    6 ++++--
>  include/linux/irq.h       |    6 +++---
>  init/main.c               |    7 ++++---
>  kernel/irq/handle.c       |    7 ++++---
>  4 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
> index 2fe543f..e4d4d19 100644
> --- a/arch/x86/kernel/io_apic.c
> +++ b/arch/x86/kernel/io_apic.c
> @@ -170,7 +170,7 @@ static struct irq_cfg irq_cfgx[NR_IRQS] = {
>  	[15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
>  };
> 
> -void __init arch_early_irq_init(void)
> +int __init arch_early_irq_init(void)
>  {
>  	struct irq_cfg *cfg;
>  	struct irq_desc *desc;
> @@ -184,6 +184,8 @@ void __init arch_early_irq_init(void)
>  		desc = irq_to_desc(i);
>  		desc->chip_data = &cfg[i];
>  	}
> +
> +	return 0;
>  }
> 
>  #ifdef CONFIG_SPARSE_IRQ
> @@ -212,7 +214,7 @@ static struct irq_cfg *get_one_free_irq_cfg(int cpu)
>  	return cfg;
>  }
> 
> -void arch_init_chip_data(struct irq_desc *desc, int cpu)
> +int arch_init_chip_data(struct irq_desc *desc, int cpu)
>  {
>  	struct irq_cfg *cfg;

the return statement is missing in the patch.

> 
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index 69da275..0e40af4 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -193,9 +193,9 @@ struct irq_desc {
>  	const char		*name;
>  } ____cacheline_internodealigned_in_smp;
> 
> -extern void early_irq_init(void);
> -extern void arch_early_irq_init(void);
> -extern void arch_init_chip_data(struct irq_desc *desc, int cpu);
> +extern int early_irq_init(void);
> +extern int arch_early_irq_init(void);
> +extern int arch_init_chip_data(struct irq_desc *desc, int cpu);
>  extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
>  					struct irq_desc *desc, int cpu);
>  extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc);
> diff --git a/init/main.c b/init/main.c
> index c1f999a..b541c9a 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -539,13 +539,14 @@ void __init __weak thread_info_cache_init(void)
>  {
>  }
> 
> -void __init __weak arch_early_irq_init(void)
> +int __init __weak arch_early_irq_init(void)
>  {
> +	return 0;
>  }
> 
> -void __init __weak early_irq_init(void)
> +int __init __weak early_irq_init(void)
>  {
> -	arch_early_irq_init();
> +	return 0;
>  }
> 
>  asmlinkage void __init start_kernel(void)
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index 893da67..0bef3ec 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -86,8 +86,9 @@ void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
>  		desc->kstat_irqs = (unsigned int *)ptr;
>  }
> 
> -void __attribute__((weak)) arch_init_chip_data(struct irq_desc *desc, int cpu)
> +int __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
>  {
> +	return 0;
>  }
> 
>  static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
> @@ -132,7 +133,7 @@ static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_sm
>  /* FIXME: use bootmem alloc ...*/
>  static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
> 
> -void __init early_irq_init(void)
> +int __init early_irq_init(void)
>  {
>  	struct irq_desc *desc;
>  	int legacy_count;
> @@ -151,7 +152,7 @@ void __init early_irq_init(void)
>  	for (i = legacy_count; i < NR_IRQS; i++)
>  		irq_desc_ptrs[i] = NULL;
> 
> -	arch_early_irq_init();
> +	return arch_early_irq_init();
>  }
> 
>  struct irq_desc *irq_to_desc(unsigned int irq)


After applying the patch, the kernel crashes with the same back trace


Initializing CPU#0
BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
IP: [<ffffffff8070e46e>] init_ISA_irqs+0x18/0x53
PGD 0 
Thread overran stack, or stack corrupted
Oops: 0002 [#1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.28-rc8-autotest-tip #1
RIP: 0010:[<ffffffff8070e46e>]  [<ffffffff8070e46e>] init_ISA_irqs+0x18/0x53
RSP: 0018:ffffffff806fff68  EFLAGS: 00010093
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff80773b40
RDX: 0000000000000100 RSI: 0000000000000096 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff8800808a3000 R09: 0000000000000000
R10: ffff880001012ce0 R11: ffffffff80355720 R12: 0000000000000000
R13: ffffffff80735860 R14: ffffffff807380a0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff806f1480(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000048 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff806fe000, task ffffffff8067e3a0)
Stack:
 0000000000000003 ffffffff8070e4b2 ffffffff806e2f40 ffffffff8050e443
 0000000000000003 ffffffff80707b25 0000000000000000 00000000008127f0
 ffffffff807380a0 0000000000093370 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8070e4b2>] native_init_IRQ+0x9/0x9b5
 [<ffffffff8050e443>] register_cpu_notifier+0x1f/0x23
 [<ffffffff80707b25>] start_kernel+0x1c2/0x31d
 [<ffffffff80707394>] x86_64_start_kernel+0xde/0xe2
Code: 85 c0 75 0d 59 48 c7 c7 a0 ff 67 80 e9 78 bf cb ff 5a c3 53 31 db e8 6e 87 00 00 31 ff e8 4d 0e b0 ff 89 df e8 9f 81 b5 ff 89 df <c7> 40 48 00 02 00 00 48 c7 40 40 00 00 00 00 c7 40 4c 01 00 00 
RIP  [<ffffffff8070e46e>] init_ISA_irqs+0x18/0x53
 RSP <ffffffff806fff68>
CR2: 0000000000000048
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc8-autotest-tip #1
Call Trace:
 [<ffffffff80237321>] panic+0x86/0x144
 [<ffffffff80237eb1>] printk+0x4e/0x56
 [<ffffffff80239fd7>] do_exit+0x75/0x78f
 [<ffffffff8052579e>] oops_end+0xa8/0xad
 [<ffffffff80526fed>] do_page_fault+0x756/0x80f
 [<ffffffff80524daf>] page_fault+0x1f/0x30
 [<ffffffff80355720>] delay_loop+0x0/0x29
 [<ffffffff8070e46e>] init_ISA_irqs+0x18/0x53
 [<ffffffff8070e46c>] init_ISA_irqs+0x16/0x53
 [<ffffffff8070e4b2>] native_init_IRQ+0x9/0x9b5
 [<ffffffff8050e443>] register_cpu_notifier+0x1f/0x23
 [<ffffffff80707b25>] start_kernel+0x1c2/0x31d
 [<ffffffff80707394>] x86_64_start_kernel+0xde/0xe2
------------[ cut here ]------------
WARNING: at kernel/smp.c:333 smp_call_function_mask+0x36/0x224()
Hardware name: IBM eServer BladeCenter LS20 -[885055U]-
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc8-autotest-tip #1
Call Trace:
 [<ffffffff80237274>] warn_slowpath+0xd8/0xf5
 [<ffffffff80524be1>] _spin_lock_irqsave+0x9/0xe
 [<ffffffff8024c2fa>] up+0xe/0x37
 [<ffffffff80237945>] release_console_sem+0x186/0x1a1
 [<ffffffff80524be1>] _spin_lock_irqsave+0x9/0xe
 [<ffffffff8024c2fa>] up+0xe/0x37
 [<ffffffff80237945>] release_console_sem+0x186/0x1a1
 [<ffffffff80211d37>] stop_this_cpu+0x0/0x1d
 [<ffffffff80707394>] x86_64_start_kernel+0xde/0xe2
 [<ffffffff80707394>] x86_64_start_kernel+0xde/0xe2
 [<ffffffff80707394>] x86_64_start_kernel+0xde/0xe2
 [<ffffffff80237eb1>] printk+0x4e/0x56
 [<ffffffff80253dab>] smp_call_function_mask+0x36/0x224
 [<ffffffff80237eb1>] printk+0x4e/0x56
 [<ffffffff8034f386>] __next_cpu_nr+0x1a/0x21
 [<ffffffff8021e8d8>] touch_nmi_watchdog+0x43/0x53
 [<ffffffff8020f13d>] print_trace_address+0x1d/0x2d
 [<ffffffff80247747>] __kernel_text_address+0x1a/0x26
 [<ffffffff8020f20f>] print_context_stack+0x90/0xa6
 [<ffffffff80259d75>] crash_kexec+0xe6/0xef
 [<ffffffff8020e4a7>] dump_trace+0x249/0x258
 [<ffffffff80253fc3>] smp_call_function+0x2a/0x2f
 [<ffffffff8021d3e3>] native_smp_send_stop+0x1a/0x26
 [<ffffffff80237335>] panic+0x9a/0x144
 [<ffffffff80237eb1>] printk+0x4e/0x56
 [<ffffffff80239fd7>] do_exit+0x75/0x78f
 [<ffffffff8052579e>] oops_end+0xa8/0xad
 [<ffffffff80526fed>] do_page_fault+0x756/0x80f
 [<ffffffff80524daf>] page_fault+0x1f/0x30
 [<ffffffff80355720>] delay_loop+0x0/0x29
 [<ffffffff8070e46e>] init_ISA_irqs+0x18/0x53
 [<ffffffff8070e46c>] init_ISA_irqs+0x16/0x53
 [<ffffffff8070e4b2>] native_init_IRQ+0x9/0x9b5
 [<ffffffff8050e443>] register_cpu_notifier+0x1f/0x23
 [<ffffffff80707b25>] start_kernel+0x1c2/0x31d
 [<ffffffff80707394>] x86_64_start_kernel+0xde/0xe2
---[ end trace 4eaa2a86a8e2da22 ]---
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
