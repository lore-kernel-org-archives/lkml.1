Return-Path: <linux-kernel-owner+w=401wt.eu-S1760425AbZA2AGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425AbZA2AGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbZA1Xpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:53067 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758257AbZA1Xpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:36 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 058/114] x86, apic: refactor ->cpu_mask_to_apicid*()
Date: Wed, 28 Jan 2009 23:42:04 +0000
Message-Id: <1233186180-29883-59-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- spread out the namespace on a per driver basis

 - clean up the functions

 - get rid of macros

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |   17 ++++++--------
 arch/x86/include/asm/es7000/apic.h            |   29 +++++++++++++++---------
 arch/x86/include/asm/mach-default/mach_apic.h |   10 ++++----
 arch/x86/include/asm/mach-generic/mach_apic.h |    2 -
 arch/x86/include/asm/numaq/apic.h             |   11 +++++----
 arch/x86/include/asm/summit/apic.h            |   21 +++++++++++-------
 arch/x86/kernel/genapic_flat_64.c             |    4 ++-
 arch/x86/kernel/genx2apic_cluster.c           |   15 +++++++-----
 arch/x86/kernel/genx2apic_phys.c              |   15 +++++++-----
 arch/x86/kernel/genx2apic_uv_x.c              |   14 +++++++-----
 arch/x86/kernel/io_apic.c                     |   21 ++++++++++-------
 arch/x86/mach-generic/bigsmp.c                |    4 +-
 arch/x86/mach-generic/default.c               |    4 +-
 arch/x86/mach-generic/es7000.c                |    6 ++--
 arch/x86/mach-generic/numaq.c                 |    4 +-
 arch/x86/mach-generic/summit.c                |    4 +-
 16 files changed, 101 insertions(+), 80 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index 1230f5d..ee29d66 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -105,18 +105,14 @@ static inline int bigsmp_check_phys_apicid_present(int boot_cpu_physical_apicid)
 }
 
 /* As we are using single CPU as destination, pick only one CPU here */
-static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
+static inline unsigned int bigsmp_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
-	int cpu;
-	int apicid;	
-
-	cpu = first_cpu(*cpumask);
-	apicid = bigsmp_cpu_to_logical_apicid(cpu);
-	return apicid;
+	return bigsmp_cpu_to_logical_apicid(first_cpu(*cpumask));
 }
 
-static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-						  const struct cpumask *andmask)
+static inline unsigned int
+bigsmp_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+			      const struct cpumask *andmask)
 {
 	int cpu;
 
@@ -124,9 +120,10 @@ static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	for_each_cpu_and(cpu, cpumask, andmask)
+	for_each_cpu_and(cpu, cpumask, andmask) {
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
+	}
 	if (cpu < nr_cpu_ids)
 		return bigsmp_cpu_to_logical_apicid(cpu);
 
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index f183dfb..b89b45d 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -137,12 +137,12 @@ static inline int es7000_check_phys_apicid_present(int cpu_physical_apicid)
 }
 
 static inline unsigned int
-cpu_mask_to_apicid_cluster(const struct cpumask *cpumask)
+es7000_cpu_mask_to_apicid_cluster(const struct cpumask *cpumask)
 {
-	int num_bits_set;
 	int cpus_found = 0;
-	int cpu;
+	int num_bits_set;
 	int apicid;
+	int cpu;
 
 	num_bits_set = cpumask_weight(cpumask);
 	/* Return id to all */
@@ -154,12 +154,15 @@ cpu_mask_to_apicid_cluster(const struct cpumask *cpumask)
 	 */
 	cpu = cpumask_first(cpumask);
 	apicid = es7000_cpu_to_logical_apicid(cpu);
+
 	while (cpus_found < num_bits_set) {
 		if (cpumask_test_cpu(cpu, cpumask)) {
 			int new_apicid = es7000_cpu_to_logical_apicid(cpu);
+
 			if (apicid_cluster(apicid) !=
-					apicid_cluster(new_apicid)){
+					apicid_cluster(new_apicid)) {
 				printk ("%s: Not a valid mask!\n", __func__);
+
 				return 0xFF;
 			}
 			apicid = new_apicid;
@@ -170,12 +173,12 @@ cpu_mask_to_apicid_cluster(const struct cpumask *cpumask)
 	return apicid;
 }
 
-static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
+static inline unsigned int es7000_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
-	int num_bits_set;
 	int cpus_found = 0;
-	int cpu;
+	int num_bits_set;
 	int apicid;
+	int cpu;
 
 	num_bits_set = cpus_weight(*cpumask);
 	/* Return id to all */
@@ -190,9 +193,11 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 	while (cpus_found < num_bits_set) {
 		if (cpu_isset(cpu, *cpumask)) {
 			int new_apicid = es7000_cpu_to_logical_apicid(cpu);
+
 			if (apicid_cluster(apicid) !=
-					apicid_cluster(new_apicid)){
+					apicid_cluster(new_apicid)) {
 				printk ("%s: Not a valid mask!\n", __func__);
+
 				return es7000_cpu_to_logical_apicid(0);
 			}
 			apicid = new_apicid;
@@ -204,8 +209,9 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 }
 
 
-static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
-						  const struct cpumask *andmask)
+static inline unsigned int
+es7000_cpu_mask_to_apicid_and(const struct cpumask *inmask,
+			      const struct cpumask *andmask)
 {
 	int apicid = es7000_cpu_to_logical_apicid(0);
 	cpumask_var_t cpumask;
@@ -215,9 +221,10 @@ static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
 
 	cpumask_and(cpumask, inmask, andmask);
 	cpumask_and(cpumask, cpumask, cpu_online_mask);
-	apicid = cpu_mask_to_apicid(cpumask);
+	apicid = es7000_cpu_mask_to_apicid(cpumask);
 
 	free_cpumask_var(cpumask);
+
 	return apicid;
 }
 
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 8719208..8972f84 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -19,8 +19,6 @@ static inline const struct cpumask *default_target_cpus(void)
 
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
-#define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
-#define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
 #define read_apic_id()  (apic->get_apic_id(apic_read(APIC_ID)))
 #define send_IPI_self (apic->send_IPI_self)
 #define wakeup_secondary_cpu (apic->wakeup_cpu)
@@ -49,13 +47,15 @@ static inline int default_apic_id_registered(void)
 	return physid_isset(read_apic_id(), phys_cpu_present_map);
 }
 
-static inline unsigned int cpu_mask_to_apicid(const struct cpumask *cpumask)
+static inline unsigned int
+default_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	return cpumask_bits(cpumask)[0];
 }
 
-static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-						  const struct cpumask *andmask)
+static inline unsigned int
+default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+			       const struct cpumask *andmask)
 {
 	unsigned long mask1 = cpumask_bits(cpumask)[0];
 	unsigned long mask2 = cpumask_bits(andmask)[0];
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index 1eeb5b6..ca460e4 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -3,8 +3,6 @@
 
 #include <asm/genapic.h>
 
-#define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
-#define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
 #define wakeup_secondary_cpu (apic->wakeup_cpu)
 
 extern void generic_bigsmp_probe(void);
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index 765c4d5..ce95e79 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -101,15 +101,16 @@ static inline int numaq_check_phys_apicid_present(int boot_cpu_physical_apicid)
  * We use physical apicids here, not logical, so just return the default
  * physical broadcast to stop people from breaking us
  */
-static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
+static inline unsigned int numaq_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
-	return (int) 0xF;
+	return 0x0F;
 }
 
-static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-						  const struct cpumask *andmask)
+static inline unsigned int
+numaq_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+			     const struct cpumask *andmask)
 {
-	return (int) 0xF;
+	return 0x0F;
 }
 
 /* No NUMA-Q box has a HT CPU, but it can't hurt to use the default code. */
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index fa6b3b4..15b8dbd 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -125,29 +125,32 @@ static inline int summit_check_phys_apicid_present(int boot_cpu_physical_apicid)
 	return 1;
 }
 
-static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
+static inline unsigned int summit_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
-	int num_bits_set;
 	int cpus_found = 0;
-	int cpu;
+	int num_bits_set;
 	int apicid;
+	int cpu;
 
 	num_bits_set = cpus_weight(*cpumask);
 	/* Return id to all */
 	if (num_bits_set >= nr_cpu_ids)
-		return (int) 0xFF;
+		return 0xFF;
 	/*
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of target_cpus():
 	 */
 	cpu = first_cpu(*cpumask);
 	apicid = summit_cpu_to_logical_apicid(cpu);
+
 	while (cpus_found < num_bits_set) {
 		if (cpu_isset(cpu, *cpumask)) {
 			int new_apicid = summit_cpu_to_logical_apicid(cpu);
+
 			if (apicid_cluster(apicid) !=
-					apicid_cluster(new_apicid)){
+					apicid_cluster(new_apicid)) {
 				printk ("%s: Not a valid mask!\n", __func__);
+
 				return 0xFF;
 			}
 			apicid = apicid | new_apicid;
@@ -158,8 +161,9 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 	return apicid;
 }
 
-static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
-						  const struct cpumask *andmask)
+static inline unsigned int
+summit_cpu_mask_to_apicid_and(const struct cpumask *inmask,
+			      const struct cpumask *andmask)
 {
 	int apicid = summit_cpu_to_logical_apicid(0);
 	cpumask_var_t cpumask;
@@ -169,9 +173,10 @@ static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
 
 	cpumask_and(cpumask, inmask, andmask);
 	cpumask_and(cpumask, cpumask, cpu_online_mask);
-	apicid = cpu_mask_to_apicid(cpumask);
+	apicid = summit_cpu_mask_to_apicid(cpumask);
 
 	free_cpumask_var(cpumask);
+
 	return apicid;
 }
 
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 78baa55..b941b11 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -309,11 +309,13 @@ physflat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	for_each_cpu_and(cpu, cpumask, andmask)
+	for_each_cpu_and(cpu, cpumask, andmask) {
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
+	}
 	if (cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
+
 	return BAD_APICID;
 }
 
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index c7557e0..62f9fcc 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -111,21 +111,21 @@ static int x2apic_apic_id_registered(void)
 
 static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
-	int cpu;
-
 	/*
 	 * We're using fixed IRQ delivery, can only return one logical APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = cpumask_first(cpumask);
+	int cpu = cpumask_first(cpumask);
+
 	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_logical_apicid, cpu);
 	else
 		return BAD_APICID;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-						  const struct cpumask *andmask)
+static unsigned int
+x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+			      const struct cpumask *andmask)
 {
 	int cpu;
 
@@ -133,11 +133,14 @@ static unsigned int x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	 * We're using fixed IRQ delivery, can only return one logical APIC ID.
 	 * May as well be the first.
 	 */
-	for_each_cpu_and(cpu, cpumask, andmask)
+	for_each_cpu_and(cpu, cpumask, andmask) {
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
+	}
+
 	if (cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_logical_apicid, cpu);
+
 	return BAD_APICID;
 }
 
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 80cba49..3da1675 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -110,21 +110,21 @@ static int x2apic_apic_id_registered(void)
 
 static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
-	int cpu;
-
 	/*
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = cpumask_first(cpumask);
+	int cpu = cpumask_first(cpumask);
+
 	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
 		return BAD_APICID;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-						  const struct cpumask *andmask)
+static unsigned int
+x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+			      const struct cpumask *andmask)
 {
 	int cpu;
 
@@ -132,11 +132,14 @@ static unsigned int x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	for_each_cpu_and(cpu, cpumask, andmask)
+	for_each_cpu_and(cpu, cpumask, andmask) {
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
+	}
+
 	if (cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
+
 	return BAD_APICID;
 }
 
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 50310b9..f957878 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -171,21 +171,21 @@ static void uv_init_apic_ldr(void)
 
 static unsigned int uv_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
-	int cpu;
-
 	/*
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = cpumask_first(cpumask);
+	int cpu = cpumask_first(cpumask);
+
 	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
 		return BAD_APICID;
 }
 
-static unsigned int uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-					      const struct cpumask *andmask)
+static unsigned int
+uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+			  const struct cpumask *andmask)
 {
 	int cpu;
 
@@ -193,11 +193,13 @@ static unsigned int uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	for_each_cpu_and(cpu, cpumask, andmask)
+	for_each_cpu_and(cpu, cpumask, andmask) {
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
+	}
 	if (cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
+
 	return BAD_APICID;
 }
 
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 3d85d3d..01a2505 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -563,8 +563,9 @@ static int
 assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask);
 
 /*
- * Either sets desc->affinity to a valid value, and returns cpu_mask_to_apicid
- * of that, or returns BAD_APICID and leaves desc->affinity untouched.
+ * Either sets desc->affinity to a valid value, and returns
+ * ->cpu_mask_to_apicid of that, or returns BAD_APICID and
+ * leaves desc->affinity untouched.
  */
 static unsigned int
 set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
@@ -582,7 +583,8 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
 
 	cpumask_and(desc->affinity, cfg->domain, mask);
 	set_extra_move_desc(desc, mask);
-	return cpu_mask_to_apicid_and(desc->affinity, cpu_online_mask);
+
+	return apic->cpu_mask_to_apicid_and(desc->affinity, cpu_online_mask);
 }
 
 static void
@@ -1562,7 +1564,7 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
 		return;
 
-	dest = cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
+	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
 
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
@@ -1666,7 +1668,7 @@ static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
 	 */
 	entry.dest_mode = apic->irq_dest_mode;
 	entry.mask = 1;					/* mask IRQ now */
-	entry.dest = cpu_mask_to_apicid(apic->target_cpus());
+	entry.dest = apic->cpu_mask_to_apicid(apic->target_cpus());
 	entry.delivery_mode = apic->irq_delivery_mode;
 	entry.polarity = 0;
 	entry.trigger = 0;
@@ -2367,7 +2369,7 @@ migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 
 	set_extra_move_desc(desc, mask);
 
-	dest = cpu_mask_to_apicid_and(cfg->domain, mask);
+	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
 
 	modify_ioapic_rte = desc->status & IRQ_LEVEL;
 	if (modify_ioapic_rte) {
@@ -3270,7 +3272,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 	if (err)
 		return err;
 
-	dest = cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
+	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
 
 #ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
@@ -3708,7 +3710,8 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 		struct ht_irq_msg msg;
 		unsigned dest;
 
-		dest = cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
+		dest = apic->cpu_mask_to_apicid_and(cfg->domain,
+						    apic->target_cpus());
 
 		msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
 
@@ -3773,7 +3776,7 @@ int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	entry->polarity = 0;
 	entry->trigger = 0;
 	entry->mask = 0;
-	entry->dest = cpu_mask_to_apicid(eligible_cpu);
+	entry->dest = apic->cpu_mask_to_apicid(eligible_cpu);
 
 	mmr_pnode = uv_blade_to_pnode(mmr_blade);
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index ee52c59..22c2c7b 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -94,8 +94,8 @@ struct genapic apic_bigsmp = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0xFF << 24,
 
-	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
+	.cpu_mask_to_apicid		= bigsmp_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= bigsmp_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= send_IPI_mask,
 	.send_IPI_mask_allbutself	= NULL,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index e4ed7e6..477ebec 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -75,8 +75,8 @@ struct genapic apic_default = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0x0F << 24,
 
-	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
+	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= send_IPI_mask,
 	.send_IPI_mask_allbutself	= NULL,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 3d046de..d758cf6 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -26,7 +26,7 @@ void __init es7000_update_genapic_to_cluster(void)
 
 	apic->init_apic_ldr = es7000_init_apic_ldr_cluster;
 
-	apic->cpu_mask_to_apicid = cpu_mask_to_apicid_cluster;
+	apic->cpu_mask_to_apicid = es7000_cpu_mask_to_apicid_cluster;
 }
 
 static int probe_es7000(void)
@@ -130,8 +130,8 @@ struct genapic apic_es7000 = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0xFF << 24,
 
-	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
+	.cpu_mask_to_apicid		= es7000_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= es7000_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= send_IPI_mask,
 	.send_IPI_mask_allbutself	= NULL,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index a7bf1aa..eb7d56a 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -94,8 +94,8 @@ struct genapic apic_numaq = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0x0F << 24,
 
-	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
+	.cpu_mask_to_apicid		= numaq_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= numaq_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= send_IPI_mask,
 	.send_IPI_mask_allbutself	= NULL,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index a0ae6b9..8c29305 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -74,8 +74,8 @@ struct genapic apic_summit = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0xFF << 24,
 
-	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
+	.cpu_mask_to_apicid		= summit_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= summit_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= send_IPI_mask,
 	.send_IPI_mask_allbutself	= NULL,
-- 
1.6.0.2

