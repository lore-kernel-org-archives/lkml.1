Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbZG1MKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbZG1MKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 08:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZG1MKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 08:10:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53716 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbZG1MKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 08:10:51 -0400
Message-ID: <4A6EEAEC.3050508@cn.fujitsu.com>
Date: Tue, 28 Jul 2009 20:11:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: fix invalid function_graph entry
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


print_graph_entry() consumes current event, if this event
is the last event in the page, the ring_buffer may reuse
the page. It will become invalid.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index abf7c4a..02102a3 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -835,9 +835,16 @@ print_graph_function(struct trace_iterator *iter)
 
 	switch (entry->type) {
 	case TRACE_GRAPH_ENT: {
-		struct ftrace_graph_ent_entry *field;
+		/*
+		 * print_graph_entry() may consume the current event,
+		 * thus @field may become invalid, so we need to save it.
+		 * sizeof(struct ftrace_graph_ent_entry) is very small,
+		 * it is safely saved at the stack.
+		 */
+		struct ftrace_graph_ent_entry *field, saved;
 		trace_assign_type(field, entry);
-		return print_graph_entry(field, s, iter);
+		saved = *field;
+		return print_graph_entry(&saved, s, iter);
 	}
 	case TRACE_GRAPH_RET: {
 		struct ftrace_graph_ret_entry *field;

