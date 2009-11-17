Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbZKQXlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbZKQXlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 18:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbZKQXlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 18:41:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344AbZKQXlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 18:41:15 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 3/3] tracepoint: Add signal loss events
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Tue, 17 Nov 2009 18:42:06 -0500
Message-ID: <20091117234206.30589.61346.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091117234117.30589.61311.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091117234117.30589.61311.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add signal_overflow_fail and signal_lose_info tracepoints
for signal-lost events.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Suggested-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 include/trace/events/signal.h |   71 +++++++++++++++++++++++++++++++++++++++++
 kernel/signal.c               |   19 ++++++++---
 2 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index 6dfd88d..eb57285 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -4,6 +4,7 @@
 #if !defined(_TRACE_SIGNAL_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_SIGNAL_H
 
+#include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/tracepoint.h>
 
@@ -56,6 +57,76 @@ TRACE_EVENT(signal_deliver,
 	TP_printk("sig=%d sa_handler=%lx sa_flags=%lx",
 		  __entry->sig, __entry->sa_handler, __entry->sa_flags)
 );
+
+/*
+ * Tracepoint for losing a signal by overflow:
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
+		if (info == SEND_SIG_NOINFO) {
+			__entry->errno	= 0;
+			__entry->code	= SI_USER;
+		} else if (info == SEND_SIG_PRIV) {
+			__entry->errno	= 0;
+			__entry->code	= SI_KERNEL;
+		} else {
+			__entry->errno	= info->si_errno;
+			__entry->code	= info->si_code;
+		}
+	),
+
+	TP_printk("sig=%d group=%d errno=%d code=%d",
+		  __entry->sig, __entry->group, __entry->errno, __entry->code)
+);
+
+/*
+ * Tracepoint for losing a siginfo:
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
+		if (info == SEND_SIG_NOINFO) {
+			__entry->errno	= 0;
+			__entry->code	= SI_USER;
+		} else if (info == SEND_SIG_PRIV) {
+			__entry->errno	= 0;
+			__entry->code	= SI_KERNEL;
+		} else {
+			__entry->errno	= info->si_errno;
+			__entry->code	= info->si_code;
+		}
+	),
+
+	TP_printk("sig=%d group=%d errno=%d code=%d",
+		  __entry->sig, __entry->group, __entry->errno, __entry->code)
+);
 #endif /* _TRACE_SIGNAL_H */
 
 /* This part must be outside protection */
diff --git a/kernel/signal.c b/kernel/signal.c
index 5615f41..65f67c5 100644
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
