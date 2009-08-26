Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbZHZFBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbZHZFBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642AbZHZFA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:00:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58597 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374AbZHZFAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:00:52 -0400
Message-Id: <20090826050052.486178528@goodmis.org>
References: <20090826045945.201094161@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 26 Aug 2009 00:59:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 7/8] tracing/events: fix the include file dependencies
Content-Disposition: inline; filename=0007-tracing-events-fix-the-include-file-dependencies.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

The TRACE_EVENT depends on the include/linux/tracepoint.h first
and include/trace/ftrace.h later, if we include the ftrace.h early,
a building error will occur.

Both define TRACE_EVENT in trace_a.h and trace_b.h, if we include
those in .c file, like this:

#define CREATE_TRACE_POINTS
include <trace/events/trace_a.h>
include <trace/events/trace_b.h>

The above will not work, because the TRACE_EVENT was re-defined by
the previous .h file.

Reported-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
LKML-Reference: <4A937F5E.3020802@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h   |    3 +--
 include/trace/define_trace.h |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 5984ed0..8170985 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -180,6 +180,7 @@ static inline void tracepoint_synchronize_unregister(void)
 }
 
 #define PARAMS(args...) args
+#endif
 
 #ifndef TRACE_EVENT
 /*
@@ -287,5 +288,3 @@ static inline void tracepoint_synchronize_unregister(void)
 #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #endif
-
-#endif
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index f7a7ae1..cd150b9 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -56,6 +56,7 @@
 #include <trace/ftrace.h>
 #endif
 
+#undef TRACE_EVENT
 #undef TRACE_HEADER_MULTI_READ
 
 /* Only undef what we defined in this file */
-- 
1.6.3.3

-- 
