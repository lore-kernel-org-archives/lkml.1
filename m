Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYFEJr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYFEJr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYFEJrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:47:18 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:42279 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbYFEJrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:47:17 -0400
Message-ID: <4847B53A.7030006@linux.vnet.ibm.com>
Date: Thu, 05 Jun 2008 15:13:22 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Segher Boessenkool <segher@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, Sam Ravnborg <sam@ravnborg.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: [BUILD-FAILURE] linux-next: Tree for June 4 - firmware/keyspan/mpr.fw.gen.S
References: <20080604180025.3ecd03ff.sfr@canb.auug.org.au> <48468091.5000102@linux.vnet.ibm.com> <1212580245.32207.51.camel@pmac.infradead.org> <54a3f4cc48b03f9fe63be0bcd7c2ab20@kernel.crashing.org> <1212601930.32207.134.camel@pmac.infradead.org>
In-Reply-To: <1212601930.32207.134.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Wed, 2008-06-04 at 19:19 +0200, Segher Boessenkool wrote:
>> It is a new feature in GNU make 3.81, which was released slightly
>> over two years ago.
> 
> Hm, Ok. I'll stick in a workaround. Thanks.
> 
> diff --git a/firmware/Makefile b/firmware/Makefile
> index b4f758a..166a9b0 100644
> --- a/firmware/Makefile
> +++ b/firmware/Makefile
> @@ -83,6 +83,13 @@ wordsize_deps := $(wildcard include/config/64bit.h include/config/32bit.h \
>  		include/config/superh32.h include/config/superh64.h \
>  		include/config/x86_32.h include/config/x86_64.h)
> 
> +# Workaround for ancient versions of make, where .SECONDEXPANSION doesn't work.
> +# It'll end up depending on these targets, so make them a PHONY rule which
> +# depends on _all_ the directories in $(firmware-dirs), and it'll work out OK.
> +PHONY += $(objtree)/$$(%) $(objtree)/$(obj)/$$(%)
> +$(objtree)/$$(%) $(objtree)/$(obj)/$$(%): $(firmware-dirs)
> +	@true
> +
>  # For the $$(dir %) trick, where we need % to be expanded first.
>  .SECONDEXPANSION:
The make version used is 
# make -v
GNU Make 3.80

Thanks the patch, the build failure is fixed but the kernel panics while
booting the machine

BUG: unable to handle kernel paging request at 0000000000003708
IP: [<ffffffff8026cd89>] __alloc_pages_internal+0xc0/0x3d3
PGD 0 
Oops: 0000 [1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc4-next-20080604-autotest #1
RIP: 0010:[<ffffffff8026cd89>]  [<ffffffff8026cd89>] __alloc_pages_internal+0xc0/0x3d3
RSP: 0000:ffff81003f9e1c00  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000000012d0 RCX: 0000000000000000
RDX: 0000000000003700 RSI: 00000000000005c4 RDI: ffffffff805cfb76
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000018
R10: 0000000000000003 R11: ffffffff8035677d R12: 0000000000003700
R13: 0000000000000000 R14: ffff81003f9d8000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffffffff806afe80(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000003708 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f9e0000, task ffff81003f9d8000)
Stack:  0000000000000000 0000000000000000 ffff81000103b000 0000000200000010
 0000000000000000 0000000000000000 00000000ffffffff ffffffff80399b6b
 ffff81000103b000 ffff8100010118e0 0000000000000001 00000000000000d0
Call Trace:
 [<ffffffff80399b6b>] notify_update+0x2b/0x30
 [<ffffffff8028bb77>] new_slab+0x91/0x268
 [<ffffffff8028bf64>] __slab_alloc+0x1d5/0x3c1
 [<ffffffff8022ce21>] __build_sched_domains+0x688/0x9eb
 [<ffffffff8022c629>] sched_domain_node_span+0xc9/0xf3
 [<ffffffff8028c457>] kmem_cache_alloc_node+0x3e/0x73
 [<ffffffff8022ce21>] __build_sched_domains+0x688/0x9eb
 [<ffffffff806d0f72>] setup_ioapic_dest+0x30/0xd7
 [<ffffffff8022d5dc>] arch_init_sched_domains+0x69/0x76
 [<ffffffff806d51d5>] sched_init_smp+0x4f/0x123
 [<ffffffff806c28cc>] kernel_init+0xf6/0x28f
 [<ffffffff804fb831>] _spin_unlock_irq+0x9/0xc
 [<ffffffff8022e595>] finish_task_switch+0x38/0x9e
 [<ffffffff8020cb18>] child_rip+0xa/0x12
 [<ffffffff806c27d6>] kernel_init+0x0/0x28f
 [<ffffffff8020cb0e>] child_rip+0x0/0x12


Code: 25 00 00 00 00 83 7c 24 18 00 74 16 be c4 05 00 00 48 c7 c7 76 fb 5c 80 e8 98 c8 fb ff e8 29 d4 28 00 48 c7 44 24 28 00 00 00 00 <49> 83 7c 24 08 00 74 90 89 d9 44 8b 44 24 1c 48 8b 74 24 08 81 
RIP  [<ffffffff8026cd89>] __alloc_pages_internal+0xc0/0x3d3
 RSP <ffff81003f9e1c00>
CR2: 0000000000003708
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D   2.6.26-rc4-next-20080604-autotest #1

Call Trace:
 [<ffffffff802327c3>] panic+0x86/0x144
 [<ffffffff80233373>] printk+0x4e/0x56
 [<ffffffff802356dc>] do_exit+0x71/0x67c
 [<ffffffff804fbd41>] oops_begin+0x0/0x8c
 [<ffffffff804fdc54>] do_page_fault+0x77b/0x834
 [<ffffffff8039dcc6>] vt_console_print+0x26f/0x293
 [<ffffffff804fb989>] error_exit+0x0/0x51
 [<ffffffff8035677d>] vgacon_cursor+0x0/0x1a4
 [<ffffffff8026cd89>] __alloc_pages_internal+0xc0/0x3d3
 [<ffffffff80399b6b>] notify_update+0x2b/0x30
 [<ffffffff8028bb77>] new_slab+0x91/0x268
 [<ffffffff8028bf64>] __slab_alloc+0x1d5/0x3c1
 [<ffffffff8022ce21>] __build_sched_domains+0x688/0x9eb
 [<ffffffff8022c629>] sched_domain_node_span+0xc9/0xf3
 [<ffffffff8028c457>] kmem_cache_alloc_node+0x3e/0x73
 [<ffffffff8022ce21>] __build_sched_domains+0x688/0x9eb
 [<ffffffff806d0f72>] setup_ioapic_dest+0x30/0xd7
 [<ffffffff8022d5dc>] arch_init_sched_domains+0x69/0x76
 [<ffffffff806d51d5>] sched_init_smp+0x4f/0x123
 [<ffffffff806c28cc>] kernel_init+0xf6/0x28f
 [<ffffffff804fb831>] _spin_unlock_irq+0x9/0xc
 [<ffffffff8022e595>] finish_task_switch+0x38/0x9e
 [<ffffffff8020cb18>] child_rip+0xa/0x12
 [<ffffffff806c27d6>] kernel_init+0x0/0x28f
 [<ffffffff8020cb0e>] child_rip+0x0/0x12
--
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
