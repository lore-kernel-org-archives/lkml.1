Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbZFDF1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbZFDF1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbZFDF0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:26:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59133 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbZFDF0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:26:12 -0400
Message-Id: <20090604052613.706062044@goodmis.org>
References: <20090604052540.528802957@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 04 Jun 2009 01:25:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/6] tracing/branch-profiling: add variable to disable branch profiling
Content-Disposition: inline; filename=0005-tracing-branch-profiling-add-variable-to-disable-bra.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently, the branch profiler is either always enabled, or always
disabled. This patch adds a sysctl (/proc/sys/kernel/branch_profiling_enabled)
to be able to enable/disable the branch profiler.

This should help on cache line bouncing when not enabled.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kernel.h      |    4 +++-
 kernel/sysctl.c             |   10 ++++++++++
 kernel/trace/trace_branch.c |    9 +++++++++
 3 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f96a481..9372a87 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -77,13 +77,15 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #define unlikely(x)	(__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
 
 #ifdef CONFIG_PROFILE_ALL_BRANCHES
+extern int sysctl_branch_profiling_enabled;
 /*
  * "Define 'is'", Bill Clinton
  * "Define 'if'", Steven Rostedt
  */
 #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
 #define __trace_if(cond) \
-	if (__builtin_constant_p((cond)) ? !!(cond) :			\
+	if ((!sysctl_branch_profiling_enabled ||			\
+	     __builtin_constant_p((cond))) ? !!(cond) :			\
 	({								\
 		int ______r;						\
 		static struct ftrace_branch_data			\
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b2970d5..2628aa7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -912,6 +912,16 @@ static struct ctl_table kern_table[] = {
 		.child		= slow_work_sysctls,
 	},
 #endif
+#ifdef CONFIG_PROFILE_ALL_BRANCHES
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "branch_profiling_enabled",
+		.data           = &sysctl_branch_profiling_enabled,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 19c618f..e4f1465 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -334,6 +334,15 @@ fs_initcall(init_annotated_branch_stats);
 
 #ifdef CONFIG_PROFILE_ALL_BRANCHES
 
+int sysctl_branch_profiling_enabled __read_mostly;
+
+static int __init set_enable_branch_profiler(char *str)
+{
+	sysctl_branch_profiling_enabled = 1;
+	return 1;
+}
+__setup("enable_branch_profiler", set_enable_branch_profiler);
+
 extern unsigned long __start_branch_profile[];
 extern unsigned long __stop_branch_profile[];
 
-- 
1.6.3.1

-- 
