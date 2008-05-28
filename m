Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYE1Kmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYE1Kmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 06:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYE1Kmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 06:42:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59672 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYE1Kmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 06:42:31 -0400
Date: Wed, 28 May 2008 12:42:57 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, macro@ds2.pg.gda.pl
Subject: Re: i8259: fix final uglyness
Message-ID: <20080528104257.GD5728@elf.ucw.cz>
References: <20080520151528.GA1596@elf.ucw.cz> <20080520204750.GA31409@elte.hu> <20080521094402.GB12763@elf.ucw.cz> <alpine.LFD.1.10.0805222030050.3295@apollo.tec.linutronix.de> <20080522223232.GA1602@elf.ucw.cz> <alpine.LFD.1.10.0805271043220.3295@apollo.tec.linutronix.de> <20080527085541.GA1708@elf.ucw.cz> <alpine.LFD.1.10.0805271100450.3295@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805271100450.3295@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Introduce IRQx_VECTOR on 32-bit, so that #ifdef noise is kept
> > > > down. There should be no object code change.
> > > 
> > > thanks for doing this. The patch fails due to other changes in this
> > > area (especially the hw_irq.h unification). Can you please redo against:

Done.

--- 

Introduce IRQx_VECTOR on 32-bit, so that #ifdef noise is kept
down. There should be no object code change.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 7a0fda8..dc92b49 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -297,34 +297,28 @@ void init_8259A(int auto_eoi)
 	 * outb_pic - this has to work on a wide range of PC hardware.
 	 */
 	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
-#ifndef CONFIG_X86_64
-	outb_pic(0x20 + 0, PIC_MASTER_IMR);	/* ICW2: 8259A-1 IR0-7 mapped to 0x20-0x27 */
-	outb_pic(1U << PIC_CASCADE_IR, PIC_MASTER_IMR);	/* 8259A-1 (the master) has a slave on IR2 */
-#else /* CONFIG_X86_64 */
-	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 */
+
+	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 on x86-64,
+	                       to 0x20-0x27 on i386 */
 	outb_pic(IRQ0_VECTOR, PIC_MASTER_IMR);
+
 	/* 8259A-1 (the master) has a slave on IR2 */
-	outb_pic(0x04, PIC_MASTER_IMR);
-#endif /* CONFIG_X86_64 */
+	outb_pic(1U << PIC_CASCADE_IR, PIC_MASTER_IMR);
+
 	if (auto_eoi)	/* master does Auto EOI */
 		outb_pic(MASTER_ICW4_DEFAULT | PIC_ICW4_AEOI, PIC_MASTER_IMR);
 	else		/* master expects normal EOI */
 		outb_pic(MASTER_ICW4_DEFAULT, PIC_MASTER_IMR);
 
 	outb_pic(0x11, PIC_SLAVE_CMD);	/* ICW1: select 8259A-2 init */
-#ifndef CONFIG_X86_64
-	outb_pic(0x20 + 8, PIC_SLAVE_IMR);	/* ICW2: 8259A-2 IR0-7 mapped to 0x28-0x2f */
-	outb_pic(PIC_CASCADE_IR, PIC_SLAVE_IMR);	/* 8259A-2 is a slave on master's IR2 */
-	outb_pic(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR); /* (slave's support for AEOI in flat mode is to be investigated) */
-#else /* CONFIG_X86_64 */
-	/* ICW2: 8259A-2 IR0-7 mapped to 0x38-0x3f */
+
+	/* ICW2: 8259A-2 IR0-7 mapped to IRQ8_VECTOR */
 	outb_pic(IRQ8_VECTOR, PIC_SLAVE_IMR);
 	/* 8259A-2 is a slave on master's IR2 */
 	outb_pic(PIC_CASCADE_IR, PIC_SLAVE_IMR);
 	/* (slave's support for AEOI in flat mode is to be investigated) */
 	outb_pic(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR);
 
-#endif /* CONFIG_X86_64 */
 	if (auto_eoi)
 		/*
 		 * In AEOI mode we just have to mask the interrupt
diff --git a/include/asm-x86/irq_vectors.h b/include/asm-x86/irq_vectors.h
index 3cb6d8c..b58581e 100644
--- a/include/asm-x86/irq_vectors.h
+++ b/include/asm-x86/irq_vectors.h
@@ -18,17 +18,20 @@ # define IA32_SYSCALL_VECTOR	0x80
 #endif
 
 /*
- * Vectors 0x20-0x2f are used for ISA interrupts on 32 bit.
- *
  * Reserve the lowest usable priority level 0x20 - 0x2f for triggering
  * cleanup after irq migration on 64 bit.
  */
 #define IRQ_MOVE_CLEANUP_VECTOR	FIRST_EXTERNAL_VECTOR
 
 /*
- * Vectors 0x30-0x3f are used for ISA interrupts on 64 bit
+ * Vectors 0x20-0x2f are used for ISA interrupts on 32 bit.
+ * Vectors 0x30-0x3f are used for ISA interrupts on 64 bit.
  */
+#ifdef CONFIG_X86_32
+#define IRQ0_VECTOR		(FIRST_EXTERNAL_VECTOR)
+#else
 #define IRQ0_VECTOR		(FIRST_EXTERNAL_VECTOR + 0x10)
+#endif
 #define IRQ1_VECTOR		(IRQ0_VECTOR + 1)
 #define IRQ2_VECTOR		(IRQ0_VECTOR + 2)
 #define IRQ3_VECTOR		(IRQ0_VECTOR + 3)



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
