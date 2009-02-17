Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbZBQTqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbZBQTqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZBQTq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:46:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32920 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477AbZBQTqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:46:24 -0500
Date: Tue, 17 Feb 2009 20:45:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/genirq] irq: refactor and clean up the free_irq()
	code flow
Message-ID: <20090217194555.GA12091@elte.hu>
References: <tip-ae88a23b32fa7e0dc9fa7ce735966e68eb41b0bc@kernel.org> <alpine.LFD.2.00.0902171101080.21686@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902171101080.21686@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, 15 Feb 2009, Ingo Molnar wrote:
> >  	struct irq_desc *desc = irq_to_desc(irq);
> > -	struct irqaction **p;
> > +	struct irqaction *action, **p, **pp;
> 
> The whole reason for 'pp' seems to be the confusing loop:
> 
> >  	for (;;) {
> > +		action = *p;
> > +		pp = p;
> > +
> > +		if (!action) {
> > +			WARN(1, "Trying to free already-free IRQ %d\n", irq);
> > +			spin_unlock_irqrestore(&desc->lock, flags);
> > +
> > +			return;
> > +		}
> >  
> > +		p = &action->next;
> > +		if (action->dev_id != dev_id)
> > +			continue;
> >  
> > +		break;
> > +	}
> > +	/* Found it - now remove it from the list of entries: */
> > +	*pp = action->next;
> 
> Where the need for 'pp' would go away if you'd just write it as
> 
> 		if (action->dev_id == dev_id)
> 			break;
> 		p = &action->next;
> 	}
> 	*p = action->next;
> 
> instead. Which also makes it both shorter and more readable.

Ah, good point. I concentrated on an identity transformation 
primarily and missed that simplification.

Something like the patch below? (plus the followup cleanup 
further below?)

	Ingo

------------->
>From 8316e38100c70cd1443ac90074eccdd033aa218d Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 17 Feb 2009 20:28:29 +0100
Subject: [PATCH] irq: further clean up the free_irq() code flow

Linus noticed that the 'pp' variable can be eliminated
altogether, and the loop can be cleaned up further.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/manage.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 7a954b8..de5a765 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -575,7 +575,7 @@ int setup_irq(unsigned int irq, struct irqaction *act)
 void free_irq(unsigned int irq, void *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irqaction *action, **p, **pp;
+	struct irqaction *action, **p;
 	unsigned long flags;
 
 	WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
@@ -592,7 +592,6 @@ void free_irq(unsigned int irq, void *dev_id)
 	p = &desc->action;
 	for (;;) {
 		action = *p;
-		pp = p;
 
 		if (!action) {
 			WARN(1, "Trying to free already-free IRQ %d\n", irq);
@@ -601,15 +600,13 @@ void free_irq(unsigned int irq, void *dev_id)
 			return;
 		}
 
+		if (action->dev_id == dev_id)
+			break;
 		p = &action->next;
-		if (action->dev_id != dev_id)
-			continue;
-
-		break;
 	}
 
 	/* Found it - now remove it from the list of entries: */
-	*pp = action->next;
+	*p = action->next;
 
 	/* Currently used only by UML, might disappear one day: */
 #ifdef CONFIG_IRQ_RELEASE_METHOD

>From f17c75453b2d195eba0a90d9f16a3ba88c85b3b4 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 17 Feb 2009 20:43:37 +0100
Subject: [PATCH] irq: name 'p' variables a bit better

'p' stands for pointer - make it clear in setup_irq() and free_irq()
what kind of pointer it is.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/manage.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index de5a765..c589305 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -399,7 +399,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 static int
 __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 {
-	struct irqaction *old, **p;
+	struct irqaction *old, **old_ptr;
 	const char *old_name = NULL;
 	unsigned long flags;
 	int shared = 0;
@@ -431,8 +431,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	 * The following block of code has to be executed atomically
 	 */
 	spin_lock_irqsave(&desc->lock, flags);
-	p = &desc->action;
-	old = *p;
+	old_ptr = &desc->action;
+	old = *old_ptr;
 	if (old) {
 		/*
 		 * Can't share interrupts unless both agree to and are
@@ -455,8 +455,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
 		/* add new interrupt at end of irq queue */
 		do {
-			p = &old->next;
-			old = *p;
+			old_ptr = &old->next;
+			old = *old_ptr;
 		} while (old);
 		shared = 1;
 	}
@@ -507,7 +507,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 				(int)(new->flags & IRQF_TRIGGER_MASK));
 	}
 
-	*p = new;
+	*old_ptr = new;
 
 	/* Reset broken irq detection when installing new handler */
 	desc->irq_count = 0;
@@ -575,7 +575,7 @@ int setup_irq(unsigned int irq, struct irqaction *act)
 void free_irq(unsigned int irq, void *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irqaction *action, **p;
+	struct irqaction *action, **action_ptr;
 	unsigned long flags;
 
 	WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
@@ -589,9 +589,9 @@ void free_irq(unsigned int irq, void *dev_id)
 	 * There can be multiple actions per IRQ descriptor, find the right
 	 * one based on the dev_id:
 	 */
-	p = &desc->action;
+	action_ptr = &desc->action;
 	for (;;) {
-		action = *p;
+		action = *action_ptr;
 
 		if (!action) {
 			WARN(1, "Trying to free already-free IRQ %d\n", irq);
@@ -602,11 +602,11 @@ void free_irq(unsigned int irq, void *dev_id)
 
 		if (action->dev_id == dev_id)
 			break;
-		p = &action->next;
+		action_ptr = &action->next;
 	}
 
 	/* Found it - now remove it from the list of entries: */
-	*p = action->next;
+	*action_ptr = action->next;
 
 	/* Currently used only by UML, might disappear one day: */
 #ifdef CONFIG_IRQ_RELEASE_METHOD
