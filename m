Return-Path: <linux-kernel-owner+w=401wt.eu-S1751223AbZDGHkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbZDGHkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbZDGHkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:40:37 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49131 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZDGHkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:40:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qf0FAv09muuyM4Wbo5jPJWLH2PxtW+b16F8yMbaQYotVVx7knE9j5F//0wqGEp6Ady
         W7kdbhYHtD2G2T1GwAMHzDuc8Mf1KbL9HHD24RrjdxUcYjkV42IwF5s4cBaPgQ5bPPwa
         SqEoNMQrSsB0Qp+YM0BFsW9m/YdgDkM8BWC+U=
MIME-Version: 1.0
In-Reply-To: <200904061251.53189.a.miskiewicz@gmail.com>
References: <200904061251.53189.a.miskiewicz@gmail.com>
Date: Tue, 7 Apr 2009 09:40:32 +0200
Message-ID: <19f34abd0904070040k28af40bbo8e93497d69fa3b26@mail.gmail.com>
Subject: Re: 2.6.29, today's git changes, oops at boot, BUG: unable to handle 
	kernel paging request at ffffffffa00f0016
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/6 Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>:
>
> Pulled Linus git few minutes ago and new oops at boot (happens on every boot).
> Yesterday git version was fine. Oopsed just while/after udev started.
>

Hi, thanks for the report. Some musings below.

> x86_64, thinkpad t400
>
> latest commit 0221c81b1b8eb0cbb6b30a0ced52ead32d2b4e4c
>
> [    2.674741] VFS: Mounted root (xfs filesystem) readonly on device 8:3.
> [    2.674800] Trying to move old root to /initrd ... okay
> [    2.681684] Freeing unused kernel memory: 384k freed
> [    4.768259] input: Power Button (FF) as /class/input/input1
> [    4.769911] ACPI: AC Adapter [AC] (on-line)
> [    4.784019] ACPI: Power Button (FF) [PWRF]
> [    4.784082] input: Lid Switch as /class/input/input2
> [    4.784629] ACPI: Lid Switch [LID]
> [    4.784673] input: Sleep Button (CM) as /class/input/input3
> [    4.798528] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
> [    4.798954] BUG: unable to handle kernel paging request at ffffffffa00f0016
> [    4.799073] ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
> [    4.799180] IP: [<ffffffffa00f0016>] 0xffffffffa00f0016

So we are trying to execute a non-existing address. This is a vmalloc
address, so I guess it was in a module that had been unloaded. The
fact that it doesn't resolve to a symbol name also points in the
direction of a module that was just unloaded.

> [    4.799279] PGD 203067 PUD 207063 PMD 13b015067 PTE 0
> [    4.799498] Oops: 0010 [#1] PREEMPT SMP
> [    4.799675] last sysfs file: /sys/block/sda/uevent
> [    4.799733] CPU 0
> [    4.799826] Modules linked in: processor(+) battery ac button(+) crc_itu_t xfs exportfs scsi_wait_scan sd_mod crc_t10dif ahci libata scsi_mod

But why isn't there a "last unloaded" entry? Are you sure this is the
complete line?

> [    4.800001] Pid: 3140, comm: async/0 Not tainted 2.6.29 #177 2764CTO
> [    4.800001] RIP: 0010:[<ffffffffa00f0016>]  [<ffffffffa00f0016>] 0xffffffffa00f0016
> [    4.800001] RSP: 0018:ffff880138f8fec8  EFLAGS: 00010246
> [    4.800001] RAX: ffff880138f8ffd8 RBX: 0000000000000000 RCX: ffffffff80588630
> [    4.800001] RDX: ffffffff80588660 RSI: 0000000000000006 RDI: 0000000000000000
> [    4.800001] RBP: ffff880138f8ff20 R08: ffff880138f8e000 R09: ffff880028034500
> [    4.800001] R10: 0000000300000000 R11: 0000000100000000 R12: ffff880139c05400
> [    4.800001] R13: ffff88013b90dd70 R14: 0000000000000001 R15: 0000000000000001
> [    4.800001] FS:  0000000000000000(0000) GS:ffff880028023000(0000) knlGS:0000000000000000
> [    4.800001] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [    4.800001] CR2: ffffffffa00f0016 CR3: 000000013b045000 CR4: 00000000000006e0
> [    4.800001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    4.800001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    4.800001] Process async/0 (pid: 3140, threadinfo ffff880138f8e000, task ffff88013969d980)
> [    4.800001] Stack:
> [    4.800001]  ffffffff802554f7 0000000000000000 ffff88013969d980 ffffffff80238703
> [    4.801466]  ffff88013b90dee8 ffffffff80588618 ffff88013b90dd70 0000000000000000
> [    4.801466]  ffffffff802553de ffff88013b90dd70 ffff88013b88df00 ffff880138f8ff40
> [    4.801466] Call Trace:
> [    4.801466]  [<ffffffff802554f7>] ? async_thread+0x119/0x220
> [    4.801466]  [<ffffffff80238703>] ? default_wake_function+0x0/0xf
> [    4.801466]  [<ffffffff802553de>] ? async_thread+0x0/0x220
> [    4.801466]  [<ffffffff8024fd6d>] kthread+0x49/0x76
> [    4.801466]  [<ffffffff8020caaa>] child_rip+0xa/0x20
> [    4.801466]  [<ffffffff8024fd24>] ? kthread+0x0/0x76
> [    4.801466]  [<ffffffff8020caa0>] ? child_rip+0x0/0x20
> [    4.801466] Code:  Bad RIP value.

Yeah, async_thread() probably called a function that doesn't exist (anymore).

> [    4.801466] RIP  [<ffffffffa00f0016>] 0xffffffffa00f0016
> [    4.801466]  RSP <ffff880138f8fec8>
> [    4.801466] CR2: ffffffffa00f0016
> [    4.801466] ---[ end trace bc6c5e0bfc2ec314 ]---
> [    4.803382] ACPI: Sleep Button (CM) [SLPB]
> [    4.804132] Monitor-Mwait will be used to enter C-1 state
> [    4.804195] Monitor-Mwait will be used to enter C-2 state
> [    4.804263] Monitor-Mwait will be used to enter C-3 state
> [    4.804373] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> [    4.804612] processor ACPI_CPU:00: registered as cooling_device0
> [    4.804671] ACPI: Processor [CPU0] (supports 8 throttling states)
> [    4.805283] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
> [    4.805852] ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
> [    4.807419] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
> [    4.807655] processor ACPI_CPU:01: registered as cooling_device1
> [    4.807715] ACPI: Processor [CPU1] (supports 8 throttling states)
> [    4.816002] Marking TSC unstable due to TSC halts in idle
> [    4.935770] usbcore: registered new interface driver usbfs
>
>

So... missing module_get() somewhere?

Maybe you can try to boot with the "initcall_debug" parameter? Adding
"debug" might also give some more info. And just in case, though it
might produce a lot of output, adding "ignore_loglevel" would make
sure that everything makes it to the console.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
