Return-Path: <linux-kernel-owner+w=401wt.eu-S1423496AbXBPJx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423496AbXBPJx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966280AbXBPJx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:53:57 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53093 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966278AbXBPJxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:53:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: Andi Kleen <ak@suse.de>,
       Natalie Protasevich <Natalie.Protasevich@unisys.com>,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: [PATCH] i386 irq: Kill NR_IRQ_VECTORS and increase NR_IRQS
References: <200702160015.04453.lenb@kernel.org>
Date: Fri, 16 Feb 2007 02:51:49 -0700
In-Reply-To: <200702160015.04453.lenb@kernel.org> (Len Brown's message of
	"Fri, 16 Feb 2007 00:15:04 -0500")
Message-ID: <m1mz3efn0q.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Due to hardware and software implementation limits the i386 kernel can
only use 224 or so different IRQs at one time.  However except for
actually having the irqs delivered there are no limits except the
arbitrary number NR_IRQS on how many irqs we can talk about and deal
with.

Frequently not all io_apics inputs are connected to interrupt traces
going to real devices, and since even when they are devices don't
always use all of interrupt traces routed to them.  So it makes sense
to be able to talk about many more irq sources then we can actually
use.

So this patch consolidates NR_IRQS and NR_IRQ_VECTORS into just
NR_IRQS and raises NR_IRQS where appropriate above the number of irqs
we can use at one time. 

Allowing the kernel to work on big machines without complicated
and error prone irq remapping logic.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/kernel/acpi/boot.c                       |    4 ++--
 arch/i386/kernel/io_apic.c                         |    6 +++---
 include/asm-i386/mach-default/irq_vectors_limits.h |    8 +++-----
 include/asm-i386/mach-generic/irq_vectors_limits.h |    3 +--
 include/asm-i386/mach-summit/irq_vectors_limits.h  |    3 +--
 include/asm-i386/mach-visws/irq_vectors.h          |    1 -
 include/asm-i386/mach-voyager/irq_vectors.h        |    1 -
 7 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/i386/kernel/acpi/boot.c b/arch/i386/kernel/acpi/boot.c
index e94aff6..4375abd 100644
--- a/arch/i386/kernel/acpi/boot.c
+++ b/arch/i386/kernel/acpi/boot.c
@@ -826,7 +826,7 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 
 	count =
 	    acpi_table_parse_madt(ACPI_MADT_TYPE_INTERRUPT_OVERRIDE, acpi_parse_int_src_ovr,
-				  NR_IRQ_VECTORS);
+				  NR_IRQS);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX
 		       "Error parsing interrupt source overrides entry\n");
@@ -846,7 +846,7 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 
 	count =
 	    acpi_table_parse_madt(ACPI_MADT_TYPE_NMI_SOURCE, acpi_parse_nmi_src,
-				  NR_IRQ_VECTORS);
+				  NR_IRQS);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX "Error parsing NMI SRC entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
diff --git a/arch/i386/kernel/io_apic.c b/arch/i386/kernel/io_apic.c
index e3e5940..92cc604 100644
--- a/arch/i386/kernel/io_apic.c
+++ b/arch/i386/kernel/io_apic.c
@@ -1223,14 +1223,14 @@ static inline int IO_APIC_irq_trigger(int irq)
 }
 
 /* irq_vectors is indexed by the sum of all RTEs in all I/O APICs. */
-static u8 irq_vector[NR_IRQ_VECTORS] __read_mostly = { FIRST_DEVICE_VECTOR , 0 };
+static u8 irq_vector[NR_IRQS] __read_mostly = { FIRST_DEVICE_VECTOR , 0 };
 
 static int __assign_irq_vector(int irq)
 {
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
 	int vector, offset, i;
 
-	BUG_ON((unsigned)irq >= NR_IRQ_VECTORS);
+	BUG_ON((unsigned)irq >= NR_IRQS);
 
 	if (irq_vector[irq] > 0)
 		return irq_vector[irq];
@@ -1247,7 +1247,7 @@ next:
 		return -ENOSPC;
 	if (vector == SYSCALL_VECTOR)
 		goto next;
-	for (i = 0; i < NR_IRQ_VECTORS; i++)
+	for (i = 0; i < NR_IRQS; i++)
 		if (irq_vector[i] == vector)
 			goto next;
 
diff --git a/include/asm-i386/mach-default/irq_vectors_limits.h b/include/asm-i386/mach-default/irq_vectors_limits.h
index 7f161e7..ad4e05c 100644
--- a/include/asm-i386/mach-default/irq_vectors_limits.h
+++ b/include/asm-i386/mach-default/irq_vectors_limits.h
@@ -2,15 +2,13 @@
 #define _ASM_IRQ_VECTORS_LIMITS_H
 
 #ifdef CONFIG_X86_IO_APIC
-#define NR_IRQS 224
-# if (224 >= 32 * NR_CPUS)
-# define NR_IRQ_VECTORS NR_IRQS
+# if (200 >= 32 * NR_CPUS)
+#  define NR_IRQS 200
 # else
-# define NR_IRQ_VECTORS (32 * NR_CPUS)
+#  define NR_IRQS (32 * NR_CPUS)
 # endif
 #else
 #define NR_IRQS 16
-#define NR_IRQ_VECTORS NR_IRQS
 #endif
 
 #endif /* _ASM_IRQ_VECTORS_LIMITS_H */
diff --git a/include/asm-i386/mach-generic/irq_vectors_limits.h b/include/asm-i386/mach-generic/irq_vectors_limits.h
index 890ce3f..f16f727 100644
--- a/include/asm-i386/mach-generic/irq_vectors_limits.h
+++ b/include/asm-i386/mach-generic/irq_vectors_limits.h
@@ -8,7 +8,6 @@
  * This value should be the same in both the generic and summit subarches.
  * Change one, change 'em both.
  */
-#define NR_IRQS	224
-#define NR_IRQ_VECTORS	1024
+#define NR_IRQS	1024
 
 #endif /* _ASM_IRQ_VECTORS_LIMITS_H */
diff --git a/include/asm-i386/mach-summit/irq_vectors_limits.h b/include/asm-i386/mach-summit/irq_vectors_limits.h
index 890ce3f..f16f727 100644
--- a/include/asm-i386/mach-summit/irq_vectors_limits.h
+++ b/include/asm-i386/mach-summit/irq_vectors_limits.h
@@ -8,7 +8,6 @@
  * This value should be the same in both the generic and summit subarches.
  * Change one, change 'em both.
  */
-#define NR_IRQS	224
-#define NR_IRQ_VECTORS	1024
+#define NR_IRQS	1024
 
 #endif /* _ASM_IRQ_VECTORS_LIMITS_H */
diff --git a/include/asm-i386/mach-visws/irq_vectors.h b/include/asm-i386/mach-visws/irq_vectors.h
index cb572d8..c32ebdf 100644
--- a/include/asm-i386/mach-visws/irq_vectors.h
+++ b/include/asm-i386/mach-visws/irq_vectors.h
@@ -51,7 +51,6 @@
  */
 #define NR_VECTORS 256
 #define NR_IRQS 224
-#define NR_IRQ_VECTORS NR_IRQS
 
 #define FPU_IRQ			13
 
diff --git a/include/asm-i386/mach-voyager/irq_vectors.h b/include/asm-i386/mach-voyager/irq_vectors.h
index 165421f..abaf5cf 100644
--- a/include/asm-i386/mach-voyager/irq_vectors.h
+++ b/include/asm-i386/mach-voyager/irq_vectors.h
@@ -57,7 +57,6 @@
 
 #define NR_VECTORS 256
 #define NR_IRQS 224
-#define NR_IRQ_VECTORS NR_IRQS
 
 #define FPU_IRQ				13
 
-- 
1.4.4.1.g278f

