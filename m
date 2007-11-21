Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbXKUGjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbXKUGjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 01:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbXKUGi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 01:38:56 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:43055 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751955AbXKUGix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 01:38:53 -0500
From: Sripathi Kodi <sripathik@in.ibm.com>
To: linux-rt-users@vger.kernel.org
Subject: [PREEMPT_RT] LOCK_STAT and kexec: general protection fault
Date: Wed, 21 Nov 2007 12:08:38 +0530
User-Agent: KMail/1.9.4
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711211208.38776.sripathik@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On RT kernel, When CONFIG_LOCK_STAT is enabled, trying to load the kdump 
kernel (kexec -p) causes a kernel panic. I have seen slightly varying 
backtraces, but I see general protection fault every time.

Hardware: x86_64, 4CPUs, LS20 blade.
Kernel: 2.6.23.1-rt11.

I don't see this problem on non-rt kernels.

Kernstopped custom tracer.
general protection fault: 0000 [1] PREEMPT SMP
CPU 3
Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler autofs4 hidp rfcomm 
l2cap bluetooth sunrpc nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 
xt_state iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter 
ip6_tables x_tables ipv6 dm_mirror dm_multipath dm_mod video output sbs dock 
battery ac parport_pc lp parport joydev sg amd_rng rtc_cmos i2c_amd756 k8temp 
shpchp i2c_core rtc_core tg3 hwmon serio_raw rtc_lib button mptspi mptscsih 
scsi_transport_spi mptbase sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd 
uhci_hcd
Pid: 3540, comm: kexec Not tainted 2.6.23.1-rt11 #2
RIP: 0010:[<ffffffff8025ae13>]  [<ffffffff8025ae13>] 
__lock_acquire+0x6b2/0xca0
RSP: 0018:ffff8102118d7eb8  EFLAGS: 00010092
RAX: 0bbda08e8f9f3119 RBX: ffff8101fb4defd0 RCX: ffffffff80e31110
RDX: 0bbda08e8f9f3119 RSI: 000000000000000a RDI: 0000000000000001
RBP: ffff8102118d7f18 R08: 0000000000000002 R09: 0000000000000001
R10: ffffffff80275659 R11: fffffffffffff000 R12: 00000000000000e6
R13: ffff8101fb4de7c0 R14: 0000000000000000 R15: 00000000001225dc
FS:  00002b55f6778b00(0000) GS:ffff810211fbb940(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000032fc494ff0 CR3: 00000001fbfa0000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kexec (pid: 3540, threadinfo ffff8101fb518000, task ffff8101fb4de7c0)
Stack:  00000001b434a540 0000000000000002 0000000000000000 ffffffff8068dc90
 ffffffff80234dd8 ffff8102118d7f00 000000000000000a 0000000000000046
 ffffffff8068dc78 0000000000000003 ffffffff8068dc78 00000000001225dc
Call Trace:
 <IRQ>  [<ffffffff80234dd8>] wake_up_process+0x12/0x14
 [<ffffffff8025b45f>] lock_acquire+0x5e/0x77
 [<ffffffff80275659>] handle_edge_irq+0x29/0x158
 [<ffffffff804a1690>] __spin_lock+0x35/0x62
 [<ffffffff80275659>] handle_edge_irq+0x29/0x158
 [<ffffffff8020e5d2>] do_IRQ+0x80/0xea
 [<ffffffff8020c4a6>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8033b647>] copy_user_generic_string+0x17/0x40
 [<ffffffff80267f74>] sys_kexec_load+0x501/0x5dd
 [<ffffffff8020f17a>] syscall_trace_enter+0x95/0x99
 [<ffffffff8020c0f7>] tracesys+0xdc/0xe1

INFO: lockdep is turned off.

Code: 48 8b 10 0f 18 0a 48 39 c8 75 e4 f0 ff 0d 1b 5a 39 00 79 0d 
RIP  [<ffffffff8025ae13>] __lock_acquire+0x6b2/0xca0
 RSP <ffff8102118d7eb8>
Kernel panic - not syncing: Fatal exception

Call Trace:
 <IRQ>  [<ffffffff8023af69>] panic+0xaf/0x16e
 [<ffffffff802322d6>] task_rq_lock+0x42/0x74
 [<ffffffff804a0e7c>] rt_spin_unlock+0x1e/0x50
 [<ffffffff804a0e7c>] rt_spin_unlock+0x1e/0x50
 [<ffffffff804a2de0>] oops_end+0x69/0x72
 [<ffffffff8020d776>] die+0x4a/0x54
 [<ffffffff804a3440>] do_general_protection+0x116/0x11f
 [<ffffffff80258281>] put_lock_stats+0x2b/0x2d
 [<ffffffff804a294d>] error_exit+0x0/0x96
 [<ffffffff80275659>] handle_edge_irq+0x29/0x158
 [<ffffffff8025ae13>] __lock_acquire+0x6b2/0xca0
 [<ffffffff80234dd8>] wake_up_process+0x12/0x14
 [<ffffffff8025b45f>] lock_acquire+0x5e/0x77
 [<ffffffff80275659>] handle_edge_irq+0x29/0x158
 [<ffffffff804a1690>] __spin_lock+0x35/0x62
 [<ffffffff80275659>] handle_edge_irq+0x29/0x158
 [<ffffffff8020e5d2>] do_IRQ+0x80/0xea
 [<ffffffff8020c4a6>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8033b647>] copy_user_generic_string+0x17/0x40
 [<ffffffff80267f74>] sys_kexec_load+0x501/0x5dd
 [<ffffffff8020f17a>] syscall_trace_enter+0x95/0x99
 [<ffffffff8020c0f7>] tracesys+0xdc/0xe1

INFO: lockdep is turned off.

Thanks,
Sripathi.
