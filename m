Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbYF2NGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbYF2NGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 09:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYF2NG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 09:06:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57219 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbYF2NG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 09:06:28 -0400
Date: Sun, 29 Jun 2008 15:05:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <srostedt@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: -tip: WARNING: at kernel/lockdep.c:2738
Message-ID: <20080629130554.GA16703@elte.hu>
References: <19f34abd0806290532k1b176d97k96f7c5bb2bb9e830@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806290532k1b176d97k96f7c5bb2bb9e830@mail.gmail.com>
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
> I just got this on the latest tip/master shortly after finishing initcalls:
> 
> ------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:2738 check_flags+0x142/0x160()
> Pid: 5, comm: watchdog/0 Not tainted 2.6.26-rc8-tip-00206-g3248a70-dirty #49
>  [<c0139684>] warn_on_slowpath+0x54/0x70
>  [<c015be00>] ? trace_hardirqs_off_caller+0x40/0xe0
>  [<c010a7c5>] ? native_sched_clock+0xb5/0x110
>  [<c018076e>] ? ftrace_record_ip+0x12e/0x240
>  [<c05ab8c8>] ? _spin_unlock_irqrestore+0x48/0x80
>  [<c029ffd3>] ? debug_locks_off+0x3/0x50
>  [<c018076e>] ? ftrace_record_ip+0x12e/0x240
>  [<c0104f6b>] ? mcount_call+0x5/0xa
>  [<c015b322>] check_flags+0x142/0x160
>  [<c015f6e9>] lock_acquire+0x59/0xd0
>  [<c01769f1>] ? watchdog+0xb1/0x1e0
>  [<c05ab2fd>] _read_lock+0x3d/0x70
>  [<c01769f1>] ? watchdog+0xb1/0x1e0
>  [<c01769f1>] watchdog+0xb1/0x1e0
>  [<c05ab8c8>] ? _spin_unlock_irqrestore+0x48/0x80
>  [<c012bae9>] ? complete+0x49/0x60
>  [<c0176940>] ? watchdog+0x0/0x1e0
>  [<c014e637>] kthread+0x47/0x80
>  [<c014e5f0>] ? kthread+0x0/0x80
>  [<c0104f53>] kernel_thread_helper+0x7/0x10
>  =======================
> ---[ end trace 8e23f95b45fa05f7 ]---
> possible reason: unannotated irqs-on.
> irq event stamp: 18
> hardirqs last  enabled at (17): [<c015e02b>] trace_hardirqs_on+0xb/0x10
> hardirqs last disabled at (18): [<c015beab>] trace_hardirqs_off+0xb/0x10
> softirqs last  enabled at (0): [<c0137cd8>] copy_process+0x268/0x10b0
> softirqs last disabled at (0): [<00000000>] 0x0
> 
> I hope this wasn't caused by any of my patches :-S
> 
> $ addr2line -e vmlinux -i c01769f1
> kernel/softlockup.c:232
> kernel/softlockup.c:271
> 
> It seems that Andrew reported this too,
> http://lkml.org/lkml/2008/6/9/41, but I already have the fix,
> 
> commit 040ec23d07f95285e9777a85cda29cb339a3065b
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Mon Jun 9 01:45:29 2008 -0700
> 
>     sched: sched_clock() lockdep fix
> 
> so it can't be the same one.
> 
> (It seems to be something ftrace-related, adding Steven to Cc.)

perhaps caused by this one:

| commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa
| Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
| Date:   Fri Jun 27 13:41:15 2008 +0200
|
|    sched: sched_clock_cpu() based cpu_clock()

?

Does the patch below (or the tip/master i just pushed out) fix it?

	Ingo

------------->
commit 2d452c9b10caeec455eb5e56a0ef4ed485178213
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sun Jun 29 15:01:59 2008 +0200

    sched: sched_clock_cpu() based cpu_clock(), lockdep fix
    
    Vegard Nossum reported:
    
    > WARNING: at kernel/lockdep.c:2738 check_flags+0x142/0x160()
    
    which happens due to:
    
     unsigned long long cpu_clock(int cpu)
     {
             unsigned long long clock;
             unsigned long flags;
    
             raw_local_irq_save(flags);
    
    as lower level functions can take locks, we must not do that, use
    proper lockdep-annotated irq save/restore.
    
    Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index ed5a8c4..60094e2 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -250,9 +250,9 @@ unsigned long long cpu_clock(int cpu)
 	unsigned long long clock;
 	unsigned long flags;
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	clock = sched_clock_cpu(cpu);
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
 	return clock;
 }
