Return-Path: <linux-kernel-owner+w=401wt.eu-S934350AbZKXVyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350AbZKXVyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934338AbZKXVyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:54:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934342AbZKXVya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:54:30 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v4 2/3] tracepoint: Add signal deliver event
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Jason Baron <jbaron@redhat.com>, Roland McGrath <roland@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 24 Nov 2009 16:56:51 -0500
Message-ID: <20091124215651.30449.20926.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091124215638.30449.3838.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091124215638.30449.3838.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a tracepoint where a process gets a signal. This tracepoint
shows signal-number, sa-handler and sa-flag.

Changes in v3:
 - Add docbook style comments

Changes in v2:
 - Add siginfo argument
 - Fix comment

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reviewed-by: Jason Baron <jbaron@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
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
index 54ac4c5..d518984 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1860,6 +1860,9 @@ relock:
 			ka = &sighand->action[signr-1];
 		}
 
+		/* Trace actually delivered signals. */
+		trace_signal_deliver(signr, info, ka);
+
 		if (ka->sa.sa_handler == SIG_IGN) /* Do nothing.  */
 			continue;
 		if (ka->sa.sa_handler != SIG_DFL) {


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
