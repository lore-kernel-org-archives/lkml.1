Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbZEEGlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbZEEGlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZEEGkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:40:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63566 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754626AbZEEGkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:40:46 -0400
Message-ID: <49FFDF9C.7040505@cn.fujitsu.com>
Date: Tue, 05 May 2009 14:41:32 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, fweisbec@gmail.com,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, laijs@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v3] ftrace: add a tracepoint for __raise_softirq_irqoff()
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

Changelog for v1 -> v2: 
1: Use TRACE_EVENT instead of DEFINE_TRACE
2: Move the tracepoint from raise_softirq_irqoff() to
   __raise_softirq_irqoff()

Changelog for v2 -> v3: 
Move the definition of __raise_softifq_irqoff() to .c file when
CONFIG_TRACEPOINTS is enabled, to avoid recursive includes

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

---
 include/linux/interrupt.h  |    6 ++++++
 include/trace/events/irq.h |   18 ++++++++++++++++++
 kernel/softirq.c           |    8 ++++++++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index dd574d5..3143341 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -361,7 +361,13 @@ asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
 extern void open_softirq(int nr, void (*action)(struct softirq_action *));
 extern void softirq_init(void);
+
+#ifdef CONFIG_TRACEPOINTS
+extern void __raise_softirq_irqoff(unsigned int nr);
+#else
 #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
+#endif
+
 extern void raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
 extern void wakeup_softirqd(void);
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 32a9f7e..3c895bb 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -128,6 +128,24 @@ TRACE_EVENT(softirq_exit,
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
diff --git a/kernel/softirq.c b/kernel/softirq.c
index b41fb71..bd0546b 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -310,6 +310,14 @@ void irq_exit(void)
 	preempt_enable_no_resched();
 }
 
+#ifdef CONFIG_TRACEPOINTS
+inline void __raise_softirq_irqoff(unsigned int nr)
+{
+	trace_irq_softirq_raise(nr);
+	or_softirq_pending(1UL << (nr));
+}
+#endif
+
 /*
  * This function must run with irqs disabled!
  */
-- 
1.6.1.2

