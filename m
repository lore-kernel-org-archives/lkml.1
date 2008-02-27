Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbYB0Qz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbYB0Qz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 11:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbYB0QzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 11:55:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbYB0QzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 11:55:13 -0500
Date: Wed, 27 Feb 2008 11:44:06 -0500
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [patch 1/7] Immediate Values - Architecture Independent Code
Message-ID: <20080227164406.GA5539@redhat.com>
References: <20080202210828.840735763@polymtl.ca> <20080202211204.268876860@polymtl.ca> <20080226225242.GA15926@redhat.com> <20080226231248.GA32455@Krystal> <20080226233445.GA1297@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226233445.GA1297@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 06:34:45PM -0500, Mathieu Desnoyers wrote:
> > > In testing this patch, i've run across a deadlock...apply_imv_update() can get
> > > called again before, ipi_busy_loop() has had a chance to finsh, and set 
> > > wait_sync back to its initial value. This causes ipi_busy_loop() to get stuck
> > > indefinitely and the subsequent apply_imv_update() hangs. I've shown this 
> > > deadlock below using nmi_watchdog=1 in item 1). 
> > > 
> > 
> > Hrm, yes, Jan pointed out the exact same problem in my ltt-test-tsc TSC
> > test module in LTTng a few days ago. His fix implied to add another
> > barrier upon which the smp_call_function() caller must wait for the ipis
> > to finish. Since this immediate value code does the same I did in my
> > ltt-test-tsc code, the same fix will likely apply.
> > 
> > I'll cook something.
> > 
> 
> This should work. Untested for now. Can you give it a try ?
> 

this patch results in the subsequent 3 way deadlock that I described in the
previous mail. smp_call_function() can not be used with a function that 
attempts to rendezvous cpus in the manner being done here. The patch I posted 
in the previous mail addresses these limitations on smp_call_functions(). trace
of the lockup using this patch is shown below. 

thanks,

-Jason


NMI Watchdog detected LOCKUP on CPU 2
CPU 2
Modules linked in: toggle_tester ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf]Pid: 11233, comm: make Not tainted 2.6.24-git12markers #2
RIP: 0010:[<ffffffff811248d9>]  [<ffffffff811248d9>] __write_lock_failed+0x9/0x20
RSP: 0018:ffff81006e025e30  EFLAGS: 00000087
RAX: ffff81006ece8b58 RBX: 0000000000000000 RCX: ffff81006e1f0ec8
RDX: 0000000000000011 RSI: fe60000000000000 RDI: ffffffff813d4000
RBP: ffff81006e025e38 R08: ffff81006e1f0e90 R09: 00000000ffffffff
R10: ffff810072c45e98 R11: 0000000000004111 R12: 00000000fffffff4
R13: ffff81006ece8930 R14: ffff81006818b260 R15: 0000000000000000
FS:  00002b14168b66f0(0000) GS:ffff81007f801980(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000106f000 CR3: 00000000680d2000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process make (pid: 11233, threadinfo ffff81006e024000, task ffff81006818b260)
Stack:  ffffffff8127536a ffff81006e025ed8 ffffffff81034260 ffff81006e1f0e80
 0000000000000000 0000000000000000 ffff81006e025f58 00007fff94222fe0
 0000000000004111 ffff81006ece8930 0000000000000000 ffff81006ec6f040
Call Trace:
 [<ffffffff8127536a>] ? _write_lock_irq+0x13/0x15
 [<ffffffff81034260>] copy_process+0xf7c/0x1477
 [<ffffffff81034870>] do_fork+0x75/0x20a
 [<ffffffff8100c0e9>] ? tracesys+0xdc/0xe1
 [<ffffffff8100a3c6>] sys_vfork+0x20/0x22
 [<ffffffff8100c287>] ptregscall_common+0x67/0xb0

Code: e9 07 48 89 11 31 c0 c3 48 83 e9 07 eb 00 48 c7 c0 f2 ff ff ff c3 90 90 90 90 90 90 90 90
---[ end trace 6a2bbda3f47e95fd ]---
NMI Watchdog detected LOCKUP on CPU 3
CPU 3
Modules linked in: toggle_tester ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf]Pid: 3258, comm: toggle-writer Not tainted 2.6.24-git12markers #2
RIP: 0010:[<ffffffff8101c717>]  [<ffffffff8101c717>] __smp_call_function_mask+0x9f/0xc1
RSP: 0018:ffff81006ec51da8  EFLAGS: 00000297
RAX: 00000000000008fc RBX: 0000000000000007 RCX: 000000007688fa00
RDX: 00000000000008fc RSI: 00000000000000fc RDI: 0000000000000007
RBP: ffff81006ec51e08 R08: ffffffff8840504f R09: 00007fa6423566f0
R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff8106e7c3
FS:  00007fa6423566f0(0000) GS:ffff81007f801c80(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000031fb603080 CR3: 000000006ec49000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process toggle-writer (pid: 3258, threadinfo ffff81006ec50000, task ffff81007899a000)
Stack:  ffffffff8106e7c3 0000000000000000 0000000300000002 ffffffff00000000
 0000000000000007 0000000000000292 ffff81007899a000 0000000000000000
 0000000000000000 ffffffff8106e7c3 000000000000000f 0000000000000005
Call Trace:
 [<ffffffff8106e7c3>] ? ipi_busy_loop+0x0/0x55
 [<ffffffff8106e7c3>] ? ipi_busy_loop+0x0/0x55
 [<ffffffff8101c783>] smp_call_function_mask+0x4a/0x59
 [<ffffffff8101c7ab>] smp_call_function+0x19/0x1b
 [<ffffffff8106e702>] imv_update_range+0xd6/0x17e
 [<ffffffff8105494e>] _module_imv_update+0x35/0x54
 [<ffffffff81054982>] module_imv_update+0x15/0x23
 [<ffffffff884050c4>] :toggle_tester:proc_toggle_write+0x4c/0x64
 [<ffffffff810d64c8>] proc_reg_write+0x7b/0x96
 [<ffffffff81099f96>] vfs_write+0xae/0x157
 [<ffffffff8109a563>] sys_write+0x47/0x70
 [<ffffffff8100c0e9>] tracesys+0xdc/0xe1

Code: f8 48 3b 5d c0 48 8b 05 28 1a 41 00 75 0a bf fc 00 00 00 ff 50 38 eb 0f be fc 00 00 00 48
---[ end trace 6a2bbda3f47e95fd ]---
NMI Watchdog detected LOCKUP on CPU 1
CPU 1
Modules linked in: toggle_tester ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf]Pid: 0, comm: swapper Not tainted 2.6.24-git12markers #2
RIP: 0010:[<ffffffff8106e7dc>]  [<ffffffff8106e7dc>] ipi_busy_loop+0x19/0x55
RSP: 0018:ffff81007fb6ff70  EFLAGS: 00000002
RAX: 0000000000000008 RBX: 0000000000000000 RCX: ffff81007fb5f260
RDX: 000000000000000a RSI: 0000000000000046 RDI: 0000000000000000
RBP: ffff81007fb6ff78 R08: ffff81007fb6ff78 R09: 0000000000000002
R10: ffff810001018b80 R11: ffff810072dddc18 R12: ffffffff8106e7c3
R13: 0000000000000000 R14: ffffffff81491a80 R15: ffff810001018a80
FS:  0000000000000000(0000) GS:ffff81007f801680(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000031fac9afa0 CR3: 0000000072cfb000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff81007fb6a000, task ffff81007fb5f260)
Stack:  0000000000000000 ffff81007fb6ffa8 ffffffff8101ca4e ffff81007fb6ffa8
 ffffffff8100b0e2 0000000000000001 0000000000000040 ffff81007fb6be60
 ffffffff8100cac6 ffff81007fb6be60 <EOI>  ffff81007fb6bee8 ffff810072dddc18
Call Trace:
 <IRQ>  [<ffffffff8101ca4e>] smp_call_function_interrupt+0x48/0x71
 [<ffffffff8100b0e2>] ? mwait_idle+0x0/0x4a
 [<ffffffff8100cac6>] call_function_interrupt+0x66/0x70
 <EOI>  [<ffffffff8100b127>] ? mwait_idle+0x45/0x4a
 [<ffffffff8100a723>] ? enter_idle+0x22/0x24
 [<ffffffff8100b06f>] ? cpu_idle+0x97/0xc1
 [<ffffffff81270a55>] ? start_secondary+0x3ba/0x3c6

Code: 81 48 c7 c7 02 fd 36 81 48 89 e5 e8 6b fe ff ff c9 c3 55 48 89 e5 53 9c 5e fa f0 ff 0d 72
---[ end trace 6a2bbda3f47e95fd ]---
NMI Watchdog detected LOCKUP on CPU 0
Kernel panic - not syncing: Aiee, killing interrupt handler!
CPU 0
Modules linked in: toggle_tester ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf]Pid: 5, comm: watchdog/0 Not tainted 2.6.24-git12markers #2
RIP: 0010:[<ffffffff8106e7e9>]  [<ffffffff8106e7e9>] ipi_busy_loop+0x26/0x55
RSP: 0018:ffffffff81498f70  EFLAGS: 00000002
RAX: 0000000000000008 RBX: 0000000000000000 RCX: ffffffff81394620
RDX: 000000000000000a RSI: 0000000000000046 RDI: 0000000000000000
RBP: ffffffff81498f78 R08: ffffffff81498f78 R09: ffff81000100cbe0
R10: ffff81007fb59e20 R11: 0000000000000001 R12: ffffffff8106e7c3
R13: 0000000000000000 R14: 00000000000000f0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff813d2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000006bb374 CR3: 000000006ec88000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process watchdog/0 (pid: 5, threadinfo ffff81007fb58000, task ffff81007fb54930)
Stack:  0000000000000000 ffffffff81498fa8 ffffffff8101ca4e ffffffff884059c8
 ffff81007e4d3260 ffff81007e4d3260 00000000000003b2 ffff81007fb59e60
 ffffffff8100cac6 ffff81007fb59e60 <EOI>  ffff81007fb59f20 0000000000000001
Call Trace:
 <IRQ>  [<ffffffff8101ca4e>] smp_call_function_interrupt+0x48/0x71
 [<ffffffff8100cac6>] call_function_interrupt+0x66/0x70
 <EOI>  [<ffffffff81069685>] ? watchdog+0xd5/0x1c8
 [<ffffffff810695b0>] ? watchdog+0x0/0x1c8
 [<ffffffff81047fd3>] ? kthread+0x49/0x76
 [<ffffffff8100cd88>] ? child_rip+0xa/0x12
 [<ffffffff81047f8a>] ? kthread+0x0/0x76
 [<ffffffff8100cd7e>] ? child_rip+0x0/0x12

