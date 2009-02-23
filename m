Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbZBWVfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbZBWVfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 16:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZBWVew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 16:34:52 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34029 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617AbZBWVew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 16:34:52 -0500
Subject: [PATCH 2.6.29-rc6] x86/Voyager: fix compile by lifting the
	degeneracy of phys_cpu_present_map
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 21:34:47 +0000
Message-Id: <1235424887.9366.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was changed to a physmap_t giving a clashing symbol redefinition,
but actually using a physmap_t consumes rather a lot of space on x86, so
stick with a private copy renamed with a voyager_ prefix and made
static.  Nothing outside of the voyager code uses it, anyway.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/mach-voyager/voyager_smp.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 7ffcdee..b9cc84a 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -65,7 +65,7 @@ static volatile unsigned long smp_invalidate_needed;
 
 /* Bitmask of CPUs present in the system - exported by i386_syms.c, used
  * by scheduler but indexed physically */
-cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
+static cpumask_t voyager_phys_cpu_present_map = CPU_MASK_NONE;
 
 /* The internal functions */
 static void send_CPI(__u32 cpuset, __u8 cpi);
@@ -366,19 +366,19 @@ void __init find_smp_config(void)
 	/* set up everything for just this CPU, we can alter
 	 * this as we start the other CPUs later */
 	/* now get the CPU disposition from the extended CMOS */
-	cpus_addr(phys_cpu_present_map)[0] =
+	cpus_addr(voyager_phys_cpu_present_map)[0] =
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK);
-	cpus_addr(phys_cpu_present_map)[0] |=
+	cpus_addr(voyager_phys_cpu_present_map)[0] |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK + 1) << 8;
-	cpus_addr(phys_cpu_present_map)[0] |=
+	cpus_addr(voyager_phys_cpu_present_map)[0] |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK +
 				       2) << 16;
-	cpus_addr(phys_cpu_present_map)[0] |=
+	cpus_addr(voyager_phys_cpu_present_map)[0] |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK +
 				       3) << 24;
-	init_cpu_possible(&phys_cpu_present_map);
-	printk("VOYAGER SMP: phys_cpu_present_map = 0x%lx\n",
-	       cpus_addr(phys_cpu_present_map)[0]);
+	init_cpu_possible(&voyager_phys_cpu_present_map);
+	printk("VOYAGER SMP: voyager_phys_cpu_present_map = 0x%lx\n",
+	       cpus_addr(voyager_phys_cpu_present_map)[0]);
 	/* Here we set up the VIC to enable SMP */
 	/* enable the CPIs by writing the base vector to their register */
 	outb(VIC_DEFAULT_CPI_BASE, VIC_CPI_BASE_REGISTER);
@@ -628,15 +628,15 @@ void __init smp_boot_cpus(void)
 		/* now that the cat has probed the Voyager System Bus, sanity
 		 * check the cpu map */
 		if (((voyager_quad_processors | voyager_extended_vic_processors)
-		     & cpus_addr(phys_cpu_present_map)[0]) !=
-		    cpus_addr(phys_cpu_present_map)[0]) {
+		     & cpus_addr(voyager_phys_cpu_present_map)[0]) !=
+		    cpus_addr(voyager_phys_cpu_present_map)[0]) {
 			/* should panic */
 			printk("\n\n***WARNING*** "
 			       "Sanity check of CPU present map FAILED\n");
 		}
 	} else if (voyager_level == 4)
 		voyager_extended_vic_processors =
-		    cpus_addr(phys_cpu_present_map)[0];
+		    cpus_addr(voyager_phys_cpu_present_map)[0];
 
 	/* this sets up the idle task to run on the current cpu */
 	voyager_extended_cpus = 1;
@@ -670,7 +670,7 @@ void __init smp_boot_cpus(void)
 	/* loop over all the extended VIC CPUs and boot them.  The
 	 * Quad CPUs must be bootstrapped by their extended VIC cpu */
 	for (i = 0; i < nr_cpu_ids; i++) {
-		if (i == boot_cpu_id || !cpu_isset(i, phys_cpu_present_map))
+		if (i == boot_cpu_id || !cpu_isset(i, voyager_phys_cpu_present_map))
 			continue;
 		do_boot_cpu(i);
 		/* This udelay seems to be needed for the Quad boots
-- 
1.5.6.5



