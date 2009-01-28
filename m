Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZA1Rc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZA1Rc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbZA1Rcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:32:46 -0500
Received: from relay3.sgi.com ([192.48.171.31]:60177 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750951AbZA1Rcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:32:45 -0500
Message-ID: <498096BA.2000301@sgi.com>
Date: Wed, 28 Jan 2009 09:32:42 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <200901271735.12034.rusty@rustcorp.com.au> <20090126232519.44f2943c.akpm@linux-foundation.org> <200901282332.29429.rusty@rustcorp.com.au> <4980939C.6010102@sgi.com>
In-Reply-To: <4980939C.6010102@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Hi Rusty,
> 
> I'm testing this now on x86_64 and one question comes up.  The
> initialization of the woc_wq thread happens quite late.  Might it
> be better to initialize it earlier?

Umm, definitely needed earlier...  A bug catcher caught this.  Work_on_cpu
is being called before it's initialized.

[   16.541297] calling  microcode_init+0x0/0x13a @ 1
[   16.555989] ------------[ cut here ]------------
[   16.556955] kernel BUG at .../kernel/work_on_cpu.c:67!
[   16.556955] invalid opcode: 0000 [#1] SMP
[   16.556955] last sysfs file:
[   16.556955] CPU 5
[   16.556955] Pid: 1, comm: swapper Tainted: G        W  2.6.29-rc1-4k-defconfig.01280914-00263-g0ee2ad8-dirty #100
[   16.556955] RIP: 0010:[<ffffffff810a69df>]  [<ffffffff810a69df>] work_on_cpu+0x3d/0xeb
[   16.556955] RSP: 0018:ffff88012fac9b60  EFLAGS: 00010202
[   16.556955] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
[   16.556955] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
[   16.556955] RBP: ffff88012fac9c00 R08: 0000000000000000 R09: ffff88012fac9b80
[   16.556955] R10: ffffffff8187b778 R11: 0000000081049799 R12: 0000000000000000
[   16.556955] R13: ffffffff81026313 R14: 0000000000000000 R15: 0000000000000000
[   16.556955] FS:  0000000000000000(0000) GS:ffff88022ec3a000(0000) knlGS:0000000000000000
[   16.556955] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   16.556955] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006a0
[   16.556955] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   16.556955] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   16.556955] Process swapper (pid: 1, threadinfo ffff88012fac8000, task ffff88022faa8000)
[   16.556955] Stack:
[   16.556955]  000000002fac9bb0 ffffffff810260a6 000000002e0d75f0 0000000000000002
[   16.556955]  2222222222222222 2222222222222222 2222222222222222 2222222222222222
[   16.556955]  2222222222222222 0000000000000000 ffff88012fac9bd0 0000000000000000
[   16.556955] Call Trace:
[   16.556955]  [<ffffffff810260a6>] ? microcode_init_cpu+0x1e/0x3e
[   16.556955]  [<ffffffff810260b6>] microcode_init_cpu+0x2e/0x3e
[   16.556955]  [<ffffffff8102620c>] mc_sysdev_add+0x67/0x71
[   16.556955]  [<ffffffff812ffde8>] sysdev_driver_register+0xcb/0x125
[   16.556955]  [<ffffffff81a5bc32>] microcode_init+0xb7/0x13a
[   16.556955]  [<ffffffff81a5bb7b>] ? microcode_init+0x0/0x13a
[   16.556955]  [<ffffffff81009075>] _stext+0x75/0x17f
[   16.556955]  [<ffffffff8106dc2c>] ? mark_lock+0x1c/0x369
[   16.556955]  [<ffffffff8106f0bc>] ? __lock_acquire+0xba0/0xbc1
[   16.556955]  [<ffffffff812444a1>] ? ida_get_new_above+0x171/0x18d
[   16.556955]  [<ffffffff8112d764>] ? proc_register+0x184/0x198
[   16.556955]  [<ffffffff8125b54e>] ? _raw_spin_unlock+0xc7/0xf6
[   16.556955]  [<ffffffff815ce60b>] ? _spin_unlock+0x2b/0x2f
[   16.556955]  [<ffffffff8112d764>] ? proc_register+0x184/0x198
[   16.556955]  [<ffffffff8112d895>] ? create_proc_entry+0x79/0x8f
[   16.556955]  [<ffffffff81094705>] ? register_irq_proc+0xb3/0xcf
[   16.556955]  [<ffffffff81120000>] ? load_elf_binary+0xc38/0x1aa8
[   16.556955]  [<ffffffff81a4a902>] kernel_init+0x14b/0x1a1
[   16.556955]  [<ffffffff8100d7ba>] child_rip+0xa/0x20
[   16.556955]  [<ffffffff8100d1bc>] ? restore_args+0x0/0x30
[   16.556955]  [<ffffffff81a4a7b7>] ? kernel_init+0x0/0x1a1
[   16.556955]  [<ffffffff8100d7b0>] ? child_rip+0x0/0x20
[   16.556955] Code: 00 00 31 db 83 3d 75 24 50 01 00 41 89 fc 49 89 f5 49 89 d6 48 c7 c7 e8 d8 96 81 0f 94 c3 31 d2 89 de e8 8e f1 ff ff 85 db 74 04 <0f> 0b eb fe 48 8d 9d 60 ff ff ff 44 89 a5 60 ff ff ff 4c 89 ad
[   16.556955] RIP  [<ffffffff810a69df>] work_on_cpu+0x3d/0xeb
[   16.556955]  RSP <ffff88012fac9b60>
[   17.493250] ---[ end trace 4eaa2a86a8e2da23 ]---
[   17.507376] swapper used greatest stack depth: 3776 bytes left
[   17.525131] Kernel panic - not syncing: Attempted to kill init!



