Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbYIOKpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbYIOKpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 06:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYIOKpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 06:45:38 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:38927 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752670AbYIOKph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 06:45:37 -0400
Date: Mon, 15 Sep 2008 16:15:34 +0530
From: Kiran Prakash <kiran@linux.vnet.ibm.com>
To: Kiran Prakash <kiran@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Fix for quad core x86 topology in 2.6.25.16 stable tree
Message-Id: <20080915161534.f1751aa5.kiran@linux.vnet.ibm.com>
In-Reply-To: <20080915091957.GB9355@kiran-laptop>
References: <20080915091957.GB9355@kiran-laptop>
Organization: IBM
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous mail is mangled. So resending the patch.

This patch fixes the topology problem in the 2.6.25 kernel. The cores 
and the packages in the system are not deteced correctly in the kernel
due to the problem in the logical cpu to apic id mapping. The problem 
is solved by assigning the APIC ids from the BIOS APIC table to
the cpus.

Topology before applying the patch

CPU0 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000001 00000002
  domain 1: span 000000ff
   groups: 00000003 0000000c 00000030 000000c0

This topology is wrong for this box, because logical cpu 0 belongs to
quad core package 0 and logical cpu 1 belongs to package 1

This problem has been fixed in 2.6.26 by using bios apic table.

CPU1 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000002 00000001
  domain 1: span 000000ff
   groups: 00000003 0000000c 00000030 000000c0
CPU2 attaching sched-domain:
 domain 0: span 0000000c
  groups: 00000004 00000008
  domain 1: span 000000ff
   groups: 0000000c 00000030 000000c0 00000003
CPU3 attaching sched-domain:
 domain 0: span 0000000c
  groups: 00000008 00000004
  domain 1: span 000000ff
   groups: 0000000c 00000030 000000c0 00000003
CPU4 attaching sched-domain:
 domain 0: span 00000030
  groups: 00000010 00000020
  domain 1: span 000000ff
   groups: 00000030 000000c0 00000003 0000000c
CPU5 attaching sched-domain:
 domain 0: span 00000030
  groups: 00000020 00000010
  domain 1: span 000000ff
   groups: 00000030 000000c0 00000003 0000000c
CPU6 attaching sched-domain:
 domain 0: span 000000c0
  groups: 00000040 00000080
  domain 1: span 000000ff
   groups: 000000c0 00000003 0000000c 00000030
CPU7 attaching sched-domain:
 domain 0: span 000000c0
  groups: 00000080 00000040
  domain 1: span 000000ff
   groups: 000000c0 00000003 0000000c 00000030


Topology after applying the patch

CPU0 attaching sched-domain:
 domain 0: span 00000005
  groups: 00000001 00000004
  domain 1: span 000000ff
   groups: 00000005 00000022 00000018 000000c0

This is the correct topology where logical 0,2,3,4 belongs to quad
core package 0 and cpu 1,5,6,7 belongs to package 1.

This is the correct topology built in 2.6.26.  This patch fixes the
topology issue for 2.6.25 stable tree.

CPU1 attaching sched-domain:
 domain 0: span 00000022
  groups: 00000002 00000020
  domain 1: span 000000ff
   groups: 00000022 00000018 000000c0 00000005
CPU2 attaching sched-domain:
 domain 0: span 00000005
  groups: 00000004 00000001
  domain 1: span 000000ff
   groups: 00000005 00000022 00000018 000000c0
CPU3 attaching sched-domain:
 domain 0: span 00000018
  groups: 00000008 00000010
  domain 1: span 000000ff
   groups: 00000018 000000c0 00000005 00000022
CPU4 attaching sched-domain:
 domain 0: span 00000018
  groups: 00000010 00000008
  domain 1: span 000000ff
   groups: 00000018 000000c0 00000005 00000022
CPU5 attaching sched-domain:
 domain 0: span 00000022
  groups: 00000020 00000002
  domain 1: span 000000ff
   groups: 00000022 00000018 000000c0 00000005
CPU6 attaching sched-domain:
 domain 0: span 000000c0
  groups: 00000040 00000080
  domain 1: span 000000ff
   groups: 000000c0 00000005 00000022 00000018
CPU7 attaching sched-domain:
 domain 0: span 000000c0
  groups: 00000080 00000040
  domain 1: span 000000ff
   groups: 000000c0 00000005 00000022 00000018

Signed-off-by: Kiran Prakash <kiran@linux.vnet.ibm.com>

Index: linux-2.6.25.16/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.25.16.orig/arch/x86/kernel/apic_32.c	2008-09-09 15:26:59.000000000 +0530
+++ linux-2.6.25.16/arch/x86/kernel/apic_32.c	2008-09-11 15:46:58.000000000 +0530
@@ -65,6 +65,7 @@
 /* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
+extern void *x86_bios_cpu_apicid_early_ptr;
 
 /*
  * Debug level, exported for io_apic.c
@@ -95,6 +96,8 @@
 	.irq		= -1,
 };
 static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
+DEFINE_PER_CPU(u8, x86_bios_cpu_apicid) = BAD_APICID;
+EXPORT_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
 /* Local APIC was disabled by the BIOS and enabled by the kernel */
 static int enabled_via_apicbase;
@@ -1394,6 +1397,32 @@
 	}
 }
 
+void __cpuinit generic_processor_info(int apicid)
+{
+       int cpu;
+       cpumask_t tmp_map;
+       physid_mask_t phys_cpu;
+       #ifdef CONFIG_SMP
+       cpu = first_cpu(cpu_present_map);
+
+       if (apicid == boot_cpu_physical_apicid)
+       cpu = 0;
+
+       if (x86_cpu_to_apicid_early_ptr) {
+		u16 *cpu_to_apicid = x86_cpu_to_apicid_early_ptr;
+		u16 *bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
+		cpu_to_apicid[cpu] = apicid;
+		bios_cpu_apicid[cpu] = apicid;
+       } else {
+		per_cpu(x86_cpu_to_apicid, cpu) = apicid;
+		per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
+       }
+       #endif
+       cpu_set(cpu, cpu_possible_map);
+       cpu_set(cpu, cpu_present_map);
+}
+
+
 /*
  * Power management
  */
Index: linux-2.6.25.16/arch/x86/kernel/mpparse_32.c
===================================================================
--- linux-2.6.25.16.orig/arch/x86/kernel/mpparse_32.c	2008-09-09 15:29:26.000000000 +0530
+++ linux-2.6.25.16/arch/x86/kernel/mpparse_32.c	2008-09-11 15:47:43.000000000 +0530
@@ -36,7 +36,7 @@
 /* Have we found an MP table */
 int smp_found_config;
 unsigned int __cpuinitdata maxcpus = NR_CPUS;
-
+extern void __cpuinit generic_processor_info(int apicid);
 /*
  * Various Linux-internal data structures created from the
  * MP-table.
@@ -111,7 +111,11 @@
 	if (!(m->mpc_cpuflag & CPU_ENABLED))
 		return;
 
-	apicid = mpc_apic_id(m, translation_table[mpc_record]);
+	#ifdef CONFIG_X86_NUMAQ
+		apicid = mpc_apic_id(m, translation_table[mpc_record]);
+	#else
+		apicid = m->mpc_apicid;
+	#endif
 
 	if (m->mpc_featureflag&(1<<0))
 		Dprintk("    Floating point unit present.\n");
@@ -217,6 +221,7 @@
 		}
 	}
 	bios_cpu_apicid[num_processors - 1] = m->mpc_apicid;
+	generic_processor_info(apicid);
 }
 
 static void __init MP_bus_info (struct mpc_config_bus *m)
Index: linux-2.6.25.16/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.25.16.orig/arch/x86/kernel/setup_32.c	2008-09-09 15:30:55.000000000 +0530
+++ linux-2.6.25.16/arch/x86/kernel/setup_32.c	2008-09-11 15:48:00.000000000 +0530
@@ -69,7 +69,8 @@
    immediately after the boot time page tables.  It contains a *physical*
    address, and must not be in the .bss segment! */
 unsigned long init_pg_tables_end __initdata = ~0UL;
-
+extern void *x86_bios_cpu_apicid_early_ptr;
+extern u8 __initdata x86_bios_cpu_apicid_init[];
 /*
  * Machine setup..
  */
@@ -826,6 +827,14 @@
 
 	io_delay_init();
 
+#ifdef CONFIG_X86_SMP
+	x86_cpu_to_apicid_early_ptr = (void *)x86_cpu_to_apicid_init;
+	x86_bios_cpu_apicid_early_ptr = (void *)x86_bios_cpu_apicid_init;
+#ifdef CONFIG_NUMA
+	x86_cpu_to_node_map_early_ptr = (void *)x86_cpu_to_node_map_init;
+#endif
+#endif
+
 #ifdef CONFIG_X86_GENERICARCH
 	generic_apic_probe();
 #endif
Index: linux-2.6.25.16/arch/x86/kernel/smpboot_32.c
===================================================================
--- linux-2.6.25.16.orig/arch/x86/kernel/smpboot_32.c	2008-09-09 15:32:01.000000000 +0530
+++ linux-2.6.25.16/arch/x86/kernel/smpboot_32.c	2008-09-11 15:44:52.000000000 +0530
@@ -94,7 +94,10 @@
 /* which logical CPU number maps to which CPU (physical APIC ID) */
 u8 x86_cpu_to_apicid_init[NR_CPUS] __initdata =
 			{ [0 ... NR_CPUS-1] = BAD_APICID };
+u8 x86_bios_cpu_apicid_init[NR_CPUS] __initdata =
+			{ [0 ... NR_CPUS-1] = BAD_APICID };
 void *x86_cpu_to_apicid_early_ptr;
+void *x86_bios_cpu_apicid_early_ptr;
 DEFINE_PER_CPU(u8, x86_cpu_to_apicid) = BAD_APICID;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
Index: linux-2.6.25.16/include/asm-x86/mach-default/mach_apic.h
===================================================================
--- linux-2.6.25.16.orig/include/asm-x86/mach-default/mach_apic.h	2008-09-09 15:35:23.000000000 +0530
+++ linux-2.6.25.16/include/asm-x86/mach-default/mach_apic.h	2008-09-09 15:35:55.000000000 +0530
@@ -5,6 +5,7 @@
 #include <asm/smp.h>
 
 #define APIC_DFR_VALUE	(APIC_DFR_FLAT)
+extern u8 bios_cpu_apicid[];
 
 static inline cpumask_t target_cpus(void)
 { 
@@ -79,7 +80,7 @@
 static inline int cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < get_physical_broadcast())
-		return  mps_cpu;
+		return  bios_cpu_apicid[mps_cpu];
 	else
 		return BAD_APICID;
 }
Index: linux-2.6.25.16/include/asm-x86/smp_32.h
===================================================================
--- linux-2.6.25.16.orig/include/asm-x86/smp_32.h	2008-09-09 15:34:45.000000000 +0530
+++ linux-2.6.25.16/include/asm-x86/smp_32.h	2008-09-09 15:35:02.000000000 +0530
@@ -31,7 +31,7 @@
 
 extern u8 __initdata x86_cpu_to_apicid_init[];
 extern void *x86_cpu_to_apicid_early_ptr;
-
+extern void *x86_bios_cpu_apicid_early_ptr;
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_t, cpu_core_map);
 DECLARE_PER_CPU(u8, cpu_llc_id);
Index: linux-2.6.25.16/include/asm-x86/mpspec.h
===================================================================
--- linux-2.6.25.16.orig/include/asm-x86/mpspec.h	2008-09-09 16:09:48.000000000 +0530
+++ linux-2.6.25.16/include/asm-x86/mpspec.h	2008-09-09 16:09:57.000000000 +0530
@@ -40,6 +40,7 @@
 
 extern void find_smp_config(void);
 extern void get_smp_config(void);
+extern void generic_processor_info(int apicid);
 
 #ifdef CONFIG_ACPI
 extern void mp_register_lapic(u8 id, u8 enabled);
