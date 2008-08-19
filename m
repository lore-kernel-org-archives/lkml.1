Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYHSTqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYHSTqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYHSTqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:46:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915AbYHSTqd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:46:33 -0400
Date: Tue, 19 Aug 2008 12:46:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Message-Id: <20080819124602.9e8e69f7.akpm@linux-foundation.org>
In-Reply-To: <48A36838.3050309@hp.com>
References: <48A36838.3050309@hp.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 19:03:20 -0400
"Alan D. Brunelle" <Alan.Brunelle@hp.com> wrote:

> I ran into this trying 2.6.27-rc3 today:
> 
> [6.461876] kernel BUG at mm/vmalloc.c:217!
> 
> (full boot log attached)
> 
> I bisected it to:
> 
> git-bisect bad 1c89ac55017f982355c7761e1c912c88c941483d
> 
> which is:
> 
> commit 1c89ac55017f982355c7761e1c912c88c941483d
> Merge: 88fa08f... b1b135c...
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Aug 12 08:40:19 2008 -0700
> 
>     Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus
> 
>     *
> git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus:
>       fix spinlock recursion in hvc_console
>       stop_machine: remove unused variable
>       modules: extend initcall_debug functionality to the module loader
>       export virtio_rng.h
>       lguest: use get_user_pages_fast() instead of get_user_pages()
>       mm: Make generic weak get_user_pages_fast and EXPORT_GPL it
>       lguest: don't set MAC address for guest unless specified
> 
> Backing out to the previous commit boots just fine. I've attached the
> boot.log, config file, lspci.txt and git-bisect-log. If there is
> anything else I can do, I'd be happy to oblige, but I'm checking out
> right now. I'll check in tomorrow morning (Eastern USA).
> 
> Alan
> 
> 
> [boot.log  text/plain (5.2KB)]
> [6.461876] kernel BUG at mm/vmalloc.c:217!

Please confirm that this happened at

static struct vm_struct *
__get_vm_area_node(unsigned long size, unsigned long flags, unsigned long start,
		unsigned long end, int node, gfp_t gfp_mask, void *caller)
{
	struct vm_struct **p, *tmp, *area;
	unsigned long align = 1;
	unsigned long addr;

-->	BUG_ON(in_interrupt());


> [6.461876] invalid opcode: 0000 [1] SMP
> [6.461876] CPU 1
> [6.461876] Modules linked in: processor(+) fan thermal_sys fuse
> [6.461876] Pid: 1256, comm: modprobe Not tainted 2.6.27-rc2 #14
> [6.461876] RIP: 0010:[<ffffffff802a227e>]  [<ffffffff802a227e>] __get_vm_area_node+0x1fe/0x210
> [6.461876] RSP: 0018:ffff88021b157538  EFLAGS: 00010206
> [6.461876] RAX: ffffffff8022151a RBX: ffffc20000000000 RCX: ffffe1ffffffffff
> [6.461876] RDX: 00000000ffffffff RSI: 00000000000000d0 RDI: 0000000000002000
> [6.461876] RBP: ffff88021b157578 R08: 00000000ffffffff R09: 00000000000000d0
> [6.461876] R10: 0000000000001000 R11: 0000000000000000 R12: 0000000000000010
> [6.461876] R13: 00000000cffc3000 R14: 00000000cffc3b51 R15: 00000000cffc480a
> [6.461876] FS:  00007f13ac7606e0(0000) GS:ffff88022fc02980(0000) knlGS:0000000000000000
> [6.461876] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [6.461876] CR2: 000000000044f360 CR3: 000000021ad66000 CR4: 00000000000006e0
> [6.461876] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [6.461876] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [6.461876] Process modprobe (pid: 1256, threadinfo ffff88021b156000, task ffff88021ac3c890)
> [6.461876] Stack:  ffffe1ffffffffff 0000000000000001 ffff88021b157558 0000000000002000
> [6.461876]  0000000000000010 00000000cffc3000 00000000cffc3b51 00000000cffc480a
> [6.461876]  ffff88021b157598 ffffffff802a2301 ffffffff8047f559 00000000cffc480a
> [6.461876] Call Trace:[1;88r[88;1H
> [6.461876]  [<ffffffff802a2301>] get_vm_area_caller+0x31/0x40
> [6.461876]  [<ffffffff8047f559>] ? acpi_os_map_memory+0x12/0x29
> [6.461876]  [<ffffffff80225078>] __ioremap_caller+0x188/0x340
> [6.461876]  [<ffffffff8047f559>] ? acpi_os_map_memory+0x12/0x29[1;88r[88;1H
> [6.461876]  [<ffffffff8038f1ce>] ? acpi_ex_system_memory_space_handler+0x0/0x1be[1;88r[88;1H
> [6.461876]  [<ffffffff80225342>] ioremap_nocache+0x12/0x20[1;88r[88;1H
> [6.461876]  [<ffffffff8047f559>] acpi_os_map_memory+0x12/0x29[1;88r[88;1H
> [6.461876]  [<ffffffff8038f2a0>] acpi_ex_system_memory_space_handler+0xd2/0x1be[1;88r[88;1H
> [6.461876]  [<ffffffff8038f1ce>] ? acpi_ex_system_memory_space_handler+0x0/0x1be[1;88r[88;1H
> [6.461876]  [<ffffffff8038805c>] acpi_ev_address_space_dispatch+0x172/0x1c1[1;88r[88;1H
> [6.461876]  [<ffffffff8038c5e8>] acpi_ex_access_region+0x209/0x226[1;88r[88;1H
> [6.461876]  [<ffffffff8038c6f4>] acpi_ex_field_datum_io+0xef/0x183[1;88r[88;1H
> [6.461876]  [<ffffffff8038c814>] acpi_ex_extract_from_field+0x8c/0x1a1[1;88r[88;1H
> [6.461876]  [<ffffffff8039ac13>] ? acpi_ut_create_internal_object_dbg+0x26/0x90[1;88r[88;1H
> [6.461876]  [<ffffffff8038b303>] acpi_ex_read_data_from_field+0x120/0x159[1;88r[88;1H
> [6.461876]  [<ffffffff8039018c>] acpi_ex_resolve_node_to_value+0x190/0x240[1;88r[88;1H
> [6.461876]  [<ffffffff8038bda2>] acpi_ex_resolve_to_value+0x256/0x268[1;88r[88;1H
> [6.461876]  [<ffffffff80386586>] acpi_ds_evaluate_name_path+0x7a/0xff[1;88r[88;1H
> [6.461876]  [<ffffffff8038522e>] acpi_ds_exec_end_op+0x94/0x3ca[1;88r[88;1H
> [6.461876]  [<ffffffff80395395>] acpi_ps_parse_loop+0x6a3/0x876[1;88r[88;1H
> [6.461876]  [<ffffffff803945de>] acpi_ps_parse_aml+0x7e/0x2bb[1;88r[88;1H
> [6.461876]  [<ffffffff80395b87>] acpi_ps_execute_method+0x129/0x1d6[1;88r[88;1H
> [6.461876]  [<ffffffff803927a8>] acpi_ns_evaluate+0x150/0x1b4[1;88r[88;1H
> [6.461876]  [<ffffffff803922b8>] acpi_evaluate_object+0x140/0x1fc[1;88r[88;1H
> [6.461876]  [<ffffffff8021bf37>] ? arch_acpi_processor_init_pdc+0x97/0x160[1;88r[88;1H
> [6.461876]  [<ffffffffa01971bd>] ? acpi_processor_notify+0x0/0x108 [processor][1;88r[88;1H
> [6.461876]  [<ffffffffa019b23e>] acpi_processor_start+0x612/0x774 [processor][1;88r[88;1H
> [6.461876]  [<ffffffff8031234b>] ? __sysfs_add_one+0x6b/0xa0[1;88r[88;1H
> [6.461876]  [<ffffffff803133de>] ? sysfs_do_create_link+0xbe/0x140[1;88r[88;1H
> [6.461876]  [<ffffffff8039d01a>] acpi_start_single_object+0x2d/0x52[1;88r[88;1H
> [6.461876]  [<ffffffff8039e603>] acpi_device_probe+0x7e/0x92[1;88r[88;1H
> [6.461876]  [<ffffffff803d195b>] driver_probe_device+0x9b/0x1a0[1;88r[88;1H
> [6.461876]  [<ffffffff803d1ae6>] __driver_attach+0x86/0x90[1;88r[88;1H
> [6.461876]  [<ffffffff803d1a60>] ? __driver_attach+0x0/0x90[1;88r[88;1H
> [6.461876]  [<ffffffff803d0f84>] bus_for_each_dev+0x54/0x80[1;88r[88;1H
> [6.461876]  [<ffffffff80359f0a>] ? kobject_get+0x1a/0x30[1;88r[88;1H
> [6.461876]  [<ffffffff803d179c>] driver_attach+0x1c/0x20[1;88r[88;1H
> [6.461876]  [<ffffffff803d15b9>] bus_add_driver+0x1e9/0x260[1;88r[88;1H
> [6.461876]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor][1;88r[88;1H
> [6.461876]  [<ffffffff803d1d7f>] driver_register+0x5f/0x140[1;88r[88;1H
> [6.461876]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor][1;88r[88;1H
> [6.461876]  [<ffffffff8039e913>] acpi_bus_register_driver+0x3e/0x40[1;88r[88;1H
> [6.461876]  [<ffffffffa0222094>] acpi_processor_init+0x94/0x107 [processor][1;88r[88;1H
> [6.461876]  [<ffffffff802a2a8d>] ? __vunmap+0x8d/0xf0[1;88r[88;1H
> [6.461876]  [<ffffffff80209040>] _stext+0x40/0x180[1;88r[88;1H
> [6.461876]  [<ffffffff80262902>] sys_init_module+0x142/0x1dc0[1;88r[88;1H
> [6.461876]  [<ffffffff8047e430>] ? cpu_down+0x0/0x70[1;88r[88;1H
> [6.461876]  [<ffffffff8020c34b>] system_call_fastpath+0x16/0x1b[1;88r[88;1H

Thing is, the code *isn't* in an interrupt.  Something got screwed up.

What can happen is that some code has a lock imbalance or a
preempt_disable imbalance and it does preempt_disable() so many times
that the counter overflows eight bits and starts to increment the
softirq counter, then the hardirq counter, then in_interrupt() starts
incorrectly returning true then blam.

You could confirm/debug it with something along the lines of this:

--- a/mm/vmalloc.c~a
+++ a/mm/vmalloc.c
@@ -214,7 +214,9 @@ __get_vm_area_node(unsigned long size, u
 	unsigned long align = 1;
 	unsigned long addr;
 
-	BUG_ON(in_interrupt());
+	if (preempt_count() > 10)
+		printk("%s: preempt_count()=%d\n", __func__, preempt_count());
+	WARN_ON(in_interrupt());
 	if (flags & VM_IOREMAP) {
 		int bit = fls(size);
 
_


But this bug could be in practically anywhere in the kernel and
bisection is by far the best way to find it.  It's sad and odd that
bisection landed you on a merge commit.  I'd suggest that you persist
with the bisection (please). 
http://www.kernel.org/doc/local/git-quick.html#example might be useful.



