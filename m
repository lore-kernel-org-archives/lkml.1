Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471Ab0AKVcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0AKVcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944Ab0AKV1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:18 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:34876 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab0AKV1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=JIiJDitg8W2Sr87qet1xUcUrw7ew7U0JeE7bhyrQn3fEFwcXKzbSZ/AFdW0CEtIp+p
         rYo5//cVii92J6Ta1DlNf7KnoCPkK0mrduc+Vb+WTuABDebRDio2mF76gQ19DAGBmm0+
         NHo7Cuiz/dmg7pc1oXqLkXbr/UsqDEDU6h1T0=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 06/26] x86: Convert i8259A_lock to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:36 +0100
Message-Id: <1263245216-14754-7-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-6-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot sleep in preempt-rt to raw_spinlocks.

See also: 62dff70985cfec2c958f27c76f66ac2dfbfa3cef

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/x86/include/asm/i8259.h   |    2 +-
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 arch/x86/kernel/i8259.c        |   30 +++++++++++++++---------------
 arch/x86/kernel/time.c         |    4 ++--
 arch/x86/kernel/visws_quirks.c |    6 +++---
 5 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/i8259.h b/arch/x86/include/asm/i8259.h
index 58d7091..7ec65b1 100644
--- a/arch/x86/include/asm/i8259.h
+++ b/arch/x86/include/asm/i8259.h
@@ -24,7 +24,7 @@ extern unsigned int cached_irq_mask;
 #define SLAVE_ICW4_DEFAULT	0x01
 #define PIC_ICW4_AEOI		2
 
-extern spinlock_t i8259A_lock;
+extern raw_spinlock_t i8259A_lock;
 
 extern void init_8259A(int auto_eoi);
 extern void enable_8259A_irq(unsigned int irq);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7719fa0..06757c8 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1830,7 +1830,7 @@ __apicdebuginit(void) print_PIC(void)
 
 	printk(KERN_DEBUG "\nprinting PIC contents\n");
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
 	v = inb(0xa1) << 8 | inb(0x21);
 	printk(KERN_DEBUG "... PIC  IMR: %04x\n", v);
@@ -1844,7 +1844,7 @@ __apicdebuginit(void) print_PIC(void)
 	outb(0x0a,0xa0);
 	outb(0x0a,0x20);
 
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 
 	printk(KERN_DEBUG "... PIC  ISR: %04x\n", v);
 
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index df89102..8c93a84 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -32,7 +32,7 @@
  */
 
 static int i8259A_auto_eoi;
-DEFINE_SPINLOCK(i8259A_lock);
+DEFINE_RAW_SPINLOCK(i8259A_lock);
 static void mask_and_ack_8259A(unsigned int);
 
 struct irq_chip i8259A_chip = {
@@ -68,13 +68,13 @@ void disable_8259A_irq(unsigned int irq)
 	unsigned int mask = 1 << irq;
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 	cached_irq_mask |= mask;
 	if (irq & 8)
 		outb(cached_slave_mask, PIC_SLAVE_IMR);
 	else
 		outb(cached_master_mask, PIC_MASTER_IMR);
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
 void enable_8259A_irq(unsigned int irq)
@@ -82,13 +82,13 @@ void enable_8259A_irq(unsigned int irq)
 	unsigned int mask = ~(1 << irq);
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 	cached_irq_mask &= mask;
 	if (irq & 8)
 		outb(cached_slave_mask, PIC_SLAVE_IMR);
 	else
 		outb(cached_master_mask, PIC_MASTER_IMR);
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
 int i8259A_irq_pending(unsigned int irq)
@@ -97,12 +97,12 @@ int i8259A_irq_pending(unsigned int irq)
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 	if (irq < 8)
 		ret = inb(PIC_MASTER_CMD) & mask;
 	else
 		ret = inb(PIC_SLAVE_CMD) & (mask >> 8);
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 
 	return ret;
 }
@@ -150,7 +150,7 @@ static void mask_and_ack_8259A(unsigned int irq)
 	unsigned int irqmask = 1 << irq;
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 	/*
 	 * Lightweight spurious IRQ detection. We do not want
 	 * to overdo spurious IRQ handling - it's usually a sign
@@ -183,7 +183,7 @@ handle_real_irq:
 		outb(cached_master_mask, PIC_MASTER_IMR);
 		outb(0x60+irq, PIC_MASTER_CMD);	/* 'Specific EOI to master */
 	}
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 	return;
 
 spurious_8259A_irq:
@@ -285,24 +285,24 @@ void mask_8259A(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
 	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
 	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
 
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
 void unmask_8259A(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
 	outb(cached_master_mask, PIC_MASTER_IMR); /* restore master IRQ mask */
 	outb(cached_slave_mask, PIC_SLAVE_IMR);	  /* restore slave IRQ mask */
 
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
 void init_8259A(int auto_eoi)
@@ -311,7 +311,7 @@ void init_8259A(int auto_eoi)
 
 	i8259A_auto_eoi = auto_eoi;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
 	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
 	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
@@ -356,5 +356,5 @@ void init_8259A(int auto_eoi)
 	outb(cached_master_mask, PIC_MASTER_IMR); /* restore master IRQ mask */
 	outb(cached_slave_mask, PIC_SLAVE_IMR);	  /* restore slave IRQ mask */
 
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index be25734..fb5cc5e 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -70,11 +70,11 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 		 * manually to deassert NMI lines for the watchdog if run
 		 * on an 82489DX-based system.
 		 */
-		spin_lock(&i8259A_lock);
+		raw_spin_lock(&i8259A_lock);
 		outb(0x0c, PIC_MASTER_OCW3);
 		/* Ack the IRQ; AEOI will end it automatically. */
 		inb(PIC_MASTER_POLL);
-		spin_unlock(&i8259A_lock);
+		raw_spin_unlock(&i8259A_lock);
 	}
 
 	global_clock_event->event_handler(global_clock_event);
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 34a279a..ab38ce0 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -559,7 +559,7 @@ static irqreturn_t piix4_master_intr(int irq, void *dev_id)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8259A_lock, flags);
+	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
 	/* Find out what's interrupting in the PIIX4 master 8259 */
 	outb(0x0c, 0x20);		/* OCW3 Poll command */
@@ -596,7 +596,7 @@ static irqreturn_t piix4_master_intr(int irq, void *dev_id)
 		outb(0x60 + realirq, 0x20);
 	}
 
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 
 	desc = irq_to_desc(realirq);
 
@@ -614,7 +614,7 @@ static irqreturn_t piix4_master_intr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 
 out_unlock:
-	spin_unlock_irqrestore(&i8259A_lock, flags);
+	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 	return IRQ_NONE;
 }
 
-- 
1.6.5.2

