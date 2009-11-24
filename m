Return-Path: <linux-kernel-owner+w=401wt.eu-S934335AbZKXVyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934335AbZKXVyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934326AbZKXVyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:54:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934323AbZKXVyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:54:20 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v4 3/3] tracepoint: Add signal loss events
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Jason Baron <jbaron@redhat.com>, Roland McGrath <roland@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Tue, 24 Nov 2009 16:56:58 -0500
Message-ID: <20091124215658.30449.9934.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091124215638.30449.3838.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091124215638.30449.3838.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add signal_overflow_fail and signal_lose_info tracepoints
for signal-lost events.

Changes in v3:
 - Add docbook style comments

Changes in v2:
 - Use siginfo string macro

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Suggested-by: Roland McGrath <roland@redhat.com>
Reviewed-by: Jason Baron <jbaron@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
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
index d518984..6b982f2 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -919,12 +919,21 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
