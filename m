Return-Path: <linux-kernel-owner+w=401wt.eu-S1163280AbXD1Rwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163280AbXD1Rwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163293AbXD1Rwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:52:34 -0400
Received: from mx1.suse.de ([195.135.220.2]:34402 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163280AbXD1Rwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:32 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <ak@suse.de>, "Li, Shaohua" <shaohua.li@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [6/35] x86_64: remove clustered APIC mode
Message-Id: <20070428175230.39393151F6@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ingo Molnar <mingo@elte.hu>

Remove now unused clustered APIC mode code.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/Makefile          |    3 
 arch/x86_64/kernel/genapic_cluster.c |  137 -----------------------------------
 2 files changed, 1 insertion(+), 139 deletions(-)

Index: linux/arch/x86_64/kernel/Makefile
===================================================================
--- linux.orig/arch/x86_64/kernel/Makefile
+++ linux/arch/x86_64/kernel/Makefile
@@ -21,8 +21,7 @@ obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
 obj-$(CONFIG_SMP)		+= smp.o smpboot.o trampoline.o tsc_sync.o
 obj-y				+= apic.o  nmi.o
-obj-y				+= io_apic.o mpparse.o \
-		genapic.o genapic_cluster.o genapic_flat.o
+obj-y				+= io_apic.o mpparse.o genapic.o genapic_flat.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_PM)		+= suspend.o
Index: linux/arch/x86_64/kernel/genapic_cluster.c
===================================================================
--- linux.orig/arch/x86_64/kernel/genapic_cluster.c
+++ /dev/null
@@ -1,137 +0,0 @@
-/*
- * Copyright 2004 James Cleverdon, IBM.
- * Subject to the GNU Public License, v.2
- *
- * Clustered APIC subarch code.  Up to 255 CPUs, physical delivery.
- * (A more realistic maximum is around 230 CPUs.)
- *
- * Hacked for x86-64 by James Cleverdon from i386 architecture code by
- * Martin Bligh, Andi Kleen, James Bottomley, John Stultz, and
- * James Cleverdon.
- */
-#include <linux/threads.h>
-#include <linux/cpumask.h>
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/ctype.h>
-#include <linux/init.h>
-#include <asm/smp.h>
-#include <asm/ipi.h>
-
-
-/*
- * Set up the logical destination ID.
- *
- * Intel recommends to set DFR, LDR and TPR before enabling
- * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
- * document number 292116).  So here it goes...
- */
-static void cluster_init_apic_ldr(void)
-{
-	unsigned long val, id;
-	long i, count;
-	u8 lid;
-	u8 my_id = hard_smp_processor_id();
-	u8 my_cluster = APIC_CLUSTER(my_id);
-
-	/* Create logical APIC IDs by counting CPUs already in cluster. */
-	for (count = 0, i = NR_CPUS; --i >= 0; ) {
-		lid = x86_cpu_to_log_apicid[i];
-		if (lid != BAD_APICID && APIC_CLUSTER(lid) == my_cluster)
-			++count;
-	}
-	/*
-	 * We only have a 4 wide bitmap in cluster mode.  There's no way
-	 * to get above 60 CPUs and still give each one it's own bit.
-	 * But, we're using physical IRQ delivery, so we don't care.
-	 * Use bit 3 for the 4th through Nth CPU in each cluster.
-	 */
-	if (count >= XAPIC_DEST_CPUS_SHIFT)
-		count = 3;
-	id = my_cluster | (1UL << count);
-	x86_cpu_to_log_apicid[smp_processor_id()] = id;
-	apic_write(APIC_DFR, APIC_DFR_CLUSTER);
-	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
-	val |= SET_APIC_LOGICAL_ID(id);
-	apic_write(APIC_LDR, val);
-}
-
-/* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
-
-static cpumask_t cluster_target_cpus(void)
-{
-	return cpumask_of_cpu(0);
-}
-
-static cpumask_t cluster_vector_allocation_domain(int cpu)
-{
-	cpumask_t domain = CPU_MASK_NONE;
-	cpu_set(cpu, domain);
-	return domain;
-}
-
-static void cluster_send_IPI_mask(cpumask_t mask, int vector)
-{
-	send_IPI_mask_sequence(mask, vector);
-}
-
-static void cluster_send_IPI_allbutself(int vector)
-{
-	cpumask_t mask = cpu_online_map;
-
-	cpu_clear(smp_processor_id(), mask);
-
-	if (!cpus_empty(mask))
-		cluster_send_IPI_mask(mask, vector);
-}
-
-static void cluster_send_IPI_all(int vector)
-{
-	cluster_send_IPI_mask(cpu_online_map, vector);
-}
-
-static int cluster_apic_id_registered(void)
-{
-	return 1;
-}
-
-static unsigned int cluster_cpu_mask_to_apicid(cpumask_t cpumask)
-{
-	int cpu;
-
-	/*
-	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
-	 * May as well be the first.
-	 */
-	cpu = first_cpu(cpumask);
-	if ((unsigned)cpu < NR_CPUS)
-		return x86_cpu_to_apicid[cpu];
-	else
-		return BAD_APICID;
-}
-
-/* cpuid returns the value latched in the HW at reset, not the APIC ID
- * register's value.  For any box whose BIOS changes APIC IDs, like
- * clustered APIC systems, we must use hard_smp_processor_id.
- *
- * See Intel's IA-32 SW Dev's Manual Vol2 under CPUID.
- */
-static unsigned int phys_pkg_id(int index_msb)
-{
-	return hard_smp_processor_id() >> index_msb;
-}
-
-struct genapic apic_cluster = {
-	.name = "clustered",
-	.int_delivery_mode = dest_Fixed,
-	.int_dest_mode = (APIC_DEST_PHYSICAL != 0),
-	.target_cpus = cluster_target_cpus,
-	.vector_allocation_domain = cluster_vector_allocation_domain,
-	.apic_id_registered = cluster_apic_id_registered,
-	.init_apic_ldr = cluster_init_apic_ldr,
-	.send_IPI_all = cluster_send_IPI_all,
-	.send_IPI_allbutself = cluster_send_IPI_allbutself,
-	.send_IPI_mask = cluster_send_IPI_mask,
-	.cpu_mask_to_apicid = cluster_cpu_mask_to_apicid,
-	.phys_pkg_id = phys_pkg_id,
-};
