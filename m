Return-Path: <linux-kernel-owner+w=401wt.eu-S934973AbYEVWby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934973AbYEVWby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760213AbYEVWbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:31:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47269 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758744AbYEVWbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:31:41 -0400
Date: Fri, 23 May 2008 00:32:32 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, macro@ds2.pg.gda.pl
Subject: i8259: fix final uglyness
Message-ID: <20080522223232.GA1602@elf.ucw.cz>
References: <20080520151528.GA1596@elf.ucw.cz> <20080520204750.GA31409@elte.hu> <20080521094402.GB12763@elf.ucw.cz> <alpine.LFD.1.10.0805222030050.3295@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805222030050.3295@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce IRQx_VECTOR on 32-bit, so that #ifdef noise is kept
down. There should be no object code change.


Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit e9f4353b46ec2b05f73e1a84085c305de211bd3e
tree 560080f09144090fe5caa17f6740f6710bb6421b
parent 81657c7907691cd20f40747563bfc9eb9e79f7e2
author Pavel <pavel@amd.ucw.cz> Thu, 22 May 2008 22:36:59 +0200
committer Pavel <pavel@amd.ucw.cz> Thu, 22 May 2008 22:36:59 +0200

 arch/x86/kernel/i8259.c     |   19 ++++++-------------
 include/asm-x86/hw_irq_32.h |   17 +++++++++++++++++
 2 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 7a0fda8..7ad0560 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -297,26 +297,20 @@ void init_8259A(int auto_eoi)
 	 * outb_pic - this has to work on a wide range of PC hardware.
 	 */
 	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
-#ifndef CONFIG_X86_64
-	outb_pic(0x20 + 0, PIC_MASTER_IMR);	/* ICW2: 8259A-1 IR0-7 mapped to 0x20-0x27 */
-	outb_pic(1U << PIC_CASCADE_IR, PIC_MASTER_IMR);	/* 8259A-1 (the master) has a slave on IR2 */
-#else /* CONFIG_X86_64 */
-	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 */
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
+
 	/* ICW2: 8259A-2 IR0-7 mapped to IRQ8_VECTOR.. */
 	outb_pic(IRQ8_VECTOR, PIC_SLAVE_IMR);
 	/* 8259A-2 is a slave on master's IR2 */
@@ -324,7 +318,6 @@ #else /* CONFIG_X86_64 */
 	/* (slave's support for AEOI in flat mode is to be investigated) */
 	outb_pic(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR);
 
-#endif /* CONFIG_X86_64 */
 	if (auto_eoi)
 		/*
 		 * In AEOI mode we just have to mask the interrupt
diff --git a/include/asm-x86/hw_irq_32.h b/include/asm-x86/hw_irq_32.h
index ea88054..6ad2e51 100644
--- a/include/asm-x86/hw_irq_32.h
+++ b/include/asm-x86/hw_irq_32.h
@@ -19,6 +19,23 @@ #include <asm/sections.h>
 
 #define NMI_VECTOR		0x02
 
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
 /*
  * Various low-level irq details needed by irq.c, process.c,
  * time.c, io_apic.c and smp.c


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
