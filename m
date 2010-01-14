Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950Ab0ANAoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab0ANAoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 19:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505Ab0ANAoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 19:44:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:33196 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab0ANAn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 19:43:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,271,1262592000"; 
   d="scan'208";a="531106688"
Message-Id: <20100114002118.521826763@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 13 Jan 2010 16:19:11 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, ebiederm@xmission.com, yinghai@kernel.org, mingo@elte.hu,
       macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/2] x86, irq: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead of 0x1f
References: <20100114002118.436172066@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=use_vector_0x20_for_low_priority.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After talking to some more folks inside intel (Peter Anvin, Asit Mallick),
the safest option (for future compatibility etc) seen was to use vector 0x20
for IRQ_MOVE_CLEANUP_VECTOR instead of using vector 0x1f (which is documented as
reserved vector in the Intel IA32 manuals).

Also we don't need to reserve the entire privilege level (all 16 vectors in
the priority bucket that IRQ_MOVE_CLEANUP_VECTOR falls into), as the
x86 architecture (section 10.9.3 in SDM Vol3a) specifies that with in the
priority level, the higher the vector number the higher the priority.
And hence we don't need to reserve the complete priority level 0x20-0x2f for
the IRQ migration cleanup logic.

So change the IRQ_MOVE_CLEANUP_VECTOR to 0x20 and  allow 0x21-0x2f to be used
for device interrupts. 0x30-0x3f will be used for ISA interrupts (these
also can be migrated in the context of IOAPIC and hence need to be at a higher
priority level than IRQ_MOVE_CLEANUP_VECTOR).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
---
 arch/x86/include/asm/irq_vectors.h |   47 ++++++++++++-------------------------
 arch/x86/kernel/apic/io_apic.c     |    4 +--
 2 files changed, 18 insertions(+), 33 deletions(-)

Index: tip/arch/x86/include/asm/irq_vectors.h
===================================================================
--- tip.orig/arch/x86/include/asm/irq_vectors.h
+++ tip/arch/x86/include/asm/irq_vectors.h
@@ -28,19 +28,22 @@
 #define MCE_VECTOR			0x12
 
 /*
- * IDT vectors usable for external interrupt sources start
- * at 0x20:
- * hpa said we can start from 0x1f.
- *   0x1f is documented as reserved.  However, the ability for the APIC
- *   to generate vectors starting at 0x10 is documented, as is the
- *   ability for the CPU to receive any vector number as an interrupt.
- *   0x1f is used for IRQ_MOVE_CLEANUP_VECTOR since that vector needs
- *   an entire privilege level (16 vectors) all by itself at a higher
- *   priority than any actual device vector.  Thus, by placing it in the
- *   otherwise-unusable 0x10 privilege level, we avoid wasting a full
- *   16-vector block.
+ * IDT vectors usable for external interrupt sources start at 0x20.
+ * (0x80 is the syscall vector, 0x30-0x3f are for ISA)
  */
-#define FIRST_EXTERNAL_VECTOR		0x1f
+#define FIRST_EXTERNAL_VECTOR		0x20
+/*
+ * We start allocating at 0x21 to spread out vectors evenly between
+ * priority levels. (0x80 is the syscall vector)
+ */
+#define VECTOR_OFFSET_START		1
+
+/*
+ * Reserve the lowest usable vector (and hence lowest priority)  0x20 for
+ * triggering cleanup after irq migration. 0x21-0x2f will still be used
+ * for device interrupts.
+ */
+#define IRQ_MOVE_CLEANUP_VECTOR		FIRST_EXTERNAL_VECTOR
 
 #define IA32_SYSCALL_VECTOR		0x80
 #ifdef CONFIG_X86_32
@@ -48,17 +51,7 @@
 #endif
 
 /*
- * Reserve the lowest usable priority level 0x10 - 0x1f for triggering
- * cleanup after irq migration.
- * this overlaps with the reserved range for cpu exceptions so this
- * will need to be changed to 0x20 - 0x2f if the last cpu exception is
- * ever allocated.
- */
-
-#define IRQ_MOVE_CLEANUP_VECTOR		FIRST_EXTERNAL_VECTOR
-
-/*
- * Vectors 0x20-0x2f are used for ISA interrupts.
+ * Vectors 0x30-0x3f are used for ISA interrupts.
  *   round up to the next 16-vector boundary
  */
 #define IRQ0_VECTOR			((FIRST_EXTERNAL_VECTOR + 16) & ~15)
@@ -132,14 +125,6 @@
  */
 #define MCE_SELF_VECTOR			0xeb
 
-/*
- * First APIC vector available to drivers: (vectors 0x30-0xee).  We
- * start allocating at 0x31 to spread out vectors evenly between
- * priority levels. (0x80 is the syscall vector)
- */
-#define FIRST_DEVICE_VECTOR		(IRQ15_VECTOR + 1)
-#define VECTOR_OFFSET_START		1
-
 #define NR_VECTORS			 256
 
 #define FPU_IRQ				  13
Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -1162,7 +1162,7 @@ __assign_irq_vector(int irq, struct irq_
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	static int current_vector = FIRST_DEVICE_VECTOR + VECTOR_OFFSET_START;
+	static int current_vector = FIRST_EXTERNAL_VECTOR + VECTOR_OFFSET_START;
 	static int current_offset = VECTOR_OFFSET_START % 8;
 	unsigned int old_vector;
 	int cpu, err;
@@ -1199,7 +1199,7 @@ next:
 		if (vector >= first_system_vector) {
 			/* If out of vectors on large boxen, must share them. */
 			offset = (offset + 1) % 8;
-			vector = FIRST_DEVICE_VECTOR + offset;
+			vector = FIRST_EXTERNAL_VECTOR + offset;
 		}
 		if (unlikely(current_vector == vector))
 			continue;


