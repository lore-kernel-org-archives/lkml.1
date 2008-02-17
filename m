Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbYBQVSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbYBQVSE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbYBQVRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:17:44 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:6010 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbYBQVRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:17:43 -0500
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2008 16:17:36 EST
Date: Sun, 17 Feb 2008 16:08:11 -0500 (EST)
From: <dpreed@reed.com>
Message-Id: <200802172108.JRY53897@mr08.lnh.mail.rcn.net>
X-Junkmail-Status: score=10/50, host=mr08.lnh.mail.rcn.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A010204.47B8A23B.0036,ss=1,fgs=0,
	ip=207.172.4.11,
	so=2007-10-30 19:00:17,
	dmn=5.4.3/2007-11-16
X-Junkmail-IWF: false
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From David P. Reed <dpreed@reed.com> Sat Feb 16 15:05:17 2008
Message-Id: <20080216200517.289893560@reed.com>>
References: <20080216200517.113862251@reed.com>>
User-Agent: quilt/0.46-1
Date: Sat, 16 Feb 2008 15:05:18 -0500
From: David P. Reed <dpreed@reed.com>
To: Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org,
 "David P. Reed" <dpreed@reed.com>
Subject: [PATCH 1/3] x86: fix init_8259A() to not use outb_pic
Content-Disposition: inline; filename=fix-8259-iodelay.patch

fix init_8259A() which initializes the 8259 PIC to not use outb_pic,
which is a renamed version of outb_p, and delete outb_pic define.
There is already code in the .c files that does accesses to CMD & IMR registers
in successive outb() calls without _p.  Thus the outb_p is obviously not
needed, if it ever was.  Research into chipset documentation and old BIOS
listings shows that IODELAY was not used even in early machines.  Thus
the delay between i/o port writes was deleted for the 8259.

Again, the primary reason for fixing this is to use proper delay strategy,
and in particular to fix crashes that can result from using port 80 writes
on machines that have resources on port 80, such as the ENE chips used by Quanta
in latops it designs and sells to, e.g. HP.

Signed-off-by: David P. Reed <dpreed@reed.com>
Index: linux-2.6/arch/x86/kernel/i8259_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/i8259_32.c
+++ linux-2.6/arch/x86/kernel/i8259_32.c
@@ -285,24 +285,30 @@ void init_8259A(int auto_eoi)
 
 	spin_lock_irqsave(&i8259A_lock, flags);
 
-	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
-	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
-
-	/*
-	 * outb_pic - this has to work on a wide range of PC hardware.
-	 */
-	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
-	outb_pic(0x20 + 0, PIC_MASTER_IMR);	/* ICW2: 8259A-1 IR0-7 mapped to 0x20-0x27 */
-	outb_pic(1U << PIC_CASCADE_IR, PIC_MASTER_IMR);	/* 8259A-1 (the master) has a slave on IR2 */
+	/* mask all of 8259A-1 */
+	outb(0xff, PIC_MASTER_IMR);
+	/* mask all of 8259A-2 */
+	outb(0xff, PIC_SLAVE_IMR);
+
+	/* ICW1: select 8259A-1 init */
+	outb(0x11, PIC_MASTER_CMD);
+	/* ICW2: 8259A-1 IR0-7 mapped to 0x20-0x27 */
+	outb(0x20 + 0, PIC_MASTER_IMR);
+	/* 8259A-1 (the master) has a slave on IR2 */
+	outb(1U << PIC_CASCADE_IR, PIC_MASTER_IMR);
 	if (auto_eoi)	/* master does Auto EOI */
-		outb_pic(MASTER_ICW4_DEFAULT | PIC_ICW4_AEOI, PIC_MASTER_IMR);
+		outb(MASTER_ICW4_DEFAULT | PIC_ICW4_AEOI, PIC_MASTER_IMR);
 	else		/* master expects normal EOI */
-		outb_pic(MASTER_ICW4_DEFAULT, PIC_MASTER_IMR);
+		outb(MASTER_ICW4_DEFAULT, PIC_MASTER_IMR);
 
-	outb_pic(0x11, PIC_SLAVE_CMD);	/* ICW1: select 8259A-2 init */
-	outb_pic(0x20 + 8, PIC_SLAVE_IMR);	/* ICW2: 8259A-2 IR0-7 mapped to 0x28-0x2f */
-	outb_pic(PIC_CASCADE_IR, PIC_SLAVE_IMR);	/* 8259A-2 is a slave on master's IR2 */
-	outb_pic(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR); /* (slave's support for AEOI in flat mode is to be investigated) */
+	/* ICW1: select 8259A-2 init */
+	outb(0x11, PIC_SLAVE_CMD);
+	/* ICW2: 8259A-2 IR0-7 mapped to 0x28-0x2f */
+	outb(0x20 + 8, PIC_SLAVE_IMR);
+	/* 8259A-2 is a slave on master's IR2 */
+	outb(PIC_CASCADE_IR, PIC_SLAVE_IMR);
+	/* (slave's support for AEOI in flat mode is to be investigated) */
+	outb(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR);
 	if (auto_eoi)
 		/*
 		 * In AEOI mode we just have to mask the interrupt
Index: linux-2.6/arch/x86/kernel/i8259_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/i8259_64.c
+++ linux-2.6/arch/x86/kernel/i8259_64.c
@@ -355,29 +355,30 @@ void init_8259A(int auto_eoi)
 
 	spin_lock_irqsave(&i8259A_lock, flags);
 
-	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
-	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
+	/* mask all of 8259A-1 */
+	outb(0xff, PIC_MASTER_IMR);
+	/* mask all of 8259A-2 */
+	outb(0xff, PIC_SLAVE_IMR);
 
-	/*
-	 * outb_pic - this has to work on a wide range of PC hardware.
-	 */
-	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
+	/* ICW1: select 8259A-1 init */
+	outb(0x11, PIC_MASTER_CMD);
 	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 */
-	outb_pic(IRQ0_VECTOR, PIC_MASTER_IMR);
+	outb(IRQ0_VECTOR, PIC_MASTER_IMR);
 	/* 8259A-1 (the master) has a slave on IR2 */
-	outb_pic(0x04, PIC_MASTER_IMR);
+	outb(0x04, PIC_MASTER_IMR);
 	if (auto_eoi)	/* master does Auto EOI */
-		outb_pic(MASTER_ICW4_DEFAULT | PIC_ICW4_AEOI, PIC_MASTER_IMR);
+		outb(MASTER_ICW4_DEFAULT | PIC_ICW4_AEOI, PIC_MASTER_IMR);
 	else		/* master expects normal EOI */
-		outb_pic(MASTER_ICW4_DEFAULT, PIC_MASTER_IMR);
+		outb(MASTER_ICW4_DEFAULT, PIC_MASTER_IMR);
 
-	outb_pic(0x11, PIC_SLAVE_CMD);	/* ICW1: select 8259A-2 init */
+	/* ICW1: select 8259A-2 init */
+	outb(0x11, PIC_SLAVE_CMD);
 	/* ICW2: 8259A-2 IR0-7 mapped to 0x38-0x3f */
-	outb_pic(IRQ8_VECTOR, PIC_SLAVE_IMR);
+	outb(IRQ8_VECTOR, PIC_SLAVE_IMR);
 	/* 8259A-2 is a slave on master's IR2 */
-	outb_pic(PIC_CASCADE_IR, PIC_SLAVE_IMR);
+	outb(PIC_CASCADE_IR, PIC_SLAVE_IMR);
 	/* (slave's support for AEOI in flat mode is to be investigated) */
-	outb_pic(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR);
+	outb(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR);
 
 	if (auto_eoi)
 		/*
Index: linux-2.6/include/asm-x86/i8259.h
===================================================================
--- linux-2.6.orig/include/asm-x86/i8259.h
+++ linux-2.6/include/asm-x86/i8259.h
@@ -29,7 +29,5 @@ extern void enable_8259A_irq(unsigned in
 extern void disable_8259A_irq(unsigned int irq);
 extern unsigned int startup_8259A_irq(unsigned int irq);
 
-#define inb_pic		inb_p
-#define outb_pic	outb_p
 
 #endif	/* __ASM_I8259_H__ */

-- 
