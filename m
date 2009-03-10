Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZCJVHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZCJVHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZCJVFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:05:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55466 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbZCJVFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:05:35 -0400
Message-Id: <20090310210531.745257481@goodmis.org>
References: <20090310210408.419131392@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 17:04:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 6/7] tracing: update comments to match event code macros
Content-Disposition: inline; filename=0006-tracing-update-comments-to-match-event-code-macros.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up / comments

The comments that described the ftrace macros to manipulate the
TRACE_EVENT and TRACE_FORMAT macros no longer match the code.
This patch updates them.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_events_stage_1.h |    6 ++++--
 kernel/trace/trace_events_stage_2.h |    9 ++++-----
 kernel/trace/trace_events_stage_3.h |    8 ++++----
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace_events_stage_1.h b/kernel/trace/trace_events_stage_1.h
index 82f6844..38985f9 100644
--- a/kernel/trace/trace_events_stage_1.h
+++ b/kernel/trace/trace_events_stage_1.h
@@ -6,11 +6,13 @@
  * struct ftrace_raw_<call> {
  *	struct trace_entry		ent;
  *	<type>				<item>;
+ *	<type2>				<item2>[<len>];
  *	[...]
  * };
  *
- * The <type> <item> is created by the TRACE_FIELD(type, item, assign)
- * macro. We simply do "type item;", and that will create the fields
+ * The <type> <item> is created by the __field(type, item) macro or
+ * the __array(type2, item2, len) macro.
+ * We simply do "type item;", and that will create the fields
  * in the structure.
  */
 
diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
index 1ad9f8d..ca347af 100644
--- a/kernel/trace/trace_events_stage_2.h
+++ b/kernel/trace/trace_events_stage_2.h
@@ -20,7 +20,7 @@
  *
  *	field = (typeof(field))entry;
  *
- *	ret = trace_seq_printf(s, <TP_RAW_FMT> "%s", <ARGS> "\n");
+ *	ret = trace_seq_printf(s, <TP_printk> "\n");
  *	if (!ret)
  *		return TRACE_TYPE_PARTIAL_LINE;
  *
@@ -76,10 +76,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
  *	int ret;
  *
  *	ret = trace_seq_printf(s, #type " " #item ";"
- *			       " size:%d; offset:%d;\n",
- *			       sizeof(field.type),
- *			       offsetof(struct ftrace_raw_##call,
- *					item));
+ *			       " offset:%u; size:%u;\n",
+ *			       offsetof(struct ftrace_raw_##call, item),
+ *			       sizeof(field.type));
  *
  * }
  */
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index d6de06b..6ee1de5 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -56,7 +56,8 @@
  * 		return;
  * 	entry	= ring_buffer_event_data(event);
  *
- * 	<tstruct>;  <-- Here we assign the entries by the TRACE_FIELD.
+ * 	<assign>;  <-- Here we assign the entries by the __field and
+ *			__array macros.
  *
  * 	trace_current_buffer_unlock_commit(event, irq_flags, pc);
  * }
@@ -96,11 +97,10 @@
  * __attribute__((__aligned__(4)))
  * __attribute__((section("_ftrace_events"))) event_<call> = {
  * 	.name 			= "<call>",
+ *	.system			= "<system>",
+ * 	.raw_init		= ftrace_raw_init_event_<call>,
  * 	.regfunc		= ftrace_reg_event_<call>,
  * 	.unregfunc		= ftrace_unreg_event_<call>,
- * 	.raw_init		= ftrace_raw_init_event_<call>,
- * 	.raw_reg		= ftrace_raw_reg_event_<call>,
- * 	.raw_unreg		= ftrace_raw_unreg_event_<call>,
  *	.show_format		= ftrace_format_<call>,
  * }
  *
-- 
1.6.1.3

-- 
