Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbXKAAD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbXKAAD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 20:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbXKAADP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 20:03:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40560 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754358AbXKAADL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 20:03:11 -0400
Message-Id: <20071101000310.439787988@sgi.com>
References: <20071101000211.970501947@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 17:02:15 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 4/7] Percpu: Add support for this_cpu_offset() to be able to create this_cpu_ptr()
Content-Disposition: inline; filename=this_cpu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Support for this_cpu_ptr() is important for those arches that allow a faster
way to get to the per cpu area of the local processor.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-generic/percpu.h |    4 ++++
 include/asm-ia64/percpu.h    |    3 +++
 include/asm-powerpc/percpu.h |    3 +++
 include/asm-s390/percpu.h    |    4 ++++
 include/asm-sparc64/percpu.h |    2 ++
 include/asm-x86/percpu_32.h  |    2 ++
 include/asm-x86/percpu_64.h  |    4 ++++
 include/linux/percpu.h       |    7 +++++++
 8 files changed, 29 insertions(+)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2007-10-31 16:41:00.907621059 -0700
+++ linux-2.6/include/linux/percpu.h	2007-10-31 16:42:45.748121446 -0700
@@ -51,6 +51,13 @@
     	(__typeof__(ptr))(p + q);			\
 })
 
+#define this_cpu_ptr(ptr)           			\
+({							\
+	void *p = ptr;					\
+    	(__typeof__(ptr))(p + this_cpu_offset());	\
+})
+
+
 extern void *__alloc_percpu(size_t size);
 extern void percpu_free(void *__pdata);
 
Index: linux-2.6/include/asm-generic/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-generic/percpu.h	2007-10-31 16:36:43.452121172 -0700
+++ linux-2.6/include/asm-generic/percpu.h	2007-10-31 16:42:45.748121446 -0700
@@ -26,6 +26,8 @@ extern unsigned long __per_cpu_offset[NR
 #define __get_cpu_var(var) per_cpu(var, smp_processor_id())
 #define __raw_get_cpu_var(var) per_cpu(var, raw_smp_processor_id())
 
+#define this_cpu_offset() __per_cpu_offset(raw_smp_processor_id())
+
 /* A macro to avoid #include hell... */
 #define percpu_modcopy(pcpudst, src, size)			\
 do {								\
@@ -53,4 +55,6 @@ do {								\
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
 
+#define this_cpu_offset() 0
+
 #endif /* _ASM_GENERIC_PERCPU_H_ */
Index: linux-2.6/include/asm-ia64/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/percpu.h	2007-10-31 16:36:43.460121335 -0700
+++ linux-2.6/include/asm-ia64/percpu.h	2007-10-31 16:42:45.748121446 -0700
@@ -51,6 +51,8 @@ extern unsigned long __per_cpu_offset[NR
 /* Equal to __per_cpu_offset[smp_processor_id()], but faster to access: */
 DECLARE_PER_CPU(unsigned long, local_per_cpu_offset);
 
+#define this_cpu_offset() __ia64_per_cpu_var(local_per_cpu_offset)
+
 #define per_cpu(var, cpu)  (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset[cpu]))
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __ia64_per_cpu_var(local_per_cpu_offset)))
 #define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __ia64_per_cpu_var(local_per_cpu_offset)))
@@ -65,6 +67,7 @@ extern void *per_cpu_init(void);
 #define __get_cpu_var(var)			per_cpu__##var
 #define __raw_get_cpu_var(var)			per_cpu__##var
 #define per_cpu_init()				(__phys_per_cpu_start)
+#define this_cpu_offset()			0
 
 #endif	/* SMP */
 
Index: linux-2.6/include/asm-powerpc/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-powerpc/percpu.h	2007-10-31 16:36:43.464121161 -0700
+++ linux-2.6/include/asm-powerpc/percpu.h	2007-10-31 16:42:45.748121446 -0700
@@ -16,6 +16,8 @@
 #define __my_cpu_offset() get_paca()->data_offset
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
+#define this_cpu_offset() __my_cpu_offset()
+
 /* Separate out the type, so (int[3], foo) works. */
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
@@ -51,6 +53,7 @@ extern void setup_per_cpu_areas(void);
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
 #define __raw_get_cpu_var(var)			per_cpu__##var
+#define this_cpu_offset()			0
 
 #endif	/* SMP */
 
Index: linux-2.6/include/asm-s390/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-s390/percpu.h	2007-10-31 16:36:43.472121072 -0700
+++ linux-2.6/include/asm-s390/percpu.h	2007-10-31 16:42:45.779370925 -0700
@@ -51,6 +51,8 @@ extern unsigned long __per_cpu_offset[NR
 #define per_cpu(var,cpu) __reloc_hide(var,__per_cpu_offset[cpu])
 #define per_cpu_offset(x) (__per_cpu_offset[x])
 
+#define this_cpu_offset() S390_lowcore.percpu_offset
+
 /* A macro to avoid #include hell... */
 #define percpu_modcopy(pcpudst, src, size)			\
 do {								\
@@ -71,6 +73,8 @@ do {								\
 #define __raw_get_cpu_var(var) __reloc_hide(var,0)
 #define per_cpu(var,cpu) __reloc_hide(var,0)
 
+#define this_cpu_offset() 0
+
 #endif /* SMP */
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
Index: linux-2.6/include/asm-sparc64/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-sparc64/percpu.h	2007-10-31 16:36:43.480121400 -0700
+++ linux-2.6/include/asm-sparc64/percpu.h	2007-10-31 16:42:45.779370925 -0700
@@ -5,6 +5,8 @@
 
 register unsigned long __local_per_cpu_offset asm("g5");
 
+#define this_cpu_offset() __local_per_cpu_offset
+
 #ifdef CONFIG_SMP
 
 #define setup_per_cpu_areas()			do { } while (0)
Index: linux-2.6/include/asm-x86/percpu_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu_32.h	2007-10-31 16:36:43.484121314 -0700
+++ linux-2.6/include/asm-x86/percpu_32.h	2007-10-31 16:42:45.779370925 -0700
@@ -72,6 +72,8 @@ DECLARE_PER_CPU(unsigned long, this_cpu_
 	RELOC_HIDE(&per_cpu__##var, x86_read_percpu(this_cpu_off));	\
 }))
 
+#define this_cpu_offset() x86_read_percpu(this_cpu_off)
+
 #define __get_cpu_var(var) __raw_get_cpu_var(var)
 
 /* A macro to avoid #include hell... */
Index: linux-2.6/include/asm-x86/percpu_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu_64.h	2007-10-31 16:36:43.492121152 -0700
+++ linux-2.6/include/asm-x86/percpu_64.h	2007-10-31 16:42:45.779370925 -0700
@@ -14,6 +14,8 @@
 #define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
 #define __my_cpu_offset() read_pda(data_offset)
 
+#define this_cpu_offset() read_pda(data_offset)
+
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
 /* Separate out the type, so (int[3], foo) works. */
@@ -58,6 +60,8 @@ extern void setup_per_cpu_areas(void);
 #define __get_cpu_var(var)			per_cpu__##var
 #define __raw_get_cpu_var(var)			per_cpu__##var
 
+#define this_cpu_offset() 0
+
 #endif	/* SMP */
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name

-- 
