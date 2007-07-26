Return-Path: <linux-kernel-owner+w=401wt.eu-S936662AbXGZUOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936662AbXGZUOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934474AbXGZUN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:13:58 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52377 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507AbXGZUN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:13:57 -0400
Date: Thu, 26 Jul 2007 14:13:56 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@osdl.org>
Subject: IRQF_DISABLED problem
Message-ID: <20070726201355.GP19275@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I noticed that we only look at the first action in the chain when
determining whether to re-enable local interrupts during handle_IRQ_event.
But we don't try to exclude sharing interrupts with mixtures of
IRQF_DISABLED set and clear.  I just tried to do that locally, and one
of my USB ports disappears, because it shares an interrupt with qla2xxx
which sets IRQF_DISABLED, and UHCI doesn't.

Another possibility is to force it if *any* of the handlers want
IRQF_DISABLED.  This seems to work:

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 203a518..d804a0b 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -308,6 +308,15 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 			goto mismatch;
 #endif
 
+		/* If one handler wants interrupts to be disabled,
+		 * they must all be disabled.  Rather than walk the list of
+		 * handlers twice at interrupt time, just make sure the
+		 * head handler has its flag set
+		 */
+		if ((new->flags & IRQF_DISABLED) &&
+		    !(old->flags & IRQF_DISABLED)
+			old->flags |= IRQF_DISABLED);
+
 		/* add new interrupt at end of irq queue */
 		do {
 			p = &old->next;


This patch makes interrupts requested with IRQF_DISABLED non-matching
fail, in case you think it's a better solution:

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 203a518..2c99b88 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -293,10 +293,12 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 		 * Can't share interrupts unless both agree to and are
 		 * the same type (level, edge, polarity). So both flag
 		 * fields must have IRQF_SHARED set and the bits which
-		 * set the trigger type must match.
+		 * set the trigger type must match and the disabled bit
+		 * must match.
 		 */
 		if (!((old->flags & new->flags) & IRQF_SHARED) ||
-		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK)) {
+		    ((old->flags ^ new->flags) &
+		     (IRQF_TRIGGER_MASK | IRQF_DISABLED))) {
 			old_name = old->name;
 			goto mismatch;
 		}

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
