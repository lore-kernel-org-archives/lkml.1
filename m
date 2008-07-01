Return-Path: <linux-kernel-owner+w=401wt.eu-S1761174AbYGAAU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761174AbYGAAU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 20:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbYGAAUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 20:20:14 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62218 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754452AbYGAAUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 20:20:13 -0400
Date: Tue, 1 Jul 2008 01:19:31 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: I/O APIC: Add a 64-bit variation of replace_pin_at_irq()
Message-ID: <Pine.LNX.4.55.0807010112360.30785@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 When an interrupt is rerouted to a different I/O APIC pin the relevant
entry of the irq_2_pin list should get updated accordingly so that
operations are performed on the correct redirection entry.  This is
already done by the 32-bit variation of the code and here is a
complementing 64-bit implementation.  Should make someone's decision less
tough when merging the two. ;)

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-ioapic-replace-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c	2008-06-18 03:24:54.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c	2008-06-19 23:15:58.000000000 +0000
@@ -360,6 +360,26 @@ static void add_pin_to_irq(unsigned int 
 	entry->pin = pin;
 }
 
+/*
+ * Reroute an IRQ to a different pin.
+ */
+static void __init replace_pin_at_irq(unsigned int irq,
+				      int oldapic, int oldpin,
+				      int newapic, int newpin)
+{
+	struct irq_pin_list *entry = irq_2_pin + irq;
+
+	while (1) {
+		if (entry->apic == oldapic && entry->pin == oldpin) {
+			entry->apic = newapic;
+			entry->pin = newpin;
+		}
+		if (!entry->next)
+			break;
+		entry = irq_2_pin + entry->next;
+	}
+}
+
 
 #define DO_ACTION(name,R,ACTION, FINAL)					\
 									\
@@ -1711,7 +1731,7 @@ static inline void __init check_timer(vo
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		/* replace_pin_at_irq(0, apic1, pin1, apic2, pin2); */
+		replace_pin_at_irq(0, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
 		unmask_IO_APIC_irq(0);
 		enable_8259A_irq(0);
