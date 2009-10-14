Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZJNHA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZJNHA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbZJNHA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:00:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:37412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbZJNHAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:00:25 -0400
Date: Wed, 14 Oct 2009 06:59:13 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091013203425.896285120@goodmis.org>
References: <20091013203425.896285120@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Enable records during the module load
Message-ID: <tip-5cb084bb1f3fd4dcdaf7e4cf564994346ec8f783@git.kernel.org>
Git-Commit-ID: 5cb084bb1f3fd4dcdaf7e4cf564994346ec8f783
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:59:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cb084bb1f3fd4dcdaf7e4cf564994346ec8f783
Gitweb:     http://git.kernel.org/tip/5cb084bb1f3fd4dcdaf7e4cf564994346ec8f783
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 13 Oct 2009 16:33:53 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Oct 2009 08:13:54 +0200

tracing: Enable records during the module load

I was debuging some module using "function" and "function_graph"
tracers and noticed, that if you load module after you enabled
tracing, the module's hooks will convert only to NOP instructions.

The attached patch enables modules' hooks if there's function trace
allready on, thus allowing to trace module functions.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20091013203425.896285120@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/ftrace.c |   38 ++++++++++++++++++++++++++++++--------
 1 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0c799d1..aaea9cd 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1270,12 +1270,34 @@ static int ftrace_update_code(struct module *mod)
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
@@ -2609,7 +2631,7 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 	return 0;
 }
 
-static int ftrace_convert_nops(struct module *mod,
+static int ftrace_process_locs(struct module *mod,
 			       unsigned long *start,
 			       unsigned long *end)
 {
@@ -2669,7 +2691,7 @@ static void ftrace_init_module(struct module *mod,
 {
 	if (ftrace_disabled || start == end)
 		return;
-	ftrace_convert_nops(mod, start, end);
+	ftrace_process_locs(mod, start, end);
 }
 
 static int ftrace_module_notify(struct notifier_block *self,
@@ -2730,7 +2752,7 @@ void __init ftrace_init(void)
 
 	last_ftrace_enabled = ftrace_enabled = 1;
 
-	ret = ftrace_convert_nops(NULL,
+	ret = ftrace_process_locs(NULL,
 				  __start_mcount_loc,
 				  __stop_mcount_loc);
 
