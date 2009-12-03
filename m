Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbZLCTfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbZLCTfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbZLCTfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:35:48 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38584 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZLCTfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:35:47 -0500
Date: Thu, 3 Dec 2009 14:35:49 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [PATCH] Fix tracing infrastructure to support multiple
	includes when defining CREATE_TRACE_POINTS
Message-ID: <20091203193549.GA18664@hmsreliant.think-freely.org>
References: <20091202191916.GA7589@hmsreliant.think-freely.org> <1259849726.12870.123.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259849726.12870.123.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 09:15:26AM -0500, Steven Rostedt wrote:
> On Wed, 2009-12-02 at 14:19 -0500, Neil Horman wrote:
> > Fix tracing infrastructure to allow multiple header files with TRACE_EVENTS to
> > be included with CREATE_TRACE_EVENTS defined
> > 
> > I've been workingon adding a few tracepoints to the network stack, and in so
> > doing it was convienient for me to add a second include file to
> > net/core/net-traces.c with TRACE_EVENTS defined in them.  net-traces.c defines
> > CREATE_TRACE_EVENTS, and during the build it was failing, complaining about
> > duplicate definitions of __tpstrtab_<name>.  I tracked down the bug to find that
> > define_trace.h redefined DECLARE_TRACE to be DEFINE_TRACE, so after the first
> > run through define_trace.h (which is included from skb.h, included in
> > net-trace.c first), the DECLARE_TRACE macro was left with an improper definition
> > to start a new cycle with the next header.
> > 
> > The fix I came up with was to make sure that DECLARE_TRACE was undefined at the
> > end of define_trace.h, and to add a conditional re-definition in tracepoint.h.
> > This places us back in the proper state to define a new set of tracepoints in a
> > subsequent header file.  Not sure if theres a better way to handle this, but
> > this worked well for me, allowing me to include multiple headers with
> > TRACE_EVENT macros in a c file with CREATE_TRACE_POINTS defined.
> > 
> 
> Nice, just some comments below.
><snip> 
> 
> You duplicate the DECLARE_TRACE from above and place it into an
> unprotected area. Why not move it instead of duplicating it. This is
> just a bug waiting to happen if we ever need to modify DECLARE_TRACE.
> 
> If you change it to:
> 
> #if !defined(CONFIG_TRACEPOINTS) && !defined(DECLARE_TRACE)
> 
> #define DECLARE_TRACE(...) ....
> 
> #endif
> 
> Then you can remove the first definition of it. The first time
> processing the file, when it hits the #ifndef DECLARE_TRACE in the
> _LINUX_TRACEPOINT_H conditional, it still does not define DECLARE_TRACE,
> and then when it exits that conditional, it does.


Yeah, that makes sense to me.  Although I think you mean if
defined(CONFIG_TRACEPOINTS) rather than if !defined(CONFIG_TRACEPOINTS).  The
case I'm moving to outside the unprotected area is the one that we use if
tracepoints are enabled.  I just tested this new patch, and it works well for
me.  Thanks!

Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 linux/tracepoint.h   |   45 +++++++++++++++++++++++----------------------
 trace/define_trace.h |    1 +
 2 files changed, 24 insertions(+), 22 deletions(-)


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

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 2aac8a8..311abbf 100644
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
index 2a4b3bf..a3e0095 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -64,6 +64,7 @@
 #undef TRACE_EVENT
 #undef TRACE_EVENT_FN
 #undef TRACE_HEADER_MULTI_READ
+#undef DECLARE_TRACE
 
 /* Only undef what we defined in this file */
 #ifdef UNDEF_TRACE_INCLUDE_FILE
