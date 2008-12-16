Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYLPCZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYLPCZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYLPCYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:18 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40530 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751579AbYLPCYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:13 -0500
Message-Id: <20081216022410.402575000@polaris-admin.engr.sgi.com>
References: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:13 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 04/16] x86: Add cpu_mask_to_apicid_and
Content-Disposition: inline; filename=0004-x86-Add-cpu_mask_to_apicid_and.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: new API

Add a helper function that takes two cpumask's, and's them and then
returns the apicid of the result.  This removes a need in io_apic.c
that uses a temporary cpumask to hold (mask & cfg->domain).

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/bigsmp/apic.h            |   16 ++++++++
 arch/x86/include/asm/es7000/apic.h            |   47 +++++++++++++++++++++++++
 arch/x86/include/asm/genapic_32.h             |    3 ++
 arch/x86/include/asm/genapic_64.h             |    2 +
 arch/x86/include/asm/mach-default/mach_apic.h |   10 +++++
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 +
 arch/x86/include/asm/numaq/apic.h             |    6 +++
 arch/x86/include/asm/summit/apic.h            |   39 ++++++++++++++++++++
 arch/x86/kernel/genapic_flat_64.c             |   26 ++++++++++++++
 arch/x86/kernel/genx2apic_cluster.c           |   16 ++++++++
 arch/x86/kernel/genx2apic_phys.c              |   16 ++++++++
 arch/x86/kernel/genx2apic_uv_x.c              |   16 ++++++++
 12 files changed, 198 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index dc6225c..99f9aba 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -129,6 +129,22 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 	return apicid;
 }
 
+static inline unsigned int cpu_mask_to_apicid_and(const cpumask_t *cpumask,
+						  const cpumask_t *andmask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	while ((cpu = next_cpu(-1, *cpumask)) < nr_cpu_ids)
+		if (cpu_isset(cpu, *andmask))
+			return cpu_to_logical_apicid(cpu);
+
+	return BAD_APICID;
+}
+
 static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
 {
 	return cpuid_apic >> index_msb;
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index e65eee7..f8e402b 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -213,6 +213,53 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 	return apicid;
 }
 
+static inline unsigned int cpu_mask_to_apicid_and(const cpumask_t *cpumask,
+						  const cpumask_t *andmask)
+{
+	int num_bits_set;
+	int num_bits_set2;
+	int cpus_found = 0;
+	int cpu;
+	int apicid = 0;
+
+	num_bits_set = cpus_weight(*cpumask);
+	num_bits_set2 = cpus_weight(*andmask);
+	num_bits_set = min_t(int, num_bits_set, num_bits_set2);
+	/* Return id to all */
+	if (num_bits_set >= nr_cpu_ids)
+#if defined CONFIG_ES7000_CLUSTERED_APIC
+		return 0xFF;
+#else
+		return cpu_to_logical_apicid(0);
+#endif
+	/*
+	 * The cpus in the mask must all be on the apic cluster.  If are not
+	 * on the same apicid cluster return default value of TARGET_CPUS.
+	 */
+	while ((cpu = next_cpu(-1, *cpumask)) < nr_cpu_ids)
+		if (cpu_isset(cpu, *andmask)
+			apicid = cpu_to_logical_apicid(cpu);
+	while (cpus_found < num_bits_set) {
+		if (cpu_isset(cpu, *cpumask) && cpu_isset(cpu, *andmask)) {
+			int new_apicid = cpu_to_logical_apicid(cpu);
+			if (apicid_cluster(apicid) !=
+					apicid_cluster(new_apicid)) {
+				printk(KERN_WARNING
+					"%s: Not a valid mask!\n", __func__);
+#if defined CONFIG_ES7000_CLUSTERED_APIC
+				return 0xFF;
+#else
+				return cpu_to_logical_apicid(0);
+#endif
+			}
+			apicid = new_apicid;
+			cpus_found++;
+		}
+		cpu++;
+	}
+	return apicid;
+}
+
 static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
 {
 	return cpuid_apic >> index_msb;
diff --git a/arch/x86/include/asm/genapic_32.h b/arch/x86/include/asm/genapic_32.h
index b21ed21..325298a 100644
--- a/arch/x86/include/asm/genapic_32.h
+++ b/arch/x86/include/asm/genapic_32.h
@@ -58,6 +58,8 @@ struct genapic {
 	unsigned (*get_apic_id)(unsigned long x);
 	unsigned long apic_id_mask;
 	unsigned int (*cpu_mask_to_apicid)(const cpumask_t *cpumask);
+	unsigned int (*cpu_mask_to_apicid_and)(const cpumask_t *cpumask,
+					       const cpumask_t *andmask);
 	void (*vector_allocation_domain)(int cpu, cpumask_t *retmask);
 
 #ifdef CONFIG_SMP
@@ -115,6 +117,7 @@ struct genapic {
 	APICFUNC(get_apic_id)				\
 	.apic_id_mask = APIC_ID_MASK,			\
 	APICFUNC(cpu_mask_to_apicid)			\
+	APICFUNC(cpu_mask_to_apicid_and)		\
 	APICFUNC(vector_allocation_domain)		\
 	APICFUNC(acpi_madt_oem_check)			\
 	IPIFUNC(send_IPI_mask)				\
diff --git a/arch/x86/include/asm/genapic_64.h b/arch/x86/include/asm/genapic_64.h
index a020e7d..301c7f4 100644
--- a/arch/x86/include/asm/genapic_64.h
+++ b/arch/x86/include/asm/genapic_64.h
@@ -31,6 +31,8 @@ struct genapic {
 	void (*send_IPI_self)(int vector);
 	/* */
 	unsigned int (*cpu_mask_to_apicid)(const cpumask_t *cpumask);
+	unsigned int (*cpu_mask_to_apicid_and)(const cpumask_t *cpumask,
+					       const cpumask_t *andmask);
 	unsigned int (*phys_pkg_id)(int index_msb);
 	unsigned int (*get_apic_id)(unsigned long x);
 	unsigned long (*set_apic_id)(unsigned int id);
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index c18896b..229b605 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -28,6 +28,7 @@ static inline const cpumask_t *target_cpus(void)
 #define apic_id_registered (genapic->apic_id_registered)
 #define init_apic_ldr (genapic->init_apic_ldr)
 #define cpu_mask_to_apicid (genapic->cpu_mask_to_apicid)
+#define cpu_mask_to_apicid_and (genapic->cpu_mask_to_apicid_and)
 #define phys_pkg_id	(genapic->phys_pkg_id)
 #define vector_allocation_domain    (genapic->vector_allocation_domain)
 #define read_apic_id()  (GET_APIC_ID(apic_read(APIC_ID)))
@@ -66,6 +67,15 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 	return cpus_addr(*cpumask)[0];
 }
 
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask,
+					      const cpumask_t *andmask)
+{
+	unsigned long mask1 = cpus_addr(*cpumask)[0];
+	unsigned long mask2 = cpus_addr(*andmask)[0];
+
+	return (unsigned int)(mask1 & mask2);
+}
+
 static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
 {
 	return cpuid_apic >> index_msb;
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index e430f47..48553e9 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -24,6 +24,7 @@
 #define check_phys_apicid_present (genapic->check_phys_apicid_present)
 #define check_apicid_used (genapic->check_apicid_used)
 #define cpu_mask_to_apicid (genapic->cpu_mask_to_apicid)
+#define cpu_mask_to_apicid_and (genapic->cpu_mask_to_apicid_and)
 #define vector_allocation_domain (genapic->vector_allocation_domain)
 #define enable_apic_mode (genapic->enable_apic_mode)
 #define phys_pkg_id (genapic->phys_pkg_id)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index 1df7ebe..abf668c 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -127,6 +127,12 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 	return (int) 0xF;
 }
 
+static inline unsigned int cpu_mask_to_apicid_and(const cpumask_t *cpumask,
+						  const cpumask_t *andmask)
+{
+	return (int) 0xF;
+}
+
 /* No NUMA-Q box has a HT CPU, but it can't hurt to use the default code. */
 static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
 {
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 437dc83..cbcc2c7 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -170,6 +170,45 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 	return apicid;
 }
 
+static inline unsigned int cpu_mask_to_apicid_and(const cpumask_t *cpumask,
+						  const cpumask_t *andmask)
+{
+	int num_bits_set;
+	int num_bits_set2;
+	int cpus_found = 0;
+	int cpu;
+	int apicid = 0;
+
+	num_bits_set = cpus_weight(*cpumask);
+	num_bits_set2 = cpus_weight(*andmask);
+	num_bits_set = min_t(int, num_bits_set, num_bits_set2);
+	/* Return id to all */
+	if (num_bits_set >= nr_cpu_ids)
+		return 0xFF;
+	/*
+	 * The cpus in the mask must all be on the apic cluster.  If are not
+	 * on the same apicid cluster return default value of TARGET_CPUS.
+	 */
+	while ((cpu = next_cpu(-1, *cpumask)) < nr_cpu_ids)
+		if (cpu_isset(cpu, *andmask)
+			apicid = cpu_to_logical_apicid(cpu);
+	while (cpus_found < num_bits_set) {
+		if (cpu_isset(cpu, *cpumask) && cpu_isset(cpu, *andmask)) {
+			int new_apicid = cpu_to_logical_apicid(cpu);
+			if (apicid_cluster(apicid) !=
+					apicid_cluster(new_apicid)) {
+				printk(KERN_WARNING
+					"%s: Not a valid mask!\n", __func__);
+				return 0xFF;
+			}
+			apicid = apicid | new_apicid;
+			cpus_found++;
+		}
+		cpu++;
+	}
+	return apicid;
+}
+
 /* cpuid returns the value latched in the HW at reset, not the APIC ID
  * register's value.  For any box whose BIOS changes APIC IDs, like
  * clustered APIC systems, we must use hard_smp_processor_id.
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 50eebd0..1efecd2 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -158,6 +158,15 @@ static unsigned int flat_cpu_mask_to_apicid(const cpumask_t *cpumask)
 	return cpus_addr(*cpumask)[0] & APIC_ALL_CPUS;
 }
 
+static unsigned int flat_cpu_mask_to_apicid_and(const cpumask_t *cpumask,
+						const cpumask_t *andmask)
+{
+	unsigned long mask1 = cpus_addr(*cpumask)[0] & APIC_ALL_CPUS;
+	unsigned long mask2 = cpus_addr(*andmask)[0] & APIC_ALL_CPUS;
+
+	return (int)(mask1 & mask2);
+}
+
 static unsigned int phys_pkg_id(int index_msb)
 {
 	return hard_smp_processor_id() >> index_msb;
@@ -178,6 +187,7 @@ struct genapic apic_flat =  {
 	.send_IPI_mask_allbutself = flat_send_IPI_mask_allbutself,
 	.send_IPI_self = apic_send_IPI_self,
 	.cpu_mask_to_apicid = flat_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and = flat_cpu_mask_to_apicid_and,
 	.phys_pkg_id = phys_pkg_id,
 	.get_apic_id = get_apic_id,
 	.set_apic_id = set_apic_id,
@@ -254,6 +264,21 @@ static unsigned int physflat_cpu_mask_to_apicid(const cpumask_t *cpumask)
 		return BAD_APICID;
 }
 
+static unsigned int physflat_cpu_mask_to_apicid_and(const cpumask_t *cpumask,
+						    const cpumask_t *andmask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	while ((cpu = next_cpu(-1, *cpumask)) < nr_cpu_ids)
+		if (cpu_isset(cpu, *andmask))
+			return per_cpu(x86_cpu_to_apicid, cpu);
+	return BAD_APICID;
+}
+
 struct genapic apic_physflat =  {
 	.name = "physical flat",
 	.acpi_madt_oem_check = physflat_acpi_madt_oem_check,
@@ -269,6 +294,7 @@ struct genapic apic_physflat =  {
 	.send_IPI_mask_allbutself = physflat_send_IPI_mask_allbutself,
 	.send_IPI_self = apic_send_IPI_self,
 	.cpu_mask_to_apicid = physflat_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and = physflat_cpu_mask_to_apicid_and,
 	.phys_pkg_id = phys_pkg_id,
 	.get_apic_id = get_apic_id,
 	.set_apic_id = set_apic_id,
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index f5fa9a9..fd8047f 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -123,6 +123,21 @@ static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t *cpumask)
 		return BAD_APICID;
 }
 
+static unsigned int x2apic_cpu_mask_to_apicid_and(const cpumask_t *cpumask,
+						  const cpumask_t *andmask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	while ((cpu = next_cpu(-1, *cpumask)) < nr_cpu_ids)
+		if (cpu_isset(cpu, *andmask))
+			return per_cpu(x86_cpu_to_apicid, cpu);
+	return BAD_APICID;
+}
+
 static unsigned int get_apic_id(unsigned long x)
 {
 	unsigned int id;
@@ -172,6 +187,7 @@ struct genapic apic_x2apic_cluster = {
 	.send_IPI_mask_allbutself = x2apic_send_IPI_mask_allbutself,
 	.send_IPI_self = x2apic_send_IPI_self,
 	.cpu_mask_to_apicid = x2apic_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and = x2apic_cpu_mask_to_apicid_and,
 	.phys_pkg_id = phys_pkg_id,
 	.get_apic_id = get_apic_id,
 	.set_apic_id = set_apic_id,
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 41c27b2..d5578bb 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -122,6 +122,21 @@ static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t *cpumask)
 		return BAD_APICID;
 }
 
+static unsigned int x2apic_cpu_mask_to_apicid_and(const cpumask_t *cpumask,
+						  const cpumask_t *andmask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	while ((cpu = next_cpu(-1, *cpumask)) < nr_cpu_ids)
+		if (cpu_isset(cpu, *andmask))
+			return per_cpu(x86_cpu_to_apicid, cpu);
+	return BAD_APICID;
+}
+
 static unsigned int get_apic_id(unsigned long x)
 {
 	unsigned int id;
@@ -168,6 +183,7 @@ struct genapic apic_x2apic_phys = {
 	.send_IPI_mask_allbutself = x2apic_send_IPI_mask_allbutself,
 	.send_IPI_self = x2apic_send_IPI_self,
 	.cpu_mask_to_apicid = x2apic_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and = x2apic_cpu_mask_to_apicid_and,
 	.phys_pkg_id = phys_pkg_id,
 	.get_apic_id = get_apic_id,
 	.set_apic_id = set_apic_id,
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 0106594..53bd257 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -179,6 +179,21 @@ static unsigned int uv_cpu_mask_to_apicid(const cpumask_t *cpumask)
 		return BAD_APICID;
 }
 
+static unsigned int uv_cpu_mask_to_apicid_and(const cpumask_t *cpumask,
+					      const cpumask_t *andmask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	while ((cpu = next_cpu(-1, *cpumask)) < nr_cpu_ids)
+		if (cpu_isset(cpu, *andmask))
+			return per_cpu(x86_cpu_to_apicid, cpu);
+	return BAD_APICID;
+}
+
 static unsigned int get_apic_id(unsigned long x)
 {
 	unsigned int id;
@@ -229,6 +244,7 @@ struct genapic apic_x2apic_uv_x = {
 	.send_IPI_mask_allbutself = uv_send_IPI_mask_allbutself,
 	.send_IPI_self = uv_send_IPI_self,
 	.cpu_mask_to_apicid = uv_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and = uv_cpu_mask_to_apicid_and,
 	.phys_pkg_id = phys_pkg_id,
 	.get_apic_id = get_apic_id,
 	.set_apic_id = set_apic_id,
-- 
1.6.0

-- 
