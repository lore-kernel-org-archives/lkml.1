Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbYE0UTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbYE0UTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 16:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759188AbYE0UTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 16:19:31 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63897 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759143AbYE0UTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 16:19:31 -0400
Date: Tue, 27 May 2008 21:19:16 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] x86: I/O APIC: Fix the name of the through-8259A handler
Message-ID: <Pine.LNX.4.55.0805271911440.18833@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 When the through-8259A mode is used for the timer, the call to
set_irq_handler() will register a NULL handler name, resulting in
"IO-APIC-<NULL>" reported.  Fix by calling ioapic_register_intr() as done
for all the other I/O APIC interrupts.

 The 64-bit variation calls set_irq_chip_and_handler_name() here
needlessly and should get fixed with the upcoming merge.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-timer-extint-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-05 02:55:24.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-05-25 01:54:08.000000000 +0000
@@ -1331,8 +1331,7 @@ static void __init setup_ExtINT_IRQ0_pin
 	 * The timer IRQ doesn't have to know that behind the
 	 * scene we have a 8259A-master in AEOI mode ...
 	 */
-	irq_desc[0].chip = &ioapic_chip;
-	set_irq_handler(0, handle_edge_irq);
+	ioapic_register_intr(0, vector, IOAPIC_EDGE);
 
 	/*
 	 * Add it to the IO-APIC irq-routing table:
