Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYIEPA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYIEPA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 11:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYIEPAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 11:00:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35993 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbYIEPAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 11:00:51 -0400
Date: Fri, 5 Sep 2008 17:00:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v2)
Message-ID: <20080905150030.GD10292@elte.hu>
References: <48C13D1C.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C13D1C.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use the
> former in ioremap's phys_addr_valid() check also on 32bit/PAE.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/kernel/cpu/common.c |   17 +++++++++++++++++
>  arch/x86/mm/ioremap.c        |   15 ++++++---------
>  include/asm-x86/processor.h  |    4 ++--
>  3 files changed, 25 insertions(+), 11 deletions(-)

hm, the cpu/common.c bits just got reworked massively in tip/master. 
I've tried a blind merge (see the patch below) but at least the first 
hunk looks wrong. Mind looking at how to merge this?

	Ingo

--------------->
Subject: x86: x86_{phys,virt}_bits field also for i386 (v2)
From: "Jan Beulich" <jbeulich@novell.com>
Date: Fri, 05 Sep 2008 13:07:24 +0100

Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use the
former in ioremap's phys_addr_valid() check also on 32bit/PAE.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/kernel/cpu/common.c |   17 +++++++++++++++++
 arch/x86/mm/ioremap.c        |   15 ++++++---------
 include/asm-x86/processor.h  |    4 ++--
 3 files changed, 25 insertions(+), 11 deletions(-)

Index: tip/arch/x86/kernel/cpu/common.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/common.c
+++ tip/arch/x86/kernel/cpu/common.c
@@ -464,6 +464,18 @@ static void __cpuinit get_cpu_cap(struct
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
 
 #ifdef CONFIG_X86_64
@@ -503,6 +515,8 @@ static void __init early_identify_cpu(st
 	c->x86_clflush_size = 32;
 #endif
 	c->x86_cache_alignment = c->x86_clflush_size;
+	c->x86_phys_bits = 32;
+	c->x86_virt_bits = 32;
 
 	if (!have_cpuid_p())
 		return;
@@ -513,6 +527,9 @@ static void __init early_identify_cpu(st
 
 	cpu_detect(c);
 
+	if (cpu_has(c, X86_FEATURE_PAE) || cpu_has(c, X86_FEATURE_PSE36))
+		c->x86_phys_bits = 36;
+
 	get_cpu_vendor(c);
 
 	get_cpu_cap(c);
Index: tip/arch/x86/mm/ioremap.c
===================================================================
--- tip.orig/arch/x86/mm/ioremap.c
+++ tip/arch/x86/mm/ioremap.c
@@ -24,11 +24,6 @@
 
 #ifdef CONFIG_X86_64
 
-static inline int phys_addr_valid(unsigned long addr)
-{
-	return addr < (1UL << boot_cpu_data.x86_phys_bits);
-}
-
 unsigned long __phys_addr(unsigned long x)
 {
 	if (x >= __START_KERNEL_map) {
@@ -45,13 +40,14 @@ unsigned long __phys_addr(unsigned long 
 }
 EXPORT_SYMBOL(__phys_addr);
 
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
 #ifdef CONFIG_DEBUG_VIRTUAL
 unsigned long __phys_addr(unsigned long x)
 {
@@ -62,6 +58,7 @@ unsigned long __phys_addr(unsigned long 
 }
 EXPORT_SYMBOL(__phys_addr);
 #endif
+}
 
 #endif
 
Index: tip/include/asm-x86/processor.h
===================================================================
--- tip.orig/include/asm-x86/processor.h
+++ tip/include/asm-x86/processor.h
@@ -74,8 +74,6 @@ struct cpuinfo_x86 {
 #else
 	/* Number of 4K pages in DTLB/ITLB combined(in pages): */
 	int			 x86_tlbsize;
-	__u8			x86_virt_bits;
-	__u8			x86_phys_bits;
 	/* CPUID returned core id bits: */
 	__u8			x86_coreid_bits;
 #endif
@@ -100,6 +98,8 @@ struct cpuinfo_x86 {
 	u16			apicid;
 	u16			initial_apicid;
 	u16			x86_clflush_size;
+	u8			x86_virt_bits;
+	u8			x86_phys_bits;
 #ifdef CONFIG_SMP
 	/* number of cores as seen by the OS: */
 	u16			booted_cores;
