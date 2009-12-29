Return-Path: <linux-kernel-owner+w=401wt.eu-S1751493AbZL2FKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbZL2FKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 00:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbZL2FKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 00:10:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:36175 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZL2FKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 00:10:03 -0500
Message-ID: <4B398ECD.1080506@kernel.org>
Date: Mon, 28 Dec 2009 21:08:29 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -v2] x86: increase NR_IRQS and nr_irqs
References: <4B347AEE.6030705@kernel.org> <20091228094707.GH24690@elte.hu>
In-Reply-To: <20091228094707.GH24690@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



have a system with lots of igb and ixgbe, when iov/vf are enabled for
them, we hit the limit of 3064.

when system have 20 pcie installed, and one card have 2 functions, and one
function need 64 msi-x,
 may need 20 * 2 * 64 = 2560 for msi-x
but if iov and vf are enabled
 may need 20 * 2 * 64 * 3 = 7680 for msi-x
assume system with 5 ioapic, nr_irqs_gsi will be 120.
NR_CPUS = 512, and nr_cpu_ids = 128
will have NR_IRQS = 256 + 512 * 64 = 33024
will have nr_irqs = 120 + 8 * 128 + 120 * 64 = 8824

when SPARSE_IRQ is not set, there is no increase with data
when NR_CPUS=128, and SPARSE_IRQ is set
   text		   data	    bss		   dec		 hex	filename
21837444	4216564	12480736	38534744	24bfe58	vmlinux.before
21837442	4216580	12480736	38534758	24bfe66	vmlinux.after
when NR_CPUS=4096, and SPARSE_IRQ is set
   text		   data	    bss		   dec		 hex	filename
21878619	5610244	13415392	40904255	270263f	vmlinux.before
21878617	5610244	13415392	40904253	270263d	vmlinux.after

-v2: update comments to address Ingo's concern

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
+	nr += nr_irqs_gsi * 64;
 #endif
 	if (nr < nr_irqs)
 		nr_irqs = nr;
