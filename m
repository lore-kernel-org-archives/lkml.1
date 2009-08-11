Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbZHKStV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbZHKStV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932109AbZHKStR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:49:17 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:32762 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbZHKStP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:49:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iBbX+oZ0cyorYGRe5OSVTkuPoOAJDuMEiuYt0+hRMrRuc2XDgh8qnPFQI7cLqdfbma
         twCumFlkymmYLYJIY7Z2OdCgosroMtL0zRZeDI/ttciKynAlfa7VqrrKNeXQLsZBL09C
         o+w00sFSoffbXF6kDlSt/cVg9mr9UGbQDUIsI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 04/16] tracing: Add DECLARE_TRACE_WITH_CALLBACK() macro
Date: Tue, 11 Aug 2009 20:48:53 +0200
Message-Id: <1250016545-6601-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Introduce a new 'DECLARE_TRACE_WITH_CALLBACK()' macro, so that
tracepoints can associate an external register/unregister function.

This prepares for the syscalls tracer conversion to trace events. We
will need to perform arch level operations once a syscall event is
turned on/off, such as TIF flags setting, hence the need of such
specific callbacks.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/tracepoint.h |   31 +++++++++++++++++++++++++++----
 1 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index b9dc4ca..5984ed0 100644
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
@@ -71,13 +73,30 @@ struct tracepoint {
 	}								\
 	static inline int register_trace_##name(void (*probe)(proto))	\
 	{								\
-		return tracepoint_probe_register(#name, (void *)probe);	\
+		int ret;						\
+		void (*func)(void) = reg;				\
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
+		void (*func)(void) = unreg;				\
+									\
+		ret = tracepoint_probe_unregister(#name, (void *)probe);\
+		if (func && !ret)					\
+			func();						\
+		return ret;						\
 	}
 
+
+#define DECLARE_TRACE(name, proto, args)				 \
+	DECLARE_TRACE_WITH_CALLBACK(name, TP_PROTO(proto), TP_ARGS(args),\
+					NULL, NULL);
+
 #define DEFINE_TRACE(name)						\
 	static const char __tpstrtab_##name[]				\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
@@ -94,7 +113,7 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 	struct tracepoint *end);
 
 #else /* !CONFIG_TRACEPOINTS */
-#define DECLARE_TRACE(name, proto, args)				\
+#define DECLARE_TRACE_WITH_CALLBACK(name, proto, args, reg, unreg)	\
 	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
 	{ }								\
 	static inline void trace_##name(proto)				\
@@ -108,6 +127,10 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 		return -ENOSYS;						\
 	}
 
+#define DECLARE_TRACE(name, proto, args)				 \
+	DECLARE_TRACE_WITH_CALLBACK(name, TP_PROTO(proto), TP_ARGS(args),\
+					NULL, NULL);
+
 #define DEFINE_TRACE(name)
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
 #define EXPORT_TRACEPOINT_SYMBOL(name)
-- 
1.6.2.3

