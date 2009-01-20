Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbZATGa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbZATGa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 01:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZATGaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 01:30:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63232 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbZATGaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 01:30:08 -0500
Message-ID: <49756F44.6040801@cn.fujitsu.com>
Date: Tue, 20 Jan 2009 14:29:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] kernel BUG at arch/x86/kernel/tlb_32.c:130!
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was using mmotm 2009-01-16-16-18, and I ran into this BUG,
the line is:
	BUG_ON(cpumask_empty(cpumask));

I suspect it is caused by:

commit 4595f9620cda8a1e973588e743cf5f8436dd20c6
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Jan 10 21:58:09 2009 -0800

    x86: change flush_tlb_others to take a const struct cpumask

    Impact: reduce stack usage, use new cpumask API.

?

------------[ cut here ]------------
kernel BUG at arch/x86/kernel/tlb_32.c:130!
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/irq
Modules linked in: bridge stp llc autofs4 dm_mirror dm_region_hash dm_log dm_mod parport_pc r8169 parport mii sg button sata_sis pata_sis ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]

Pid: 16050, comm: test6.sh Not tainted (2.6.29-rc2-mm1 #3) Aspire SA85
EIP: 0060:[<c04147ec>] EFLAGS: 00210202 CPU: 1
EIP is at native_flush_tlb_others+0x20/0xf1
EAX: 00000001 EBX: e6f03390 ECX: 00000004 EDX: e6fe0a30
ESI: e6f03200 EDI: ffffffff EBP: e6e8bd9c ESP: e6e8bd90
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process test6.sh (pid: 16050, ti=e6e8b000 task=e6fe0a30 task.ti=e6e8b000)
Stack:
 e6f03390 e6f03200 00598000 e6e8bdac c0414b15 c1c456e0 3bec5025 e6e8be08
 c04884d7 00000001 00000000 f61fdbb0 e6e8be20 00000000 00000001 006c0000
 f65e3004 e6f03200 f6233660 c1c456e0 00000000 fffffffa c1aff268 f65e3004
Call Trace:
 [<c0414b15>] ? flush_tlb_mm+0x67/0x8a
 [<c04884d7>] ? unmap_vmas+0x419/0x582
 [<c048bb3e>] ? exit_mmap+0x9e/0x127
 [<c042cc77>] ? mmput+0x3a/0x8b
 [<c04a36bd>] ? flush_old_exec+0x4c1/0x756
 [<c049f768>] ? vfs_read+0xf4/0x136
 [<c04a2bf4>] ? kernel_read+0x39/0x4b
 [<c04ca6ce>] ? load_elf_binary+0x33f/0x11bb
 [<c04a28d4>] ? search_binary_handler+0xc5/0x263
 [<c04a28dc>] ? search_binary_handler+0xcd/0x263
 [<c04ca38f>] ? load_elf_binary+0x0/0x11bb
 [<c04a3b6b>] ? do_execve+0x17a/0x20e
 [<c04019a3>] ? sys_execve+0x2e/0x56
 [<c0403485>] ? sysenter_do_call+0x12/0x35
Code: 07 89 d8 e8 8c ff ff ff 5b 5d c3 55 89 e5 57 56 53 0f 1f 44 00 00 89 d6 8b 15 00 6b 77 c0 89 c3 89 cf e8 60 be 0f 00 85 c0 74 04 <0f> 0b eb fe 85 f6 75 04 0f 0b eb fe b8 10 0c 73 c0 e8 3c dc 20 
EIP: [<c04147ec>] native_flush_tlb_others+0x20/0xf1 SS:ESP 0068:e6e8bd90
---[ end trace 6c8e163a63cc95c4 ]---
note: test6.sh[16050] exited with preempt_count 2
------------[ cut here ]------------
kernel BUG at arch/x86/kernel/tlb_32.c:130!
invalid opcode: 0000 [#2] PREEMPT SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:0e.0/irq
Modules linked in: bridge stp llc autofs4 dm_mirror dm_region_hash dm_log dm_mod parport_pc r8169 parport mii sg button sata_sis pata_sis ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]

Pid: 8238, comm: test5.sh Tainted: G      D    (2.6.29-rc2-mm1 #3) Aspire SA85
EIP: 0060:[<c04147ec>] EFLAGS: 00210202 CPU: 0
EIP is at native_flush_tlb_others+0x20/0xf1
EAX: 00000001 EBX: e6f03110 ECX: 00000004 EDX: 00000000
ESI: e6f02f80 EDI: ffffffff EBP: f6032d9c ESP: f6032d90
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process test5.sh (pid: 8238, ti=f6032000 task=e6fe5180 task.ti=f6032000)
Stack:
 e6f03110 e6f02f80 00598000 f6032dac c0414b15 c1c3c6e0 3bec5025 f6032e08
 c04884d7 f6032dd0 00000000 f6225318 f6032e20 00000000 00000001 006c0000
 f6520004 e6f02f80 f612b660 c1c3c6e0 00000000 fffffffa c1afbcc8 f6520004
Call Trace:
 [<c0414b15>] ? flush_tlb_mm+0x67/0x8a
 [<c04884d7>] ? unmap_vmas+0x419/0x582
 [<c048bb3e>] ? exit_mmap+0x9e/0x127
 [<c042cc77>] ? mmput+0x3a/0x8b
 [<c04a36bd>] ? flush_old_exec+0x4c1/0x756
 [<c049f768>] ? vfs_read+0xf4/0x136
 [<c04a2bf4>] ? kernel_read+0x39/0x4b
 [<c04ca6ce>] ? load_elf_binary+0x33f/0x11bb
 [<c04a2851>] ? search_binary_handler+0x42/0x263
 [<c04a28d4>] ? search_binary_handler+0xc5/0x263
 [<c04a28dc>] ? search_binary_handler+0xcd/0x263
 [<c04ca38f>] ? load_elf_binary+0x0/0x11bb
 [<c04a3b6b>] ? do_execve+0x17a/0x20e
 [<c04019a3>] ? sys_execve+0x2e/0x56
 [<c0403485>] ? sysenter_do_call+0x12/0x35
Code: 07 89 d8 e8 8c ff ff ff 5b 5d c3 55 89 e5 57 56 53 0f 1f 44 00 00 89 d6 8b 15 00 6b 77 c0 89 c3 89 cf e8 60 be 0f 00 85 c0 74 04 <0f> 0b eb fe 85 f6 75 04 0f 0b eb fe b8 10 0c 73 c0 e8 3c dc 20 
EIP: [<c04147ec>] native_flush_tlb_others+0x20/0xf1 SS:ESP 0068:f6032d90
---[ end trace 6c8e163a63cc95c5 ]---
note: test5.sh[8238] exited with preempt_count 2
