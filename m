Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbZKZK1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbZKZK1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 05:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760252AbZKZK1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 05:27:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:48412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760253AbZKZK1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 05:27:21 -0500
Date: Thu, 26 Nov 2009 10:24:52 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       roland@redhat.com, dle-develop@lists.sourceforge.net, oleg@redhat.com,
       tglx@linutronix.de, jbaron@redhat.com, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, dle-develop@lists.sourceforge.net, oleg@redhat.com,
       tglx@linutronix.de, jbaron@redhat.com, mhiramat@redhat.com,
       systemtap@sources.redhat.com, mingo@elte.hu
In-Reply-To: <20091124215651.30449.20926.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091124215651.30449.20926.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracepoint: Add signal deliver event
Message-ID: <tip-f9d4257e01d266e67420cc99d456b6d4c8464f54@git.kernel.org>
Git-Commit-ID: f9d4257e01d266e67420cc99d456b6d4c8464f54
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9d4257e01d266e67420cc99d456b6d4c8464f54
Gitweb:     http://git.kernel.org/tip/f9d4257e01d266e67420cc99d456b6d4c8464f54
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 24 Nov 2009 16:56:51 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 10:55:38 +0100

tracepoint: Add signal deliver event

Add a tracepoint where a process gets a signal. This tracepoint
shows signal-number, sa-handler and sa-flag.

Changes in v3:
 - Add docbook style comments

Changes in v2:
 - Add siginfo argument
 - Fix comment

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reviewed-by: Jason Baron <jbaron@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Oleg Nesterov <oleg@redhat.com>
LKML-Reference: <20091124215651.30449.20926.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/signal.h |   39 +++++++++++++++++++++++++++++++++++++++
 kernel/signal.c               |    3 +++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index ef51756..a6d71de 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -60,6 +60,45 @@ TRACE_EVENT(signal_generate,
 		  __entry->comm, __entry->pid)
 );
 
+/**
+ * signal_deliver - called when a signal is delivered
+ * @sig: signal number
+ * @info: pointer to struct siginfo
+ * @ka: pointer to struct k_sigaction
+ *
+ * A 'sig' signal is delivered to current process with 'info' siginfo,
+ * and it will be handled by 'ka'. ka->sa.sa_handler can be SIG_IGN or
+ * SIG_DFL.
+ * Note that some signals reported by signal_generate tracepoint can be
+ * lost, ignored or modified (by debugger) before hitting this tracepoint.
+ * This means, this can show which signals are actually delivered, but
+ * matching generated signals and delivered signals may not be correct.
+ */
+TRACE_EVENT(signal_deliver,
+
+	TP_PROTO(int sig, struct siginfo *info, struct k_sigaction *ka),
+
+	TP_ARGS(sig, info, ka),
+
+	TP_STRUCT__entry(
+		__field(	int,		sig		)
+		__field(	int,		errno		)
+		__field(	int,		code		)
+		__field(	unsigned long,	sa_handler	)
+		__field(	unsigned long,	sa_flags	)
+	),
+
+	TP_fast_assign(
+		__entry->sig	= sig;
+		TP_STORE_SIGINFO(__entry, info);
+		__entry->sa_handler	= (unsigned long)ka->sa.sa_handler;
+		__entry->sa_flags	= ka->sa.sa_flags;
+	),
+
+	TP_printk("sig=%d errno=%d code=%d sa_handler=%lx sa_flags=%lx",
+		  __entry->sig, __entry->errno, __entry->code,
+		  __entry->sa_handler, __entry->sa_flags)
+);
 #endif /* _TRACE_SIGNAL_H */
 
 /* This part must be outside protection */
diff --git a/kernel/signal.c b/kernel/signal.c
index a1e0cc6..349d449 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1840,6 +1840,9 @@ relock:
 			ka = &sighand->action[signr-1];
 		}
 
+		/* Trace actually delivered signals. */
+		trace_signal_deliver(signr, info, ka);
+
 		if (ka->sa.sa_handler == SIG_IGN) /* Do nothing.  */
 			continue;
 		if (ka->sa.sa_handler != SIG_DFL) {
