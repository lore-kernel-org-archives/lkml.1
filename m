Return-Path: <linux-kernel-owner+w=401wt.eu-S1764950AbZLQRDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764950AbZLQRDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764941AbZLQRDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:03:18 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:58580 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764931AbZLQRDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:03:16 -0500
Date: Thu, 17 Dec 2009 22:33:09 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [Bug][perf hw-breakpoints] Null pointer exception when using
	register_user_hw_breakpoint with inherit flag
Message-ID: <20091217170309.GA5457@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  While testing out two new interfaces (to be sent separately) that
in-turn uses register_user_hw_breakpoint() and unregister_hw_breakpoint(),
I noticed the following error.

The bug is seen only when 'inherit' flag of 'perf_event_attr' is set
(not otherwise) before the call to register_user_hw_breakpoint(),
and when the user-space process tries to spawn a new thread.

Please find the screen logs taken from an x86 box, running -tip kernel 
commit 7818b3d0fc68f5c2a85fed86d9fa37131c5a3068.

Digging further, the causative line of code appears to be

	atomic_long_inc(&parent_event->filp->f_count);

in inherit_event() function, wherein f_count is NULL (and hence the
error). I haven't analysed further to understand why/if the said
pointer is/should be NULL.

Thought might bring it to the community's notice for wider
notice/further investigation.

Thanks,
K.Prasad

Error message
--------------
BUG: unable to handle kernel NULL pointer dereference at 00000038
IP: [<c04a1827>] inherit_event+0x90/0xf9
*pde = 00000000 
Oops: 0002 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu3/topology/core_siblings
Modules linked in: data_breakpoint_2 stap_7360b82bc2f92256437d244aa8ebe5e6_2590 ipt_MASQUERADE iptable_nat nf_nat sco bridge stp bnep l2cap crc16 bluetooth ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 p4_clockmod dm_multipath uinput joydev ppdev pcspkr ata_generic pata_acpi aic7xxx serio_raw tg3 i2c_piix4 e1000 pata_serverworks e100 libphy mii i2c_core ibmasm parport_pc parport floppy mptspi mptscsih mptbase scsi_transport_spi [last unloaded: scsi_wait_scan]

Pid: 5098, comm: probe7-thread Not tainted 2.6.32-tip.latest+ #1 /eserver xSeries 235 -[86714AX]-
EIP: 0060:[<c04a1827>] EFLAGS: 00010246 CPU: 2
EIP is at inherit_event+0x90/0xf9
EAX: 00000038 EBX: f6d4c850 ECX: f6e8baa8 EDX: 00000000
ESI: f582cf90 EDI: f6e8baa0 EBP: eb47de6c ESP: eb47de60
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process probe7-thread (pid: 5098, ti=eb47d000 task=ea171580 task.ti=eb47d000)
Stack:
 f6d4cbe0 00000000 f6d4c850 eb47deb4 c04a1a08 ea2bd600 00000000 f6d4c850
<0> ea2bd608 ea2bd600 f6d4cc04 f6d4cc54 f582cf90 ea171580 00000001 ea2bd7ac
<0> eb47deb4 00000282 ea2bd600 00000000 ea2be2d4 eb47df14 c04395cd c314c550
Call Trace:
 [<c04a1a08>] ? perf_event_init_task+0x122/0x20d
 [<c04395cd>] ? copy_process+0x560/0x10cd
 [<c043a257>] ? do_fork+0x11d/0x297
 [<c072bda1>] ? do_page_fault+0x2f6/0x324
 [<c04815b1>] ? audit_syscall_entry+0x11b/0x140
 [<c04092d2>] ? sys_clone+0x24/0x29
 [<c0403331>] ? ptregs_clone+0x15/0x24
 [<c072972d>] ? syscall_call+0x7/0xb
Code: 00 89 87 f8 00 00 00 89 97 fc 00 00 00 8b 86 70 02 00 00 89 da 89 87 70 02 00 00 89 f8 e8 5b eb ff ff 8b 96 34 01 00 00 8d 42 38 <f0> ff 42 38 8b 86 30 01 00 00 83 b8 ac 00 00 00 00 74 1f 80 3d 
EIP: [<c04a1827>] inherit_event+0x90/0xf9 SS:ESP 0068:eb47de60
CR2: 0000000000000038
---[ end trace 2f6ec1ff2cce0ff3 ]---
