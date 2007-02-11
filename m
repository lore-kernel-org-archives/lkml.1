Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbXBKTSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbXBKTSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932071AbXBKTRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:17:54 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:48588 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789AbXBKTRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:17:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH 05/10] atomic.h : Add atomic64 cmpxchg, xchg and add_unless to mips
Date: Sun, 11 Feb 2007 14:17:43 -0500
Message-Id: <117122146921-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

atomic.h : Add atomic64 cmpxchg, xchg and add_unless to mips

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-mips/atomic.h
+++ b/include/asm-mips/atomic.h
@@ -291,8 +291,8 @@ static __inline__ int atomic_sub_if_positive(int i, atomic_t * v)
 	return result;
 }
 
-#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+#define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
+#define atomic_xchg(v, new) (xchg(&((v)->counter), (new)))
 
 /**
  * atomic_add_unless - add unless the number is a given value
@@ -305,7 +305,7 @@ static __inline__ int atomic_sub_if_positive(int i, atomic_t * v)
  */
 #define atomic_add_unless(v, a, u)				\
 ({								\
-	int c, old;						\
+	__typeof__((v)->counter) c, old;			\
 	c = atomic_read(v);					\
 	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
 		c = old;					\
@@ -651,6 +651,29 @@ static __inline__ long atomic64_sub_if_positive(long i, atomic64_t * v)
 	return result;
 }
 
+#define atomic64_cmpxchg(v, o, n) \
+	(((__typeof__((v)->counter)))cmpxchg(&((v)->counter), (o), (n)))
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), (new)))
+
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
+	c = atomic_read(v);					\
+	while (c != (u) && (old = atomic64_cmpxchg((v), c, c + (a))) != c) \
+		c = old;					\
+	c != (u);						\
+})
+#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
+
 #define atomic64_dec_return(v) atomic64_sub_return(1,(v))
 #define atomic64_inc_return(v) atomic64_add_return(1,(v))
 
