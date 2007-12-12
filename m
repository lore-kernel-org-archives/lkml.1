Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbXLLUVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbXLLUVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbXLLUVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:21:07 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:35570 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbXLLUVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:21:06 -0500
Date: Wed, 12 Dec 2007 15:20:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Remy Bohmer <linux@bohmer.net>, Daniel Walker <dwalker@mvista.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Revert lazy irq disable for simple irqs
Message-ID: <Pine.LNX.4.58.0712121516400.22305@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[This patch *is* for mainline Linux]

In commit 76d2160147f43f982dfe881404cfde9fd0a9da21 lazy irq disabling
was implemented, and the simple irq handler had a masking set to it.

Remy Bohmer discovered that some devices in the ARM architecture
would trigger the mask, but never unmask it. His patch to do the
unmasking was questioned by Russell King about masking simple irqs
to begin with. Looking further, it was discovered that the problems
Remy was seeing was due to improper use of the simple handler by
devices, and he later submitted patches to fix those. But the issue
that was uncovered was that the simple handler should never mask.

This patch reverts the masking in the simple handler.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 kernel/irq/chip.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: linux-compile.git/kernel/irq/chip.c
===================================================================
--- linux-compile.git.orig/kernel/irq/chip.c	2007-10-19 12:37:51.000000000 -0400
+++ linux-compile.git/kernel/irq/chip.c	2007-12-12 15:03:43.000000000 -0500
@@ -297,18 +297,13 @@ handle_simple_irq(unsigned int irq, stru

 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
+	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
 	kstat_cpu(cpu).irqs[irq]++;

 	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
-		if (desc->chip->mask)
-			desc->chip->mask(irq);
-		desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-		desc->status |= IRQ_PENDING;
+	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
 		goto out_unlock;
-	}

-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING | IRQ_PENDING);
 	desc->status |= IRQ_INPROGRESS;
 	spin_unlock(&desc->lock);


