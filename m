Return-Path: <linux-kernel-owner+w=401wt.eu-S1764104AbZFQKcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764104AbZFQKcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 06:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbZFQKcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 06:32:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:38174 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbZFQKcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 06:32:45 -0400
Date: Wed, 17 Jun 2009 10:32:04 GMT
From: tip-bot for Andi Kleen <andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090615125200.GD31969@one.firstfloor.org>
References: <20090615125200.GD31969@one.firstfloor.org>
Subject: [tip:x86/urgent] x86: mce: Handle banks == 0 case in K7 quirk
Message-ID: <tip-203abd67b75f7714ce98ab0cdbd6cfd7ad79dec4@git.kernel.org>
Git-Commit-ID: 203abd67b75f7714ce98ab0cdbd6cfd7ad79dec4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 10:32:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  203abd67b75f7714ce98ab0cdbd6cfd7ad79dec4
Gitweb:     http://git.kernel.org/tip/203abd67b75f7714ce98ab0cdbd6cfd7ad79dec4
Author:     Andi Kleen <andi@firstfloor.org>
AuthorDate: Mon, 15 Jun 2009 14:52:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 08:59:45 +0200

x86: mce: Handle banks == 0 case in K7 quirk

Vegard Nossum reported:

> I get an MCE-related crash like this in latest linus tree:
>
> [    0.115341] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.116396] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.120570] mce: CPU supports 0 MCE banks
> [    0.124870] BUG: unable to handle kernel NULL pointer dereference at 00000000 00000010
> [    0.128001] IP: [<ffffffff813b98ad>] mcheck_init+0x278/0x320
> [    0.128001] PGD 0
> [    0.128001] Thread overran stack, or stack corrupted
> [    0.128001] Oops: 0002 [#1] PREEMPT SMP
> [    0.128001] last sysfs file:
> [    0.128001] CPU 0
> [    0.128001] Modules linked in:
> [    0.128001] Pid: 0, comm: swapper Not tainted 2.6.30 #426
> [    0.128001] RIP: 0010:[<ffffffff813b98ad>]  [<ffffffff813b98ad>] mcheck_init+0x278/0x320
> [    0.128001] RSP: 0018:ffffffff81595e38  EFLAGS: 00000246
> [    0.128001] RAX: 0000000000000010 RBX: ffffffff8158f900 RCX: 0000000000000000
> [    0.128001] RDX: 0000000000000000 RSI: 00000000000000ff RDI: 0000000000000010
> [    0.128001] RBP: ffffffff81595e68 R08: 0000000000000001 R09: 0000000000000000
> [    0.128001] R10: 0000000000000010 R11: 0000000000000000 R12: 0000000000000000
> [    0.128001] R13: 00000000ffffffff R14: 0000000000000000 R15: 0000000000000000
> [    0.128001] FS:  0000000000000000(0000) GS:ffff880002288000(0000) knlGS:00000
> 00000000000
> [    0.128001] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [    0.128001] CR2: 0000000000000010 CR3: 0000000001001000 CR4: 00000000000006b0
> [    0.128001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.128001] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
> [    0.128001] Process swapper (pid: 0, threadinfo ffffffff81594000, task ffffff
> ff8152a4a0)
> [    0.128001] Stack:
> [    0.128001]  0000000081595e68 5aa50ed3b4ddbe6e ffffffff8158f900 ffffffff8158f
> 914
> [    0.128001]  ffffffff8158f948 0000000000000000 ffffffff81595eb8 ffffffff813b8
> 69c
> [    0.128001]  5aa50ed3b4ddbe6e 00000001078bfbfd 0000062300000800 5aa50ed3b4ddb
> e6e
> [    0.128001] Call Trace:
> [    0.128001]  [<ffffffff813b869c>] identify_cpu+0x331/0x392
> [    0.128001]  [<ffffffff815a1445>] identify_boot_cpu+0x23/0x6e
> [    0.128001]  [<ffffffff815a14ac>] check_bugs+0x1c/0x60
> [    0.128001]  [<ffffffff8159c075>] start_kernel+0x403/0x46e
> [    0.128001]  [<ffffffff8159b2ac>] x86_64_start_reservations+0xac/0xd5
> [    0.128001]  [<ffffffff8159b3ea>] x86_64_start_kernel+0x115/0x14b
> [    0.128001]  [<ffffffff8159b140>] ? early_idt_handler+0x0/0x71

This happens on QEMU which reports MCA capability, but no banks.
Without this patch there is a buffer overrun and boot ops because
the code would try to initialize the 0 element of a zero length
kmalloc() buffer.

Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Tested-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20090615125200.GD31969@one.firstfloor.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index fabba15..d9d77cf 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1245,7 +1245,7 @@ static void mce_cpu_quirks(struct cpuinfo_x86 *c)
 		 * Various K7s with broken bank 0 around. Always disable
 		 * by default.
 		 */
-		 if (c->x86 == 6)
+		 if (c->x86 == 6 && banks > 0)
 			bank[0] = 0;
 	}
 
