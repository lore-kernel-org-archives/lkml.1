Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbZAaR3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbZAaR3m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 12:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZAaR3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 12:29:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51361 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZAaR3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 12:29:33 -0500
Subject: Re: [git pull] scheduler fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Alexey Zaytsev <alexey.zaytsev@gmail.com>
In-Reply-To: <1233422632.4787.31.camel@laptop>
References: <20090130230936.GA7549@elte.hu>
	 <1233421901.4787.27.camel@laptop>  <1233422632.4787.31.camel@laptop>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 18:29:24 +0100
Message-Id: <1233422964.4787.34.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 18:23 +0100, Peter Zijlstra wrote:
> Since the commit msg of 01e3eb8 says:
> 
>     kernel_locked() is not a valid test in IRQ context (we update the
>     BKL's ->lock_depth and the preempt count separately and non-atomicalyy),
>     so we cannot put it into the generic preempt debugging checks which
>     can run in IRQ contexts too.
> 
> Another possibility would be writing it like:
> 
>   if (DEBUG_LOCKS_WARN_ON(val > preempt_count() -
>                           (in_interrupt() ? 0 : !!kernel_locked())))
> 
> Which might just work because we're in sub_preempt_count, before we
> actually do the subtraction, so in_interrupt() will still be true.

Which I guess translates into the following patch (like the previous
one, utterly untested).

Of course this might just render the whole test useless... Nick, what
circumstances prompted you to write the initial patch?

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/irq_32.c |    2 +-
 kernel/sched.c           |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index c5ba297..d802c84 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -141,7 +141,7 @@ void __cpuinit irq_ctx_init(int cpu)
 	irqctx->tinfo.task		= NULL;
 	irqctx->tinfo.exec_domain	= NULL;
 	irqctx->tinfo.cpu		= cpu;
-	irqctx->tinfo.preempt_count	= SOFTIRQ_OFFSET;
+	irqctx->tinfo.preempt_count	= 0;
 	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
 
 	softirq_ctx[cpu] = irqctx;
diff --git a/kernel/sched.c b/kernel/sched.c
index b97a9e3..0324880 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4610,7 +4610,8 @@ void __kprobes sub_preempt_count(int val)
 	/*
 	 * Underflow?
 	 */
-       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
+       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - 
+			       (in_interrupt() ? 0 : !!kernel_locked())))
 		return;
 	/*
 	 * Is the spinlock portion underflowing?


