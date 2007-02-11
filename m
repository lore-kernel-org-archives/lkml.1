Return-Path: <linux-kernel-owner+w=401wt.eu-S932072AbXBKTRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbXBKTRw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932071AbXBKTRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:17:52 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:42175 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787AbXBKTRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:17:50 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH 01/10] atomic.h : Add atomic64 cmpxchg, xchg and add_unless to alpha
Date: Sun, 11 Feb 2007 14:17:39 -0500
Message-Id: <1171221468451-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

atomic.h : Add atomic64 cmpxchg, xchg and add_unless to alpha

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-alpha/atomic.h
+++ b/include/asm-alpha/atomic.h
@@ -175,19 +175,62 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t * v)
 	return result;
 }
 
-#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
+#define atomic64_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
+
+#define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
+/**
+ * atomic_add_unless - add unless the number is a given value
+ * @v: pointer of type atomic_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as it was not @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
 #define atomic_add_unless(v, a, u)				\
 ({								\
-	int c, old;						\
+	__typeof__((v)->counter) c, old;			\
 	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
+	for (;;) {						\
+		if (unlikely(c == (u)))				\
+			break;					\
+		old = atomic_cmpxchg((v), c, c + (a));		\
+		if (likely(old == c))				\
+			break;					\
 		c = old;					\
+	}							\
 	c != (u);						\
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
 #define atomic_add_negative(a, v) (atomic_add_return((a), (v)) < 0)
 #define atomic64_add_negative(a, v) (atomic64_add_return((a), (v)) < 0)
 
