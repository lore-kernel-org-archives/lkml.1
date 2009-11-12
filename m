Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbZKLExd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbZKLExd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 23:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759481AbZKLExd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 23:53:33 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:57393 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514AbZKLExc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 23:53:32 -0500
To: <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: BUG_ON(rq->nr_running != 0) in CPU_DEAD
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 11 Nov 2009 20:53:29 -0800
Message-ID: <m1ljiccpiu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When calling halt on one of my test machines I got this.
I have seen this a few times (but it is rare).

This appears to be BUG_ON(rq->nr_running != 0) from migration_call() CPU_DEAD.

I don't know what to make of it other than disable_nonboot_cpus is broken,
in a way I'm not familiar with.

Eric


[  624.034007] ------------[ cut here ]------------
[  624.035066] Kernel BUG at ffffffff813d0d82 [verbose debug info unavailable]
[  624.035066] invalid opcode: 0000 [#1] SMP 
[  624.035066] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.3/usb5/5-0:1.0/bInterfaceProtocol
[  624.035066] CPU 0 
[  624.035066] Modules linked in:
[  624.035066] Pid: 7102, comm: halt Not tainted 2.6.32-rc6x86_64 #20         
[  624.035066] RIP: 0010:[<ffffffff813d0d82>]  [<ffffffff813d0d82>] migration_call+0x358/0x4cd
[  624.035066] RSP: 0018:ffff88007d967d48  EFLAGS: 00010046
[  624.035066] RAX: 0000000000000003 RBX: 0000000000010000 RCX: ffff880001980000
[  624.035066] RDX: 0000000000010000 RSI: ffff880001990088 RDI: ffff88007ea68e38
[  624.035066] RBP: ffff880001990000 R08: ffff88007ea68898 R09: ffff880001990060
[  624.035066] R10: ffff88007ea68888 R11: 0000000000000001 R12: ffff88007ea68df0
[  624.035066] R13: ffff880001990000 R14: 0000000000000003 R15: 0000000000000000
[  624.035066] FS:  00007f43ea5bb6f0(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
[  624.035066] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  624.035066] CR2: 00000000005aae48 CR3: 000000007da9c000 CR4: 00000000000006f0
[  624.035066] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  624.035066] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  624.035066] Process halt (pid: 7102, threadinfo ffff88007d966000, task ffff88007da686c0)
[  624.035066] Stack:
[  624.035066]  0000000000000003 0000000000000000 0000000000000000 00000000ffffffff
[  624.035066] <0> ffffffff8161eec0 0000000000000003 0000000000000017 ffffffff81048ec4
[  624.035066] <0> ffff88007da686c0 0000000000000003 0000000000000010 ffffffff816200e8
[  624.035066] Call Trace:
[  624.035066]  [<ffffffff81048ec4>] ? notifier_call_chain+0x29/0x56
[  624.035066]  [<ffffffff813b4687>] ? _cpu_down+0x1a6/0x284
[  624.035066]  [<ffffffff81036039>] ? disable_nonboot_cpus+0x63/0xfa
[  624.035066]  [<ffffffff81040f3b>] ? kernel_power_off+0x21/0x3a
[  624.035066]  [<ffffffff810411e3>] ? sys_reboot+0x13b/0x158
[  624.035066]  [<ffffffff8103f145>] ? kill_pid_info+0x35/0x46
[  624.035066]  [<ffffffff8103f9d9>] ? sys_kill+0x72/0x143
[  624.035066]  [<ffffffff8109a316>] ? dput+0x2c/0x13a
[  624.035066]  [<ffffffff8108c540>] ? __fput+0x198/0x1c8
[  624.035066]  [<ffffffff8109ebbd>] ? mntput_no_expire+0x1c/0x8c
[  624.035066]  [<ffffffff81089e60>] ? filp_close+0x5e/0x66
[  624.035066]  [<ffffffff8100aceb>] ? system_call_fastpath+0x16/0x1b
[  624.035066] Code: 49 8b 44 24 30 4c 89 e6 4c 89 ef ff 50 30 48 c7 c2 00 00 01 00 44 89 f0 41 83 bc 24 48 01 00 00 00 48 8b 0c c5 20 fc 61 81 75 04 <0 
[  624.035066] RIP  [<ffffffff813d0d82>] migration_call+0x358/0x4cd
[  624.035066]  RSP <ffff88007d967d48>
[  624.035066] ---[ end trace b69b4ad3bcd0ae93 ]---
