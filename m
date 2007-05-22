Return-Path: <linux-kernel-owner+w=401wt.eu-S1765995AbXEVIiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765995AbXEVIiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757361AbXEVIh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:37:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219AbXEVIh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:37:58 -0400
Date: Tue, 22 May 2007 10:37:56 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@in.ibm.com>
Subject: [PATCH] Fix crash with irqpoll due to the IRQF_IRQPOLL flag
Message-ID: <20070522083756.GB18498@suse.de>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>
References: <20070426093620.GB2626@in.ibm.com> <20070426082405.67a0fdd2.akpm@linux-foundation.org> <20070430084833.GA16173@in.ibm.com> <20070502221932.GA488@suse.de> <20070508171841.GA29733@in.ibm.com> <20070514140513.GD29616@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514140513.GD29616@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

o System crashes if booted with irqpoll command line option.

o Problem happens because Inside note_interrupt() we are accessing
  desc->action->flag without taking the desc->lock. While accessing it
  somebody goes ahead and unregisters the irq handler hence desc->action
  is NULL. By the time note_interrupt() checks it, it crashes.

o In that system it is irq 4 seriving to serial driver.

o Take the desc->lock before accessing desc->action->flag.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
---

 linux-2.6.21-git12-root/kernel/irq/spurious.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff -puN kernel/irq/spurious.c~fix-irqpoll-crash kernel/irq/spurious.c
--- linux-2.6.21-git12/kernel/irq/spurious.c~fix-irqpoll-crash	2007-05-17 17:36:50.000000000 +0530
+++ linux-2.6.21-git12-root/kernel/irq/spurious.c	2007-05-17 17:53:52.000000000 +0530
@@ -138,6 +138,8 @@ report_bad_irq(unsigned int irq, struct 
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
+	int call_misrouted_irq = 0;
+
 	if (unlikely(action_ret != IRQ_HANDLED)) {
 		desc->irqs_unhandled++;
 		if (unlikely(action_ret != IRQ_NONE))
@@ -146,9 +148,24 @@ void note_interrupt(unsigned int irq, st
 
 	if (unlikely(irqfixup)) {
 		/* Don't punish working computers */
-		if ((irqfixup == 2 && ((irq == 0) ||
-				(desc->action->flags & IRQF_IRQPOLL))) ||
-				action_ret == IRQ_NONE) {
+		if (action_ret == IRQ_NONE)
+			/* Nobody handled irq. Possibly a misrouted one. */
+			call_misrouted_irq = 1;
+		else if (irqfixup == 2) {
+			/* irqpoll is enabled. Is this the irq driving
+			 * polling.
+			 */
+			if (irq == 0)
+				call_misrouted_irq = 1;
+			else {
+				spin_lock(&desc->lock);
+				if (desc->action &&
+					(desc->action->flags & IRQF_IRQPOLL))
+					call_misrouted_irq = 1;
+				spin_unlock(&desc->lock);
+			}
+		}
+		if (call_misrouted_irq) {
 			int ok = misrouted_irq(irq);
 			if (action_ret == IRQ_NONE)
 				desc->irqs_unhandled -= ok;
_
