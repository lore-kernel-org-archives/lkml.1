Return-Path: <linux-kernel-owner+w=401wt.eu-S1759789AbZDQGg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789AbZDQGg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbZDQGfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:35:46 -0400
Received: from gw.goop.org ([64.81.55.164]:36611 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751880AbZDQGfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:35:44 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: mathieu.desnoyers@polymtl.ca
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 2/4] x86/pvops: target CREATE_TRACE_POINTS to particular subsystems
Date: Thu, 16 Apr 2009 23:35:37 -0700
Message-Id: <1239950139-1119-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1239950139-1119-1-git-send-email-jeremy@goop.org>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Rather than having a single CREATE_TRACE_POINTS which indescriminately
creates tracepoints, use CREATE_FOO_TRACE_POINTS to make then for subsystem
foo.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/trace/events/irq.h                 |    5 +++++
 include/trace/events/kmem.h                |    5 +++++
 include/trace/events/lockdep.h             |    5 +++++
 include/trace/events/sched.h               |    5 +++++
 include/trace/events/skb.h                 |    6 ++++++
 include/trace/instantiate_trace.h          |    7 +++++++
 kernel/irq/handle.c                        |    2 +-
 kernel/lockdep.c                           |    2 +-
 kernel/sched.c                             |    2 +-
 mm/util.c                                  |    2 +-
 net/core/net-traces.c                      |    2 +-
 samples/trace_events/trace-events-sample.c |    2 +-
 samples/trace_events/trace-events-sample.h |    6 ++++++
 13 files changed, 45 insertions(+), 6 deletions(-)
 create mode 100644 include/trace/instantiate_trace.h

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 75e3468..ddc62f5 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -54,4 +54,9 @@ TRACE_FORMAT(softirq_exit,
 #endif /*  _TRACE_IRQ_H */
 
 /* This part must be outside protection */
+#ifdef CREATE_IRQ_TRACE_POINTS
+#undef CREATE_IRQ_TRACE_POINTS	/* avoid infinite recursion */
+#include <trace/instantiate_trace.h>
+#else
 #include <trace/define_trace.h>
+#endif
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index c22c42f..80c24b4 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -191,4 +191,9 @@ TRACE_EVENT(kmem_cache_free,
 #endif /* _TRACE_KMEM_H */
 
 /* This part must be outside protection */
+#ifdef CREATE_KMEM_TRACE_POINTS
+#undef CREATE_KMEM_TRACE_POINTS	/* avoid infinite recursion */
+#include <trace/instantiate_trace.h>
+#else
 #include <trace/define_trace.h>
+#endif
diff --git a/include/trace/events/lockdep.h b/include/trace/events/lockdep.h
index 45e326b..d5540c8 100644
--- a/include/trace/events/lockdep.h
+++ b/include/trace/events/lockdep.h
@@ -57,4 +57,9 @@ TRACE_EVENT(lock_acquired,
 #endif /* _TRACE_LOCKDEP_H */
 
 /* This part must be outside protection */
+#ifdef CREATE_LOCKDEP_TRACE_POINTS
+#undef CREATE_LOCKDEP_TRACE_POINTS	/* avoid infinite recursion */
+#include <trace/instantiate_trace.h>
+#else
 #include <trace/define_trace.h>
+#endif
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index ffa1cab..bacdc54 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -336,4 +336,9 @@ TRACE_EVENT(sched_signal_send,
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
+#ifdef CREATE_SCHED_TRACE_POINTS
+#undef CREATE_SCHED_TRACE_POINTS	/* avoid infinite recursion */
+#include <trace/instantiate_trace.h>
+#else
 #include <trace/define_trace.h>
+#endif
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 1e8fabb..d316de9 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -37,4 +37,10 @@ TRACE_EVENT(kfree_skb,
 #endif /* _TRACE_SKB_H */
 
 /* This part must be outside protection */
+#ifdef CREATE_SKB_TRACE_POINTS
+#undef CREATE_SKB_TRACE_POINTS	/* avoid infinite recursion */
+#include <trace/instantiate_trace.h>
+#else
 #include <trace/define_trace.h>
+#endif
+
diff --git a/include/trace/instantiate_trace.h b/include/trace/instantiate_trace.h
new file mode 100644
index 0000000..9ccda3e
--- /dev/null
+++ b/include/trace/instantiate_trace.h
@@ -0,0 +1,7 @@
+/* 
+ * trace/events/foo.h include this when their subsystem-specific
+ * CREATE_FOO_TRACE_POINTS is defined.
+ */
+#define CREATE_TRACE_POINTS
+#include <trace/define_trace.h>
+#undef CREATE_TRACE_POINTS
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 37c6363..264f478 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -19,7 +19,7 @@
 #include <linux/hash.h>
 #include <linux/bootmem.h>
 
-#define CREATE_TRACE_POINTS
+#define CREATE_IRQ_TRACE_POINTS
 #include <trace/events/irq.h>
 
 #include "internals.h"
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 47b201e..c2ddfb2 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -47,7 +47,7 @@
 
 #include "lockdep_internals.h"
 
-#define CREATE_TRACE_POINTS
+#define CREATE_LOCKDEP_TRACE_POINTS
 #include <trace/events/lockdep.h>
 
 #ifdef CONFIG_PROVE_LOCKING
diff --git a/kernel/sched.c b/kernel/sched.c
index 9f7ffd0..3093b44 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -78,7 +78,7 @@
 
 #include "sched_cpupri.h"
 
-#define CREATE_TRACE_POINTS
+#define CREATE_SCHED_TRACE_POINTS
 #include <trace/events/sched.h>
 
 /*
diff --git a/mm/util.c b/mm/util.c
index 6794a33..9bef53c 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -6,7 +6,7 @@
 #include <linux/sched.h>
 #include <asm/uaccess.h>
 
-#define CREATE_TRACE_POINTS
+#define CREATE_KMEM_TRACE_POINTS
 #include <trace/events/kmem.h>
 
 /**
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index 499a67e..df0b5fb 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -23,7 +23,7 @@
 #include <asm/unaligned.h>
 #include <asm/bitops.h>
 
-#define CREATE_TRACE_POINTS
+#define CREATE_SKB_TRACE_POINTS
 #include <trace/events/skb.h>
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kfree_skb);
diff --git a/samples/trace_events/trace-events-sample.c b/samples/trace_events/trace-events-sample.c
index f33b3ba..fe47b6d 100644
--- a/samples/trace_events/trace-events-sample.c
+++ b/samples/trace_events/trace-events-sample.c
@@ -7,7 +7,7 @@
  * CREATE_TRACE_POINTS first.  This will make the C code that
  * creates the handles for the trace points.
  */
-#define CREATE_TRACE_POINTS
+#define CREATE_SAMPLE_TRACE_POINTS
 #include "trace-events-sample.h"
 
 
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index eab4644..42be370 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -121,4 +121,10 @@ TRACE_EVENT(foo_bar,
  */
 #undef TRACE_INCLUDE_PATH
 #define TRACE_INCLUDE_PATH .
+
+#ifdef CREATE_SAMPLE_TRACE_POINTS
+#undef CREATE_SAMPLE_TRACE_POINTS	/* avoid infinite recursion */
+#include <trace/instantiate_trace.h>
+#else
 #include <trace/define_trace.h>
+#endif
-- 
1.6.0.6

