Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbZKZK1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbZKZK1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 05:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759679AbZKZK1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 05:27:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:48415 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760263AbZKZK13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 05:27:29 -0500
Date: Thu, 26 Nov 2009 10:25:07 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       roland@redhat.com, dle-develop@lists.sourceforge.net, oleg@redhat.com,
       tglx@linutronix.de, jbaron@redhat.com, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, dle-develop@lists.sourceforge.net, oleg@redhat.com,
       tglx@linutronix.de, jbaron@redhat.com, mhiramat@redhat.com,
       systemtap@sources.redhat.com, mingo@elte.hu
In-Reply-To: <20091124215658.30449.9934.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091124215658.30449.9934.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracepoint: Add signal loss events
Message-ID: <tip-ba005e1f417295d28cd1563ab82bc33af07fb16a@git.kernel.org>
Git-Commit-ID: ba005e1f417295d28cd1563ab82bc33af07fb16a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba005e1f417295d28cd1563ab82bc33af07fb16a
Gitweb:     http://git.kernel.org/tip/ba005e1f417295d28cd1563ab82bc33af07fb16a
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 24 Nov 2009 16:56:58 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 10:55:38 +0100

tracepoint: Add signal loss events

Add signal_overflow_fail and signal_lose_info tracepoints
for signal-lost events.

Changes in v3:
 - Add docbook style comments

Changes in v2:
 - Use siginfo string macro

Suggested-by: Roland McGrath <roland@redhat.com>
Reviewed-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Oleg Nesterov <oleg@redhat.com>
LKML-Reference: <20091124215658.30449.9934.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/signal.h |   68 +++++++++++++++++++++++++++++++++++++++++
 kernel/signal.c               |   19 ++++++++---
 2 files changed, 82 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index a6d71de..a510b75 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -99,6 +99,74 @@ TRACE_EVENT(signal_deliver,
 		  __entry->sig, __entry->errno, __entry->code,
 		  __entry->sa_handler, __entry->sa_flags)
 );
+
+/**
+ * signal_overflow_fail - called when signal queue is overflow
+ * @sig: signal number
+ * @group: signal to process group or not (bool)
+ * @info: pointer to struct siginfo
+ *
+ * Kernel fails to generate 'sig' signal with 'info' siginfo, because
+ * siginfo queue is overflow, and the signal is dropped.
+ * 'group' is not 0 if the signal will be sent to a process group.
+ * 'sig' is always one of RT signals.
+ */
+TRACE_EVENT(signal_overflow_fail,
+
+	TP_PROTO(int sig, int group, struct siginfo *info),
+
+	TP_ARGS(sig, group, info),
+
+	TP_STRUCT__entry(
+		__field(	int,	sig	)
+		__field(	int,	group	)
+		__field(	int,	errno	)
+		__field(	int,	code	)
+	),
+
+	TP_fast_assign(
+		__entry->sig	= sig;
+		__entry->group	= group;
+		TP_STORE_SIGINFO(__entry, info);
+	),
+
+	TP_printk("sig=%d group=%d errno=%d code=%d",
+		  __entry->sig, __entry->group, __entry->errno, __entry->code)
+);
+
+/**
+ * signal_lose_info - called when siginfo is lost
+ * @sig: signal number
+ * @group: signal to process group or not (bool)
+ * @info: pointer to struct siginfo
+ *
+ * Kernel generates 'sig' signal but loses 'info' siginfo, because siginfo
+ * queue is overflow.
+ * 'group' is not 0 if the signal will be sent to a process group.
+ * 'sig' is always one of non-RT signals.
+ */
+TRACE_EVENT(signal_lose_info,
+
+	TP_PROTO(int sig, int group, struct siginfo *info),
+
+	TP_ARGS(sig, group, info),
+
+	TP_STRUCT__entry(
+		__field(	int,	sig	)
+		__field(	int,	group	)
+		__field(	int,	errno	)
+		__field(	int,	code	)
+	),
+
+	TP_fast_assign(
+		__entry->sig	= sig;
+		__entry->group	= group;
+		TP_STORE_SIGINFO(__entry, info);
+	),
+
+	TP_printk("sig=%d group=%d errno=%d code=%d",
+		  __entry->sig, __entry->group, __entry->errno, __entry->code)
+);
 #endif /* _TRACE_SIGNAL_H */
 
 /* This part must be outside protection */
diff --git a/kernel/signal.c b/kernel/signal.c
index 349d449..93e72e5 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -897,12 +897,21 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			break;
 		}
 	} else if (!is_si_special(info)) {
-		if (sig >= SIGRTMIN && info->si_code != SI_USER)
-		/*
-		 * Queue overflow, abort.  We may abort if the signal was rt
-		 * and sent by user using something other than kill().
-		 */
+		if (sig >= SIGRTMIN && info->si_code != SI_USER) {
+			/*
+			 * Queue overflow, abort.  We may abort if the
+			 * signal was rt and sent by user using something
+			 * other than kill().
+			 */
+			trace_signal_overflow_fail(sig, group, info);
 			return -EAGAIN;
+		} else {
+			/*
+			 * This is a silent loss of information.  We still
+			 * send the signal, but the *info bits are lost.
+			 */
+			trace_signal_lose_info(sig, group, info);
+		}
 	}
 
 out_set:
