Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237Ab0ASHfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab0ASHfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964Ab0ASHfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:35:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49871 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab0ASHfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:35:20 -0500
Message-ID: <4B556064.7080700@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 15:33:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/6] : bug fix, remove partial zero out
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

partial-zero-out a struct is very dangerous, we should zero out
field by field directly when need.

partial-zero-out for struct trace_iterator exists when ftrace
was first introduced into mainline kernel. But in this few years,
the code of ftrace is changed a lot, and:

1) partial-zero-out for struct trace_iterator has a bug now,
   cpumask_var_t started should not be zeroed out.

2) I viewed the codes and found that fields below
   "/* The below is zeroed out in pipe_read */"
   don't need to be zeroed out or initialized now.

So, we remove the code of "partial zero out"

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 3ca9485..c6d0e1a 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -54,7 +54,6 @@ struct trace_iterator {
 	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
 	unsigned long		iter_flags;
 
-	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
 	struct trace_entry	*ent;
 	int			leftover;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5314c90..27fecf8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3124,12 +3124,6 @@ waitagain:
 	if (cnt >= PAGE_SIZE)
 		cnt = PAGE_SIZE - 1;
 
-	/* reset all but tr, trace, and overruns */
-	memset(&iter->seq, 0,
-	       sizeof(struct trace_iterator) -
-	       offsetof(struct trace_iterator, seq));
-	iter->pos = -1;
-
 	trace_event_read_lock();
 	trace_access_lock(iter->cpu_file);
 	while (find_next_entry_inc(iter) != NULL) {
@@ -4398,12 +4392,7 @@ static void __ftrace_dump(bool disable_tracing)
 
 		cnt++;
 
-		/* reset all but tr, trace, and overruns */
-		memset(&iter.seq, 0,
-		       sizeof(struct trace_iterator) -
-		       offsetof(struct trace_iterator, seq));
 		iter.iter_flags |= TRACE_FILE_LAT_FMT;
-		iter.pos = -1;
 
 		if (find_next_entry_inc(&iter) != NULL) {
 			int ret;

