Return-Path: <linux-kernel-owner+w=401wt.eu-S1945910AbXEAUfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945910AbXEAUfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423665AbXEAUfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:35:20 -0400
Received: from assei1bl6.telenet-ops.be ([195.130.133.68]:33534 "EHLO
	assei1bl6.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423658AbXEAUfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:35:09 -0400
Message-Id: <20070501203336.299500248@mail.of.borg>
References: <20070501203234.252205858@mail.of.borg>
User-Agent: quilt/0.45-1
Date: Tue, 01 May 2007 22:32:58 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Finn Thain <fthain@telegraphics.com.au>
Subject: [patch 24/33] m68k: Mac IRQ cleanup
Content-Disposition: inline; filename=mac68k-finish_irq_cleanup.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

There are no slow IRQs on Macs since Roman Zippel's IRQ reorganisation that
went into 2.6.16 and removed mac_irq_list[] and the do_mac_irq_list()
dispatcher. (They were implemented in do_mac_irq_list() by lowering the IPL.)
Hence there's no more use for mutual exclusion in the Mac interrupt
dispatchers. Remove it.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mac/baboon.c |   20 +++++++-------------
 arch/m68k/mac/oss.c    |    4 ----
 arch/m68k/mac/psc.c    |    2 --
 arch/m68k/mac/via.c    |   10 ----------
 4 files changed, 7 insertions(+), 29 deletions(-)

--- linux-m68k-2.6.21.orig/arch/m68k/mac/baboon.c
+++ linux-m68k-2.6.21/arch/m68k/mac/baboon.c
@@ -22,7 +22,7 @@
 /* #define DEBUG_BABOON */
 /* #define DEBUG_IRQS */
 
-int baboon_present,baboon_active;
+int baboon_present;
 volatile struct baboon *baboon;
 
 irqreturn_t baboon_irq(int, void *);
@@ -45,7 +45,6 @@ void __init baboon_init(void)
 
 	baboon = (struct baboon *) BABOON_BASE;
 	baboon_present = 1;
-	baboon_active = 0;
 
 	printk("Baboon detected at %p\n", baboon);
 }
@@ -70,9 +69,9 @@ irqreturn_t baboon_irq(int irq, void *de
 	unsigned char events;
 
 #ifdef DEBUG_IRQS
-	printk("baboon_irq: mb_control %02X mb_ifr %02X mb_status %02X active %02X\n",
+	printk("baboon_irq: mb_control %02X mb_ifr %02X mb_status %02X\n",
 		(uint) baboon->mb_control, (uint) baboon->mb_ifr,
-		(uint) baboon->mb_status,  baboon_active);
+		(uint) baboon->mb_status);
 #endif
 
 	if (!(events = baboon->mb_ifr & 0x07))
@@ -81,11 +80,9 @@ irqreturn_t baboon_irq(int irq, void *de
 	irq_num = IRQ_BABOON_0;
 	irq_bit = 1;
 	do {
-	        if (events & irq_bit/* & baboon_active*/) {
-			baboon_active &= ~irq_bit;
+	        if (events & irq_bit) {
 			baboon->mb_ifr &= ~irq_bit;
 			m68k_handle_int(irq_num);
-			baboon_active |= irq_bit;
 		}
 		irq_bit <<= 1;
 		irq_num++;
@@ -99,21 +96,18 @@ irqreturn_t baboon_irq(int irq, void *de
 }
 
 void baboon_irq_enable(int irq) {
-	int irq_idx	= IRQ_IDX(irq);
-
 #ifdef DEBUG_IRQUSE
 	printk("baboon_irq_enable(%d)\n", irq);
 #endif
-	baboon_active |= (1 << irq_idx);
+	/* FIXME: figure out how to mask and unmask baboon interrupt sources */
+	enable_irq(IRQ_NUBUS_C);
 }
 
 void baboon_irq_disable(int irq) {
-	int irq_idx	= IRQ_IDX(irq);
-
 #ifdef DEBUG_IRQUSE
 	printk("baboon_irq_disable(%d)\n", irq);
 #endif
-	baboon_active &= ~(1 << irq_idx);
+	disable_irq(IRQ_NUBUS_C);
 }
 
 void baboon_irq_clear(int irq) {
--- linux-m68k-2.6.21.orig/arch/m68k/mac/oss.c
+++ linux-m68k-2.6.21/arch/m68k/mac/oss.c
@@ -112,10 +112,8 @@ irqreturn_t oss_irq(int irq, void *dev_i
 		oss->irq_pending &= ~OSS_IP_SOUND;
 		/* FIXME: call sound handler */
 	} else if (events & OSS_IP_SCSI) {
-		oss->irq_level[OSS_SCSI] = OSS_IRQLEV_DISABLED;
 		oss->irq_pending &= ~OSS_IP_SCSI;
 		m68k_handle_int(IRQ_MAC_SCSI);
-		oss->irq_level[OSS_SCSI] = OSS_IRQLEV_SCSI;
 	} else {
 		/* FIXME: error check here? */
 	}
@@ -149,10 +147,8 @@ irqreturn_t oss_nubus_irq(int irq, void 
 		--i;
 		irq_bit >>= 1;
 		if (events & irq_bit) {
-			oss->irq_level[i] = OSS_IRQLEV_DISABLED;
 			oss->irq_pending &= ~irq_bit;
 			m68k_handle_int(NUBUS_SOURCE_BASE + i);
-			oss->irq_level[i] = OSS_IRQLEV_NUBUS;
 		}
 	} while(events & (irq_bit - 1));
 	return IRQ_HANDLED;
--- linux-m68k-2.6.21.orig/arch/m68k/mac/psc.c
+++ linux-m68k-2.6.21/arch/m68k/mac/psc.c
@@ -147,10 +147,8 @@ irqreturn_t psc_irq(int irq, void *dev_i
 	irq_bit = 1;
 	do {
 		if (events & irq_bit) {
-			psc_write_byte(pIER, irq_bit);
 			psc_write_byte(pIFR, irq_bit);
 			m68k_handle_int(irq_num);
-			psc_write_byte(pIER, irq_bit | 0x80);
 		}
 		irq_num++;
 		irq_bit <<= 1;
--- linux-m68k-2.6.21.orig/arch/m68k/mac/via.c
+++ linux-m68k-2.6.21/arch/m68k/mac/via.c
@@ -443,11 +443,6 @@ void __init via_nubus_init(void)
 /*
  * The generic VIA interrupt routines (shamelessly stolen from Alan Cox's
  * via6522.c :-), disable/pending masks added.
- *
- * The new interrupt architecture in macints.c takes care of a lot of the
- * gruntwork for us, including tallying the interrupts and calling the
- * handlers on the linked list. All we need to do here is basically generate
- * the machspec interrupt number after clearing the interrupt.
  */
 
 irqreturn_t via1_irq(int irq, void *dev_id)
@@ -463,10 +458,8 @@ irqreturn_t via1_irq(int irq, void *dev_
 	irq_bit = 1;
 	do {
 		if (events & irq_bit) {
-			via1[vIER] = irq_bit;
 			via1[vIFR] = irq_bit;
 			m68k_handle_int(irq_num);
-			via1[vIER] = irq_bit | 0x80;
 		}
 		++irq_num;
 		irq_bit <<= 1;
@@ -502,11 +495,8 @@ irqreturn_t via2_irq(int irq, void *dev_
 	irq_bit = 1;
 	do {
 		if (events & irq_bit) {
-			via2[gIER] = irq_bit;
 			via2[gIFR] = irq_bit | rbv_clear;
 			m68k_handle_int(irq_num);
-			if (irq_num != IRQ_MAC_NUBUS || nubus_disabled == 0)
-				via2[gIER] = irq_bit | 0x80;
 		}
 		++irq_num;
 		irq_bit <<= 1;

--
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

