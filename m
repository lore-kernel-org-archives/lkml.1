Return-Path: <linux-kernel-owner+w=401wt.eu-S1030270AbXAYQQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030270AbXAYQQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030258AbXAYQQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:16:08 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:46920 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030272AbXAYQQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:16:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, Douglas Niehaus <niehaus@eecs.ku.edu>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH 04/09] atomic.h : Add atomic64 cmpxchg, xchg and add_unless to ia64
Date: Thu, 25 Jan 2007 11:15:49 -0500
Message-Id: <1169741755638-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: git-send-email 1.4.4.3
In-Reply-To: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

atomic.h : Add atomic64 cmpxchg, xchg and add_unless to ia64

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-ia64/atomic.h
+++ b/include/asm-ia64/atomic.h
@@ -88,12 +88,17 @@ ia64_atomic64_sub (__s64 i, atomic64_t *v)
 	return new;
 }
 
-#define atomic_cmpxchg(v, old, new) ((int)cmpxchg(&((v)->counter), old, new))
+#define atomic_cmpxchg(v, old, new) \
+	((__typeof__((v)->counter))cmpxchg(&((v)->counter), old, new))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
+#define atomic64_cmpxchg(v, old, new) \
+	((__typeof__((v)->counter))cmpxchg(&((v)->counter), old, new))
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
+
 #define atomic_add_unless(v, a, u)				\
 ({								\
-	int c, old;						\
+	__typeof__(v->counter) c, old;				\
 	c = atomic_read(v);					\
 	for (;;) {						\
 		if (unlikely(c == (u)))				\
@@ -107,6 +112,22 @@ ia64_atomic64_sub (__s64 i, atomic64_t *v)
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
