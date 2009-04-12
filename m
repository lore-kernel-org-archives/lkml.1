Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbZDLJ27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbZDLJ27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 05:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759574AbZDLJ2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 05:28:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:55174 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759472AbZDLJ2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 05:28:36 -0400
Date: Sun, 12 Apr 2009 09:27:42 GMT
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, tzanussi@gmail.com, zhaolei@cn.fujitsu.com,
       davem@davemloft.net, fweisbec@gmail.com, nhorman@tuxdriver.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       zhaolei@cn.fujitsu.com, davem@davemloft.net, fweisbec@gmail.com,
       rostedt@goodmis.org, nhorman@tuxdriver.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49DD90D2.5020604@cn.fujitsu.com>
References: <49DD90D2.5020604@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing, net, skb tracepoint: make skb tracepoint use the TRACE_EVENT() macro
Message-ID: <tip-5cb3d1d9d34ac04bcaa2034139345b2a5fea54c1@git.kernel.org>
Git-Commit-ID: 5cb3d1d9d34ac04bcaa2034139345b2a5fea54c1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 09:27:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cb3d1d9d34ac04bcaa2034139345b2a5fea54c1
Gitweb:     http://git.kernel.org/tip/5cb3d1d9d34ac04bcaa2034139345b2a5fea54c1
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Thu, 9 Apr 2009 14:08:18 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 12:57:55 +0200

tracing, net, skb tracepoint: make skb tracepoint use the TRACE_EVENT() macro

TRACE_EVENT is a more generic way to define a tracepoint.
Doing so adds these new capabilities to this tracepoint:

  - zero-copy and per-cpu splice() tracing
  - binary tracing without printf overhead
  - structured logging records exposed under /debug/tracing/events
  - trace events embedded in function tracer output and other plugins
  - user-defined, per tracepoint filter expressions

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "Steven Rostedt ;" <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <49DD90D2.5020604@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/trace/skb.h               |    4 +--
 include/trace/skb_event_types.h   |   38 +++++++++++++++++++++++++++++++++++++
 include/trace/trace_event_types.h |    1 +
 include/trace/trace_events.h      |    1 +
 4 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/include/trace/skb.h b/include/trace/skb.h
index b66206d..d2de717 100644
--- a/include/trace/skb.h
+++ b/include/trace/skb.h
@@ -4,8 +4,6 @@
 #include <linux/skbuff.h>
 #include <linux/tracepoint.h>
 
-DECLARE_TRACE(kfree_skb,
-	TP_PROTO(struct sk_buff *skb, void *location),
-	TP_ARGS(skb, location));
+#include <trace/skb_event_types.h>
 
 #endif
diff --git a/include/trace/skb_event_types.h b/include/trace/skb_event_types.h
new file mode 100644
index 0000000..4a1c504
--- /dev/null
+++ b/include/trace/skb_event_types.h
@@ -0,0 +1,38 @@
+
+/* use <trace/skb.h> instead */
+#ifndef TRACE_EVENT
+# error Do not include this file directly.
+# error Unless you know what you are doing.
+#endif
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM skb
+
+/*
+ * Tracepoint for free an sk_buff:
+ */
+TRACE_EVENT(kfree_skb,
+
+	TP_PROTO(struct sk_buff *skb, void *location),
+
+	TP_ARGS(skb, location),
+
+	TP_STRUCT__entry(
+		__field(	void *,		skbaddr		)
+		__field(	unsigned short,	protocol	)
+		__field(	void *,		location	)
+	),
+
+	TP_fast_assign(
+		__entry->skbaddr = skb;
+		if (skb) {
+			__entry->protocol = ntohs(skb->protocol);
+		}
+		__entry->location = location;
+	),
+
+	TP_printk("skbaddr=%p protocol=%u location=%p",
+		__entry->skbaddr, __entry->protocol, __entry->location)
+);
+
+#undef TRACE_SYSTEM
diff --git a/include/trace/trace_event_types.h b/include/trace/trace_event_types.h
index df56f56..33b6bfc 100644
--- a/include/trace/trace_event_types.h
+++ b/include/trace/trace_event_types.h
@@ -3,3 +3,4 @@
 #include <trace/sched_event_types.h>
 #include <trace/irq_event_types.h>
 #include <trace/lockdep_event_types.h>
+#include <trace/skb_event_types.h>
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
index fd13750..0e2aa80 100644
--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -3,3 +3,4 @@
 #include <trace/sched.h>
 #include <trace/irq.h>
 #include <trace/lockdep.h>
+#include <trace/skb.h>
