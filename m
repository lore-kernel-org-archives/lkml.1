Return-Path: <linux-kernel-owner+w=401wt.eu-S937837AbYEUVOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937837AbYEUVOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757328AbYEUVKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:10:48 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63955 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937113AbYEUVKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:10:46 -0400
Date: Wed, 21 May 2008 22:10:32 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] x86: I/O APIC: Timer through 8259A second-chance
Message-ID: <Pine.LNX.4.55.0805212036320.4894@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Some systems incorrectly report the ExtINTA pin of the I/O APIC as the
genuine target of the timer interrupt.  Here is a change that copies timer
pin information found to the other pin if one has been found only.  This 
way both a direct and a through-8259A route is tested with the pin letting 
these problematic systems work well enough.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-timer-pins-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-21 18:52:36.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-05-21 18:52:36.000000000 +0000
@@ -2166,6 +2166,21 @@ static inline void __init check_timer(vo
 	printk(KERN_INFO "..TIMER: vector=0x%02X apic1=%d pin1=%d apic2=%d pin2=%d\n",
 		vector, apic1, pin1, apic2, pin2);
 
+	/*
+	 * Some BIOS writers are clueless and report the ExtINTA
+	 * I/O APIC input from the cascaded 8259A as the timer
+	 * interrupt input.  So just in case, if only one pin
+	 * was found above, try it both directly and through the
+	 * 8259A.  --macro
+	 */
+	if (pin1 == -1) {
+		pin1 = pin2;
+		apic1 = apic2;
+	} else if (pin2 == -1) {
+		pin2 = pin1;
+		apic2 = apic1;
+	}
+
 	if (pin1 != -1) {
 		/*
 		 * Ok, does IRQ0 through the IOAPIC work?
@@ -2196,7 +2211,7 @@ static inline void __init check_timer(vo
 		if (timer_irq_works()) {
 			printk("works.\n");
 			timer_through_8259 = 1;
-			if (pin1 != -1)
+			if (pin2 != pin1 || apic2 != apic1)
 				replace_pin_at_irq(0, apic1, pin1, apic2, pin2);
 			else
 				add_pin_to_irq(0, apic2, pin2);
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c	2008-05-18 00:24:43.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c	2008-05-18 00:24:43.000000000 +0000
@@ -1669,6 +1669,21 @@ static inline void __init check_timer(vo
 	apic_printk(APIC_VERBOSE,KERN_INFO "..TIMER: vector=0x%02X apic1=%d pin1=%d apic2=%d pin2=%d\n",
 		cfg->vector, apic1, pin1, apic2, pin2);
 
+	/*
+	 * Some BIOS writers are clueless and report the ExtINTA
+	 * I/O APIC input from the cascaded 8259A as the timer
+	 * interrupt input.  So just in case, if only one pin
+	 * was found above, try it both directly and through the
+	 * 8259A.  --macro
+	 */
+	if (pin1 == -1) {
+		pin1 = pin2;
+		apic1 = apic2;
+	} else if (pin2 == -1) {
+		pin2 = pin1;
+		apic2 = apic1;
+	}
+
 	if (pin1 != -1) {
 		/*
 		 * Ok, does IRQ0 through the IOAPIC work?
