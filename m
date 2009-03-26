Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbZCZPuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbZCZPuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758009AbZCZPuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:50:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49145 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420AbZCZPuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:50:04 -0400
Message-Id: <20090326155001.343838081@goodmis.org>
References: <20090326154918.330439698@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 26 Mar 2009 11:49:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] tracing: increase size of number of possible events
Content-Disposition: inline; filename=0001-tracing-increase-size-of-number-of-possible-events.patch
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

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.h        |    5 ++++-
 kernel/trace/trace_events.c |    2 +-
 kernel/trace/trace_output.c |    2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d7410bb..1c7cb30 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -48,13 +48,16 @@ enum trace_type {
  *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
  */
 struct trace_entry {
-	unsigned char		type;
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
  * Function trace entry - function address and parent function addres:
  */
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3047b56..d0f9968 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -357,7 +357,7 @@ static int trace_write_header(struct trace_seq *s)
 				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 				"\n",
-				FIELD(unsigned char, type),
+				FIELD(unsigned short, type),
 				FIELD(unsigned char, flags),
 				FIELD(unsigned char, preempt_count),
 				FIELD(int, pid),
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 19261fd..b2599b0 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -513,6 +513,8 @@ int register_ftrace_event(struct trace_event *event)
  out:
 	mutex_unlock(&trace_event_mutex);
 
+	WARN_ON_ONCE(next_event_type > FTRACE_MAX_EVENT);
+
 	return ret;
 }
 
-- 
1.6.2

-- 
