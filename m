Return-Path: <linux-kernel-owner+w=401wt.eu-S1763797AbXGJJE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763797AbXGJJE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762644AbXGJJED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:04:03 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:41148 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761667AbXGJJEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:04:00 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] [2.6.22] CPU/GEODE: Replace NSC/Cyrix specific chipset access macros by inlined functions
Date: Tue, 10 Jul 2007 11:03:56 +0200
User-Agent: KMail/1.9.4
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707101103.57233.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juergen Beisert <juergen@kreuzholzen.de>

2nd try to include it into mainline.

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

Signed-off-by: Juergen Beisert <juergen@kreuzholzen.de>

Index: include/asm-i386/processor.h
===================================================================
--- include/asm-i386/processor.h.orig
+++ include/asm-i386/processor.h
@@ -168,17 +168,6 @@ static inline void clear_in_cr4 (unsigne
 	write_cr4(cr4);
 }

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
Index: include/asm-i386/processor-cyrix.h
===================================================================
--- /dev/null
+++ include/asm-i386/processor-cyrix.h
@@ -0,0 +1,15 @@
+/*
+ * NSC/Cyrix CPU indexed register access. Must be inlined instead of
+ * macros to ensure correct access ordering
+ */
+static inline u8 getCx86(u8 reg)
+{
+	outb(reg, 0x22);
+	return inb(0x23);
+}
+
+static inline void setCx86(u8 reg, u8 data)
+{
+	outb(reg, 0x22);
+	outb(data, 0x23);
+}
Index: arch/i386/kernel/cpu/cyrix.c
===================================================================
--- arch/i386/kernel/cpu/cyrix.c.orig
+++ arch/i386/kernel/cpu/cyrix.c
@@ -4,7 +4,7 @@
 #include <linux/pci.h>
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/processor.h>
+#include <asm/processor-cyrix.h>
 #include <asm/timer.h>
 #include <asm/pci-direct.h>
 #include <asm/tsc.h>
Index: arch/i386/kernel/cpu/mtrr/cyrix.c
===================================================================
--- arch/i386/kernel/cpu/mtrr/cyrix.c.orig
+++ arch/i386/kernel/cpu/mtrr/cyrix.c
@@ -3,6 +3,7 @@
 #include <asm/mtrr.h>
 #include <asm/msr.h>
 #include <asm/io.h>
+#include <asm/processor-cyrix.h>
 #include "mtrr.h"

 int arr3_protected;
Index: arch/i386/kernel/cpu/cpufreq/gx-suspmod.c
===================================================================
--- arch/i386/kernel/cpu/cpufreq/gx-suspmod.c.orig
+++ arch/i386/kernel/cpu/cpufreq/gx-suspmod.c
@@ -79,7 +79,7 @@
 #include <linux/smp.h>
 #include <linux/cpufreq.h>
 #include <linux/pci.h>
-#include <asm/processor.h>
+#include <asm/processor-cyrix.h>
 #include <asm/errno.h>

 /* PCI config registers, all at F0 */
Index: include/asm-x86_64/processor.h
===================================================================
--- include/asm-x86_64/processor.h.orig
+++ include/asm-x86_64/processor.h
@@ -391,17 +391,6 @@ static inline void prefetchw(void *x)

 #define cpu_relax()   rep_nop()

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
 static inline void serialize_cpu(void)
 {
 	__asm__ __volatile__ ("cpuid" : : : "ax", "bx", "cx", "dx");
