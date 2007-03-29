Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbXC2LH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbXC2LH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 07:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbXC2LH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 07:07:28 -0400
Received: from ozlabs.org ([203.10.76.45]:53840 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbXC2LH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 07:07:27 -0400
Subject: Re: [PATCH] ignore vgacon if hardware not present
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Gerd Hoffmann <kraxel@suse.de>, Alan <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070329103602.GB52274@muc.de>
References: <1175154408.12230.195.camel@localhost.localdomain>
	 <20070329103602.GB52274@muc.de>
Content-Type: text/plain
Date: Thu, 29 Mar 2007 21:06:57 +1000
Message-Id: <1175166417.12230.206.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-29 at 12:36 +0200, Andi Kleen wrote:
> On Thu, Mar 29, 2007 at 05:46:48PM +1000, Rusty Russell wrote:
> > (Did this fall through the cracks?  I don't see it in -mm.  It's
> > standalone, and saves some silly code in lguest and presumably others).
> 
> Normally it should go to some some console maintainer? 

Hmm, but who?

> Ok I can add it.

Thanks.  While you're in a patch-applying mood, how about this?

Cheers,
Rusty.
==
Use X86_EFLAGS_IF in irqflags.h.

Move X86_EFLAGS_IF et al out to a new header: processor-flags.h, so we
can include it from irqflags.h and use it in raw_irqs_disabled_flags().

As a side-effect, we could now use these flags in .S files.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

---
 include/asm-i386/irqflags.h        |    3 ++-
 include/asm-i386/processor-flags.h |   26 ++++++++++++++++++++++++++
 include/asm-i386/processor.h       |   22 +---------------------
 3 files changed, 29 insertions(+), 22 deletions(-)

===================================================================
--- /dev/null
+++ b/include/asm-i386/processor-flags.h
@@ -0,0 +1,26 @@
+#ifndef __ASM_I386_PROCESSOR_FLAGS_H
+#define __ASM_I386_PROCESSOR_FLAGS_H
+/* Various flags defined: can be included from assembler. */
+
+/*
+ * EFLAGS bits
+ */
+#define X86_EFLAGS_CF	0x00000001 /* Carry Flag */
+#define X86_EFLAGS_PF	0x00000004 /* Parity Flag */
+#define X86_EFLAGS_AF	0x00000010 /* Auxillary carry Flag */
+#define X86_EFLAGS_ZF	0x00000040 /* Zero Flag */
+#define X86_EFLAGS_SF	0x00000080 /* Sign Flag */
+#define X86_EFLAGS_TF	0x00000100 /* Trap Flag */
+#define X86_EFLAGS_IF	0x00000200 /* Interrupt Flag */
+#define X86_EFLAGS_DF	0x00000400 /* Direction Flag */
+#define X86_EFLAGS_OF	0x00000800 /* Overflow Flag */
+#define X86_EFLAGS_IOPL	0x00003000 /* IOPL mask */
+#define X86_EFLAGS_NT	0x00004000 /* Nested Task */
+#define X86_EFLAGS_RF	0x00010000 /* Resume Flag */
+#define X86_EFLAGS_VM	0x00020000 /* Virtual Mode */
+#define X86_EFLAGS_AC	0x00040000 /* Alignment Check */
+#define X86_EFLAGS_VIF	0x00080000 /* Virtual Interrupt Flag */
+#define X86_EFLAGS_VIP	0x00100000 /* Virtual Interrupt Pending */
+#define X86_EFLAGS_ID	0x00200000 /* CPUID detection flag */
+
+#endif	/* __ASM_I386_PROCESSOR_FLAGS_H */
===================================================================
--- a/include/asm-i386/irqflags.h
+++ b/include/asm-i386/irqflags.h
@@ -9,6 +9,7 @@
  */
 #ifndef _ASM_IRQFLAGS_H
 #define _ASM_IRQFLAGS_H
+#include <asm/processor-flags.h>
 
 #ifndef __ASSEMBLY__
 static inline unsigned long native_save_fl(void)
@@ -119,7 +120,7 @@ static inline unsigned long __raw_local_
 
 static inline int raw_irqs_disabled_flags(unsigned long flags)
 {
-	return !(flags & (1 << 9));
+	return !(flags & X86_EFLAGS_IF);
 }
 
 static inline int raw_irqs_disabled(void)
===================================================================
--- a/include/asm-i386/processor.h
+++ b/include/asm-i386/processor.h
@@ -21,6 +21,7 @@
 #include <asm/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/init.h>
+#include <asm/processor-flags.h>
 
 /* flag for disabling the tsc */
 extern int tsc_disable;
@@ -125,27 +126,6 @@ extern void detect_ht(struct cpuinfo_x86
 #else
 static inline void detect_ht(struct cpuinfo_x86 *c) {}
 #endif
-
-/*
- * EFLAGS bits
- */
-#define X86_EFLAGS_CF	0x00000001 /* Carry Flag */
-#define X86_EFLAGS_PF	0x00000004 /* Parity Flag */
-#define X86_EFLAGS_AF	0x00000010 /* Auxillary carry Flag */
-#define X86_EFLAGS_ZF	0x00000040 /* Zero Flag */
-#define X86_EFLAGS_SF	0x00000080 /* Sign Flag */
-#define X86_EFLAGS_TF	0x00000100 /* Trap Flag */
-#define X86_EFLAGS_IF	0x00000200 /* Interrupt Flag */
-#define X86_EFLAGS_DF	0x00000400 /* Direction Flag */
-#define X86_EFLAGS_OF	0x00000800 /* Overflow Flag */
-#define X86_EFLAGS_IOPL	0x00003000 /* IOPL mask */
-#define X86_EFLAGS_NT	0x00004000 /* Nested Task */
-#define X86_EFLAGS_RF	0x00010000 /* Resume Flag */
-#define X86_EFLAGS_VM	0x00020000 /* Virtual Mode */
-#define X86_EFLAGS_AC	0x00040000 /* Alignment Check */
-#define X86_EFLAGS_VIF	0x00080000 /* Virtual Interrupt Flag */
-#define X86_EFLAGS_VIP	0x00100000 /* Virtual Interrupt Pending */
-#define X86_EFLAGS_ID	0x00200000 /* CPUID detection flag */
 
 static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 					 unsigned int *ecx, unsigned int *edx)


