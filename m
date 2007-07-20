Return-Path: <linux-kernel-owner+w=401wt.eu-S1760348AbXGTQ4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348AbXGTQ4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935322AbXGTQuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:50:00 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:65447 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934222AbXGTQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:49:56 -0400
Date: Fri, 20 Jul 2007 12:49:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] 80386 and 80486 cmpxchg64 and cmpxchg64_local fallback
Message-ID: <20070720164947.GA2793@Krystal>
References: <200707191154.642492000@suse.de> <200707201027.46532.ak@suse.de> <20070720141210.GA29979@Krystal> <200707201714.16811.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200707201714.16811.ak@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:17:39 up 3 days, 10:51,  3 users,  load average: 0.41, 0.29, 0.21
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fall back on interrupt disable in cmpxchg8b on 80386 and 80486

Actually, on 386, cmpxchg and cmpxchg_local fall back on
cmpxchg_386_u8/16/32: it disables interruptions around non atomic
updates to mimic the cmpxchg behavior.

The comment:
/* Poor man's cmpxchg for 386. Unsuitable for SMP */

in the implementation tells much about how this cmpxchg implementation
should not be used in a SMP context. However, the cmpxchg_local can
perfectly use this fallback, since it only needs to be atomic wrt the
local cpu.

This patch adds a cmpxchg_386_u64 and uses it as a fallback for cmpxchg64
and cmpxchg64_local on 80386 and 80486.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/i386/kernel/cpu/intel.c |   17 +++++++
 include/asm-i386/cmpxchg.h   |   99 ++++++++++++++++++++++++++++---------------
 2 files changed, 82 insertions(+), 34 deletions(-)

Index: linux-2.6-lttng/arch/i386/kernel/cpu/intel.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/cpu/intel.c	2007-07-20 12:41:24.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/cpu/intel.c	2007-07-20 12:43:56.000000000 -0400
@@ -329,5 +329,22 @@ unsigned long cmpxchg_386_u32(volatile v
 EXPORT_SYMBOL(cmpxchg_386_u32);
 #endif
 
+#ifndef CONFIG_X86_CMPXCHG64
+unsigned long long cmpxchg_486_u64(volatile void *ptr, u64 old, u64 new)
+{
+	u64 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg8b for 386 and 486. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u64 *)ptr;
+	if (prev == old)
+		*(u64 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_486_u64);
+#endif
+
 // arch_initcall(intel_cpu_init);
 
Index: linux-2.6-lttng/include/asm-i386/cmpxchg.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/cmpxchg.h	2007-07-20 12:41:24.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/cmpxchg.h	2007-07-20 12:42:12.000000000 -0400
@@ -116,6 +116,15 @@ static inline unsigned long __xchg(unsig
 					(unsigned long)(n),sizeof(*(ptr))))
 #endif
 
+#ifdef CONFIG_X86_CMPXCHG64
+#define cmpxchg64(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg64((ptr),(unsigned long long)(o),\
+					(unsigned long long)(n)))
+#define cmpxchg64_local(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg64_local((ptr),(unsigned long long)(o),\
+					(unsigned long long)(n)))
+#endif
+
 static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
 				      unsigned long new, int size)
 {
@@ -203,6 +212,34 @@ static inline unsigned long __cmpxchg_lo
 	return old;
 }
 
+static inline unsigned long long __cmpxchg64(volatile void *ptr,
+			unsigned long long old, unsigned long long new)
+{
+	unsigned long long prev;
+	__asm__ __volatile__(LOCK_PREFIX "cmpxchg8b %3"
+			     : "=A"(prev)
+			     : "b"((unsigned long)new),
+			       "c"((unsigned long)(new >> 32)),
+			       "m"(*__xg(ptr)),
+			       "0"(old)
+			     : "memory");
+	return prev;
+}
+
+static inline unsigned long long __cmpxchg64_local(volatile void *ptr,
+			unsigned long long old, unsigned long long new)
+{
+	unsigned long long prev;
+	__asm__ __volatile__("cmpxchg8b %3"
+			     : "=A"(prev)
+			     : "b"((unsigned long)new),
+			       "c"((unsigned long)(new >> 32)),
+			       "m"(*__xg(ptr)),
+			       "0"(old)
+			     : "memory");
+	return prev;
+}
+
 #ifndef CONFIG_X86_CMPXCHG
 /*
  * Building a kernel capable running on 80386. It may be necessary to
@@ -252,42 +289,36 @@ static inline unsigned long cmpxchg_386(
 })
 #endif
 
-#ifdef CONFIG_X86_CMPXCHG64
-
-static inline unsigned long long __cmpxchg64(volatile void *ptr, unsigned long long old,
-				      unsigned long long new)
-{
-	unsigned long long prev;
-	__asm__ __volatile__(LOCK_PREFIX "cmpxchg8b %3"
-			     : "=A"(prev)
-			     : "b"((unsigned long)new),
-			       "c"((unsigned long)(new >> 32)),
-			       "m"(*__xg(ptr)),
-			       "0"(old)
-			     : "memory");
-	return prev;
-}
+#ifndef CONFIG_X86_CMPXCHG64
+/*
+ * Building a kernel capable running on 80386 and 80486. It may be necessary
+ * to simulate the cmpxchg8b on the 80386 and 80486 CPU.
+ */
 
-static inline unsigned long long __cmpxchg64_local(volatile void *ptr,
-			unsigned long long old, unsigned long long new)
-{
-	unsigned long long prev;
-	__asm__ __volatile__("cmpxchg8b %3"
-			     : "=A"(prev)
-			     : "b"((unsigned long)new),
-			       "c"((unsigned long)(new >> 32)),
-			       "m"(*__xg(ptr)),
-			       "0"(old)
-			     : "memory");
-	return prev;
-}
+extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
 
-#define cmpxchg64(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg64((ptr),(unsigned long long)(o),\
-					(unsigned long long)(n)))
-#define cmpxchg64_local(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg64_local((ptr),(unsigned long long)(o),\
-					(unsigned long long)(n)))
+#define cmpxchg64(ptr,o,n)						\
+({									\
+	__typeof__(*(ptr)) __ret;					\
+	if (likely(boot_cpu_data.x86 > 4))				\
+		__ret = __cmpxchg64((ptr), (unsigned long long)(o),	\
+				(unsigned long long)(n));		\
+	else								\
+		__ret = cmpxchg_486_u64((ptr), (unsigned long long)(o),	\
+				(unsigned long long)(n));		\
+	__ret;								\
+})
+#define cmpxchg64_local(ptr,o,n)					\
+({									\
+	__typeof__(*(ptr)) __ret;					\
+	if (likely(boot_cpu_data.x86 > 4))				\
+		__ret = __cmpxchg64_local((ptr), (unsigned long long)(o), \
+				(unsigned long long)(n));		\
+	else								\
+		__ret = cmpxchg_486_u64((ptr), (unsigned long long)(o),	\
+				(unsigned long long)(n));		\
+	__ret;								\
+})
 #endif
 
 #endif
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
