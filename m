Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbZA3Dcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbZA3Dcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 22:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZA3Dco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 22:32:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:46770 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbZA3Dcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 22:32:43 -0500
Message-ID: <498274A5.8010805@kernel.org>
Date: Thu, 29 Jan 2009 19:31:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: seperate default_send_IPI_mask_sequence/allbutself with
 logical
References: <49827414.2020908@kernel.org>
In-Reply-To: <49827414.2020908@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: 32bit should logical version

there are two version: for default_send_IPI_mask_sequence/allbutself
one in ipi.h and one in ipi.c for 32bit

it seems .h version overwrite ipi.c for a while.

restore it so 32 bit could use it's old logical version.
also remove dupicated functions in .c

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/ipi.h        |   71 ++++++++++++++++---
 arch/x86/kernel/bigsmp_32.c       |    8 --
 arch/x86/kernel/es7000_32.c       |    4 -
 arch/x86/kernel/genapic_flat_64.c |    6 -
 arch/x86/kernel/ipi.c             |  139 --------------------------------------
 arch/x86/kernel/numaq_32.c        |    8 --
 arch/x86/kernel/probe_32.c        |    4 -
 arch/x86/kernel/summit_32.c       |    6 -
 8 files changed, 77 insertions(+), 169 deletions(-)

Index: linux-2.6/arch/x86/include/asm/ipi.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/ipi.h
+++ linux-2.6/arch/x86/include/asm/ipi.h
@@ -120,7 +120,7 @@ static inline void
 }
 
 static inline void
-default_send_IPI_mask_sequence(const struct cpumask *mask, int vector)
+default_send_IPI_mask_sequence_phys(const struct cpumask *mask, int vector)
 {
 	unsigned long query_cpu;
 	unsigned long flags;
@@ -139,7 +139,7 @@ default_send_IPI_mask_sequence(const str
 }
 
 static inline void
-default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
+default_send_IPI_mask_allbutself_phys(const struct cpumask *mask, int vector)
 {
 	unsigned int this_cpu = smp_processor_id();
 	unsigned int query_cpu;
@@ -157,23 +157,72 @@ default_send_IPI_mask_allbutself(const s
 	local_irq_restore(flags);
 }
 
+#include <asm/genapic.h>
+
+static inline void
+default_send_IPI_mask_sequence_logical(const struct cpumask *mask, int vector)
+{
+	unsigned long flags;
+	unsigned int query_cpu;
+
+	/*
+	 * Hack. The clustered APIC addressing mode doesn't allow us to send
+	 * to an arbitrary mask, so I do a unicasts to each CPU instead. This
+	 * should be modified to do 1 message per cluster ID - mbligh
+	 */
+
+	local_irq_save(flags);
+	for_each_cpu(query_cpu, mask)
+		__default_send_IPI_dest_field(
+			apic->cpu_to_logical_apicid(query_cpu), vector,
+			apic->dest_logical);
+	local_irq_restore(flags);
+}
+
+static inline void
+default_send_IPI_mask_allbutself_logical(const struct cpumask *mask, int vector)
+{
+	unsigned long flags;
+	unsigned int query_cpu;
+	unsigned int this_cpu = smp_processor_id();
+
+	/* See Hack comment above */
+
+	local_irq_save(flags);
+	for_each_cpu(query_cpu, mask) {
+		if (query_cpu == this_cpu)
+			continue;
+		__default_send_IPI_dest_field(
+			apic->cpu_to_logical_apicid(query_cpu), vector,
+			apic->dest_logical);
+		}
+	local_irq_restore(flags);
+}
 
 /* Avoid include hell */
 #define NMI_VECTOR 0x02
 
-void default_send_IPI_mask_bitmask(const struct cpumask *mask, int vector);
-void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
-
 extern int no_broadcast;
 
-#ifdef CONFIG_X86_64
-#include <asm/genapic.h>
-#else
-static inline void default_send_IPI_mask(const struct cpumask *mask, int vector)
+#ifndef CONFIG_X86_64
+/*
+ * This is only used on smaller machines.
+ */
+static inline void default_send_IPI_mask_bitmask_logical(const struct cpumask *cpumask, int vector)
+{
+	unsigned long mask = cpumask_bits(cpumask)[0];
+	unsigned long flags;
+
+	local_irq_save(flags);
+	WARN_ON(mask & ~cpumask_bits(cpu_online_mask)[0]);
+	__default_send_IPI_dest_field(mask, vector, apic->dest_logical);
+	local_irq_restore(flags);
+}
+
+static inline void default_send_IPI_mask_logical(const struct cpumask *mask, int vector)
 {
-	default_send_IPI_mask_bitmask(mask, vector);
+	default_send_IPI_mask_bitmask_logical(mask, vector);
 }
-void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
 #endif
 
 static inline void __default_local_send_IPI_allbutself(int vector)
Index: linux-2.6/arch/x86/kernel/bigsmp_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/bigsmp_32.c
+++ linux-2.6/arch/x86/kernel/bigsmp_32.c
@@ -9,6 +9,7 @@
 #include <asm/genapic.h>
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
+#include <asm/ipi.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
@@ -154,17 +155,14 @@ static inline int bigsmp_phys_pkg_id(int
 	return cpuid_apic >> index_msb;
 }
 
-void default_send_IPI_mask_sequence(const struct cpumask *mask, int vector);
-void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
-
 static inline void bigsmp_send_IPI_mask(const struct cpumask *mask, int vector)
 {
-	default_send_IPI_mask_sequence(mask, vector);
+	default_send_IPI_mask_sequence_phys(mask, vector);
 }
 
 static inline void bigsmp_send_IPI_allbutself(int vector)
 {
-	default_send_IPI_mask_allbutself(cpu_online_mask, vector);
+	default_send_IPI_mask_allbutself_phys(cpu_online_mask, vector);
 }
 
 static inline void bigsmp_send_IPI_all(int vector)
Index: linux-2.6/arch/x86/kernel/es7000_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/es7000_32.c
+++ linux-2.6/arch/x86/kernel/es7000_32.c
@@ -451,12 +451,12 @@ static int es7000_check_dsdt(void)
 
 static void es7000_send_IPI_mask(const struct cpumask *mask, int vector)
 {
-	default_send_IPI_mask_sequence(mask, vector);
+	default_send_IPI_mask_sequence_phys(mask, vector);
 }
 
 static void es7000_send_IPI_allbutself(int vector)
 {
-	default_send_IPI_mask_allbutself(cpu_online_mask, vector);
+	default_send_IPI_mask_allbutself_phys(cpu_online_mask, vector);
 }
 
 static void es7000_send_IPI_all(int vector)
Index: linux-2.6/arch/x86/kernel/genapic_flat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6/arch/x86/kernel/genapic_flat_64.c
@@ -267,18 +267,18 @@ static void physflat_vector_allocation_d
 
 static void physflat_send_IPI_mask(const struct cpumask *cpumask, int vector)
 {
-	default_send_IPI_mask_sequence(cpumask, vector);
+	default_send_IPI_mask_sequence_phys(cpumask, vector);
 }
 
 static void physflat_send_IPI_mask_allbutself(const struct cpumask *cpumask,
 					      int vector)
 {
-	default_send_IPI_mask_allbutself(cpumask, vector);
+	default_send_IPI_mask_allbutself_phys(cpumask, vector);
 }
 
 static void physflat_send_IPI_allbutself(int vector)
 {
-	default_send_IPI_mask_allbutself(cpu_online_mask, vector);
+	default_send_IPI_mask_allbutself_phys(cpu_online_mask, vector);
 }
 
 static void physflat_send_IPI_all(int vector)
Index: linux-2.6/arch/x86/kernel/ipi.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/ipi.c
+++ linux-2.6/arch/x86/kernel/ipi.c
@@ -17,148 +17,13 @@
 #include <asm/mmu_context.h>
 #include <asm/apic.h>
 #include <asm/proto.h>
+#include <asm/ipi.h>
 
 #ifdef CONFIG_X86_32
-#include <asm/genapic.h>
-
-/*
- * the following functions deal with sending IPIs between CPUs.
- *
- * We use 'broadcast', CPU->CPU IPIs and self-IPIs too.
- */
-
-static inline int __prepare_ICR(unsigned int shortcut, int vector)
-{
-	unsigned int icr = shortcut | apic->dest_logical;
-
-	switch (vector) {
-	default:
-		icr |= APIC_DM_FIXED | vector;
-		break;
-	case NMI_VECTOR:
-		icr |= APIC_DM_NMI;
-		break;
-	}
-	return icr;
-}
-
-static inline int __prepare_ICR2(unsigned int mask)
-{
-	return SET_APIC_DEST_FIELD(mask);
-}
-
-void __default_send_IPI_shortcut(unsigned int shortcut, int vector)
-{
-	/*
-	 * Subtle. In the case of the 'never do double writes' workaround
-	 * we have to lock out interrupts to be safe.  As we don't care
-	 * of the value read we use an atomic rmw access to avoid costly
-	 * cli/sti.  Otherwise we use an even cheaper single atomic write
-	 * to the APIC.
-	 */
-	unsigned int cfg;
-
-	/*
-	 * Wait for idle.
-	 */
-	apic_wait_icr_idle();
-
-	/*
-	 * No need to touch the target chip field
-	 */
-	cfg = __prepare_ICR(shortcut, vector);
-
-	/*
-	 * Send the IPI. The write to APIC_ICR fires this off.
-	 */
-	apic_write(APIC_ICR, cfg);
-}
 
 void default_send_IPI_self(int vector)
 {
-	__default_send_IPI_shortcut(APIC_DEST_SELF, vector);
-}
-
-/*
- * This is used to send an IPI with no shorthand notation (the destination is
- * specified in bits 56 to 63 of the ICR).
- */
-static inline void __default_send_IPI_dest_field(unsigned long mask, int vector)
-{
-	unsigned long cfg;
-
-	/*
-	 * Wait for idle.
-	 */
-	if (unlikely(vector == NMI_VECTOR))
-		safe_apic_wait_icr_idle();
-	else
-		apic_wait_icr_idle();
-
-	/*
-	 * prepare target chip field
-	 */
-	cfg = __prepare_ICR2(mask);
-	apic_write(APIC_ICR2, cfg);
-
-	/*
-	 * program the ICR
-	 */
-	cfg = __prepare_ICR(0, vector);
-
-	/*
-	 * Send the IPI. The write to APIC_ICR fires this off.
-	 */
-	apic_write(APIC_ICR, cfg);
-}
-
-/*
- * This is only used on smaller machines.
- */
-void default_send_IPI_mask_bitmask(const struct cpumask *cpumask, int vector)
-{
-	unsigned long mask = cpumask_bits(cpumask)[0];
-	unsigned long flags;
-
-	local_irq_save(flags);
-	WARN_ON(mask & ~cpumask_bits(cpu_online_mask)[0]);
-	__default_send_IPI_dest_field(mask, vector);
-	local_irq_restore(flags);
-}
-
-void default_send_IPI_mask_sequence(const struct cpumask *mask, int vector)
-{
-	unsigned long flags;
-	unsigned int query_cpu;
-
-	/*
-	 * Hack. The clustered APIC addressing mode doesn't allow us to send
-	 * to an arbitrary mask, so I do a unicasts to each CPU instead. This
-	 * should be modified to do 1 message per cluster ID - mbligh
-	 */
-
-	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask)
-		__default_send_IPI_dest_field(apic->cpu_to_logical_apicid(query_cpu), vector);
-	local_irq_restore(flags);
-}
-
-void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
-{
-	unsigned long flags;
-	unsigned int query_cpu;
-	unsigned int this_cpu = smp_processor_id();
-
-	/* See Hack comment above */
-
-	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask) {
-		if (query_cpu == this_cpu)
-			continue;
-		__default_send_IPI_dest_field(
-			apic->cpu_to_logical_apicid(query_cpu), vector);
-	}
-	local_irq_restore(flags);
+	__default_send_IPI_shortcut(APIC_DEST_SELF, vector, apic->dest_logical);
 }
 
 /* must come after the send_IPI functions above for inlining */
Index: linux-2.6/arch/x86/kernel/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/numaq_32.c
+++ linux-2.6/arch/x86/kernel/numaq_32.c
@@ -302,6 +302,7 @@ int __init get_memcfg_numaq(void)
 #include <asm/genapic.h>
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
+#include <asm/ipi.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/init.h>
@@ -319,17 +320,14 @@ static inline unsigned int numaq_get_api
 	return (x >> 24) & 0x0F;
 }
 
-void default_send_IPI_mask_sequence(const struct cpumask *mask, int vector);
-void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
-
 static inline void numaq_send_IPI_mask(const struct cpumask *mask, int vector)
 {
-	default_send_IPI_mask_sequence(mask, vector);
+	default_send_IPI_mask_sequence_logical(mask, vector);
 }
 
 static inline void numaq_send_IPI_allbutself(int vector)
 {
-	default_send_IPI_mask_allbutself(cpu_online_mask, vector);
+	default_send_IPI_mask_allbutself_logical(cpu_online_mask, vector);
 }
 
 static inline void numaq_send_IPI_all(int vector)
Index: linux-2.6/arch/x86/kernel/probe_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/probe_32.c
+++ linux-2.6/arch/x86/kernel/probe_32.c
@@ -112,8 +112,8 @@ struct genapic apic_default = {
 	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
 
-	.send_IPI_mask			= default_send_IPI_mask,
-	.send_IPI_mask_allbutself	= default_send_IPI_mask_allbutself,
+	.send_IPI_mask			= default_send_IPI_mask_logical,
+	.send_IPI_mask_allbutself	= default_send_IPI_mask_allbutself_logical,
 	.send_IPI_allbutself		= default_send_IPI_allbutself,
 	.send_IPI_all			= default_send_IPI_all,
 	.send_IPI_self			= NULL,
Index: linux-2.6/arch/x86/kernel/summit_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/summit_32.c
+++ linux-2.6/arch/x86/kernel/summit_32.c
@@ -43,6 +43,7 @@
 #include <asm/genapic.h>
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
+#include <asm/ipi.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/init.h>
@@ -54,12 +55,9 @@ static inline unsigned summit_get_apic_i
 	return (x >> 24) & 0xFF;
 }
 
-void default_send_IPI_mask_sequence(const cpumask_t *mask, int vector);
-void default_send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
-
 static inline void summit_send_IPI_mask(const cpumask_t *mask, int vector)
 {
-	default_send_IPI_mask_sequence(mask, vector);
+	default_send_IPI_mask_sequence_logical(mask, vector);
 }
 
 static inline void summit_send_IPI_allbutself(int vector)
