Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbZHMTwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbZHMTwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbZHMTwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:52:53 -0400
Received: from www.tglx.de ([62.245.132.106]:44334 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755794AbZHMTwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:52:51 -0400
Date: Thu, 13 Aug 2009 21:52:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT pull] genirq fixes for 2.6.31
In-Reply-To: <alpine.LFD.2.01.0908131211550.28882@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0908132145340.1283@localhost.localdomain>
References: <alpine.LFD.2.00.0908132100210.1283@localhost.localdomain> <alpine.LFD.2.01.0908131211550.28882@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Linus Torvalds wrote:
> Now, I can see a bug, which is that "action->tsk" may have been set to 
> NULL. But I can't see a race, and I can't see a reason for all the code 
> movement. So quite frankly, I think the comments (both in the code and in 
> the commit message) are just wrong. And the odd "load it first, then do 
> other things" code looks confused.
> 
> So why is this not just a
> 
> 	if (action->thread)
> 		wake_up_process(action->thread);
> 
> with appropriate comments?

What guarantees that the compiler does not dereference action->thread
twice and the action->thread = NULL; operation happens between the
check and the wake_up_process() call? I might be paranoid, but ...

> Or, alternatively, just move all the "clear action->thread" in free_irq() 
> to after having done the "synchronize_irq()" thing, and then - afaik - 
> you'll not need that test at all, because you're guaranteed that as long 
> as you're in an interrupt handler, the thing shouldn't be cleared.

Right, I looked at that as well, but we need to do it different than
just calling synchronize_irq(), as we need to keep desc->lock after we
established that no interrupt is in progress. Otherwise we can run
into the same problem which we have right now. Patch below.

Thanks,

	tglx
---
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 76e109a..06fa022 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -895,7 +907,28 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	if (!desc)
 		return NULL;
 
-	atomic_spin_lock_irqsave(&desc->lock, flags);
+	while (1) {
+		/*
+		 * Wait until we're out of the critical section.  This might
+		 * give the wrong answer due to the lack of memory barriers.
+		 */
+		while (desc->status & IRQ_INPROGRESS)
+			cpu_relax();
+
+		/*
+		 * Check under the lock again. If irq is not in
+		 * progress we keep the lock held until we removed
+		 * action. We do not care about an already running irq
+		 * thread here. We care about it when we stop the thread.
+		 */
+		atomic_spin_lock_irqsave(&desc->lock, flags);
+
+		if (!(desc->status & IRQ_INPROGRESS))
+			break;
+
+		/* Try again */
+		atomic_spin_unlock_irqrestore(&desc->lock, flags);
+	}
 
 	/*
 	 * There can be multiple actions per IRQ descriptor, find the right


