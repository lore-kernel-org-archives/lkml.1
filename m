Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbZESVFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbZESVFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZESVFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:05:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44875 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbZESVFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:05:21 -0400
Date: Tue, 19 May 2009 17:03:39 -0400
Message-Id: <4600839ddabeb9b9d0aea7a72b6812d524e698ca.1242763826.git.jbaron@redhat.com>
In-Reply-To: <cover.1242763826.git.jbaron@redhat.com>
References: <cover.1242763826.git.jbaron@redhat.com>
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
CC: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: [PATCH 1/3] tracepoints: add tracepoint_call() to optimize tracepoints disabled
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a wrapper function call before the call to 'trace_##name'. This preserves
the type checking, while allowing arguments that are passed to the tracepoint
to not be evaluated until after the tracepoint on/off check is performed.
This reduces the cost when tracepoints are disabled.


Signed-off-by: Jason Baron <jbaron@redhat.com>


---
 include/linux/tracepoint.h |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 14df7e6..d747c78 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -65,7 +65,6 @@ struct tracepoint {
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		if (unlikely(__tracepoint_##name.state))		\
 			__DO_TRACE(&__tracepoint_##name,		\
 				TP_PROTO(proto), TP_ARGS(args));	\
 	}								\
@@ -78,6 +77,19 @@ struct tracepoint {
 		return tracepoint_probe_unregister(#name, (void *)probe);\
 	}
 
+/*
+ * Use this function in the instrumented code. This wrapper call to trace_##name
+ * is added so that arguments aren't evaluated, and do not have side-effects
+ * when a tracepoint is disabled. We still call the inline for type checking.
+ */
+
+#define tracepoint_call(name, ...)		     \
+do {						     \
+	extern struct tracepoint __tracepoint_##name;\
+	if (unlikely(__tracepoint_##name.state))     \
+		trace_##name(__VA_ARGS__);	     \
+} while (0)
+
 #define DEFINE_TRACE(name)						\
 	static const char __tpstrtab_##name[]				\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
@@ -108,6 +120,12 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 		return -ENOSYS;						\
 	}
 
+#define tracepoint_call(name, ...)	  \
+do {					  \
+	if (0)				  \
+		trace_##name(__VA_ARGS__);\
+} while (0)
+
 #define DEFINE_TRACE(name)
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
 #define EXPORT_TRACEPOINT_SYMBOL(name)
-- 
1.6.0.6

