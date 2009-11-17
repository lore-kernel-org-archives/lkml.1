Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbZKRAi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbZKRAi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZKRAi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:38:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbZKRAiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:38:25 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/3] tracepoint: Add signal deliver event
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 17 Nov 2009 18:41:48 -0500
Message-ID: <20091117234148.30589.94756.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091117234117.30589.61311.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091117234117.30589.61311.stgit@dhcp-100-2-132.bos.redhat.com>
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
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 include/trace/events/signal.h |   24 ++++++++++++++++++++++++
 kernel/signal.c               |    3 +++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index c7817f3..6dfd88d 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -32,6 +32,30 @@ TRACE_EVENT(signal_generate,
 		  __entry->sig, __entry->comm, __entry->pid)
 );
 
+/*
+ * Tracepoint for delivering a signal:
+ */
+TRACE_EVENT(signal_deliver,
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
+	TP_fast_assign(
+		__entry->sig	= sig;
+		__entry->sa_handler	= (unsigned long)ka->sa.sa_handler;
+		__entry->sa_flags	= ka->sa.sa_flags;
+	),
+
+	TP_printk("sig=%d sa_handler=%lx sa_flags=%lx",
+		  __entry->sig, __entry->sa_handler, __entry->sa_flags)
+);
 #endif /* _TRACE_SIGNAL_H */
 
 /* This part must be outside protection */
diff --git a/kernel/signal.c b/kernel/signal.c
index 82ab077..5615f41 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1860,6 +1860,9 @@ relock:
 			ka = &sighand->action[signr-1];
 		}
 
+		/* Trace the actual delivered signals including SIG_IGN.*/
+		trace_signal_deliver(signr, ka);
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
