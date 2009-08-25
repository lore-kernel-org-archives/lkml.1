Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbZHYGGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbZHYGGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZHYGGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:06:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56712 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbZHYGGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:06:52 -0400
Message-ID: <4A937F5E.3020802@cn.fujitsu.com>
Date: Tue, 25 Aug 2009 14:06:22 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Neil Horman <nhorman@tuxdriver.com>, Wei Yongjun <yjwei@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] trace_events: fix the include file dependencies
References: <4A937EF5.4040505@cn.fujitsu.com>
In-Reply-To: <4A937EF5.4040505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TRACE_EVENT depend on the include/linux/tracepoint.h first
and include/trace/ftrace.h later, if we include the ftrace.h early,
It'll occur building error, like blow:

Both define TRACE_EVENT in trace_a.h and trace_b.h, if we include
those in .c file, like this:

#define CREATE_TRACE_POINTS
include <trace/events/trace_a.h>
include <trace/events/trace_b.h>

There are can't work,  because the TRACE_EVENT has re-defined by
the previous .h file

Reported-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
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
index 76e93bf..202cecd 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -52,6 +52,7 @@
 #include <trace/ftrace.h>
 #endif
 
+#undef TRACE_EVENT
 #undef TRACE_HEADER_MULTI_READ
 
 /* Only undef what we defined in this file */
-- 
1.6.1.2


