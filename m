Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYL2LA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYL2LA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYL2LAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:00:20 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:40059 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbYL2LAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:00:19 -0500
Date: Mon, 29 Dec 2008 16:30:12 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
Message-ID: <20081229110012.GB11111@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu> <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com> <20081227173839.GA9793@elte.hu> <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain> <20081228232729.GA2158@elte.hu> <20081228233028.GA14697@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081228233028.GA14697@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2008-12-29 00:30:28]:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> >   b2e2fe9: sparseirq: work around __weak alias bug
> 
> here's that fix, standalone too. Kamalesh, i think this should finally fix 
> the crash you are seeing.
> 
> 	Ingo
> 
> ---------------->
> From b2e2fe99628c4f944c3075258e536197b5a4f3f8 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 29 Dec 2008 00:16:45 +0100
> Subject: [PATCH] sparseirq: work around __weak alias bug
> 
> Impact: fix boot crash if the kernel is built with certain GCC versions
> 
> GCC has a bug with __weak alias functions: if the functions are in
> the same compilation unit as their call site, GCC can decide to
> inline them - and thus rob the linker of the opportunity to override
> the weak alias with the real thing.
> 
> This can lead to the boot crash reported by Kamalesh Babulal:
> 
>  ACPI: Core revision 20080926
>  Setting APIC routing to flat
>  BUG: unable to handle kernel NULL pointer dereference at
>  0000000000000000
>  IP: [<ffffffff8021f9a8>] add_pin_to_irq_cpu+0x14/0x74
>  PGD 0
>  Oops: 0000 [#1] SMP
>  [...]
> 
> So move the arch_init_chip_data() function from handle.c to manage.c.
> 
> Reported-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/irq/handle.c |    5 -----
>  kernel/irq/manage.c |    9 +++++++++
>  2 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index 157c04c..c20db0b 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -86,11 +86,6 @@ void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
>  		desc->kstat_irqs = (unsigned int *)ptr;
>  }
> 
> -int __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
> -{
> -	return 0;
> -}
> -
>  static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
>  {
>  	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 46953a0..c2741b0 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -261,6 +261,15 @@ void enable_irq(unsigned int irq)
>  }
>  EXPORT_SYMBOL(enable_irq);
> 
> +/*
> + * [ Not in kernel/irq/handle.c, so that GCC does not
> + *   inline the __weak alias: ]
> + */
> +int __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
> +{
> +	return 0;
> +}
> +
>  static int set_irq_wake_real(unsigned int irq, unsigned int on)
>  {
>  	struct irq_desc *desc = irq_to_desc(irq);

Hi Ingo,

	kernel crashes after applying the patch, I will retest with 
the patch posted at http://lkml.org/lkml/2008/12/29/48

Setting APIC routing to flat
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff8021f9a8>] add_pin_to_irq_cpu+0x14/0x74
PGD 0 
Oops: 0000 [#1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.28-autotest-tip #1
RIP: 0010:[<ffffffff8021f9a8>]  [<ffffffff8021f9a8>] add_pin_to_irq_cpu+0x14/0x74
RSP: 0018:ffff88003f9d7e40  EFLAGS: 00010282
RAX: ffffffff8073c300 RBX: 0000000000000001 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000018 R09: 0000000000000002
R10: 000000000000000f R11: ffffffff8021e8aa R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80855480(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88003f9d6000, task ffff88003f9d8000)
Stack:
 0000000000000000 0000000000000001 ffffffff8073c300 0000000000000001
 0000000000000001 ffffffff80874282 0000000000000286 0000000000000286
 0000000000010000 0000000000000206 0000000000000002 0000000000000002
Call Trace:
 [<ffffffff80874282>] setup_IO_APIC+0x12f/0x720
 [<ffffffff80525711>] _spin_lock_irqsave+0x9/0xe
 [<ffffffff8022221b>] get_apic_id+0x0/0x9
 [<ffffffff8087116f>] native_smp_prepare_cpus+0x256/0x2f1
 [<ffffffff808637ca>] kernel_init+0x50/0x1eb
 [<ffffffff8020ce9a>] child_rip+0xa/0x20
 [<ffffffff8086377a>] kernel_init+0x0/0x1eb
 [<ffffffff8020ce90>] child_rip+0x0/0x20
Code: 48 c7 c7 8d 3c 5f 80 31 c0 e8 08 8d 01 00 5b 4c 89 e0 41 5c 41 5d c3 41 55 49 89 fd 89 f7 41 54 41 89 cc 55 89 d5 53 48 83 ec 08 <49> 8b 5d 00 48 85 db 75 36 e8 88 ff ff ff 48 85 c0 75 19 41 5b 
RIP  [<ffffffff8021f9a8>] add_pin_to_irq_cpu+0x14/0x74
 RSP <ffff88003f9d7e40>
CR2: 0000000000000000
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D    2.6.28-autotest-tip #1
Call Trace:
 [<ffffffff80237b4d>] panic+0x86/0x144
 [<ffffffff802373f4>] mm_release+0x3f/0xd3
 [<ffffffff802393b2>] exit_fs+0x35/0x46
 [<ffffffff8023a842>] do_exit+0x75/0x787
 [<ffffffff805262ce>] oops_end+0xa8/0xad
 [<ffffffff80527b1d>] do_page_fault+0x756/0x80f
 [<ffffffff805258df>] page_fault+0x1f/0x30
 [<ffffffff8021e8aa>] native_apic_mem_write+0x0/0x9
 [<ffffffff8021f9a8>] add_pin_to_irq_cpu+0x14/0x74
 [<ffffffff80874282>] setup_IO_APIC+0x12f/0x720
 [<ffffffff80525711>] _spin_lock_irqsave+0x9/0xe
 [<ffffffff8022221b>] get_apic_id+0x0/0x9
 [<ffffffff8087116f>] native_smp_prepare_cpus+0x256/0x2f1
 [<ffffffff808637ca>] kernel_init+0x50/0x1eb
 [<ffffffff8020ce9a>] child_rip+0xa/0x20
 [<ffffffff8086377a>] kernel_init+0x0/0x1eb
 [<ffffffff8020ce90>] child_rip+0x0/0x20
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
