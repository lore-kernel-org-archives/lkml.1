Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbXEQNbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbXEQNbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 09:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbXEQNbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 09:31:18 -0400
Received: from www.osadl.org ([213.239.205.134]:47682 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751661AbXEQNbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 09:31:17 -0400
Subject: [PATCH] INPUT: Sanitize PIT locking in pcspkr
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Stable Team <stable@kernel.org>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Richard Henderson <rth@twiddle.net>
Content-Type: text/plain
Date: Thu, 17 May 2007 15:36:02 +0200
Message-Id: <1179408962.3764.72.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The PC-speaker code has a quite creative method to serialize access to
the PIT: It uses a local lock.

On i386 and x86_64 the access to the PIT is serialized by a lock in the
architecture code. The separate locking in the PC-speaker code ignores
the global lock and creates a nasty race between the PC-speaker and the
PIT clock source / events code on SMP machines.

Use the global i8253_lock instead of the local i8253_beep_lock, when
compiled for i386/x86_64.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Index: linux-2.6/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/time.c
+++ linux-2.6/arch/x86_64/kernel/time.c
@@ -33,6 +33,7 @@
 #include <acpi/acpi_bus.h>
 #endif
 #include <asm/8253pit.h>
+#include <asm/i8253.h>
 #include <asm/pgtable.h>
 #include <asm/vsyscall.h>
 #include <asm/timex.h>
@@ -50,6 +51,7 @@ static char *timename = NULL;
 DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
 DEFINE_SPINLOCK(i8253_lock);
+EXPORT_SYMBOL(i8253_lock);
 
 volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
 
Index: linux-2.6/drivers/input/misc/pcspkr.c
===================================================================
--- linux-2.6.orig/drivers/input/misc/pcspkr.c
+++ linux-2.6/drivers/input/misc/pcspkr.c
@@ -24,7 +24,12 @@ MODULE_AUTHOR("Vojtech Pavlik <vojtech@u
 MODULE_DESCRIPTION("PC Speaker beeper driver");
 MODULE_LICENSE("GPL");
 
-static DEFINE_SPINLOCK(i8253_beep_lock);
+#ifdef CONFIG_X86
+/* Use the global PIT lock ! */
+#include <asm/i8253.h>
+#else
+static DEFINE_SPINLOCK(i8253_lock);
+#endif
 
 static int pcspkr_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
 {
@@ -43,7 +48,7 @@ static int pcspkr_event(struct input_dev
 	if (value > 20 && value < 32767)
 		count = PIT_TICK_RATE / value;
 
-	spin_lock_irqsave(&i8253_beep_lock, flags);
+	spin_lock_irqsave(&i8253_lock, flags);
 
 	if (count) {
 		/* enable counter 2 */
@@ -58,7 +63,7 @@ static int pcspkr_event(struct input_dev
 		outb(inb_p(0x61) & 0xFC, 0x61);
 	}
 
-	spin_unlock_irqrestore(&i8253_beep_lock, flags);
+	spin_unlock_irqrestore(&i8253_lock, flags);
 
 	return 0;
 }
Index: linux-2.6/include/asm-x86_64/i8253.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86_64/i8253.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_I8253_H__
+#define __ASM_I8253_H__
+
+extern spinlock_t i8253_lock;
+
+#endif	/* __ASM_I8253_H__ */


