Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbXKMFfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbXKMFfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 00:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbXKMFfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 00:35:24 -0500
Received: from zachs.place.org ([66.219.59.183]:34445 "EHLO place.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738AbXKMFfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 00:35:23 -0500
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH] Make i8259_64 more _32-like and remove io_ports.h
Date: Mon, 12 Nov 2007 23:35:22 -0600
From: Paul Jimenez <pj@place.org>
Message-Id: <20071113053522.5E6548B2C@place.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch mainly hinges around two includes and their ramifications:

 #include <i8259.h>
 #include <io_ports.h>

io_ports.h is very short, and contains only #defs relating to i8259
code. Rolling the contents of io_ports.h into i8259.h (where it seems
more fitting anyway) removed 140+ lines of diffs between i8259_32.c and
i8259_64.c, thus making it easier for the real substantitive differences
between them to show up, and hopefully therefore making it easier to
eventually merge the two.

Also, there's some cleanup of i8259_* code to make checkpatch happier.

Signed-off-by: Paul Jimenez <pj@place.org>
---

This replaces a previous version of this patch that tried to be more
conservative but ended up not building under x86_64 with allnoconfig.

 arch/x86/kernel/apic_32.c               |    2 -
 arch/x86/kernel/apm_32.c                |    2 -
 arch/x86/kernel/i8259_32.c              |   16 ++--
 arch/x86/kernel/i8259_64.c              |  141 +++++++++++++++----------------
 arch/x86/kernel/io_apic_32.c            |    2 -
 arch/x86/kernel/time_32.c               |    2 -
 arch/x86/kernel/vmiclock_32.c           |    1 -
 include/asm-x86/i8259.h                 |   15 ++++
 include/asm-x86/mach-default/io_ports.h |   25 ------
 9 files changed, 92 insertions(+), 114 deletions(-)
 delete mode 100644 include/asm-x86/mach-default/io_ports.h

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 08b07c1..270eb51 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -43,8 +43,6 @@
 #include <mach_apicdef.h>
 #include <mach_ipi.h>
 
-#include "io_ports.h"
-
 /*
  * Sanity check
  */
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 17089a0..8cd9778 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -235,8 +235,6 @@
 #include <asm/paravirt.h>
 #include <asm/reboot.h>
 
-#include "io_ports.h"
-
 #if defined(CONFIG_APM_DISPLAY_BLANK) && defined(CONFIG_VT)
 extern int (*console_blank_hook)(int);
 #endif
diff --git a/arch/x86/kernel/i8259_32.c b/arch/x86/kernel/i8259_32.c
index f634fc7..a5dc3a4 100644
--- a/arch/x86/kernel/i8259_32.c
+++ b/arch/x86/kernel/i8259_32.c
@@ -21,8 +21,6 @@
 #include <asm/arch_hooks.h>
 #include <asm/i8259.h>
 
-#include <io_ports.h>
-
 /*
  * This is the 'legacy' 8259A Programmable Interrupt Controller,
  * present in the majority of PC/AT boxes.
@@ -129,14 +127,14 @@ static inline int i8259A_irq_real(unsigned int irq)
 	int irqmask = 1<<irq;
 
 	if (irq < 8) {
-		outb(0x0B,PIC_MASTER_CMD);	/* ISR register */
+		outb(0x0B, PIC_MASTER_CMD);	/* ISR register */
 		value = inb(PIC_MASTER_CMD) & irqmask;
-		outb(0x0A,PIC_MASTER_CMD);	/* back to the IRR register */
+		outb(0x0A, PIC_MASTER_CMD);	/* back to the IRR register */
 		return value;
 	}
-	outb(0x0B,PIC_SLAVE_CMD);	/* ISR register */
+	outb(0x0B, PIC_SLAVE_CMD);	/* ISR register */
 	value = inb(PIC_SLAVE_CMD) & (irqmask >> 8);
-	outb(0x0A,PIC_SLAVE_CMD);	/* back to the IRR register */
+	outb(0x0A, PIC_SLAVE_CMD);	/* back to the IRR register */
 	return value;
 }
 
@@ -175,12 +173,12 @@ handle_real_irq:
 	if (irq & 8) {
 		inb(PIC_SLAVE_IMR);	/* DUMMY - (do we need this?) */
 		outb(cached_slave_mask, PIC_SLAVE_IMR);
-		outb(0x60+(irq&7),PIC_SLAVE_CMD);/* 'Specific EOI' to slave */
-		outb(0x60+PIC_CASCADE_IR,PIC_MASTER_CMD); /* 'Specific EOI' to master-IRQ2 */
+		outb(0x60+(irq&7), PIC_SLAVE_CMD);/* 'Specific EOI' to slave */
+		outb(0x60+PIC_CASCADE_IR, PIC_MASTER_CMD); /* 'Specific EOI' to master-IRQ2 */
 	} else {
 		inb(PIC_MASTER_IMR);	/* DUMMY - (do we need this?) */
 		outb(cached_master_mask, PIC_MASTER_IMR);
-		outb(0x60+irq,PIC_MASTER_CMD);	/* 'Specific EOI to master */
+		outb(0x60+irq, PIC_MASTER_CMD);	/* 'Specific EOI' to master */
 	}
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 	return;
diff --git a/arch/x86/kernel/i8259_64.c b/arch/x86/kernel/i8259_64.c
index 3f27ea0..1e495f0 100644
--- a/arch/x86/kernel/i8259_64.c
+++ b/arch/x86/kernel/i8259_64.c
@@ -21,6 +21,7 @@
 #include <asm/delay.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
+#include <asm/i8259.h>
 
 /*
  * Common place to define all x86 IRQ vectors
@@ -114,11 +115,7 @@ static struct irq_chip i8259A_chip = {
 /*
  * This contains the irq mask for both 8259A irq controllers,
  */
-static unsigned int cached_irq_mask = 0xffff;
-
-#define __byte(x,y) 	(((unsigned char *)&(y))[x])
-#define cached_21	(__byte(0,cached_irq_mask))
-#define cached_A1	(__byte(1,cached_irq_mask))
+unsigned int cached_irq_mask = 0xffff;
 
 /*
  * Not all IRQs can be routed through the IO-APIC, eg. on certain (older)
@@ -139,9 +136,9 @@ void disable_8259A_irq(unsigned int irq)
 	spin_lock_irqsave(&i8259A_lock, flags);
 	cached_irq_mask |= mask;
 	if (irq & 8)
-		outb(cached_A1,0xA1);
+		outb(cached_slave_mask, PIC_SLAVE_IMR);
 	else
-		outb(cached_21,0x21);
+		outb(cached_master_mask, PIC_MASTER_IMR);
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
@@ -153,9 +150,9 @@ void enable_8259A_irq(unsigned int irq)
 	spin_lock_irqsave(&i8259A_lock, flags);
 	cached_irq_mask &= mask;
 	if (irq & 8)
-		outb(cached_A1,0xA1);
+		outb(cached_slave_mask, PIC_SLAVE_IMR);
 	else
-		outb(cached_21,0x21);
+		outb(cached_master_mask, PIC_MASTER_IMR);
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
@@ -167,9 +164,9 @@ int i8259A_irq_pending(unsigned int irq)
 
 	spin_lock_irqsave(&i8259A_lock, flags);
 	if (irq < 8)
-		ret = inb(0x20) & mask;
+		ret = inb(PIC_MASTER_CMD) & mask;
 	else
-		ret = inb(0xA0) & (mask >> 8);
+		ret = inb(PIC_SLAVE_CMD) & (mask >> 8);
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 
 	return ret;
@@ -196,14 +193,14 @@ static inline int i8259A_irq_real(unsigned int irq)
 	int irqmask = 1<<irq;
 
 	if (irq < 8) {
-		outb(0x0B,0x20);		/* ISR register */
-		value = inb(0x20) & irqmask;
-		outb(0x0A,0x20);		/* back to the IRR register */
+		outb(0x0B, PIC_MASTER_CMD);	/* ISR register */
+		value = inb(PIC_MASTER_CMD) & irqmask;
+		outb(0x0A, PIC_MASTER_CMD);	/* back to the IRR register */
 		return value;
 	}
-	outb(0x0B,0xA0);		/* ISR register */
-	value = inb(0xA0) & (irqmask >> 8);
-	outb(0x0A,0xA0);		/* back to the IRR register */
+	outb(0x0B, PIC_SLAVE_CMD);	/* ISR register */
+	value = inb(PIC_SLAVE_CMD) & (irqmask >> 8);
+	outb(0x0A, PIC_SLAVE_CMD);	/* back to the IRR register */
 	return value;
 }
 
@@ -240,14 +237,14 @@ static void mask_and_ack_8259A(unsigned int irq)
 
 handle_real_irq:
 	if (irq & 8) {
-		inb(0xA1);		/* DUMMY - (do we need this?) */
-		outb(cached_A1,0xA1);
-		outb(0x60+(irq&7),0xA0);/* 'Specific EOI' to slave */
-		outb(0x62,0x20);	/* 'Specific EOI' to master-IRQ2 */
+		inb(PIC_SLAVE_IMR);	/* DUMMY - (do we need this?) */
+		outb(cached_slave_mask, PIC_SLAVE_IMR);
+		outb(0x60+(irq&7), PIC_SLAVE_CMD);/* 'Specific EOI' to slave */
+		outb(0x60+PIC_CASCADE_IR, PIC_MASTER_CMD); /* 'Specific EOI' to master-IRQ2 */
 	} else {
-		inb(0x21);		/* DUMMY - (do we need this?) */
-		outb(cached_21,0x21);
-		outb(0x60+irq,0x20);	/* 'Specific EOI' to master */
+		inb(PIC_MASTER_IMR);	/* DUMMY - (do we need this?) */
+		outb(cached_master_mask, PIC_MASTER_IMR);
+		outb(0x60+irq, PIC_MASTER_CMD);	/* 'Specific EOI' to master */
 	}
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 	return;
@@ -283,51 +280,6 @@ spurious_8259A_irq:
 	}
 }
 
-void init_8259A(int auto_eoi)
-{
-	unsigned long flags;
-
-	i8259A_auto_eoi = auto_eoi;
-
-	spin_lock_irqsave(&i8259A_lock, flags);
-
-	outb(0xff, 0x21);	/* mask all of 8259A-1 */
-	outb(0xff, 0xA1);	/* mask all of 8259A-2 */
-
-	/*
-	 * outb_p - this has to work on a wide range of PC hardware.
-	 */
-	outb_p(0x11, 0x20);	/* ICW1: select 8259A-1 init */
-	outb_p(IRQ0_VECTOR, 0x21);	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 */
-	outb_p(0x04, 0x21);	/* 8259A-1 (the master) has a slave on IR2 */
-	if (auto_eoi)
-		outb_p(0x03, 0x21);	/* master does Auto EOI */
-	else
-		outb_p(0x01, 0x21);	/* master expects normal EOI */
-
-	outb_p(0x11, 0xA0);	/* ICW1: select 8259A-2 init */
-	outb_p(IRQ8_VECTOR, 0xA1);	/* ICW2: 8259A-2 IR0-7 mapped to 0x38-0x3f */
-	outb_p(0x02, 0xA1);	/* 8259A-2 is a slave on master's IR2 */
-	outb_p(0x01, 0xA1);	/* (slave's support for AEOI in flat mode
-				    is to be investigated) */
-
-	if (auto_eoi)
-		/*
-		 * in AEOI mode we just have to mask the interrupt
-		 * when acking.
-		 */
-		i8259A_chip.mask_ack = disable_8259A_irq;
-	else
-		i8259A_chip.mask_ack = mask_and_ack_8259A;
-
-	udelay(100);		/* wait for 8259A to initialize */
-
-	outb(cached_21, 0x21);	/* restore master IRQ mask */
-	outb(cached_A1, 0xA1);	/* restore slave IRQ mask */
-
-	spin_unlock_irqrestore(&i8259A_lock, flags);
-}
-
 static char irq_trigger[2];
 /**
  * ELCR registers (0x4d0, 0x4d1) control edge/level of IRQ
@@ -364,8 +316,8 @@ static int i8259A_shutdown(struct sys_device *dev)
 	 * the kernel initialization code can get it
 	 * out of.
 	 */
-	outb(0xff, 0x21);	/* mask all of 8259A-1 */
-	outb(0xff, 0xA1);	/* mask all of 8259A-1 */
+	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
+	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-1 */
 	return 0;
 }
 
@@ -391,6 +343,53 @@ static int __init i8259A_init_sysfs(void)
 
 device_initcall(i8259A_init_sysfs);
 
+void init_8259A(int auto_eoi)
+{
+	unsigned long flags;
+
+	i8259A_auto_eoi = auto_eoi;
+
+	spin_lock_irqsave(&i8259A_lock, flags);
+
+	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
+	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
+
+	/*
+	 * outb_p - this has to work on a wide range of PC hardware.
+	 */
+	outb_p(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
+	outb_p(IRQ0_VECTOR, PIC_MASTER_IMR);	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 */
+	outb_p(0x04, PIC_MASTER_IMR);	/* 8259A-1 (the master) has a slave on IR2 */
+	if (auto_eoi)	/* master does Auto EOI */
+		outb_p(MASTER_ICW4_DEFAULT | PIC_ICW4_AEOI, PIC_MASTER_IMR);
+	else		/* master expects normal EOI */
+		outb_p(MASTER_ICW4_DEFAULT, PIC_MASTER_IMR);
+
+	outb_p(0x11, PIC_SLAVE_CMD);	/* ICW1: select 8259A-2 init */
+	outb_p(IRQ8_VECTOR, PIC_SLAVE_IMR);	/* ICW2: 8259A-2 IR0-7 mapped to 0x38-0x3f */
+	outb_p(PIC_CASCADE_IR, PIC_SLAVE_IMR);	/* 8259A-2 is a slave on master's IR2 */
+	outb_p(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR); /* (slave's support for AEOI in flat mode is to be investigated) */
+
+	if (auto_eoi)
+		/*
+		 * In AEOI mode we just have to mask the interrupt
+		 * when acking.
+		 */
+		i8259A_chip.mask_ack = disable_8259A_irq;
+	else
+		i8259A_chip.mask_ack = mask_and_ack_8259A;
+
+	udelay(100);		/* wait for 8259A to initialize */
+
+	outb(cached_master_mask, PIC_MASTER_IMR); /* restore master IRQ mask */
+	outb(cached_slave_mask, PIC_SLAVE_IMR);	  /* restore slave IRQ mask */
+
+	spin_unlock_irqrestore(&i8259A_lock, flags);
+}
+
+
+
+
 /*
  * IRQ2 is cascade interrupt to second interrupt controller
  */
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index f35c6eb..0eebc93 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -48,8 +48,6 @@
 #include <mach_apic.h>
 #include <mach_apicdef.h>
 
-#include "io_ports.h"
-
 int (*ioapic_renumber_irq)(int ioapic, int irq);
 atomic_t irq_mis_count;
 
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 8a322c9..8234eca 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -64,8 +64,6 @@
 
 #include <asm/arch_hooks.h>
 
-#include "io_ports.h"
-
 #include <asm/i8259.h>
 
 #include "do_timer.h"
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index b1b5ab0..57f9ef5 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -35,7 +35,6 @@
 #include <asm/i8253.h>
 
 #include <irq_vectors.h>
-#include "io_ports.h"
 
 #define VMI_ONESHOT  (VMI_ALARM_IS_ONESHOT  | VMI_CYCLES_REAL | vmi_get_alarm_wiring())
 #define VMI_PERIODIC (VMI_ALARM_IS_PERIODIC | VMI_CYCLES_REAL | vmi_get_alarm_wiring())
diff --git a/include/asm-x86/i8259.h b/include/asm-x86/i8259.h
index 29d8f9a..44a8476 100644
--- a/include/asm-x86/i8259.h
+++ b/include/asm-x86/i8259.h
@@ -1,6 +1,21 @@
 #ifndef __ASM_I8259_H__
 #define __ASM_I8259_H__
 
+/* i8259A PIC registers */
+#define PIC_MASTER_CMD          0x20
+#define PIC_MASTER_IMR          0x21
+#define PIC_MASTER_ISR          PIC_MASTER_CMD
+#define PIC_MASTER_POLL         PIC_MASTER_ISR
+#define PIC_MASTER_OCW3         PIC_MASTER_ISR
+#define PIC_SLAVE_CMD           0xa0
+#define PIC_SLAVE_IMR           0xa1
+
+/* i8259A PIC related value */
+#define PIC_CASCADE_IR          2
+#define MASTER_ICW4_DEFAULT     0x01
+#define SLAVE_ICW4_DEFAULT      0x01
+#define PIC_ICW4_AEOI           2
+
 extern unsigned int cached_irq_mask;
 
 #define __byte(x,y) 		(((unsigned char *) &(y))[x])
diff --git a/include/asm-x86/mach-default/io_ports.h b/include/asm-x86/mach-default/io_ports.h
deleted file mode 100644
index 48540ba..0000000
--- a/include/asm-x86/mach-default/io_ports.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- *  arch/i386/mach-generic/io_ports.h
- *
- *  Machine specific IO port address definition for generic.
- *  Written by Osamu Tomita <tomita@cinet.co.jp>
- */
-#ifndef _MACH_IO_PORTS_H
-#define _MACH_IO_PORTS_H
-
-/* i8259A PIC registers */
-#define PIC_MASTER_CMD		0x20
-#define PIC_MASTER_IMR		0x21
-#define PIC_MASTER_ISR		PIC_MASTER_CMD
-#define PIC_MASTER_POLL		PIC_MASTER_ISR
-#define PIC_MASTER_OCW3		PIC_MASTER_ISR
-#define PIC_SLAVE_CMD		0xa0
-#define PIC_SLAVE_IMR		0xa1
-
-/* i8259A PIC related value */
-#define PIC_CASCADE_IR		2
-#define MASTER_ICW4_DEFAULT	0x01
-#define SLAVE_ICW4_DEFAULT	0x01
-#define PIC_ICW4_AEOI		2
-
-#endif /* !_MACH_IO_PORTS_H */
-- 
1.5.2.5

