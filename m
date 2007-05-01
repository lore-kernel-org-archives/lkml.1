Return-Path: <linux-kernel-owner+w=401wt.eu-S1031224AbXEAS1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031224AbXEAS1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031184AbXEAS0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:26:41 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:38484 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030998AbXEAS0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:26:30 -0400
Date: Tue, 1 May 2007 14:21:57 -0400
From: Jeff Dike <jdike@addtoit.com>
To: akpm@osdl.org, Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/6] Create asm-i386/cmpxchg.h
Message-ID: <20070501182157.GA8348@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rearrange the i386 cmpxchg code to allow atomic.h to get it without
needing to include system.h.  This kills warnings in the UML build
from atomic.h about implicit declarations of cmpxchg symbols.  The
i386 build presumably isn't seeing this because a separate inclusion
of system.h is covering it over.

The cmpxchg stuff is moved to asm-i386/cmpxchg.h, with an include left
in system.h for the benefit of generic code which expects cmpxchg
there.

Meanwhile, atomic.h includes cmpxchg.h.

This causes no noticable damage to the i386 build.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/asm-i386/atomic.h  |    1 
 include/asm-i386/cmpxchg.h |  293 +++++++++++++++++++++++++++++++++++++++++++++
 include/asm-i386/system.h  |  289 --------------------------------------------
 3 files changed, 295 insertions(+), 288 deletions(-)

Index: linux-2.6.21-mm/include/asm-i386/atomic.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-i386/atomic.h	2007-04-30 18:04:43.000000000 -0400
+++ linux-2.6.21-mm/include/asm-i386/atomic.h	2007-05-01 12:41:52.000000000 -0400
@@ -3,6 +3,7 @@
 
 #include <linux/compiler.h>
 #include <asm/processor.h>
+#include <asm/cmpxchg.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
Index: linux-2.6.21-mm/include/asm-i386/cmpxchg.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-mm/include/asm-i386/cmpxchg.h	2007-05-01 12:42:08.000000000 -0400
@@ -0,0 +1,293 @@
+#ifndef __ASM_CMPXCHG_H
+#define __ASM_CMPXCHG_H
+
+#include <linux/bitops.h> /* for LOCK_PREFIX */
+
+#define xchg(ptr,v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v),(ptr),sizeof(*(ptr))))
+
+struct __xchg_dummy { unsigned long a[100]; };
+#define __xg(x) ((struct __xchg_dummy *)(x))
+
+
+#ifdef CONFIG_X86_CMPXCHG64
+
+/*
+ * The semantics of XCHGCMP8B are a bit strange, this is why
+ * there is a loop and the loading of %%eax and %%edx has to
+ * be inside. This inlines well in most cases, the cached
+ * cost is around ~38 cycles. (in the future we might want
+ * to do an SIMD/3DNOW!/MMX/FPU 64-bit store here, but that
+ * might have an implicit FPU-save as a cost, so it's not
+ * clear which path to go.)
+ *
+ * cmpxchg8b must be used with the lock prefix here to allow
+ * the instruction to be executed atomically, see page 3-102
+ * of the instruction set reference 24319102.pdf. We need
+ * the reader side to see the coherent 64bit value.
+ */
+static inline void __set_64bit (unsigned long long * ptr,
+		unsigned int low, unsigned int high)
+{
+	__asm__ __volatile__ (
+		"\n1:\t"
+		"movl (%0), %%eax\n\t"
+		"movl 4(%0), %%edx\n\t"
+		"lock cmpxchg8b (%0)\n\t"
+		"jnz 1b"
+		: /* no outputs */
+		:	"D"(ptr),
+			"b"(low),
+			"c"(high)
+		:	"ax","dx","memory");
+}
+
+static inline void __set_64bit_constant (unsigned long long *ptr,
+						 unsigned long long value)
+{
+	__set_64bit(ptr,(unsigned int)(value), (unsigned int)((value)>>32ULL));
+}
+#define ll_low(x)	*(((unsigned int*)&(x))+0)
+#define ll_high(x)	*(((unsigned int*)&(x))+1)
+
+static inline void __set_64bit_var (unsigned long long *ptr,
+			 unsigned long long value)
+{
+	__set_64bit(ptr,ll_low(value), ll_high(value));
+}
+
+#define set_64bit(ptr,value) \
+(__builtin_constant_p(value) ? \
+ __set_64bit_constant(ptr, value) : \
+ __set_64bit_var(ptr, value) )
+
+#define _set_64bit(ptr,value) \
+(__builtin_constant_p(value) ? \
+ __set_64bit(ptr, (unsigned int)(value), (unsigned int)((value)>>32ULL) ) : \
+ __set_64bit(ptr, ll_low(value), ll_high(value)) )
+
+#endif
+
+/*
+ * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
+ * Note 2: xchg has side effect, so that attribute volatile is necessary,
+ *	  but generally the primitive is invalid, *ptr is output argument. --ANK
+ */
+static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
+{
+	switch (size) {
+		case 1:
+			__asm__ __volatile__("xchgb %b0,%1"
+				:"=q" (x)
+				:"m" (*__xg(ptr)), "0" (x)
+				:"memory");
+			break;
+		case 2:
+			__asm__ __volatile__("xchgw %w0,%1"
+				:"=r" (x)
+				:"m" (*__xg(ptr)), "0" (x)
+				:"memory");
+			break;
+		case 4:
+			__asm__ __volatile__("xchgl %0,%1"
+				:"=r" (x)
+				:"m" (*__xg(ptr)), "0" (x)
+				:"memory");
+			break;
+	}
+	return x;
+}
+
+/*
+ * Atomic compare and exchange.  Compare OLD with MEM, if identical,
+ * store NEW in MEM.  Return the initial value in MEM.  Success is
+ * indicated by comparing RETURN with OLD.
+ */
+
+#ifdef CONFIG_X86_CMPXCHG
+#define __HAVE_ARCH_CMPXCHG 1
+#define cmpxchg(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
+					(unsigned long)(n),sizeof(*(ptr))))
+#define sync_cmpxchg(ptr,o,n)\
+	((__typeof__(*(ptr)))__sync_cmpxchg((ptr),(unsigned long)(o),\
+					(unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg_local(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr),(unsigned long)(o),\
+					(unsigned long)(n),sizeof(*(ptr))))
+#endif
+
+static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
+				      unsigned long new, int size)
+{
+	unsigned long prev;
+	switch (size) {
+	case 1:
+		__asm__ __volatile__(LOCK_PREFIX "cmpxchgb %b1,%2"
+				     : "=a"(prev)
+				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 2:
+		__asm__ __volatile__(LOCK_PREFIX "cmpxchgw %w1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 4:
+		__asm__ __volatile__(LOCK_PREFIX "cmpxchgl %1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	}
+	return old;
+}
+
+/*
+ * Always use locked operations when touching memory shared with a
+ * hypervisor, since the system may be SMP even if the guest kernel
+ * isn't.
+ */
+static inline unsigned long __sync_cmpxchg(volatile void *ptr,
+					    unsigned long old,
+					    unsigned long new, int size)
+{
+	unsigned long prev;
+	switch (size) {
+	case 1:
+		__asm__ __volatile__("lock; cmpxchgb %b1,%2"
+				     : "=a"(prev)
+				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 2:
+		__asm__ __volatile__("lock; cmpxchgw %w1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 4:
+		__asm__ __volatile__("lock; cmpxchgl %1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	}
+	return old;
+}
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+			unsigned long old, unsigned long new, int size)
+{
+	unsigned long prev;
+	switch (size) {
+	case 1:
+		__asm__ __volatile__("cmpxchgb %b1,%2"
+				     : "=a"(prev)
+				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 2:
+		__asm__ __volatile__("cmpxchgw %w1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 4:
+		__asm__ __volatile__("cmpxchgl %1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	}
+	return old;
+}
+
+#ifndef CONFIG_X86_CMPXCHG
+/*
+ * Building a kernel capable running on 80386. It may be necessary to
+ * simulate the cmpxchg on the 80386 CPU. For that purpose we define
+ * a function for each of the sizes we support.
+ */
+
+extern unsigned long cmpxchg_386_u8(volatile void *, u8, u8);
+extern unsigned long cmpxchg_386_u16(volatile void *, u16, u16);
+extern unsigned long cmpxchg_386_u32(volatile void *, u32, u32);
+
+static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 1:
+		return cmpxchg_386_u8(ptr, old, new);
+	case 2:
+		return cmpxchg_386_u16(ptr, old, new);
+	case 4:
+		return cmpxchg_386_u32(ptr, old, new);
+	}
+	return old;
+}
+
+#define cmpxchg(ptr,o,n)						\
+({									\
+	__typeof__(*(ptr)) __ret;					\
+	if (likely(boot_cpu_data.x86 > 3))				\
+		__ret = __cmpxchg((ptr), (unsigned long)(o),		\
+					(unsigned long)(n), sizeof(*(ptr))); \
+	else								\
+		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
+					(unsigned long)(n), sizeof(*(ptr))); \
+	__ret;								\
+})
+#define cmpxchg_local(ptr,o,n)						\
+({									\
+	__typeof__(*(ptr)) __ret;					\
+	if (likely(boot_cpu_data.x86 > 3))				\
+		__ret = __cmpxchg_local((ptr), (unsigned long)(o),	\
+					(unsigned long)(n), sizeof(*(ptr))); \
+	else								\
+		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
+					(unsigned long)(n), sizeof(*(ptr))); \
+	__ret;								\
+})
+#endif
+
+#ifdef CONFIG_X86_CMPXCHG64
+
+static inline unsigned long long __cmpxchg64(volatile void *ptr, unsigned long long old,
+				      unsigned long long new)
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
+#define cmpxchg64(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg64((ptr),(unsigned long long)(o),\
+					(unsigned long long)(n)))
+#define cmpxchg64_local(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg64_local((ptr),(unsigned long long)(o),\
+					(unsigned long long)(n)))
+#endif
+
+#endif
Index: linux-2.6.21-mm/include/asm-i386/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-i386/system.h	2007-04-30 18:04:43.000000000 -0400
+++ linux-2.6.21-mm/include/asm-i386/system.h	2007-05-01 12:41:52.000000000 -0400
@@ -4,7 +4,7 @@
 #include <linux/kernel.h>
 #include <asm/segment.h>
 #include <asm/cpufeature.h>
-#include <linux/bitops.h> /* for LOCK_PREFIX */
+#include <asm/cmpxchg.h>
 
 #ifdef __KERNEL__
 
@@ -195,293 +195,6 @@ static inline unsigned long get_limit(un
 
 #define nop() __asm__ __volatile__ ("nop")
 
-#define xchg(ptr,v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v),(ptr),sizeof(*(ptr))))
-
-struct __xchg_dummy { unsigned long a[100]; };
-#define __xg(x) ((struct __xchg_dummy *)(x))
-
-
-#ifdef CONFIG_X86_CMPXCHG64
-
-/*
- * The semantics of XCHGCMP8B are a bit strange, this is why
- * there is a loop and the loading of %%eax and %%edx has to
- * be inside. This inlines well in most cases, the cached
- * cost is around ~38 cycles. (in the future we might want
- * to do an SIMD/3DNOW!/MMX/FPU 64-bit store here, but that
- * might have an implicit FPU-save as a cost, so it's not
- * clear which path to go.)
- *
- * cmpxchg8b must be used with the lock prefix here to allow
- * the instruction to be executed atomically, see page 3-102
- * of the instruction set reference 24319102.pdf. We need
- * the reader side to see the coherent 64bit value.
- */
-static inline void __set_64bit (unsigned long long * ptr,
-		unsigned int low, unsigned int high)
-{
-	__asm__ __volatile__ (
-		"\n1:\t"
-		"movl (%0), %%eax\n\t"
-		"movl 4(%0), %%edx\n\t"
-		"lock cmpxchg8b (%0)\n\t"
-		"jnz 1b"
-		: /* no outputs */
-		:	"D"(ptr),
-			"b"(low),
-			"c"(high)
-		:	"ax","dx","memory");
-}
-
-static inline void __set_64bit_constant (unsigned long long *ptr,
-						 unsigned long long value)
-{
-	__set_64bit(ptr,(unsigned int)(value), (unsigned int)((value)>>32ULL));
-}
-#define ll_low(x)	*(((unsigned int*)&(x))+0)
-#define ll_high(x)	*(((unsigned int*)&(x))+1)
-
-static inline void __set_64bit_var (unsigned long long *ptr,
-			 unsigned long long value)
-{
-	__set_64bit(ptr,ll_low(value), ll_high(value));
-}
-
-#define set_64bit(ptr,value) \
-(__builtin_constant_p(value) ? \
- __set_64bit_constant(ptr, value) : \
- __set_64bit_var(ptr, value) )
-
-#define _set_64bit(ptr,value) \
-(__builtin_constant_p(value) ? \
- __set_64bit(ptr, (unsigned int)(value), (unsigned int)((value)>>32ULL) ) : \
- __set_64bit(ptr, ll_low(value), ll_high(value)) )
-
-#endif
-
-/*
- * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
- * Note 2: xchg has side effect, so that attribute volatile is necessary,
- *	  but generally the primitive is invalid, *ptr is output argument. --ANK
- */
-static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
-{
-	switch (size) {
-		case 1:
-			__asm__ __volatile__("xchgb %b0,%1"
-				:"=q" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-		case 2:
-			__asm__ __volatile__("xchgw %w0,%1"
-				:"=r" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-		case 4:
-			__asm__ __volatile__("xchgl %0,%1"
-				:"=r" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-	}
-	return x;
-}
-
-/*
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
- */
-
-#ifdef CONFIG_X86_CMPXCHG
-#define __HAVE_ARCH_CMPXCHG 1
-#define cmpxchg(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
-#define sync_cmpxchg(ptr,o,n)\
-	((__typeof__(*(ptr)))__sync_cmpxchg((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
-#define cmpxchg_local(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
-#endif
-
-static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 2:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 4:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgl %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	}
-	return old;
-}
-
-/*
- * Always use locked operations when touching memory shared with a
- * hypervisor, since the system may be SMP even if the guest kernel
- * isn't.
- */
-static inline unsigned long __sync_cmpxchg(volatile void *ptr,
-					    unsigned long old,
-					    unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		__asm__ __volatile__("lock; cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 2:
-		__asm__ __volatile__("lock; cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 4:
-		__asm__ __volatile__("lock; cmpxchgl %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	}
-	return old;
-}
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-			unsigned long old, unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		__asm__ __volatile__("cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 2:
-		__asm__ __volatile__("cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 4:
-		__asm__ __volatile__("cmpxchgl %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	}
-	return old;
-}
-
-#ifndef CONFIG_X86_CMPXCHG
-/*
- * Building a kernel capable running on 80386. It may be necessary to
- * simulate the cmpxchg on the 80386 CPU. For that purpose we define
- * a function for each of the sizes we support.
- */
-
-extern unsigned long cmpxchg_386_u8(volatile void *, u8, u8);
-extern unsigned long cmpxchg_386_u16(volatile void *, u16, u16);
-extern unsigned long cmpxchg_386_u32(volatile void *, u32, u32);
-
-static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	switch (size) {
-	case 1:
-		return cmpxchg_386_u8(ptr, old, new);
-	case 2:
-		return cmpxchg_386_u16(ptr, old, new);
-	case 4:
-		return cmpxchg_386_u32(ptr, old, new);
-	}
-	return old;
-}
-
-#define cmpxchg(ptr,o,n)						\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	if (likely(boot_cpu_data.x86 > 3))				\
-		__ret = __cmpxchg((ptr), (unsigned long)(o),		\
-					(unsigned long)(n), sizeof(*(ptr))); \
-	else								\
-		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
-					(unsigned long)(n), sizeof(*(ptr))); \
-	__ret;								\
-})
-#define cmpxchg_local(ptr,o,n)						\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	if (likely(boot_cpu_data.x86 > 3))				\
-		__ret = __cmpxchg_local((ptr), (unsigned long)(o),	\
-					(unsigned long)(n), sizeof(*(ptr))); \
-	else								\
-		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
-					(unsigned long)(n), sizeof(*(ptr))); \
-	__ret;								\
-})
-#endif
-
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
-
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
-
-#define cmpxchg64(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg64((ptr),(unsigned long long)(o),\
-					(unsigned long long)(n)))
-#define cmpxchg64_local(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg64_local((ptr),(unsigned long long)(o),\
-					(unsigned long long)(n)))
-#endif
-    
 /*
  * Force strict CPU ordering.
  * And yes, this is required on UP too when we're talking
