Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbZJJOA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbZJJOA6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 10:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759083AbZJJOA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 10:00:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449AbZJJOA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 10:00:57 -0400
From: jolsa@redhat.com
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tracing - enable records during the module load
Date: Sat, 10 Oct 2009 16:00:20 +0200
Message-Id: <1255183220-15640-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was debuging some module using "function" and "function_graph" tracers
and noticed, that if you load module after you enabled tracing, the module's
hooks will convert only to NOP instructions.

The attached patch enables modules' hooks if there's function
trace allready on, thus allowing to trace module functions.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/ftrace.c |   38 ++++++++++++++++++++++++++++++--------
 1 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1a7f6ab..1ab603b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1261,12 +1261,34 @@ static int ftrace_update_code(struct module *mod)
 		ftrace_new_addrs = p->newlist;
 		p->flags = 0L;
 
-		/* convert record (i.e, patch mcount-call with NOP) */
-		if (ftrace_code_disable(mod, p)) {
-			p->flags |= FTRACE_FL_CONVERTED;
-			ftrace_update_cnt++;
-		} else
+		/*
+		 * Do the initial record convertion from mcount jump
+		 * to the NOP instructions.
+		 */
+		if (!ftrace_code_disable(mod, p)) {
 			ftrace_free_rec(p);
+			continue;
+		}
+
+		p->flags |= FTRACE_FL_CONVERTED;
+		ftrace_update_cnt++;
+
+		/*
+		 * If the tracing is enabled, go ahead and enable the record.
+		 *
+		 * The reason not to enable the record immediatelly is the
+		 * inherent check of ftrace_make_nop/ftrace_make_call for
+		 * correct previous instructions.  Making first the NOP
+		 * conversion puts the module to the correct state, thus
+		 * passing the ftrace_make_call check.
+		 */
+		if (ftrace_start_up) {
+			int failed = __ftrace_replace_code(p, 1);
+			if (failed) {
+				ftrace_bug(failed, p->ip);
+				ftrace_free_rec(p);
+			}
+		}
 	}
 
 	stop = ftrace_now(raw_smp_processor_id());
@@ -2570,7 +2592,7 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 	return 0;
 }
 
-static int ftrace_convert_nops(struct module *mod,
+static int ftrace_process_locs(struct module *mod,
 			       unsigned long *start,
 			       unsigned long *end)
 {
@@ -2630,7 +2652,7 @@ static void ftrace_init_module(struct module *mod,
 {
 	if (ftrace_disabled || start == end)
 		return;
-	ftrace_convert_nops(mod, start, end);
+	ftrace_process_locs(mod, start, end);
 }
 
 static int ftrace_module_notify(struct notifier_block *self,
@@ -2691,7 +2713,7 @@ void __init ftrace_init(void)
 
 	last_ftrace_enabled = ftrace_enabled = 1;
 
-	ret = ftrace_convert_nops(NULL,
+	ret = ftrace_process_locs(NULL,
 				  __start_mcount_loc,
 				  __stop_mcount_loc);
 
