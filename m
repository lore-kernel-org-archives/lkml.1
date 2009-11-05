Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZKEObp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZKEObp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbZKEObp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:31:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:35017 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888AbZKEObo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:31:44 -0500
Date: Thu, 5 Nov 2009 15:31:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       cl@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: irq lock inversion
In-Reply-To: <4AF28D7A.6020209@kernel.org>
Message-ID: <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de>
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com> <4AF25FC7.4000502@kernel.org> <20091105082102.GA2870@elte.hu> <4AF28D7A.6020209@kernel.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added LKML to CC so that the lockdep message is at least indexed by 
  search engines in archives ]

On Thu, 5 Nov 2009, Tejun Heo wrote:

> > lockdep only considers a lock irq-safe if it was used from an irq 
> > context before.
> > 
> > _irqsave() API usage alone does not trigger this.
> 
> Thanks for the explanation.  It's about the same tho.  sched_init() is
> calling it with irq disabled but that's an exception to might_sleep()
> rule.  Maybe making lockdep recognize the same exception as
> might_sleep() so that lockdep doesn't consider a lock irq-safe if it's
> called with irq off but before system_state is set to SYSTEM_RUNNING
> works around the problem?

Hmm, I wonder why I don't see this lockdep warning myself with 
head on 1836d9592, even though I have 

	CONFIG_PROVE_LOCKING=y
	CONFIG_TRACE_IRQFLAGS=y

... ?

Anyway, how about something like this? (I can't verify myself that it even 
fixes the warning, as I don't see it for some odd reason)




From: Jiri Kosina <jkosina@suse.cz>
Subject: lockdep: avoid false positives about irq-safety

Commit 403a91b1 ("percpu: allow pcpu_alloc() to be called
with IRQs off") introduced this warning:

	=========================================================
	[ INFO: possible irq lock inversion dependency detected ]
	2.6.32-rc5-tip-04815-g12f0f93-dirty #745
	---------------------------------------------------------
	hub 1-3:1.0: state 7 ports 2 chg 0000 evt 0004
	ksoftirqd/65/199 just changed the state of lock:
	 (pcpu_lock){..-...}, at: [<ffffffff81130e04>] free_percpu+0x38/0x104
	but this lock took another, SOFTIRQ-unsafe lock in the past:
	 (vmap_area_lock){+.+...}

	and interrupts could create inverse lock ordering between them.

This warning is bogus -- sched_init() is being called very early with IRQs
disabled, and the irqsave/restore code paths in pcpu_alloc() are only for early
init. The path can never be called from irq context once the early init
finishes. Rationale for this is explained in changelog of the commit mentioned
above.

This problem can be encountered generally in any other early code running
with IRQs off and using irqsave/irqrestore.

Reported-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

--- 
 kernel/lockdep.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 9af5672..996b395 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2487,6 +2487,14 @@ void lockdep_trace_alloc(gfp_t gfp_mask)
 
 static int mark_irqflags(struct task_struct *curr, struct held_lock *hlock)
 {
+	/* 
+	 * This is exception similar to the might_sleep() one. 
+	 * We don't care about irq-safety of the locks this early, as
+	 * it will produce false positives (sched_init() is called with
+	 * irqs off, but needs to use irqsave/irqrestore API)
+	 */
+	if (system_state != SYSTEM_RUNNING)
+		return 1;
 	/*
 	 * If non-trylock use in a hardirq or softirq context, then
 	 * mark the lock as used in these contexts:
