Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbYKUUcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbYKUUcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 15:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbYKUUbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 15:31:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47110 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbYKUUbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 15:31:03 -0500
Message-Id: <20081121203101.099886994@goodmis.org>
References: <20081121202932.281682721@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Nov 2008 15:29:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Fleming <mjf@gentoo.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Sam Ravnborg <sam@ravnborg.org>, Jim Radford <radford@galvanix.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/5] trace: fix compiler warning in branch profiler
Content-Disposition: inline; filename=0005-trace-fix-compiler-warning-in-branch-profiler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix complier warning

The ftrace_pointers used in the branch profiler are constant values.
They should never change. But the compiler complains when they are
passed into the debugfs_create_file as a data pointer, because the
function discards the qualifier.

This patch typecasts the parameter to debugfs_create_file back to
a void pointer. To remind the callbacks that they are pointing to
a constant value, I also modified the callback local pointers to
be const struct ftrace_pointer * as well.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_branch.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 85792ae..877ee88 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -191,7 +191,7 @@ struct ftrace_pointer {
 static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct ftrace_pointer *f = m->private;
+	const struct ftrace_pointer *f = m->private;
 	struct ftrace_branch_data *p = v;
 
 	(*pos)++;
@@ -224,7 +224,7 @@ static void t_stop(struct seq_file *m, void *p)
 
 static int t_show(struct seq_file *m, void *v)
 {
-	struct ftrace_pointer *fp = m->private;
+	const struct ftrace_pointer *fp = m->private;
 	struct ftrace_branch_data *p = v;
 	const char *f;
 	long percent;
@@ -296,7 +296,7 @@ static const struct file_operations tracing_branch_fops = {
 extern unsigned long __start_branch_profile[];
 extern unsigned long __stop_branch_profile[];
 
-static struct ftrace_pointer ftrace_branch_pos = {
+static const struct ftrace_pointer ftrace_branch_pos = {
 	.start			= __start_branch_profile,
 	.stop			= __stop_branch_profile,
 	.hit			= 1,
@@ -320,7 +320,7 @@ static __init int ftrace_branch_init(void)
 	d_tracer = tracing_init_dentry();
 
 	entry = debugfs_create_file("profile_annotated_branch", 0444, d_tracer,
-				    &ftrace_annotated_branch_pos,
+				    (void *)&ftrace_annotated_branch_pos,
 				    &tracing_branch_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
@@ -328,7 +328,7 @@ static __init int ftrace_branch_init(void)
 
 #ifdef CONFIG_PROFILE_ALL_BRANCHES
 	entry = debugfs_create_file("profile_branch", 0444, d_tracer,
-				    &ftrace_branch_pos,
+				    (void *)&ftrace_branch_pos,
 				    &tracing_branch_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs"
-- 
1.5.6.5

-- 
