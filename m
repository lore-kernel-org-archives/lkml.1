Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbZLCUb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbZLCUb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbZLCUb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:31:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49889 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbZLCUbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:31:53 -0500
Date: Thu, 3 Dec 2009 21:31:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm for v2.6.33
Message-ID: <20091203203143.GA25305@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-asm-for-linus

The most user visible change here is the (default disabled) 
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS security feature, which uses 
__builtin_object_size() to validate copy_from_user accesses.

out-of-topic modifications in x86-asm-for-linus:
------------------------------------------------
include/linux/compiler-gcc4.h      # 7cff7ce: include/linux/compiler-gcc4.h: Fi
                                   # 63312b6: x86: Add a Kconfig option to turn
                                   # 4a31276: x86: Turn the copy_from_user chec
                                   # 9f0cf4a: x86: Use __builtin_object_size() 
include/linux/compiler.h           # 63312b6: x86: Add a Kconfig option to turn
                                   # 4a31276: x86: Turn the copy_from_user chec
                                   # 9f0cf4a: x86: Use __builtin_object_size() 

 Thanks,

	Ingo

------------------>
Andrew Morton (1):
      include/linux/compiler-gcc4.h: Fix build bug - gcc-4.0.2 doesn't understand __builtin_object_size

Arjan van de Ven (5):
      x86: Use __builtin_object_size() to validate the buffer size for copy_from_user()
      x86: Use __builtin_memset and __builtin_memcpy for memset/memcpy
      x86: Turn the copy_from_user check into an (optional) compile time warning
      x86: Add a Kconfig option to turn the copy_from_user warnings into errors
      x86: Don't use the strict copy checks when branch profiling is in use

Brian Gerst (4):
      x86, 64-bit: Move K8 B step iret fixup to fault entry asm
      x86, 64-bit: Fix bstep_iret jump
      x86: Optimize loadsegment()
      x86, 64-bit: Set data segments to null after switching to 64-bit mode

Frederic Weisbecker (1):
      x86: Add missing might_fault() checks to copy_{to,from}_user()

Ingo Molnar (1):
      x86: Clean up the loadsegment() macro

Jan Beulich (3):
      x86-64: __copy_from_user_inatomic() adjustments
      x86/alternatives: Check replacementlen <= instrlen at build time
      x86/alternatives: No need for alternatives-asm.h to re-invent stuff already in asm.h

Masami Hiramatsu (1):
      x86: Remove unused thread_return label from switch_to()

Peter Zijlstra (1):
      x86: Generate cmpxchg build failures


 arch/x86/Kconfig.debug                 |   14 ++
 arch/x86/include/asm/alternative-asm.h |   10 +-
 arch/x86/include/asm/alternative.h     |    1 +
 arch/x86/include/asm/cmpxchg_32.h      |  218 ++++++++++++------------------
 arch/x86/include/asm/cmpxchg_64.h      |  234 ++++++++++++-------------------
 arch/x86/include/asm/string_32.h       |    9 ++
 arch/x86/include/asm/system.h          |   31 ++--
 arch/x86/include/asm/uaccess.h         |    1 -
 arch/x86/include/asm/uaccess_32.h      |   27 ++++-
 arch/x86/include/asm/uaccess_64.h      |   36 +++++-
 arch/x86/kernel/entry_64.S             |   11 +-
 arch/x86/kernel/head_64.S              |    4 +-
 arch/x86/kernel/x8664_ksyms_64.c       |    5 +-
 arch/x86/lib/copy_user_64.S            |   14 +--
 arch/x86/lib/usercopy_32.c             |   10 +-
 arch/x86/mm/extable.c                  |   31 ----
 include/linux/compiler-gcc4.h          |    8 +
 include/linux/compiler.h               |   11 ++
 18 files changed, 321 insertions(+), 354 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index d105f29..fb772b6 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -287,4 +287,18 @@ config OPTIMIZE_INLINING
 
 	  If unsure, say N.
 
+config DEBUG_STRICT_USER_COPY_CHECKS
+	bool "Strict copy size checks"
+	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
+	---help---
+	  Enabling this option turns a certain set of sanity checks for user
+	  copy operations into compile time failures.
+
+	  The copy_from_user() etc checks are there to help test if there
+	  are sufficient security checks on the length argument of
+	  the copy operation, by having gcc prove that the argument is
+	  within bounds.
+
+	  If unsure, or if you run an older (pre 4.4) gcc, say N.
+
 endmenu
diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index e2077d3..b97f786 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -1,17 +1,13 @@
 #ifdef __ASSEMBLY__
 
-#ifdef CONFIG_X86_32
-# define X86_ALIGN .long
-#else
-# define X86_ALIGN .quad
-#endif
+#include <asm/asm.h>
 
 #ifdef CONFIG_SMP
 	.macro LOCK_PREFIX
 1:	lock
 	.section .smp_locks,"a"
-	.align 4
-	X86_ALIGN 1b
+	_ASM_ALIGN
+	_ASM_PTR 1b
 	.previous
 	.endm
 #else
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index c240efc..69b74a7 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -84,6 +84,7 @@ static inline void alternatives_smp_switch(int smp) {}
       "	 .byte " __stringify(feature) "\n"	/* feature bit     */	\
       "	 .byte 662b-661b\n"			/* sourcelen       */	\
       "	 .byte 664f-663f\n"			/* replacementlen  */	\
+      "	 .byte 0xff + (664f-663f) - (662b-661b)\n" /* rlen <= slen */	\
       ".previous\n"							\
       ".section .altinstr_replacement, \"ax\"\n"			\
       "663:\n\t" newinstr "\n664:\n"		/* replacement     */	\
diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 82ceb78..5371174 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -8,14 +8,50 @@
  *       you need to test for the feature in boot_cpu_data.
  */
 
-#define xchg(ptr, v)							\
-	((__typeof__(*(ptr)))__xchg((unsigned long)(v), (ptr), sizeof(*(ptr))))
+extern void __xchg_wrong_size(void);
+
+/*
+ * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
+ * Note 2: xchg has side effect, so that attribute volatile is necessary,
+ *	  but generally the primitive is invalid, *ptr is output argument. --ANK
+ */
 
 struct __xchg_dummy {
 	unsigned long a[100];
 };
 #define __xg(x) ((struct __xchg_dummy *)(x))
 
+#define __xchg(x, ptr, size)						\
+({									\
+	__typeof(*(ptr)) __x = (x);					\
+	switch (size) {							\
+	case 1:								\
+		asm volatile("xchgb %b0,%1"				\
+			     : "=q" (__x)				\
+			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "memory");				\
+		break;							\
+	case 2:								\
+		asm volatile("xchgw %w0,%1"				\
+			     : "=r" (__x)				\
+			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "memory");				\
+		break;							\
+	case 4:								\
+		asm volatile("xchgl %0,%1"				\
+			     : "=r" (__x)				\
+			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "memory");				\
+		break;							\
+	default:							\
+		__xchg_wrong_size();					\
+	}								\
+	__x;								\
+})
+
+#define xchg(ptr, v)							\
+	__xchg((v), (ptr), sizeof(*ptr))
+
 /*
  * The semantics of XCHGCMP8B are a bit strange, this is why
  * there is a loop and the loading of %%eax and %%edx has to
@@ -71,57 +107,63 @@ static inline void __set_64bit_var(unsigned long long *ptr,
 		       (unsigned int)((value) >> 32))			\
 	 : __set_64bit(ptr, ll_low((value)), ll_high((value))))
 
-/*
- * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
- * Note 2: xchg has side effect, so that attribute volatile is necessary,
- *	  but generally the primitive is invalid, *ptr is output argument. --ANK
- */
-static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
-				   int size)
-{
-	switch (size) {
-	case 1:
-		asm volatile("xchgb %b0,%1"
-			     : "=q" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
-			     : "memory");
-		break;
-	case 2:
-		asm volatile("xchgw %w0,%1"
-			     : "=r" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
-			     : "memory");
-		break;
-	case 4:
-		asm volatile("xchgl %0,%1"
-			     : "=r" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
-			     : "memory");
-		break;
-	}
-	return x;
-}
+extern void __cmpxchg_wrong_size(void);
 
 /*
  * Atomic compare and exchange.  Compare OLD with MEM, if identical,
  * store NEW in MEM.  Return the initial value in MEM.  Success is
  * indicated by comparing RETURN with OLD.
  */
+#define __raw_cmpxchg(ptr, old, new, size, lock)			\
+({									\
+	__typeof__(*(ptr)) __ret;					\
+	__typeof__(*(ptr)) __old = (old);				\
+	__typeof__(*(ptr)) __new = (new);				\
+	switch (size) {							\
+	case 1:								\
+		asm volatile(lock "cmpxchgb %b1,%2"			\
+			     : "=a"(__ret)				\
+			     : "q"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+		break;							\
+	case 2:								\
+		asm volatile(lock "cmpxchgw %w1,%2"			\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+		break;							\
+	case 4:								\
+		asm volatile(lock "cmpxchgl %1,%2"			\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+		break;							\
+	default:							\
+		__cmpxchg_wrong_size();					\
+	}								\
+	__ret;								\
+})
+
+#define __cmpxchg(ptr, old, new, size)					\
+	__raw_cmpxchg((ptr), (old), (new), (size), LOCK_PREFIX)
+
+#define __sync_cmpxchg(ptr, old, new, size)				\
+	__raw_cmpxchg((ptr), (old), (new), (size), "lock; ")
+
+#define __cmpxchg_local(ptr, old, new, size)				\
+	__raw_cmpxchg((ptr), (old), (new), (size), "")
 
 #ifdef CONFIG_X86_CMPXCHG
 #define __HAVE_ARCH_CMPXCHG 1
-#define cmpxchg(ptr, o, n)						\
-	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	\
-				       (unsigned long)(n),		\
-				       sizeof(*(ptr))))
-#define sync_cmpxchg(ptr, o, n)						\
-	((__typeof__(*(ptr)))__sync_cmpxchg((ptr), (unsigned long)(o),	\
-					    (unsigned long)(n),		\
-					    sizeof(*(ptr))))
-#define cmpxchg_local(ptr, o, n)					\
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
-					     (unsigned long)(n),	\
-					     sizeof(*(ptr))))
+
+#define cmpxchg(ptr, old, new)						\
+	__cmpxchg((ptr), (old), (new), sizeof(*ptr))
+
+#define sync_cmpxchg(ptr, old, new)					\
+	__sync_cmpxchg((ptr), (old), (new), sizeof(*ptr))
+
+#define cmpxchg_local(ptr, old, new)					\
+	__cmpxchg_local((ptr), (old), (new), sizeof(*ptr))
 #endif
 
 #ifdef CONFIG_X86_CMPXCHG64
@@ -133,94 +175,6 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
 					       (unsigned long long)(n)))
 #endif
 
-static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		asm volatile(LOCK_PREFIX "cmpxchgb %b1,%2"
-			     : "=a"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	case 2:
-		asm volatile(LOCK_PREFIX "cmpxchgw %w1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	case 4:
-		asm volatile(LOCK_PREFIX "cmpxchgl %1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
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
-					   unsigned long old,
-					   unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		asm volatile("lock; cmpxchgb %b1,%2"
-			     : "=a"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	case 2:
-		asm volatile("lock; cmpxchgw %w1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	case 4:
-		asm volatile("lock; cmpxchgl %1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	}
-	return old;
-}
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-					    unsigned long old,
-					    unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		asm volatile("cmpxchgb %b1,%2"
-			     : "=a"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	case 2:
-		asm volatile("cmpxchgw %w1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	case 4:
-		asm volatile("cmpxchgl %1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	}
-	return old;
-}
-
 static inline unsigned long long __cmpxchg64(volatile void *ptr,
 					     unsigned long long old,
 					     unsigned long long new)
diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxchg_64.h
index 52de72e..485ae41 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -3,9 +3,6 @@
 
 #include <asm/alternative.h> /* Provides LOCK_PREFIX */
 
-#define xchg(ptr, v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v), \
-						 (ptr), sizeof(*(ptr))))
-
 #define __xg(x) ((volatile long *)(x))
 
 static inline void set_64bit(volatile unsigned long *ptr, unsigned long val)
@@ -15,167 +12,118 @@ static inline void set_64bit(volatile unsigned long *ptr, unsigned long val)
 
 #define _set_64bit set_64bit
 
+extern void __xchg_wrong_size(void);
+extern void __cmpxchg_wrong_size(void);
+
 /*
  * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
  * Note 2: xchg has side effect, so that attribute volatile is necessary,
  *	  but generally the primitive is invalid, *ptr is output argument. --ANK
  */
-static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
-				   int size)
-{
-	switch (size) {
-	case 1:
-		asm volatile("xchgb %b0,%1"
-			     : "=q" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
-			     : "memory");
-		break;
-	case 2:
-		asm volatile("xchgw %w0,%1"
-			     : "=r" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
-			     : "memory");
-		break;
-	case 4:
-		asm volatile("xchgl %k0,%1"
-			     : "=r" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
-			     : "memory");
-		break;
-	case 8:
-		asm volatile("xchgq %0,%1"
-			     : "=r" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
-			     : "memory");
-		break;
-	}
-	return x;
-}
+#define __xchg(x, ptr, size)						\
+({									\
+	__typeof(*(ptr)) __x = (x);					\
+	switch (size) {							\
+	case 1:								\
+		asm volatile("xchgb %b0,%1"				\
+			     : "=q" (__x)				\
+			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "memory");				\
+		break;							\
+	case 2:								\
+		asm volatile("xchgw %w0,%1"				\
+			     : "=r" (__x)				\
+			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "memory");				\
+		break;							\
+	case 4:								\
+		asm volatile("xchgl %k0,%1"				\
+			     : "=r" (__x)				\
+			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "memory");				\
+		break;							\
+	case 8:								\
+		asm volatile("xchgq %0,%1"				\
+			     : "=r" (__x)				\
+			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "memory");				\
+		break;							\
+	default:							\
+		__xchg_wrong_size();					\
+	}								\
+	__x;								\
+})
+
+#define xchg(ptr, v)							\
+	__xchg((v), (ptr), sizeof(*ptr))
+
+#define __HAVE_ARCH_CMPXCHG 1
 
 /*
  * Atomic compare and exchange.  Compare OLD with MEM, if identical,
  * store NEW in MEM.  Return the initial value in MEM.  Success is
  * indicated by comparing RETURN with OLD.
  */
+#define __raw_cmpxchg(ptr, old, new, size, lock)			\
+({									\
+	__typeof__(*(ptr)) __ret;					\
+	__typeof__(*(ptr)) __old = (old);				\
+	__typeof__(*(ptr)) __new = (new);				\
+	switch (size) {							\
+	case 1:								\
+		asm volatile(lock "cmpxchgb %b1,%2"			\
+			     : "=a"(__ret)				\
+			     : "q"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+		break;							\
+	case 2:								\
+		asm volatile(lock "cmpxchgw %w1,%2"			\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+		break;							\
+	case 4:								\
+		asm volatile(lock "cmpxchgl %k1,%2"			\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+		break;							\
+	case 8:								\
+		asm volatile(lock "cmpxchgq %1,%2"			\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+		break;							\
+	default:							\
+		__cmpxchg_wrong_size();					\
+	}								\
+	__ret;								\
+})
 
-#define __HAVE_ARCH_CMPXCHG 1
+#define __cmpxchg(ptr, old, new, size)					\
+	__raw_cmpxchg((ptr), (old), (new), (size), LOCK_PREFIX)
 
-static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		asm volatile(LOCK_PREFIX "cmpxchgb %b1,%2"
-			     : "=a"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	case 2:
-		asm volatile(LOCK_PREFIX "cmpxchgw %w1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	case 4:
-		asm volatile(LOCK_PREFIX "cmpxchgl %k1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	case 8:
-		asm volatile(LOCK_PREFIX "cmpxchgq %1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	}
-	return old;
-}
+#define __sync_cmpxchg(ptr, old, new, size)				\
+	__raw_cmpxchg((ptr), (old), (new), (size), "lock; ")
 
-/*
- * Always use locked operations when touching memory shared with a
- * hypervisor, since the system may be SMP even if the guest kernel
- * isn't.
- */
-static inline unsigned long __sync_cmpxchg(volatile void *ptr,
-					   unsigned long old,
-					   unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		asm volatile("lock; cmpxchgb %b1,%2"
-			     : "=a"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	case 2:
-		asm volatile("lock; cmpxchgw %w1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	case 4:
-		asm volatile("lock; cmpxchgl %1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	}
-	return old;
-}
+#define __cmpxchg_local(ptr, old, new, size)				\
+	__raw_cmpxchg((ptr), (old), (new), (size), "")
 
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-					    unsigned long old,
-					    unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		asm volatile("cmpxchgb %b1,%2"
-			     : "=a"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	case 2:
-		asm volatile("cmpxchgw %w1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	case 4:
-		asm volatile("cmpxchgl %k1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	case 8:
-		asm volatile("cmpxchgq %1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
-		return prev;
-	}
-	return old;
-}
+#define cmpxchg(ptr, old, new)						\
+	__cmpxchg((ptr), (old), (new), sizeof(*ptr))
+
+#define sync_cmpxchg(ptr, old, new)					\
+	__sync_cmpxchg((ptr), (old), (new), sizeof(*ptr))
+
+#define cmpxchg_local(ptr, old, new)					\
+	__cmpxchg_local((ptr), (old), (new), sizeof(*ptr))
 
-#define cmpxchg(ptr, o, n)						\
-	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	\
-				       (unsigned long)(n), sizeof(*(ptr))))
 #define cmpxchg64(ptr, o, n)						\
 ({									\
 	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
 	cmpxchg((ptr), (o), (n));					\
 })
-#define cmpxchg_local(ptr, o, n)					\
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
-					     (unsigned long)(n),	\
-					     sizeof(*(ptr))))
-#define sync_cmpxchg(ptr, o, n)						\
-	((__typeof__(*(ptr)))__sync_cmpxchg((ptr), (unsigned long)(o),	\
-					    (unsigned long)(n),		\
-					    sizeof(*(ptr))))
+
 #define cmpxchg64_local(ptr, o, n)					\
 ({									\
 	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index ae907e6..3d3e835 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -177,10 +177,15 @@ static inline void *__memcpy3d(void *to, const void *from, size_t len)
  */
 
 #ifndef CONFIG_KMEMCHECK
+
+#if (__GNUC__ >= 4)
+#define memcpy(t, f, n) __builtin_memcpy(t, f, n)
+#else
 #define memcpy(t, f, n)				\
 	(__builtin_constant_p((n))		\
 	 ? __constant_memcpy((t), (f), (n))	\
 	 : __memcpy((t), (f), (n)))
+#endif
 #else
 /*
  * kmemcheck becomes very happy if we use the REP instructions unconditionally,
@@ -316,11 +321,15 @@ void *__constant_c_and_count_memset(void *s, unsigned long pattern,
 	 : __memset_generic((s), (c), (count)))
 
 #define __HAVE_ARCH_MEMSET
+#if (__GNUC__ >= 4)
+#define memset(s, c, count) __builtin_memset(s, c, count)
+#else
 #define memset(s, c, count)						\
 	(__builtin_constant_p(c)					\
 	 ? __constant_c_x_memset((s), (0x01010101UL * (unsigned char)(c)), \
 				 (count))				\
 	 : __memset((s), (c), (count)))
+#endif
 
 /*
  * find the first occurrence of byte 'c', or 1 past the area if none
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index f08f973..022a843 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -128,8 +128,6 @@ do {									\
 	     "movq %%rsp,%P[threadrsp](%[prev])\n\t" /* save RSP */	  \
 	     "movq %P[threadrsp](%[next]),%%rsp\n\t" /* restore RSP */	  \
 	     "call __switch_to\n\t"					  \
-	     ".globl thread_return\n"					  \
-	     "thread_return:\n\t"					  \
 	     "movq "__percpu_arg([current_task])",%%rsi\n\t"		  \
 	     __switch_canary						  \
 	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
@@ -157,19 +155,22 @@ extern void native_load_gs_index(unsigned);
  * Load a segment. Fall back on loading the zero
  * segment if something goes wrong..
  */
-#define loadsegment(seg, value)			\
-	asm volatile("\n"			\
-		     "1:\t"			\
-		     "movl %k0,%%" #seg "\n"	\
-		     "2:\n"			\
-		     ".section .fixup,\"ax\"\n"	\
-		     "3:\t"			\
-		     "movl %k1, %%" #seg "\n\t"	\
-		     "jmp 2b\n"			\
-		     ".previous\n"		\
-		     _ASM_EXTABLE(1b,3b)	\
-		     : :"r" (value), "r" (0) : "memory")
-
+#define loadsegment(seg, value)						\
+do {									\
+	unsigned short __val = (value);					\
+									\
+	asm volatile("						\n"	\
+		     "1:	movl %k0,%%" #seg "		\n"	\
+									\
+		     ".section .fixup,\"ax\"			\n"	\
+		     "2:	xorl %k0,%k0			\n"	\
+		     "		jmp 1b				\n"	\
+		     ".previous					\n"	\
+									\
+		     _ASM_EXTABLE(1b, 2b)				\
+									\
+		     : "+r" (__val) : : "memory");			\
+} while (0)
 
 /*
  * Save a segment register away
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index d2c6c93..abd3e0e 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -570,7 +570,6 @@ extern struct movsl_mask {
 #ifdef CONFIG_X86_32
 # include "uaccess_32.h"
 #else
-# define ARCH_HAS_SEARCH_EXTABLE
 # include "uaccess_64.h"
 #endif
 
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 632fb44..0c9825e 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -187,9 +187,34 @@ __copy_from_user_inatomic_nocache(void *to, const void __user *from,
 
 unsigned long __must_check copy_to_user(void __user *to,
 					const void *from, unsigned long n);
-unsigned long __must_check copy_from_user(void *to,
+unsigned long __must_check _copy_from_user(void *to,
 					  const void __user *from,
 					  unsigned long n);
+
+
+extern void copy_from_user_overflow(void)
+#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
+	__compiletime_error("copy_from_user() buffer size is not provably correct")
+#else
+	__compiletime_warning("copy_from_user() buffer size is not provably correct")
+#endif
+;
+
+static inline unsigned long __must_check copy_from_user(void *to,
+					  const void __user *from,
+					  unsigned long n)
+{
+	int sz = __compiletime_object_size(to);
+	int ret = -EFAULT;
+
+	if (likely(sz == -1 || sz >= n))
+		ret = _copy_from_user(to, from, n);
+	else
+		copy_from_user_overflow();
+
+	return ret;
+}
+
 long __must_check strncpy_from_user(char *dst, const char __user *src,
 				    long count);
 long __must_check __strncpy_from_user(char *dst,
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index db24b21..46324c6 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -19,12 +19,37 @@ __must_check unsigned long
 copy_user_generic(void *to, const void *from, unsigned len);
 
 __must_check unsigned long
-copy_to_user(void __user *to, const void *from, unsigned len);
+_copy_to_user(void __user *to, const void *from, unsigned len);
 __must_check unsigned long
-copy_from_user(void *to, const void __user *from, unsigned len);
+_copy_from_user(void *to, const void __user *from, unsigned len);
 __must_check unsigned long
 copy_in_user(void __user *to, const void __user *from, unsigned len);
 
+static inline unsigned long __must_check copy_from_user(void *to,
+					  const void __user *from,
+					  unsigned long n)
+{
+	int sz = __compiletime_object_size(to);
+	int ret = -EFAULT;
+
+	might_fault();
+	if (likely(sz == -1 || sz >= n))
+		ret = _copy_from_user(to, from, n);
+#ifdef CONFIG_DEBUG_VM
+	else
+		WARN(1, "Buffer overflow detected!\n");
+#endif
+	return ret;
+}
+
+static __always_inline __must_check
+int copy_to_user(void __user *dst, const void *src, unsigned size)
+{
+	might_fault();
+
+	return _copy_to_user(dst, src, size);
+}
+
 static __always_inline __must_check
 int __copy_from_user(void *dst, const void __user *src, unsigned size)
 {
@@ -176,8 +201,11 @@ __must_check long strlen_user(const char __user *str);
 __must_check unsigned long clear_user(void __user *mem, unsigned long len);
 __must_check unsigned long __clear_user(void __user *mem, unsigned long len);
 
-__must_check long __copy_from_user_inatomic(void *dst, const void __user *src,
-					    unsigned size);
+static __must_check __always_inline int
+__copy_from_user_inatomic(void *dst, const void __user *src, unsigned size)
+{
+	return copy_user_generic(dst, (__force const void *)src, size);
+}
 
 static __must_check __always_inline int
 __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b5c061f..1579a6c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1491,12 +1491,17 @@ error_kernelspace:
 	leaq irq_return(%rip),%rcx
 	cmpq %rcx,RIP+8(%rsp)
 	je error_swapgs
-	movl %ecx,%ecx	/* zero extend */
-	cmpq %rcx,RIP+8(%rsp)
-	je error_swapgs
+	movl %ecx,%eax	/* zero extend */
+	cmpq %rax,RIP+8(%rsp)
+	je bstep_iret
 	cmpq $gs_change,RIP+8(%rsp)
 	je error_swapgs
 	jmp error_sti
+
+bstep_iret:
+	/* Fix truncated RIP */
+	movq %rcx,RIP+8(%rsp)
+	jmp error_swapgs
 END(error_entry)
 
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 2640660..17ba9ec 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -212,8 +212,8 @@ ENTRY(secondary_startup_64)
 	 */
 	lgdt	early_gdt_descr(%rip)
 
-	/* set up data segments. actually 0 would do too */
-	movl $__KERNEL_DS,%eax
+	/* set up data segments */
+	xorl %eax,%eax
 	movl %eax,%ds
 	movl %eax,%ss
 	movl %eax,%es
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 3909e3b..a102976 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -30,9 +30,8 @@ EXPORT_SYMBOL(__put_user_8);
 
 EXPORT_SYMBOL(copy_user_generic);
 EXPORT_SYMBOL(__copy_user_nocache);
-EXPORT_SYMBOL(copy_from_user);
-EXPORT_SYMBOL(copy_to_user);
-EXPORT_SYMBOL(__copy_from_user_inatomic);
+EXPORT_SYMBOL(_copy_from_user);
+EXPORT_SYMBOL(_copy_to_user);
 
 EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(clear_page);
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 6ba0f7b..cf889d4 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -65,7 +65,7 @@
 	.endm
 
 /* Standard copy_to_user with segment limit checking */
-ENTRY(copy_to_user)
+ENTRY(_copy_to_user)
 	CFI_STARTPROC
 	GET_THREAD_INFO(%rax)
 	movq %rdi,%rcx
@@ -75,10 +75,10 @@ ENTRY(copy_to_user)
 	jae bad_to_user
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
-ENDPROC(copy_to_user)
+ENDPROC(_copy_to_user)
 
 /* Standard copy_from_user with segment limit checking */
-ENTRY(copy_from_user)
+ENTRY(_copy_from_user)
 	CFI_STARTPROC
 	GET_THREAD_INFO(%rax)
 	movq %rsi,%rcx
@@ -88,7 +88,7 @@ ENTRY(copy_from_user)
 	jae bad_from_user
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
-ENDPROC(copy_from_user)
+ENDPROC(_copy_from_user)
 
 ENTRY(copy_user_generic)
 	CFI_STARTPROC
@@ -96,12 +96,6 @@ ENTRY(copy_user_generic)
 	CFI_ENDPROC
 ENDPROC(copy_user_generic)
 
-ENTRY(__copy_from_user_inatomic)
-	CFI_STARTPROC
-	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
-	CFI_ENDPROC
-ENDPROC(__copy_from_user_inatomic)
-
 	.section .fixup,"ax"
 	/* must zero dest */
 ENTRY(bad_from_user)
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 1f118d4..e218d5d 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -874,7 +874,7 @@ EXPORT_SYMBOL(copy_to_user);
  * data to the requested size using zero bytes.
  */
 unsigned long
-copy_from_user(void *to, const void __user *from, unsigned long n)
+_copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	if (access_ok(VERIFY_READ, from, n))
 		n = __copy_from_user(to, from, n);
@@ -882,4 +882,10 @@ copy_from_user(void *to, const void __user *from, unsigned long n)
 		memset(to, 0, n);
 	return n;
 }
-EXPORT_SYMBOL(copy_from_user);
+EXPORT_SYMBOL(_copy_from_user);
+
+void copy_from_user_overflow(void)
+{
+	WARN(1, "Buffer overflow detected!\n");
+}
+EXPORT_SYMBOL(copy_from_user_overflow);
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 61b41ca..d0474ad 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -35,34 +35,3 @@ int fixup_exception(struct pt_regs *regs)
 
 	return 0;
 }
-
-#ifdef CONFIG_X86_64
-/*
- * Need to defined our own search_extable on X86_64 to work around
- * a B stepping K8 bug.
- */
-const struct exception_table_entry *
-search_extable(const struct exception_table_entry *first,
-	       const struct exception_table_entry *last,
-	       unsigned long value)
-{
-	/* B stepping K8 bug */
-	if ((value >> 32) == 0)
-		value |= 0xffffffffUL << 32;
-
-	while (first <= last) {
-		const struct exception_table_entry *mid;
-		long diff;
-
-		mid = (last - first) / 2 + first;
-		diff = mid->insn - value;
-		if (diff == 0)
-			return mid;
-		else if (diff < 0)
-			first = mid+1;
-		else
-			last = mid-1;
-	}
-	return NULL;
-}
-#endif
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 450fa59..e6ef279 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -37,3 +37,11 @@
 #define __cold			__attribute__((__cold__))
 
 #endif
+
+#if __GNUC_MINOR__ > 0
+#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
+#endif
+#if __GNUC_MINOR__ >= 4
+#define __compiletime_warning(message) __attribute__((warning(message)))
+#define __compiletime_error(message) __attribute__((error(message)))
+#endif
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 04fb513..88fd4b6 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -266,6 +266,17 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 #endif
 
+/* Compile time object size, -1 for unknown */
+#ifndef __compiletime_object_size
+# define __compiletime_object_size(obj) -1
+#endif
+#ifndef __compiletime_warning
+# define __compiletime_warning(message)
+#endif
+#ifndef __compiletime_error
+# define __compiletime_error(message)
+#endif
+
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
