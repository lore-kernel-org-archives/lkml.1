Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbZFAIvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbZFAIvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbZFAIvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:51:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49241 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbZFAIvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:51:06 -0400
Message-ID: <4A2396C7.3000700@cn.fujitsu.com>
Date: Mon, 01 Jun 2009 16:52:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/irq: use softirq_to_name instead of __print_symbolic
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| commit c2adae0970ca1db8adb92fb56ae3bcabd916e8bd
| Author: Steven Rostedt <srostedt@redhat.com>
| Date:   Wed May 20 19:56:19 2009 -0400
|
|    tracing: convert irq events to use __print_symbolic
|
|    The recording of the names at trace time is inefficient. This patch
|    implements the softirq event recording to only record the vector
|    and then use the __print_symbolic interface to print out the names.
|
|    [ Impact: faster recording of softirq events ]

It's great to boost recording of softirq events, but why not simply
use softirq_to_name in TP_printk()?

The above commit has 2 flaws:

  - we waste memory defining local static struct trace_print_flags array
    in each softirq TRACE_EVENT
  - if someone adds/removes a softirq, he may not know show_softirq_name()
    needs to be updated

Another issue with the above commit, that the output of softirq events
becomes:

  X-1701  [000]  1595.220739: softirq_entry: softirq=1 action=TIMER_SOFTIRQ

Compared to the original output:

  X-1701  [000]  1595.220739: softirq_entry: softirq=1 action=TIMER

[ Impact: reserve the original output format of softirq events ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/events/irq.h |   17 ++---------------
 1 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 683fb36..2ff9998 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -7,19 +7,6 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM irq
 
-#define softirq_name(sirq) { sirq, #sirq }
-#define show_softirq_name(val)						\
-	__print_symbolic(val,						\
-			 softirq_name(HI_SOFTIRQ),			\
-			 softirq_name(TIMER_SOFTIRQ),			\
-			 softirq_name(NET_TX_SOFTIRQ),			\
-			 softirq_name(NET_RX_SOFTIRQ),			\
-			 softirq_name(BLOCK_SOFTIRQ),			\
-			 softirq_name(TASKLET_SOFTIRQ),			\
-			 softirq_name(SCHED_SOFTIRQ),			\
-			 softirq_name(HRTIMER_SOFTIRQ),			\
-			 softirq_name(RCU_SOFTIRQ))
-
 /**
  * irq_handler_entry - called immediately before the irq action handler
  * @irq: irq number
@@ -107,7 +94,7 @@ TRACE_EVENT(softirq_entry,
 	),
 
 	TP_printk("softirq=%d action=%s", __entry->vec,
-		  show_softirq_name(__entry->vec))
+		  softirq_to_name[__entry->vec])
 );
 
 /**
@@ -136,7 +123,7 @@ TRACE_EVENT(softirq_exit,
 	),
 
 	TP_printk("softirq=%d action=%s", __entry->vec,
-		  show_softirq_name(__entry->vec))
+		  softirq_to_name[__entry->vec])
 );
 
 #endif /*  _TRACE_IRQ_H */
-- 
1.5.4.rc3

