Return-Path: <linux-kernel-owner+w=401wt.eu-S1163448AbXD1SPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163448AbXD1SPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163299AbXD1SOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:14:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163298AbXD1Rwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:41 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <ak@suse.de>, "Li, Shaohua" <shaohua.li@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [5/35] x86_64: always use physical delivery mode on > 8 CPUs
Message-Id: <20070428175229.25F2D151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ingo Molnar <mingo@elte.hu>

Remove clustered APIC mode.  There's little point in the use of clustered APIC
mode, broadcasting is limited to within the cluster only, and chipsets have
bugs in this area as well.  So default to physical APIC mode when the CPU
count is large, and default to logical APIC mode when the CPU count is 8 or
smaller.

(this patch only removes the use of genapic_cluster and cleans up the
resulting genapic.c file - removal of all remaining traces of clustered
mode will be done by another patch.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/genapic.c |   71 +++++++++----------------------------------
 include/asm-x86_64/genapic.h |    4 +-
 2 files changed, 18 insertions(+), 57 deletions(-)

Index: linux/arch/x86_64/kernel/genapic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/genapic.c
+++ linux/arch/x86_64/kernel/genapic.c
@@ -11,26 +11,24 @@
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/string.h>
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
-#include <linux/module.h>
 
 #include <asm/smp.h>
 #include <asm/ipi.h>
 
-#if defined(CONFIG_ACPI)
+#ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
 #endif
 
 /* which logical CPU number maps to which CPU (physical APIC ID) */
-u8 x86_cpu_to_apicid[NR_CPUS] __read_mostly = { [0 ... NR_CPUS-1] = BAD_APICID };
+u8 x86_cpu_to_apicid[NR_CPUS] __read_mostly
+					= { [0 ... NR_CPUS-1] = BAD_APICID };
 EXPORT_SYMBOL(x86_cpu_to_apicid);
-u8 x86_cpu_to_log_apicid[NR_CPUS] = { [0 ... NR_CPUS-1] = BAD_APICID };
 
-extern struct genapic apic_cluster;
-extern struct genapic apic_flat;
-extern struct genapic apic_physflat;
+u8 x86_cpu_to_log_apicid[NR_CPUS]	= { [0 ... NR_CPUS-1] = BAD_APICID };
 
 struct genapic __read_mostly *genapic = &apic_flat;
 
@@ -39,76 +37,37 @@ struct genapic __read_mostly *genapic = 
  */
 void __init clustered_apic_check(void)
 {
-	int i;
-	u8 clusters, max_cluster;
+	unsigned int i, max_apic = 0;
 	u8 id;
-	u8 cluster_cnt[NUM_APIC_CLUSTERS];
-	int max_apic = 0;
 
 #ifdef CONFIG_ACPI
 	/*
-	 * Some x86_64 machines use physical APIC mode regardless of how many
-	 * procs/clusters are present (x86_64 ES7000 is an example).
+	 * Quirk: some x86_64 machines can only use physical APIC mode
+	 * regardless of how many processors are present (x86_64 ES7000
+	 * is an example).
 	 */
-	if (acpi_gbl_FADT.header.revision > FADT2_REVISION_ID)
-		if (acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL) {
-			genapic = &apic_cluster;
-			goto print;
-		}
+	if (acpi_gbl_FADT.header.revision > FADT2_REVISION_ID &&
+			(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL))
+		genapic = &apic_physflat;
 #endif
 
-	memset(cluster_cnt, 0, sizeof(cluster_cnt));
 	for (i = 0; i < NR_CPUS; i++) {
 		id = bios_cpu_apicid[i];
 		if (id == BAD_APICID)
 			continue;
 		if (id > max_apic)
 			max_apic = id;
-		cluster_cnt[APIC_CLUSTERID(id)]++;
 	}
 
-	/*
-	 * Don't use clustered mode on AMD platforms, default
-	 * to flat logical mode.
-	 */
- 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
-		/*
-		 * Switch to physical flat mode if more than 8 APICs
-		 * (In the case of 8 CPUs APIC ID goes from 0 to 7):
-		 */
-		if (max_apic >= 8)
-			genapic = &apic_physflat;
- 		goto print;
- 	}
-
-	clusters = 0;
-	max_cluster = 0;
-
-	for (i = 0; i < NUM_APIC_CLUSTERS; i++) {
-		if (cluster_cnt[i] > 0) {
-			++clusters;
-			if (cluster_cnt[i] > max_cluster)
-				max_cluster = cluster_cnt[i];
-		}
-	}
-
-	/*
-	 * If we have clusters <= 1 and CPUs <= 8 in cluster 0, then flat mode,
-	 * else if max_cluster <= 4 and cluster_cnt[15] == 0, clustered logical
-	 * else physical mode.
-	 * (We don't use lowest priority delivery + HW APIC IRQ steering, so
-	 * can ignore the clustered logical case and go straight to physical.)
-	 */
-	if (clusters <= 1 && max_cluster <= 8 && cluster_cnt[0] == max_cluster)
+	if (max_apic < 8)
 		genapic = &apic_flat;
 	else
-		genapic = &apic_cluster;
+		genapic = &apic_physflat;
 
-print:
 	printk(KERN_INFO "Setting APIC routing to %s\n", genapic->name);
 }
 
-/* Same for both flat and clustered. */
+/* Same for both flat and physical. */
 
 void send_IPI_self(int vector)
 {
Index: linux/include/asm-x86_64/genapic.h
===================================================================
--- linux.orig/include/asm-x86_64/genapic.h
+++ linux/include/asm-x86_64/genapic.h
@@ -29,7 +29,9 @@ struct genapic {
 	unsigned int (*phys_pkg_id)(int index_msb);
 };
 
-
 extern struct genapic *genapic;
 
+extern struct genapic apic_flat;
+extern struct genapic apic_physflat;
+
 #endif
