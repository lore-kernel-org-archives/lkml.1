Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZHMUFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZHMUFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbZHMUFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:05:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755657AbZHMUFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:05:32 -0400
Date: Thu, 13 Aug 2009 13:05:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT pull] genirq fixes for 2.6.31
In-Reply-To: <alpine.LFD.2.00.0908132145340.1283@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908131259340.28882@localhost.localdomain>
References: <alpine.LFD.2.00.0908132100210.1283@localhost.localdomain> <alpine.LFD.2.01.0908131211550.28882@localhost.localdomain> <alpine.LFD.2.00.0908132145340.1283@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Aug 2009, Thomas Gleixner wrote:

> On Thu, 13 Aug 2009, Linus Torvalds wrote:
> > Now, I can see a bug, which is that "action->tsk" may have been set to 
> > NULL. But I can't see a race, and I can't see a reason for all the code 
> > movement. So quite frankly, I think the comments (both in the code and in 
> > the commit message) are just wrong. And the odd "load it first, then do 
> > other things" code looks confused.
> > 
> > So why is this not just a
> > 
> > 	if (action->thread)
> > 		wake_up_process(action->thread);
> > 
> > with appropriate comments?
> 
> What guarantees that the compiler does not dereference action->thread
> twice and the action->thread = NULL; operation happens between the
> check and the wake_up_process() call? I might be paranoid, but ...

Aren't we holding the lock here?

And if we are _not_ holding the lock, then it's racy anyway, and the right 
fix is the other one I suggested:

> > Or, alternatively, just move all the "clear action->thread" in free_irq() 
> > to after having done the "synchronize_irq()" thing, and then - afaik - 
> > you'll not need that test at all, because you're guaranteed that as long 
> > as you're in an interrupt handler, the thing shouldn't be cleared.
> 
> Right, I looked at that as well, but we need to do it different than
> just calling synchronize_irq(), as we need to keep desc->lock after we
> established that no interrupt is in progress. Otherwise we can run
> into the same problem which we have right now. Patch below.

But we already _do_ call synchronize_irq().

And no, we'd better not be running into the same problem, becaue dang it, 
if we do, then 'action' itself is unreliable (since we'll be doing a 
'kfree()' in it in free_irq())

IOW, why not just make the patch do something like the appended? 

NOTE! This is UNTESTED. And I also - on purpose - removed the "set 
action->thread to NULL", because we're going to free 'action', so if 
anything depends on it, it's already buggy.

What am I missing?

		Linus

---
 kernel/irq/manage.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 61c679d..0747f22 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -809,9 +809,6 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 			desc->chip->disable(irq);
 	}
 
-	irqthread = action->thread;
-	action->thread = NULL;
-
 	spin_unlock_irqrestore(&desc->lock, flags);
 
 	unregister_handler_proc(irq, action);
@@ -819,12 +816,6 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	/* Make sure it's not being used on another CPU: */
 	synchronize_irq(irq);
 
-	if (irqthread) {
-		if (!test_bit(IRQTF_DIED, &action->thread_flags))
-			kthread_stop(irqthread);
-		put_task_struct(irqthread);
-	}
-
 #ifdef CONFIG_DEBUG_SHIRQ
 	/*
 	 * It's a shared IRQ -- the driver ought to be prepared for an IRQ
@@ -840,6 +831,14 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 		local_irq_restore(flags);
 	}
 #endif
+
+	irqthread = action->thread;
+	if (irqthread) {
+		if (!test_bit(IRQTF_DIED, &action->thread_flags))
+			kthread_stop(irqthread);
+		put_task_struct(irqthread);
+	}
+
 	return action;
 }
 
