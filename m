Return-Path: <linux-kernel-owner+w=401wt.eu-S1760668AbYGJSnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668AbYGJSnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757871AbYGJSlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:45689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbYGJSln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="11424586"
Message-Id: <20080710182237.913762000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:48 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 14/26] x64, x2apic/intr-remap: introduce read_apic_id() to genapic routines
Content-Disposition: inline; filename=genapic_read_apic_id.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the read_apic_id()  to genapic routines.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/arch/x86/kernel/genapic_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/genapic_64.c	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/arch/x86/kernel/genapic_64.c	2008-07-10 09:52:12.000000000 -0700
@@ -79,17 +79,6 @@
 	return 0;
 }
 
-unsigned int read_apic_id(void)
-{
-	unsigned int id;
-
-	WARN_ON(preemptible() && num_online_cpus() > 1);
-	id = apic_read(APIC_ID);
-	if (uv_system_type >= UV_X2APIC)
-		id  |= __get_cpu_var(x2apic_extra_bits);
-	return id;
-}
-
 enum uv_system_type get_uv_system_type(void)
 {
 	return uv_system_type;
Index: tree-x86/arch/x86/kernel/genapic_flat_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/genapic_flat_64.c	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/arch/x86/kernel/genapic_flat_64.c	2008-07-10 09:52:12.000000000 -0700
@@ -15,9 +15,11 @@
 #include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
+#include <linux/hardirq.h>
 #include <asm/smp.h>
 #include <asm/ipi.h>
 #include <asm/genapic.h>
+#include <mach_apicdef.h>
 
 static cpumask_t flat_target_cpus(void)
 {
@@ -95,9 +97,17 @@
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector, APIC_DEST_LOGICAL);
 }
 
+static unsigned int read_xapic_id(void)
+{
+	unsigned int id;
+
+	id = GET_XAPIC_ID(apic_read(APIC_ID));
+	return id;
+}
+
 static int flat_apic_id_registered(void)
 {
-	return physid_isset(GET_APIC_ID(read_apic_id()), phys_cpu_present_map);
+	return physid_isset(read_xapic_id(), phys_cpu_present_map);
 }
 
 static unsigned int flat_cpu_mask_to_apicid(cpumask_t cpumask)
@@ -123,6 +133,7 @@
 	.send_IPI_mask = flat_send_IPI_mask,
 	.cpu_mask_to_apicid = flat_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,
+	.read_apic_id = read_xapic_id,
 };
 
 /*
@@ -187,4 +198,5 @@
 	.send_IPI_mask = physflat_send_IPI_mask,
 	.cpu_mask_to_apicid = physflat_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,
+	.read_apic_id = read_xapic_id,
 };
Index: tree-x86/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/arch/x86/kernel/genx2apic_uv_x.c	2008-07-10 09:52:12.000000000 -0700
@@ -18,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/bootmem.h>
 #include <linux/module.h>
+#include <linux/hardirq.h>
 #include <asm/smp.h>
 #include <asm/ipi.h>
 #include <asm/genapic.h>
@@ -134,9 +135,19 @@
 		return BAD_APICID;
 }
 
+static unsigned int uv_read_apic_id(void)
+{
+	unsigned int id;
+
+	WARN_ON(preemptible() && num_online_cpus() > 1);
+	id = apic_read(APIC_ID) | __get_cpu_var(x2apic_extra_bits);
+
+	return id;
+}
+
 static unsigned int phys_pkg_id(int index_msb)
 {
-	return GET_APIC_ID(read_apic_id()) >> index_msb;
+	return uv_read_apic_id() >> index_msb;
 }
 
 #ifdef ZZZ		/* Needs x2apic patch */
@@ -159,6 +170,7 @@
 	/* ZZZ.send_IPI_self = uv_send_IPI_self, */
 	.cpu_mask_to_apicid = uv_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,	/* Fixme ZZZ */
+	.read_apic_id = uv_read_apic_id,
 };
 
 static __cpuinit void set_x2apic_extra_bits(int pnode)
Index: tree-x86/include/asm-x86/genapic_64.h
===================================================================
--- tree-x86.orig/include/asm-x86/genapic_64.h	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/include/asm-x86/genapic_64.h	2008-07-10 09:52:12.000000000 -0700
@@ -27,6 +27,7 @@
 	/* */
 	unsigned int (*cpu_mask_to_apicid)(cpumask_t cpumask);
 	unsigned int (*phys_pkg_id)(int index_msb);
+	unsigned int (*read_apic_id)(void);
 };
 
 extern struct genapic *genapic;
Index: tree-x86/include/asm-x86/mach-default/mach_apic.h
===================================================================
--- tree-x86.orig/include/asm-x86/mach-default/mach_apic.h	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/include/asm-x86/mach-default/mach_apic.h	2008-07-10 09:52:12.000000000 -0700
@@ -30,6 +30,7 @@
 #define cpu_mask_to_apicid (genapic->cpu_mask_to_apicid)
 #define phys_pkg_id	(genapic->phys_pkg_id)
 #define vector_allocation_domain    (genapic->vector_allocation_domain)
+#define read_apic_id  (genapic->read_apic_id)
 extern void setup_apic_routing(void);
 #else
 #define INT_DELIVERY_MODE dest_LowestPrio
Index: tree-x86/include/asm-x86/smp.h
===================================================================
--- tree-x86.orig/include/asm-x86/smp.h	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/include/asm-x86/smp.h	2008-07-10 09:52:12.000000000 -0700
@@ -176,12 +176,10 @@
 {
 	return *(u32 *)(APIC_BASE + APIC_ID);
 }
-#else
-extern unsigned int read_apic_id(void);
 #endif
 
 
-# ifdef APIC_DEFINITION
+# if defined(APIC_DEFINITION) || defined(CONFIG_X86_64)
 extern int hard_smp_processor_id(void);
 # else
 #  include <mach_apicdef.h>
Index: tree-x86/include/asm-x86/mach-default/mach_apicdef.h
===================================================================
--- tree-x86.orig/include/asm-x86/mach-default/mach_apicdef.h	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/include/asm-x86/mach-default/mach_apicdef.h	2008-07-10 09:52:12.000000000 -0700
@@ -5,8 +5,9 @@
 
 #ifdef CONFIG_X86_64
 #define	APIC_ID_MASK		(0xFFu<<24)
-#define GET_APIC_ID(x)          (((x)>>24)&0xFFu)
+#define GET_APIC_ID(x)          (x)
 #define	SET_APIC_ID(x)		(((x)<<24))
+#define GET_XAPIC_ID(x)		(((x) >> 24) & 0xFFu)
 #else
 #define		APIC_ID_MASK		(0xF<<24)
 static inline unsigned get_apic_id(unsigned long x) 
Index: tree-x86/arch/x86/kernel/apic_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/apic_64.c	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/arch/x86/kernel/apic_64.c	2008-07-10 09:52:12.000000000 -0700
@@ -1096,6 +1096,11 @@
 	cpu_set(cpu, cpu_present_map);
 }
 
+int hard_smp_processor_id(void)
+{
+	return read_apic_id();
+}
+
 /*
  * Power management
  */

-- 

