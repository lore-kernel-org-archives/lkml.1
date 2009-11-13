Return-Path: <linux-kernel-owner+w=401wt.eu-S932423AbZKMWxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbZKMWxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932320AbZKMWxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:53:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbZKMWxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:53:10 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 3/3] Add get_signal tracepoint
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Roland McGrath <roland@redhat.com>
Date: Fri, 13 Nov 2009 17:52:40 -0500
Message-ID: <20091113225240.15079.4863.stgit@harusame>
In-Reply-To: <20091113225226.15079.90813.stgit@harusame>
References: <20091113225226.15079.90813.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a tracepoint where a process gets a signal. This tracepoint
shows signal-number, sa-handler and sa-flag.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---

 include/trace/events/sched.h |   26 ++++++++++++++++++++++++++
 kernel/signal.c              |    3 +++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index ff9d5fb..de8ca7e 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -354,6 +354,32 @@ TRACE_EVENT(sched_process_coredump,
 );
 
 /*
+ * Tracepoint for getting a signal:
+ */
+TRACE_EVENT(sched_process_get_signal,
+
+	TP_PROTO(int sig, struct k_sigaction *ka),
+
+	TP_ARGS(sig, ka),
+
+	TP_STRUCT__entry(
+		__field(	int,		sig		)
+		__field(	unsigned long,	sa_handler	)
+		__field(	unsigned long,	sa_flags	)
+	),
+
+
+	TP_fast_assign(
+		__entry->sig	= sig;
+		__entry->sa_handler	= (unsigned long)ka->sa.sa_handler;
+		__entry->sa_flags	= ka->sa.sa_flags;
+	),
+
+	TP_printk("sig: %d sa_handler: %lx sa_flags: %lx",
+		  __entry->sig, __entry->sa_handler, __entry->sa_flags)
+);
+
+/*
  * Tracepoint for sending a signal:
  */
 TRACE_EVENT(sched_signal_send,
diff --git a/kernel/signal.c b/kernel/signal.c
index fe08008..44614fb 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1859,6 +1859,9 @@ relock:
 			ka = &sighand->action[signr-1];
 		}
 
+		/* Trace the actual queued signals including SIG_IGN.*/
+		trace_sched_process_get_signal(signr, ka);
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
