Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbZHMUKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbZHMUKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbZHMUKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:10:49 -0400
Received: from kroah.org ([198.145.64.141]:41733 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095AbZHMT7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:35 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:29 2009
Message-Id: <20090813195129.013296149@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [patch 30/74] tracing: Fix invalid function_graph entry
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=tracing-fix-invalid-function_graph-entry.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

commit 38ceb592fcac9110c6b3c87ea0a27bff68c43486 upstream.

When print_graph_entry() computes a function call entry event, it needs
to also check the next entry to guess if it matches the return event of
the current function entry.
In order to look at this next event, it needs to consume the current
entry before going ahead in the ring buffer.

However, if the current event that gets consumed is the last one in the
ring buffer head page, the ring_buffer may reuse the page for writers.
The consumed entry will then become invalid because of possible
racy overwriting.

Me must then handle this entry by making a copy of it.

The fix also applies on 2.6.30

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A6EEAEC.3050508@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace_functions_graph.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -798,9 +798,16 @@ print_graph_function(struct trace_iterat
 
 	switch (entry->type) {
 	case TRACE_GRAPH_ENT: {
-		struct ftrace_graph_ent_entry *field;
+		/*
+		 * print_graph_entry() may consume the current event,
+		 * thus @field may become invalid, so we need to save it.
+		 * sizeof(struct ftrace_graph_ent_entry) is very small,
+		 * it can be safely saved at the stack.
+		 */
+		struct ftrace_graph_ent_entry *field, saved;
 		trace_assign_type(field, entry);
-		return print_graph_entry(field, s, iter);
+		saved = *field;
+		return print_graph_entry(&saved, s, iter);
 	}
 	case TRACE_GRAPH_RET: {
 		struct ftrace_graph_ret_entry *field;


