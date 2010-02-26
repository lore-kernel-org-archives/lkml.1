Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0BZFld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 00:41:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62902 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab0BZFl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 00:41:28 -0500
X-Authority-Analysis: v=1.0 c=1 a=t_VDih24ar0A:10 a=meVymXHHAAAA:8 a=4YaYhP3ASh5VgZbmWqkA:9 a=IYGL5M_rQQhh3baMUWsA:7 a=eoa8iferI_ANOiYSqcn6sng9KXcA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100226054125.508188403@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 26 Feb 2010 00:38:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Hellwig <hch@lst.de>, Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 2/2 v2] tracing: Add extract out softirq names used by irq trace events
References: <20100226053831.050130780@goodmis.org>
Content-Disposition: inline; filename=irq-events-v2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq trace events that map the softirq vectors to strings
shows up in the format files as names. To allow binary parsers to
be able to convert these names to their actual numbers, this patch
extracts those enums.

In doing this, we also change the way the softirq names are defined.
This gives us a tight coupling between the names and what is exported
as well as used by the __print_symbolic() macro.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

---
 include/linux/interrupt.h  |   29 ++++++++++++++++++-----------
 include/trace/events/irq.h |   22 ++++++++++------------
 2 files changed, 28 insertions(+), 23 deletions(-)

Index: linux-trace.git/include/trace/events/irq.h
===================================================================
--- linux-trace.git.orig/include/trace/events/irq.h	2010-02-25 21:47:57.000000000 -0500
+++ linux-trace.git/include/trace/events/irq.h	2010-02-25 23:06:16.000000000 -0500
@@ -7,19 +7,15 @@
 #include <linux/tracepoint.h>
 #include <linux/interrupt.h>
 
-#define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
+#define C(sirq) \
+	TRACE_SYMBOL_PARSE(#sirq, sirq##_SOFTIRQ, sizeof(sirq##_SOFTIRQ))
+
+EXTRACT_TRACE_SYMBOLS(softirqs, SOFTIRQ_NAMES);
+
+#undef C
+#define C(sirq) { sirq##_SOFTIRQ, #sirq }
 #define show_softirq_name(val)				\
-	__print_symbolic(val,				\
-			 softirq_name(HI),		\
-			 softirq_name(TIMER),		\
-			 softirq_name(NET_TX),		\
-			 softirq_name(NET_RX),		\
-			 softirq_name(BLOCK),		\
-			 softirq_name(BLOCK_IOPOLL),	\
-			 softirq_name(TASKLET),		\
-			 softirq_name(SCHED),		\
-			 softirq_name(HRTIMER),		\
-			 softirq_name(RCU))
+	__print_symbolic(val, SOFTIRQ_NAMES)
 
 /**
  * irq_handler_entry - called immediately before the irq action handler
@@ -136,6 +132,8 @@ DEFINE_EVENT(softirq, softirq_exit,
 	TP_ARGS(h, vec)
 );
 
+#undef C
+
 #endif /*  _TRACE_IRQ_H */
 
 /* This part must be outside protection */
Index: linux-trace.git/include/linux/interrupt.h
===================================================================
--- linux-trace.git.orig/include/linux/interrupt.h	2010-02-25 21:47:49.000000000 -0500
+++ linux-trace.git/include/linux/interrupt.h	2010-02-25 21:54:59.000000000 -0500
@@ -338,21 +338,28 @@ static inline int disable_irq_wake(unsig
    al. should be converted to tasklets, not to softirqs.
  */
 
+#define SOFTIRQ_NAMES						\
+	C(HI),							\
+	C(TIMER),						\
+	C(NET_TX),						\
+	C(NET_RX),						\
+	C(BLOCK),						\
+	C(BLOCK_IOPOLL),					\
+	C(TASKLET),						\
+	C(SCHED),						\
+	C(HRTIMER),						\
+	/* Preferable RCU should always be the last softirq */	\
+	C(RCU)
+
+#undef C
+#define C(name)	name##_SOFTIRQ
+
 enum
 {
-	HI_SOFTIRQ=0,
-	TIMER_SOFTIRQ,
-	NET_TX_SOFTIRQ,
-	NET_RX_SOFTIRQ,
-	BLOCK_SOFTIRQ,
-	BLOCK_IOPOLL_SOFTIRQ,
-	TASKLET_SOFTIRQ,
-	SCHED_SOFTIRQ,
-	HRTIMER_SOFTIRQ,
-	RCU_SOFTIRQ,	/* Preferable RCU should always be the last softirq */
-
+	SOFTIRQ_NAMES,
 	NR_SOFTIRQS
 };
+#undef C
 
 /* map softirq index to softirq name. update 'softirq_to_name' in
  * kernel/softirq.c when adding a new softirq.

