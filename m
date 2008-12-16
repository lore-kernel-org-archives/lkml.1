Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbYLPC3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbYLPC3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYLPCYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:30 -0500
Received: from relay2.sgi.com ([192.48.179.30]:50753 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751901AbYLPCYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:14 -0500
Message-Id: <20081216022410.530062000@polaris-admin.engr.sgi.com>
References: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:14 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 05/16] x86: update add-cpu_mask_to_apicid_and to use struct cpumask*
Content-Disposition: inline; filename=0005-x86-update-add-cpu_mask_to_apicid_and-to-use-struct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: use updated APIs

Various API updates for x86:add-cpu_mask_to_apicid_and

(Note: separate because previous patch has been "backported" to 2.6.27.)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/bigsmp/apic.h            |   10 +++++-----
 arch/x86/include/asm/es7000/apic.h            |   19 ++++++++++---------
 arch/x86/include/asm/genapic_32.h             |    4 ++--
 arch/x86/include/asm/genapic_64.h             |    4 ++--
 arch/x86/include/asm/mach-default/mach_apic.h |    8 ++++----
 arch/x86/include/asm/numaq/apic.h             |    4 ++--
 arch/x86/include/asm/summit/apic.h            |   18 +++++++++---------
 arch/x86/kernel/genapic_flat_64.c             |   21 +++++++++++----------
 arch/x86/kernel/genx2apic_cluster.c           |   10 +++++-----
 arch/x86/kernel/genx2apic_phys.c              |   10 +++++-----
 arch/x86/kernel/genx2apic_uv_x.c              |   10 +++++-----
 11 files changed, 60 insertions(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index 99f9aba..976399d 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -129,8 +129,8 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 	return apicid;
 }
 
-static inline unsigned int cpu_mask_to_apicid_and(const cpumask_t *cpumask,
-						  const cpumask_t *andmask)
+static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+						  const struct cpumask *andmask)
 {
 	int cpu;
 
@@ -138,9 +138,9 @@ static inline unsigned int cpu_mask_to_apicid_and(const cpumask_t *cpumask,
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	while ((cpu = next_cpu(-1, *cpumask)) < nr_cpu_ids)
-		if (cpu_isset(cpu, *andmask))
-			return cpu_to_logical_apicid(cpu);
+	cpu = cpumask_any_and(cpumask, andmask);
+	if (cpu < nr_cpu_ids)
+		return cpu_to_logical_apicid(cpu);
 
 	return BAD_APICID;
 }
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index f8e402b..6e6ab92 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -213,8 +213,8 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 	return apicid;
 }
 
-static inline unsigned int cpu_mask_to_apicid_and(const cpumask_t *cpumask,
-						  const cpumask_t *andmask)
+static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+						  const struct cpumask *andmask)
 {
 	int num_bits_set;
 	int num_bits_set2;
@@ -222,9 +222,9 @@ static inline unsigned int cpu_mask_to_apicid_and(const cpumask_t *cpumask,
 	int cpu;
 	int apicid = 0;
 
-	num_bits_set = cpus_weight(*cpumask);
-	num_bits_set2 = cpus_weight(*andmask);
-	num_bits_set = min_t(int, num_bits_set, num_bits_set2);
+	num_bits_set = cpumask_weight(cpumask);
+	num_bits_set2 = cpumask_weight(andmask);
+	num_bits_set = min(num_bits_set, num_bits_set2);
 	/* Return id to all */
 	if (num_bits_set >= nr_cpu_ids)
 #if defined CONFIG_ES7000_CLUSTERED_APIC
@@ -236,11 +236,12 @@ static inline unsigned int cpu_mask_to_apicid_and(const cpumask_t *cpumask,
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
-	while ((cpu = next_cpu(-1, *cpumask)) < nr_cpu_ids)
-		if (cpu_isset(cpu, *andmask)
-			apicid = cpu_to_logical_apicid(cpu);
+	cpu = cpumask_first_and(cpumask, andmask);
+	apicid = cpu_to_logical_apicid(cpu);
+
 	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, *cpumask) && cpu_isset(cpu, *andmask)) {
+		if (cpumask_test_cpu(cpu, cpumask) &&
+		    cpumask_test_cpu(cpu, andmask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)) {
diff --git a/arch/x86/include/asm/genapic_32.h b/arch/x86/include/asm/genapic_32.h
index 325298a..eed6e30 100644
--- a/arch/x86/include/asm/genapic_32.h
+++ b/arch/x86/include/asm/genapic_32.h
@@ -58,8 +58,8 @@ struct genapic {
 	unsigned (*get_apic_id)(unsigned long x);
 	unsigned long apic_id_mask;
 	unsigned int (*cpu_mask_to_apicid)(const cpumask_t *cpumask);
-	unsigned int (*cpu_mask_to_apicid_and)(const cpumask_t *cpumask,
-					       const cpumask_t *andmask);
+	unsigned int (*cpu_mask_to_apicid_and)(const struct cpumask *cpumask,
+					       const struct cpumask *andmask);
 	void (*vector_allocation_domain)(int cpu, cpumask_t *retmask);
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/include/asm/genapic_64.h b/arch/x86/include/asm/genapic_64.h
index 301c7f4..244b717 100644
--- a/arch/x86/include/asm/genapic_64.h
+++ b/arch/x86/include/asm/genapic_64.h
@@ -31,8 +31,8 @@ struct genapic {
 	void (*send_IPI_self)(int vector);
 	/* */
 	unsigned int (*cpu_mask_to_apicid)(const cpumask_t *cpumask);
-	unsigned int (*cpu_mask_to_apicid_and)(const cpumask_t *cpumask,
-					       const cpumask_t *andmask);
+	unsigned int (*cpu_mask_to_apicid_and)(const struct cpumask *cpumask,
+					       const struct cpumask *andmask);
 	unsigned int (*phys_pkg_id)(int index_msb);
 	unsigned int (*get_apic_id)(unsigned long x);
 	unsigned long (*set_apic_id)(unsigned int id);
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 229b605..df8e024 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -67,11 +67,11 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 	return cpus_addr(*cpumask)[0];
 }
 
-static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask,
-					      const cpumask_t *andmask)
+static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+						  const struct cpumask *andmask)
 {
-	unsigned long mask1 = cpus_addr(*cpumask)[0];
-	unsigned long mask2 = cpus_addr(*andmask)[0];
+	unsigned long mask1 = cpumask_bits(cpumask)[0];
+	unsigned long mask2 = cpumask_bits(andmask)[0];
 
 	return (unsigned int)(mask1 & mask2);
 }
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index abf668c..c80f00d 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -127,8 +127,8 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 	return (int) 0xF;
 }
 
-static inline unsigned int cpu_mask_to_apicid_and(const cpumask_t *cpumask,
-						  const cpumask_t *andmask)
+static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+						  const struct cpumask *andmask)
 {
 	return (int) 0xF;
 }
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index cbcc2c7..651a938 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -170,8 +170,8 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 	return apicid;
 }
 
-static inline unsigned int cpu_mask_to_apicid_and(const cpumask_t *cpumask,
-						  const cpumask_t *andmask)
+static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+						  const struct cpumask *andmask)
 {
 	int num_bits_set;
 	int num_bits_set2;
@@ -179,9 +179,9 @@ static inline unsigned int cpu_mask_to_apicid_and(const cpumask_t *cpumask,
 	int cpu;
 	int apicid = 0;
 
-	num_bits_set = cpus_weight(*cpumask);
-	num_bits_set2 = cpus_weight(*andmask);
-	num_bits_set = min_t(int, num_bits_set, num_bits_set2);
+	num_bits_set = cpumask_weight(cpumask);
+	num_bits_set2 = cpumask_weight(andmask);
+	num_bits_set = min(num_bits_set, num_bits_set2);
 	/* Return id to all */
 	if (num_bits_set >= nr_cpu_ids)
 		return 0xFF;
@@ -189,11 +189,11 @@ static inline unsigned int cpu_mask_to_apicid_and(const cpumask_t *cpumask,
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
-	while ((cpu = next_cpu(-1, *cpumask)) < nr_cpu_ids)
-		if (cpu_isset(cpu, *andmask)
-			apicid = cpu_to_logical_apicid(cpu);
+	cpu = cpumask_first_and(cpumask, andmask);
+	apicid = cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, *cpumask) && cpu_isset(cpu, *andmask)) {
+		if (cpumask_test_cpu(cpu, cpumask)
+		    && cpumask_test_cpu(cpu, andmask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)) {
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 1efecd2..c772bb1 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -158,13 +158,13 @@ static unsigned int flat_cpu_mask_to_apicid(const cpumask_t *cpumask)
 	return cpus_addr(*cpumask)[0] & APIC_ALL_CPUS;
 }
 
-static unsigned int flat_cpu_mask_to_apicid_and(const cpumask_t *cpumask,
-						const cpumask_t *andmask)
+static unsigned int flat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+						const struct cpumask *andmask)
 {
-	unsigned long mask1 = cpus_addr(*cpumask)[0] & APIC_ALL_CPUS;
-	unsigned long mask2 = cpus_addr(*andmask)[0] & APIC_ALL_CPUS;
+	unsigned long mask1 = cpumask_bits(cpumask)[0] & APIC_ALL_CPUS;
+	unsigned long mask2 = cpumask_bits(andmask)[0] & APIC_ALL_CPUS;
 
-	return (int)(mask1 & mask2);
+	return mask1 & mask2;
 }
 
 static unsigned int phys_pkg_id(int index_msb)
@@ -264,8 +264,9 @@ static unsigned int physflat_cpu_mask_to_apicid(const cpumask_t *cpumask)
 		return BAD_APICID;
 }
 
-static unsigned int physflat_cpu_mask_to_apicid_and(const cpumask_t *cpumask,
-						    const cpumask_t *andmask)
+static unsigned int
+physflat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+				const struct cpumask *andmask)
 {
 	int cpu;
 
@@ -273,9 +274,9 @@ static unsigned int physflat_cpu_mask_to_apicid_and(const cpumask_t *cpumask,
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	while ((cpu = next_cpu(-1, *cpumask)) < nr_cpu_ids)
-		if (cpu_isset(cpu, *andmask))
-			return per_cpu(x86_cpu_to_apicid, cpu);
+	cpu = cpumask_any_and(cpumask, andmask);
+	if (cpu < nr_cpu_ids)
+		return per_cpu(x86_cpu_to_apicid, cpu);
 	return BAD_APICID;
 }
 
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index fd8047f..e7d16f5 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -123,8 +123,8 @@ static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t *cpumask)
 		return BAD_APICID;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid_and(const cpumask_t *cpumask,
-						  const cpumask_t *andmask)
+static unsigned int x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+						  const struct cpumask *andmask)
 {
 	int cpu;
 
@@ -132,9 +132,9 @@ static unsigned int x2apic_cpu_mask_to_apicid_and(const cpumask_t *cpumask,
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	while ((cpu = next_cpu(-1, *cpumask)) < nr_cpu_ids)
-		if (cpu_isset(cpu, *andmask))
-			return per_cpu(x86_cpu_to_apicid, cpu);
+	cpu = cpumask_any_and(cpumask, andmask);
+	if (cpu < nr_cpu_ids)
+		return per_cpu(x86_cpu_to_apicid, cpu);
 	return BAD_APICID;
 }
 
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index d5578bb..9d0386c 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -122,8 +122,8 @@ static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t *cpumask)
 		return BAD_APICID;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid_and(const cpumask_t *cpumask,
-						  const cpumask_t *andmask)
+static unsigned int x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+						  const struct cpumask *andmask)
 {
 	int cpu;
 
@@ -131,9 +131,9 @@ static unsigned int x2apic_cpu_mask_to_apicid_and(const cpumask_t *cpumask,
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	while ((cpu = next_cpu(-1, *cpumask)) < nr_cpu_ids)
-		if (cpu_isset(cpu, *andmask))
-			return per_cpu(x86_cpu_to_apicid, cpu);
+	cpu = cpumask_any_and(cpumask, andmask);
+	if (cpu < nr_cpu_ids)
+		return per_cpu(x86_cpu_to_apicid, cpu);
 	return BAD_APICID;
 }
 
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 53bd257..22596ec 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -179,8 +179,8 @@ static unsigned int uv_cpu_mask_to_apicid(const cpumask_t *cpumask)
 		return BAD_APICID;
 }
 
-static unsigned int uv_cpu_mask_to_apicid_and(const cpumask_t *cpumask,
-					      const cpumask_t *andmask)
+static unsigned int uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+					      const struct cpumask *andmask)
 {
 	int cpu;
 
@@ -188,9 +188,9 @@ static unsigned int uv_cpu_mask_to_apicid_and(const cpumask_t *cpumask,
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	while ((cpu = next_cpu(-1, *cpumask)) < nr_cpu_ids)
-		if (cpu_isset(cpu, *andmask))
-			return per_cpu(x86_cpu_to_apicid, cpu);
+	cpu = cpumask_any_and(cpumask, andmask);
+	if (cpu < nr_cpu_ids)
+		return per_cpu(x86_cpu_to_apicid, cpu);
 	return BAD_APICID;
 }
 
-- 
1.6.0

-- 
