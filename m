Return-Path: <linux-kernel-owner+w=401wt.eu-S936947AbXGTPfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936947AbXGTPfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935974AbXGTPdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:33:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:54401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935944AbXGTPdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:33:00 -0400
From: Andi Kleen <ak@suse.de>
References: <20070720532.949522000@suse.de>
In-Reply-To: <20070720532.949522000@suse.de>
To: juergen@kreuzholzen.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/11] x86: Replace NSC/Cyrix specific chipset access macros by inlined functions.
Message-Id: <20070720153253.D17F214E7B@wotan.suse.de>
Date: Fri, 20 Jul 2007 17:32:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Juergen Beisert <juergen@kreuzholzen.de>
With the macros a line like this fails (and does nothing):
	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
With inlined functions this line will work as expected.

Note about a side effect: Seems on Geode GX1 based systems the
"suspend on halt power saving feature" was never enabled due to this
wrong macro expansion. With inlined functions it will be enabled, but
this will stop the TSC when the CPU runs into a HLT instruction.
Kernel output something like this:
	Clocksource tsc unstable (delta = -472746897 ns)

This is the 3rd version of this patch.

 - Adding missed arch/i386/kernel/cpu/mtrr/state.c
	Thanks to Andres Salomon
 - Adding some big fat comments into the new header file
 	Suggested by Andi Kleen

AK: fixed x86-64 compilation

Signed-off-by: Juergen Beisert <juergen@kreuzholzen.de>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/cpufreq/gx-suspmod.c |    2 +-
 arch/i386/kernel/cpu/cyrix.c              |    2 +-
 arch/i386/kernel/cpu/mtrr/cyrix.c         |    1 +
 arch/i386/kernel/cpu/mtrr/state.c         |    1 +
 include/asm-i386/processor-cyrix.h        |   30 ++++++++++++++++++++++++++++++
 include/asm-i386/processor.h              |   11 -----------
 include/asm-x86_64/processor.h            |   11 -----------
 7 files changed, 34 insertions(+), 24 deletions(-)

Index: linux/include/asm-i386/processor.h
===================================================================
--- linux.orig/include/asm-i386/processor.h
+++ linux/include/asm-i386/processor.h
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
Index: linux/include/asm-i386/processor-cyrix.h
===================================================================
--- /dev/null
+++ linux/include/asm-i386/processor-cyrix.h
@@ -0,0 +1,30 @@
+/*
+ * NSC/Cyrix CPU indexed register access. Must be inlined instead of
+ * macros to ensure correct access ordering
+ * Access order is always 0x22 (=offset), 0x23 (=value)
+ *
+ * When using the old macros a line like
+ *   setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
+ * gets expanded to:
+ *  do {
+ *    outb((CX86_CCR2), 0x22);
+ *    outb((({
+ *        outb((CX86_CCR2), 0x22);
+ *        inb(0x23);
+ *    }) | 0x88), 0x23);
+ *  } while (0);
+ *
+ * which in fact violates the access order (= 0x22, 0x22, 0x23, 0x23).
+ */
+
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
Index: linux/arch/i386/kernel/cpu/cyrix.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/cyrix.c
+++ linux/arch/i386/kernel/cpu/cyrix.c
@@ -4,7 +4,7 @@
 #include <linux/pci.h>
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/processor.h>
+#include <asm/processor-cyrix.h>
 #include <asm/timer.h>
 #include <asm/pci-direct.h>
 #include <asm/tsc.h>
Index: linux/arch/i386/kernel/cpu/mtrr/cyrix.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/cyrix.c
+++ linux/arch/i386/kernel/cpu/mtrr/cyrix.c
@@ -3,6 +3,7 @@
 #include <asm/mtrr.h>
 #include <asm/msr.h>
 #include <asm/io.h>
+#include <asm/processor-cyrix.h>
 #include "mtrr.h"
 
 int arr3_protected;
Index: linux/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c
+++ linux/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c
@@ -79,7 +79,7 @@
 #include <linux/smp.h>
 #include <linux/cpufreq.h>
 #include <linux/pci.h>
-#include <asm/processor.h>
+#include <asm/processor-cyrix.h>
 #include <asm/errno.h>
 
 /* PCI config registers, all at F0 */
Index: linux/include/asm-x86_64/processor.h
===================================================================
--- linux.orig/include/asm-x86_64/processor.h
+++ linux/include/asm-x86_64/processor.h
@@ -389,17 +389,6 @@ static inline void prefetchw(void *x) 
 
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
Index: linux/arch/i386/kernel/cpu/mtrr/state.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/state.c
+++ linux/arch/i386/kernel/cpu/mtrr/state.c
@@ -3,6 +3,7 @@
 #include <asm/io.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
+#include <asm-i386/processor-cyrix.h>
 #include "mtrr.h"
 
 
