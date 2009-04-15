Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbZDODCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbZDODCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZDODCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:02:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62079 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753604AbZDODCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:02:07 -0400
Message-ID: <49E54E60.50408@cn.fujitsu.com>
Date: Wed, 15 Apr 2009 11:02:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] blktrace: fix context-info when mixed-using blk tracer and
 trace events
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When set current tracer to blk tracer, TRACE_ITER_CONTEXT_INFO is unset,
but actually context-info is printed:
    pdflush-431   [000]   821.181576:   8,0    P   N [pdflush]

And then if we enable TRACE_ITER_CONTEXT_INFO:
    # echo context-info > trace_options

We'll see context-info is printed twice. What's worse is, when use blk
tracer and trace events at a time, we'll see no context-info for trace
events:
    jbd2_commit_logging: dev dm-0:8 transaction 333227
    jbd2_end_commit: dev dm-0:8 transaction 333227 head 332814
      rm-25433 [001]  9578.307485:   8,18   m   N cfq25433 slice expired t=0
      rm-25433 [001]  9578.307486:   8,18   m   N cfq25433 put_queue

This patch adds blk_tracer->set_flags(), and context-info flag is unset
only when we set the output to classic mode.

Note after this patch, one should unset context-info explicitly if he
wants to get binary output that can be parsed by blkparse:
    # echo nocontext-info > trace_options
    # echo bin > trace_options
    # echo blk > current_tracer
    # cat trace_pipe | blkparse -i -

Reported-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 8e7c5da..c32062b 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1211,7 +1211,6 @@ static void blk_tracer_print_header(struct seq_file *m)
 static void blk_tracer_start(struct trace_array *tr)
 {
 	blk_tracer_enabled = true;
-	trace_flags &= ~TRACE_ITER_CONTEXT_INFO;
 }
 
 static int blk_tracer_init(struct trace_array *tr)
@@ -1224,7 +1223,6 @@ static int blk_tracer_init(struct trace_array *tr)
 static void blk_tracer_stop(struct trace_array *tr)
 {
 	blk_tracer_enabled = false;
-	trace_flags |= TRACE_ITER_CONTEXT_INFO;
 }
 
 static void blk_tracer_reset(struct trace_array *tr)
@@ -1289,9 +1287,6 @@ out:
 static enum print_line_t blk_trace_event_print(struct trace_iterator *iter,
 					       int flags)
 {
-	if (!trace_print_context(iter))
-		return TRACE_TYPE_PARTIAL_LINE;
-
 	return print_one_line(iter, false);
 }
 
@@ -1326,6 +1321,18 @@ static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
 	return print_one_line(iter, true);
 }
 
+static int blk_tracer_set_flag(u32 old_flags, u32 bit, int set)
+{
+	/* don't output context-info for blk_classic output */
+	if (bit == TRACE_BLK_OPT_CLASSIC) {
+		if (set)
+			trace_flags &= ~TRACE_ITER_CONTEXT_INFO;
+		else
+			trace_flags |= TRACE_ITER_CONTEXT_INFO;
+	}
+	return 0;
+}
+
 static struct tracer blk_tracer __read_mostly = {
 	.name		= "blk",
 	.init		= blk_tracer_init,
@@ -1335,6 +1342,7 @@ static struct tracer blk_tracer __read_mostly = {
 	.print_header	= blk_tracer_print_header,
 	.print_line	= blk_tracer_print_line,
 	.flags		= &blk_tracer_flags,
+	.set_flag	= blk_tracer_set_flag,
 };
 
 static struct trace_event trace_blk_event = {
-- 
1.5.4.rc3

