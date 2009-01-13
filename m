Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbZAMKnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbZAMKnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbZAMKja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:39:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:51185 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbZAMKj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:39:28 -0500
From: Tejun Heo <tj@kernel.org>
To: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/13] x86_64: convert pda ops to wrappers around x86 percpu accessors
Date: Tue, 13 Jan 2009 19:38:15 +0900
Message-Id: <1231843097-18003-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231843097-18003-1-git-send-email-tj@kernel.org>
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:38:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pda is now a percpu variable and there's no reason it can't use plain
x86 percpu accessors.  Add x86_test_and_clear_bit_percpu() and replace
pda op implementations with wrappers around x86 percpu accessors.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/pda.h       |   88 +++-----------------------------------
 arch/x86/include/asm/percpu.h    |   10 ++++
 arch/x86/kernel/vmlinux_64.lds.S |    1 -
 arch/x86/kernel/x8664_ksyms_64.c |    2 -
 4 files changed, 16 insertions(+), 85 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 66ae104..e3d3a08 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -45,91 +45,15 @@ extern void pda_init(int);
 
 #define cpu_pda(cpu)		(&per_cpu(__pda, cpu))
 
-/*
- * There is no fast way to get the base address of the PDA, all the accesses
- * have to mention %fs/%gs.  So it needs to be done this Torvaldian way.
- */
-extern void __bad_pda_field(void) __attribute__((noreturn));
-
-/*
- * proxy_pda doesn't actually exist, but tell gcc it is accessed for
- * all PDA accesses so it gets read/write dependencies right.
- */
-extern struct x8664_pda _proxy_pda;
-
-#define pda_offset(field) offsetof(struct x8664_pda, field)
-
-#define pda_to_op(op, field, val)					\
-do {									\
-	typedef typeof(_proxy_pda.field) T__;				\
-	if (0) { T__ tmp__; tmp__ = (val); }	/* type checking */	\
-	switch (sizeof(_proxy_pda.field)) {				\
-	case 2:								\
-		asm(op "w %1,%%gs:%c2" :				\
-		    "+m" (_proxy_pda.field) :				\
-		    "ri" ((T__)val),					\
-		    "i"(pda_offset(field)));				\
-		break;							\
-	case 4:								\
-		asm(op "l %1,%%gs:%c2" :				\
-		    "+m" (_proxy_pda.field) :				\
-		    "ri" ((T__)val),					\
-		    "i" (pda_offset(field)));				\
-		break;							\
-	case 8:								\
-		asm(op "q %1,%%gs:%c2":					\
-		    "+m" (_proxy_pda.field) :				\
-		    "r" ((T__)val),					\
-		    "i"(pda_offset(field)));				\
-		break;							\
-	default:							\
-		__bad_pda_field();					\
-	}								\
-} while (0)
-
-#define pda_from_op(op, field)			\
-({						\
-	typeof(_proxy_pda.field) ret__;		\
-	switch (sizeof(_proxy_pda.field)) {	\
-	case 2:					\
-		asm(op "w %%gs:%c1,%0" :	\
-		    "=r" (ret__) :		\
-		    "i" (pda_offset(field)),	\
-		    "m" (_proxy_pda.field));	\
-		break;				\
-	case 4:					\
-		asm(op "l %%gs:%c1,%0":		\
-		    "=r" (ret__):		\
-		    "i" (pda_offset(field)),	\
-		    "m" (_proxy_pda.field));	\
-		break;				\
-	case 8:					\
-		asm(op "q %%gs:%c1,%0":		\
-		    "=r" (ret__) :		\
-		    "i" (pda_offset(field)),	\
-		    "m" (_proxy_pda.field));	\
-		break;				\
-	default:				\
-		__bad_pda_field();		\
-	}					\
-	ret__;					\
-})
-
-#define read_pda(field)		pda_from_op("mov", field)
-#define write_pda(field, val)	pda_to_op("mov", field, val)
-#define add_pda(field, val)	pda_to_op("add", field, val)
-#define sub_pda(field, val)	pda_to_op("sub", field, val)
-#define or_pda(field, val)	pda_to_op("or", field, val)
+#define read_pda(field)		x86_read_percpu(__pda.field)
+#define write_pda(field, val)	x86_write_percpu(__pda.field, val)
+#define add_pda(field, val)	x86_add_percpu(__pda.field, val)
+#define sub_pda(field, val)	x86_sub_percpu(__pda.field, val)
+#define or_pda(field, val)	x86_or_percpu(__pda.field, val)
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
 #define test_and_clear_bit_pda(bit, field)				\
-({									\
-	int old__;							\
-	asm volatile("btr %2,%%gs:%c3\n\tsbbl %0,%0"			\
-		     : "=r" (old__), "+m" (_proxy_pda.field)		\
-		     : "dIr" (bit), "i" (pda_offset(field)) : "memory");\
-	old__;								\
-})
+	x86_test_and_clear_bit_percpu(bit, __pda.field)
 
 #endif
 
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 556f84b..328b31a 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -121,6 +121,16 @@ do {							\
 #define x86_sub_percpu(var, val) percpu_to_op("sub", per_cpu__##var, val)
 #define x86_or_percpu(var, val) percpu_to_op("or", per_cpu__##var, val)
 
+/* This is not atomic against other CPUs -- CPU preemption needs to be off */
+#define x86_test_and_clear_bit_percpu(bit, var)				\
+({									\
+	int old__;							\
+	asm volatile("btr %1,"__percpu_seg_str"%c2\n\tsbbl %0,%0"	\
+		     : "=r" (old__)					\
+		     : "dIr" (bit), "i" (&per_cpu__##var) : "memory");	\
+	old__;								\
+})
+
 #ifdef CONFIG_X86_64
 extern void load_pda_offset(int cpu);
 #else
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index d2a0baa..a09abb8 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -14,7 +14,6 @@ OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(phys_startup_64)
 jiffies_64 = jiffies;
-_proxy_pda = 1;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
 	data PT_LOAD FLAGS(7);	/* RWE */
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 695e426..3909e3b 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -58,5 +58,3 @@ EXPORT_SYMBOL(__memcpy);
 EXPORT_SYMBOL(empty_zero_page);
 EXPORT_SYMBOL(init_level4_pgt);
 EXPORT_SYMBOL(load_gs_index);
-
-EXPORT_SYMBOL(_proxy_pda);
-- 
1.5.6

