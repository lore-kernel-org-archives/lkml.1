Return-Path: <linux-kernel-owner+w=401wt.eu-S1163439AbXD1SOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163439AbXD1SOn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163289AbXD1Rwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:52:37 -0400
Received: from ns.suse.de ([195.135.220.2]:34398 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163288AbXD1Rwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:32 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <ak@suse.de>, "Li, Shaohua" <shaohua.li@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [7/35] x86: default to physical mode on hotplug CPU kernels
Message-Id: <20070428175231.48F9A151F8@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ingo Molnar <mingo@elte.hu>

Default to physical mode on hotplug CPU kernels.  Furher simplify and clean up
the APIC initialization code.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/acpi/boot.c              |    2 +-
 arch/i386/kernel/mpparse.c                |    2 +-
 arch/x86_64/kernel/genapic.c              |   16 +++-------------
 arch/x86_64/kernel/mpparse.c              |    2 +-
 include/asm-i386/genapic.h                |    4 ++--
 include/asm-i386/mach-bigsmp/mach_apic.h  |    2 +-
 include/asm-i386/mach-default/mach_apic.h |    2 +-
 include/asm-i386/mach-es7000/mach_apic.h  |    2 +-
 include/asm-i386/mach-generic/mach_apic.h |    2 +-
 include/asm-i386/mach-numaq/mach_apic.h   |    2 +-
 include/asm-i386/mach-summit/mach_apic.h  |    2 +-
 include/asm-i386/mach-visws/mach_apic.h   |    2 +-
 include/asm-x86_64/apic.h                 |    2 +-
 13 files changed, 16 insertions(+), 26 deletions(-)

Index: linux/arch/i386/kernel/acpi/boot.c
===================================================================
--- linux.orig/arch/i386/kernel/acpi/boot.c
+++ linux/arch/i386/kernel/acpi/boot.c
@@ -874,7 +874,7 @@ static void __init acpi_process_madt(voi
 				acpi_ioapic = 1;
 
 				smp_found_config = 1;
-				clustered_apic_check();
+				setup_apic_routing();
 			}
 		}
 		if (error == -EINVAL) {
Index: linux/arch/i386/kernel/mpparse.c
===================================================================
--- linux.orig/arch/i386/kernel/mpparse.c
+++ linux/arch/i386/kernel/mpparse.c
@@ -477,7 +477,7 @@ static int __init smp_read_mpc(struct mp
 		}
 		++mpc_record;
 	}
-	clustered_apic_check();
+	setup_apic_routing();
 	if (!num_processors)
 		printk(KERN_ERR "SMP mptable: no processors registered!\n");
 	return num_processors;
Index: linux/arch/x86_64/kernel/genapic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/genapic.c
+++ linux/arch/x86_64/kernel/genapic.c
@@ -35,11 +35,8 @@ struct genapic __read_mostly *genapic = 
 /*
  * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
  */
-void __init clustered_apic_check(void)
+void __init setup_apic_routing(void)
 {
-	unsigned int i, max_apic = 0;
-	u8 id;
-
 #ifdef CONFIG_ACPI
 	/*
 	 * Quirk: some x86_64 machines can only use physical APIC mode
@@ -49,17 +46,10 @@ void __init clustered_apic_check(void)
 	if (acpi_gbl_FADT.header.revision > FADT2_REVISION_ID &&
 			(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL))
 		genapic = &apic_physflat;
+	else
 #endif
 
-	for (i = 0; i < NR_CPUS; i++) {
-		id = bios_cpu_apicid[i];
-		if (id == BAD_APICID)
-			continue;
-		if (id > max_apic)
-			max_apic = id;
-	}
-
-	if (max_apic < 8)
+	if (cpus_weight(cpu_possible_map) <= 8)
 		genapic = &apic_flat;
 	else
 		genapic = &apic_physflat;
Index: linux/arch/x86_64/kernel/mpparse.c
===================================================================
--- linux.orig/arch/x86_64/kernel/mpparse.c
+++ linux/arch/x86_64/kernel/mpparse.c
@@ -300,7 +300,7 @@ static int __init smp_read_mpc(struct mp
 			}
 		}
 	}
-	clustered_apic_check();
+	setup_apic_routing();
 	if (!num_processors)
 		printk(KERN_ERR "MPTABLE: no processors registered!\n");
 	return num_processors;
Index: linux/include/asm-i386/genapic.h
===================================================================
--- linux.orig/include/asm-i386/genapic.h
+++ linux/include/asm-i386/genapic.h
@@ -36,7 +36,7 @@ struct genapic { 
 	void (*init_apic_ldr)(void);
 	physid_mask_t (*ioapic_phys_id_map)(physid_mask_t map);
 
-	void (*clustered_apic_check)(void);
+	void (*setup_apic_routing)(void);
 	int (*multi_timer_check)(int apic, int irq);
 	int (*apicid_to_node)(int logical_apicid); 
 	int (*cpu_to_logical_apicid)(int cpu);
@@ -99,7 +99,7 @@ struct genapic { 
 	APICFUNC(check_apicid_present) \
 	APICFUNC(init_apic_ldr) \
 	APICFUNC(ioapic_phys_id_map) \
-	APICFUNC(clustered_apic_check) \
+	APICFUNC(setup_apic_routing) \
 	APICFUNC(multi_timer_check) \
 	APICFUNC(apicid_to_node) \
 	APICFUNC(cpu_to_logical_apicid) \
Index: linux/include/asm-i386/mach-bigsmp/mach_apic.h
===================================================================
--- linux.orig/include/asm-i386/mach-bigsmp/mach_apic.h
+++ linux/include/asm-i386/mach-bigsmp/mach_apic.h
@@ -71,7 +71,7 @@ static inline void init_apic_ldr(void)
 	apic_write_around(APIC_LDR, val);
 }
 
-static inline void clustered_apic_check(void)
+static inline void setup_apic_routing(void)
 {
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
 		"Physflat", nr_ioapics);
Index: linux/include/asm-i386/mach-default/mach_apic.h
===================================================================
--- linux.orig/include/asm-i386/mach-default/mach_apic.h
+++ linux/include/asm-i386/mach-default/mach_apic.h
@@ -54,7 +54,7 @@ static inline physid_mask_t ioapic_phys_
 	return phys_map;
 }
 
-static inline void clustered_apic_check(void)
+static inline void setup_apic_routing(void)
 {
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
 					"Flat", nr_ioapics);
Index: linux/include/asm-i386/mach-es7000/mach_apic.h
===================================================================
--- linux.orig/include/asm-i386/mach-es7000/mach_apic.h
+++ linux/include/asm-i386/mach-es7000/mach_apic.h
@@ -81,7 +81,7 @@ static inline void enable_apic_mode(void
 }
 
 extern int apic_version [MAX_APICS];
-static inline void clustered_apic_check(void)
+static inline void setup_apic_routing(void)
 {
 	int apic = bios_cpu_apicid[smp_processor_id()];
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs, target cpus %lx\n",
Index: linux/include/asm-i386/mach-generic/mach_apic.h
===================================================================
--- linux.orig/include/asm-i386/mach-generic/mach_apic.h
+++ linux/include/asm-i386/mach-generic/mach_apic.h
@@ -13,7 +13,7 @@
 #define apic_id_registered (genapic->apic_id_registered)
 #define init_apic_ldr (genapic->init_apic_ldr)
 #define ioapic_phys_id_map (genapic->ioapic_phys_id_map)
-#define clustered_apic_check (genapic->clustered_apic_check) 
+#define setup_apic_routing (genapic->setup_apic_routing)
 #define multi_timer_check (genapic->multi_timer_check)
 #define apicid_to_node (genapic->apicid_to_node)
 #define cpu_to_logical_apicid (genapic->cpu_to_logical_apicid) 
Index: linux/include/asm-i386/mach-numaq/mach_apic.h
===================================================================
--- linux.orig/include/asm-i386/mach-numaq/mach_apic.h
+++ linux/include/asm-i386/mach-numaq/mach_apic.h
@@ -34,7 +34,7 @@ static inline void init_apic_ldr(void)
 	/* Already done in NUMA-Q firmware */
 }
 
-static inline void clustered_apic_check(void)
+static inline void setup_apic_routing(void)
 {
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
 		"NUMA-Q", nr_ioapics);
Index: linux/include/asm-i386/mach-summit/mach_apic.h
===================================================================
--- linux.orig/include/asm-i386/mach-summit/mach_apic.h
+++ linux/include/asm-i386/mach-summit/mach_apic.h
@@ -80,7 +80,7 @@ static inline int apic_id_registered(voi
 	return 1;
 }
 
-static inline void clustered_apic_check(void)
+static inline void setup_apic_routing(void)
 {
 	printk("Enabling APIC mode:  Summit.  Using %d I/O APICs\n",
 						nr_ioapics);
Index: linux/include/asm-i386/mach-visws/mach_apic.h
===================================================================
--- linux.orig/include/asm-i386/mach-visws/mach_apic.h
+++ linux/include/asm-i386/mach-visws/mach_apic.h
@@ -47,7 +47,7 @@ static inline void summit_check(char *oe
 {
 }
 
-static inline void clustered_apic_check(void)
+static inline void setup_apic_routing(void)
 {
 }
 
Index: linux/include/asm-x86_64/apic.h
===================================================================
--- linux.orig/include/asm-x86_64/apic.h
+++ linux/include/asm-x86_64/apic.h
@@ -83,7 +83,7 @@ extern void setup_secondary_APIC_clock (
 extern int APIC_init_uniprocessor (void);
 extern void disable_APIC_timer(void);
 extern void enable_APIC_timer(void);
-extern void clustered_apic_check(void);
+extern void setup_apic_routing(void);
 
 extern void setup_APIC_extened_lvt(unsigned char lvt_off, unsigned char vector,
 				   unsigned char msg_type, unsigned char mask);
