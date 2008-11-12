Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbYKLTVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbYKLTVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 14:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbYKLTVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 14:21:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57482 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbYKLTVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 14:21:45 -0500
Date: Wed, 12 Nov 2008 20:21:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "lenb@kernel.org" <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [Linux 2.6.28-rc4] BUG: using smp_processor_id() in
	preemptible [00000000] code: suspend_to_disk/2934
Message-ID: <20081112192128.GA17667@elte.hu>
References: <8db1092f0811121030t1977b3bbu8340b582694d1e65@mail.gmail.com> <alpine.LFD.2.00.0811121046360.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811121046360.3468@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 12 Nov 2008, Maciej Rutecki wrote:
> 
> > -rc3 works OK
> > 
> > I have this bug during suspend to disk:
> > 
> > [  188.592151] Enabling non-boot CPUs ...
> > [  188.592151] SMP alternatives: switching to SMP code
> > [  188.666058] BUG: using smp_processor_id() in preemptible [00000000]
> > code: suspend_to_disk/2934
> > [  188.666064] caller is native_sched_clock+0x2b/0x80
> 
> The cause seems to be commit 
> 7cbaef9c83e58bbd4bdd534b09052b6c5ec457d5, "sched: optimize 
> sched_clock() a bit" by Ingo.
> 
> Which actually comments on the fact that a few callers may need to 
> be updated. That wasn't good. Ingo - it's not acceptable for a 
> latish-rc patch to introduce _known_ bugs and not fixing everything 
> up.
>
> Of course, since Maciej has frame pointers disabled, the stack trace 
> isn't entirely reliable, but it looks like the problem is 
> "init_idle()".
> 
> That thing needs to call sched_clock() with interrupts disabled. 
> Looking at it, I'd also expect that it should have used 
> "sched_clock_cpu()", but I'm leaving that to Ingo to sort out. Ingo?

i've queued up the fix below in tip/sched/urgent - Maciej, could you 
please test it? I've build and boot tested it.

I picked the simplest solution - to widen the (init only) use of the 
rq lock there, which is irqsafe already.

Another question is: how/where does the hibernation code call 
init_idle() with interrupts and preemption enabled? All the normal 
init_idle() sequences are called with irqs off (and at least with 
preemption off), that's why my testing didnt catch this bug.

[ I was under the distinct illusion that i had all callers covered 
  both via review and via testing (there's no that many users of naked 
  sched_clock() left). So there was certainly no bug known to me - my 
  comment was directed at out-of-tree naked-sched_clock() users which 
  do exist. The recommended in-kernel API is cpu_clock(cpu) - except
  for scheduler-internal use which was the issue here. ]

But it was still a late change and the boot warning was unnecessary, 
sorry about that.

	Ingo

------------->
>From 5cbd54ef470d880fc37fbe4b21eb514806d51e0d Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 12 Nov 2008 20:05:50 +0100
Subject: [PATCH] sched: fix init_idle()'s use of sched_clock()

Maciej Rutecki reported:

> I have this bug during suspend to disk:
>
> [  188.592151] Enabling non-boot CPUs ...
> [  188.592151] SMP alternatives: switching to SMP code
> [  188.666058] BUG: using smp_processor_id() in preemptible
> [00000000]
> code: suspend_to_disk/2934
> [  188.666064] caller is native_sched_clock+0x2b/0x80

Which, as noted by Linus, was caused by me, via:

  7cbaef9c "sched: optimize sched_clock() a bit"

Move the rq locking a bit earlier in the initialization sequence,
that will make the sched_clock() call in init_idle() non-preemptible.

Reported-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3bafbe3..c94baf2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5870,6 +5870,8 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
+	spin_lock_irqsave(&rq->lock, flags);
+
 	__sched_fork(idle);
 	idle->se.exec_start = sched_clock();
 
@@ -5877,7 +5879,6 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	idle->cpus_allowed = cpumask_of_cpu(cpu);
 	__set_task_cpu(idle, cpu);
 
-	spin_lock_irqsave(&rq->lock, flags);
 	rq->curr = rq->idle = idle;
 #if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
 	idle->oncpu = 1;

