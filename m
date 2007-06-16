Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbXFPK1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbXFPK1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 06:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbXFPKYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 06:24:20 -0400
Received: from www.osadl.org ([213.239.205.134]:37202 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753877AbXFPKYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 06:24:15 -0400
Message-Id: <20070616101636.989765471@inhelltoy.tec.linutronix.de>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 16 Jun 2007 10:36:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch-mm 12/25] pcspkr: use the global PIT lock
Content-Disposition: inline; filename=pcspkr-use-the-global-pit-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the pcspkr private PIT lock by the global PIT lock to
serialize the PIT access all over the place.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86_64/kernel/time.c   |    2 ++
 drivers/input/misc/pcspkr.c |   11 ++++++++---
 include/asm-x86_64/i8253.h  |    6 ++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc4-mm/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/x86_64/kernel/time.c	2007-06-16 12:10:21.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/x86_64/kernel/time.c	2007-06-16 12:10:23.000000000 +0200
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
 
Index: linux-2.6.22-rc4-mm/drivers/input/misc/pcspkr.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/drivers/input/misc/pcspkr.c	2007-06-16 12:10:21.000000000 +0200
+++ linux-2.6.22-rc4-mm/drivers/input/misc/pcspkr.c	2007-06-16 12:10:23.000000000 +0200
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
Index: linux-2.6.22-rc4-mm/include/asm-x86_64/i8253.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22-rc4-mm/include/asm-x86_64/i8253.h	2007-06-16 12:10:23.000000000 +0200
@@ -0,0 +1,6 @@
+#ifndef __ASM_I8253_H__
+#define __ASM_I8253_H__
+
+extern spinlock_t i8253_lock;
+
+#endif	/* __ASM_I8253_H__ */

-- 

