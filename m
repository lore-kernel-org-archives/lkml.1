Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbZBFP2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbZBFP2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbZBFP1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:27:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44232 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbZBFP1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:27:22 -0500
Message-Id: <20090206152721.162909140@goodmis.org>
References: <20090206152151.962749733@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Feb 2009 10:21:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 4/7] nmi: add generic nmi tracking state
Content-Disposition: inline; filename=0004-nmi-add-generic-nmi-tracking-state.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This code adds an in_nmi() macro that uses the current tasks preempt count
to track when it is in NMI context. Other parts of the kernel can
use this to determine if the context is in NMI context or not.

This code was inspired by the -rt patch in_nmi version that was
written by Peter Zijlstra, who borrowed that code from
Mathieu Desnoyers.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/hardirq.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index f832883..f3cf86e 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -61,6 +61,12 @@
 #error PREEMPT_ACTIVE is too low!
 #endif
 
+#define NMI_OFFSET	(PREEMPT_ACTIVE << 1)
+
+#if NMI_OFFSET >= 0x80000000
+#error PREEMPT_ACTIVE too high!
+#endif
+
 #define hardirq_count()	(preempt_count() & HARDIRQ_MASK)
 #define softirq_count()	(preempt_count() & SOFTIRQ_MASK)
 #define irq_count()	(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK))
@@ -73,6 +79,11 @@
 #define in_softirq()		(softirq_count())
 #define in_interrupt()		(irq_count())
 
+/*
+ * Are we in NMI context?
+ */
+#define in_nmi()	(preempt_count() & NMI_OFFSET)
+
 #if defined(CONFIG_PREEMPT)
 # define PREEMPT_INATOMIC_BASE kernel_locked()
 # define PREEMPT_CHECK_OFFSET 1
@@ -167,6 +178,8 @@ extern void irq_exit(void);
 #define nmi_enter()				\
 	do {					\
 		ftrace_nmi_enter();		\
+		BUG_ON(in_nmi());		\
+		add_preempt_count(NMI_OFFSET);	\
 		lockdep_off();			\
 		rcu_nmi_enter();		\
 		__irq_enter();			\
@@ -177,6 +190,8 @@ extern void irq_exit(void);
 		__irq_exit();			\
 		rcu_nmi_exit();			\
 		lockdep_on();			\
+		BUG_ON(!in_nmi());		\
+		sub_preempt_count(NMI_OFFSET);	\
 		ftrace_nmi_exit();		\
 	} while (0)
 
-- 
1.5.6.5

-- 
