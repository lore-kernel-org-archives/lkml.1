Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbZLYIny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbZLYIny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 03:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZLYInx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 03:43:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:43648 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbZLYInx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 03:43:53 -0500
Message-ID: <4B347AEE.6030705@kernel.org>
Date: Fri, 25 Dec 2009 00:42:22 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: increase NR_IRQS and nr_irqs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



have a system with lots of igb and ixgbe, when iov/vf are enabled for
them, we hit the limit of 3064.

so try to increase NR_IRQS and nr_irqs to about 8000 and 6000.
for that system.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/irq_vectors.h |   12 ++++++------
 arch/x86/kernel/apic/io_apic.c     |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq_vectors.h
+++ linux-2.6/arch/x86/include/asm/irq_vectors.h
@@ -154,21 +154,21 @@ static inline int invalid_vm86_irq(int i
 
 #define NR_IRQS_LEGACY			  16
 
-#define CPU_VECTOR_LIMIT		(  8 * NR_CPUS      )
 #define IO_APIC_VECTOR_LIMIT		( 32 * MAX_IO_APICS )
 
 #ifdef CONFIG_X86_IO_APIC
 # ifdef CONFIG_SPARSE_IRQ
+#  define CPU_VECTOR_LIMIT		(64 * NR_CPUS)
 #  define NR_IRQS					\
 	(CPU_VECTOR_LIMIT > IO_APIC_VECTOR_LIMIT ?	\
 		(NR_VECTORS + CPU_VECTOR_LIMIT)  :	\
 		(NR_VECTORS + IO_APIC_VECTOR_LIMIT))
 # else
-#  if NR_CPUS < MAX_IO_APICS
-#   define NR_IRQS 			(NR_VECTORS + 4*CPU_VECTOR_LIMIT)
-#  else
-#   define NR_IRQS			(NR_VECTORS + IO_APIC_VECTOR_LIMIT)
-#  endif
+#  define CPU_VECTOR_LIMIT		(32 * NR_CPUS)
+#  define NR_IRQS					\
+	(CPU_VECTOR_LIMIT < IO_APIC_VECTOR_LIMIT ?	\
+		(NR_VECTORS + CPU_VECTOR_LIMIT)  :	\
+		(NR_VECTORS + IO_APIC_VECTOR_LIMIT))
 # endif
 #else /* !CONFIG_X86_IO_APIC: */
 # define NR_IRQS			NR_IRQS_LEGACY
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3840,7 +3840,7 @@ int __init arch_probe_nr_irqs(void)
 	/*
 	 * for MSI and HT dyn irq
 	 */
-	nr += nr_irqs_gsi * 16;
+	nr += nr_irqs_gsi * 48;
 #endif
 	if (nr < nr_irqs)
 		nr_irqs = nr;
