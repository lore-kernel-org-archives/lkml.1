Return-Path: <linux-kernel-owner+w=401wt.eu-S933653AbXK3GpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653AbXK3GpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 01:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932668AbXK3GoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 01:44:08 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51771 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756652AbXK3GoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 01:44:02 -0500
Message-Id: <20071130064400.054191278@sgi.com>
References: <20071130064305.459255715@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 Nov 2007 22:43:08 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 3/3] x86_64: Make the x86_32 percpu operations usable on x86_64
Content-Disposition: inline; filename=x86_64_rebase_compat
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Relocate the x86_64 percpu variables to begin at zero. Then
we can directly use the x86_32 percpu operations. x86_32
offsets %fs by __per_cpu_start. x86_64 has %gs pointing
directly to the pda and the per cpu area if they start at zero.

Access to the pda with the x86_64 pda operations is still
possible in addition to access to the per cpu variables
using x86_32 percpu operations.

Hopefully this is helpful for arch integration.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/Kconfig                 |    5 +++++
 arch/x86/kernel/setup64.c        |    4 ++--
 arch/x86/kernel/vmlinux_64.lds.S |    1 +
 include/asm-x86/percpu.h         |   12 +++++++++++-
 4 files changed, 19 insertions(+), 3 deletions(-)

Index: linux-2.6.24-rc3-mm2/include/asm-x86/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-x86/percpu.h	2007-11-29 22:13:54.806575787 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-x86/percpu.h	2007-11-29 22:21:42.383571603 -0800
@@ -17,6 +17,12 @@
 
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
+#define __percpu_seg "%%gs:"
+
+#else
+
+#define __percpu_seg ""
+
 #endif
 #include <asm-generic/percpu.h>
 
@@ -81,6 +87,11 @@ DECLARE_PER_CPU(struct x8664_pda, pda);
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
+#endif /* __ASSEMBLY__ */
+#endif /* !CONFIG_X86_64 */
+
+#ifndef __ASSEMBLY__
+
 /* For arch-specific code, we can use direct single-insn ops (they
  * don't give an lvalue though). */
 extern void __bad_percpu_size(void);
@@ -138,5 +149,4 @@ extern void __bad_percpu_size(void);
 #define x86_sub_percpu(var,val) percpu_to_op("sub", per_cpu__##var, val)
 #define x86_or_percpu(var,val) percpu_to_op("or", per_cpu__##var, val)
 #endif /* !__ASSEMBLY__ */
-#endif /* !CONFIG_X86_64 */
 #endif /* _ASM_X86_PERCPU_H_ */
Index: linux-2.6.24-rc3-mm2/arch/x86/Kconfig
===================================================================
--- linux-2.6.24-rc3-mm2.orig/arch/x86/Kconfig	2007-11-29 22:05:39.003576212 -0800
+++ linux-2.6.24-rc3-mm2/arch/x86/Kconfig	2007-11-29 22:12:53.942575452 -0800
@@ -123,6 +123,11 @@ config GENERIC_TIME_VSYSCALL
 config ARCH_SETS_UP_PER_CPU_AREA
 	def_bool X86_64
 
+config PERCPU_ZERO_BASED
+	bool
+	depends on X86_64 && SMP
+	default y
+
 config ZONE_DMA32
 	bool
 	default X86_64
Index: linux-2.6.24-rc3-mm2/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/arch/x86/kernel/setup64.c	2007-11-29 22:12:08.962826086 -0800
+++ linux-2.6.24-rc3-mm2/arch/x86/kernel/setup64.c	2007-11-29 22:12:53.942575452 -0800
@@ -111,11 +111,11 @@ void __init setup_per_cpu_areas(void)
 		}
 		if (!ptr)
 			panic("Cannot allocate cpu data for CPU %d\n", i);
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+		memcpy(ptr, __per_cpu_load, __per_cpu_size);
 		/* Relocate the pda */
 		memcpy(ptr, cpu_pda(i), sizeof(struct x8664_pda));
 		cpu_pda(i) = (struct x8664_pda *)ptr;
-		cpu_pda(i)->data_offset = ptr - __per_cpu_start;
+		cpu_pda(i)->data_offset = (unsigned long)ptr;
 	}
 	/* Fix up pda for this processor .... */
 	pda_init(0);
Index: linux-2.6.24-rc3-mm2/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6.24-rc3-mm2.orig/arch/x86/kernel/vmlinux_64.lds.S	2007-11-29 22:05:38.987576338 -0800
+++ linux-2.6.24-rc3-mm2/arch/x86/kernel/vmlinux_64.lds.S	2007-11-29 22:12:53.930825752 -0800
@@ -16,6 +16,7 @@ jiffies_64 = jiffies;
 _proxy_pda = 1;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
+	percpu PT_LOAD FLAGS(4);	/* R__ */
 	data PT_LOAD FLAGS(7);	/* RWE */
 	user PT_LOAD FLAGS(7);	/* RWE */
 	data.init PT_LOAD FLAGS(7);	/* RWE */

-- 
