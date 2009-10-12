Return-Path: <linux-kernel-owner+w=401wt.eu-S932126AbZJLMXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbZJLMXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbZJLMXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:23:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51363 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbZJLMXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:23:33 -0400
Date: Mon, 12 Oct 2009 14:22:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] NULL pointer dereference at IP: [<ffffffff812e9ccb>]
	uart_close+0x2a/0x1e4
Message-ID: <20091012122245.GA22088@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> <20091012080511.GA22607@elte.hu> <20091012091954.GA31171@elte.hu> <20091012092713.GA32647@elte.hu> <20091012112504.GA10002@elte.hu> <20091012124501.3c1ac94f@lxorguk.ukuu.org.uk> <20091012115549.GA13987@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012115549.GA13987@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > so uart_close takes the wrong lock. I've checked the rest of the 
> > patch for the same error and I don't see any other screwups.
> 
> Cool! This very much looks like something that could fix both problems. 
> I've started testing your fix.

Unfortunately it does not solve the problem, i still get:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000240
IP: [<ffffffff812ea215>] uart_close+0x24/0x1e5
PGD 77166067 PUD 77171067 PMD 0 
Oops: 0000 [#1] DEBUG_PAGEALLOC
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 1107, comm: hwclock Not tainted 2.6.32-rc4-tip #8185 System Product Name
RIP: 0010:[<ffffffff812ea215>]  [<ffffffff812ea215>] uart_close+0x24/0x1e5
RSP: 0018:ffff8800770e9b98  EFLAGS: 00010246
RAX: ffffffff812ea1f1 RBX: ffff88007df80000 RCX: 0000000000000000
RDX: ffff88007aaa7900 RSI: ffff88007df80000 RDI: ffff88007b3eb000
RBP: ffff8800770e9bb8 R08: ffff88007a62cd80 R09: ffff88007a62c600
R10: 0000000000000246 R11: ffffffff812c1ed9 R12: 0000000000000000
R13: ffff88007b3eb000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fc1bae596f0(0000) GS:ffffffff81b38000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000240 CR3: 0000000077187000 CR4: 00000000000026f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hwclock (pid: 1107, threadinfo ffff8800770e8000, task ffff88007a62c600)
Stack:
 ffff88007b3eb000 0000000000000000 00000000fffffffa 0000000000000000
<0> ffff8800770e9c98 ffffffff812c3ece ffff8800770e9bf8 0000000000000246
<0> ffff88007aab8150 ffff88007aab8000 ffff88007b3eb000 ffffffff81d57560
Call Trace:
 [<ffffffff812c3ece>] tty_release_dev+0x1ca/0x4d8
 [<ffffffff81772e4e>] ? mutex_unlock+0xe/0x10
 [<ffffffff81774cc5>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff812c478d>] tty_open+0x33f/0x41d
 [<ffffffff811174a1>] chrdev_open+0x179/0x19a
 [<ffffffff81112a8a>] __dentry_open+0x1cf/0x2f9
 [<ffffffff81117328>] ? chrdev_open+0x0/0x19a
 [<ffffffff81113a14>] nameidata_to_filp+0x45/0x56
 [<ffffffff8112035a>] do_filp_open+0x58a/0xa39
 [<ffffffff8103f3ce>] ? native_sched_clock+0x3b/0x52
 [<ffffffff8103f38f>] ? sched_clock+0x17/0x1b
 [<ffffffff8108c06e>] ? cpu_clock+0x41/0x5b
 [<ffffffff8112971c>] ? alloc_fd+0x110/0x11f
 [<ffffffff81774cc5>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff8112971c>] ? alloc_fd+0x110/0x11f
 [<ffffffff811127c8>] do_sys_open+0x62/0x109
 [<ffffffff811128a2>] sys_open+0x20/0x22
 [<ffffffff81038dff>] system_call_fastpath+0x16/0x1b
Code: 5d 41 5e 41 5f c9 c3 55 48 89 e5 41 56 41 55 41 54 53 0f 1f 44 00 00 f6 05 53 29 55 01 08 4c 8b a7 28 04 00 00 49 89 fd 48 89 f3 <4d> 8b b4 24 40 02 00 00 74 16 f6 05 3c 29 55 01 40 74 0d 80 3d 
RIP  [<ffffffff812ea215>] uart_close+0x24/0x1e5
 RSP <ffff8800770e9b98>
CR2: 0000000000000240
---[ end trace a06c2589766a51bf ]---

I still think it's a break-through - you found one bug in the patch 
already, which means that there could be more in there ;-)

	Ingo
