Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbYJXNna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbYJXNna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 09:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbYJXNnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 09:43:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56846 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbYJXNnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:43:01 -0400
Date: Fri, 24 Oct 2008 09:42:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ftrace: handle archs that do not support
 irqs_disabled_flags
In-Reply-To: <4901D8CD.7000405@gmail.com>
Message-ID: <alpine.DEB.1.10.0810240937130.3882@gandalf.stny.rr.com>
References: <20081023213637.eff9b414.sfr@canb.auug.org.au> <20081023121145.GB27984@x200.localdomain> <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com> <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com> <49008D12.5090204@gmail.com>
 <Pine.LNX.4.64.0810231635440.18978@anakin> <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com> <Pine.LNX.4.64.0810231727430.18978@anakin> <4900B414.7090002@gmail.com> <20081023163433.GA3160@x200.localdomain> <20081023163850.GB16591@elte.hu>
 <4901D8CD.7000405@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some architectures do not support a way to read the irq flags that
is set from "local_irq_save(flags)" to determine if interrupts were
disabled or enabled. Ftrace uses this information to display to the user
if the trace occurred with interrupts enabled or disabled.

Besides the fact that those archs that do not support this will fail to
compile, unless they fix it, we do not want to have the trace simply
say interrupts were not disabled or they were enabled, without knowing
the real answer.

This patch adds a 'X' in the output to let the user know that the
architecture they are running on does not support a way for the tracer
to determine if interrupts were enabled or disabled. It also lets those
same archs compile with tracing enabled.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 Documentation/ftrace.txt |    3 +++
 kernel/trace/trace.c     |    7 ++++++-
 kernel/trace/trace.h     |   20 +++++++++++---------
 3 files changed, 20 insertions(+), 10 deletions(-)

Index: linux-tip.git/Documentation/ftrace.txt
===================================================================
--- linux-tip.git.orig/Documentation/ftrace.txt	2008-10-23 19:23:26.000000000 -0400
+++ linux-tip.git/Documentation/ftrace.txt	2008-10-24 09:32:42.000000000 -0400
@@ -291,6 +291,9 @@ explains which is which.
   CPU#: The CPU which the process was running on.
 
   irqs-off: 'd' interrupts are disabled. '.' otherwise.
+	    Note: If the architecture does not support a way to
+		  read the irq flags variable, an 'X' will always
+		  be printed here.
 
   need-resched: 'N' task need_resched is set, '.' otherwise.
 
Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-10-23 19:24:15.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-10-24 09:31:17.000000000 -0400
@@ -677,7 +677,11 @@ tracing_generic_entry_update(struct trac
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
@@ -1265,7 +1269,8 @@ lat_print_generic(struct trace_seq *s, s
 	trace_seq_printf(s, "%8.8s-%-5d ", comm, entry->pid);
 	trace_seq_printf(s, "%3d", cpu);
 	trace_seq_printf(s, "%c%c",
-			(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' : '.',
+			(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
+			 (entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ? 'X' : '.',
 			((entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.'));
 
 	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
Index: linux-tip.git/kernel/trace/trace.h
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.h	2008-10-23 12:55:37.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.h	2008-10-24 09:27:10.000000000 -0400
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


