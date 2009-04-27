Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbZD0Fyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbZD0Fyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 01:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbZD0Fyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 01:54:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57530 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbZD0Fyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 01:54:38 -0400
Message-ID: <49F548D0.9030500@cn.fujitsu.com>
Date: Mon, 27 Apr 2009 13:55:28 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, fweisbec@gmail.com,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, laijs@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, tzanussi@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH v2] ftrace: add a tracepoint for __raise_softirq_irqoff()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

This patch is modified from Mathieu Desnoyers' patch. The original patch
can be found here: 
	http://marc.info/?l=linux-kernel&m=123791201816245&w=2
This tracepoint can trace the time stamp when softirq action is raised. 

Change log for v1 -> v2: 
1: Use TRACE_EVENT instead of DEFINE_TRACE
2: Move the tracepoint from raise_softirq_irqoff() to __raise_softirq_irqoff()

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

---
 include/linux/interrupt.h  |    9 ++++++++-
 include/trace/events/irq.h |   18 ++++++++++++++++++
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 912c52c..86bae89 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -361,7 +361,14 @@ asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
 extern void open_softirq(int nr, void (*action)(struct softirq_action *));
 extern void softirq_init(void);
-#define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
+
+#include <trace/events/irq.h>
+static inline void __raise_softirq_irqoff(unsigned int nr)
+{
+	trace_irq_softirq_raise(nr);
+	or_softirq_pending(1UL << nr);
+}
+
 extern void raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
 extern void wakeup_softirqd(void);
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 7686864..2628e08 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -90,6 +90,24 @@ TRACE_EVENT(softirq_exit,
 	TP_printk("softirq=%d action=%s", __entry->vec, __get_str(name))
 );
 
+TRACE_EVENT(irq_softirq_raise,
+
+	TP_PROTO(unsigned int nr),
+
+	TP_ARGS(nr),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	nr	)
+	),
+
+	TP_fast_assign(
+		__entry->nr	= nr;
+	),
+
+	TP_printk("softirq=%d action=%s is raised",
+		__entry->nr, softirq_to_name[__entry->nr])
+);
+
 #endif /*  _TRACE_IRQ_H */
 
 /* This part must be outside protection */
-- 
1.6.1.2

