Return-Path: <linux-kernel-owner+w=401wt.eu-S1760405AbZA2AA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbZA2AA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbZA1Xo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:52939 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758553AbZA1Xoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:55 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 043/114] x86, apic: clean up ->cpu_to_logical_apicid()
Date: Wed, 28 Jan 2009 23:41:49 +0000
Message-Id: <1233186180-29883-44-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- separate the namespace

 - remove macros

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    6 +++---
 arch/x86/include/asm/es7000/apic.h            |   16 ++++++++--------
 arch/x86/include/asm/mach-default/mach_apic.h |    2 +-
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 -
 arch/x86/include/asm/numaq/apic.h             |    3 ++-
 arch/x86/include/asm/summit/apic.h            |    8 ++++----
 arch/x86/kernel/ipi.c                         |    4 ++--
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/es7000.c                |    2 +-
 arch/x86/mach-generic/numaq.c                 |    2 +-
 arch/x86/mach-generic/summit.c                |    2 +-
 12 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index 77f0b73..d0d894f 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -82,7 +82,7 @@ static inline physid_mask_t apicid_to_cpu_present(int phys_apicid)
 
 extern u8 cpu_2_logical_apicid[];
 /* Mapping from cpu number to logical apicid */
-static inline int cpu_to_logical_apicid(int cpu)
+static inline int bigsmp_cpu_to_logical_apicid(int cpu)
 {
 	if (cpu >= nr_cpu_ids)
 		return BAD_APICID;
@@ -115,7 +115,7 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 	int apicid;	
 
 	cpu = first_cpu(*cpumask);
-	apicid = cpu_to_logical_apicid(cpu);
+	apicid = bigsmp_cpu_to_logical_apicid(cpu);
 	return apicid;
 }
 
@@ -132,7 +132,7 @@ static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
 	if (cpu < nr_cpu_ids)
-		return cpu_to_logical_apicid(cpu);
+		return bigsmp_cpu_to_logical_apicid(cpu);
 
 	return BAD_APICID;
 }
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index bcdf314..e0cd07e 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -109,7 +109,7 @@ static inline physid_mask_t apicid_to_cpu_present(int phys_apicid)
 
 extern u8 cpu_2_logical_apicid[];
 /* Mapping from cpu number to logical apicid */
-static inline int cpu_to_logical_apicid(int cpu)
+static inline int es7000_cpu_to_logical_apicid(int cpu)
 {
 #ifdef CONFIG_SMP
 	if (cpu >= nr_cpu_ids)
@@ -155,10 +155,10 @@ cpu_mask_to_apicid_cluster(const struct cpumask *cpumask)
 	 * on the same apicid cluster return default value of target_cpus():
 	 */
 	cpu = cpumask_first(cpumask);
-	apicid = cpu_to_logical_apicid(cpu);
+	apicid = es7000_cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
 		if (cpumask_test_cpu(cpu, cpumask)) {
-			int new_apicid = cpu_to_logical_apicid(cpu);
+			int new_apicid = es7000_cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){
 				printk ("%s: Not a valid mask!\n", __func__);
@@ -182,20 +182,20 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 	num_bits_set = cpus_weight(*cpumask);
 	/* Return id to all */
 	if (num_bits_set == nr_cpu_ids)
-		return cpu_to_logical_apicid(0);
+		return es7000_cpu_to_logical_apicid(0);
 	/*
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of target_cpus():
 	 */
 	cpu = first_cpu(*cpumask);
-	apicid = cpu_to_logical_apicid(cpu);
+	apicid = es7000_cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
 		if (cpu_isset(cpu, *cpumask)) {
-			int new_apicid = cpu_to_logical_apicid(cpu);
+			int new_apicid = es7000_cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){
 				printk ("%s: Not a valid mask!\n", __func__);
-				return cpu_to_logical_apicid(0);
+				return es7000_cpu_to_logical_apicid(0);
 			}
 			apicid = new_apicid;
 			cpus_found++;
@@ -209,7 +209,7 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
 						  const struct cpumask *andmask)
 {
-	int apicid = cpu_to_logical_apicid(0);
+	int apicid = es7000_cpu_to_logical_apicid(0);
 	cpumask_var_t cpumask;
 
 	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 2f78209..eae3e4b 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -105,7 +105,7 @@ static inline physid_mask_t default_ioapic_phys_id_map(physid_mask_t phys_map)
 }
 
 /* Mapping from cpu number to logical apicid */
-static inline int cpu_to_logical_apicid(int cpu)
+static inline int default_cpu_to_logical_apicid(int cpu)
 {
 	return 1 << cpu;
 }
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index b585a8e..2ea913e 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -3,7 +3,6 @@
 
 #include <asm/genapic.h>
 
-#define cpu_to_logical_apicid (apic->cpu_to_logical_apicid) 
 #define cpu_present_to_apicid (apic->cpu_present_to_apicid)
 #define apicid_to_cpu_present (apic->apicid_to_cpu_present)
 #define setup_portio_remap (apic->setup_portio_remap)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index a0e3b43..6989abd 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -56,7 +56,8 @@ static inline physid_mask_t numaq_ioapic_phys_id_map(physid_mask_t phys_map)
 
 /* Mapping from cpu number to logical apicid */
 extern u8 cpu_2_logical_apicid[];
-static inline int cpu_to_logical_apicid(int cpu)
+
+static inline int numaq_cpu_to_logical_apicid(int cpu)
 {
 	if (cpu >= nr_cpu_ids)
 		return BAD_APICID;
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index cfff276..d564d7e 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -85,7 +85,7 @@ static inline int summit_apicid_to_node(int logical_apicid)
 }
 
 /* Mapping from cpu number to logical apicid */
-static inline int cpu_to_logical_apicid(int cpu)
+static inline int summit_cpu_to_logical_apicid(int cpu)
 {
 #ifdef CONFIG_SMP
 	if (cpu >= nr_cpu_ids)
@@ -145,10 +145,10 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 	 * on the same apicid cluster return default value of target_cpus():
 	 */
 	cpu = first_cpu(*cpumask);
-	apicid = cpu_to_logical_apicid(cpu);
+	apicid = summit_cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
 		if (cpu_isset(cpu, *cpumask)) {
-			int new_apicid = cpu_to_logical_apicid(cpu);
+			int new_apicid = summit_cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){
 				printk ("%s: Not a valid mask!\n", __func__);
@@ -165,7 +165,7 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
 						  const struct cpumask *andmask)
 {
-	int apicid = cpu_to_logical_apicid(0);
+	int apicid = summit_cpu_to_logical_apicid(0);
 	cpumask_var_t cpumask;
 
 	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
diff --git a/arch/x86/kernel/ipi.c b/arch/x86/kernel/ipi.c
index e2e4895..367c5e6 100644
--- a/arch/x86/kernel/ipi.c
+++ b/arch/x86/kernel/ipi.c
@@ -140,7 +140,7 @@ void send_IPI_mask_sequence(const struct cpumask *mask, int vector)
 
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask)
-		__send_IPI_dest_field(cpu_to_logical_apicid(query_cpu), vector);
+		__send_IPI_dest_field(apic->cpu_to_logical_apicid(query_cpu), vector);
 	local_irq_restore(flags);
 }
 
@@ -155,7 +155,7 @@ void send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask)
 		if (query_cpu != this_cpu)
-			__send_IPI_dest_field(cpu_to_logical_apicid(query_cpu),
+			__send_IPI_dest_field(apic->cpu_to_logical_apicid(query_cpu),
 					      vector);
 	local_irq_restore(flags);
 }
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 2f41214..cd6f02b 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -81,7 +81,7 @@ struct genapic apic_bigsmp = {
 	.setup_apic_routing		= bigsmp_setup_apic_routing,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= bigsmp_apicid_to_node,
-	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
+	.cpu_to_logical_apicid		= bigsmp_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= cpu_present_to_apicid,
 	.apicid_to_cpu_present		= apicid_to_cpu_present,
 	.setup_portio_remap		= setup_portio_remap,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index d391c2d..ef9b936 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -62,7 +62,7 @@ struct genapic apic_default = {
 	.setup_apic_routing		= default_setup_apic_routing,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= default_apicid_to_node,
-	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
+	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= cpu_present_to_apicid,
 	.apicid_to_cpu_present		= apicid_to_cpu_present,
 	.setup_portio_remap		= setup_portio_remap,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 933f2a3..74bf2b6 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -123,7 +123,7 @@ struct genapic apic_es7000 = {
 	.setup_apic_routing		= es7000_setup_apic_routing,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= es7000_apicid_to_node,
-	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
+	.cpu_to_logical_apicid		= es7000_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= cpu_present_to_apicid,
 	.apicid_to_cpu_present		= apicid_to_cpu_present,
 	.setup_portio_remap		= setup_portio_remap,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 38344fb..461f5be 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -68,7 +68,7 @@ struct genapic apic_numaq = {
 	.setup_apic_routing		= numaq_setup_apic_routing,
 	.multi_timer_check		= numaq_multi_timer_check,
 	.apicid_to_node			= numaq_apicid_to_node,
-	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
+	.cpu_to_logical_apicid		= numaq_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= cpu_present_to_apicid,
 	.apicid_to_cpu_present		= apicid_to_cpu_present,
 	.setup_portio_remap		= setup_portio_remap,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 6150604..d99be2d 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -61,7 +61,7 @@ struct genapic apic_summit = {
 	.setup_apic_routing		= summit_setup_apic_routing,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= summit_apicid_to_node,
-	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
+	.cpu_to_logical_apicid		= summit_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= cpu_present_to_apicid,
 	.apicid_to_cpu_present		= apicid_to_cpu_present,
 	.setup_portio_remap		= setup_portio_remap,
-- 
1.6.0.2

