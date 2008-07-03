Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbYGCVeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbYGCVeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbYGCVe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:34:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:7222 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbYGCVe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:34:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=gGf8t7RvgfaM41viRqaFHuwDPx8i/HFXDwNvuoQf9vFIh5rojqjh5cDlEPo4mGysq1
         9DUltcQtV7O9AF/HNcxt0q57PqHinBfKoYPqwnb2HR2YAdKz4FFN7XCrSfu32cCxW/DU
         rVzdQ6EZUw5HNzBSOSLw5NpaBz01d3j680Yzs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86/acpi: remove have_arch_parse_srat
Date: Thu, 3 Jul 2008 14:35:36 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807031435.36508.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we already have the same srat handling interface for 32bit.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/ia64/Kconfig          |    4 ----
 arch/x86/Kconfig           |    4 ----
 arch/x86/mm/discontig_32.c |   17 -----------------
 drivers/acpi/numa.c        |    4 ----
 include/linux/acpi.h       |    3 +--
 5 files changed, 1 insertion(+), 31 deletions(-)

Index: linux-2.6/arch/ia64/Kconfig
===================================================================
--- linux-2.6.orig/arch/ia64/Kconfig
+++ linux-2.6/arch/ia64/Kconfig
@@ -60,10 +60,6 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default y
 
-config HAVE_ARCH_PARSE_SRAT
-	bool
-	default y
-
 config ARCH_HAS_ILOG2_U32
 	bool
 	default n
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -465,10 +465,6 @@ config ACPI_SRAT
 	depends on X86_32 && ACPI && NUMA && X86_GENERICARCH
 	select ACPI_NUMA
 
-config HAVE_ARCH_PARSE_SRAT
-	def_bool y
-	depends on ACPI_SRAT
-
 config X86_SUMMIT_NUMA
 	def_bool y
 	depends on X86_32 && NUMA && X86_GENERICARCH
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -443,20 +443,3 @@ int memory_add_physaddr_to_nid(u64 addr)
 EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 #endif
 
-#if defined(CONFIG_ACPI_NUMA) && !defined(CONFIG_HAVE_ARCH_PARSE_SRAT)
-/*
- * Dummy on 32-bit, for now:
- */
-void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
-{
-}
-
-void __init
-acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
-{
-}
-
-void __init acpi_numa_arch_fixup(void)
-{
-}
-#endif
Index: linux-2.6/drivers/acpi/numa.c
===================================================================
--- linux-2.6.orig/drivers/acpi/numa.c
+++ linux-2.6/drivers/acpi/numa.c
@@ -207,7 +207,6 @@ acpi_parse_processor_affinity(struct acp
 	return 0;
 }
 
-#ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
 static int __init
 acpi_parse_memory_affinity(struct acpi_subtable_header * header,
 			   const unsigned long end)
@@ -225,7 +224,6 @@ acpi_parse_memory_affinity(struct acpi_s
 
 	return 0;
 }
-#endif
 
 static int __init acpi_parse_srat(struct acpi_table_header *table)
 {
@@ -254,11 +252,9 @@ int __init acpi_numa_init(void)
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
 				      acpi_parse_processor_affinity, NR_CPUS);
-#ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 				      acpi_parse_memory_affinity,
 				      NR_NODE_MEMBLKS);
-#endif
 	}
 
 	/* SLIT: System Locality Information Table */
Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -94,8 +94,7 @@ int acpi_parse_mcfg (struct acpi_table_h
 void acpi_table_print_madt_entry (struct acpi_subtable_header *madt);
 
 /* the following four functions are architecture-dependent */
-#if defined(CONFIG_HAVE_ARCH_PARSE_SRAT) && !defined(NR_NODE_MEMBLKS)
-#define NR_NODE_MEMBLKS MAX_NUMNODES
+#ifndef CONFIG_ACPI_NUMA
 #define acpi_numa_slit_init(slit) do {} while (0)
 #define acpi_numa_processor_affinity_init(pa) do {} while (0)
 #define acpi_numa_memory_affinity_init(ma) do {} while (0)
