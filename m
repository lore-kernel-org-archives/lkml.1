Return-Path: <linux-kernel-owner+w=401wt.eu-S1756333AbYLaPnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbYLaPnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 10:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbYLaPnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 10:43:22 -0500
Received: from mail-fx0-f26.google.com ([209.85.220.26]:59613 "EHLO
	mail-fx0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753AbYLaPnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 10:43:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject;
        b=GPEqCkIqQWTTi7VIWOaIQMEmSh4lqdJKN7AMSOwG5tZSx43WPOlkJfLC+pLQRU5Kok
         eNRa8JNRE0uKhRS1uTy6bG98lOIjICG7s5Jkg+MpvWLMHwTvSy03n1A6aNS+g73RfltQ
         CCpIQ0/cp6NUwdfWUaAM+ju46YM9EisJHkOiQ=
Message-ID: <495b9316.1358560a.1934.7f61@mx.google.com>
Date: Wed, 31 Dec 2008 07:43:18 -0800 (PST)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       fweisbec@gmail.com
Subject: [PATCH 2/2] tracing/branch-tracer: adapt to the new reentrant stat tracing api
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: make all and annotated branches available simultaneously

Create two files "all" and "annotated" inside the /debugfs/tracing/trace_stat
directory, making the both stats simultaneously available instead of needing
to change an option to switch from one stat file to another.

The output of these stats haven't changed.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 4785a3b..da5cf3e 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -306,19 +306,6 @@ static int annotated_branch_stat_cmp(void *p1, void *p2)
 }
 
 #ifdef CONFIG_PROFILE_ALL_BRANCHES
-enum {
-	TRACE_BRANCH_OPT_ALL = 0x1
-};
-
-static struct tracer_opt branch_opts[] = {
-	{ TRACER_OPT(stat_all_branch, TRACE_BRANCH_OPT_ALL) },
-	{ }
-};
-
-static struct tracer_flags branch_flags = {
-	.val = 0,
-	.opts = branch_opts
-};
 
 extern unsigned long __start_branch_profile[];
 extern unsigned long __stop_branch_profile[];
@@ -352,28 +339,36 @@ all_branch_stat_next(void *v, int idx)
 	return p;
 }
 
-static int branch_set_flag(u32 old_flags, u32 bit, int set)
-{
-	if (bit == TRACE_BRANCH_OPT_ALL) {
-		if (set) {
-			branch_trace.stat_headers = all_branch_stat_headers;
-			branch_trace.stat_start = all_branch_stat_start;
-			branch_trace.stat_next = all_branch_stat_next;
-			branch_trace.stat_cmp = NULL;
-		} else {
-			branch_trace.stat_headers =
-				annotated_branch_stat_headers;
-			branch_trace.stat_start = annotated_branch_stat_start;
-			branch_trace.stat_next = annotated_branch_stat_next;
-			branch_trace.stat_cmp = annotated_branch_stat_cmp;
-		}
-		init_tracer_stat(&branch_trace);
-	}
-	return 0;
-}
+static struct tracer_stat branch_stats[] = {
+	{.name = "annotated",
+	.stat_start = annotated_branch_stat_start,
+	.stat_next = annotated_branch_stat_next,
+	.stat_cmp = annotated_branch_stat_cmp,
+	.stat_headers = annotated_branch_stat_headers,
+	.stat_show = branch_stat_show},
 
+	{.name = "all",
+	.stat_start = all_branch_stat_start,
+	.stat_next = all_branch_stat_next,
+	.stat_headers = all_branch_stat_headers,
+	.stat_show = branch_stat_show},
+
+	{ }
+};
+#else
+static struct tracer_stat branch_stats[] = {
+	{.name = "annotated",
+	.stat_start = annotated_branch_stat_start,
+	.stat_next = annotated_branch_stat_next,
+	.stat_cmp = annotated_branch_stat_cmp,
+	.stat_headers = annotated_branch_stat_headers,
+	.stat_show = branch_stat_show},
+
+	{ }
+};
 #endif /* CONFIG_PROFILE_ALL_BRANCHES */
 
+
 static struct tracer branch_trace __read_mostly =
 {
 	.name		= "branch",
@@ -383,16 +378,8 @@ static struct tracer branch_trace __read_mostly =
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest	= trace_selftest_startup_branch,
 #endif /* CONFIG_FTRACE_SELFTEST */
-#endif /* CONFIG_BRANCH_TRACER */
-	.stat_start	=	annotated_branch_stat_start,
-	.stat_next	= annotated_branch_stat_next,
-	.stat_show	= branch_stat_show,
-	.stat_headers	= annotated_branch_stat_headers,
-	.stat_cmp	= annotated_branch_stat_cmp,
-#ifdef CONFIG_PROFILE_ALL_BRANCHES
-	.flags	= &branch_flags,
-	.set_flag	= branch_set_flag,
 #endif
+	.stats		= branch_stats
 };
 
 __init static int init_branch_trace(void)
-- 
1.6.0.4


