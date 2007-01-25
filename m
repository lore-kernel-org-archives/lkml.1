Return-Path: <linux-kernel-owner+w=401wt.eu-S1030289AbXAYQVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030289AbXAYQVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030297AbXAYQVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:21:08 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:47384 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030289AbXAYQVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:21:07 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, Douglas Niehaus <niehaus@eecs.ku.edu>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH 06/09] atomic.h : Add atomic64 cmpxchg, xchg and add_unless to parisc
Date: Thu, 25 Jan 2007 11:15:51 -0500
Message-Id: <1169741756818-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: git-send-email 1.4.4.3
In-Reply-To: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

atomic.h : Add atomic64 cmpxchg, xchg and add_unless to parisc

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-parisc/atomic.h
+++ b/include/asm-parisc/atomic.h
@@ -163,7 +163,8 @@ static __inline__ int atomic_read(const atomic_t *v)
 }
 
 /* exported interface */
-#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
+#define atomic_cmpxchg(v, o, n) \
+	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
@@ -177,7 +178,7 @@ static __inline__ int atomic_read(const atomic_t *v)
  */
 #define atomic_add_unless(v, a, u)				\
 ({								\
-	int c, old;						\
+	__typeof__((v)->counter) c, old;						\
 	c = atomic_read(v);					\
 	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
 		c = old;					\
@@ -270,6 +271,31 @@ atomic64_read(const atomic64_t *v)
 #define atomic64_dec_and_test(v)	(atomic64_dec_return(v) == 0)
 #define atomic64_sub_and_test(i,v)	(atomic64_sub_return((i),(v)) == 0)
 
+/* exported interface */
+#define atomic64_cmpxchg(v, o, n) \
+	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
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
+	__typeof__((v)->counter) c, old;						\
+	c = atomic64_read(v);					\
+	while (c != (u) && (old = atomic64_cmpxchg((v), c, c + (a))) != c) \
+		c = old;					\
+	c != (u);						\
+})
+#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
+
+
 #endif /* __LP64__ */
 
 #include <asm-generic/atomic.h>
