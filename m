Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbXGOTGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbXGOTGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 15:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbXGOTGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:06:32 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:58211 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbXGOTGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:06:31 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: TAKADA Yoshihito <takada@mbf.nifty.com>
Subject: Re: [PATCH 1/1] i386: Geode's TSC is not neccessary to mark tu unstable
Date: Sun, 15 Jul 2007 21:06:27 +0200
User-Agent: KMail/1.9.4
Cc: linux-kernel@vger.kernel.org
References: <20070715.210036.157242351.takada@mbf.nifty.com>
In-Reply-To: <20070715.210036.157242351.takada@mbf.nifty.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_0AnmG3DNvLuvnng"
Message-Id: <200707152106.28437.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_0AnmG3DNvLuvnng
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

On Sunday 15 July 2007 14:00, TAKADA Yoshihito wrote:
> Hi. I reported to remove pit_latch_buggy(http://lkml.org/lkml/2007/2/10/8).
> In the report, I stated that TSC was unstable.
> When I installed 2.6.21, GeodeGX's TSC is stable.

GeodeGX1's TSC is stable until you activate halt/suspend feature. In 
arch/i386/kernel/cpu/cyrix.c:geode_configure() it will be activated by 
default. But due to a macro failure the line
  setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
does nothing.
Replace the setCx86/getCx86 macros by the attached patch, and the TSC will be 
unstable again!

So it makes sense to mark the TSC unstable if the halt/suspend feature is 
activated.

Juergen

--Boundary-00=_0AnmG3DNvLuvnng
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="setup_correct_chipset_access_functions.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="setup_correct_chipset_access_functions.patch"

From: Juergen Beisert <juergen@kreuzholzen.de>

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
@@ -0,0 +1,20 @@
+#ifndef __ASM_I386_PROCESSOR_CYRIX_H
+#define __ASM_I386_PROCESSOR_CYRIX
+
+#include <asm/processor-flags.h>
+/*
+ * NSC/Cyrix CPU indexed register access
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
+
+#endif
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

--Boundary-00=_0AnmG3DNvLuvnng--
