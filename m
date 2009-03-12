Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbZCLMhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbZCLMhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZCLMg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:36:57 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:37421 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZCLMg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:36:56 -0400
Message-Id: <49B9101E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 12:37:34 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: also use cpuinfo_x86's x86_{phys,virt}_bits
	 members
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: 32/64-bit consolidation

In a first step, this allows fixing phys_addr_valid() for PAE (which
until now reported all addresses to be valid). Subsequently, this will
also allow simplifying some MTRR handling code.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/processor.h |    2 +-
 arch/x86/kernel/cpu/common.c     |   12 +++++++++++-
 arch/x86/kernel/cpu/intel.c      |    5 +++++
 arch/x86/mm/ioremap.c            |   17 ++++++++---------
 4 files changed, 25 insertions(+), 11 deletions(-)

--- linux-2.6.29-rc7/arch/x86/include/asm/processor.h	2009-03-04 09:10:19.000000000 +0100
+++ 2.6.29-rc7-x86-phys-virt-bits/arch/x86/include/asm/processor.h	2009-03-06 10:24:22.000000000 +0100
@@ -74,9 +74,9 @@ struct cpuinfo_x86 {
 #else
 	/* Number of 4K pages in DTLB/ITLB combined(in pages): */
 	int			 x86_tlbsize;
+#endif
 	__u8			x86_virt_bits;
 	__u8			x86_phys_bits;
-#endif
 	/* CPUID returned core id bits: */
 	__u8			x86_coreid_bits;
 	/* Max extended CPUID function supported: */
--- linux-2.6.29-rc7/arch/x86/kernel/cpu/common.c	2009-03-04 09:10:19.000000000 +0100
+++ 2.6.29-rc7-x86-phys-virt-bits/arch/x86/kernel/cpu/common.c	2009-03-06 10:24:22.000000000 +0100
@@ -493,13 +493,15 @@ static void __cpuinit get_cpu_cap(struct
 		}
 	}
 
-#ifdef CONFIG_X86_64
 	if (c->extended_cpuid_level >= 0x80000008) {
 		u32 eax = cpuid_eax(0x80000008);
 
 		c->x86_virt_bits = (eax >> 8) & 0xff;
 		c->x86_phys_bits = eax & 0xff;
 	}
+#ifdef CONFIG_X86_32
+	else if (cpu_has(c, X86_FEATURE_PAE) || cpu_has(c, X86_FEATURE_PSE36))
+		c->x86_phys_bits = 36;
 #endif
 
 	if (c->extended_cpuid_level >= 0x80000007)
@@ -546,8 +548,12 @@ static void __init early_identify_cpu(st
 {
 #ifdef CONFIG_X86_64
 	c->x86_clflush_size = 64;
+	c->x86_phys_bits = 36;
+	c->x86_virt_bits = 48;
 #else
 	c->x86_clflush_size = 32;
+	c->x86_phys_bits = 32;
+	c->x86_virt_bits = 32;
 #endif
 	c->x86_cache_alignment = c->x86_clflush_size;
 
@@ -671,9 +677,13 @@ static void __cpuinit identify_cpu(struc
 	c->x86_coreid_bits = 0;
 #ifdef CONFIG_X86_64
 	c->x86_clflush_size = 64;
+	c->x86_phys_bits = 36;
+	c->x86_virt_bits = 48;
 #else
 	c->cpuid_level = -1;	/* CPUID not detected */
 	c->x86_clflush_size = 32;
+	c->x86_phys_bits = 32;
+	c->x86_virt_bits = 32;
 #endif
 	c->x86_cache_alignment = c->x86_clflush_size;
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
--- linux-2.6.29-rc7/arch/x86/kernel/cpu/intel.c	2009-03-04 09:10:19.000000000 +0100
+++ 2.6.29-rc7-x86-phys-virt-bits/arch/x86/kernel/cpu/intel.c	2009-03-06 10:24:22.000000000 +0100
@@ -54,6 +54,11 @@ static void __cpuinit early_init_intel(s
 		c->x86_cache_alignment = 128;
 #endif
 
+	/* CPUID workaround for 0F33/0F34 CPU */
+	if (c->x86 == 0xF && c->x86_model == 0x3
+	    && (c->x86_mask == 0x3 || c->x86_mask == 0x4))
+		c->x86_phys_bits = 36;
+
 	/*
 	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
 	 * with P/T states and does not stop in deep C-states
--- linux-2.6.29-rc7/arch/x86/mm/ioremap.c	2009-03-04 09:10:19.000000000 +0100
+++ 2.6.29-rc7-x86-phys-virt-bits/arch/x86/mm/ioremap.c	2009-03-06 10:24:22.000000000 +0100
@@ -22,13 +22,17 @@
 #include <asm/pgalloc.h>
 #include <asm/pat.h>
 
-#ifdef CONFIG_X86_64
-
-static inline int phys_addr_valid(unsigned long addr)
+static inline int phys_addr_valid(resource_size_t addr)
 {
-	return addr < (1UL << boot_cpu_data.x86_phys_bits);
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+	return !(addr >> boot_cpu_data.x86_phys_bits);
+#else
+	return 1;
+#endif
 }
 
+#ifdef CONFIG_X86_64
+
 unsigned long __phys_addr(unsigned long x)
 {
 	if (x >= __START_KERNEL_map) {
@@ -68,11 +72,6 @@ EXPORT_SYMBOL(__virt_addr_valid);
 
 #else
 
-static inline int phys_addr_valid(unsigned long addr)
-{
-	return 1;
-}
-
 #ifdef CONFIG_DEBUG_VIRTUAL
 unsigned long __phys_addr(unsigned long x)
 {



