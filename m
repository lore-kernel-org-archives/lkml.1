Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbXK0APW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbXK0APW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757077AbXK0AOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:14:32 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45349 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756877AbXK0AOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:14:30 -0500
Message-Id: <20071127001429.852782494@sgi.com>
References: <20071127001407.859743255@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 26 Nov 2007 16:14:10 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>
Subject: [patch 03/14] Modules: Fold percpu_modcopy into module.c and get rid of the macro from hell
Content-Disposition: inline; filename=modcopy
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_modcopy() is defined multiple times in arch files. However, the only
user is module.c. Put a static definition into module.c and remove
the definitions from the arch files.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/ia64/kernel/module.c    |   10 ----------
 include/asm-generic/percpu.h |    8 --------
 include/asm-ia64/percpu.h    |    5 -----
 include/asm-powerpc/percpu.h |    9 ---------
 include/asm-s390/percpu.h    |    9 ---------
 include/asm-sparc64/percpu.h |    8 --------
 include/asm-x86/percpu_32.h  |    9 ---------
 include/asm-x86/percpu_64.h  |    9 ---------
 kernel/module.c              |    8 ++++++++
 9 files changed, 8 insertions(+), 67 deletions(-)

Index: linux-2.6/include/asm-generic/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-generic/percpu.h	2007-11-21 13:11:18.430858642 -0800
+++ linux-2.6/include/asm-generic/percpu.h	2007-11-21 13:11:42.871108294 -0800
@@ -26,14 +26,6 @@ extern unsigned long __per_cpu_offset[NR
 #define __get_cpu_var(var) per_cpu(var, smp_processor_id())
 #define __raw_get_cpu_var(var) per_cpu(var, raw_smp_processor_id())
 
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset[__i],		\
-		       (src), (size));				\
-} while (0)
 #else /* ! SMP */
 
 #define DEFINE_PER_CPU(type, name) \
Index: linux-2.6/arch/ia64/kernel/module.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/module.c	2007-11-21 13:13:06.587858751 -0800
+++ linux-2.6/arch/ia64/kernel/module.c	2007-11-21 13:13:19.527309025 -0800
@@ -941,13 +941,3 @@ module_arch_cleanup (struct module *mod)
 		unw_remove_unwind_table(mod->arch.core_unw_table);
 }
 
-#ifdef CONFIG_SMP
-void
-percpu_modcopy (void *pcpudst, const void *src, unsigned long size)
-{
-	unsigned int i;
-	for_each_possible_cpu(i) {
-		memcpy(pcpudst + __per_cpu_offset[i], src, size);
-	}
-}
-#endif /* CONFIG_SMP */
Index: linux-2.6/include/asm-ia64/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/percpu.h	2007-11-21 13:12:37.140358213 -0800
+++ linux-2.6/include/asm-ia64/percpu.h	2007-11-21 13:12:55.271731039 -0800
@@ -39,10 +39,6 @@
 	DEFINE_PER_CPU(type, name)
 #endif
 
-/*
- * Pretty much a literal copy of asm-generic/percpu.h, except that percpu_modcopy() is an
- * external routine, to avoid include-hell.
- */
 #ifdef CONFIG_SMP
 
 extern unsigned long __per_cpu_offset[NR_CPUS];
@@ -55,7 +51,6 @@ DECLARE_PER_CPU(unsigned long, local_per
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __ia64_per_cpu_var(local_per_cpu_offset)))
 #define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __ia64_per_cpu_var(local_per_cpu_offset)))
 
-extern void percpu_modcopy(void *pcpudst, const void *src, unsigned long size);
 extern void setup_per_cpu_areas (void);
 extern void *per_cpu_init(void);
 
Index: linux-2.6/include/asm-powerpc/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-powerpc/percpu.h	2007-11-21 13:14:21.754859049 -0800
+++ linux-2.6/include/asm-powerpc/percpu.h	2007-11-21 13:14:33.651108379 -0800
@@ -30,15 +30,6 @@
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()))
 #define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, local_paca->data_offset))
 
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset(__i),		\
-		       (src), (size));				\
-} while (0)
-
 extern void setup_per_cpu_areas(void);
 
 #else /* ! SMP */
Index: linux-2.6/include/asm-s390/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-s390/percpu.h	2007-11-21 13:14:39.835108493 -0800
+++ linux-2.6/include/asm-s390/percpu.h	2007-11-21 13:14:48.590858137 -0800
@@ -51,15 +51,6 @@ extern unsigned long __per_cpu_offset[NR
 #define per_cpu(var,cpu) __reloc_hide(var,__per_cpu_offset[cpu])
 #define per_cpu_offset(x) (__per_cpu_offset[x])
 
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset[__i],		\
-		       (src), (size));				\
-} while (0)
-
 #else /* ! SMP */
 
 #define DEFINE_PER_CPU(type, name) \
Index: linux-2.6/include/asm-sparc64/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-sparc64/percpu.h	2007-11-21 13:15:04.043858836 -0800
+++ linux-2.6/include/asm-sparc64/percpu.h	2007-11-21 13:15:11.330973138 -0800
@@ -30,14 +30,6 @@ extern unsigned long __per_cpu_shift;
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __local_per_cpu_offset))
 #define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __local_per_cpu_offset))
 
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset(__i),		\
-		       (src), (size));				\
-} while (0)
 #else /* ! SMP */
 
 #define real_setup_per_cpu_areas()		do { } while (0)
Index: linux-2.6/include/asm-x86/percpu_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu_32.h	2007-11-21 13:15:19.947608444 -0800
+++ linux-2.6/include/asm-x86/percpu_32.h	2007-11-21 13:15:26.562798940 -0800
@@ -74,15 +74,6 @@ DECLARE_PER_CPU(unsigned long, this_cpu_
 
 #define __get_cpu_var(var) __raw_get_cpu_var(var)
 
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset[__i],		\
-		       (src), (size));				\
-} while (0)
-
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
 
Index: linux-2.6/include/asm-x86/percpu_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu_64.h	2007-11-21 13:15:29.222858444 -0800
+++ linux-2.6/include/asm-x86/percpu_64.h	2007-11-21 13:15:34.703108217 -0800
@@ -36,15 +36,6 @@
 	extern int simple_identifier_##var(void);	\
 	RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()); }))
 
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset(__i),		\
-		       (src), (size));				\
-} while (0)
-
 extern void setup_per_cpu_areas(void);
 
 #else /* ! SMP */
Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c	2007-11-21 13:18:06.743108472 -0800
+++ linux-2.6/kernel/module.c	2007-11-21 13:23:29.394688088 -0800
@@ -423,6 +423,14 @@ static unsigned int find_pcpusec(Elf_Ehd
 	return find_sec(hdr, sechdrs, secstrings, ".data.percpu");
 }
 
+static void percpu_modcopy(void *pcpudest, const void *from, unsigned long size)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		memcpy(pcpudest + per_cpu_offset(cpu), from, size);
+}
+
 static int percpu_modinit(void)
 {
 	pcpu_num_used = 2;

-- 
