Return-Path: <linux-kernel-owner+w=401wt.eu-S1758999AbYJ3XbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbYJ3XbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbYJ3Xa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:30:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43683 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbYJ3Xa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:30:57 -0400
Date: Fri, 31 Oct 2008 00:30:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] tracing fix
Message-ID: <20081030233042.GA14498@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Steven Rostedt (1):
      ftrace: handle archs that do not support irqs_disabled_flags


 Documentation/ftrace.txt |    3 +++
 kernel/trace/trace.c     |    7 ++++++-
 kernel/trace/trace.h     |   20 +++++++++++---------
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index d330fe3..ea5a827 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -291,6 +291,9 @@ explains which is which.
   CPU#: The CPU which the process was running on.
 
   irqs-off: 'd' interrupts are disabled. '.' otherwise.
+	    Note: If the architecture does not support a way to
+		  read the irq flags variable, an 'X' will always
+		  be printed here.
 
   need-resched: 'N' task need_resched is set, '.' otherwise.
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a610ca7..8a499e2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -656,7 +656,11 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 	entry->preempt_count		= pc & 0xff;
 	entry->pid			= (tsk) ? tsk->pid : 0;
 	entry->flags =
+#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
+#else
+		TRACE_FLAG_IRQS_NOSUPPORT |
+#endif
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
 		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
@@ -1244,7 +1248,8 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 	trace_seq_printf(s, "%8.8s-%-5d ", comm, entry->pid);
 	trace_seq_printf(s, "%3d", cpu);
 	trace_seq_printf(s, "%c%c",
-			(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' : '.',
+			(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
+			 (entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ? 'X' : '.',
 			((entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.'));
 
 	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6889ca4..8465ad0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -120,18 +120,20 @@ struct trace_boot {
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
- *  IRQS_OFF	- interrupts were disabled
- *  NEED_RESCED - reschedule is requested
- *  HARDIRQ	- inside an interrupt handler
- *  SOFTIRQ	- inside a softirq handler
- *  CONT	- multiple entries hold the trace item
+ *  IRQS_OFF		- interrupts were disabled
+ *  IRQS_NOSUPPORT 	- arch does not support irqs_disabled_flags
+ *  NEED_RESCED		- reschedule is requested
+ *  HARDIRQ		- inside an interrupt handler
+ *  SOFTIRQ		- inside a softirq handler
+ *  CONT		- multiple entries hold the trace item
  */
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
-	TRACE_FLAG_NEED_RESCHED		= 0x02,
-	TRACE_FLAG_HARDIRQ		= 0x04,
-	TRACE_FLAG_SOFTIRQ		= 0x08,
-	TRACE_FLAG_CONT			= 0x10,
+	TRACE_FLAG_IRQS_NOSUPPORT	= 0x02,
+	TRACE_FLAG_NEED_RESCHED		= 0x04,
+	TRACE_FLAG_HARDIRQ		= 0x08,
+	TRACE_FLAG_SOFTIRQ		= 0x10,
+	TRACE_FLAG_CONT			= 0x20,
 };
 
 #define TRACE_BUF_SIZE		1024
