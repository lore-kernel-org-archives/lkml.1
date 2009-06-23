Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZFWScK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZFWScK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbZFWSbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:31:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39326 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645AbZFWSbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:31:36 -0400
Date: Tue, 23 Jun 2009 14:29:04 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com, lizf@cn.fujitsu.com
Message-Id: <df45ccb4905bff0e49d11386b44b0eb23034e83c.1245770664.git.jbaron@redhat.com>
In-Reply-To: <cover.1245770664.git.jbaron@redhat.com>
References: <cover.1245770664.git.jbaron@redhat.com>
Subject: [PATCH 3/7] V2 add syscall tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce a new 'DECLARE_TRACE_WITH_CALLBACK()' macro, so that tracepoints can 
associate an external register/unregister function.


Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

---
 include/linux/tracepoint.h |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index b9dc4ca..778e018 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -60,8 +60,10 @@ struct tracepoint {
  * Make sure the alignment of the structure in the __tracepoints section will
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
+ * An optional set of (un)registration functions can be passed to perform any
+ * additional (un)registration work.
  */
-#define DECLARE_TRACE(name, proto, args)				\
+#define DECLARE_TRACE_WITH_CALLBACK(name, proto, args, reg, unreg)	\
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
@@ -71,13 +73,29 @@ struct tracepoint {
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
+	DECLARE_TRACE_WITH_CALLBACK(name, TP_PROTO(proto), TP_ARGS(args), 0, 0);
+
 #define DEFINE_TRACE(name)						\
 	static const char __tpstrtab_##name[]				\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
@@ -94,7 +112,7 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 	struct tracepoint *end);
 
 #else /* !CONFIG_TRACEPOINTS */
-#define DECLARE_TRACE(name, proto, args)				\
+#define DECLARE_TRACE_WITH_CALLBACK(name, proto, args, reg, unreg)	\
 	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
 	{ }								\
 	static inline void trace_##name(proto)				\
@@ -108,6 +126,9 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 		return -ENOSYS;						\
 	}
 
+#define DECLARE_TRACE(name, proto, args)                \
+	DECLARE_TRACE_WITH_CALLBACK(name, TP_PROTO(proto), TP_ARGS(args), 0, 0);
+
 #define DEFINE_TRACE(name)
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
 #define EXPORT_TRACEPOINT_SYMBOL(name)
-- 
1.6.0.6

