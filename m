Return-Path: <linux-kernel-owner+w=401wt.eu-S1761513AbXGTMLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513AbXGTMLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbXGTMLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:11:34 -0400
Received: from ozlabs.org ([203.10.76.45]:53182 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbXGTMLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:11:34 -0400
Subject: [PATCH 1/3] lguest: fix sense if IF flag on interrupt injection
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 22:11:13 +1000
Message-Id: <1184933473.10380.296.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The sense of the IF bit is backwards in the host interrupt handling.

This means we always save "IF=1" on the stack when injecting an
interrupt.  It turns out this is almost always correct (unless the
guest is taking a page fault in an interrupt due to an unpopulated
vmalloc mapping), so went unnoticed.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/interrupts_and_traps.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -r 209f5cd5cda5 drivers/lguest/interrupts_and_traps.c
--- a/drivers/lguest/interrupts_and_traps.c	Fri Jul 20 14:53:40 2007 +1000
+++ b/drivers/lguest/interrupts_and_traps.c	Fri Jul 20 21:34:06 2007 +1000
@@ -38,12 +38,12 @@ static void set_guest_interrupt(struct l
 		ss = lg->regs->ss;
 	}
 
-	/* We use IF bit in eflags to indicate whether irqs were disabled
-	   (it's always 0, since irqs are enabled when guest is running). */
+	/* We use IF bit in eflags to indicate whether irqs were enabled
+	   (it's always 1, since irqs are enabled when guest is running). */
 	eflags = lg->regs->eflags;
-	if (get_user(irq_enable, &lg->lguest_data->irq_enabled))
-		irq_enable = 0;
-	eflags |= (irq_enable & X86_EFLAGS_IF);
+	if (get_user(irq_enable, &lg->lguest_data->irq_enabled) == 0
+	    && !(irq_enable & X86_EFLAGS_IF))
+		eflags &= ~X86_EFLAGS_IF;
 
 	push_guest_stack(lg, &gstack, eflags);
 	push_guest_stack(lg, &gstack, lg->regs->cs);


