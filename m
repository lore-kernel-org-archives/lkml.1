Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbXBKTW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbXBKTW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932102AbXBKTW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:22:58 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:64200 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932099AbXBKTW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:22:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH 04/10] atomic.h : Add atomic64 cmpxchg, xchg and add_unless to ia64
Date: Sun, 11 Feb 2007 14:17:42 -0500
Message-Id: <11712214681012-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

atomic.h : Add atomic64 cmpxchg, xchg and add_unless to ia64

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-ia64/atomic.h
+++ b/include/asm-ia64/atomic.h
@@ -88,12 +88,16 @@ ia64_atomic64_sub (__s64 i, atomic64_t *v)
 	return new;
 }
 
-#define atomic_cmpxchg(v, old, new) ((int)cmpxchg(&((v)->counter), old, new))
+#define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
+#define atomic64_cmpxchg(v, old, new) \
+	(cmpxchg(&((v)->counter), old, new))
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
+
 #define atomic_add_unless(v, a, u)				\
 ({								\
-	int c, old;						\
+	__typeof__(v->counter) c, old;				\
 	c = atomic_read(v);					\
 	for (;;) {						\
 		if (unlikely(c == (u)))				\
@@ -107,6 +111,22 @@ ia64_atomic64_sub (__s64 i, atomic64_t *v)
 })
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
+#define atomic64_add_unless(v, a, u)				\
+({								\
+	__typeof__(v->counter) c, old;				\
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
 #define atomic_add_return(i,v)						\
 ({									\
 	int __ia64_aar_i = (i);						\
