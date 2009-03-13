Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbZCMCfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbZCMCfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbZCMCee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:34:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:39533 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417AbZCMCec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:34:32 -0400
Date: Fri, 13 Mar 2009 02:33:47 GMT
From: Jan Beulich <jbeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B9101E.76E4.0078.0@novell.com>
References: <49B9101E.76E4.0078.0@novell.com>
Subject: [tip:x86/mm] x86, 32-bit: also use cpuinfo_x86's x86_{phys,virt}_bits members
Message-ID: <tip-13c6c53282d99c82e79b02477efd2c1e30a991ef@git.kernel.org>
Git-Commit-ID: 13c6c53282d99c82e79b02477efd2c1e30a991ef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 02:33:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13c6c53282d99c82e79b02477efd2c1e30a991ef
Gitweb:     http://git.kernel.org/tip/13c6c53282d99c82e79b02477efd2c1e30a991ef
Author:     Jan Beulich <jbeulich@novell.com>
AuthorDate: Thu, 12 Mar 2009 12:37:34 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 02:37:17 +0100

x86, 32-bit: also use cpuinfo_x86's x86_{phys,virt}_bits members

Impact: 32/64-bit consolidation

In a first step, this allows fixing phys_addr_valid() for PAE (which
until now reported all addresses to be valid). Subsequently, this will
also allow simplifying some MTRR handling code.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49B9101E.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/processor.h |    2 +-
 arch/x86/kernel/cpu/common.c     |   12 +++++++++++-
 arch/x86/kernel/cpu/intel.c      |    5 +++++
 arch/x86/mm/ioremap.c            |   17 ++++++++---------
 4 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7613950..bd3406d 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -75,9 +75,9 @@ struct cpuinfo_x86 {
 #else
 	/* Number of 4K pages in DTLB/ITLB combined(in pages): */
 	int			x86_tlbsize;
+#endif
 	__u8			x86_virt_bits;
 	__u8			x86_phys_bits;
-#endif
 	/* CPUID returned core id bits: */
 	__u8			x86_coreid_bits;
 	/* Max extended CPUID function supported: */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 826d5c8..a95e948 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -549,13 +549,15 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
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
@@ -602,8 +604,12 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
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
 
@@ -726,9 +732,13 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
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
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 191117f..ae76947 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -54,6 +54,11 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
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
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index aca924a..83ed74a 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
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
@@ -65,11 +69,6 @@ EXPORT_SYMBOL(__virt_addr_valid);
 
 #else
 
-static inline int phys_addr_valid(unsigned long addr)
-{
-	return 1;
-}
-
 #ifdef CONFIG_DEBUG_VIRTUAL
 unsigned long __phys_addr(unsigned long x)
 {
