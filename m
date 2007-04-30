Return-Path: <linux-kernel-owner+w=401wt.eu-S1423236AbXD3NKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423236AbXD3NKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 09:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423235AbXD3NKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 09:10:05 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:56106 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423233AbXD3NKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 09:10:04 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>
Subject: [PATCH] [1/1] CPU-i386-Geode: Chipset access macros do not work as expected
Date: Mon, 30 Apr 2007 15:09:58 +0200
User-Agent: KMail/1.9.4
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301509.58776.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juergen Beisert <juergen.beisert@weihenstephan.org>

Replace NSC/Cyrix specific chipset access macros by inlined functions.
With the macros a line like this fails (and does nothing):
	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
With inlined functions this line will work as expected.

Note about a side effect: Seems on Geode GX1 based systems the
"suspend on halt power saving feature" was never enabled due to this
wrong macro expansion. With inlined functions it will be enabled, but
this will stop the TSC when the CPU runs into a HLT instruction.
Kernel output something like this:
	Clocksource tsc unstable (delta = -472746897 ns)
Tested on a Geode GX1 system.

Signed-off-by: Juergen Beisert <juergen.beisert@weihenstephan.org>

Index: linux-2.6.21/include/asm-i386/processor.h
===================================================================
--- linux-2.6.21.orig/include/asm-i386/processor.h
+++ linux-2.6.21/include/asm-i386/processor.h
@@ -202,37 +202,6 @@ static inline void clear_in_cr4 (unsigne
 	write_cr4(cr4);
 }

-/*
- *      NSC/Cyrix CPU configuration register indexes
- */
-
-#define CX86_PCR0 0x20
-#define CX86_GCR  0xb8
-#define CX86_CCR0 0xc0
-#define CX86_CCR1 0xc1
-#define CX86_CCR2 0xc2
-#define CX86_CCR3 0xc3
-#define CX86_CCR4 0xe8
-#define CX86_CCR5 0xe9
-#define CX86_CCR6 0xea
-#define CX86_CCR7 0xeb
-#define CX86_PCR1 0xf0
-#define CX86_DIR0 0xfe
-#define CX86_DIR1 0xff
-#define CX86_ARR_BASE 0xc4
-#define CX86_RCR_BASE 0xdc
-
-/*
- *      NSC/Cyrix CPU indexed register access macros
- */
-
-#define getCx86(reg) ({ outb((reg), 0x22); inb(0x23); })
-
-#define setCx86(reg, data) do { \
-	outb((reg), 0x22); \
-	outb((data), 0x23); \
-} while (0)
-
 /* Stop speculative execution */
 static inline void sync_core(void)
 {
Index: linux-2.6.21/include/asm-i386/processor-cyrix.h
===================================================================
--- /dev/null
+++ linux-2.6.21/include/asm-i386/processor-cyrix.h
@@ -0,0 +1,35 @@
+/*
+ * NSC/Cyrix CPU configuration register indexes
+ */
+#define CX86_PCR0 0x20
+#define CX86_GCR  0xb8
+#define CX86_CCR0 0xc0
+#define CX86_CCR1 0xc1
+#define CX86_CCR2 0xc2
+#define CX86_CCR3 0xc3
+#define CX86_CCR4 0xe8
+#define CX86_CCR5 0xe9
+#define CX86_CCR6 0xea
+#define CX86_CCR7 0xeb
+#define CX86_PCR1 0xf0
+#define CX86_DIR0 0xfe
+#define CX86_DIR1 0xff
+#define CX86_ARR_BASE 0xc4
+#define CX86_RCR_BASE 0xdc
+
+/*
+ * NSC/Cyrix CPU indexed register access
+ */
+static inline u8 getCx86(u8 reg)
+{
+	outb(reg,0x22);
+	return inb(0x23);
+}
+
+static inline void setCx86(u8 reg, u8 data)
+{
+	outb(reg,0x22);
+	outb(data,0x23);
+}
+
+/* end of file processor-cyrix.h */
Index: linux-2.6.21/arch/i386/kernel/cpu/cyrix.c
===================================================================
--- linux-2.6.21.orig/arch/i386/kernel/cpu/cyrix.c
+++ linux-2.6.21/arch/i386/kernel/cpu/cyrix.c
@@ -4,7 +4,7 @@
 #include <linux/pci.h>
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/processor.h>
+#include <asm/processor-cyrix.h>
 #include <asm/timer.h>
 #include <asm/pci-direct.h>

Index: linux-2.6.21/arch/i386/kernel/cpu/mtrr/cyrix.c
===================================================================
--- linux-2.6.21.orig/arch/i386/kernel/cpu/mtrr/cyrix.c
+++ linux-2.6.21/arch/i386/kernel/cpu/mtrr/cyrix.c
@@ -3,6 +3,7 @@
 #include <asm/mtrr.h>
 #include <asm/msr.h>
 #include <asm/io.h>
+#include <asm/processor-cyrix.h>
 #include "mtrr.h"

 int arr3_protected;
