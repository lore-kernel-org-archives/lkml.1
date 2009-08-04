Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbZHDMNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbZHDMNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 08:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbZHDMNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 08:13:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:46076 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971AbZHDMNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 08:13:06 -0400
Date: Tue, 4 Aug 2009 12:12:36 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com
In-Reply-To: <4A6EEAEC.3050508@cn.fujitsu.com>
References: <4A6EEAEC.3050508@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing: Fix invalid function_graph entry
Message-ID: <tip-38ceb592fcac9110c6b3c87ea0a27bff68c43486@git.kernel.org>
Git-Commit-ID: 38ceb592fcac9110c6b3c87ea0a27bff68c43486
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 12:12:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38ceb592fcac9110c6b3c87ea0a27bff68c43486
Gitweb:     http://git.kernel.org/tip/38ceb592fcac9110c6b3c87ea0a27bff68c43486
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 28 Jul 2009 20:11:24 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 28 Jul 2009 23:17:23 +0200

tracing: Fix invalid function_graph entry

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
Cc: stable@kernel.org
LKML-Reference: <4A6EEAEC.3050508@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 kernel/trace/trace_functions_graph.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index d2249ab..420ec34 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -843,9 +843,16 @@ print_graph_function(struct trace_iterator *iter)
 
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
