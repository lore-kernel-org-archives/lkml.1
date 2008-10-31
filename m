Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbYJaERT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbYJaERT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 00:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYJaERA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 00:17:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37985 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYJaERA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 00:17:00 -0400
Date: Fri, 31 Oct 2008 00:16:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: [PATCH] hardirq.h clean up
In-Reply-To: <alpine.DEB.1.10.0810310002320.28140@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0810310016230.28140@gandalf.stny.rr.com>
References: <20081030200831.467420488@goodmis.org> <20081030201127.820600693@goodmis.org> <20081030133228.824e3f69.akpm@linux-foundation.org> <alpine.DEB.1.10.0810301645100.21031@gandalf.stny.rr.com> <20081030141048.904c82e1.akpm@linux-foundation.org>
 <alpine.DEB.1.10.0810310002320.28140@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch converts the CPP macros of __irq_enter, __irq_exit,
nmi_enter, and nmi_exit into static inlines.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/hardirq.h |   53 ++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

Index: linux-tip.git/include/linux/hardirq.h
===================================================================
--- linux-tip.git.orig/include/linux/hardirq.h	2008-10-30 10:27:09.000000000 -0400
+++ linux-tip.git/include/linux/hardirq.h	2008-10-31 00:07:46.000000000 -0400
@@ -133,13 +133,13 @@ extern void rcu_irq_exit(void);
  * always balanced, so the interrupted value of ->hardirq_context
  * will always be restored.
  */
-#define __irq_enter()					\
-	do {						\
-		rcu_irq_enter();			\
-		account_system_vtime(current);		\
-		add_preempt_count(HARDIRQ_OFFSET);	\
-		trace_hardirq_enter();			\
-	} while (0)
+static inline void __irq_enter(void)
+{
+	rcu_irq_enter();
+	account_system_vtime(current);
+	add_preempt_count(HARDIRQ_OFFSET);
+	trace_hardirq_enter();
+}
 
 /*
  * Enter irq context (on NO_HZ, update jiffies):
@@ -149,30 +149,31 @@ extern void irq_enter(void);
 /*
  * Exit irq context without processing softirqs:
  */
-#define __irq_exit()					\
-	do {						\
-		trace_hardirq_exit();			\
-		account_system_vtime(current);		\
-		sub_preempt_count(HARDIRQ_OFFSET);	\
-		rcu_irq_exit();				\
-	} while (0)
+static inline void __irq_exit(void)
+{
+	trace_hardirq_exit();
+	account_system_vtime(current);
+	sub_preempt_count(HARDIRQ_OFFSET);
+	rcu_irq_exit();
+}
 
 /*
  * Exit irq context and process softirqs if needed:
  */
 extern void irq_exit(void);
 
-#define nmi_enter()				\
-	do {					\
-		ftrace_nmi_enter();		\
-		lockdep_off();			\
-		__irq_enter();			\
-	} while (0)
-#define nmi_exit()				\
-	do {					\
-		__irq_exit();			\
-		lockdep_on();			\
-		ftrace_nmi_exit();		\
-	} while (0)
+static inline void nmi_enter(void)
+{
+	ftrace_nmi_enter();
+	lockdep_off();
+	__irq_enter();
+}
+
+static inline void nmi_exit(void)
+{
+	__irq_exit();
+	lockdep_on();
+	ftrace_nmi_exit();
+}
 
 #endif /* LINUX_HARDIRQ_H */


