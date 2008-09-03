Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbYICVsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbYICVsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYICVr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:47:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32902 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbYICVr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:47:56 -0400
Message-Id: <20080903214754.309026929@goodmis.org>
References: <20080903214249.661170580@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 17:42:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ftrace: print continue index fix
Content-Disposition: inline; filename=ftrace-trace-cont-index-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An item in the trace buffer that is bigger than one entry may be split
up using the TRACE_CONT entry. This makes it a virtual single entry.
The current code increments the iterator index even while traversing
TRACE_CONT entries, making it look like the iterator is further than
it actually is.

This patch adds code to not increment the iterator index while skipping
over TRACE_CONT entries.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-09-03 16:46:30.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-09-03 16:50:03.000000000 -0400
@@ -1117,9 +1117,8 @@ trace_entry_idx(struct trace_array *tr, 
 }
 
 /* Increment the index counter of an iterator by one */
-static void trace_iterator_increment(struct trace_iterator *iter, int cpu)
+static void __trace_iterator_increment(struct trace_iterator *iter, int cpu)
 {
-	iter->idx++;
 	iter->next_idx[cpu]++;
 	iter->next_page_idx[cpu]++;
 
@@ -1132,6 +1131,12 @@ static void trace_iterator_increment(str
 	}
 }
 
+static void trace_iterator_increment(struct trace_iterator *iter, int cpu)
+{
+	iter->idx++;
+	__trace_iterator_increment(iter, cpu);
+}
+
 static struct trace_entry *
 trace_entry_next(struct trace_array *tr, struct trace_array_cpu *data,
 		 struct trace_iterator *iter, int cpu)
@@ -1153,7 +1158,7 @@ trace_entry_next(struct trace_array *tr,
 
 	/* find a real entry */
 	do {
-		trace_iterator_increment(iter, cpu);
+		__trace_iterator_increment(iter, cpu);
 		ent = trace_entry_idx(tr, tr->data[cpu], iter, cpu);
 	} while (ent && ent->type != TRACE_CONT);
 
@@ -1187,7 +1192,7 @@ __find_next_entry(struct trace_iterator 
 				ent = trace_entry_next(tr, data, iter, cpu);
 			else {
 				while (ent && ent->type == TRACE_CONT) {
-					trace_iterator_increment(iter, cpu);
+					__trace_iterator_increment(iter, cpu);
 					ent = trace_entry_idx(tr, tr->data[cpu],
 							      iter, cpu);
 				}
@@ -1566,7 +1571,7 @@ trace_seq_print_cont(struct trace_seq *s
 
 	do {
 		trace_seq_printf(s, "%s", ent->cont.buf);
-		trace_iterator_increment(iter, iter->cpu);
+		__trace_iterator_increment(iter, iter->cpu);
 		ent = trace_entry_idx(tr, data, iter, iter->cpu);
 	} while (ent && ent->type == TRACE_CONT);
 }

-- 
