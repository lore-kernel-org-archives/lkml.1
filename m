Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbXE1REB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbXE1REB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 13:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbXE1RDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 13:03:54 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60835 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbXE1RDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 13:03:53 -0400
Date: Mon, 28 May 2007 19:03:40 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: clameter@sgi.com
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: 2.6.22-rc2-mm1: SLUB-related panic
Message-ID: <Pine.LNX.4.64.0705281858200.8531@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when trying to reproduce a bugreport in bugzilla, I am experiencing panics 
upon boot. The .config which causes this is at [1]

I'd guess that it's some race - I have tried adding a few debug printk()s 
into mm/slub.c for __kmalloc_track_caller() and slab_alloc(), and the 
problem seems to have vanished after this.

The panic happens alternatively on the following two traces:

BUG: unable to handle kernel paging request at virtual address 75646f6d
 printing eip:
c0264b45
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in:
CPU:    0
EIP:    0060:[<c0264b45>]    Not tainted VLI
EFLAGS: 00010002   (2.6.22-rc2-mm1 #82)
EIP is at __kmalloc_track_caller+0x4f/0x60
eax: 00000000   ebx: 00000282   ecx: 75646f6d   edx: c10705b0
esi: c05602c8   edi: 000000d0   ebp: c02a3cd1   esp: c21c5db8
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process modprobe (pid: 715, ti=c21c4000 task=c23d0af0 task.ti=c21c4000)
Stack: c0561500 c2b04d8b c2b04d84 c2b04d84 c2b04d8c 00000008 c0252594 
00000000
       00000002 c2b04d84 c2b04d84 00000000 00000002 c02a3cd1 c0483012 
c2b04d84
       41ed4d84 c2b04d84 c2614dc0 c2b04d8c c2614dc0 c02a3e43 00000000 
c2614d20
Call Trace:
 [<c0252594>] kstrdup+0x27/0x46
 [<c02a3cd1>] sysfs_new_dirent+0x52/0xde
 [<c02a3e43>] create_dir+0x78/0x177
 [<c02a3f8b>] sysfs_create_dir+0x49/0x63
 [<c02dde46>] kobject_shadow_add+0xdc/0x183
 [<c02ddfd7>] kobject_register+0x19/0x30
 [<c02de12d>] kobject_kset_add_dir+0x46/0x75
 [<c02391de>] mod_sysfs_setup+0x2f/0x8e
 [<c023a8cd>] sys_init_module+0x14c2/0x181e
 [<c02025fa>] sysenter_past_esp+0x5f/0x85
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
Code: 00 00 00 85 d2 74 06 83 7a 0c 00 75 17 89 54 24 04 83 c9 ff 89 fa 89 
f0 89 2c 24 e8 04 e6 ff ff 89 c1 eb 0d 0f b7 42 0a 8b 4a 0c <8b> 04 81 89 
42 0c 53 9d 89 c8 5b 5e 5b 5e
EIP: [<c0264b45>] __kmalloc_track_caller+0x4f/0x60 SS:ESP 0068:c21c5db8
BUG: sleeping function called from invalid context at kernel/rwsem.c:20
in_atomic():0, irqs_disabled():1
INFO: lockdep is turned off.
 [<c02035ff>] dump_trace+0x68/0x1d9
 [<c0203788>] show_trace_log_lvl+0x18/0x2c
 [<c0204237>] show_trace+0xf/0x11
 [<c020424b>] dump_stack+0x12/0x14
 [<c022e88a>] down_read+0x15/0x49
 [<c023e3e8>] acct_collect+0x38/0x140
 [<c021e742>] do_exit+0x1d5/0x747
 [<c0203d4c>] die+0x1e2/0x20e
 [<c03ec148>] do_page_fault+0x476/0x549
 [<c03eaa2a>] error_code+0x72/0x78
 [<c0264b45>] __kmalloc_track_caller+0x4f/0x60
 [<c0252594>] kstrdup+0x27/0x46
 [<c02a3cd1>] sysfs_new_dirent+0x52/0xde
 [<c02a3e43>] create_dir+0x78/0x177
 [<c02a3f8b>] sysfs_create_dir+0x49/0x63
 [<c02dde46>] kobject_shadow_add+0xdc/0x183
 [<c02ddfd7>] kobject_register+0x19/0x30
 [<c02de12d>] kobject_kset_add_dir+0x46/0x75
 [<c02391de>] mod_sysfs_setup+0x2f/0x8e
 [<c023a8cd>] sys_init_module+0x14c2/0x181e
 [<c02025fa>] sysenter_past_esp+0x5f/0x85
 [<ffffe410>] 0xffffe410
 =======================


and the second one:

BUG: unable to handle kernel paging request at virtual address 75646f6d
 printing eip:
c0263c14
*pde = 00000000
Oops: 0000 [#2]
PREEMPT SMP
Modules linked in:
CPU:    0
EIP:    0060:[<c0263c14>]    Not tainted VLI
EFLAGS: 00010002   (2.6.22-rc2-mm1 #82)
EIP is at __kmalloc+0x51/0x62
eax: 00000000   ebx: 00000282   ecx: 75646f6d   edx: c10705b0
esi: c05602c8   edi: c030a4d6   ebp: 000000d0   esp: c20c3db8
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process kacpid (pid: 40, ti=c20c2000 task=c20841a0 task.ti=c20c2000)
Stack: 00000046 43455047 00000007 00000000 00000001 f8808ede c030a4d6 
00000003
       00000000 c048c578 00000000 c21fc4e0 c21fc4e0 00000000 c030a746 
00000000
       00000001 00000004 00000040 c20c3e38 f8808ede c21fc4e0 c21fc4e0 
c2b49800
Call Trace:
 [<c030a4d6>] acpi_ex_allocate_name_string+0x36/0xa2
 [<c030a746>] acpi_ex_get_name_string+0x137/0x1c1
 [<c0305d1e>] acpi_ds_create_operand+0x3a/0x1d6
 [<c0305edb>] acpi_ds_create_operands+0x21/0x6e
 [<c0304ee5>] acpi_ds_exec_end_op+0x76/0x3d1
 [<c0313e65>] acpi_ps_parse_loop+0x5b4/0x76f
 [<c03132a2>] acpi_ps_parse_aml+0x60/0x23d
 [<c0314520>] acpi_ps_execute_method+0x11b/0x1bb
 [<c0311841>] acpi_ns_evaluate+0x99/0xf0
 [<c03093b5>] acpi_ev_asynch_execute_gpe_method+0xa2/0x108
 [<c0302df7>] acpi_os_execute_deferred+0x22/0x30
 [<c0228e01>] run_workqueue+0x77/0x121
 [<c02296c0>] worker_thread+0xba/0xc6
 [<c022bcdd>] kthread+0x38/0x5f
 [<c020321b>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
Code: 00 00 00 85 d2 74 06 83 7a 0c 00 75 17 89 54 24 04 83 c9 ff 89 ea 89 
f0 89 3c 24 e8 35 f5 ff ff 89 c1 eb 0d 0f b7 42 0a 8b 4a 0c <8b> 04 81 89 
42 0c 53 9d 89 c8 5d 5a 5b 5e
EIP: [<c0263c14>] __kmalloc+0x51/0x62 SS:ESP 0068:c20c3db8


(always the same address being dereferenced).

[1] http://www.jikos.cz/jikos/junk/.config

-- 
Jiri Kosina
