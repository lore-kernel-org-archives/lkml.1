Return-Path: <linux-kernel-owner+w=401wt.eu-S1760967AbZC1Vab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760967AbZC1Vab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 17:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760881AbZC1V3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 17:29:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:53480 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169AbZC1V3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 17:29:07 -0400
Date: Sat, 28 Mar 2009 21:28:33 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49CC3823.7010904@cn.fujitsu.com>
References: <49CC3823.7010904@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: extract duplidate code
Message-ID: <tip-e1eb6c441d543eb3de17c214e3adb11bdd83b10e@git.kernel.org>
Git-Commit-ID: e1eb6c441d543eb3de17c214e3adb11bdd83b10e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 28 Mar 2009 21:28:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1eb6c441d543eb3de17c214e3adb11bdd83b10e
Gitweb:     http://git.kernel.org/tip/e1eb6c441d543eb3de17c214e3adb11bdd83b10e
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 27 Mar 2009 10:21:23 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 Mar 2009 12:51:42 +0100

blktrace: extract duplidate code

Impact: cleanup

blk_trace_event_print() and blk_tracer_print_line() share most of the code.

   text    data     bss     dec     hex filename
   8605     393      12    9010    2332 kernel/trace/blktrace.o.orig
   text    data     bss     dec     hex filename
   8555     393      12    8960    2300 kernel/trace/blktrace.o

This patch also prepares for the next patch, that prints out BLK_TN_MESSAGE.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49CC3823.7010904@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
