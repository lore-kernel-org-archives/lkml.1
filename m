Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbZCEXdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbZCEXdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756304AbZCEXdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:33:42 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:36920 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbZCEXdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:33:41 -0500
Message-Id: <20090305225513.705619098@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:37 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC patch 09/41] LTTng optimize write to page function deal with unaligned access
Content-Disposition: inline; filename=lttng-optimize-write-to-page-function-deal-with-unaligned.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we don't end up doing unaligned accesses on architectures which lack
support for efficient unaligned access.

Standard configurations are either :

If architecture defines
  CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
    -> !CONFIG_LTT_ALIGNMENT  (to save space)

or if the architecture does not define CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
    -> CONFIG_LTT_ALIGNMENT   (to speed up tracing)

Compiling a kernel with tracing active :

Tests done only on x86_64 (which has efficient unaligned access) :

CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
!CONFIG_LTT_ALIGNMENT
real 1m29.349s

CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
CONFIG_LTT_ALIGNMENT
real 1m29.309s

!CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS (forced by modifying arch/x86/Kconfig)
CONFIG_LTT_ALIGNMENT
real	1m29.162s

So even with this supplementary test, the fast path stays fast.

Testing the variations on an architecture without efficient unaligned
access would be welcome.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Martin Bligh <mbligh@google.com>
---
 include/linux/ltt-core.h   |   35 ++++++++++++++++++++++++++++++++
 include/linux/ltt-relay.h  |   49 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/ltt-tracer.h |   35 --------------------------------
 3 files changed, 84 insertions(+), 35 deletions(-)

Index: linux-2.6-lttng/include/linux/ltt-relay.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/ltt-relay.h	2009-03-05 15:23:53.000000000 -0500
+++ linux-2.6-lttng/include/linux/ltt-relay.h	2009-03-05 15:24:23.000000000 -0500
@@ -20,6 +20,7 @@
 #include <linux/poll.h>
 #include <linux/kref.h>
 #include <linux/mm.h>
+#include <linux/ltt-core.h>
 
 /* Needs a _much_ better name... */
 #define FIX_SIZE(x) ((((x) - 1) & PAGE_MASK) + PAGE_SIZE)
@@ -199,6 +200,7 @@ static inline struct buf_page *ltt_relay
 	return page;
 }
 
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 static inline void ltt_relay_do_copy(void *dest, const void *src, size_t len)
 {
 	switch (len) {
@@ -222,6 +224,53 @@ static inline void ltt_relay_do_copy(voi
 		memcpy(dest, src, len);
 	}
 }
+#else
+/*
+ * Returns whether the dest and src addresses are aligned on
+ * min(sizeof(void *), len). Call this with statically known len for efficiency.
+ */
+static inline int addr_aligned(const void *dest, const void *src, size_t len)
+{
+	if (ltt_align((size_t)dest, len))
+		return 0;
+	if (ltt_align((size_t)src, len))
+		return 0;
+	return 1;
+}
+
+static inline void ltt_relay_do_copy(void *dest, const void *src, size_t len)
+{
+	switch (len) {
+	case 0:
+		break;
+	case 1:
+		*(u8 *)dest = *(const u8 *)src;
+		break;
+	case 2:
+		if (unlikely(!addr_aligned(dest, src, 2)))
+			goto memcpy_fallback;
+		*(u16 *)dest = *(const u16 *)src;
+		break;
+	case 4:
+		if (unlikely(!addr_aligned(dest, src, 4)))
+			goto memcpy_fallback;
+		*(u32 *)dest = *(const u32 *)src;
+		break;
+#if (BITS_PER_LONG == 64)
+	case 8:
+		if (unlikely(!addr_aligned(dest, src, 8)))
+			goto memcpy_fallback;
+		*(u64 *)dest = *(const u64 *)src;
+		break;
+#endif
+	default:
+		goto memcpy_fallback;
+	}
+	return;
+memcpy_fallback:
+	memcpy(dest, src, len);
+}
+#endif
 
 static inline int ltt_relay_write(struct rchan_buf *buf, size_t offset,
 	const void *src, size_t len)
Index: linux-2.6-lttng/include/linux/ltt-core.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/ltt-core.h	2009-03-05 15:22:42.000000000 -0500
+++ linux-2.6-lttng/include/linux/ltt-core.h	2009-03-05 15:23:58.000000000 -0500
@@ -44,4 +44,39 @@ extern ltt_run_filter_functor ltt_run_fi
 extern void ltt_filter_register(ltt_run_filter_functor func);
 extern void ltt_filter_unregister(void);
 
+#if defined(CONFIG_LTT) && defined(CONFIG_LTT_ALIGNMENT)
+
+/*
+ * Calculate the offset needed to align the type.
+ * size_of_type must be non-zero.
+ */
+static inline unsigned int ltt_align(size_t align_drift, size_t size_of_type)
+{
+	size_t alignment = min(sizeof(void *), size_of_type);
+	return (alignment - align_drift) & (alignment - 1);
+}
+/* Default arch alignment */
+#define LTT_ALIGN
+
+static inline int ltt_get_alignment(void)
+{
+	return sizeof(void *);
+}
+
+#else
+
+static inline unsigned int ltt_align(size_t align_drift,
+		 size_t size_of_type)
+{
+	return 0;
+}
+
+#define LTT_ALIGN __attribute__((packed))
+
+static inline int ltt_get_alignment(void)
+{
+	return 0;
+}
+#endif /* defined(CONFIG_LTT) && defined(CONFIG_LTT_ALIGNMENT) */
+
 #endif /* LTT_CORE_H */
Index: linux-2.6-lttng/include/linux/ltt-tracer.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/ltt-tracer.h	2009-03-05 15:23:56.000000000 -0500
+++ linux-2.6-lttng/include/linux/ltt-tracer.h	2009-03-05 15:23:58.000000000 -0500
@@ -138,41 +138,6 @@ static inline enum marker_id marker_id_t
 		return MARKER_ID_DYNAMIC;
 }
 
-#if defined(CONFIG_LTT) && defined(CONFIG_LTT_ALIGNMENT)
-
-/*
- * Calculate the offset needed to align the type.
- * size_of_type must be non-zero.
- */
-static inline unsigned int ltt_align(size_t align_drift, size_t size_of_type)
-{
-	size_t alignment = min(sizeof(void *), size_of_type);
-	return (alignment - align_drift) & (alignment - 1);
-}
-/* Default arch alignment */
-#define LTT_ALIGN
-
-static inline int ltt_get_alignment(void)
-{
-	return sizeof(void *);
-}
-
-#else
-
-static inline unsigned int ltt_align(size_t align_drift,
-		 size_t size_of_type)
-{
-	return 0;
-}
-
-#define LTT_ALIGN __attribute__((packed))
-
-static inline int ltt_get_alignment(void)
-{
-	return 0;
-}
-#endif /* CONFIG_LTT_ALIGNMENT */
-
 #ifdef CONFIG_LTT
 
 struct user_dbg_data {

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
