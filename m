Return-Path: <linux-kernel-owner+w=401wt.eu-S1760468AbXLLTnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468AbXLLTnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759119AbXLLTm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:42:58 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:64670 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758914AbXLLTm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:42:56 -0500
Date: Wed, 12 Dec 2007 14:40:09 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel <linux-kernel@vger.kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       RT <linux-rt-users@vger.kernel.org>, Daniel Walker <dwalker@mvista.com>,
       Remy Bohmer <linux@bohmer.net>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: [PATCH RT] Revert Softdisable for simple irqs.
In-Reply-To: <1196178834.23808.11.camel@imap.mvista.com>
Message-ID: <Pine.LNX.4.58.0712121436260.21795@gandalf.stny.rr.com>
References: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com>
 <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com>
 <1196176294.13982.58.camel@localhost.localdomain> <1196177122.23808.7.camel@imap.mvista.com>
 <1196178834.23808.11.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

[Note: This version is for the RT patch, and the IRQ_PENDING is needed
 for threaded IRQs]

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 kernel/irq/chip.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6.23.9-rt13/kernel/irq/chip.c
===================================================================
--- linux-2.6.23.9-rt13.orig/kernel/irq/chip.c
+++ linux-2.6.23.9-rt13/kernel/irq/chip.c
@@ -302,10 +302,9 @@ handle_simple_irq(unsigned int irq, stru
 	action = desc->action;
 	if (unlikely(!action || (desc->status & (IRQ_INPROGRESS |
 						 IRQ_DISABLED)))) {
-		if (desc->chip->mask)
-			desc->chip->mask(irq);
 		desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-		desc->status |= IRQ_PENDING;
+		if (action && (desc->status & IRQ_INPROGRESS))
+			desc->status |= IRQ_PENDING;
 		goto out_unlock;
 	}

