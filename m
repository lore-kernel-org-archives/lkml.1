Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbZJIOYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbZJIOYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760934AbZJIOYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:24:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:42825 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760884AbZJIOYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:24:16 -0400
Date: Fri, 9 Oct 2009 14:23:05 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1254771187.21044.22.camel@laptop>
References: <1254771187.21044.22.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Generate cmpxchg build failures
Message-ID: <tip-f3834b9ef68067199486740b31f691afb14dbdf5@git.kernel.org>
Git-Commit-ID: f3834b9ef68067199486740b31f691afb14dbdf5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 09 Oct 2009 14:23:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3834b9ef68067199486740b31f691afb14dbdf5
Gitweb:     http://git.kernel.org/tip/f3834b9ef68067199486740b31f691afb14dbdf5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 9 Oct 2009 10:12:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Oct 2009 15:57:00 +0200

x86: Generate cmpxchg build failures

Rework the x86 cmpxchg() implementation to generate build failures
when used on improper types.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1254771187.21044.22.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/cmpxchg_32.h |  218 ++++++++++++++---------------------
 arch/x86/include/asm/cmpxchg_64.h |  234 ++++++++++++++----------------------
 2 files changed, 177 insertions(+), 275 deletions(-)

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
