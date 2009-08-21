Return-Path: <linux-kernel-owner+w=401wt.eu-S932984AbZHUVcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984AbZHUVcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932966AbZHUVcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:32:33 -0400
Received: from www.tglx.de ([62.245.132.106]:51774 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932965AbZHUVc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:32:29 -0400
Message-Id: <20090821205602.584376844@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:30:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 16/32] x86: Replace ARCH_SETUP by a proper platform
	function
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-move-arch-setup-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARCH_SETUP is a horrible hack of paravirt/xen which is way nicer to
read as a platform setup function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/paravirt.h  |    2 --
 arch/x86/include/asm/platform.h  |    9 +++++++++
 arch/x86/kernel/paravirt.c       |    1 -
 arch/x86/kernel/platform_setup.c |    4 ++++
 arch/x86/kernel/setup.c          |    6 +-----
 arch/x86/xen/enlighten.c         |    2 +-
 6 files changed, 15 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/include/asm/paravirt.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/paravirt.h
+++ linux-2.6/arch/x86/include/asm/paravirt.h
@@ -87,7 +87,6 @@ struct pv_init_ops {
 			  unsigned long addr, unsigned len);
 
 	/* Basic arch-specific setup */
-	void (*arch_setup)(void);
 	void (*post_allocator_init)(void);
 
 	/* Print a banner to identify the environment */
@@ -699,7 +698,6 @@ static inline void load_sp0(struct tss_s
 	PVOP_VCALL2(pv_cpu_ops.load_sp0, tss, thread);
 }
 
-#define ARCH_SETUP			pv_init_ops.arch_setup();
 static inline unsigned long get_wallclock(void)
 {
 	return PVOP_CALL0(unsigned long, pv_time_ops.get_wallclock);
Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -63,6 +63,14 @@ struct platform_setup_irqs {
 };
 
 /**
+ * struct platform_setup_oem - oem platform specific customizing functions
+ * @arch_setup:			platform specific architecure setup
+ */
+struct platform_setup_oem {
+	void (*arch_setup)(void);
+};
+
+/**
  * struct platform_setup_ops - functions for platform specific setup
  *
  */
@@ -70,6 +78,7 @@ struct platform_setup_ops {
 	struct platform_setup_resources resources;
 	struct platform_setup_mpparse mpparse;
 	struct platform_setup_irqs irqs;
+	struct platform_setup_oem oem;
 	struct platform_setup_quirks quirks;
 };
 
Index: linux-2.6/arch/x86/kernel/paravirt.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/paravirt.c
+++ linux-2.6/arch/x86/kernel/paravirt.c
@@ -311,7 +311,6 @@ struct pv_info pv_info = {
 struct pv_init_ops pv_init_ops = {
 	.patch = native_patch,
 	.banner = default_banner,
-	.arch_setup = paravirt_nop,
 };
 
 struct pv_time_ops pv_time_ops = {
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -42,6 +42,10 @@ struct __initdata platform_setup_ops pla
 		.trap_init = platform_setup_noop,
 	},
 
+	.oem = {
+		.arch_setup = platform_setup_noop,
+	},
+
 	.quirks = {
 		.mpc_record = platform_setup_uint_noop,
 	},
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -108,10 +108,6 @@
 #include <asm/numa_64.h>
 #endif
 
-#ifndef ARCH_SETUP
-#define ARCH_SETUP
-#endif
-
 /*
  * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
  * The direct mapping extends to max_pfn_mapped, so that we can directly access
@@ -750,7 +746,7 @@ void __init setup_arch(char **cmdline_p)
 	}
 #endif
 
-	ARCH_SETUP
+	platform_setup.oem.arch_setup();
 
 	setup_memory_map();
 	parse_setup_data();
Index: linux-2.6/arch/x86/xen/enlighten.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/enlighten.c
+++ linux-2.6/arch/x86/xen/enlighten.c
@@ -841,7 +841,6 @@ static const struct pv_init_ops xen_init
 	.patch = xen_patch,
 
 	.banner = xen_banner,
-	.arch_setup = xen_arch_setup,
 	.post_allocator_init = xen_post_allocator_init,
 };
 
@@ -986,6 +985,7 @@ asmlinkage void __init xen_start_kernel(
 	pv_mmu_ops = xen_mmu_ops;
 
 	platform_setup.resources.memory_setup = xen_memory_setup;
+	platform_setup.oem.arch_setup = xen_arch_setup;
 
 	xen_init_irq_ops();
 


