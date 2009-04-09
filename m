Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbZDIFlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbZDIFlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761477AbZDIFiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:38:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58083
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761220AbZDIFiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:38:00 -0400
Date: Wed, 08 Apr 2009 22:37:51 -0700 (PDT)
Message-Id: <20090408.223751.51368318.davem@davemloft.net>
To: tj@kernel.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/12]: sparc64: Defer cpu_data() setup until end of per-cpu
 data initialization.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/ds.c      |    1 +
 arch/sparc/kernel/mdesc.c   |    1 -
 arch/sparc/kernel/prom_64.c |    1 -
 arch/sparc/kernel/smp_64.c  |    4 ++++
 arch/sparc/mm/init_64.c     |   12 ++++--------
 5 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/kernel/ds.c b/arch/sparc/kernel/ds.c
index 51b05c4..4a700f4 100644
--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -544,6 +544,7 @@ static int __cpuinit dr_cpu_configure(struct ds_info *dp,
 			     resp_len, ncpus, mask,
 			     DR_CPU_STAT_CONFIGURED);
 
+	mdesc_populate_present_mask(mask);
 	mdesc_fill_in_cpu_data(mask);
 
 	for_each_cpu_mask(cpu, *mask) {
diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index 6d2015e..938da19 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -861,7 +861,6 @@ void __cpuinit mdesc_fill_in_cpu_data(cpumask_t *mask)
 {
 	struct mdesc_handle *hp;
 
-	mdesc_populate_present_mask(mask);
 	mdesc_iterate_over_cpus(fill_in_one_cpu, NULL, mask);
 
 #ifdef CONFIG_SMP
diff --git a/arch/sparc/kernel/prom_64.c b/arch/sparc/kernel/prom_64.c
index 04b518d..f65d623 100644
--- a/arch/sparc/kernel/prom_64.c
+++ b/arch/sparc/kernel/prom_64.c
@@ -537,7 +537,6 @@ void __init of_fill_in_cpu_data(void)
 	if (tlb_type == hypervisor)
 		return;
 
-	of_populate_present_mask();
 	of_iterate_over_cpus(fill_in_one_cpu, NULL);
 
 	smp_fill_in_sib_core_maps();
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 022e5e0..73f5538 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1399,4 +1399,8 @@ void __init real_setup_per_cpu_areas(void)
 
 	/* Setup %g5 for the boot cpu.  */
 	__local_per_cpu_offset = __per_cpu_offset(smp_processor_id());
+
+	of_fill_in_cpu_data();
+	if (tlb_type == hypervisor)
+		mdesc_fill_in_cpu_data(CPU_MASK_ALL_PTR);
 }
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 87fea94..785f0a2 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1799,20 +1799,16 @@ void __init paging_init(void)
 	if (tlb_type == hypervisor)
 		sun4v_ktsb_register();
 
-	/* We must setup the per-cpu areas before we pull in the
-	 * PROM and the MDESC.  The code there fills in cpu and
-	 * other information into per-cpu data structures.
-	 */
-	real_setup_per_cpu_areas();
-
 	prom_build_devicetree();
-	of_fill_in_cpu_data();
+	of_populate_present_mask();
 
 	if (tlb_type == hypervisor) {
 		sun4v_mdesc_init();
-		mdesc_fill_in_cpu_data(CPU_MASK_ALL_PTR);
+		mdesc_populate_present_mask(CPU_MASK_ALL_PTR);
 	}
 
+	real_setup_per_cpu_areas();
+
 	/* Once the OF device tree and MDESC have been setup, we know
 	 * the list of possible cpus.  Therefore we can allocate the
 	 * IRQ stacks.
-- 
1.6.2.2

