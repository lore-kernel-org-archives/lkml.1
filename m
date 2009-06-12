Return-Path: <linux-kernel-owner+w=401wt.eu-S933820AbZFLV1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820AbZFLV1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764326AbZFLV1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:27:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42760 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762980AbZFLV1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:27:09 -0400
Date: Fri, 12 Jun 2009 17:24:49 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, bligh@google.com, roland@redhat.com,
       fche@redhat.com
Message-Id: <0ee4090012cf46f25d8cd8b022746a43b99d5767.1244837725.git.jbaron@redhat.com>
In-Reply-To: <cover.1244837725.git.jbaron@redhat.com>
References: <cover.1244837725.git.jbaron@redhat.com>
Subject: [PATCH 3/7] add syscall tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce a new 'DECLARE_TRACE_REG()' macro, so that tracepoints can associate
an external register/unregister function.


Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 include/linux/tracepoint.h |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 14df7e6..9a3660b 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -61,7 +61,7 @@ struct tracepoint {
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  */
-#define DECLARE_TRACE(name, proto, args)				\
+#define DECLARE_TRACE_REG(name, proto, args, reg, unreg)		\
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
@@ -71,13 +71,29 @@ struct tracepoint {
 	}								\
 	static inline int register_trace_##name(void (*probe)(proto))	\
 	{								\
-		return tracepoint_probe_register(#name, (void *)probe);	\
+		int ret;						\
+		void (*func)(void) = (void (*)(void))reg;		\
+									\
+		ret = tracepoint_probe_register(#name, (void *)probe);	\
+		if (func && !ret)					\
+			func();						\
+		return ret;						\
 	}								\
 	static inline int unregister_trace_##name(void (*probe)(proto))	\
 	{								\
-		return tracepoint_probe_unregister(#name, (void *)probe);\
+		int ret;						\
+		void (*func)(void) = (void (*)(void))unreg;		\
+									\
+		ret = tracepoint_probe_unregister(#name, (void *)probe);\
+		if (func && !ret)					\
+			func();						\
+		return ret;						\
 	}
 
+
+#define DECLARE_TRACE(name, proto, args)		\
+	DECLARE_TRACE_REG(name, TP_PROTO(proto), TP_ARGS(args), 0, 0);
+
 #define DEFINE_TRACE(name)						\
 	static const char __tpstrtab_##name[]				\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
@@ -94,7 +110,7 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 	struct tracepoint *end);
 
 #else /* !CONFIG_TRACEPOINTS */
-#define DECLARE_TRACE(name, proto, args)				\
+#define DECLARE_TRACE_REG(name, proto, args, reg, unreg)		\
 	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
 	{ }								\
 	static inline void trace_##name(proto)				\
@@ -108,6 +124,9 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 		return -ENOSYS;						\
 	}
 
+#define DECLARE_TRACE(name, proto, args)                \
+	DECLARE_TRACE_REG(name, TP_PROTO(proto), TP_ARGS(args), 0, 0);
+
 #define DEFINE_TRACE(name)
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
 #define EXPORT_TRACEPOINT_SYMBOL(name)
-- 
1.6.0.6

