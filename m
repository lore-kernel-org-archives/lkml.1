Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbXFWN1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbXFWN1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758288AbXFWNWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:22:21 -0400
Received: from www.osadl.org ([213.239.205.134]:59264 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755694AbXFWNWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:22:10 -0400
Message-Id: <20070623124030.894902330@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch -mm 17/28] i386: move PIT function declarations and constants
	to correct header file
Content-Disposition: inline;
	filename=i386-move-pit-related-functions-and-constants-to-i8253-h.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

setup_pit_timer is declared in asm-i386/timer.h. Move it to the pit header
file, so it can be used by x86_64 as well.

Move also the PIT constants.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/i8253.c                 |    2 --
 arch/i386/kernel/vmiclock.c              |    1 +
 include/asm-i386/i8253.h                 |    7 +++++++
 include/asm-i386/mach-default/io_ports.h |    5 -----
 include/asm-i386/timer.h                 |    1 -
 5 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6.22-rc4-mm/include/asm-i386/i8253.h
===================================================================
--- linux-2.6.22-rc4-mm.orig/include/asm-i386/i8253.h	2007-06-23 14:38:55.000000000 +0200
+++ linux-2.6.22-rc4-mm/include/asm-i386/i8253.h	2007-06-23 14:38:59.000000000 +0200
@@ -3,6 +3,11 @@
 
 #include <linux/clockchips.h>
 
+/* i8253A PIT registers */
+#define PIT_MODE		0x43
+#define PIT_CH0			0x40
+#define PIT_CH2			0x42
+
 extern spinlock_t i8253_lock;
 
 extern struct clock_event_device *global_clock_event;
@@ -18,4 +23,6 @@ static inline void pit_interrupt_hook(vo
 	global_clock_event->event_handler(global_clock_event);
 }
 
+extern void setup_pit_timer(void);
+
 #endif	/* __ASM_I8253_H__ */
Index: linux-2.6.22-rc4-mm/include/asm-i386/timer.h
===================================================================
--- linux-2.6.22-rc4-mm.orig/include/asm-i386/timer.h	2007-06-23 14:38:59.000000000 +0200
+++ linux-2.6.22-rc4-mm/include/asm-i386/timer.h	2007-06-23 14:38:59.000000000 +0200
@@ -6,7 +6,6 @@
 
 #define TICK_SIZE (tick_nsec / 1000)
 
-void setup_pit_timer(void);
 unsigned long long native_sched_clock(void);
 unsigned long native_calculate_cpu_khz(void);
 
Index: linux-2.6.22-rc4-mm/arch/i386/kernel/i8253.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/i386/kernel/i8253.c	2007-06-23 14:38:59.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/i386/kernel/i8253.c	2007-06-23 14:38:59.000000000 +0200
@@ -15,8 +15,6 @@
 #include <asm/io.h>
 #include <asm/timer.h>
 
-#include "io_ports.h"
-
 DEFINE_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
 
Index: linux-2.6.22-rc4-mm/arch/i386/kernel/vmiclock.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/i386/kernel/vmiclock.c	2007-06-23 14:38:58.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/i386/kernel/vmiclock.c	2007-06-23 14:38:59.000000000 +0200
@@ -32,6 +32,7 @@
 #include <asm/apicdef.h>
 #include <asm/apic.h>
 #include <asm/timer.h>
+#include <asm/i8253.h>
 
 #include <irq_vectors.h>
 #include "io_ports.h"
Index: linux-2.6.22-rc4-mm/include/asm-i386/mach-default/io_ports.h
===================================================================
--- linux-2.6.22-rc4-mm.orig/include/asm-i386/mach-default/io_ports.h	2007-06-23 14:38:55.000000000 +0200
+++ linux-2.6.22-rc4-mm/include/asm-i386/mach-default/io_ports.h	2007-06-23 14:38:59.000000000 +0200
@@ -7,11 +7,6 @@
 #ifndef _MACH_IO_PORTS_H
 #define _MACH_IO_PORTS_H
 
-/* i8253A PIT registers */
-#define PIT_MODE		0x43
-#define PIT_CH0			0x40
-#define PIT_CH2			0x42
-
 /* i8259A PIC registers */
 #define PIC_MASTER_CMD		0x20
 #define PIC_MASTER_IMR		0x21

-- 

