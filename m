Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbZKRVOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbZKRVOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbZKRVOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:14:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756013AbZKRVOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:14:17 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v2 3/3] tracepoint: Add signal loss events
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Wed, 18 Nov 2009 16:16:28 -0500
Message-ID: <20091118211628.20207.96267.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091118211609.20207.55487.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091118211609.20207.55487.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add signal_overflow_fail and signal_lose_info tracepoints
for signal-lost events.

Changes in v2:
 - Use siginfo string macro

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Suggested-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 include/trace/events/signal.h |   52 +++++++++++++++++++++++++++++++++++++++++
 kernel/signal.c               |   19 +++++++++++----
 2 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index 9a043db..f7215ed 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -79,6 +79,58 @@ TRACE_EVENT(signal_deliver,
 		  __entry->sig, __entry->errno, __entry->code,
 		  __entry->sa_handler, __entry->sa_flags)
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
+		TP_STORE_SIGINFO(__entry, info);
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
