Return-Path: <linux-kernel-owner+w=401wt.eu-S1762297AbYAKSVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762297AbYAKSVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 13:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYAKSVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 13:21:34 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56606 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753387AbYAKSVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 13:21:33 -0500
Date: Fri, 11 Jan 2008 18:18:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Isolate PIC/PIT in/out calls
Message-ID: <20080111181846.5ead1220@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than remove and/or mangle inb_p/outb_p we want to remove the use
of them from inappropriate places. For the PIC/PIT this may eventually
depend on 32/64bitism or similar so start by adding inb/outb_pit and
inb/outb_pic so that we can make them use any scheme we settle on without
disturbing the existing, correct (for ISA), port 0x80 usage. (eg we can
make inb_pit use udelay without messing up inb_p).

Floppy already does this for the fdc. That really only leaves the CMOS as
a core logic item to tackle, and bits of parallel port handling in the
chipset layers.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/arch/x86/kernel/apm_32.c linux-2.6.24-rc6-mm1/arch/x86/kernel/apm_32.c
--- linux.vanilla-2.6.24-rc6-mm1/arch/x86/kernel/apm_32.c	2008-01-02 16:04:19.000000000 +0000
+++ linux-2.6.24-rc6-mm1/arch/x86/kernel/apm_32.c	2008-01-11 15:05:39.000000000 +0000
@@ -1172,11 +1172,11 @@
 
 	spin_lock_irqsave(&i8253_lock, flags);
 	/* set the clock to HZ */
-	outb_p(0x34, PIT_MODE);		/* binary, mode 2, LSB/MSB, ch 0 */
+	outb_pit(0x34, PIT_MODE);		/* binary, mode 2, LSB/MSB, ch 0 */
 	udelay(10);
-	outb_p(LATCH & 0xff, PIT_CH0);	/* LSB */
+	outb_pit(LATCH & 0xff, PIT_CH0);	/* LSB */
 	udelay(10);
-	outb(LATCH >> 8, PIT_CH0);	/* MSB */
+	outb_pit(LATCH >> 8, PIT_CH0);	/* MSB */
 	udelay(10);
 	spin_unlock_irqrestore(&i8253_lock, flags);
 #endif
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/arch/x86/kernel/i8253.c linux-2.6.24-rc6-mm1/arch/x86/kernel/i8253.c
--- linux.vanilla-2.6.24-rc6-mm1/arch/x86/kernel/i8253.c	2008-01-02 16:04:19.000000000 +0000
+++ linux-2.6.24-rc6-mm1/arch/x86/kernel/i8253.c	2008-01-11 15:10:09.000000000 +0000
@@ -36,24 +36,24 @@
 	switch(mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		/* binary, mode 2, LSB/MSB, ch 0 */
-		outb_p(0x34, PIT_MODE);
-		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
-		outb(LATCH >> 8 , PIT_CH0);	/* MSB */
+		outb_pit(0x34, PIT_MODE);
+		outb_pit(LATCH & 0xff , PIT_CH0);	/* LSB */
+		outb_pit(LATCH >> 8 , PIT_CH0);		/* MSB */
 		break;
 
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	case CLOCK_EVT_MODE_UNUSED:
 		if (evt->mode == CLOCK_EVT_MODE_PERIODIC ||
 		    evt->mode == CLOCK_EVT_MODE_ONESHOT) {
-			outb_p(0x30, PIT_MODE);
-			outb_p(0, PIT_CH0);
-			outb_p(0, PIT_CH0);
+			outb_pit(0x30, PIT_MODE);
+			outb_pit(0, PIT_CH0);
+			outb_pit(0, PIT_CH0);
 		}
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
 		/* One shot setup */
-		outb_p(0x38, PIT_MODE);
+		outb_pit(0x38, PIT_MODE);
 		break;
 
 	case CLOCK_EVT_MODE_RESUME:
@@ -71,8 +71,8 @@
 static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
 {
 	spin_lock(&i8253_lock);
-	outb_p(delta & 0xff , PIT_CH0);	/* LSB */
-	outb(delta >> 8 , PIT_CH0);	/* MSB */
+	outb_pit(delta & 0xff , PIT_CH0);	/* LSB */
+	outb_pit(delta >> 8 , PIT_CH0);		/* MSB */
 	spin_unlock(&i8253_lock);
 
 	return 0;
@@ -144,15 +144,15 @@
 	 * count), it cannot be newer.
 	 */
 	jifs = jiffies;
-	outb_p(0x00, PIT_MODE);	/* latch the count ASAP */
-	count = inb_p(PIT_CH0);	/* read the latched count */
-	count |= inb_p(PIT_CH0) << 8;
+	outb_pit(0x00, PIT_MODE);	/* latch the count ASAP */
+	count = inb_pit(PIT_CH0);	/* read the latched count */
+	count |= inb_pit(PIT_CH0) << 8;
 
 	/* VIA686a test code... reset the latch if count > max + 1 */
 	if (count > LATCH) {
-		outb_p(0x34, PIT_MODE);
-		outb_p(LATCH & 0xff, PIT_CH0);
-		outb(LATCH >> 8, PIT_CH0);
+		outb_pit(0x34, PIT_MODE);
+		outb_pit(LATCH & 0xff, PIT_CH0);
+		outb_pit(LATCH >> 8, PIT_CH0);
 		count = LATCH - 1;
 	}
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/arch/x86/kernel/i8259_32.c linux-2.6.24-rc6-mm1/arch/x86/kernel/i8259_32.c
--- linux.vanilla-2.6.24-rc6-mm1/arch/x86/kernel/i8259_32.c	2008-01-02 16:04:19.000000000 +0000
+++ linux-2.6.24-rc6-mm1/arch/x86/kernel/i8259_32.c	2008-01-11 15:11:24.000000000 +0000
@@ -289,20 +289,20 @@
 	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
 
 	/*
-	 * outb_p - this has to work on a wide range of PC hardware.
+	 * outb_pic - this has to work on a wide range of PC hardware.
 	 */
-	outb_p(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
-	outb_p(0x20 + 0, PIC_MASTER_IMR);	/* ICW2: 8259A-1 IR0-7 mapped to 0x20-0x27 */
-	outb_p(1U << PIC_CASCADE_IR, PIC_MASTER_IMR);	/* 8259A-1 (the master) has a slave on IR2 */
+	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
+	outb_pic(0x20 + 0, PIC_MASTER_IMR);	/* ICW2: 8259A-1 IR0-7 mapped to 0x20-0x27 */
+	outb_pic(1U << PIC_CASCADE_IR, PIC_MASTER_IMR);	/* 8259A-1 (the master) has a slave on IR2 */
 	if (auto_eoi)	/* master does Auto EOI */
-		outb_p(MASTER_ICW4_DEFAULT | PIC_ICW4_AEOI, PIC_MASTER_IMR);
+		outb_pic(MASTER_ICW4_DEFAULT | PIC_ICW4_AEOI, PIC_MASTER_IMR);
 	else		/* master expects normal EOI */
-		outb_p(MASTER_ICW4_DEFAULT, PIC_MASTER_IMR);
+		outb_pic(MASTER_ICW4_DEFAULT, PIC_MASTER_IMR);
 
-	outb_p(0x11, PIC_SLAVE_CMD);	/* ICW1: select 8259A-2 init */
-	outb_p(0x20 + 8, PIC_SLAVE_IMR);	/* ICW2: 8259A-2 IR0-7 mapped to 0x28-0x2f */
-	outb_p(PIC_CASCADE_IR, PIC_SLAVE_IMR);	/* 8259A-2 is a slave on master's IR2 */
-	outb_p(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR); /* (slave's support for AEOI in flat mode is to be investigated) */
+	outb_pic(0x11, PIC_SLAVE_CMD);	/* ICW1: select 8259A-2 init */
+	outb_pic(0x20 + 8, PIC_SLAVE_IMR);	/* ICW2: 8259A-2 IR0-7 mapped to 0x28-0x2f */
+	outb_pic(PIC_CASCADE_IR, PIC_SLAVE_IMR);	/* 8259A-2 is a slave on master's IR2 */
+	outb_pic(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR); /* (slave's support for AEOI in flat mode is to be investigated) */
 	if (auto_eoi)
 		/*
 		 * In AEOI mode we just have to mask the interrupt
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/arch/x86/kernel/i8259_64.c linux-2.6.24-rc6-mm1/arch/x86/kernel/i8259_64.c
--- linux.vanilla-2.6.24-rc6-mm1/arch/x86/kernel/i8259_64.c	2008-01-02 16:04:19.000000000 +0000
+++ linux-2.6.24-rc6-mm1/arch/x86/kernel/i8259_64.c	2008-01-11 15:11:55.000000000 +0000
@@ -359,25 +359,25 @@
 	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
 
 	/*
-	 * outb_p - this has to work on a wide range of PC hardware.
+	 * outb_pic - this has to work on a wide range of PC hardware.
 	 */
-	outb_p(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
+	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
 	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 */
-	outb_p(IRQ0_VECTOR, PIC_MASTER_IMR);
+	outb_pic(IRQ0_VECTOR, PIC_MASTER_IMR);
 	/* 8259A-1 (the master) has a slave on IR2 */
-	outb_p(0x04, PIC_MASTER_IMR);
+	outb_pic(0x04, PIC_MASTER_IMR);
 	if (auto_eoi)	/* master does Auto EOI */
-		outb_p(MASTER_ICW4_DEFAULT | PIC_ICW4_AEOI, PIC_MASTER_IMR);
+		outb_pic(MASTER_ICW4_DEFAULT | PIC_ICW4_AEOI, PIC_MASTER_IMR);
 	else		/* master expects normal EOI */
-		outb_p(MASTER_ICW4_DEFAULT, PIC_MASTER_IMR);
+		outb_pic(MASTER_ICW4_DEFAULT, PIC_MASTER_IMR);
 
-	outb_p(0x11, PIC_SLAVE_CMD);	/* ICW1: select 8259A-2 init */
+	outb_pic(0x11, PIC_SLAVE_CMD);	/* ICW1: select 8259A-2 init */
 	/* ICW2: 8259A-2 IR0-7 mapped to 0x38-0x3f */
-	outb_p(IRQ8_VECTOR, PIC_SLAVE_IMR);
+	outb_pic(IRQ8_VECTOR, PIC_SLAVE_IMR);
 	/* 8259A-2 is a slave on master's IR2 */
-	outb_p(PIC_CASCADE_IR, PIC_SLAVE_IMR);
+	outb_pic(PIC_CASCADE_IR, PIC_SLAVE_IMR);
 	/* (slave's support for AEOI in flat mode is to be investigated) */
-	outb_p(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR);
+	outb_pic(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR);
 
 	if (auto_eoi)
 		/*
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/arch/x86/kernel/reboot_64.c linux-2.6.24-rc6-mm1/arch/x86/kernel/reboot_64.c
--- linux.vanilla-2.6.24-rc6-mm1/arch/x86/kernel/reboot_64.c	2008-01-02 16:04:19.000000000 +0000
+++ linux-2.6.24-rc6-mm1/arch/x86/kernel/reboot_64.c	2008-01-11 15:15:42.000000000 +0000
@@ -79,9 +79,13 @@
 {
 	int i;
 
-	for (i=0; i<0x10000; i++)
-		if ((inb_p(0x64) & 0x02) == 0)
+	for (i=0; i<0x10000; i++) {
+		if ((inb(0x64) & 0x02) == 0)
 			break;
+		udelay(10);
+		cpu_relax();
+	}
+	/* No delay on successful read, but this is done by caller */
 }
 
 void machine_shutdown(void)
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/arch/x86/kernel/vmiclock_32.c linux-2.6.24-rc6-mm1/arch/x86/kernel/vmiclock_32.c
--- linux.vanilla-2.6.24-rc6-mm1/arch/x86/kernel/vmiclock_32.c	2008-01-02 16:04:19.000000000 +0000
+++ linux-2.6.24-rc6-mm1/arch/x86/kernel/vmiclock_32.c	2008-01-11 15:04:13.000000000 +0000
@@ -237,7 +237,7 @@
 void __init vmi_time_init(void)
 {
 	/* Disable PIT: BIOSes start PIT CH0 with 18.2hz peridic. */
-	outb_p(0x3a, PIT_MODE); /* binary, mode 5, LSB/MSB, ch 0 */
+	outb_pit(0x3a, PIT_MODE); /* binary, mode 5, LSB/MSB, ch 0 */
 
 	vmi_time_init_clockevent();
 	setup_irq(0, &vmi_clock_action);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/include/asm-x86/i8253.h linux-2.6.24-rc6-mm1/include/asm-x86/i8253.h
--- linux.vanilla-2.6.24-rc6-mm1/include/asm-x86/i8253.h	2008-01-02 16:04:07.000000000 +0000
+++ linux-2.6.24-rc6-mm1/include/asm-x86/i8253.h	2008-01-11 15:26:10.000000000 +0000
@@ -12,4 +12,7 @@
 
 extern void setup_pit_timer(void);
 
+#define inb_pit		inb_p
+#define outb_pit	outb_p
+
 #endif	/* __ASM_I8253_H__ */
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/include/asm-x86/i8259.h linux-2.6.24-rc6-mm1/include/asm-x86/i8259.h
--- linux.vanilla-2.6.24-rc6-mm1/include/asm-x86/i8259.h	2008-01-02 16:04:25.000000000 +0000
+++ linux-2.6.24-rc6-mm1/include/asm-x86/i8259.h	2008-01-11 15:25:33.000000000 +0000
@@ -29,4 +29,7 @@
 extern void disable_8259A_irq(unsigned int irq);
 extern unsigned int startup_8259A_irq(unsigned int irq);
 
+#define inb_pic		inb_p
+#define outb_pic	outb_p
+
 #endif	/* __ASM_I8259_H__ */
