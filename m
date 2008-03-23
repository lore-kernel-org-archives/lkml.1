Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbYCWIMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbYCWIMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758825AbYCWIIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:01 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2191 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758715AbYCWIHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:07:55 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 016/148] include/asm-x86/cmpxchg_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:51 -0700
Message-Id: <1206259443-13210-17-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/cmpxchg_32.h |  253 ++++++++++++++++++++++--------------------
 1 files changed, 132 insertions(+), 121 deletions(-)

diff --git a/include/asm-x86/cmpxchg_32.h b/include/asm-x86/cmpxchg_32.h
index 959fad0..bf5a69d 100644
--- a/include/asm-x86/cmpxchg_32.h
+++ b/include/asm-x86/cmpxchg_32.h
@@ -8,9 +8,12 @@
  *       you need to test for the feature in boot_cpu_data.
  */
 
-#define xchg(ptr,v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v),(ptr),sizeof(*(ptr))))
+#define xchg(ptr, v)							\
+	((__typeof__(*(ptr)))__xchg((unsigned long)(v), (ptr), sizeof(*(ptr))))
 
-struct __xchg_dummy { unsigned long a[100]; };
+struct __xchg_dummy {
+	unsigned long a[100];
+};
 #define __xg(x) ((struct __xchg_dummy *)(x))
 
 /*
@@ -27,72 +30,74 @@ struct __xchg_dummy { unsigned long a[100]; };
  * of the instruction set reference 24319102.pdf. We need
  * the reader side to see the coherent 64bit value.
  */
-static inline void __set_64bit (unsigned long long * ptr,
-		unsigned int low, unsigned int high)
+static inline void __set_64bit(unsigned long long *ptr,
+			       unsigned int low, unsigned int high)
 {
-	__asm__ __volatile__ (
-		"\n1:\t"
-		"movl (%0), %%eax\n\t"
-		"movl 4(%0), %%edx\n\t"
-		LOCK_PREFIX "cmpxchg8b (%0)\n\t"
-		"jnz 1b"
-		: /* no outputs */
-		:	"D"(ptr),
-			"b"(low),
-			"c"(high)
-		:	"ax","dx","memory");
+	asm volatile("\n1:\t"
+		     "movl (%0), %%eax\n\t"
+		     "movl 4(%0), %%edx\n\t"
+		     LOCK_PREFIX "cmpxchg8b (%0)\n\t"
+		     "jnz 1b"
+		     : /* no outputs */
+		     : "D"(ptr),
+		       "b"(low),
+		       "c"(high)
+		     : "ax", "dx", "memory");
 }
 
-static inline void __set_64bit_constant (unsigned long long *ptr,
-						 unsigned long long value)
+static inline void __set_64bit_constant(unsigned long long *ptr,
+					unsigned long long value)
 {
-	__set_64bit(ptr,(unsigned int)(value), (unsigned int)((value)>>32ULL));
+	__set_64bit(ptr, (unsigned int)value, (unsigned int)(value >> 32));
 }
-#define ll_low(x)	*(((unsigned int*)&(x))+0)
-#define ll_high(x)	*(((unsigned int*)&(x))+1)
 
-static inline void __set_64bit_var (unsigned long long *ptr,
-			 unsigned long long value)
+#define ll_low(x)	*(((unsigned int *)&(x)) + 0)
+#define ll_high(x)	*(((unsigned int *)&(x)) + 1)
+
+static inline void __set_64bit_var(unsigned long long *ptr,
+				   unsigned long long value)
 {
-	__set_64bit(ptr,ll_low(value), ll_high(value));
+	__set_64bit(ptr, ll_low(value), ll_high(value));
 }
 
-#define set_64bit(ptr,value) \
-(__builtin_constant_p(value) ? \
- __set_64bit_constant(ptr, value) : \
- __set_64bit_var(ptr, value) )
+#define set_64bit(ptr, value)			\
+	(__builtin_constant_p((value))		\
+	 ? __set_64bit_constant((ptr), (value))	\
+	 : __set_64bit_var((ptr), (value)))
 
-#define _set_64bit(ptr,value) \
-(__builtin_constant_p(value) ? \
- __set_64bit(ptr, (unsigned int)(value), (unsigned int)((value)>>32ULL) ) : \
- __set_64bit(ptr, ll_low(value), ll_high(value)) )
+#define _set_64bit(ptr, value)						\
+	(__builtin_constant_p(value)					\
+	 ? __set_64bit(ptr, (unsigned int)(value),			\
+		       (unsigned int)((value) >> 32))			\
+	 : __set_64bit(ptr, ll_low((value)), ll_high((value))))
 
 /*
  * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
  * Note 2: xchg has side effect, so that attribute volatile is necessary,
  *	  but generally the primitive is invalid, *ptr is output argument. --ANK
  */
-static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
+				   int size)
 {
 	switch (size) {
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
+	case 1:
+		asm volatile("xchgb %b0,%1"
+			     : "=q" (x)
+			     : "m" (*__xg(ptr)), "0" (x)
+			     : "memory");
+		break;
+	case 2:
+		asm volatile("xchgw %w0,%1"
+			     : "=r" (x)
+			     : "m" (*__xg(ptr)), "0" (x)
+			     : "memory");
+		break;
+	case 4:
+		asm volatile("xchgl %0,%1"
+			     : "=r" (x)
+			     : "m" (*__xg(ptr)), "0" (x)
+			     : "memory");
+		break;
 	}
 	return x;
 }
@@ -105,24 +110,27 @@ static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int siz
 
 #ifdef CONFIG_X86_CMPXCHG
 #define __HAVE_ARCH_CMPXCHG 1
-#define cmpxchg(ptr, o, n)						     \
-	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	     \
-					(unsigned long)(n), sizeof(*(ptr))))
-#define sync_cmpxchg(ptr, o, n)						     \
-	((__typeof__(*(ptr)))__sync_cmpxchg((ptr), (unsigned long)(o),	     \
-					(unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg_local(ptr, o, n)					     \
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	     \
-					(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg(ptr, o, n)						\
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	\
+				       (unsigned long)(n),		\
+				       sizeof(*(ptr))))
+#define sync_cmpxchg(ptr, o, n)						\
+	((__typeof__(*(ptr)))__sync_cmpxchg((ptr), (unsigned long)(o),	\
+					    (unsigned long)(n),		\
+					    sizeof(*(ptr))))
+#define cmpxchg_local(ptr, o, n)					\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+					     (unsigned long)(n),	\
+					     sizeof(*(ptr))))
 #endif
 
 #ifdef CONFIG_X86_CMPXCHG64
-#define cmpxchg64(ptr, o, n)						      \
-	((__typeof__(*(ptr)))__cmpxchg64((ptr), (unsigned long long)(o),      \
-					(unsigned long long)(n)))
-#define cmpxchg64_local(ptr, o, n)					      \
-	((__typeof__(*(ptr)))__cmpxchg64_local((ptr), (unsigned long long)(o),\
-					(unsigned long long)(n)))
+#define cmpxchg64(ptr, o, n)						\
+	((__typeof__(*(ptr)))__cmpxchg64((ptr), (unsigned long long)(o), \
+					 (unsigned long long)(n)))
+#define cmpxchg64_local(ptr, o, n)					\
+	((__typeof__(*(ptr)))__cmpxchg64_local((ptr), (unsigned long long)(o), \
+					       (unsigned long long)(n)))
 #endif
 
 static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
@@ -131,22 +139,22 @@ static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile(LOCK_PREFIX "cmpxchgb %b1,%2"
+			     : "=a"(prev)
+			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	case 2:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile(LOCK_PREFIX "cmpxchgw %w1,%2"
+			     : "=a"(prev)
+			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	case 4:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgl %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile(LOCK_PREFIX "cmpxchgl %1,%2"
+			     : "=a"(prev)
+			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	}
 	return old;
@@ -158,85 +166,88 @@ static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
  * isn't.
  */
 static inline unsigned long __sync_cmpxchg(volatile void *ptr,
-					    unsigned long old,
-					    unsigned long new, int size)
+					   unsigned long old,
+					   unsigned long new, int size)
 {
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		__asm__ __volatile__("lock; cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile("lock; cmpxchgb %b1,%2"
+			     : "=a"(prev)
+			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	case 2:
-		__asm__ __volatile__("lock; cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile("lock; cmpxchgw %w1,%2"
+			     : "=a"(prev)
+			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	case 4:
-		__asm__ __volatile__("lock; cmpxchgl %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile("lock; cmpxchgl %1,%2"
+			     : "=a"(prev)
+			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	}
 	return old;
 }
 
 static inline unsigned long __cmpxchg_local(volatile void *ptr,
-			unsigned long old, unsigned long new, int size)
+					    unsigned long old,
+					    unsigned long new, int size)
 {
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		__asm__ __volatile__("cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile("cmpxchgb %b1,%2"
+			     : "=a"(prev)
+			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	case 2:
-		__asm__ __volatile__("cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile("cmpxchgw %w1,%2"
+			     : "=a"(prev)
+			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	case 4:
-		__asm__ __volatile__("cmpxchgl %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile("cmpxchgl %1,%2"
+			     : "=a"(prev)
+			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	}
 	return old;
 }
 
 static inline unsigned long long __cmpxchg64(volatile void *ptr,
-			unsigned long long old, unsigned long long new)
+					     unsigned long long old,
+					     unsigned long long new)
 {
 	unsigned long long prev;
-	__asm__ __volatile__(LOCK_PREFIX "cmpxchg8b %3"
-			     : "=A"(prev)
-			     : "b"((unsigned long)new),
-			       "c"((unsigned long)(new >> 32)),
-			       "m"(*__xg(ptr)),
-			       "0"(old)
-			     : "memory");
+	asm volatile(LOCK_PREFIX "cmpxchg8b %3"
+		     : "=A"(prev)
+		     : "b"((unsigned long)new),
+		       "c"((unsigned long)(new >> 32)),
+		       "m"(*__xg(ptr)),
+		       "0"(old)
+		     : "memory");
 	return prev;
 }
 
 static inline unsigned long long __cmpxchg64_local(volatile void *ptr,
-			unsigned long long old, unsigned long long new)
+						   unsigned long long old,
+						   unsigned long long new)
 {
 	unsigned long long prev;
-	__asm__ __volatile__("cmpxchg8b %3"
-			     : "=A"(prev)
-			     : "b"((unsigned long)new),
-			       "c"((unsigned long)(new >> 32)),
-			       "m"(*__xg(ptr)),
-			       "0"(old)
-			     : "memory");
+	asm volatile("cmpxchg8b %3"
+		     : "=A"(prev)
+		     : "b"((unsigned long)new),
+		       "c"((unsigned long)(new >> 32)),
+		       "m"(*__xg(ptr)),
+		       "0"(old)
+		     : "memory");
 	return prev;
 }
 
@@ -252,7 +263,7 @@ extern unsigned long cmpxchg_386_u16(volatile void *, u16, u16);
 extern unsigned long cmpxchg_386_u32(volatile void *, u32, u32);
 
 static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
+					unsigned long new, int size)
 {
 	switch (size) {
 	case 1:
-- 
1.5.4.rc2

