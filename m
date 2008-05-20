Return-Path: <linux-kernel-owner+w=401wt.eu-S933371AbYETPPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371AbYETPPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932318AbYETPOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:14:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36618 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596AbYETPOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:14:48 -0400
Date: Tue, 20 May 2008 17:15:45 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Unify common parts of i8259.c
Message-ID: <20080520151528.GA1596@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge common parts of i8259_{32,64} into i8259.c.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 4544eda7dd9bc73061bc308130ed03e8b81f4f61
tree 6a4adc5a6661136352f6ff362d9574142ab0c246
parent 3576982b19d0fbd81f8d31d0475bf7b374010cb5
author Pavel <pavel@amd.ucw.cz> Tue, 20 May 2008 17:14:29 +0200
committer Pavel <pavel@amd.ucw.cz> Tue, 20 May 2008 17:14:29 +0200

 arch/x86/kernel/Makefile    |    2 
 arch/x86/kernel/i8259.c     |  323 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/i8259_32.c  |  297 ----------------------------------------
 arch/x86/kernel/i8259_64.c  |  312 ------------------------------------------
 include/asm-x86/hw_irq_32.h |   20 +++
 include/asm-x86/i8259.h     |    2 
 6 files changed, 347 insertions(+), 609 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 5e618c3..f71a76e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -18,7 +18,7 @@ CFLAGS_tsc_64.o		:= $(nostackp)
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
 obj-y			+= traps_$(BITS).o irq_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o
-obj-y			+= setup_$(BITS).o i8259_$(BITS).o setup.o
+obj-y			+= setup_$(BITS).o i8259.o i8259_$(BITS).o setup.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o setup64.o
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
new file mode 100644
index 0000000..8103646
--- /dev/null
+++ b/arch/x86/kernel/i8259.c
@@ -0,0 +1,323 @@
+#include <linux/errno.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/ioport.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/random.h>
+#include <linux/init.h>
+#include <linux/kernel_stat.h>
+#include <linux/sysdev.h>
+#include <linux/bitops.h>
+
+#include <asm/atomic.h>
+#include <asm/system.h>
+#include <asm/io.h>
+#include <asm/timer.h>
+#include <asm/pgtable.h>
+#include <asm/delay.h>
+#include <asm/desc.h>
+#include <asm/apic.h>
+#include <asm/arch_hooks.h>
+#include <asm/i8259.h>
+
+/*
+ * This is the 'legacy' 8259A Programmable Interrupt Controller,
+ * present in the majority of PC/AT boxes.
+ * plus some generic x86 specific things if generic specifics makes
+ * any sense at all.
+ * this file should become arch/i386/kernel/irq.c when the old irq.c
+ * moves to arch independent land
+ */
+
+static int i8259A_auto_eoi;
+DEFINE_SPINLOCK(i8259A_lock);
+static void mask_and_ack_8259A(unsigned int);
+
+struct irq_chip i8259A_chip = {
+	.name		= "XT-PIC",
+	.mask		= disable_8259A_irq,
+	.disable	= disable_8259A_irq,
+	.unmask		= enable_8259A_irq,
+	.mask_ack	= mask_and_ack_8259A,
+};
+
+/*
+ * 8259A PIC functions to handle ISA devices:
+ */
+
+/*
+ * This contains the irq mask for both 8259A irq controllers,
+ */
+unsigned int cached_irq_mask = 0xffff;
+
+/*
+ * Not all IRQs can be routed through the IO-APIC, eg. on certain (older)
+ * boards the timer interrupt is not really connected to any IO-APIC pin,
+ * it's fed to the master 8259A's IR0 line only.
+ *
+ * Any '1' bit in this mask means the IRQ is routed through the IO-APIC.
+ * this 'mixed mode' IRQ handling costs nothing because it's only used
+ * at IRQ setup time.
+ */
+unsigned long io_apic_irqs;
+
+void disable_8259A_irq(unsigned int irq)
+{
+	unsigned int mask = 1 << irq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&i8259A_lock, flags);
+	cached_irq_mask |= mask;
+	if (irq & 8)
+		outb(cached_slave_mask, PIC_SLAVE_IMR);
+	else
+		outb(cached_master_mask, PIC_MASTER_IMR);
+	spin_unlock_irqrestore(&i8259A_lock, flags);
+}
+
+void enable_8259A_irq(unsigned int irq)
+{
+	unsigned int mask = ~(1 << irq);
+	unsigned long flags;
+
+	spin_lock_irqsave(&i8259A_lock, flags);
+	cached_irq_mask &= mask;
+	if (irq & 8)
+		outb(cached_slave_mask, PIC_SLAVE_IMR);
+	else
+		outb(cached_master_mask, PIC_MASTER_IMR);
+	spin_unlock_irqrestore(&i8259A_lock, flags);
+}
+
+int i8259A_irq_pending(unsigned int irq)
+{
+	unsigned int mask = 1<<irq;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&i8259A_lock, flags);
+	if (irq < 8)
+		ret = inb(PIC_MASTER_CMD) & mask;
+	else
+		ret = inb(PIC_SLAVE_CMD) & (mask >> 8);
+	spin_unlock_irqrestore(&i8259A_lock, flags);
+
+	return ret;
+}
+
+void make_8259A_irq(unsigned int irq)
+{
+	disable_irq_nosync(irq);
+	io_apic_irqs &= ~(1<<irq);
+	set_irq_chip_and_handler_name(irq, &i8259A_chip, handle_level_irq,
+				      "XT");
+	enable_irq(irq);
+}
+
+/*
+ * This function assumes to be called rarely. Switching between
+ * 8259A registers is slow.
+ * This has to be protected by the irq controller spinlock
+ * before being called.
+ */
+static inline int i8259A_irq_real(unsigned int irq)
+{
+	int value;
+	int irqmask = 1<<irq;
+
+	if (irq < 8) {
+		outb(0x0B,PIC_MASTER_CMD);	/* ISR register */
+		value = inb(PIC_MASTER_CMD) & irqmask;
+		outb(0x0A,PIC_MASTER_CMD);	/* back to the IRR register */
+		return value;
+	}
+	outb(0x0B,PIC_SLAVE_CMD);	/* ISR register */
+	value = inb(PIC_SLAVE_CMD) & (irqmask >> 8);
+	outb(0x0A,PIC_SLAVE_CMD);	/* back to the IRR register */
+	return value;
+}
+
+/*
+ * Careful! The 8259A is a fragile beast, it pretty
+ * much _has_ to be done exactly like this (mask it
+ * first, _then_ send the EOI, and the order of EOI
+ * to the two 8259s is important!
+ */
+static void mask_and_ack_8259A(unsigned int irq)
+{
+	unsigned int irqmask = 1 << irq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&i8259A_lock, flags);
+	/*
+	 * Lightweight spurious IRQ detection. We do not want
+	 * to overdo spurious IRQ handling - it's usually a sign
+	 * of hardware problems, so we only do the checks we can
+	 * do without slowing down good hardware unnecessarily.
+	 *
+	 * Note that IRQ7 and IRQ15 (the two spurious IRQs
+	 * usually resulting from the 8259A-1|2 PICs) occur
+	 * even if the IRQ is masked in the 8259A. Thus we
+	 * can check spurious 8259A IRQs without doing the
+	 * quite slow i8259A_irq_real() call for every IRQ.
+	 * This does not cover 100% of spurious interrupts,
+	 * but should be enough to warn the user that there
+	 * is something bad going on ...
+	 */
+	if (cached_irq_mask & irqmask)
+		goto spurious_8259A_irq;
+	cached_irq_mask |= irqmask;
+
+handle_real_irq:
+	if (irq & 8) {
+		inb(PIC_SLAVE_IMR);	/* DUMMY - (do we need this?) */
+		outb(cached_slave_mask, PIC_SLAVE_IMR);
+		outb(0x60+(irq&7),PIC_SLAVE_CMD);/* 'Specific EOI' to slave */
+		outb(0x60+PIC_CASCADE_IR,PIC_MASTER_CMD); /* 'Specific EOI' to master-IRQ2 */
+	} else {
+		inb(PIC_MASTER_IMR);	/* DUMMY - (do we need this?) */
+		outb(cached_master_mask, PIC_MASTER_IMR);
+		outb(0x60+irq,PIC_MASTER_CMD);	/* 'Specific EOI to master */
+	}
+	spin_unlock_irqrestore(&i8259A_lock, flags);
+	return;
+
+spurious_8259A_irq:
+	/*
+	 * this is the slow path - should happen rarely.
+	 */
+	if (i8259A_irq_real(irq))
+		/*
+		 * oops, the IRQ _is_ in service according to the
+		 * 8259A - not spurious, go handle it.
+		 */
+		goto handle_real_irq;
+
+	{
+		static int spurious_irq_mask;
+		/*
+		 * At this point we can be sure the IRQ is spurious,
+		 * lets ACK and report it. [once per IRQ]
+		 */
+		if (!(spurious_irq_mask & irqmask)) {
+			printk(KERN_DEBUG "spurious 8259A interrupt: IRQ%d.\n", irq);
+			spurious_irq_mask |= irqmask;
+		}
+		atomic_inc(&irq_err_count);
+		/*
+		 * Theoretically we do not have to handle this IRQ,
+		 * but in Linux this does not cause problems and is
+		 * simpler for us.
+		 */
+		goto handle_real_irq;
+	}
+}
+
+static char irq_trigger[2];
+/**
+ * ELCR registers (0x4d0, 0x4d1) control edge/level of IRQ
+ */
+static void restore_ELCR(char *trigger)
+{
+	outb(trigger[0], 0x4d0);
+	outb(trigger[1], 0x4d1);
+}
+
+static void save_ELCR(char *trigger)
+{
+	/* IRQ 0,1,2,8,13 are marked as reserved */
+	trigger[0] = inb(0x4d0) & 0xF8;
+	trigger[1] = inb(0x4d1) & 0xDE;
+}
+
+static int i8259A_resume(struct sys_device *dev)
+{
+	init_8259A(i8259A_auto_eoi);
+	restore_ELCR(irq_trigger);
+	return 0;
+}
+
+static int i8259A_suspend(struct sys_device *dev, pm_message_t state)
+{
+	save_ELCR(irq_trigger);
+	return 0;
+}
+
+static int i8259A_shutdown(struct sys_device *dev)
+{
+	/* Put the i8259A into a quiescent state that
+	 * the kernel initialization code can get it
+	 * out of.
+	 */
+	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
+	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-1 */
+	return 0;
+}
+
+static struct sysdev_class i8259_sysdev_class = {
+	.name = "i8259",
+	.suspend = i8259A_suspend,
+	.resume = i8259A_resume,
+	.shutdown = i8259A_shutdown,
+};
+
+static struct sys_device device_i8259A = {
+	.id	= 0,
+	.cls	= &i8259_sysdev_class,
+};
+
+static int __init i8259A_init_sysfs(void)
+{
+	int error = sysdev_class_register(&i8259_sysdev_class);
+	if (!error)
+		error = sysdev_register(&device_i8259A);
+	return error;
+}
+
+device_initcall(i8259A_init_sysfs);
+
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
+	 * outb_pic - this has to work on a wide range of PC hardware.
+	 */
+	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
+	/* ICW2: 8259A-1 IR0-7 mapped to 0x20-0x27 or 32-bit and 0x30-0x37 on 64-bit */
+	outb_pic(IRQ0_VECTOR, PIC_MASTER_IMR);
+	outb_pic(1U << PIC_CASCADE_IR, PIC_MASTER_IMR);	/* 8259A-1 (the master) has a slave on IR2 */
+	if (auto_eoi)	/* master does Auto EOI */
+		outb_pic(MASTER_ICW4_DEFAULT | PIC_ICW4_AEOI, PIC_MASTER_IMR);
+	else		/* master expects normal EOI */
+		outb_pic(MASTER_ICW4_DEFAULT, PIC_MASTER_IMR);
+
+	outb_pic(0x11, PIC_SLAVE_CMD);	/* ICW1: select 8259A-2 init */
+	/* ICW2: 8259A-2 IR0-7 mapped to 0x28-0x2f / 0x38-0x3f */
+	outb_pic(IRQ8_VECTOR, PIC_SLAVE_IMR);
+	outb_pic(PIC_CASCADE_IR, PIC_SLAVE_IMR);	/* 8259A-2 is a slave on master's IR2 */
+	outb_pic(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR); /* (slave's support for AEOI in flat mode is to be investigated) */
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
diff --git a/arch/x86/kernel/i8259_32.c b/arch/x86/kernel/i8259_32.c
index fe63196..8cdd9c3 100644
--- a/arch/x86/kernel/i8259_32.c
+++ b/arch/x86/kernel/i8259_32.c
@@ -21,302 +21,6 @@ #include <asm/apic.h>
 #include <asm/arch_hooks.h>
 #include <asm/i8259.h>
 
-/*
- * This is the 'legacy' 8259A Programmable Interrupt Controller,
- * present in the majority of PC/AT boxes.
- * plus some generic x86 specific things if generic specifics makes
- * any sense at all.
- */
-
-static int i8259A_auto_eoi;
-DEFINE_SPINLOCK(i8259A_lock);
-static void mask_and_ack_8259A(unsigned int);
-
-static struct irq_chip i8259A_chip = {
-	.name		= "XT-PIC",
-	.mask		= disable_8259A_irq,
-	.disable	= disable_8259A_irq,
-	.unmask		= enable_8259A_irq,
-	.mask_ack	= mask_and_ack_8259A,
-};
-
-/*
- * 8259A PIC functions to handle ISA devices:
- */
-
-/*
- * This contains the irq mask for both 8259A irq controllers,
- */
-unsigned int cached_irq_mask = 0xffff;
-
-/*
- * Not all IRQs can be routed through the IO-APIC, eg. on certain (older)
- * boards the timer interrupt is not really connected to any IO-APIC pin,
- * it's fed to the master 8259A's IR0 line only.
- *
- * Any '1' bit in this mask means the IRQ is routed through the IO-APIC.
- * this 'mixed mode' IRQ handling costs nothing because it's only used
- * at IRQ setup time.
- */
-unsigned long io_apic_irqs;
-
-void disable_8259A_irq(unsigned int irq)
-{
-	unsigned int mask = 1 << irq;
-	unsigned long flags;
-
-	spin_lock_irqsave(&i8259A_lock, flags);
-	cached_irq_mask |= mask;
-	if (irq & 8)
-		outb(cached_slave_mask, PIC_SLAVE_IMR);
-	else
-		outb(cached_master_mask, PIC_MASTER_IMR);
-	spin_unlock_irqrestore(&i8259A_lock, flags);
-}
-
-void enable_8259A_irq(unsigned int irq)
-{
-	unsigned int mask = ~(1 << irq);
-	unsigned long flags;
-
-	spin_lock_irqsave(&i8259A_lock, flags);
-	cached_irq_mask &= mask;
-	if (irq & 8)
-		outb(cached_slave_mask, PIC_SLAVE_IMR);
-	else
-		outb(cached_master_mask, PIC_MASTER_IMR);
-	spin_unlock_irqrestore(&i8259A_lock, flags);
-}
-
-int i8259A_irq_pending(unsigned int irq)
-{
-	unsigned int mask = 1<<irq;
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&i8259A_lock, flags);
-	if (irq < 8)
-		ret = inb(PIC_MASTER_CMD) & mask;
-	else
-		ret = inb(PIC_SLAVE_CMD) & (mask >> 8);
-	spin_unlock_irqrestore(&i8259A_lock, flags);
-
-	return ret;
-}
-
-void make_8259A_irq(unsigned int irq)
-{
-	disable_irq_nosync(irq);
-	io_apic_irqs &= ~(1<<irq);
-	set_irq_chip_and_handler_name(irq, &i8259A_chip, handle_level_irq,
-				      "XT");
-	enable_irq(irq);
-}
-
-/*
- * This function assumes to be called rarely. Switching between
- * 8259A registers is slow.
- * This has to be protected by the irq controller spinlock
- * before being called.
- */
-static inline int i8259A_irq_real(unsigned int irq)
-{
-	int value;
-	int irqmask = 1<<irq;
-
-	if (irq < 8) {
-		outb(0x0B,PIC_MASTER_CMD);	/* ISR register */
-		value = inb(PIC_MASTER_CMD) & irqmask;
-		outb(0x0A,PIC_MASTER_CMD);	/* back to the IRR register */
-		return value;
-	}
-	outb(0x0B,PIC_SLAVE_CMD);	/* ISR register */
-	value = inb(PIC_SLAVE_CMD) & (irqmask >> 8);
-	outb(0x0A,PIC_SLAVE_CMD);	/* back to the IRR register */
-	return value;
-}
-
-/*
- * Careful! The 8259A is a fragile beast, it pretty
- * much _has_ to be done exactly like this (mask it
- * first, _then_ send the EOI, and the order of EOI
- * to the two 8259s is important!
- */
-static void mask_and_ack_8259A(unsigned int irq)
-{
-	unsigned int irqmask = 1 << irq;
-	unsigned long flags;
-
-	spin_lock_irqsave(&i8259A_lock, flags);
-	/*
-	 * Lightweight spurious IRQ detection. We do not want
-	 * to overdo spurious IRQ handling - it's usually a sign
-	 * of hardware problems, so we only do the checks we can
-	 * do without slowing down good hardware unnecessarily.
-	 *
-	 * Note that IRQ7 and IRQ15 (the two spurious IRQs
-	 * usually resulting from the 8259A-1|2 PICs) occur
-	 * even if the IRQ is masked in the 8259A. Thus we
-	 * can check spurious 8259A IRQs without doing the
-	 * quite slow i8259A_irq_real() call for every IRQ.
-	 * This does not cover 100% of spurious interrupts,
-	 * but should be enough to warn the user that there
-	 * is something bad going on ...
-	 */
-	if (cached_irq_mask & irqmask)
-		goto spurious_8259A_irq;
-	cached_irq_mask |= irqmask;
-
-handle_real_irq:
-	if (irq & 8) {
-		inb(PIC_SLAVE_IMR);	/* DUMMY - (do we need this?) */
-		outb(cached_slave_mask, PIC_SLAVE_IMR);
-		outb(0x60+(irq&7),PIC_SLAVE_CMD);/* 'Specific EOI' to slave */
-		outb(0x60+PIC_CASCADE_IR,PIC_MASTER_CMD); /* 'Specific EOI' to master-IRQ2 */
-	} else {
-		inb(PIC_MASTER_IMR);	/* DUMMY - (do we need this?) */
-		outb(cached_master_mask, PIC_MASTER_IMR);
-		outb(0x60+irq,PIC_MASTER_CMD);	/* 'Specific EOI to master */
-	}
-	spin_unlock_irqrestore(&i8259A_lock, flags);
-	return;
-
-spurious_8259A_irq:
-	/*
-	 * this is the slow path - should happen rarely.
-	 */
-	if (i8259A_irq_real(irq))
-		/*
-		 * oops, the IRQ _is_ in service according to the
-		 * 8259A - not spurious, go handle it.
-		 */
-		goto handle_real_irq;
-
-	{
-		static int spurious_irq_mask;
-		/*
-		 * At this point we can be sure the IRQ is spurious,
-		 * lets ACK and report it. [once per IRQ]
-		 */
-		if (!(spurious_irq_mask & irqmask)) {
-			printk(KERN_DEBUG "spurious 8259A interrupt: IRQ%d.\n", irq);
-			spurious_irq_mask |= irqmask;
-		}
-		atomic_inc(&irq_err_count);
-		/*
-		 * Theoretically we do not have to handle this IRQ,
-		 * but in Linux this does not cause problems and is
-		 * simpler for us.
-		 */
-		goto handle_real_irq;
-	}
-}
-
-static char irq_trigger[2];
-/**
- * ELCR registers (0x4d0, 0x4d1) control edge/level of IRQ
- */
-static void restore_ELCR(char *trigger)
-{
-	outb(trigger[0], 0x4d0);
-	outb(trigger[1], 0x4d1);
-}
-
-static void save_ELCR(char *trigger)
-{
-	/* IRQ 0,1,2,8,13 are marked as reserved */
-	trigger[0] = inb(0x4d0) & 0xF8;
-	trigger[1] = inb(0x4d1) & 0xDE;
-}
-
-static int i8259A_resume(struct sys_device *dev)
-{
-	init_8259A(i8259A_auto_eoi);
-	restore_ELCR(irq_trigger);
-	return 0;
-}
-
-static int i8259A_suspend(struct sys_device *dev, pm_message_t state)
-{
-	save_ELCR(irq_trigger);
-	return 0;
-}
-
-static int i8259A_shutdown(struct sys_device *dev)
-{
-	/* Put the i8259A into a quiescent state that
-	 * the kernel initialization code can get it
-	 * out of.
-	 */
-	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
-	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-1 */
-	return 0;
-}
-
-static struct sysdev_class i8259_sysdev_class = {
-	.name = "i8259",
-	.suspend = i8259A_suspend,
-	.resume = i8259A_resume,
-	.shutdown = i8259A_shutdown,
-};
-
-static struct sys_device device_i8259A = {
-	.id	= 0,
-	.cls	= &i8259_sysdev_class,
-};
-
-static int __init i8259A_init_sysfs(void)
-{
-	int error = sysdev_class_register(&i8259_sysdev_class);
-	if (!error)
-		error = sysdev_register(&device_i8259A);
-	return error;
-}
-
-device_initcall(i8259A_init_sysfs);
-
-void init_8259A(int auto_eoi)
-{
-	unsigned long flags;
-
-	i8259A_auto_eoi = auto_eoi;
-
-	spin_lock_irqsave(&i8259A_lock, flags);
-
-	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
-	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
-
-	/*
-	 * outb_pic - this has to work on a wide range of PC hardware.
-	 */
-	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
-	outb_pic(0x20 + 0, PIC_MASTER_IMR);	/* ICW2: 8259A-1 IR0-7 mapped to 0x20-0x27 */
-	outb_pic(1U << PIC_CASCADE_IR, PIC_MASTER_IMR);	/* 8259A-1 (the master) has a slave on IR2 */
-	if (auto_eoi)	/* master does Auto EOI */
-		outb_pic(MASTER_ICW4_DEFAULT | PIC_ICW4_AEOI, PIC_MASTER_IMR);
-	else		/* master expects normal EOI */
-		outb_pic(MASTER_ICW4_DEFAULT, PIC_MASTER_IMR);
-
-	outb_pic(0x11, PIC_SLAVE_CMD);	/* ICW1: select 8259A-2 init */
-	outb_pic(0x20 + 8, PIC_SLAVE_IMR);	/* ICW2: 8259A-2 IR0-7 mapped to 0x28-0x2f */
-	outb_pic(PIC_CASCADE_IR, PIC_SLAVE_IMR);	/* 8259A-2 is a slave on master's IR2 */
-	outb_pic(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR); /* (slave's support for AEOI in flat mode is to be investigated) */
-	if (auto_eoi)
-		/*
-		 * In AEOI mode we just have to mask the interrupt
-		 * when acking.
-		 */
-		i8259A_chip.mask_ack = disable_8259A_irq;
-	else
-		i8259A_chip.mask_ack = mask_and_ack_8259A;
-
-	udelay(100);		/* wait for 8259A to initialize */
-
-	outb(cached_master_mask, PIC_MASTER_IMR); /* restore master IRQ mask */
-	outb(cached_slave_mask, PIC_SLAVE_IMR);	  /* restore slave IRQ mask */
-
-	spin_unlock_irqrestore(&i8259A_lock, flags);
-}
 
 /*
  * Note that on a 486, we don't want to do a SIGFPE on an irq13
@@ -351,6 +55,7 @@ static struct irqaction fpu_irq = {
 	.name = "fpu",
 };
 
+
 void __init init_ISA_irqs (void)
 {
 	int i;
diff --git a/arch/x86/kernel/i8259_64.c b/arch/x86/kernel/i8259_64.c
index fa57a15..8bb24b9 100644
--- a/arch/x86/kernel/i8259_64.c
+++ b/arch/x86/kernel/i8259_64.c
@@ -88,318 +88,6 @@ #undef IRQ
 #undef IRQLIST_16
 
 /*
- * This is the 'legacy' 8259A Programmable Interrupt Controller,
- * present in the majority of PC/AT boxes.
- * plus some generic x86 specific things if generic specifics makes
- * any sense at all.
- * this file should become arch/i386/kernel/irq.c when the old irq.c
- * moves to arch independent land
- */
-
-static int i8259A_auto_eoi;
-DEFINE_SPINLOCK(i8259A_lock);
-static void mask_and_ack_8259A(unsigned int);
-
-static struct irq_chip i8259A_chip = {
-	.name		= "XT-PIC",
-	.mask		= disable_8259A_irq,
-	.disable	= disable_8259A_irq,
-	.unmask		= enable_8259A_irq,
-	.mask_ack	= mask_and_ack_8259A,
-};
-
-/*
- * 8259A PIC functions to handle ISA devices:
- */
-
-/*
- * This contains the irq mask for both 8259A irq controllers,
- */
-unsigned int cached_irq_mask = 0xffff;
-
-/*
- * Not all IRQs can be routed through the IO-APIC, eg. on certain (older)
- * boards the timer interrupt is not really connected to any IO-APIC pin,
- * it's fed to the master 8259A's IR0 line only.
- *
- * Any '1' bit in this mask means the IRQ is routed through the IO-APIC.
- * this 'mixed mode' IRQ handling costs nothing because it's only used
- * at IRQ setup time.
- */
-unsigned long io_apic_irqs;
-
-void disable_8259A_irq(unsigned int irq)
-{
-	unsigned int mask = 1 << irq;
-	unsigned long flags;
-
-	spin_lock_irqsave(&i8259A_lock, flags);
-	cached_irq_mask |= mask;
-	if (irq & 8)
-		outb(cached_slave_mask, PIC_SLAVE_IMR);
-	else
-		outb(cached_master_mask, PIC_MASTER_IMR);
-	spin_unlock_irqrestore(&i8259A_lock, flags);
-}
-
-void enable_8259A_irq(unsigned int irq)
-{
-	unsigned int mask = ~(1 << irq);
-	unsigned long flags;
-
-	spin_lock_irqsave(&i8259A_lock, flags);
-	cached_irq_mask &= mask;
-	if (irq & 8)
-		outb(cached_slave_mask, PIC_SLAVE_IMR);
-	else
-		outb(cached_master_mask, PIC_MASTER_IMR);
-	spin_unlock_irqrestore(&i8259A_lock, flags);
-}
-
-int i8259A_irq_pending(unsigned int irq)
-{
-	unsigned int mask = 1<<irq;
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&i8259A_lock, flags);
-	if (irq < 8)
-		ret = inb(PIC_MASTER_CMD) & mask;
-	else
-		ret = inb(PIC_SLAVE_CMD) & (mask >> 8);
-	spin_unlock_irqrestore(&i8259A_lock, flags);
-
-	return ret;
-}
-
-void make_8259A_irq(unsigned int irq)
-{
-	disable_irq_nosync(irq);
-	io_apic_irqs &= ~(1<<irq);
-	set_irq_chip_and_handler_name(irq, &i8259A_chip, handle_level_irq,
-				      "XT");
-	enable_irq(irq);
-}
-
-/*
- * This function assumes to be called rarely. Switching between
- * 8259A registers is slow.
- * This has to be protected by the irq controller spinlock
- * before being called.
- */
-static inline int i8259A_irq_real(unsigned int irq)
-{
-	int value;
-	int irqmask = 1<<irq;
-
-	if (irq < 8) {
-		outb(0x0B,PIC_MASTER_CMD);	/* ISR register */
-		value = inb(PIC_MASTER_CMD) & irqmask;
-		outb(0x0A,PIC_MASTER_CMD);	/* back to the IRR register */
-		return value;
-	}
-	outb(0x0B,PIC_SLAVE_CMD);	/* ISR register */
-	value = inb(PIC_SLAVE_CMD) & (irqmask >> 8);
-	outb(0x0A,PIC_SLAVE_CMD);	/* back to the IRR register */
-	return value;
-}
-
-/*
- * Careful! The 8259A is a fragile beast, it pretty
- * much _has_ to be done exactly like this (mask it
- * first, _then_ send the EOI, and the order of EOI
- * to the two 8259s is important!
- */
-static void mask_and_ack_8259A(unsigned int irq)
-{
-	unsigned int irqmask = 1 << irq;
-	unsigned long flags;
-
-	spin_lock_irqsave(&i8259A_lock, flags);
-	/*
-	 * Lightweight spurious IRQ detection. We do not want
-	 * to overdo spurious IRQ handling - it's usually a sign
-	 * of hardware problems, so we only do the checks we can
-	 * do without slowing down good hardware unnecessarily.
-	 *
-	 * Note that IRQ7 and IRQ15 (the two spurious IRQs
-	 * usually resulting from the 8259A-1|2 PICs) occur
-	 * even if the IRQ is masked in the 8259A. Thus we
-	 * can check spurious 8259A IRQs without doing the
-	 * quite slow i8259A_irq_real() call for every IRQ.
-	 * This does not cover 100% of spurious interrupts,
-	 * but should be enough to warn the user that there
-	 * is something bad going on ...
-	 */
-	if (cached_irq_mask & irqmask)
-		goto spurious_8259A_irq;
-	cached_irq_mask |= irqmask;
-
-handle_real_irq:
-	if (irq & 8) {
-		inb(PIC_SLAVE_IMR);	/* DUMMY - (do we need this?) */
-		outb(cached_slave_mask, PIC_SLAVE_IMR);
-		/* 'Specific EOI' to slave */
-		outb(0x60+(irq&7),PIC_SLAVE_CMD);
-		 /* 'Specific EOI' to master-IRQ2 */
-		outb(0x60+PIC_CASCADE_IR,PIC_MASTER_CMD);
-	} else {
-		inb(PIC_MASTER_IMR);	/* DUMMY - (do we need this?) */
-		outb(cached_master_mask, PIC_MASTER_IMR);
-		/* 'Specific EOI' to master */
-		outb(0x60+irq,PIC_MASTER_CMD);
-	}
-	spin_unlock_irqrestore(&i8259A_lock, flags);
-	return;
-
-spurious_8259A_irq:
-	/*
-	 * this is the slow path - should happen rarely.
-	 */
-	if (i8259A_irq_real(irq))
-		/*
-		 * oops, the IRQ _is_ in service according to the
-		 * 8259A - not spurious, go handle it.
-		 */
-		goto handle_real_irq;
-
-	{
-		static int spurious_irq_mask;
-		/*
-		 * At this point we can be sure the IRQ is spurious,
-		 * lets ACK and report it. [once per IRQ]
-		 */
-		if (!(spurious_irq_mask & irqmask)) {
-			printk(KERN_DEBUG
-			       "spurious 8259A interrupt: IRQ%d.\n", irq);
-			spurious_irq_mask |= irqmask;
-		}
-		atomic_inc(&irq_err_count);
-		/*
-		 * Theoretically we do not have to handle this IRQ,
-		 * but in Linux this does not cause problems and is
-		 * simpler for us.
-		 */
-		goto handle_real_irq;
-	}
-}
-
-static char irq_trigger[2];
-/**
- * ELCR registers (0x4d0, 0x4d1) control edge/level of IRQ
- */
-static void restore_ELCR(char *trigger)
-{
-	outb(trigger[0], 0x4d0);
-	outb(trigger[1], 0x4d1);
-}
-
-static void save_ELCR(char *trigger)
-{
-	/* IRQ 0,1,2,8,13 are marked as reserved */
-	trigger[0] = inb(0x4d0) & 0xF8;
-	trigger[1] = inb(0x4d1) & 0xDE;
-}
-
-static int i8259A_resume(struct sys_device *dev)
-{
-	init_8259A(i8259A_auto_eoi);
-	restore_ELCR(irq_trigger);
-	return 0;
-}
-
-static int i8259A_suspend(struct sys_device *dev, pm_message_t state)
-{
-	save_ELCR(irq_trigger);
-	return 0;
-}
-
-static int i8259A_shutdown(struct sys_device *dev)
-{
-	/* Put the i8259A into a quiescent state that
-	 * the kernel initialization code can get it
-	 * out of.
-	 */
-	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
-	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-1 */
-	return 0;
-}
-
-static struct sysdev_class i8259_sysdev_class = {
-	.name = "i8259",
-	.suspend = i8259A_suspend,
-	.resume = i8259A_resume,
-	.shutdown = i8259A_shutdown,
-};
-
-static struct sys_device device_i8259A = {
-	.id	= 0,
-	.cls	= &i8259_sysdev_class,
-};
-
-static int __init i8259A_init_sysfs(void)
-{
-	int error = sysdev_class_register(&i8259_sysdev_class);
-	if (!error)
-		error = sysdev_register(&device_i8259A);
-	return error;
-}
-
-device_initcall(i8259A_init_sysfs);
-
-void init_8259A(int auto_eoi)
-{
-	unsigned long flags;
-
-	i8259A_auto_eoi = auto_eoi;
-
-	spin_lock_irqsave(&i8259A_lock, flags);
-
-	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
-	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
-
-	/*
-	 * outb_pic - this has to work on a wide range of PC hardware.
-	 */
-	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
-	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 */
-	outb_pic(IRQ0_VECTOR, PIC_MASTER_IMR);
-	/* 8259A-1 (the master) has a slave on IR2 */
-	outb_pic(0x04, PIC_MASTER_IMR);
-	if (auto_eoi)	/* master does Auto EOI */
-		outb_pic(MASTER_ICW4_DEFAULT | PIC_ICW4_AEOI, PIC_MASTER_IMR);
-	else		/* master expects normal EOI */
-		outb_pic(MASTER_ICW4_DEFAULT, PIC_MASTER_IMR);
-
-	outb_pic(0x11, PIC_SLAVE_CMD);	/* ICW1: select 8259A-2 init */
-	/* ICW2: 8259A-2 IR0-7 mapped to 0x38-0x3f */
-	outb_pic(IRQ8_VECTOR, PIC_SLAVE_IMR);
-	/* 8259A-2 is a slave on master's IR2 */
-	outb_pic(PIC_CASCADE_IR, PIC_SLAVE_IMR);
-	/* (slave's support for AEOI in flat mode is to be investigated) */
-	outb_pic(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR);
-
-	if (auto_eoi)
-		/*
-		 * In AEOI mode we just have to mask the interrupt
-		 * when acking.
-		 */
-		i8259A_chip.mask_ack = disable_8259A_irq;
-	else
-		i8259A_chip.mask_ack = mask_and_ack_8259A;
-
-	udelay(100);		/* wait for 8259A to initialize */
-
-	outb(cached_master_mask, PIC_MASTER_IMR); /* restore master IRQ mask */
-	outb(cached_slave_mask, PIC_SLAVE_IMR);	  /* restore slave IRQ mask */
-
-	spin_unlock_irqrestore(&i8259A_lock, flags);
-}
-
-
-
-
-/*
  * IRQ2 is cascade interrupt to second interrupt controller
  */
 
diff --git a/include/asm-x86/hw_irq_32.h b/include/asm-x86/hw_irq_32.h
index ea88054..91fdeb9 100644
--- a/include/asm-x86/hw_irq_32.h
+++ b/include/asm-x86/hw_irq_32.h
@@ -20,6 +20,26 @@ #include <asm/sections.h>
 #define NMI_VECTOR		0x02
 
 /*
+ * Vectors 0x20-0x2f are used for ISA interrupts.
+ */
+#define IRQ0_VECTOR		(0x20)
+#define IRQ1_VECTOR		(IRQ0_VECTOR + 1)
+#define IRQ2_VECTOR		(IRQ0_VECTOR + 2)
+#define IRQ3_VECTOR		(IRQ0_VECTOR + 3)
+#define IRQ4_VECTOR		(IRQ0_VECTOR + 4)
+#define IRQ5_VECTOR		(IRQ0_VECTOR + 5)
+#define IRQ6_VECTOR		(IRQ0_VECTOR + 6)
+#define IRQ7_VECTOR		(IRQ0_VECTOR + 7)
+#define IRQ8_VECTOR		(IRQ0_VECTOR + 8)
+#define IRQ9_VECTOR		(IRQ0_VECTOR + 9)
+#define IRQ10_VECTOR		(IRQ0_VECTOR + 10)
+#define IRQ11_VECTOR		(IRQ0_VECTOR + 11)
+#define IRQ12_VECTOR		(IRQ0_VECTOR + 12)
+#define IRQ13_VECTOR		(IRQ0_VECTOR + 13)
+#define IRQ14_VECTOR		(IRQ0_VECTOR + 14)
+#define IRQ15_VECTOR		(IRQ0_VECTOR + 15)
+
+/*
  * Various low-level irq details needed by irq.c, process.c,
  * time.c, io_apic.c and smp.c
  *
diff --git a/include/asm-x86/i8259.h b/include/asm-x86/i8259.h
index 45d4df3..2f98df9 100644
--- a/include/asm-x86/i8259.h
+++ b/include/asm-x86/i8259.h
@@ -55,4 +55,6 @@ static inline void outb_pic(unsigned cha
 	udelay(2);
 }
 
+extern struct irq_chip i8259A_chip;
+
 #endif	/* __ASM_I8259_H__ */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
