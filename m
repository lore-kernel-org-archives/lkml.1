Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbYA1RTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbYA1RTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYA1RTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:19:16 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:28311 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbYA1RTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:19:14 -0500
Date: Mon, 28 Jan 2008 18:19:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, jeremy@goop.org
Subject: git-x86 oopses in acpi_ps_peek_opcode
Message-ID: <20080128171907.GA24037@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 28 Jan 2008 17:12:51.0945 (UTC) FILETIME=[03C65D90:01C861D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


git-x86 tip  5b838c0d9d7269eb4d21532da126b3c90db46c67 with x86-64 defconfig
oopses on boot with 

ACPI: Core revision 20070126
ACPI Warning (tbutils-0217): Incorrect checksum in table [����] -  FF, should be 76 [20070126]
ACPI Warning (tbutils-0217): Incorrect checksum in table [����] -  FF, should be 76 [20070126]
BUG: unable to handle kernel paging request at ffffc20001815000
IP: [<ffffffff803773e8>] acpi_ps_peek_opcode+0x4/0x1c
PGD 12fc32067 PUD 32fc24067 PMD 32f42c067 PTE 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.24 #2
RIP: 0010:[<ffffffff803773e8>]  [<ffffffff803773e8>] acpi_ps_peek_opcode+0x4/0x1c
RSP: 0018:ffffffff8077de20  EFLAGS: 00010216
RAX: 0000000000004eac RBX: 0000000000000000 RCX: ffffc2010181012f
RDX: ffffc20001815000 RSI: ffff81012f0c4470 RDI: ffff81032f034428
RBP: ffff81032f034400 R08: 0000000000000000 R09: ffffffff806df4a0
R10: 0000000000000000 R11: 0000000000000002 R12: ffff81012f0c4470
R13: ffff81032f034428 R14: ffffc20001815000 R15: ffffffff806780a1
FS:  0000000000000000(0000) GS:ffffffff80743000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffffc20001815000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff8077c000, task ffffffff806df4a0)
Stack:  ffffffff80377cbd 0000000000000246 00000000000080d0 0000000000000000
 ffff81012f0c4470 0000000000000000 0000000000000000 ffff81032f034400
 0000000000000000 ffff81012f056550 0000000000000000 ffffffff80678006
Call Trace:
 [<ffffffff80377cbd>] ? acpi_ps_parse_loop+0x17d/0x7a4
 [<ffffffff8037747b>] ? acpi_ps_parse_aml+0x7b/0x27f
 [<ffffffff80376df2>] ? acpi_ns_one_complete_parse+0xc2/0xdb
 [<ffffffff8037d5a3>] ? acpi_ut_release_mutex+0x5f/0x63
 [<ffffffff80376e1c>] ? acpi_ns_parse_table+0x11/0x25
 [<ffffffff80374d7b>] ? acpi_ns_load_table+0x43/0x88
 [<ffffffff80379f2d>] ? acpi_load_tables+0x105/0x1d4
 [<ffffffff807a1f82>] ? acpi_early_init+0x6c/0x105
 [<ffffffff80789af9>] ? start_kernel+0x2b1/0x2c2
 [<ffffffff807891ce>] ? _sinittext+0x1ce/0x1d5


Code: 24 08 4c 89 2a eb 05 b8 04 00 00 00 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 81 ff 00 01 00 00 19 c0 83 c0 02 c3 48 8b 57 08 <8a> 02 3c 5b 74 06 66 0f b6 c0 eb 08 66 0f b6 42 01 80 cc 5b 0f
RIP  [<ffffffff803773e8>] acpi_ps_peek_opcode+0x4/0x1c
 RSP <ffffffff8077de20>
CR2: ffffc20001815000
---[ end trace ca143223eefdc828 ]---
Kernel panic - not syncing: Attempted to kill the idle task!

Looks like early_ioremap is broken again.

I tried to bisect it, but failed because immediate kernels oops with

TCP reno registered
Unable to handle kernel NULL pointer dereference at 0000000000000040 RIP:
 [<ffffffff8034f2fd>] kobject_uevent_env+0x2a/0x3e2
PGD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-ge71b779d #51
RIP: 0010:[<ffffffff8034f2fd>]  [<ffffffff8034f2fd>] kobject_uevent_env+0x2a/0x3e2
RSP: 0000:ffff81012f075b90  EFLAGS: 00010286
RAX: 0000000000000018 RBX: 0000000000000000 RCX: 00000000c0000410
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000018
RBP: 0000000000000018 R08: 0000000000000000 R09: 000000002f2f64b0
R10: 0000000000000246 R11: 00000a96806e2de0 R12: 0000000000000000
R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000004
FS:  0000000000000000(0000) GS:ffffffff80743000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000040 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81012f074000, task ffff81032f06b040)
Stack:  ffff81012f2f64b0 00000000802c2188 ffffffff80662cff ffffffff806e2e20
 ffff81012f075be0 ffffffff806e2e20 ffff81032e765280 0000000000000000
 ffff81012f2f64b0 ffffffff802c1cfb 000000002f2f64b0 00000000c000040f
Call Trace:
 [<ffffffff802c1cfb>] ? sysfs_add_file+0x5b/0x81
 [<ffffffff802174c7>] ? allocate_threshold_blocks+0x193/0x1bf
 [<ffffffff802174b5>] ? allocate_threshold_blocks+0x181/0x1bf
 [<ffffffff802174b5>] ? allocate_threshold_blocks+0x181/0x1bf
 [<ffffffff802174b5>] ? allocate_threshold_blocks+0x181/0x1bf
 [<ffffffff802174b5>] ? allocate_threshold_blocks+0x181/0x1bf
 [<ffffffff802174b5>] ? allocate_threshold_blocks+0x181/0x1bf
 [<ffffffff802174b5>] ? allocate_threshold_blocks+0x181/0x1bf
 [<ffffffff802174b5>] ? allocate_threshold_blocks+0x181/0x1bf
 [<ffffffff802174b5>] ? allocate_threshold_blocks+0x181/0x1bf
 [<ffffffff802176e7>] ? threshold_create_device+0x1f4/0x2e8
 [<ffffffff80791502>] ? threshold_init_device+0x16/0x3f
 [<ffffffff807896de>] ? kernel_init+0x170/0x2da
 [<ffffffff8020c0d8>] ? child_rip+0xa/0x12
 [<ffffffff8078956e>] ? kernel_init+0x0/0x2da
 [<ffffffff8020c0ce>] ? child_rip+0x0/0x12


Code: c3 41 57 89 f0 41 56 41 55 41 54 55 48 89 fd 53 48 89 d3 48 83 ec 58 48 8b 04 c5 e0 9d 58 80 89 74 24 0c 48 89 44 24 10 48 89 f8 <4c> 8b 70 28 4d 85 f6 75 14 48 8b 40 20 48 85 c0 75 ee 41 bd ea
RIP  [<ffffffff8034f2fd>] kobject_uevent_env+0x2a/0x3e2
 RSP <ffff81012f075b90>
CR2: 0000000000000040
---[ end trace 778e504de7e3b1e3 ]---
Kernel panic - not syncing: Attempted to kill init!

-Andi
