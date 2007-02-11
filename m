Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbXBKTZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbXBKTZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932102AbXBKTXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:23:22 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:64230 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932109AbXBKTXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:23:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH 10/10] atomic.h : Add atomic64 cmpxchg, xchg and add_unless to x86_64
Date: Sun, 11 Feb 2007 14:17:48 -0500
Message-Id: <11712214703522-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

atomic.h : Add atomic64 cmpxchg, xchg and add_unless to x86_64

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-x86_64/atomic.h
+++ b/include/asm-x86_64/atomic.h
@@ -375,8 +375,8 @@ static __inline__ long atomic64_add_return(long i, atomic64_t *v)
 	long __i = i;
 	__asm__ __volatile__(
 		LOCK_PREFIX "xaddq %0, %1;"
-		:"=r"(i)
-		:"m"(v->counter), "0"(i));
+		:"+r" (i), "+m" (v->counter)
+		: : "memory");
 	return i + __i;
 }
 
@@ -388,7 +388,10 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t *v)
 #define atomic64_inc_return(v)  (atomic64_add_return(1,v))
 #define atomic64_dec_return(v)  (atomic64_sub_return(1,v))
 
-#define atomic_cmpxchg(v, old, new) ((int)cmpxchg(&((v)->counter), old, new))
+#define atomic64_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
+
+#define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
@@ -402,7 +405,7 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t *v)
  */
 #define atomic_add_unless(v, a, u)				\
 ({								\
-	int c, old;						\
+	__typeof__((v)->counter) c, old;			\
 	c = atomic_read(v);					\
 	for (;;) {						\
 		if (unlikely(c == (u)))				\
@@ -416,6 +419,31 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t *v)
 })
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
+/**
+ * atomic64_add_unless - add unless the number is a given value
+ * @v: pointer of type atomic64_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as it was not @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
+#define atomic64_add_unless(v, a, u)				\
+({								\
+	__typeof__((v)->counter) c, old;			\
+	c = atomic64_read(v);					\
+	for (;;) {						\
+		if (unlikely(c == (u)))				\
+			break;					\
+		old = atomic64_cmpxchg((v), c, c + (a));	\
+		if (likely(old == c))				\
+			break;					\
+		c = old;					\
+	}							\
+	c != (u);						\
+})
+#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
+
 /* These are x86-specific, used by some header files */
 #define atomic_clear_mask(mask, addr) \
 __asm__ __volatile__(LOCK_PREFIX "andl %0,%1" \
