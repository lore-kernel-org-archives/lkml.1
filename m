Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbYGLBpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbYGLBpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 21:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbYGLBoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 21:44:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:36256 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbYGLBow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 21:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=B84DRMOPxabKgy0omuhCVDa5pPmXv1nc5/VPLO9zFhKcXEvNVkrB0CpUO1k+GYygYm
         UObLlvL/XFvGiBMf7wDAlrzCgrr0XosmoTgKwBLeAm39ffZN+pJP5FChmj1uYuiOJUNG
         8Nz7vYVJY4cIAjwtoKchLL6OH6VgnW7u6xnpw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: make read_apic_id return final apicid
Date: Fri, 11 Jul 2008 18:44:16 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807111841.55403.yhlu.kernel@gmail.com> <200807111843.11157.yhlu.kernel@gmail.com>
In-Reply-To: <200807111843.11157.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807111844.17084.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


also remove GET_APIC_ID when read_apic_id is used.

need to apply after
	[PATCH] x86: mach_apicdef.h need to include before smp.h


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/acpi/boot.c                 |    2 +-
 arch/x86/kernel/apic_32.c                   |    4 ++--
 arch/x86/kernel/apic_64.c                   |    6 +++---
 arch/x86/kernel/genapic_flat_64.c           |    2 +-
 arch/x86/kernel/io_apic_32.c                |    5 ++---
 arch/x86/kernel/io_apic_64.c                |    4 ++--
 arch/x86/kernel/smpboot.c                   |    6 +++---
 include/asm-x86/mach-default/mach_apic.h    |    2 +-
 include/asm-x86/mach-default/mach_apicdef.h |    3 +--
 include/asm-x86/mach-es7000/mach_apic.h     |    2 +-
 include/asm-x86/smp.h                       |   11 ++++++++---
 11 files changed, 25 insertions(+), 22 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -763,7 +763,7 @@ static void __init acpi_register_lapic_a
 
 	set_fixmap_nocache(FIX_APIC_BASE, address);
 	if (boot_cpu_physical_apicid == -1U) {
-		boot_cpu_physical_apicid  = GET_APIC_ID(read_apic_id());
+		boot_cpu_physical_apicid  = read_apic_id();
 #ifdef CONFIG_X86_32
 		apic_version[boot_cpu_physical_apicid] =
 			 GET_APIC_VERSION(apic_read(APIC_LVR));
Index: linux-2.6/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_32.c
+++ linux-2.6/arch/x86/kernel/apic_32.c
@@ -1230,7 +1230,7 @@ void __init init_apic_mappings(void)
 	 * default configuration (or the MP table is broken).
 	 */
 	if (boot_cpu_physical_apicid == -1U)
-		boot_cpu_physical_apicid = GET_APIC_ID(read_apic_id());
+		boot_cpu_physical_apicid = read_apic_id();
 
 }
 
@@ -1270,7 +1270,7 @@ int __init APIC_init_uniprocessor(void)
 	 * might be zero if read from MP tables. Get it from LAPIC.
 	 */
 #ifdef CONFIG_CRASH_DUMP
-	boot_cpu_physical_apicid = GET_APIC_ID(read_apic_id());
+	boot_cpu_physical_apicid = read_apic_id();
 #endif
 	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
 
Index: linux-2.6/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_64.c
+++ linux-2.6/arch/x86/kernel/apic_64.c
@@ -1060,7 +1060,7 @@ void __init early_init_lapic_mapping(voi
 	 * Fetch the APIC ID of the BSP in case we have a
 	 * default configuration (or the MP table is broken).
 	 */
-	boot_cpu_physical_apicid = GET_APIC_ID(read_apic_id());
+	boot_cpu_physical_apicid = read_apic_id();
 }
 
 /**
@@ -1069,7 +1069,7 @@ void __init early_init_lapic_mapping(voi
 void __init init_apic_mappings(void)
 {
 	if (x2apic) {
-		boot_cpu_physical_apicid = GET_APIC_ID(read_apic_id());
+		boot_cpu_physical_apicid = read_apic_id();
 		return;
 	}
 
@@ -1092,7 +1092,7 @@ void __init init_apic_mappings(void)
 	 * Fetch the APIC ID of the BSP in case we have a
 	 * default configuration (or the MP table is broken).
 	 */
-	boot_cpu_physical_apicid = GET_APIC_ID(read_apic_id());
+	boot_cpu_physical_apicid = read_apic_id();
 }
 
 /*
Index: linux-2.6/arch/x86/kernel/genapic_flat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6/arch/x86/kernel/genapic_flat_64.c
@@ -101,7 +101,7 @@ static unsigned int read_xapic_id(void)
 {
 	unsigned int id;
 
-	id = GET_XAPIC_ID(apic_read(APIC_ID));
+	id = GET_APIC_ID(apic_read(APIC_ID));
 	return id;
 }
 
Index: linux-2.6/arch/x86/kernel/io_apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_32.c
+++ linux-2.6/arch/x86/kernel/io_apic_32.c
@@ -1501,7 +1501,7 @@ void /*__init*/ print_local_APIC(void *d
 		smp_processor_id(), hard_smp_processor_id());
 	v = apic_read(APIC_ID);
 	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v,
-			GET_APIC_ID(read_apic_id()));
+			GET_APIC_ID(v));
 	v = apic_read(APIC_LVR);
 	printk(KERN_INFO "... APIC VERSION: %08x\n", v);
 	ver = GET_APIC_VERSION(v);
@@ -1709,8 +1709,7 @@ void disable_IO_APIC(void)
 		entry.dest_mode       = 0; /* Physical */
 		entry.delivery_mode   = dest_ExtINT; /* ExtInt */
 		entry.vector          = 0;
-		entry.dest.physical.physical_dest =
-					GET_APIC_ID(read_apic_id());
+		entry.dest.physical.physical_dest = read_apic_id();
 
 		/*
 		 * Add it to the IO-APIC irq-routing table:
Index: linux-2.6/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6/arch/x86/kernel/io_apic_64.c
@@ -1246,7 +1246,7 @@ void __apicdebuginit print_local_APIC(vo
 	printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
 	v = apic_read(APIC_ID);
-	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, GET_APIC_ID(read_apic_id()));
+	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, read_apic_id());
 	v = apic_read(APIC_LVR);
 	printk(KERN_INFO "... APIC VERSION: %08x\n", v);
 	ver = GET_APIC_VERSION(v);
@@ -1441,7 +1441,7 @@ void disable_IO_APIC(void)
 		entry.dest_mode       = 0; /* Physical */
 		entry.delivery_mode   = dest_ExtINT; /* ExtInt */
 		entry.vector          = 0;
-		entry.dest          = GET_APIC_ID(read_apic_id());
+		entry.dest            = read_apic_id();
 
 		/*
 		 * Add it to the IO-APIC irq-routing table:
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -211,7 +211,7 @@ static void __cpuinit smp_callin(void)
 	/*
 	 * (This works even if the APIC is not enabled.)
 	 */
-	phys_id = GET_APIC_ID(read_apic_id());
+	phys_id = read_apic_id();
 	cpuid = smp_processor_id();
 	if (cpu_isset(cpuid, cpu_callin_map)) {
 		panic("%s: phys CPU#%d, CPU#%d already present??\n", __func__,
@@ -1157,9 +1157,9 @@ void __init native_smp_prepare_cpus(unsi
 	}
 
 	preempt_disable();
-	if (GET_APIC_ID(read_apic_id()) != boot_cpu_physical_apicid) {
+	if (read_apic_id() != boot_cpu_physical_apicid) {
 		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
-		     GET_APIC_ID(read_apic_id()), boot_cpu_physical_apicid);
+		     read_apic_id(), boot_cpu_physical_apicid);
 		/* Or can we switch back to PIC here? */
 	}
 	preempt_enable();
Index: linux-2.6/include/asm-x86/mach-default/mach_apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-default/mach_apic.h
+++ linux-2.6/include/asm-x86/mach-default/mach_apic.h
@@ -56,7 +56,7 @@ static inline void init_apic_ldr(void)
 
 static inline int apic_id_registered(void)
 {
-	return physid_isset(GET_APIC_ID(read_apic_id()), phys_cpu_present_map);
+	return physid_isset(read_apic_id(), phys_cpu_present_map);
 }
 
 static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
Index: linux-2.6/include/asm-x86/mach-default/mach_apicdef.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-default/mach_apicdef.h
+++ linux-2.6/include/asm-x86/mach-default/mach_apicdef.h
@@ -5,9 +5,8 @@
 
 #ifdef CONFIG_X86_64
 #define	APIC_ID_MASK		(0xFFu<<24)
-#define GET_APIC_ID(x)          (x)
+#define GET_APIC_ID(x)		(((x)>>24) & 0xFFu)
 #define	SET_APIC_ID(x)		(((x)<<24))
-#define GET_XAPIC_ID(x)		(((x) >> 24) & 0xFFu)
 #else
 #define		APIC_ID_MASK		(0xF<<24)
 static inline unsigned get_apic_id(unsigned long x) 
Index: linux-2.6/include/asm-x86/mach-es7000/mach_apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-es7000/mach_apic.h
+++ linux-2.6/include/asm-x86/mach-es7000/mach_apic.h
@@ -141,7 +141,7 @@ static inline void setup_portio_remap(vo
 extern unsigned int boot_cpu_physical_apicid;
 static inline int check_phys_apicid_present(int cpu_physical_apicid)
 {
-	boot_cpu_physical_apicid = GET_APIC_ID(read_apic_id());
+	boot_cpu_physical_apicid = read_apic_id();
 	return (1);
 }
 
Index: linux-2.6/include/asm-x86/smp.h
===================================================================
--- linux-2.6.orig/include/asm-x86/smp.h
+++ linux-2.6/include/asm-x86/smp.h
@@ -172,9 +172,14 @@ static inline int logical_smp_processor_
 	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
 }
 
+#include <mach_apicdef.h>
 static inline unsigned int read_apic_id(void)
 {
-	return *(u32 *)(APIC_BASE + APIC_ID);
+	unsigned int reg;
+
+	reg = *(u32 *)(APIC_BASE + APIC_ID);
+
+	return GET_APIC_ID(reg);
 }
 #endif
 
@@ -182,11 +187,11 @@ static inline unsigned int read_apic_id(
 # if defined(APIC_DEFINITION) || defined(CONFIG_X86_64)
 extern int hard_smp_processor_id(void);
 # else
-#  include <mach_apicdef.h>
+#include <mach_apicdef.h>
 static inline int hard_smp_processor_id(void)
 {
 	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_ID(read_apic_id());
+	return read_apic_id();
 }
 # endif /* APIC_DEFINITION */
 
