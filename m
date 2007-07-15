Return-Path: <linux-kernel-owner+w=401wt.eu-S1763336AbXGOQN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763336AbXGOQN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762710AbXGOQFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:23 -0400
Received: from www.osadl.org ([213.239.205.134]:42591 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762464AbXGOQFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:10 -0400
Message-Id: <20070715155541.561244482@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:11:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 20/33] x86_64: remove pit synchronization
Content-Disposition: inline;
	filename=x86_64-apic-remove-bogus-pit-synchronization.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The APIC timer setup code synchronizes the local APIC timer to the
PIT/HPET. This is pointless as the PIT and the local APIC timer
frequency are not correlated and the APIC timer calibration can never
be accurate enough to avoid that the local APIC timer and the PIT/HPET
drift apart.

Simply remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86_64/kernel/apic.c |   20 --------------------
 1 file changed, 20 deletions(-)

Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/apic.c	2007-07-15 17:39:44.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c	2007-07-15 17:48:58.000000000 +0200
@@ -791,26 +791,6 @@ static void setup_APIC_timer(unsigned in
 
 	local_irq_save(flags);
 
-	/* wait for irq slice */
-	if (hpet_address && hpet_use_timer) {
-		int trigger = hpet_readl(HPET_T0_CMP);
-		while (hpet_readl(HPET_COUNTER) >= trigger)
-			/* do nothing */ ;
-		while (hpet_readl(HPET_COUNTER) <  trigger)
-			/* do nothing */ ;
-	} else {
-		int c1, c2;
-		outb_p(0x00, 0x43);
-		c2 = inb_p(0x40);
-		c2 |= inb_p(0x40) << 8;
-		do {
-			c1 = c2;
-			outb_p(0x00, 0x43);
-			c2 = inb_p(0x40);
-			c2 |= inb_p(0x40) << 8;
-		} while (c2 - c1 < 300);
-	}
-
 	irqen = ! cpu_isset(smp_processor_id(),
 			    timer_interrupt_broadcast_ipi_mask);
 	__setup_APIC_LVTT(clocks, 0, irqen);

-- 

