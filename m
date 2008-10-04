Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYJDVMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYJDVMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYJDVMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:12:09 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:22004 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbYJDVMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:12:07 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] dumpstack: x86: various small unification steps
Date: Sat,  4 Oct 2008 23:12:39 +0200
Message-Id: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Sat, 04 Oct 2008 23:11:49 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.243; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here is the first round of unification of dumpstack_32.c
and dumpstack_64.c. The first patch can also be seen as
a clean-up of the traps.c-unification as I forgot to move
one function at the time. Anyhow, the series depends on
the traps unification.

B.T.W., I could reproduce the spontaneous reboot with the
traps unification with glibc. The change GATE_INTERRUPT -> 
GATE_TRAP fixed the crash there. Usually I test only with
a small klibc-based userspace, and there the reboot does
not happen. I guess the int 0x80 interface is less picky.
(Just to say that I do test the changes a bit ;) )

Example dumps, after the changes:

------------[ cut here ]------------
Kernel BUG at ffffffff802aa012 [verbose debug info unavailable]
invalid opcode: 0000 [#1] 
CPU 0 
Modules linked in:
Pid: 21, comm: sh Not tainted 2.6.27-rc8-tip #50
RIP: 0010:[<ffffffff802aa012>]  [<ffffffff802aa012>] 
sysrq_key_table_key2index+0x12/0x30
RSP: 0000:ffff88000793dea8  EFLAGS: 00000046
RAX: 000000000000000b RBX: 0000000000000002 RCX: 0000000000000001
RDX: 00000000000003f9 RSI: 0000000000000001 RDI: 0000000000000040
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: ffff88000793c000 R11: ffffffff8029ce50 R12: 0000000000000296
R13: 0000000000000040 R14: 0000000000000000 R15: 0000000000000007
FS:  0000000000000000(0000) GS:ffffffff80309000(0000) 
knlGS:0000000000000000
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 00000000f7f5a170 CR3: 0000000007942000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
Process sh (pid: 21, threadinfo ffff88000793c000, task ffff880007943830)
Stack:
 ffffffff802aa035 ffffffff802aa121 ffff88000783c300 0000000000000002
 fffffffffffffffb 00000000f7f59170 00000000f7f59170 0000000000000000
 0000000000000000 ffffffff80291833 ffff88000780c980 ffffffff8028b573
 0000000000000000 ffff88000783c480 ffff88000793df50 ffffffff80260f8d
 ffff88000783c480 0000000000000002 fffffffffffffff7 ffffffff80261463
 0000000006010a74 0000000000000000 0000000000000000 0000000000000001
 0000000000000000 0000000000000000 0000000000000000 ffffffff8021e292
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff802aa035>] __sysrq_get_key_op+0x5/0x20
 [<ffffffff802aa121>] __handle_sysrq+0x41/0x130
 [<ffffffff80291833>] write_sysrq_trigger+0x33/0x40
 [<ffffffff8028b573>] proc_reg_write+0x33/0x50
 [<ffffffff80260f8d>] vfs_write+0xad/0xe0
 [<ffffffff80261463>] sys_write+0x53/0x90
 [<ffffffff8021e292>] ia32_sysret+0x0/0xa
Code: 01 00 00 00 85 d2 75 0c 31 c0 83 3d 18 f5 05 00 00 0f 95 c0 f3 c3 0f 1f 00
83 ff 40 74 0d 8d 47 d0 83 f8 09 89 c1 77 07 89 c8 c3 <0f> 0b eb fe 8d 47 9f 8d
57 a9 b9 ff ff ff ff 83 f8 1a 0f 42 ca 
RIP  [<ffffffff802aa012>] sysrq_key_table_key2index+0x12/0x30
 RSP <ffff88000793dea8>
---[ end trace 61c257d34db6f0d4 ]---

------------[ cut here ]------------
Kernel BUG at c01768a6 [verbose debug info unavailable]
invalid opcode: 0000 [#1] 
Modules linked in:

Pid: 21, comm: sh Not tainted (2.6.27-rc8-tip #51) 
EIP: 0060:[<c01768a6>] EFLAGS: 00000046 CPU: 0
EIP is at sysrq_key_table_key2index+0x7/0x27
EAX: 00000040 EBX: 00000002 ECX: 000003f9 EDX: 00000040
ESI: 00000296 EDI: 00000000 EBP: 00000040 ESP: c7917f3c
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process sh (pid: 21, ti=c7917000 task=c790e330 task.ti=c7917000)
Stack:
 c01768cb c0176952 c019f80c 00000000 00000007 00000002 c01654fb fffffffb
 c79131a0 c016551e c7807004 c0161208 c7917fa0 b80c0170 c01611d9 c79131a0
 c7917fa0 c0147f65 c7917fa0 c79131a0 fffffff7 08055574 c7917000 c01482b6
 c7917fa0 00000000 00000000 00000000 00000001 08056a20 c0112afa 00000001
Call Trace:
 [<c01768cb>] __sysrq_get_key_op+0x5/0x16
 [<c0176952>] __handle_sysrq+0x35/0xe4
 [<c01654fb>] write_sysrq_trigger+0x0/0x29
 [<c016551e>] write_sysrq_trigger+0x23/0x29
 [<c0161208>] proc_reg_write+0x2f/0x40
 [<c01611d9>] proc_reg_write+0x0/0x40
 [<c0147f65>] vfs_write+0x6e/0x8d
 [<c01482b6>] sys_write+0x3c/0x63
 [<c0112afa>] syscall_call+0x7/0xb
Code: f0 5b 5e 5f 5d c3 90 90 90 83 3d 84 6b 1b c0 00 b8 01 00 00 00 75 0c 31 c0
83 3d 88 6b 1b c0 00 0f 95 c0 c3 83 f8 40 89 c2 75 04 <0f> 0b eb fe 8d 40 d0 83
f8 09 89 c1 76 0f 8d 42 9f 83 c9 ff 83 
EIP: [<c01768a6>] sysrq_key_table_key2index+0x7/0x27 SS:ESP 0068:c7917f3c
---[ end trace dabd939c3e498718 ]---
                
Greetings,
	Alexander
