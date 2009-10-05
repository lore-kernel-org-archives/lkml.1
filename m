Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZJEP6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZJEP6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbZJEP6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:58:11 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:50610 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZJEP6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:58:10 -0400
X-SourceIP: 213.93.53.227
Subject: [PATCH] x86: Generate cmpxchg build failures
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
	 <4AC060AE.1090401@gmail.com>
	 <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain>
	 <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com>
	 <4AC10365.7090802@gmail.com> <4AC2712C.4080901@gmail.com>
	 <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 05 Oct 2009 18:00:25 +0200
Message-Id: <1254758425.26976.126.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-29 at 14:17 -0700, Linus Torvalds wrote:

> And regardless, we should fix the silent cmpxchg failure, even if it's 
> just a link-time failure or something.

Something like the below?

Seems to build defconfig-i386, defconfig-x86_64 and generates a build
failure on i386 with the sched_clock cmpxchg64 thing undone.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/include/asm/cmpxchg_32.h |  274 ++++++++++++++++++----------------
 arch/x86/include/asm/cmpxchg_64.h |  296 +++++++++++++++++++-----------------
 2 files changed, 298 insertions(+), 272 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index ee1931b..45ed563 100644
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
+ 	__typeof(*(ptr)) __x = (x);					\
+	switch (size) {							\
+ 	case 1:								\
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
@@ -71,57 +107,119 @@ static inline void __set_64bit_var(unsigned long long *ptr,
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
+#define __cmpxchg(ptr, old, new, size)					\
+({									\
+ 	__typeof__(*(ptr)) __ret;					\
+ 	__typeof__(*(ptr)) __old = (old);				\
+ 	__typeof__(*(ptr)) __new = (new);				\
+	switch (size) {							\
+	case 1:								\
+		asm volatile(LOCK_PREFIX "cmpxchgb %b1,%2"		\
+			     : "=a"(__ret)				\
+			     : "q"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	case 2:								\
+		asm volatile(LOCK_PREFIX "cmpxchgw %w1,%2"		\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	case 4:								\
+		asm volatile(LOCK_PREFIX "cmpxchgl %1,%2"		\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	default:							\
+		__cmpxchg_wrong_size();					\
+	}								\
+	__ret;								\
+})
+
+/*
+ * Always use locked operations when touching memory shared with a
+ * hypervisor, since the system may be SMP even if the guest kernel
+ * isn't.
+ */
+#define __sync_cmpxchg(ptr, old, new, size)				\
+({									\
+ 	__typeof__(*(ptr)) __ret;					\
+ 	__typeof__(*(ptr)) __old = (old);				\
+ 	__typeof__(*(ptr)) __new = (new);				\
+	switch (size) {							\
+	case 1:								\
+		asm volatile("lock; cmpxchgb %b1,%2"			\
+			     : "=a"(__ret)				\
+			     : "q"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	case 2:								\
+		asm volatile("lock; cmpxchgw %w1,%2"			\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	case 4:								\
+		asm volatile("lock; cmpxchgl %1,%2"			\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	default:							\
+		__cmpxchg_wrong_size();					\
+	}								\
+	__ret;								\
+})
+
+#define __cmpxchg_local(ptr, old, new, size)				\
+({									\
+ 	__typeof__(*(ptr)) __ret;					\
+ 	__typeof__(*(ptr)) __old = (old);				\
+ 	__typeof__(*(ptr)) __new = (new);				\
+	switch (size) {							\
+	case 1:								\
+		asm volatile("cmpxchgb %b1,%2"				\
+			     : "=a"(__ret)				\
+			     : "q"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	case 2:								\
+		asm volatile("cmpxchgw %w1,%2"				\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	case 4:								\
+		asm volatile("cmpxchgl %1,%2"				\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	default:							\
+		__cmpxchg_wrong_size();					\
+	}								\
+	__ret;								\
+})
 
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
@@ -133,94 +231,6 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
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
index 52de72e..df20c6e 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -3,9 +3,6 @@
 
 #include <asm/alternative.h> /* Provides LOCK_PREFIX */
 
-#define xchg(ptr, v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v), \
-						 (ptr), sizeof(*(ptr))))
-
 #define __xg(x) ((volatile long *)(x))
 
 static inline void set_64bit(volatile unsigned long *ptr, unsigned long val)
@@ -15,167 +12,186 @@ static inline void set_64bit(volatile unsigned long *ptr, unsigned long val)
 
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
+ 	__typeof(*(ptr)) __x = (x);					\
+	switch (size) {							\
+ 	case 1:								\
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
 
 /*
  * Atomic compare and exchange.  Compare OLD with MEM, if identical,
  * store NEW in MEM.  Return the initial value in MEM.  Success is
  * indicated by comparing RETURN with OLD.
  */
-
-#define __HAVE_ARCH_CMPXCHG 1
-
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
+#define __cmpxchg(ptr, old, new, size)					\
+({									\
+ 	__typeof__(*(ptr)) __ret;					\
+ 	__typeof__(*(ptr)) __old = (old);				\
+ 	__typeof__(*(ptr)) __new = (new);				\
+	switch (size) {							\
+	case 1:								\
+		asm volatile(LOCK_PREFIX "cmpxchgb %b1,%2"		\
+			     : "=a"(__ret)				\
+			     : "q"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	case 2:								\
+		asm volatile(LOCK_PREFIX "cmpxchgw %w1,%2"		\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	case 4:								\
+		asm volatile(LOCK_PREFIX "cmpxchgl %k1,%2"		\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	case 8:								\
+		asm volatile(LOCK_PREFIX "cmpxchgq %1,%2"		\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+		break;							\
+	default:							\
+		__cmpxchg_wrong_size();					\
+	}								\
+	__ret;								\
+})
 
 /*
  * Always use locked operations when touching memory shared with a
  * hypervisor, since the system may be SMP even if the guest kernel
  * isn't.
  */
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
+#define __sync_cmpxchg(ptr, old, new, size)				\
+({									\
+ 	__typeof__(*(ptr)) __ret;					\
+ 	__typeof__(*(ptr)) __old = (old);				\
+ 	__typeof__(*(ptr)) __new = (new);				\
+	switch (size) {							\
+	case 1:								\
+		asm volatile("lock; cmpxchgb %b1,%2"			\
+			     : "=a"(__ret)				\
+			     : "q"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	case 2:								\
+		asm volatile("lock; cmpxchgw %w1,%2"			\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	case 4:								\
+		asm volatile("lock; cmpxchgl %k1,%2"			\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	case 8:								\
+		asm volatile("lock; cmpxchgq %1,%2"			\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+		break;							\
+	default:							\
+		__cmpxchg_wrong_size();					\
+	}								\
+	__ret;								\
+})
 
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
+#define __cmpxchg_local(ptr, old, new, size)				\
+({									\
+ 	__typeof__(*(ptr)) __ret;					\
+ 	__typeof__(*(ptr)) __old = (old);				\
+ 	__typeof__(*(ptr)) __new = (new);				\
+	switch (size) {							\
+	case 1:								\
+		asm volatile("cmpxchgb %b1,%2"				\
+			     : "=a"(__ret)				\
+			     : "q"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	case 2:								\
+		asm volatile("cmpxchgw %w1,%2"				\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	case 4:								\
+		asm volatile("cmpxchgl %k1,%2"				\
+			     : "=a"(__ret)				\
+			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+			     : "memory");				\
+ 		break;							\
+	case 8:								\
+		asm volatile("cmpxchgq %1,%2"				\
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
+#define __HAVE_ARCH_CMPXCHG 1
+
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


