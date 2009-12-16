Return-Path: <linux-kernel-owner+w=401wt.eu-S934893AbZLPQFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934893AbZLPQFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:05:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934515AbZLPQFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:05:01 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42721 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507AbZLPQE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:04:59 -0500
Date: Wed, 16 Dec 2009 11:04:52 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Fix tracing infrastructure to support multiple
	includes when defining CREATE_TRACE_POINTS
Message-ID: <20091216160452.GC29609@hmsreliant.think-freely.org>
References: <20091203193549.GA18664@hmsreliant.think-freely.org> <1260216282.4845.3.camel@gandalf.stny.rr.com> <20091207201829.GG8073@hmsreliant.think-freely.org> <1260218831.3518.3.camel@gandalf.stny.rr.com> <1260218966.3518.4.camel@gandalf.stny.rr.com> <20091207205341.GH8073@hmsreliant.think-freely.org> <20091214195058.GB31323@hmsreliant.think-freely.org> <20091215160852.GA18710@hmsreliant.think-freely.org> <1260936829.2146.447.camel@gandalf.stny.rr.com> <20091216114903.GA29609@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216114903.GA29609@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -3.8 (---)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven-
	Here you go, new version of the patch, with the napi trace event fixed
up so that we don't errneously access a net_device we don't hold a ref on.  I've
tested it here and its working well

Regards
Neil


Fix tracing infrastructure to allow multiple header files with TRACE_EVENTS to
be included with CREATE_TRACE_EVENTS defined

I've been workingon adding a few tracepoints to the network stack, and in so
doing it was convienient for me to add a second include file to
net/core/net-traces.c with TRACE_EVENTS defined in them.  net-traces.c defines
CREATE_TRACE_EVENTS, and during the build it was failing, complaining about
duplicate definitions of __tpstrtab_<name>.  I tracked down the bug to find that
define_trace.h redefined DECLARE_TRACE to be DEFINE_TRACE, so after the first
run through define_trace.h (which is included from skb.h, included in
net-trace.c first), the DECLARE_TRACE macro was left with an improper definition
to start a new cycle with the next header.

The fix I came up with was to make sure that DECLARE_TRACE was undefined at the
end of define_trace.h, and to add a conditional re-definition in tracepoint.h.
This places us back in the proper state to define a new set of tracepoints in a
subsequent header file.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index f59604e..f350688 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -58,28 +58,6 @@ struct tracepoint {
 		rcu_read_unlock_sched_notrace();			\
 	} while (0)
 
-/*
- * Make sure the alignment of the structure in the __tracepoints section will
- * not add unwanted padding between the beginning of the section and the
- * structure. Force alignment to the same alignment as the section start.
- */
-#define DECLARE_TRACE(name, proto, args)				\
-	extern struct tracepoint __tracepoint_##name;			\
-	static inline void trace_##name(proto)				\
-	{								\
-		if (unlikely(__tracepoint_##name.state))		\
-			__DO_TRACE(&__tracepoint_##name,		\
-				TP_PROTO(proto), TP_ARGS(args));	\
-	}								\
-	static inline int register_trace_##name(void (*probe)(proto))	\
-	{								\
-		return tracepoint_probe_register(#name, (void *)probe);	\
-	}								\
-	static inline int unregister_trace_##name(void (*probe)(proto))	\
-	{								\
-		return tracepoint_probe_unregister(#name, (void *)probe);\
-	}
-
 
 #define DEFINE_TRACE_FN(name, reg, unreg)				\
 	static const char __tpstrtab_##name[]				\
@@ -173,6 +151,29 @@ static inline void tracepoint_synchronize_unregister(void)
  *  trace event headers under one "CREATE_TRACE_POINTS" the first include
  *  will override the TRACE_EVENT and break the second include.
  */
+#if defined(CONFIG_TRACEPOINTS) && !defined(DECLARE_TRACE)
+/*
+ * Make sure the alignment of the structure in the __tracepoints section will
+ * not add unwanted padding between the beginning of the section and the
+ * structure. Force alignment to the same alignment as the section start.
+ */
+#define DECLARE_TRACE(name, proto, args)                                \
+	extern struct tracepoint __tracepoint_##name;                   \
+	static inline void trace_##name(proto)                          \
+	{                                                               \
+		if (unlikely(__tracepoint_##name.state))                \
+			__DO_TRACE(&__tracepoint_##name,                \
+				TP_PROTO(proto), TP_ARGS(args));        \
+	}                                                               \
+	static inline int register_trace_##name(void (*probe)(proto))   \
+	{                                                               \
+		return tracepoint_probe_register(#name, (void *)probe); \
+	}                                                               \
+	static inline int unregister_trace_##name(void (*probe)(proto)) \
+	{                                                               \
+		return tracepoint_probe_unregister(#name, (void *)probe);\
+	}
+#endif
 
 #ifndef TRACE_EVENT
 /*
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 5acfb1e..3e8cf03 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -75,6 +75,7 @@
 #undef DEFINE_EVENT
 #undef DEFINE_EVENT_PRINT
 #undef TRACE_HEADER_MULTI_READ
+#undef DECLARE_TRACE
 
 /* Only undef what we defined in this file */
 #ifdef UNDEF_TRACE_INCLUDE_FILE
diff --git a/include/trace/events/napi.h b/include/trace/events/napi.h
index a8989c4..6afe7a8 100644
--- a/include/trace/events/napi.h
+++ b/include/trace/events/napi.h
@@ -1,11 +1,33 @@
-#ifndef _TRACE_NAPI_H_
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM napi
+
+#if !defined(_TRACE_NAPI_H_) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_NAPI_H_
 
 #include <linux/netdevice.h>
 #include <linux/tracepoint.h>
+#include <linux/ftrace.h>
+
+TRACE_EVENT(napi_poll,
 
-DECLARE_TRACE(napi_poll,
 	TP_PROTO(struct napi_struct *napi),
-	TP_ARGS(napi));
+
+	TP_ARGS(napi),
+
+	TP_STRUCT__entry(
+		__field(        struct napi_struct *,	napi)
+		__string(	dev_name, napi->dev->name)
+        ),
+
+        TP_fast_assign(
+                __entry->napi = napi;
+		__assign_str(dev_name, napi->dev->name);
+        ),
+
+        TP_printk("napi poll on napi struct %p for device %s",
+		__entry->napi, __get_str(dev_name))
+);
 
 #endif
+
+#include <trace/define_trace.h>
