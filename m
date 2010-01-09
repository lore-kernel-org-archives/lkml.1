Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140Ab0AICLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab0AICLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 21:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788Ab0AICLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 21:11:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:11225 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab0AICLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 21:11:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,246,1262592000"; 
   d="scan'208";a="585679614"
Subject: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR
 instead of 0x1f
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 08 Jan 2010 18:09:49 -0800
Message-Id: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead of 0x1f

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
---

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 585a428..708322a 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -28,19 +28,15 @@
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
  */
-#define FIRST_EXTERNAL_VECTOR		0x1f
+#define FIRST_EXTERNAL_VECTOR		0x20
+
+/*
+ * Reserve the lowest usable vector (and hence lowest priority)  0x20 for
+ * triggering cleanup after irq migration.
+ */
+#define IRQ_MOVE_CLEANUP_VECTOR		FIRST_EXTERNAL_VECTOR
 
 #define IA32_SYSCALL_VECTOR		0x80
 #ifdef CONFIG_X86_32
@@ -48,17 +44,7 @@
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
@@ -80,6 +66,12 @@
 #define IRQ15_VECTOR			(IRQ0_VECTOR + 15)
 
 /*
+ * First APIC vector available to drivers: (vectors 0x21-0xee).
+ * (0x80 is the syscall vector, 0x30-0x3f are for ISA)
+ */
+#define FIRST_DEVICE_VECTOR		(FIRST_EXTERNAL_VECTOR + 1)
+
+/*
  * Special IRQ vectors used by the SMP architecture, 0xf0-0xff
  *
  *  some of the following vectors are 'rare', they are merged
@@ -132,14 +124,6 @@
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
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d5bfa29..5c090a1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1162,8 +1162,8 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	static int current_vector = FIRST_DEVICE_VECTOR + VECTOR_OFFSET_START;
-	static int current_offset = VECTOR_OFFSET_START % 8;
+	static int current_vector = FIRST_DEVICE_VECTOR;
+	static int current_offset = 0;
 	unsigned int old_vector;
 	int cpu, err;
 	cpumask_var_t tmp_mask;


