Return-Path: <linux-kernel-owner+w=401wt.eu-S1756327AbXFLHrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbXFLHrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbXFLHr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:47:29 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:54889 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751279AbXFLHr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:47:28 -0400
Message-Id: <466E6BDF.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 12 Jun 2007 09:48:15 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: [PATCH] x86: fix improper .init-type section references
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

.. which modpost is warning about.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/i386/kernel/cpu/intel_cacheinfo.c    |    6 +++---
 arch/i386/kernel/cpu/mcheck/therm_throt.c |    2 +-
 arch/i386/kernel/cpu/mtrr/generic.c       |    2 +-
 arch/i386/kernel/cpu/mtrr/main.c          |    2 +-
 arch/i386/kernel/smpboot.c                |    2 +-
 arch/x86_64/kernel/mce.c                  |    6 +++---
 arch/x86_64/mm/init.c                     |    2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

--- linux-2.6.22-rc4/arch/i386/kernel/cpu/intel_cacheinfo.c	2007-06-11 18:09:52.000000000 +0200
+++ 2.6.22-rc4-x86-init-attribs/arch/i386/kernel/cpu/intel_cacheinfo.c	2007-06-11 09:10:41.000000000 +0200
@@ -240,7 +240,7 @@ static int __cpuinit cpuid4_cache_lookup
 }
 
 /* will only be called once; __init is safe here */
-static int __init find_num_cache_leaves(void)
+static int noinline __init_refok find_num_cache_leaves(void)
 {
 	unsigned int		eax, ebx, ecx, edx;
 	union _cpuid4_leaf_eax	cache_eax;
@@ -448,7 +448,7 @@ static void __cpuinit cache_shared_cpu_m
 		}
 	}
 }
-static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
+static void __cpuexit cache_remove_shared_cpu_map(unsigned int cpu, int index)
 {
 	struct _cpuid4_info	*this_leaf, *sibling_leaf;
 	int sibling;
@@ -461,7 +461,7 @@ static void __cpuinit cache_remove_share
 }
 #else
 static void __init cache_shared_cpu_map_setup(unsigned int cpu, int index) {}
-static void __init cache_remove_shared_cpu_map(unsigned int cpu, int index) {}
+static void __exit cache_remove_shared_cpu_map(unsigned int cpu, int index) {}
 #endif
 
 static void free_cache_attributes(unsigned int cpu)
--- linux-2.6.22-rc4/arch/i386/kernel/cpu/mcheck/therm_throt.c	2007-06-11 18:09:52.000000000 +0200
+++ 2.6.22-rc4-x86-init-attribs/arch/i386/kernel/cpu/mcheck/therm_throt.c	2007-06-11 09:10:41.000000000 +0200
@@ -150,7 +150,7 @@ static __cpuinit int thermal_throttle_cp
 	return NOTIFY_OK;
 }
 
-static struct notifier_block thermal_throttle_cpu_notifier =
+static __cpuinitdata struct notifier_block thermal_throttle_cpu_notifier =
 {
 	.notifier_call = thermal_throttle_cpu_callback,
 };
--- linux-2.6.22-rc4/arch/i386/kernel/cpu/mtrr/generic.c	2007-06-11 18:09:52.000000000 +0200
+++ 2.6.22-rc4-x86-init-attribs/arch/i386/kernel/cpu/mtrr/generic.c	2007-06-11 09:10:41.000000000 +0200
@@ -78,7 +78,7 @@ static void __cpuinit print_fixed(unsign
 }
 
 /*  Grab all of the MTRR state for this CPU into *state  */
-void get_mtrr_state(void)
+void __init get_mtrr_state(void)
 {
 	unsigned int i;
 	struct mtrr_var_range *vrs;
--- linux-2.6.22-rc4/arch/i386/kernel/cpu/mtrr/main.c	2007-06-11 18:09:52.000000000 +0200
+++ 2.6.22-rc4-x86-init-attribs/arch/i386/kernel/cpu/mtrr/main.c	2007-06-11 09:10:41.000000000 +0200
@@ -639,7 +639,7 @@ static struct sysdev_driver mtrr_sysdev_
  * initialized (i.e. before smp_init()).
  * 
  */
-void mtrr_bp_init(void)
+void __init mtrr_bp_init(void)
 {
 	init_ifs();
 
--- linux-2.6.22-rc4/arch/i386/kernel/smpboot.c	2007-06-11 18:09:52.000000000 +0200
+++ 2.6.22-rc4-x86-init-attribs/arch/i386/kernel/smpboot.c	2007-06-11 09:10:41.000000000 +0200
@@ -118,7 +118,7 @@ DEFINE_PER_CPU(int, cpu_state) = { 0 };
  * has made sure it's suitably aligned.
  */
 
-static unsigned long __devinit setup_trampoline(void)
+static unsigned long __cpuinit setup_trampoline(void)
 {
 	memcpy(trampoline_base, trampoline_data, trampoline_end - trampoline_data);
 	return virt_to_phys(trampoline_base);
--- linux-2.6.22-rc4/arch/x86_64/kernel/mce.c	2007-06-11 18:10:04.000000000 +0200
+++ 2.6.22-rc4-x86-init-attribs/arch/x86_64/kernel/mce.c	2007-06-11 09:10:41.000000000 +0200
@@ -701,7 +701,7 @@ static __cpuinit int mce_create_device(u
 	return err;
 }
 
-static void mce_remove_device(unsigned int cpu)
+static __cpuexit void mce_remove_device(unsigned int cpu)
 {
 	int i;
 
@@ -713,7 +713,7 @@ static void mce_remove_device(unsigned i
 }
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
-static int
+static __cpuinit int
 mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
@@ -731,7 +731,7 @@ mce_cpu_callback(struct notifier_block *
 	return NOTIFY_OK;
 }
 
-static struct notifier_block mce_cpu_notifier = {
+static __cpuinitdata struct notifier_block mce_cpu_notifier = {
 	.notifier_call = mce_cpu_callback,
 };
 
--- linux-2.6.22-rc4/arch/x86_64/mm/init.c	2007-06-11 18:10:04.000000000 +0200
+++ 2.6.22-rc4-x86-init-attribs/arch/x86_64/mm/init.c	2007-06-11 10:28:44.000000000 +0200
@@ -762,7 +762,7 @@ int in_gate_area_no_task(unsigned long a
 	return (addr >= VSYSCALL_START) && (addr < VSYSCALL_END);
 }
 
-void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
+void *__init alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
 {
 	return __alloc_bootmem_core(pgdat->bdata, size,
 			SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);


