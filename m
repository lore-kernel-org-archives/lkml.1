Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbZDXEbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbZDXEbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbZDXEbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:31:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38653 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbZDXEbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:31:13 -0400
Message-Id: <20090424043111.983189535@goodmis.org>
References: <20090424043005.338878133@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 24 Apr 2009 00:30:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/6] tracing: increase size of number of possible events
Content-Disposition: inline; filename=0002-tracing-increase-size-of-number-of-possible-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

With the new event tracing registration, we must increase the number
of events that can be registered. Currently the type field is only
one byte, which leaves us only 256 possible events.

Since we do not save the CPU number in the tracer anymore (it is determined
by the per cpu ring buffer that is used) we have an extra byte to use.

This patch increases the size of type from 1 byte (256 events) to
2 bytes (65,536 events).

It also adds a WARN_ON_ONCE if we exceed that limit.

[ Impact: allow more than 255 events ]

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace_event.h |    5 ++++-
 kernel/trace/trace_events.c  |    2 +-
 kernel/trace/trace_output.c  |    2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 2a4a407..07e0a6d 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -16,13 +16,16 @@ struct dentry;
  *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
  */
 struct trace_entry {
-	int			type;
+	unsigned short		type;
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
 	int			tgid;
 };
 
+#define FTRACE_MAX_EVENT						\
+	((1 << (sizeof(((struct trace_entry *)0)->type) * 8)) - 1)
+
 /*
  * Trace iterator - used by printout routines who present trace
  * results to users and which routines might sleep, etc:
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 5d6e879..9887131 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -398,7 +398,7 @@ static int trace_write_header(struct trace_seq *s)
 				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 				"\n",
-				FIELD(int, type),
+				FIELD(unsigned short, type),
 				FIELD(unsigned char, flags),
 				FIELD(unsigned char, preempt_count),
 				FIELD(int, pid),
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 83a8abb..06997e7 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -537,6 +537,8 @@ int register_ftrace_event(struct trace_event *event)
  out:
 	mutex_unlock(&trace_event_mutex);
 
+	WARN_ON_ONCE(next_event_type > FTRACE_MAX_EVENT);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(register_ftrace_event);
-- 
1.6.2.1

-- 
