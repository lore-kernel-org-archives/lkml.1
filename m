Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0BCTAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:00:52 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:59338 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab0BCTAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:00:50 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/3] microblaze: remove early_init_dt_scan_cpus() and
	phyp_dump_*()
To: linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       monstr@monstr.eu, sfr@canb.auug.org.au, jeremy.kerr@canonical.com,
       benh@kernel.crashing.org
Date: Wed, 03 Feb 2010 12:00:47 -0700
Message-ID: <20100203190040.26862.63125.stgit@angua>
In-Reply-To: <20100203185753.26862.6818.stgit@angua>
References: <20100203185753.26862.6818.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microblaze only has one CPU, it isn't SMP at all.  early_init_dt_scan_cpus()
is effectively just a no-op, so remove it.

Microblaze doesn't support hypervisor assisted dump either, so the phyp stuff
can also go.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

---

v2 - added phyp code removal

 arch/microblaze/kernel/prom.c |  153 -----------------------------------------
 1 files changed, 0 insertions(+), 153 deletions(-)

diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index 6eff83a..cd158ef 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -47,67 +47,6 @@ struct device_node *of_chosen;
 
 #define early_init_dt_scan_drconf_memory(node) 0
 
-static int __init early_init_dt_scan_cpus(unsigned long node,
-					  const char *uname, int depth,
-					  void *data)
-{
-	static int logical_cpuid;
-	char *type = of_get_flat_dt_prop(node, "device_type", NULL);
-	const u32 *intserv;
-	int i, nthreads;
-	int found = 0;
-
-	/* We are scanning "cpu" nodes only */
-	if (type == NULL || strcmp(type, "cpu") != 0)
-		return 0;
-
-	/* Get physical cpuid */
-	intserv = of_get_flat_dt_prop(node, "reg", NULL);
-	nthreads = 1;
-
-	/*
-	 * Now see if any of these threads match our boot cpu.
-	 * NOTE: This must match the parsing done in smp_setup_cpu_maps.
-	 */
-	for (i = 0; i < nthreads; i++) {
-		/*
-		 * version 2 of the kexec param format adds the phys cpuid of
-		 * booted proc.
-		 */
-		if (initial_boot_params && initial_boot_params->version >= 2) {
-			if (intserv[i] ==
-					initial_boot_params->boot_cpuid_phys) {
-				found = 1;
-				break;
-			}
-		} else {
-			/*
-			 * Check if it's the boot-cpu, set it's hw index now,
-			 * unfortunately this format did not support booting
-			 * off secondary threads.
-			 */
-			if (of_get_flat_dt_prop(node,
-					"linux,boot-cpu", NULL) != NULL) {
-				found = 1;
-				break;
-			}
-		}
-
-#ifdef CONFIG_SMP
-		/* logical cpu id is always 0 on UP kernels */
-		logical_cpuid++;
-#endif
-	}
-
-	if (found) {
-		pr_debug("boot cpu: logical %d physical %d\n", logical_cpuid,
-			intserv[i]);
-		boot_cpuid = logical_cpuid;
-	}
-
-	return 0;
-}
-
 void __init early_init_dt_scan_chosen_arch(unsigned long node)
 {
 	/* No Microblaze specific code here */
@@ -163,86 +102,6 @@ static int __init early_init_dt_scan_memory(unsigned long node,
 	return 0;
 }
 
-#ifdef CONFIG_PHYP_DUMP
-/**
- * phyp_dump_calculate_reserve_size() - reserve variable boot area 5% or arg
- *
- * Function to find the largest size we need to reserve
- * during early boot process.
- *
- * It either looks for boot param and returns that OR
- * returns larger of 256 or 5% rounded down to multiples of 256MB.
- *
- */
-static inline unsigned long phyp_dump_calculate_reserve_size(void)
-{
-	unsigned long tmp;
-
-	if (phyp_dump_info->reserve_bootvar)
-		return phyp_dump_info->reserve_bootvar;
-
-	/* divide by 20 to get 5% of value */
-	tmp = lmb_end_of_DRAM();
-	do_div(tmp, 20);
-
-	/* round it down in multiples of 256 */
-	tmp = tmp & ~0x0FFFFFFFUL;
-
-	return (tmp > PHYP_DUMP_RMR_END ? tmp : PHYP_DUMP_RMR_END);
-}
-
-/**
- * phyp_dump_reserve_mem() - reserve all not-yet-dumped mmemory
- *
- * This routine may reserve memory regions in the kernel only
- * if the system is supported and a dump was taken in last
- * boot instance or if the hardware is supported and the
- * scratch area needs to be setup. In other instances it returns
- * without reserving anything. The memory in case of dump being
- * active is freed when the dump is collected (by userland tools).
- */
-static void __init phyp_dump_reserve_mem(void)
-{
-	unsigned long base, size;
-	unsigned long variable_reserve_size;
-
-	if (!phyp_dump_info->phyp_dump_configured) {
-		printk(KERN_ERR "Phyp-dump not supported on this hardware\n");
-		return;
-	}
-
-	if (!phyp_dump_info->phyp_dump_at_boot) {
-		printk(KERN_INFO "Phyp-dump disabled at boot time\n");
-		return;
-	}
-
-	variable_reserve_size = phyp_dump_calculate_reserve_size();
-
-	if (phyp_dump_info->phyp_dump_is_active) {
-		/* Reserve *everything* above RMR.Area freed by userland tools*/
-		base = variable_reserve_size;
-		size = lmb_end_of_DRAM() - base;
-
-		/* XXX crashed_ram_end is wrong, since it may be beyond
-		 * the memory_limit, it will need to be adjusted. */
-		lmb_reserve(base, size);
-
-		phyp_dump_info->init_reserve_start = base;
-		phyp_dump_info->init_reserve_size = size;
-	} else {
-		size = phyp_dump_info->cpu_state_size +
-			phyp_dump_info->hpte_region_size +
-			variable_reserve_size;
-		base = lmb_end_of_DRAM() - size;
-		lmb_reserve(base, size);
-		phyp_dump_info->init_reserve_start = base;
-		phyp_dump_info->init_reserve_size = size;
-	}
-}
-#else
-static inline void __init phyp_dump_reserve_mem(void) {}
-#endif /* CONFIG_PHYP_DUMP  && CONFIG_PPC_RTAS */
-
 #ifdef CONFIG_EARLY_PRINTK
 /* MS this is Microblaze specifig function */
 static int __init early_init_dt_scan_serial(unsigned long node,
@@ -284,11 +143,6 @@ void __init early_init_devtree(void *params)
 	/* Setup flat device-tree pointer */
 	initial_boot_params = params;
 
-#ifdef CONFIG_PHYP_DUMP
-	/* scan tree to see if dump occured during last boot */
-	of_scan_flat_dt(early_init_dt_scan_phyp_dump, NULL);
-#endif
-
 	/* Retrieve various informations from the /chosen node of the
 	 * device-tree, including the platform type, initrd location and
 	 * size, TCE reserve, and more ...
@@ -308,13 +162,6 @@ void __init early_init_devtree(void *params)
 
 	pr_debug("Phys. mem: %lx\n", (unsigned long) lmb_phys_mem_size());
 
-	pr_debug("Scanning CPUs ...\n");
-
-	/* Retreive CPU related informations from the flat tree
-	 * (altivec support, boot CPU ID, ...)
-	 */
-	of_scan_flat_dt(early_init_dt_scan_cpus, NULL);
-
 	pr_debug(" <- early_init_devtree()\n");
 }
 

