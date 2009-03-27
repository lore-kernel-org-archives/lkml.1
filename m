Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbZC0Fla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbZC0Fla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 01:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761029AbZC0Fkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 01:40:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49959 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760738AbZC0Fkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 01:40:46 -0400
Message-ID: <49CC66FA.5050208@cn.fujitsu.com>
Date: Fri, 27 Mar 2009 13:41:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/7] blktrace: extract duplidate code
References: <49CC6691.7050103@cn.fujitsu.com>
In-Reply-To: <49CC6691.7050103@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_trace_event_print() and blk_tracer_print_line() share most of the code.

   text    data     bss     dec     hex filename
   8605     393      12    9010    2332 kernel/trace/blktrace.o.orig
   text    data     bss     dec     hex filename
   8555     393      12    8960    2300 kernel/trace/blktrace.o

This patch also prepares for the next patch, that prints out BLK_TN_MESSAGE.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |   62 ++++++++++++++++++++++------------------------
 1 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 2f21d77..c103b0c 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -986,29 +986,31 @@ static void get_pdu_remap(const struct trace_entry *ent,
 	r->sector = be64_to_cpu(sector);
 }
 
-static int blk_log_action_iter(struct trace_iterator *iter, const char *act)
+typedef int (blk_log_action_t) (struct trace_iterator *iter, const char *act);
+
+static int blk_log_action_classic(struct trace_iterator *iter, const char *act)
 {
 	char rwbs[6];
 	unsigned long long ts  = iter->ts;
 	unsigned long nsec_rem = do_div(ts, NSEC_PER_SEC);
 	unsigned secs	       = (unsigned long)ts;
-	const struct trace_entry *ent = iter->ent;
-	const struct blk_io_trace *t = (const struct blk_io_trace *)ent;
+	const struct blk_io_trace *t = te_blk_io_trace(iter->ent);
 
 	fill_rwbs(rwbs, t);
 
 	return trace_seq_printf(&iter->seq,
 				"%3d,%-3d %2d %5d.%09lu %5u %2s %3s ",
 				MAJOR(t->device), MINOR(t->device), iter->cpu,
-				secs, nsec_rem, ent->pid, act, rwbs);
+				secs, nsec_rem, iter->ent->pid, act, rwbs);
 }
 
-static int blk_log_action_seq(struct trace_seq *s, const struct blk_io_trace *t,
-			      const char *act)
+static int blk_log_action(struct trace_iterator *iter, const char *act)
 {
 	char rwbs[6];
+	const struct blk_io_trace *t = te_blk_io_trace(iter->ent);
+
 	fill_rwbs(rwbs, t);
-	return trace_seq_printf(s, "%3d,%-3d %2s %3s ",
+	return trace_seq_printf(&iter->seq, "%3d,%-3d %2s %3s ",
 				MAJOR(t->device), MINOR(t->device), act, rwbs);
 }
 
@@ -1129,22 +1131,25 @@ static const struct {
 	[__BLK_TA_REMAP]	= {{  "A", "remap" },	   blk_log_remap },
 };
 
-static enum print_line_t blk_trace_event_print(struct trace_iterator *iter,
-					       int flags)
+static enum print_line_t print_one_line(struct trace_iterator *iter,
+					bool classic)
 {
 	struct trace_seq *s = &iter->seq;
-	const struct blk_io_trace *t = (struct blk_io_trace *)iter->ent;
-	const u16 what = t->action & ((1 << BLK_TC_SHIFT) - 1);
+	const struct blk_io_trace *t;
+	u16 what;
 	int ret;
+	bool long_act;
+	blk_log_action_t *log_action;
 
-	if (!trace_print_context(iter))
-		return TRACE_TYPE_PARTIAL_LINE;
+	t	   = te_blk_io_trace(iter->ent);
+	what	   = t->action & ((1 << BLK_TC_SHIFT) - 1);
+	long_act   = !!(trace_flags & TRACE_ITER_VERBOSE);
+	log_action = classic ? &blk_log_action_classic : &blk_log_action;
 
 	if (unlikely(what == 0 || what >= ARRAY_SIZE(what2act)))
 		ret = trace_seq_printf(s, "Bad pc action %x\n", what);
 	else {
-		const bool long_act = !!(trace_flags & TRACE_ITER_VERBOSE);
-		ret = blk_log_action_seq(s, t, what2act[what].act[long_act]);
+		ret = log_action(iter, what2act[what].act[long_act]);
 		if (ret)
 			ret = what2act[what].print(s, iter->ent);
 	}
@@ -1152,6 +1157,15 @@ static enum print_line_t blk_trace_event_print(struct trace_iterator *iter,
 	return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
 }
 
+static enum print_line_t blk_trace_event_print(struct trace_iterator *iter,
+					       int flags)
+{
+	if (!trace_print_context(iter))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return print_one_line(iter, false);
+}
+
 static int blk_trace_synthesize_old_trace(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
@@ -1177,26 +1191,10 @@ blk_trace_event_print_binary(struct trace_iterator *iter, int flags)
 
 static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
 {
-	const struct blk_io_trace *t;
-	u16 what;
-	int ret;
-
 	if (!(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC))
 		return TRACE_TYPE_UNHANDLED;
 
-	t = (const struct blk_io_trace *)iter->ent;
-	what = t->action & ((1 << BLK_TC_SHIFT) - 1);
-
-	if (unlikely(what == 0 || what >= ARRAY_SIZE(what2act)))
-		ret = trace_seq_printf(&iter->seq, "Bad pc action %x\n", what);
-	else {
-		const bool long_act = !!(trace_flags & TRACE_ITER_VERBOSE);
-		ret = blk_log_action_iter(iter, what2act[what].act[long_act]);
-		if (ret)
-			ret = what2act[what].print(&iter->seq, iter->ent);
-	}
-
-	return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+	return print_one_line(iter, true);
 }
 
 static struct tracer blk_tracer __read_mostly = {
-- 
1.5.4.rc3



