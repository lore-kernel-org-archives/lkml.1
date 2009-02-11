Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbZBKIcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbZBKIcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 03:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZBKIc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 03:32:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44002 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbZBKIcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:32:25 -0500
Date: Wed, 11 Feb 2009 09:32:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc3: BUG: scheduling while atomic: udevd/917/0x10000100
Message-ID: <20090211083217.GC21105@elte.hu>
References: <19f34abd0902110009g4cdb1754na1cbf0acb6a93cce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0902110009g4cdb1754na1cbf0acb6a93cce@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi,
> 
> Just got this:
> 
> [  774.115554] BUG: scheduling while atomic: udevd/917/0x10000100
> [  774.117293] Modules linked in:
> [  774.117293] CPU 1:
> [  774.117293] Modules linked in:
> [  774.117293] Pid: 917, comm: udevd Not tainted 2.6.29-rc3 #223
> [  774.117293] RIP: 0010:[<ffffffff811b0eff>]  [<ffffffff811b0eff>]
> find_next_bit+0x17/0xa1
> [  774.117293] RSP: 0018:ffff88003e40bcd8  EFLAGS: 00000246
> [  774.117293] RAX: 0000000000000000 RBX: ffff88003e40bcd8 RCX: 00000000ffffffff
> [  774.117293] RDX: 0000000000000000 RSI: 0000000000000040 RDI: ffffffff8181cd80
> [  774.117293] RBP: ffffffff8100cf6e R08: 0000000000000040 R09: 0000000000000000
> [  774.117293] R10: ffff88003b090000 R11: 000000000000000a R12: ffff88003e5165a0
> [  774.117293] R13: 000000000003b08f R14: 0000000100000001 R15: 0000000000000000
> [  774.117293] FS:  0000000000000000(0000) GS:ffff88003f156f80(0063)
> knlGS:00000000f7f6d700
> [  774.117293] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> [  774.117293] CR2: 0000000008ff28bc CR3: 000000003e407000 CR4: 00000000000006a0
> [  774.117293] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  774.117293] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  774.117293] Call Trace:
> [  774.117293]  [<ffffffff81108a90>] ? show_stat+0x43e/0x4d6
> [  774.117293]  [<ffffffff810d6122>] ? seq_read+0x130/0x31a
> [  774.117293]  [<ffffffff81101f40>] ? proc_reg_read+0x80/0x9a
> [  774.117293]  [<ffffffff810bf40b>] ? vfs_read+0xad/0x107
> [  774.117293]  [<ffffffff810bf533>] ? sys_read+0x4c/0x73
> [  774.117293]  [<ffffffff8102d398>] ? sysenter_dispatch+0x7/0x27
> [  774.291296] ------------[ cut here ]------------
> 
> $ addr2line -e vmlinux -i ffffffff811b0eff ffffffff81108a90
> lib/find_next_bit.c:26
> fs/proc/stat.c:95

hm, the softirq count:

> [  774.115554] BUG: scheduling while atomic: udevd/917/0x10000100

means we leaked 1 softirq count. (SOFTIRQ_OFFSET == 0x100)

the 2^31 bit is PREEMPT_ACTIVE - that's harmless here. (shows that you
are running a CONFIG_PREEMPT=y kernel)

The softirq leak can come from three sources:

 - the core softirq code forgot to elevate it. Highly unlikely.

 - there's an unmatched *_lock_bh() critical section.

 - some sort of corruption. (unlikely, the softirq count is way too specific here)

OTOH show_stat() is fairly simple and has not been changed recently.
Mysterious. More folks Cc:-ed.

There's a fourth possibility:

 - Given that it's udevd that does it - maybe we leaked a softirq preempt
   count in some rare sysfs file, and it did not get discovered until the
   next innocent piece of kernel code preempted?

But i thought lockdep would already warn if we exited a syscall with locks
held or with a preempt count elevated - Peter?

	Ingo
