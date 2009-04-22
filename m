Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbZDVUs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbZDVUs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbZDVUsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:48:11 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:42183 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756982AbZDVUsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:48:09 -0400
Message-Id: <20090422202453.829846363@polymtl.ca>
References: <20090422201852.092307236@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 22 Apr 2009 16:18:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mark.langsdorf@amd.com,
       arekm@maven.pl, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@qumranet.com>
Subject: [patch 2/2] x86 amd fix cmpxchg read acquire barrier
Content-Disposition: inline; filename=x86-amd-fix-cmpxchg-read-acquire-barrier.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 22 Apr 2009 20:46:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://google-perftools.googlecode.com/svn-history/r48/trunk/src/base/atomicops-internals-x86.cc

says

"  // Opteron Rev E has a bug in which on very rare occasions a locked
  // instruction doesn't act as a read-acquire barrier if followed by a
  // non-locked read-modify-write instruction.  Rev F has this bug in 
  // pre-release versions, but not in versions released to customers,
  // so we test only for Rev E, which is family 15, model 32..63 inclusive.
  if (strcmp(vendor, "AuthenticAMD") == 0 &&       // AMD
      family == 15 &&
      32 <= model && model <= 63) {
    AtomicOps_Internalx86CPUFeatures.has_amd_lock_mb_bug = true;
  } else {
    AtomicOps_Internalx86CPUFeatures.has_amd_lock_mb_bug = false;
  }
"

There is no official AMD bug ID yet, but it seems to be reported in the field
and a fix is present in Solaris code base. The following links shows the current
understanding of the issue.

http://bugzilla.kernel.org/show_bug.cgi?id=11305
http://bugs.mysql.com/bug.php?id=26081

Since I needed to put the alternative within assembly statements, I decided to
rework alternative.h and fold the multiple alternative*() definitions into the
same ALTERNATIVE() macro. It is done in the previous patch. Those were
duplicated code anyway.

AFAIK, this bug has not received any official bug ID from AMD. Solaris already
have a workaround for this issue.

One should probably audit Xen cmpxchg too.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: mark.langsdorf@amd.com
CC: arekm@maven.pl
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Avi Kivity <avi@qumranet.com>
---
 arch/x86/include/asm/alternative.h |    5 +++++
 arch/x86/include/asm/cmpxchg_64.h  |   21 ++++++++++++++-------
 arch/x86/include/asm/cpufeature.h  |    1 +
 arch/x86/include/asm/futex.h       |    2 ++
 arch/x86/include/asm/rwsem.h       |    1 +
 arch/x86/include/asm/spinlock.h    |    2 ++
 arch/x86/kernel/cpu/amd.c          |    4 ++++
 7 files changed, 29 insertions(+), 7 deletions(-)

Index: linux-2.6-lttng/arch/x86/include/asm/cpufeature.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/include/asm/cpufeature.h	2009-04-18 23:58:23.000000000 -0400
+++ linux-2.6-lttng/arch/x86/include/asm/cpufeature.h	2009-04-18 23:58:28.000000000 -0400
@@ -94,6 +94,7 @@
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
 #define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with monitor */
+#define X86_FEATURE_NEED_CMPXCHG_LFENCE	(3*32+26) /* Fix AMD cmpxchg lfence */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
Index: linux-2.6-lttng/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/cpu/amd.c	2009-04-18 23:58:23.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/cpu/amd.c	2009-04-18 23:58:28.000000000 -0400
@@ -416,6 +416,10 @@ static void __cpuinit init_amd(struct cp
 		clear_cpu_cap(c, X86_FEATURE_MCE);
 #endif
 
+	/* Enable workaround for missing AMD cmpxchg lfence */
+	if (c->x86 == 0xf && c->x86_model >= 32 && c->x86_model <= 63)
+		set_cpu_cap(c, X86_FEATURE_NEED_CMPXCHG_LFENCE);
+
 	/* Enable workaround for FXSAVE leak */
 	if (c->x86 >= 6)
 		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
Index: linux-2.6-lttng/arch/x86/include/asm/cmpxchg_64.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/include/asm/cmpxchg_64.h	2009-04-18 23:58:23.000000000 -0400
+++ linux-2.6-lttng/arch/x86/include/asm/cmpxchg_64.h	2009-04-18 23:58:28.000000000 -0400
@@ -66,25 +66,29 @@ static inline unsigned long __cmpxchg(vo
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		asm volatile(LOCK_PREFIX "cmpxchgb %b1,%2"
+		asm volatile(LOCK_PREFIX "cmpxchgb %b1,%2\n\t"
+			     CMPXCHG_LFENCE
 			     : "=a"(prev)
 			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
 			     : "memory");
 		return prev;
 	case 2:
-		asm volatile(LOCK_PREFIX "cmpxchgw %w1,%2"
+		asm volatile(LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
+			     CMPXCHG_LFENCE
 			     : "=a"(prev)
 			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
 			     : "memory");
 		return prev;
 	case 4:
-		asm volatile(LOCK_PREFIX "cmpxchgl %k1,%2"
+		asm volatile(LOCK_PREFIX "cmpxchgl %k1,%2\n\t"
+			     CMPXCHG_LFENCE
 			     : "=a"(prev)
 			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
 			     : "memory");
 		return prev;
 	case 8:
-		asm volatile(LOCK_PREFIX "cmpxchgq %1,%2"
+		asm volatile(LOCK_PREFIX "cmpxchgq %1,%2\n\t"
+			     CMPXCHG_LFENCE
 			     : "=a"(prev)
 			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
 			     : "memory");
@@ -105,19 +109,22 @@ static inline unsigned long __sync_cmpxc
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		asm volatile("lock; cmpxchgb %b1,%2"
+		asm volatile("lock; cmpxchgb %b1,%2\n\t"
+			     CMPXCHG_LFENCE
 			     : "=a"(prev)
 			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
 			     : "memory");
 		return prev;
 	case 2:
-		asm volatile("lock; cmpxchgw %w1,%2"
+		asm volatile("lock; cmpxchgw %w1,%2\n\t"
+			     CMPXCHG_LFENCE
 			     : "=a"(prev)
 			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
 			     : "memory");
 		return prev;
 	case 4:
-		asm volatile("lock; cmpxchgl %1,%2"
+		asm volatile("lock; cmpxchgl %1,%2\n\t"
+			     CMPXCHG_LFENCE
 			     : "=a"(prev)
 			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
 			     : "memory");
Index: linux-2.6-lttng/arch/x86/include/asm/alternative.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/include/asm/alternative.h	2009-04-18 23:58:23.000000000 -0400
+++ linux-2.6-lttng/arch/x86/include/asm/alternative.h	2009-04-18 23:58:28.000000000 -0400
@@ -5,6 +5,7 @@
 #include <linux/stddef.h>
 #include <linux/stringify.h>
 #include <asm/asm.h>
+#include <asm/nops.h>
 
 /*
  * Alternative inline assembly for SMP.
@@ -54,6 +55,10 @@ struct alt_instr {
 #endif
 };
 
+/* Needed both in UP and SMP build because of cmpxchg_sync */
+#define CMPXCHG_LFENCE 	ALTERNATIVE(ASM_NOP3, "lfence",	\
+				    X86_FEATURE_NEED_CMPXCHG_LFENCE)
+
 extern void alternative_instructions(void);
 extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
 
Index: linux-2.6-lttng/arch/x86/include/asm/spinlock.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/include/asm/spinlock.h	2009-04-18 23:58:23.000000000 -0400
+++ linux-2.6-lttng/arch/x86/include/asm/spinlock.h	2009-04-18 23:58:28.000000000 -0400
@@ -86,6 +86,7 @@ static __always_inline int __ticket_spin
 		     "leal 0x100(%" REG_PTR_MODE "0), %1\n\t"
 		     "jne 1f\n\t"
 		     LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
+		     CMPXCHG_LFENCE "\n\t"
 		     "1:"
 		     "sete %b1\n\t"
 		     "movzbl %b1,%0\n\t"
@@ -139,6 +140,7 @@ static __always_inline int __ticket_spin
 		     "leal 0x00010000(%" REG_PTR_MODE "0), %1\n\t"
 		     "jne 1f\n\t"
 		     LOCK_PREFIX "cmpxchgl %1,%2\n\t"
+		     CMPXCHG_LFENCE "\n\t"
 		     "1:"
 		     "sete %b1\n\t"
 		     "movzbl %b1,%0\n\t"
Index: linux-2.6-lttng/arch/x86/include/asm/rwsem.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/include/asm/rwsem.h	2009-04-18 23:58:23.000000000 -0400
+++ linux-2.6-lttng/arch/x86/include/asm/rwsem.h	2009-04-18 23:58:28.000000000 -0400
@@ -129,6 +129,7 @@ static inline int __down_read_trylock(st
 		     "  addl      %3,%2\n\t"
 		     "  jle	     2f\n\t"
 		     LOCK_PREFIX "  cmpxchgl  %2,%0\n\t"
+		     CMPXCHG_LFENCE "\n\t"
 		     "  jnz	     1b\n\t"
 		     "2:\n\t"
 		     "# ending __down_read_trylock\n\t"
Index: linux-2.6-lttng/arch/x86/include/asm/futex.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/include/asm/futex.h	2009-04-18 23:58:23.000000000 -0400
+++ linux-2.6-lttng/arch/x86/include/asm/futex.h	2009-04-18 23:58:28.000000000 -0400
@@ -26,6 +26,7 @@
 		     "\tmovl\t%0, %3\n"				\
 		     "\t" insn "\n"				\
 		     "2:\t" LOCK_PREFIX "cmpxchgl %3, %2\n"	\
+		     CMPXCHG_LFENCE "\n"			\
 		     "\tjnz\t1b\n"				\
 		     "3:\t.section .fixup,\"ax\"\n"		\
 		     "4:\tmov\t%5, %1\n"			\
@@ -123,6 +124,7 @@ static inline int futex_atomic_cmpxchg_i
 		return -EFAULT;
 
 	asm volatile("1:\t" LOCK_PREFIX "cmpxchgl %3, %1\n"
+		     CMPXCHG_LFENCE "\n"
 		     "2:\t.section .fixup, \"ax\"\n"
 		     "3:\tmov     %2, %0\n"
 		     "\tjmp     2b\n"

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
