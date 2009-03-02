Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbZCBUbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbZCBUbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZCBUaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:30:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35953 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZCBUa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:30:27 -0500
Message-Id: <20090302203024.802301194@goodmis.org>
References: <20090302202925.364437449@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 15:29:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/7] tracing: add ftrace headers to event format files
Content-Disposition: inline; filename=0005-tracing-add-ftrace-headers-to-event-format-files.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch includes the ftrace header to the event formats files:

 # cat /debug/tracing/events/sched/sched_switch/format
        field:unsigned char type;       offset:0;       size:1;
        field:unsigned char flags;      offset:1;       size:1;
        field:unsigned char preempt_count;      offset:2;       size:1;
        field:int pid;  offset:4;       size:4;
        field:int tgid; offset:8;       size:4;

        field:pid_t prev_pid;   offset:12;      size:4;
        field:int prev_prio;    offset:16;      size:4;
        field special:char next_comm[TASK_COMM_LEN];    offset:20;      size:16;
        field:pid_t next_pid;   offset:36;      size:4;
        field:int next_prio;    offset:40;      size:4;

A blank line is used as a deliminator between the ftrace header and the
trace point fields.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_events.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index d57a772..cdcc3ae 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -13,7 +13,7 @@
 #include <linux/module.h>
 #include <linux/ctype.h>
 
-#include "trace.h"
+#include "trace_output.h"
 
 #define TRACE_SYSTEM "TRACE_SYSTEM"
 
@@ -447,6 +447,28 @@ event_available_types_read(struct file *filp, char __user *ubuf, size_t cnt,
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
+#undef FIELD
+#define FIELD(type, name) \
+	#type, #name, offsetof(typeof(field), name), sizeof(field.name)
+
+static int trace_write_header(struct trace_seq *s)
+{
+	struct trace_entry field;
+
+	/* struct trace_entry */
+	return trace_seq_printf(s,
+				"\tfield:%s %s;\toffset:%lu;\tsize:%lu;\n"
+				"\tfield:%s %s;\toffset:%lu;\tsize:%lu;\n"
+				"\tfield:%s %s;\toffset:%lu;\tsize:%lu;\n"
+				"\tfield:%s %s;\toffset:%lu;\tsize:%lu;\n"
+				"\tfield:%s %s;\toffset:%lu;\tsize:%lu;\n"
+				"\n",
+				FIELD(unsigned char, type),
+				FIELD(unsigned char, flags),
+				FIELD(unsigned char, preempt_count),
+				FIELD(int, pid),
+				FIELD(int, tgid));
+}
 static ssize_t
 event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
@@ -465,6 +487,9 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 	if (*ppos)
 		return 0;
 
+	/* If this fails, so will the show_format. */
+	trace_write_header(s);
+
 	r = call->show_format(s);
 	if (!r) {
 		/*
-- 
1.5.6.5

-- 
