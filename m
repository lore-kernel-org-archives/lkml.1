Return-Path: <linux-kernel-owner+w=401wt.eu-S1761217AbXLLTut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761217AbXLLTut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761041AbXLLTuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:50:35 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:39208 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761013AbXLLTue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:50:34 -0500
Date: Wed, 12 Dec 2007 14:50:02 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] handle IRQ_PENDING for simple irq handler
Message-ID: <Pine.LNX.4.58.0712121446550.21926@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With the IO-APIC pcix hack (level=>edge masking), we can receive
interrupts while masked. But these interrupts might be missed.

Also, normal "simple" interrupts might be missed too on leaving of
thread handler.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Index: linux-2.6.21-rt-hack/kernel/irq/manage.c
===================================================================
--- linux-2.6.21-rt-hack.orig/kernel/irq/manage.c
+++ linux-2.6.21-rt-hack/kernel/irq/manage.c
@@ -628,14 +628,17 @@ static void thread_simple_irq(irq_desc_t
 	unsigned int irq = desc - irq_desc;
 	irqreturn_t action_ret;

-	if (action && !desc->depth) {
+	do {
+		if (!action || desc->depth)
+			break;
+		desc->status &= ~IRQ_PENDING;
 		spin_unlock(&desc->lock);
 		action_ret = handle_IRQ_event(irq, action);
 		cond_resched_hardirq_context();
 		spin_lock_irq(&desc->lock);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
-	}
+	} while (desc->status & IRQ_PENDING);
 	desc->status &= ~IRQ_INPROGRESS;
 }



