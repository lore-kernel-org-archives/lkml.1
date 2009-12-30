Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbZL3MW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbZL3MW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 07:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZL3MW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 07:22:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:42463 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbZL3MWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 07:22:55 -0500
Date: Wed, 30 Dec 2009 12:21:50 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B398ECD.1080506@kernel.org>
References: <4B398ECD.1080506@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Increase NR_IRQS and nr_irqs
Message-ID: <tip-9959c888a38b0f25b0e81a480f537d6489348442@git.kernel.org>
Git-Commit-ID: 9959c888a38b0f25b0e81a480f537d6489348442
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9959c888a38b0f25b0e81a480f537d6489348442
Gitweb:     http://git.kernel.org/tip/9959c888a38b0f25b0e81a480f537d6489348442
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 28 Dec 2009 21:08:29 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 30 Dec 2009 11:55:59 +0100

x86: Increase NR_IRQS and nr_irqs

I have a system with lots of igb and ixgbe, when iov/vf are
enabled for them, we hit the limit of 3064.

when system has 20 pcie installed, and one card has 2
functions, and one function needs 64 msi-x,
 may need 20 * 2 * 64 = 2560 for msi-x

but if iov and vf are enabled
 may need 20 * 2 * 64 * 3 = 7680 for msi-x
assume system with 5 ioapic, nr_irqs_gsi will be 120.

NR_CPUS = 512, and nr_cpu_ids = 128
will have NR_IRQS = 256 + 512 * 64 = 33024
will have nr_irqs = 120 + 8 * 128 + 120 * 64 = 8824

When SPARSE_IRQ is not set, there is no increase with kernel data
size.

when NR_CPUS=128, and SPARSE_IRQ is set:
   text		   data	    bss		   dec		 hex	filename
21837444	4216564	12480736	38534744	24bfe58	vmlinux.before
21837442	4216580	12480736	38534758	24bfe66	vmlinux.after
when NR_CPUS=4096, and SPARSE_IRQ is set
   text		   data	    bss		   dec		 hex	filename
21878619	5610244	13415392	40904255	270263f	vmlinux.before
21878617	5610244	13415392	40904253	270263d	vmlinux.after

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4B398ECD.1080506@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/irq_vectors.h |   12 ++++++------
 arch/x86/kernel/apic/io_apic.c     |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 4611f08..3ab43df 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -154,21 +154,21 @@ static inline int invalid_vm86_irq(int irq)
 
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
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index de00c46..d9cd1f1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3840,7 +3840,7 @@ int __init arch_probe_nr_irqs(void)
 	/*
 	 * for MSI and HT dyn irq
 	 */
-	nr += nr_irqs_gsi * 16;
+	nr += nr_irqs_gsi * 64;
 #endif
 	if (nr < nr_irqs)
 		nr_irqs = nr;
