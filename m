Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbZA2AHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbZA2AHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660AbZA1Xpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:53078 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758347AbZA1Xpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:40 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 059/114] x86, apic: untangle the send_IPI_*() jungle
Date: Wed, 28 Jan 2009 23:42:05 +0000
Message-Id: <1233186180-29883-60-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our send_IPI_*() methods and definitions are a twisted mess: the same
symbol is defined to different things depending on .config details,
in a non-transparent way.

 - spread out the quirks into separately named per apic driver methods

 - prefix the standard PC methods with default_

 - get rid of wrapper macro obfuscation

 - clean up various details

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/ipi.h             |   44 +++++-----
 arch/x86/include/asm/es7000/ipi.h             |   44 +++++-----
 arch/x86/include/asm/hw_irq.h                 |    4 +-
 arch/x86/include/asm/ipi.h                    |   38 ++++----
 arch/x86/include/asm/mach-default/mach_apic.h |    1 -
 arch/x86/include/asm/mach-default/mach_ipi.h  |  122 ++++++++++++-------------
 arch/x86/include/asm/mach-generic/mach_ipi.h  |    4 -
 arch/x86/include/asm/numaq/ipi.h              |   44 +++++-----
 arch/x86/include/asm/summit/ipi.h             |   52 +++++-----
 arch/x86/kernel/apic.c                        |    2 +-
 arch/x86/kernel/genapic_64.c                  |    2 +-
 arch/x86/kernel/genapic_flat_64.c             |   24 +++--
 arch/x86/kernel/genx2apic_cluster.c           |   38 ++++----
 arch/x86/kernel/genx2apic_phys.c              |   36 +++----
 arch/x86/kernel/genx2apic_uv_x.c              |   21 +++--
 arch/x86/kernel/io_apic.c                     |   10 +-
 arch/x86/kernel/ipi.c                         |   28 +++---
 arch/x86/kernel/kgdb.c                        |    2 +-
 arch/x86/kernel/reboot.c                      |    2 +-
 arch/x86/kernel/smp.c                         |   10 +-
 arch/x86/mach-generic/bigsmp.c                |    6 +-
 arch/x86/mach-generic/default.c               |    6 +-
 arch/x86/mach-generic/es7000.c                |    6 +-
 arch/x86/mach-generic/numaq.c                 |    6 +-
 arch/x86/mach-generic/summit.c                |    6 +-
 arch/x86/mm/tlb.c                             |    2 +-
 26 files changed, 279 insertions(+), 281 deletions(-)
 rewrite arch/x86/include/asm/bigsmp/ipi.h (81%)
 rewrite arch/x86/include/asm/es7000/ipi.h (81%)
 rewrite arch/x86/include/asm/mach-default/mach_ipi.h (65%)
 rewrite arch/x86/include/asm/numaq/ipi.h (81%)
 rewrite arch/x86/include/asm/summit/ipi.h (66%)

diff --git a/arch/x86/include/asm/bigsmp/ipi.h b/arch/x86/include/asm/bigsmp/ipi.h
dissimilarity index 81%
index 27fcd01..a91db69 100644
--- a/arch/x86/include/asm/bigsmp/ipi.h
+++ b/arch/x86/include/asm/bigsmp/ipi.h
@@ -1,22 +1,22 @@
-#ifndef __ASM_MACH_IPI_H
-#define __ASM_MACH_IPI_H
-
-void send_IPI_mask_sequence(const struct cpumask *mask, int vector);
-void send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
-
-static inline void send_IPI_mask(const struct cpumask *mask, int vector)
-{
-	send_IPI_mask_sequence(mask, vector);
-}
-
-static inline void send_IPI_allbutself(int vector)
-{
-	send_IPI_mask_allbutself(cpu_online_mask, vector);
-}
-
-static inline void send_IPI_all(int vector)
-{
-	send_IPI_mask(cpu_online_mask, vector);
-}
-
-#endif /* __ASM_MACH_IPI_H */
+#ifndef __ASM_MACH_IPI_H
+#define __ASM_MACH_IPI_H
+
+void default_send_IPI_mask_sequence(const struct cpumask *mask, int vector);
+void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
+
+static inline void default_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	default_send_IPI_mask_sequence(mask, vector);
+}
+
+static inline void bigsmp_send_IPI_allbutself(int vector)
+{
+	default_send_IPI_mask_allbutself(cpu_online_mask, vector);
+}
+
+static inline void bigsmp_send_IPI_all(int vector)
+{
+	default_send_IPI_mask(cpu_online_mask, vector);
+}
+
+#endif /* __ASM_MACH_IPI_H */
diff --git a/arch/x86/include/asm/es7000/ipi.h b/arch/x86/include/asm/es7000/ipi.h
dissimilarity index 81%
index 7e8ed24..81e77c8 100644
--- a/arch/x86/include/asm/es7000/ipi.h
+++ b/arch/x86/include/asm/es7000/ipi.h
@@ -1,22 +1,22 @@
-#ifndef __ASM_ES7000_IPI_H
-#define __ASM_ES7000_IPI_H
-
-void send_IPI_mask_sequence(const struct cpumask *mask, int vector);
-void send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
-
-static inline void send_IPI_mask(const struct cpumask *mask, int vector)
-{
-	send_IPI_mask_sequence(mask, vector);
-}
-
-static inline void send_IPI_allbutself(int vector)
-{
-	send_IPI_mask_allbutself(cpu_online_mask, vector);
-}
-
-static inline void send_IPI_all(int vector)
-{
-	send_IPI_mask(cpu_online_mask, vector);
-}
-
-#endif /* __ASM_ES7000_IPI_H */
+#ifndef __ASM_ES7000_IPI_H
+#define __ASM_ES7000_IPI_H
+
+void default_send_IPI_mask_sequence(const struct cpumask *mask, int vector);
+void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
+
+static inline void es7000_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	default_send_IPI_mask_sequence(mask, vector);
+}
+
+static inline void es7000_send_IPI_allbutself(int vector)
+{
+	default_send_IPI_mask_allbutself(cpu_online_mask, vector);
+}
+
+static inline void es7000_send_IPI_all(int vector)
+{
+	es7000_send_IPI_mask(cpu_online_mask, vector);
+}
+
+#endif /* __ASM_ES7000_IPI_H */
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 8de644b..bfa921f 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -73,9 +73,9 @@ extern void enable_IO_APIC(void);
 
 /* IPI functions */
 #ifdef CONFIG_X86_32
-extern void send_IPI_self(int vector);
+extern void default_send_IPI_self(int vector);
 #endif
-extern void send_IPI(int dest, int vector);
+extern void default_send_IPI(int dest, int vector);
 
 /* Statistics */
 extern atomic_t irq_err_count;
diff --git a/arch/x86/include/asm/ipi.h b/arch/x86/include/asm/ipi.h
index c745a30..a8d717f 100644
--- a/arch/x86/include/asm/ipi.h
+++ b/arch/x86/include/asm/ipi.h
@@ -55,8 +55,9 @@ static inline void __xapic_wait_icr_idle(void)
 		cpu_relax();
 }
 
-static inline void __send_IPI_shortcut(unsigned int shortcut, int vector,
-				       unsigned int dest)
+static inline void
+__default_send_IPI_shortcut(unsigned int shortcut,
+			    int vector, unsigned int dest)
 {
 	/*
 	 * Subtle. In the case of the 'never do double writes' workaround
@@ -87,8 +88,8 @@ static inline void __send_IPI_shortcut(unsigned int shortcut, int vector,
  * This is used to send an IPI with no shorthand notation (the destination is
  * specified in bits 56 to 63 of the ICR).
  */
-static inline void __send_IPI_dest_field(unsigned int mask, int vector,
-					 unsigned int dest)
+static inline void
+ __default_send_IPI_dest_field(unsigned int mask, int vector, unsigned int dest)
 {
 	unsigned long cfg;
 
@@ -117,11 +118,11 @@ static inline void __send_IPI_dest_field(unsigned int mask, int vector,
 	native_apic_mem_write(APIC_ICR, cfg);
 }
 
-static inline void send_IPI_mask_sequence(const struct cpumask *mask,
-					  int vector)
+static inline void
+default_send_IPI_mask_sequence(const struct cpumask *mask, int vector)
 {
-	unsigned long flags;
 	unsigned long query_cpu;
+	unsigned long flags;
 
 	/*
 	 * Hack. The clustered APIC addressing mode doesn't allow us to send
@@ -130,27 +131,28 @@ static inline void send_IPI_mask_sequence(const struct cpumask *mask,
 	 */
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask) {
-		__send_IPI_dest_field(per_cpu(x86_cpu_to_apicid, query_cpu),
-				      vector, APIC_DEST_PHYSICAL);
+		__default_send_IPI_dest_field(per_cpu(x86_cpu_to_apicid,
+				query_cpu), vector, APIC_DEST_PHYSICAL);
 	}
 	local_irq_restore(flags);
 }
 
-static inline void send_IPI_mask_allbutself(const struct cpumask *mask,
-					    int vector)
+static inline void
+default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
-	unsigned long flags;
-	unsigned int query_cpu;
 	unsigned int this_cpu = smp_processor_id();
+	unsigned int query_cpu;
+	unsigned long flags;
 
 	/* See Hack comment above */
 
 	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask)
-		if (query_cpu != this_cpu)
-			__send_IPI_dest_field(
-				per_cpu(x86_cpu_to_apicid, query_cpu),
-				vector, APIC_DEST_PHYSICAL);
+	for_each_cpu(query_cpu, mask) {
+		if (query_cpu == this_cpu)
+			continue;
+		__default_send_IPI_dest_field(per_cpu(x86_cpu_to_apicid,
+				 query_cpu), vector, APIC_DEST_PHYSICAL);
+	}
 	local_irq_restore(flags);
 }
 
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 8972f84..2e4104c 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -20,7 +20,6 @@ static inline const struct cpumask *default_target_cpus(void)
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
 #define read_apic_id()  (apic->get_apic_id(apic_read(APIC_ID)))
-#define send_IPI_self (apic->send_IPI_self)
 #define wakeup_secondary_cpu (apic->wakeup_cpu)
 extern void default_setup_apic_routing(void);
 #else
diff --git a/arch/x86/include/asm/mach-default/mach_ipi.h b/arch/x86/include/asm/mach-default/mach_ipi.h
dissimilarity index 65%
index 0893996..85dec63 100644
--- a/arch/x86/include/asm/mach-default/mach_ipi.h
+++ b/arch/x86/include/asm/mach-default/mach_ipi.h
@@ -1,64 +1,58 @@
-#ifndef _ASM_X86_MACH_DEFAULT_MACH_IPI_H
-#define _ASM_X86_MACH_DEFAULT_MACH_IPI_H
-
-/* Avoid include hell */
-#define NMI_VECTOR 0x02
-
-void send_IPI_mask_bitmask(const struct cpumask *mask, int vector);
-void send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
-void __send_IPI_shortcut(unsigned int shortcut, int vector);
-
-extern int no_broadcast;
-
-#ifdef CONFIG_X86_64
-#include <asm/genapic.h>
-#define send_IPI_mask (apic->send_IPI_mask)
-#define send_IPI_mask_allbutself (apic->send_IPI_mask_allbutself)
-#else
-static inline void send_IPI_mask(const struct cpumask *mask, int vector)
-{
-	send_IPI_mask_bitmask(mask, vector);
-}
-void send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
-#endif
-
-static inline void __local_send_IPI_allbutself(int vector)
-{
-	if (no_broadcast || vector == NMI_VECTOR)
-		send_IPI_mask_allbutself(cpu_online_mask, vector);
-	else
-		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector);
-}
-
-static inline void __local_send_IPI_all(int vector)
-{
-	if (no_broadcast || vector == NMI_VECTOR)
-		send_IPI_mask(cpu_online_mask, vector);
-	else
-		__send_IPI_shortcut(APIC_DEST_ALLINC, vector);
-}
-
-#ifdef CONFIG_X86_64
-#define send_IPI_allbutself (apic->send_IPI_allbutself)
-#define send_IPI_all (apic->send_IPI_all)
-#else
-static inline void send_IPI_allbutself(int vector)
-{
-	/*
-	 * if there are no other CPUs in the system then we get an APIC send 
-	 * error if we try to broadcast, thus avoid sending IPIs in this case.
-	 */
-	if (!(num_online_cpus() > 1))
-		return;
-
-	__local_send_IPI_allbutself(vector);
-	return;
-}
-
-static inline void send_IPI_all(int vector)
-{
-	__local_send_IPI_all(vector);
-}
-#endif
-
-#endif /* _ASM_X86_MACH_DEFAULT_MACH_IPI_H */
+#ifndef _ASM_X86_MACH_DEFAULT_MACH_IPI_H
+#define _ASM_X86_MACH_DEFAULT_MACH_IPI_H
+
+/* Avoid include hell */
+#define NMI_VECTOR 0x02
+
+void default_send_IPI_mask_bitmask(const struct cpumask *mask, int vector);
+void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
+void __default_send_IPI_shortcut(unsigned int shortcut, int vector);
+
+extern int no_broadcast;
+
+#ifdef CONFIG_X86_64
+#include <asm/genapic.h>
+#else
+static inline void default_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	default_send_IPI_mask_bitmask(mask, vector);
+}
+void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
+#endif
+
+static inline void __default_local_send_IPI_allbutself(int vector)
+{
+	if (no_broadcast || vector == NMI_VECTOR)
+		apic->send_IPI_mask_allbutself(cpu_online_mask, vector);
+	else
+		__default_send_IPI_shortcut(APIC_DEST_ALLBUT, vector);
+}
+
+static inline void __default_local_send_IPI_all(int vector)
+{
+	if (no_broadcast || vector == NMI_VECTOR)
+		apic->send_IPI_mask(cpu_online_mask, vector);
+	else
+		__default_send_IPI_shortcut(APIC_DEST_ALLINC, vector);
+}
+
+#ifdef CONFIG_X86_32
+static inline void default_send_IPI_allbutself(int vector)
+{
+	/*
+	 * if there are no other CPUs in the system then we get an APIC send 
+	 * error if we try to broadcast, thus avoid sending IPIs in this case.
+	 */
+	if (!(num_online_cpus() > 1))
+		return;
+
+	__default_local_send_IPI_allbutself(vector);
+}
+
+static inline void default_send_IPI_all(int vector)
+{
+	__default_local_send_IPI_all(vector);
+}
+#endif
+
+#endif /* _ASM_X86_MACH_DEFAULT_MACH_IPI_H */
diff --git a/arch/x86/include/asm/mach-generic/mach_ipi.h b/arch/x86/include/asm/mach-generic/mach_ipi.h
index 75e54bd..5691c09 100644
--- a/arch/x86/include/asm/mach-generic/mach_ipi.h
+++ b/arch/x86/include/asm/mach-generic/mach_ipi.h
@@ -3,8 +3,4 @@
 
 #include <asm/genapic.h>
 
-#define send_IPI_mask (apic->send_IPI_mask)
-#define send_IPI_allbutself (apic->send_IPI_allbutself)
-#define send_IPI_all (apic->send_IPI_all)
-
 #endif /* _ASM_X86_MACH_GENERIC_MACH_IPI_H */
diff --git a/arch/x86/include/asm/numaq/ipi.h b/arch/x86/include/asm/numaq/ipi.h
dissimilarity index 81%
index a8374c6..5dbc4b4 100644
--- a/arch/x86/include/asm/numaq/ipi.h
+++ b/arch/x86/include/asm/numaq/ipi.h
@@ -1,22 +1,22 @@
-#ifndef __ASM_NUMAQ_IPI_H
-#define __ASM_NUMAQ_IPI_H
-
-void send_IPI_mask_sequence(const struct cpumask *mask, int vector);
-void send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
-
-static inline void send_IPI_mask(const struct cpumask *mask, int vector)
-{
-	send_IPI_mask_sequence(mask, vector);
-}
-
-static inline void send_IPI_allbutself(int vector)
-{
-	send_IPI_mask_allbutself(cpu_online_mask, vector);
-}
-
-static inline void send_IPI_all(int vector)
-{
-	send_IPI_mask(cpu_online_mask, vector);
-}
-
-#endif /* __ASM_NUMAQ_IPI_H */
+#ifndef __ASM_NUMAQ_IPI_H
+#define __ASM_NUMAQ_IPI_H
+
+void default_send_IPI_mask_sequence(const struct cpumask *mask, int vector);
+void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
+
+static inline void numaq_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	default_send_IPI_mask_sequence(mask, vector);
+}
+
+static inline void numaq_send_IPI_allbutself(int vector)
+{
+	default_send_IPI_mask_allbutself(cpu_online_mask, vector);
+}
+
+static inline void numaq_send_IPI_all(int vector)
+{
+	numaq_send_IPI_mask(cpu_online_mask, vector);
+}
+
+#endif /* __ASM_NUMAQ_IPI_H */
diff --git a/arch/x86/include/asm/summit/ipi.h b/arch/x86/include/asm/summit/ipi.h
dissimilarity index 66%
index a8a2c24..f87a43f 100644
--- a/arch/x86/include/asm/summit/ipi.h
+++ b/arch/x86/include/asm/summit/ipi.h
@@ -1,26 +1,26 @@
-#ifndef __ASM_SUMMIT_IPI_H
-#define __ASM_SUMMIT_IPI_H
-
-void send_IPI_mask_sequence(const cpumask_t *mask, int vector);
-void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
-
-static inline void send_IPI_mask(const cpumask_t *mask, int vector)
-{
-	send_IPI_mask_sequence(mask, vector);
-}
-
-static inline void send_IPI_allbutself(int vector)
-{
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(smp_processor_id(), mask);
-
-	if (!cpus_empty(mask))
-		send_IPI_mask(&mask, vector);
-}
-
-static inline void send_IPI_all(int vector)
-{
-	send_IPI_mask(&cpu_online_map, vector);
-}
-
-#endif /* __ASM_SUMMIT_IPI_H */
+#ifndef __ASM_SUMMIT_IPI_H
+#define __ASM_SUMMIT_IPI_H
+
+void default_send_IPI_mask_sequence(const cpumask_t *mask, int vector);
+void default_send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
+
+static inline void summit_send_IPI_mask(const cpumask_t *mask, int vector)
+{
+	default_send_IPI_mask_sequence(mask, vector);
+}
+
+static inline void summit_send_IPI_allbutself(int vector)
+{
+	cpumask_t mask = cpu_online_map;
+	cpu_clear(smp_processor_id(), mask);
+
+	if (!cpus_empty(mask))
+		summit_send_IPI_mask(&mask, vector);
+}
+
+static inline void summit_send_IPI_all(int vector)
+{
+	summit_send_IPI_mask(&cpu_online_map, vector);
+}
+
+#endif /* __ASM_SUMMIT_IPI_H */
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 5f7f3a9..84b8e7c 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -475,7 +475,7 @@ static void lapic_timer_setup(enum clock_event_mode mode,
 static void lapic_timer_broadcast(const struct cpumask *mask)
 {
 #ifdef CONFIG_SMP
-	send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
+	apic->send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
 #endif
 }
 
diff --git a/arch/x86/kernel/genapic_64.c b/arch/x86/kernel/genapic_64.c
index d57d213..820dea5 100644
--- a/arch/x86/kernel/genapic_64.c
+++ b/arch/x86/kernel/genapic_64.c
@@ -65,7 +65,7 @@ void __init default_setup_apic_routing(void)
 
 void apic_send_IPI_self(int vector)
 {
-	__send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
+	__default_send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
 }
 
 int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index b941b11..7c648cc 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -74,7 +74,7 @@ static inline void _flat_send_IPI_mask(unsigned long mask, int vector)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__send_IPI_dest_field(mask, vector, apic->dest_logical);
+	__default_send_IPI_dest_field(mask, vector, apic->dest_logical);
 	local_irq_restore(flags);
 }
 
@@ -85,14 +85,15 @@ static void flat_send_IPI_mask(const struct cpumask *cpumask, int vector)
 	_flat_send_IPI_mask(mask, vector);
 }
 
-static void flat_send_IPI_mask_allbutself(const struct cpumask *cpumask,
-					  int vector)
+static void
+ flat_send_IPI_mask_allbutself(const struct cpumask *cpumask, int vector)
 {
 	unsigned long mask = cpumask_bits(cpumask)[0];
 	int cpu = smp_processor_id();
 
 	if (cpu < BITS_PER_LONG)
 		clear_bit(cpu, &mask);
+
 	_flat_send_IPI_mask(mask, vector);
 }
 
@@ -114,16 +115,19 @@ static void flat_send_IPI_allbutself(int vector)
 			_flat_send_IPI_mask(mask, vector);
 		}
 	} else if (num_online_cpus() > 1) {
-		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector, apic->dest_logical);
+		__default_send_IPI_shortcut(APIC_DEST_ALLBUT,
+					    vector, apic->dest_logical);
 	}
 }
 
 static void flat_send_IPI_all(int vector)
 {
-	if (vector == NMI_VECTOR)
+	if (vector == NMI_VECTOR) {
 		flat_send_IPI_mask(cpu_online_mask, vector);
-	else
-		__send_IPI_shortcut(APIC_DEST_ALLINC, vector, apic->dest_logical);
+	} else {
+		__default_send_IPI_shortcut(APIC_DEST_ALLINC,
+					    vector, apic->dest_logical);
+	}
 }
 
 static unsigned int flat_get_apic_id(unsigned long x)
@@ -265,18 +269,18 @@ static void physflat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 
 static void physflat_send_IPI_mask(const struct cpumask *cpumask, int vector)
 {
-	send_IPI_mask_sequence(cpumask, vector);
+	default_send_IPI_mask_sequence(cpumask, vector);
 }
 
 static void physflat_send_IPI_mask_allbutself(const struct cpumask *cpumask,
 					      int vector)
 {
-	send_IPI_mask_allbutself(cpumask, vector);
+	default_send_IPI_mask_allbutself(cpumask, vector);
 }
 
 static void physflat_send_IPI_allbutself(int vector)
 {
-	send_IPI_mask_allbutself(cpu_online_mask, vector);
+	default_send_IPI_mask_allbutself(cpu_online_mask, vector);
 }
 
 static void physflat_send_IPI_all(int vector)
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index 62f9fcc..2d97726 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -36,8 +36,8 @@ static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
 	cpumask_set_cpu(cpu, retmask);
 }
 
-static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
-				   unsigned int dest)
+static void
+ __x2apic_send_IPI_dest(unsigned int apicid, int vector, unsigned int dest)
 {
 	unsigned long cfg;
 
@@ -57,45 +57,50 @@ static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
  */
 static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 {
-	unsigned long flags;
 	unsigned long query_cpu;
+	unsigned long flags;
 
 	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask)
+	for_each_cpu(query_cpu, mask) {
 		__x2apic_send_IPI_dest(
 			per_cpu(x86_cpu_to_logical_apicid, query_cpu),
 			vector, apic->dest_logical);
+	}
 	local_irq_restore(flags);
 }
 
-static void x2apic_send_IPI_mask_allbutself(const struct cpumask *mask,
-					    int vector)
+static void
+ x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
-	unsigned long flags;
-	unsigned long query_cpu;
 	unsigned long this_cpu = smp_processor_id();
+	unsigned long query_cpu;
+	unsigned long flags;
 
 	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask)
-		if (query_cpu != this_cpu)
-			__x2apic_send_IPI_dest(
+	for_each_cpu(query_cpu, mask) {
+		if (query_cpu == this_cpu)
+			continue;
+		__x2apic_send_IPI_dest(
 				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
 				vector, apic->dest_logical);
+	}
 	local_irq_restore(flags);
 }
 
 static void x2apic_send_IPI_allbutself(int vector)
 {
-	unsigned long flags;
-	unsigned long query_cpu;
 	unsigned long this_cpu = smp_processor_id();
+	unsigned long query_cpu;
+	unsigned long flags;
 
 	local_irq_save(flags);
-	for_each_online_cpu(query_cpu)
-		if (query_cpu != this_cpu)
-			__x2apic_send_IPI_dest(
+	for_each_online_cpu(query_cpu) {
+		if (query_cpu == this_cpu)
+			continue;
+		__x2apic_send_IPI_dest(
 				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
 				vector, apic->dest_logical);
+	}
 	local_irq_restore(flags);
 }
 
@@ -175,7 +180,6 @@ static void init_x2apic_ldr(void)
 	int cpu = smp_processor_id();
 
 	per_cpu(x86_cpu_to_logical_apicid, cpu) = apic_read(APIC_LDR);
-	return;
 }
 
 struct genapic apic_x2apic_cluster = {
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 3da1675..74777c2 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -55,8 +55,8 @@ static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
 
 static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 {
-	unsigned long flags;
 	unsigned long query_cpu;
+	unsigned long flags;
 
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask) {
@@ -66,12 +66,12 @@ static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 	local_irq_restore(flags);
 }
 
-static void x2apic_send_IPI_mask_allbutself(const struct cpumask *mask,
-					    int vector)
+static void
+ x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
-	unsigned long flags;
-	unsigned long query_cpu;
 	unsigned long this_cpu = smp_processor_id();
+	unsigned long query_cpu;
+	unsigned long flags;
 
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask) {
@@ -85,16 +85,17 @@ static void x2apic_send_IPI_mask_allbutself(const struct cpumask *mask,
 
 static void x2apic_send_IPI_allbutself(int vector)
 {
-	unsigned long flags;
-	unsigned long query_cpu;
 	unsigned long this_cpu = smp_processor_id();
+	unsigned long query_cpu;
+	unsigned long flags;
 
 	local_irq_save(flags);
-	for_each_online_cpu(query_cpu)
-		if (query_cpu != this_cpu)
-			__x2apic_send_IPI_dest(
-				per_cpu(x86_cpu_to_apicid, query_cpu),
-				vector, APIC_DEST_PHYSICAL);
+	for_each_online_cpu(query_cpu) {
+		if (query_cpu == this_cpu)
+			continue;
+		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
+				       vector, APIC_DEST_PHYSICAL);
+	}
 	local_irq_restore(flags);
 }
 
@@ -145,18 +146,12 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 
 static unsigned int x2apic_phys_get_apic_id(unsigned long x)
 {
-	unsigned int id;
-
-	id = x;
-	return id;
+	return x;
 }
 
 static unsigned long set_apic_id(unsigned int id)
 {
-	unsigned long x;
-
-	x = id;
-	return x;
+	return id;
 }
 
 static int x2apic_phys_pkg_id(int initial_apicid, int index_msb)
@@ -171,7 +166,6 @@ static void x2apic_send_IPI_self(int vector)
 
 static void init_x2apic_ldr(void)
 {
-	return;
 }
 
 struct genapic apic_x2apic_phys = {
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index f957878..24b9f42 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -118,12 +118,13 @@ static void uv_send_IPI_one(int cpu, int vector)
 	int pnode;
 
 	apicid = per_cpu(x86_cpu_to_apicid, cpu);
-	lapicid = apicid & 0x3f;		/* ZZZ macro needed */
+	lapicid = apicid & 0x3f; /* ZZZ macro needed */
 	pnode = uv_apicid_to_pnode(apicid);
-	val =
-	    (1UL << UVH_IPI_INT_SEND_SHFT) | (lapicid <<
-					      UVH_IPI_INT_APIC_ID_SHFT) |
-	    (vector << UVH_IPI_INT_VECTOR_SHFT);
+
+	val = (     1UL << UVH_IPI_INT_SEND_SHFT    ) |
+	      ( lapicid << UVH_IPI_INT_APIC_ID_SHFT ) |
+	      (  vector << UVH_IPI_INT_VECTOR_SHFT  );
+
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
 
@@ -137,22 +138,24 @@ static void uv_send_IPI_mask(const struct cpumask *mask, int vector)
 
 static void uv_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
-	unsigned int cpu;
 	unsigned int this_cpu = smp_processor_id();
+	unsigned int cpu;
 
-	for_each_cpu(cpu, mask)
+	for_each_cpu(cpu, mask) {
 		if (cpu != this_cpu)
 			uv_send_IPI_one(cpu, vector);
+	}
 }
 
 static void uv_send_IPI_allbutself(int vector)
 {
-	unsigned int cpu;
 	unsigned int this_cpu = smp_processor_id();
+	unsigned int cpu;
 
-	for_each_online_cpu(cpu)
+	for_each_online_cpu(cpu) {
 		if (cpu != this_cpu)
 			uv_send_IPI_one(cpu, vector);
+	}
 }
 
 static void uv_send_IPI_all(int vector)
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 01a2505..e90970c 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -514,11 +514,11 @@ static void send_cleanup_vector(struct irq_cfg *cfg)
 		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
 			cfg->move_cleanup_count++;
 		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
-			send_IPI_mask(cpumask_of(i), IRQ_MOVE_CLEANUP_VECTOR);
+			apic->send_IPI_mask(cpumask_of(i), IRQ_MOVE_CLEANUP_VECTOR);
 	} else {
 		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_mask);
 		cfg->move_cleanup_count = cpumask_weight(cleanup_mask);
-		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		apic->send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
 		free_cpumask_var(cleanup_mask);
 	}
 	cfg->move_in_progress = 0;
@@ -800,7 +800,7 @@ static void clear_IO_APIC (void)
 }
 
 #if !defined(CONFIG_SMP) && defined(CONFIG_X86_32)
-void send_IPI_self(int vector)
+void default_send_IPI_self(int vector)
 {
 	unsigned int cfg;
 
@@ -2297,7 +2297,7 @@ static int ioapic_retrigger_irq(unsigned int irq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	send_IPI_mask(cpumask_of(cpumask_first(cfg->domain)), cfg->vector);
+	apic->send_IPI_mask(cpumask_of(cpumask_first(cfg->domain)), cfg->vector);
 	spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;
@@ -2305,7 +2305,7 @@ static int ioapic_retrigger_irq(unsigned int irq)
 #else
 static int ioapic_retrigger_irq(unsigned int irq)
 {
-	send_IPI_self(irq_cfg(irq)->vector);
+	apic->send_IPI_self(irq_cfg(irq)->vector);
 
 	return 1;
 }
diff --git a/arch/x86/kernel/ipi.c b/arch/x86/kernel/ipi.c
index 367c5e6..e16c41b 100644
--- a/arch/x86/kernel/ipi.c
+++ b/arch/x86/kernel/ipi.c
@@ -48,7 +48,7 @@ static inline int __prepare_ICR2(unsigned int mask)
 	return SET_APIC_DEST_FIELD(mask);
 }
 
-void __send_IPI_shortcut(unsigned int shortcut, int vector)
+void __default_send_IPI_shortcut(unsigned int shortcut, int vector)
 {
 	/*
 	 * Subtle. In the case of the 'never do double writes' workaround
@@ -75,16 +75,16 @@ void __send_IPI_shortcut(unsigned int shortcut, int vector)
 	apic_write(APIC_ICR, cfg);
 }
 
-void send_IPI_self(int vector)
+void default_send_IPI_self(int vector)
 {
-	__send_IPI_shortcut(APIC_DEST_SELF, vector);
+	__default_send_IPI_shortcut(APIC_DEST_SELF, vector);
 }
 
 /*
  * This is used to send an IPI with no shorthand notation (the destination is
  * specified in bits 56 to 63 of the ICR).
  */
-static inline void __send_IPI_dest_field(unsigned long mask, int vector)
+static inline void __default_send_IPI_dest_field(unsigned long mask, int vector)
 {
 	unsigned long cfg;
 
@@ -116,18 +116,18 @@ static inline void __send_IPI_dest_field(unsigned long mask, int vector)
 /*
  * This is only used on smaller machines.
  */
-void send_IPI_mask_bitmask(const struct cpumask *cpumask, int vector)
+void default_send_IPI_mask_bitmask(const struct cpumask *cpumask, int vector)
 {
 	unsigned long mask = cpumask_bits(cpumask)[0];
 	unsigned long flags;
 
 	local_irq_save(flags);
 	WARN_ON(mask & ~cpumask_bits(cpu_online_mask)[0]);
-	__send_IPI_dest_field(mask, vector);
+	__default_send_IPI_dest_field(mask, vector);
 	local_irq_restore(flags);
 }
 
-void send_IPI_mask_sequence(const struct cpumask *mask, int vector)
+void default_send_IPI_mask_sequence(const struct cpumask *mask, int vector)
 {
 	unsigned long flags;
 	unsigned int query_cpu;
@@ -140,11 +140,11 @@ void send_IPI_mask_sequence(const struct cpumask *mask, int vector)
 
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask)
-		__send_IPI_dest_field(apic->cpu_to_logical_apicid(query_cpu), vector);
+		__default_send_IPI_dest_field(apic->cpu_to_logical_apicid(query_cpu), vector);
 	local_irq_restore(flags);
 }
 
-void send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
+void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
 	unsigned long flags;
 	unsigned int query_cpu;
@@ -153,10 +153,12 @@ void send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 	/* See Hack comment above */
 
 	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask)
-		if (query_cpu != this_cpu)
-			__send_IPI_dest_field(apic->cpu_to_logical_apicid(query_cpu),
-					      vector);
+	for_each_cpu(query_cpu, mask) {
+		if (query_cpu == this_cpu)
+			continue;
+		__default_send_IPI_dest_field(
+			apic->cpu_to_logical_apicid(query_cpu), vector);
+	}
 	local_irq_restore(flags);
 }
 
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 10435a1..b62a381 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -347,7 +347,7 @@ void kgdb_post_primary_code(struct pt_regs *regs, int e_vector, int err_code)
  */
 void kgdb_roundup_cpus(unsigned long flags)
 {
-	send_IPI_allbutself(APIC_DM_NMI);
+	apic->send_IPI_allbutself(APIC_DM_NMI);
 }
 #endif
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f8536fe..38dace2 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -651,7 +651,7 @@ static int crash_nmi_callback(struct notifier_block *self,
 
 static void smp_send_nmi_allbutself(void)
 {
-	send_IPI_allbutself(NMI_VECTOR);
+	apic->send_IPI_allbutself(NMI_VECTOR);
 }
 
 static struct notifier_block crash_nmi_nb = {
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index e6faa33..c48ba6c 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -118,12 +118,12 @@ static void native_smp_send_reschedule(int cpu)
 		WARN_ON(1);
 		return;
 	}
-	send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
+	apic->send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
 }
 
 void native_send_call_func_single_ipi(int cpu)
 {
-	send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_SINGLE_VECTOR);
+	apic->send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_SINGLE_VECTOR);
 }
 
 void native_send_call_func_ipi(const struct cpumask *mask)
@@ -131,7 +131,7 @@ void native_send_call_func_ipi(const struct cpumask *mask)
 	cpumask_var_t allbutself;
 
 	if (!alloc_cpumask_var(&allbutself, GFP_ATOMIC)) {
-		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
+		apic->send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
 		return;
 	}
 
@@ -140,9 +140,9 @@ void native_send_call_func_ipi(const struct cpumask *mask)
 
 	if (cpumask_equal(mask, allbutself) &&
 	    cpumask_equal(cpu_online_mask, cpu_callout_mask))
-		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+		apic->send_IPI_allbutself(CALL_FUNCTION_VECTOR);
 	else
-		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
+		apic->send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
 
 	free_cpumask_var(allbutself);
 }
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 22c2c7b..4782b55 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -97,10 +97,10 @@ struct genapic apic_bigsmp = {
 	.cpu_mask_to_apicid		= bigsmp_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= bigsmp_cpu_mask_to_apicid_and,
 
-	.send_IPI_mask			= send_IPI_mask,
+	.send_IPI_mask			= default_send_IPI_mask,
 	.send_IPI_mask_allbutself	= NULL,
-	.send_IPI_allbutself		= send_IPI_allbutself,
-	.send_IPI_all			= send_IPI_all,
+	.send_IPI_allbutself		= bigsmp_send_IPI_allbutself,
+	.send_IPI_all			= bigsmp_send_IPI_all,
 	.send_IPI_self			= NULL,
 
 	.wakeup_cpu			= NULL,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 477ebec..bf4670d 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -78,10 +78,10 @@ struct genapic apic_default = {
 	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
 
-	.send_IPI_mask			= send_IPI_mask,
+	.send_IPI_mask			= default_send_IPI_mask,
 	.send_IPI_mask_allbutself	= NULL,
-	.send_IPI_allbutself		= send_IPI_allbutself,
-	.send_IPI_all			= send_IPI_all,
+	.send_IPI_allbutself		= default_send_IPI_allbutself,
+	.send_IPI_all			= default_send_IPI_all,
 	.send_IPI_self			= NULL,
 
 	.wakeup_cpu			= NULL,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index d758cf6..d36642e 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -133,10 +133,10 @@ struct genapic apic_es7000 = {
 	.cpu_mask_to_apicid		= es7000_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= es7000_cpu_mask_to_apicid_and,
 
-	.send_IPI_mask			= send_IPI_mask,
+	.send_IPI_mask			= es7000_send_IPI_mask,
 	.send_IPI_mask_allbutself	= NULL,
-	.send_IPI_allbutself		= send_IPI_allbutself,
-	.send_IPI_all			= send_IPI_all,
+	.send_IPI_allbutself		= es7000_send_IPI_allbutself,
+	.send_IPI_all			= es7000_send_IPI_all,
 	.send_IPI_self			= NULL,
 
 	.wakeup_cpu			= NULL,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index eb7d56a..135b183 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -97,10 +97,10 @@ struct genapic apic_numaq = {
 	.cpu_mask_to_apicid		= numaq_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= numaq_cpu_mask_to_apicid_and,
 
-	.send_IPI_mask			= send_IPI_mask,
+	.send_IPI_mask			= numaq_send_IPI_mask,
 	.send_IPI_mask_allbutself	= NULL,
-	.send_IPI_allbutself		= send_IPI_allbutself,
-	.send_IPI_all			= send_IPI_all,
+	.send_IPI_allbutself		= numaq_send_IPI_allbutself,
+	.send_IPI_all			= numaq_send_IPI_all,
 	.send_IPI_self			= NULL,
 
 	.wakeup_cpu			= NULL,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 8c29305..77196a4 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -77,10 +77,10 @@ struct genapic apic_summit = {
 	.cpu_mask_to_apicid		= summit_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= summit_cpu_mask_to_apicid_and,
 
-	.send_IPI_mask			= send_IPI_mask,
+	.send_IPI_mask			= summit_send_IPI_mask,
 	.send_IPI_mask_allbutself	= NULL,
-	.send_IPI_allbutself		= send_IPI_allbutself,
-	.send_IPI_all			= send_IPI_all,
+	.send_IPI_allbutself		= summit_send_IPI_allbutself,
+	.send_IPI_all			= summit_send_IPI_all,
 	.send_IPI_self			= NULL,
 
 	.wakeup_cpu			= NULL,
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 72a6d4e..6348e11 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -196,7 +196,7 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(to_cpumask(f->flush_cpumask),
+	apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
 		      INVALIDATE_TLB_VECTOR_START + sender);
 
 	while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
-- 
1.6.0.2

