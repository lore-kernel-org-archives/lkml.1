Return-Path: <linux-kernel-owner+w=401wt.eu-S937842AbXGSNy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937842AbXGSNy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762474AbXGSNsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:43 -0400
Received: from ns2.suse.de ([195.135.220.15]:48611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936509AbXGSNsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:42 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, dtor@mail.ru,
       linux-kernel@vger.kernel.org
Subject: [PATCH for review] [12/48] x86_64: use the global PIT lock
Message-Id: <20070719134841.5677614E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Gleixner <tglx@linutronix.de>

Replace the pcspkr private PIT lock by the global PIT lock to serialize the
PIT access all over the place.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/time.c   |    2 ++
 drivers/input/misc/pcspkr.c |   11 ++++++++---
 include/asm-x86_64/i8253.h  |    6 ++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

Index: linux/arch/x86_64/kernel/time.c
===================================================================
--- linux.orig/arch/x86_64/kernel/time.c
+++ linux/arch/x86_64/kernel/time.c
@@ -33,6 +33,7 @@
 #include <acpi/acpi_bus.h>
 #endif
 #include <asm/8253pit.h>
+#include <asm/i8253.h>
 #include <asm/pgtable.h>
 #include <asm/vsyscall.h>
 #include <asm/timex.h>
@@ -51,6 +52,7 @@ static char *timename = NULL;
 DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
 DEFINE_SPINLOCK(i8253_lock);
+EXPORT_SYMBOL(i8253_lock);
 
 volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
 
Index: linux/drivers/input/misc/pcspkr.c
===================================================================
--- linux.orig/drivers/input/misc/pcspkr.c
+++ linux/drivers/input/misc/pcspkr.c
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
Index: linux/include/asm-x86_64/i8253.h
===================================================================
--- /dev/null
+++ linux/include/asm-x86_64/i8253.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_I8253_H__
+#define __ASM_I8253_H__
+
+extern spinlock_t i8253_lock;
+
+#endif	/* __ASM_I8253_H__ */
