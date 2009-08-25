Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZHYGtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZHYGtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbZHYGte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:49:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50371 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbZHYGte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:49:34 -0400
Message-ID: <4A93895F.4010708@cn.fujitsu.com>
Date: Tue, 25 Aug 2009 14:49:03 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Neil Horman <nhorman@tuxdriver.com>, Wei Yongjun <yjwei@cn.fujitsu.com>,
       David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] trace_events: fix napi's tracepoint
References: <4A937EF5.4040505@cn.fujitsu.com>
In-Reply-To: <4A937EF5.4040505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the napi's tracepoint works will is depend on
"DECLARE_TRACE" definiens in include/trace/define_trace.h,
like below:

#include <trace/events/skb.h>    // include define_trace.h
#include <trace/events/napi.h>

there have error, if we remove "#include <trace/events/skb.h>"
or include napi.h in the front of include skb.h, It should
depend on the definiens in include/linux/tracepoint.h and we
can remove the "DECLARE_TRACE" definiens in
include/trace/define_trace.h, because "TRACE_EVENT" not use it

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/define_trace.h |    4 ----
 net/core/net-traces.c        |    4 +++-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index f7a7ae1..76e93bf 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -26,10 +26,6 @@
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
 	DEFINE_TRACE(name)
 
-#undef DECLARE_TRACE
-#define DECLARE_TRACE(name, proto, args)	\
-	DEFINE_TRACE(name)
-
 #undef TRACE_INCLUDE
 #undef __TRACE_INCLUDE
 
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index f1e982c..42bda72 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -19,13 +19,15 @@
 #include <linux/workqueue.h>
 #include <linux/netlink.h>
 #include <linux/net_dropmon.h>
+#include <linux/tracepoint.h>
 
 #include <asm/unaligned.h>
 #include <asm/bitops.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/skb.h>
-#include <trace/events/napi.h>
+
+DEFINE_TRACE(napi_poll);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kfree_skb);
 
-- 
1.6.1.2


