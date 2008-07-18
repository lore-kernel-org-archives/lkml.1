Return-Path: <linux-kernel-owner+w=401wt.eu-S1760548AbYGRMnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760548AbYGRMnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760321AbYGRMmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:42:49 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:30737 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760296AbYGRMms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:42:48 -0400
Message-Id: <4880AC00.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 13:43:12 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: x86_{phys,virt}_bits field also for i386
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use the
former in ioremap's phys_addr_valid() check also on 32bit/PAE.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/cpu/common.c |   18 ++++++++++++++++++
 arch/x86/mm/ioremap.c        |   15 ++++++---------
 include/asm-x86/processor.h  |    4 ++--
 3 files changed, 26 insertions(+), 11 deletions(-)

--- linux-2.6.26/arch/x86/kernel/cpu/common.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-x86-phys-bits/arch/x86/kernel/cpu/common.c	2008-07-15 14:51:28.000000000 +0200
@@ -305,6 +305,18 @@ static void __cpuinit early_get_cap(stru
 				c->x86_capability[1] = cpuid_edx(0x80000001);
 				c->x86_capability[6] = cpuid_ecx(0x80000001);
 			}
+			if (xlvl >= 0x80000008) {
+				u32 eax = cpuid_eax(0x80000008);
+
+				c->x86_phys_bits = eax & 0xff;
+				c->x86_virt_bits = (eax >> 8) & 0xff;
+				/* CPUID workaround for Intel 0F33/0F34 CPU */
+				if (c->x86_vendor == X86_VENDOR_INTEL
+				    && c->x86 == 0xF && c->x86_model == 0x3
+				    && (c->x86_mask == 0x3
+					|| c->x86_mask == 0x4))
+					c->x86_phys_bits = 36;
+			}
 		}
 
 	}
@@ -326,6 +338,12 @@ static void __init early_cpu_detect(void
 
 	c->x86_cache_alignment = 32;
 	c->x86_clflush_size = 32;
+#ifdef CONFIG_X86_PAE
+	c->x86_phys_bits = 36;
+#else
+	c->x86_phys_bits = 32;
+#endif
+	c->x86_virt_bits = 32;
 
 	if (!have_cpuid_p())
 		return;
--- linux-2.6.26/arch/x86/mm/ioremap.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-x86-phys-bits/arch/x86/mm/ioremap.c	2008-07-15 14:51:28.000000000 +0200
@@ -31,19 +31,16 @@ unsigned long __phys_addr(unsigned long 
 }
 EXPORT_SYMBOL(__phys_addr);
 
-static inline int phys_addr_valid(unsigned long addr)
-{
-	return addr < (1UL << boot_cpu_data.x86_phys_bits);
-}
-
-#else
+#endif
 
-static inline int phys_addr_valid(unsigned long addr)
+static inline int phys_addr_valid(resource_size_t addr)
 {
+#ifdef CONFIG_RESOURCES_64BIT
+	return !(addr >> boot_cpu_data.x86_phys_bits);
+#else
 	return 1;
-}
-
 #endif
+}
 
 int page_is_ram(unsigned long pagenr)
 {
--- linux-2.6.26/include/asm-x86/processor.h	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-x86-phys-bits/include/asm-x86/processor.h	2008-07-15 14:51:28.000000000 +0200
@@ -73,8 +73,6 @@ struct cpuinfo_x86 {
 #else
 	/* Number of 4K pages in DTLB/ITLB combined(in pages): */
 	int			 x86_tlbsize;
-	__u8			x86_virt_bits;
-	__u8			x86_phys_bits;
 	/* CPUID returned core id bits: */
 	__u8			x86_coreid_bits;
 	/* Max extended CPUID function supported: */
@@ -99,6 +97,8 @@ struct cpuinfo_x86 {
 	u16			apicid;
 	u16			initial_apicid;
 	u16			x86_clflush_size;
+	u8			x86_virt_bits;
+	u8			x86_phys_bits;
 #ifdef CONFIG_SMP
 	/* number of cores as seen by the OS: */
 	u16			booted_cores;



