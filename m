Return-Path: <linux-kernel-owner+w=401wt.eu-S933009AbZHUVfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009AbZHUVfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932824AbZHUVfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:35:17 -0400
Received: from www.tglx.de ([62.245.132.106]:51921 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932955AbZHUVdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:33:20 -0400
Message-Id: <20090821205603.012122905@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:31:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 25/32] x86: Remove mca bus ifdef from timer interrupt
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-time-remove-mca-bus-ifdef.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MCA_bus is constant 0 when CONFIG_MCA=n. So the compiler removes that
code w/o needing an extra #ifdef

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/time_32.c |   18 +++---------------
 arch/x86/kernel/time_64.c |    9 +++------
 2 files changed, 6 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/x86/kernel/time_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_32.c
+++ linux-2.6/arch/x86/kernel/time_32.c
@@ -77,21 +77,9 @@ static irqreturn_t timer_interrupt(int i
 
 	global_clock_event->event_handler(global_clock_event);
 
-#ifdef CONFIG_MCA
-	if (MCA_bus) {
-		/* The PS/2 uses level-triggered interrupts.  You can't
-		turn them off, nor would you want to (any attempt to
-		enable edge-triggered interrupts usually gets intercepted by a
-		special hardware circuit).  Hence we have to acknowledge
-		the timer interrupt.  Through some incredibly stupid
-		design idea, the reset for IRQ 0 is done by setting the
-		high bit of the PPI port B (0x61).  Note that some PS/2s,
-		notably the 55SX, work fine if this is removed.  */
-
-		u8 irq_v = inb_p(0x61);		/* read the current state */
-		outb_p(irq_v | 0x80, 0x61);	/* reset the IRQ */
-	}
-#endif
+	/* MCA bus quirk: Acknowledge irq0 by setting bit 7 in port 0x61 */
+	if (MCA_bus)
+		outb_p(inb_p(0x61)| 0x80, 0x61);
 
 	return IRQ_HANDLED;
 }
Index: linux-2.6/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_64.c
+++ linux-2.6/arch/x86/kernel/time_64.c
@@ -66,12 +66,9 @@ static irqreturn_t timer_interrupt(int i
 
 	global_clock_event->event_handler(global_clock_event);
 
-#ifdef CONFIG_MCA
-	if (MCA_bus) {
-		u8 irq_v = inb_p(0x61);       /* read the current state */
-		outb_p(irq_v|0x80, 0x61);     /* reset the IRQ */
-	}
-#endif
+	/* MCA bus quirk: Acknowledge irq0 by setting bit 7 in port 0x61 */
+	if (MCA_bus)
+		outb_p(inb_p(0x61)| 0x80, 0x61);
 
 	return IRQ_HANDLED;
 }


