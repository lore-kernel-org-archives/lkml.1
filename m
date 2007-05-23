Return-Path: <linux-kernel-owner+w=401wt.eu-S1764985AbXEWQBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764985AbXEWQBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbXEWQBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:01:17 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755773AbXEWQBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:01:16 -0400
Date: Wed, 23 May 2007 09:01:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: [PATCH] Fix crash with irqpoll due to the IRQF_IRQPOLL flag
In-Reply-To: <20070522083756.GB18498@suse.de>
Message-ID: <alpine.LFD.0.98.0705230836370.3890@woody.linux-foundation.org>
References: <20070426093620.GB2626@in.ibm.com> <20070426082405.67a0fdd2.akpm@linux-foundation.org>
 <20070430084833.GA16173@in.ibm.com> <20070502221932.GA488@suse.de>
 <20070508171841.GA29733@in.ibm.com> <20070514140513.GD29616@suse.de>
 <20070522083756.GB18498@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 May 2007, Bernhard Walle wrote:
>
> o System crashes if booted with irqpoll command line option.
> 
> o Problem happens because Inside note_interrupt() we are accessing
>   desc->action->flag without taking the desc->lock. While accessing it
>   somebody goes ahead and unregisters the irq handler hence desc->action
>   is NULL. By the time note_interrupt() checks it, it crashes.

I absolutely _detest_ patches that make already complex and unreadable 
code even more so. Especially conditionals. Please don't do that.

If you need a variable for a conditional, make it be an implicit one from 
an inline function, and aim for making it readable.

So how about instead writing it out as a nice self-explanatory inline 
function? I can almost guarantee that this generates no worse code, and it 
also makes it easy to explain things like "we don't bother with the lock, 
because we don't care enough".

Untested, but I think the point of the patch is obvious. Anybody want to 
test it, send it back to me, and fix the bug while making the code more 
readable?

I think we should instate a hard new rule:

 - if a bugfix doesn't make the code more readable, it's not a bugfix at 
   all.

There was a reason for the bug in the first place, and that reason is 
likely that the code was hard to think about. So making it even _harder_ 
to think about isn't really fixing the deeper problem!

		Linus

---
 kernel/irq/spurious.c |   46 +++++++++++++++++++++++++++++++++++++---------
 1 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index b0d81aa..bd9e272 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -135,6 +135,39 @@ report_bad_irq(unsigned int irq, struct irq_desc *desc, irqreturn_t action_ret)
 	}
 }
 
+static inline int try_misrouted_irq(unsigned int irq, struct irq_desc *desc, irqreturn_t action_ret)
+{
+	struct irqaction *action;
+
+	if (!irqfixup)
+		return 0;
+
+	/* We didn't actually handle the IRQ - see if it was misrouted? */
+	if (action_ret == IRQ_NONE)
+		return 1;
+
+	/*
+	 * But for 'irqfixup == 2' we also do it for handled interrupts if
+	 * they are marked as IRQF_IRQPOLL (or for irq zero, which is the
+	 * traditional PC timer interrupt.. Legacy)
+	 */
+	if (irqfixup < 2)
+		return 0;
+
+	if (!irq)
+		return 1;
+
+	/*
+	 * Since we don't get the descriptor lock, "action" can
+	 * change under us.  We don't really care, but we don't
+	 * want to follow a NULL pointer. So tell the compiler to
+	 * just load it once by using a barrier.
+	 */
+	action = desc->action;
+	barrier();
+	return action && (action->flags & IRQF_IRQPOLL);
+}
+
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
@@ -144,15 +177,10 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 			report_bad_irq(irq, desc, action_ret);
 	}
 
-	if (unlikely(irqfixup)) {
-		/* Don't punish working computers */
-		if ((irqfixup == 2 && ((irq == 0) ||
-				(desc->action->flags & IRQF_IRQPOLL))) ||
-				action_ret == IRQ_NONE) {
-			int ok = misrouted_irq(irq);
-			if (action_ret == IRQ_NONE)
-				desc->irqs_unhandled -= ok;
-		}
+	if (unlikely(try_misrouted_irq(irq, desc, action_ret))) {
+		int ok = misrouted_irq(irq);
+		if (action_ret == IRQ_NONE)
+			desc->irqs_unhandled -= ok;
 	}
 
 	desc->irq_count++;
