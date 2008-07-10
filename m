Return-Path: <linux-kernel-owner+w=401wt.eu-S1761200AbYGJSoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761200AbYGJSoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758000AbYGJSlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:45689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282AbYGJSlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="11424600"
Message-Id: <20080710182238.631011000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:53 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 19/26] x64, x2apic/intr-remap: introcude self IPI to genapic routines
Content-Disposition: inline; filename=self_ipi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce self IPI op for genapic.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/arch/x86/kernel/genapic_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/genapic_64.c	2008-07-10 09:52:12.000000000 -0700
+++ tree-x86/arch/x86/kernel/genapic_64.c	2008-07-10 09:52:24.000000000 -0700
@@ -61,7 +61,7 @@
 
 /* Same for both flat and physical. */
 
-void send_IPI_self(int vector)
+void apic_send_IPI_self(int vector)
 {
 	__send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
 }
Index: tree-x86/arch/x86/kernel/genapic_flat_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/genapic_flat_64.c	2008-07-10 09:52:12.000000000 -0700
+++ tree-x86/arch/x86/kernel/genapic_flat_64.c	2008-07-10 09:52:24.000000000 -0700
@@ -131,6 +131,7 @@
 	.send_IPI_all = flat_send_IPI_all,
 	.send_IPI_allbutself = flat_send_IPI_allbutself,
 	.send_IPI_mask = flat_send_IPI_mask,
+	.send_IPI_self = apic_send_IPI_self,
 	.cpu_mask_to_apicid = flat_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,
 	.read_apic_id = read_xapic_id,
@@ -196,6 +197,7 @@
 	.send_IPI_all = physflat_send_IPI_all,
 	.send_IPI_allbutself = physflat_send_IPI_allbutself,
 	.send_IPI_mask = physflat_send_IPI_mask,
+	.send_IPI_self = apic_send_IPI_self,
 	.cpu_mask_to_apicid = physflat_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,
 	.read_apic_id = read_xapic_id,
Index: tree-x86/include/asm-x86/genapic_64.h
===================================================================
--- tree-x86.orig/include/asm-x86/genapic_64.h	2008-07-10 09:52:12.000000000 -0700
+++ tree-x86/include/asm-x86/genapic_64.h	2008-07-10 09:52:24.000000000 -0700
@@ -24,6 +24,7 @@
 	void (*send_IPI_mask)(cpumask_t mask, int vector);
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
+	void (*send_IPI_self)(int vector);
 	/* */
 	unsigned int (*cpu_mask_to_apicid)(cpumask_t cpumask);
 	unsigned int (*phys_pkg_id)(int index_msb);
@@ -36,6 +37,7 @@
 extern struct genapic apic_physflat;
 extern int acpi_madt_oem_check(char *, char *);
 
+extern void apic_send_IPI_self(int vector);
 enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
 extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
Index: tree-x86/include/asm-x86/hw_irq.h
===================================================================
--- tree-x86.orig/include/asm-x86/hw_irq.h	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/include/asm-x86/hw_irq.h	2008-07-10 09:52:24.000000000 -0700
@@ -73,7 +73,9 @@
 #endif
 
 /* IPI functions */
+#ifdef CONFIG_X86_32
 extern void send_IPI_self(int vector);
+#endif
 extern void send_IPI(int dest, int vector);
 
 /* Statistics */
Index: tree-x86/include/asm-x86/mach-default/mach_apic.h
===================================================================
--- tree-x86.orig/include/asm-x86/mach-default/mach_apic.h	2008-07-10 09:52:12.000000000 -0700
+++ tree-x86/include/asm-x86/mach-default/mach_apic.h	2008-07-10 09:52:24.000000000 -0700
@@ -31,6 +31,7 @@
 #define phys_pkg_id	(genapic->phys_pkg_id)
 #define vector_allocation_domain    (genapic->vector_allocation_domain)
 #define read_apic_id  (genapic->read_apic_id)
+#define send_IPI_self (genapic->send_IPI_self)
 extern void setup_apic_routing(void);
 #else
 #define INT_DELIVERY_MODE dest_LowestPrio

-- 

