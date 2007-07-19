Return-Path: <linux-kernel-owner+w=401wt.eu-S938381AbXGSKg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938381AbXGSKg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938313AbXGSKZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:25:39 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:41522 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937667AbXGSKZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:25:37 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 1/1] i386: Geode's TSC is not neccessary to mark tu unstable
Date: Thu, 19 Jul 2007 12:25:25 +0200
User-Agent: KMail/1.9.4
Cc: Andres Salomon <dilinger@queued.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       TAKADA Yoshihito <takada@mbf.nifty.com>, linux-kernel@vger.kernel.org,
       Jordan Crouse <jordan.crouse@amd.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070715.210036.157242351.takada@mbf.nifty.com> <200707191052.50047.juergen127@kreuzholzen.de> <200707191125.47079.ak@suse.de>
In-Reply-To: <200707191125.47079.ak@suse.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_WwznG72eNyrzrHr"
Message-Id: <200707191225.26047.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_WwznG72eNyrzrHr
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Andi,

On Thursday 19 July 2007 11:25, Andi Kleen wrote:
> On Thursday 19 July 2007 10:52:48 Juergen Beisert wrote:
> > On Thursday 19 July 2007 10:22, Andi Kleen wrote:
> > > > Wow, that's a really cool bug; nice work!  Don't forget to update
> > > > arch/i386/kernel/cpu/mtrr/state.c, though; it uses setCx86() as well.
> > > >  It needs to include processor-cyrix.h.
> > >
> > > It also needs some big fat comments
> >
> > No problem. Where to add?
>
> Where the inlines are defined.
>
> Also can you please resubmit full patches with full description
> and Signed off lines, not incrementals? Thanks.

Find attached. Hope its ok now.

Juergen


--Boundary-00=_WwznG72eNyrzrHr
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

This is the 3rd version of this patch.

 - Adding missed arch/i386/kernel/cpu/mtrr/state.c
	Thanks to Andres Salomon
 - Adding some big fat comments into the new header file
 	Suggested by Andi Kleen

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
Index: arch/i386/kernel/cpu/mtrr/state.c
===================================================================
--- arch/i386/kernel/cpu/mtrr/state.c.orig
+++ arch/i386/kernel/cpu/mtrr/state.c
@@ -3,6 +3,7 @@
 #include <asm/io.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
+#include <asm/processor-cyrix.h>
 #include "mtrr.h"
 
 

--Boundary-00=_WwznG72eNyrzrHr--
