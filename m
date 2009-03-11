Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZCKGkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZCKGkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 02:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZCKGkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 02:40:36 -0400
Received: from ozlabs.org ([203.10.76.45]:33811 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbZCKGkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 02:40:36 -0400
CC: linux-kernel@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
CC: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 11 Mar 2009 17:02:07 +1030
Subject: [PATCH 1/2] x86: make voyager_phys_cpu_present_map static unsigned long.
Message-Id: <20090311064033.88201DE14D@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup, remove cpumask_t

Instead of replacing voyager_phys_cpu_present_map with a cpumask_var_t,
let's make it an unsigned long as assumed in various places anyway.

Also delete incorrect comment on external usage.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: James.Bottomley@HansenPartnership.com
---
 arch/x86/mach-voyager/voyager_smp.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -63,9 +63,8 @@ static int voyager_extended_cpus = 1;
 /* Used for the invalidate map that's also checked in the spinlock */
 static volatile unsigned long smp_invalidate_needed;
 
-/* Bitmask of CPUs present in the system - exported by i386_syms.c, used
- * by scheduler but indexed physically */
-static cpumask_t voyager_phys_cpu_present_map = CPU_MASK_NONE;
+/* Set from extended CMOS in find_smp_config */
+static unsigned long voyager_phys_cpu_present_map;
 
 /* The internal functions */
 static void send_CPI(__u32 cpuset, __u8 cpi);
@@ -349,6 +348,7 @@ void __init find_smp_config(void)
 void __init find_smp_config(void)
 {
 	int i;
+	unsigned long present;
 
 	boot_cpu_id = hard_smp_processor_id();
 
@@ -366,19 +366,24 @@ void __init find_smp_config(void)
 	/* set up everything for just this CPU, we can alter
 	 * this as we start the other CPUs later */
 	/* now get the CPU disposition from the extended CMOS */
-	cpus_addr(voyager_phys_cpu_present_map)[0] =
+	voyager_phys_cpu_present_map =
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK);
-	cpus_addr(voyager_phys_cpu_present_map)[0] |=
+	voyager_phys_cpu_present_map |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK + 1) << 8;
-	cpus_addr(voyager_phys_cpu_present_map)[0] |=
+	voyager_phys_cpu_present_map |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK +
 				       2) << 16;
-	cpus_addr(voyager_phys_cpu_present_map)[0] |=
+	voyager_phys_cpu_present_map |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK +
 				       3) << 24;
-	init_cpu_possible(&voyager_phys_cpu_present_map);
+	for (i = 0; i < 32; i++) {
+		if (test_bit(i, &voyager_phys_cpu_present_map))
+			set_cpu_possible(i, true);
+	}
+
 	printk("VOYAGER SMP: voyager_phys_cpu_present_map = 0x%lx\n",
-	       cpus_addr(voyager_phys_cpu_present_map)[0]);
+	       voyager_phys_cpu_present_map);
+
 	/* Here we set up the VIC to enable SMP */
 	/* enable the CPIs by writing the base vector to their register */
 	outb(VIC_DEFAULT_CPI_BASE, VIC_CPI_BASE_REGISTER);
@@ -628,15 +633,14 @@ void __init smp_boot_cpus(void)
 		/* now that the cat has probed the Voyager System Bus, sanity
 		 * check the cpu map */
 		if (((voyager_quad_processors | voyager_extended_vic_processors)
-		     & cpus_addr(voyager_phys_cpu_present_map)[0]) !=
-		    cpus_addr(voyager_phys_cpu_present_map)[0]) {
+		     & voyager_phys_cpu_present_map) !=
+		    voyager_phys_cpu_present_map) {
 			/* should panic */
 			printk("\n\n***WARNING*** "
 			       "Sanity check of CPU present map FAILED\n");
 		}
 	} else if (voyager_level == 4)
-		voyager_extended_vic_processors =
-		    cpus_addr(voyager_phys_cpu_present_map)[0];
+		voyager_extended_vic_processors = voyager_phys_cpu_present_map;
 
 	/* this sets up the idle task to run on the current cpu */
 	voyager_extended_cpus = 1;
@@ -670,7 +674,7 @@ void __init smp_boot_cpus(void)
 	/* loop over all the extended VIC CPUs and boot them.  The
 	 * Quad CPUs must be bootstrapped by their extended VIC cpu */
 	for (i = 0; i < nr_cpu_ids; i++) {
-		if (i == boot_cpu_id || !cpu_isset(i, voyager_phys_cpu_present_map))
+		if (i == boot_cpu_id || !test_bit(i, &voyager_phys_cpu_present_map))
 			continue;
 		do_boot_cpu(i);
 		/* This udelay seems to be needed for the Quad boots

