Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbYHTGvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbYHTGvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 02:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYHTGvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 02:51:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601AbYHTGvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 02:51:32 -0400
Date: Tue, 19 Aug 2008 23:51:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "the arch/x86 maintainers" <x86@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: ioremap panic
Message-Id: <20080819235106.d6776abc.akpm@linux-foundation.org>
In-Reply-To: <86802c440808162049u12fc92c4teae43c9b6f4a72b8@mail.gmail.com>
References: <86802c440808162049u12fc92c4teae43c9b6f4a72b8@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008 20:49:29 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> qla2xxx 0000:83:00.1: PCI INT B -> Link[LE3C] -> GSI 42 (level, low) -> IRQ 42
> ------------[ cut here ]------------
> kernel BUG at lib/ioremap.c:26!

static int ioremap_pte_range(pmd_t *pmd, unsigned long addr,
		unsigned long end, unsigned long phys_addr, pgprot_t prot)
{
	pte_t *pte;
	unsigned long pfn;

	pfn = phys_addr >> PAGE_SHIFT;
	pte = pte_alloc_kernel(pmd, addr);
	if (!pte)
		return -ENOMEM;
	do {
-->		BUG_ON(!pte_none(*pte));

> invalid opcode: 0000 [1] SMP
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> CPU 4
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.27-rc3-tip-00452-g60e3132-dirty #58
> RIP: 0010:[<ffffffff804b8aa2>]  [<ffffffff804b8aa2>]
> ioremap_page_range+0x1b2/0x228
> RSP: 0018:ffff881824c97a50  EFLAGS: 00010206
> RAX: 00003e00beed2000 RBX: ffffc2001f126000 RCX: 00000000000ddff8
> RDX: ffff8810224de930 RSI: ffffc2001f127000 RDI: ffffc2001f126000
> RBP: ffff881824c97ac0 R08: ffff880844223890 R09: ffffffff80ea99a0
> R10: 0000000080000000 R11: 000000000000000a R12: ffffc2001f127000
> R13: ffffc2001f127000 R14: ffffffff80201c20 R15: ffff881827c017c0
> FS:  0000000000000000(0000) GS:ffff881024c83400(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff881824c96000, task ffff881024ca0000)
> Stack:  ffff881824c97aa0 ffffc2001f126fff ffffc2001f126fff ffffc2001f126fff
>  ffffc2001f127000 ffffc2001f127000 ffff881027c01000 8000000000000173
>  00003e00beed2000 8000000000000173 0000000000000010 ffffc2001f126000
> Call Trace:
>  [<ffffffff8024211e>] __ioremap_caller+0x246/0x2cd
>  [<ffffffff8093ac5d>] ? qla2x00_probe_one+0x436/0xf96
>  [<ffffffff8024228e>] ioremap_nocache+0x17/0x19
>  [<ffffffff8093ac5d>] qla2x00_probe_one+0x436/0xf96
>  [<ffffffff804c0626>] ? __bitmap_weight+0x3e/0x89
>  [<ffffffff802566f1>] ? set_cpus_allowed_ptr+0x113/0x120
>  [<ffffffff804b8dcc>] ? kobject_get+0x1a/0x22
>  [<ffffffff804ca903>] pci_device_probe+0xd1/0x131
>  [<ffffffff8053f7e8>] driver_probe_device+0xc5/0x173
>  [<ffffffff8053f8ea>] __driver_attach+0x54/0x7e
>  [<ffffffff8053f896>] ? __driver_attach+0x0/0x7e
>  [<ffffffff8053f03e>] bus_for_each_dev+0x54/0x8e
>  [<ffffffff804b8dcc>] ? kobject_get+0x1a/0x22
>  [<ffffffff8053f624>] driver_attach+0x21/0x23
>  [<ffffffff8053e92c>] bus_add_driver+0xbc/0x206
>  [<ffffffff8053fafc>] driver_register+0xad/0x12d
>  [<ffffffff804cabd5>] __pci_register_driver+0x6b/0xa6
>  [<ffffffff80efcb01>] ? qla2x00_module_init+0x0/0x12c
>  [<ffffffff80efcbfd>] qla2x00_module_init+0xfc/0x12c
>  [<ffffffff8020904c>] _stext+0x4c/0x144
>  [<ffffffff802695e7>] ? start_workqueue_thread+0x2b/0x2f
>  [<ffffffff80269a09>] ? __create_workqueue_key+0x112/0x22c
>  [<ffffffff80ed378f>] kernel_init+0x228/0x29d
>  [<ffffffff80227ff9>] child_rip+0xa/0x11
>  [<ffffffff80ed3567>] ? kernel_init+0x0/0x29d
>  [<ffffffff80227fef>] ? child_rip+0x0/0x11
> Code: 00 00 00 00 88 ff ff 48 01 c2 48 89 d8 48 c1 e8 09 25 f8 0f 00
> 00 48 01 c2 48 8b 45 d0 48 8d 0c 03 48 c1 e9 0c 48 83 3a 00 74 04 <0f>
> 0b eb fe 48 89 c8 48 81 c3 00 10 00 00 48 c1 e0 0c 48 0b 45
> RIP  [<ffffffff804b8aa2>] ioremap_page_range+0x1b2/0x228
>  RSP <ffff881824c97a50>

Please work out what address qla2x00_probe_one() passed into ioremap(),
then see if you can work out what was already at that virtual address
(/proc/iomem, dmesg output, etc).


