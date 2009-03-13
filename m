Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbZCMFJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbZCMFJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758039AbZCMFF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:05:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41506 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499AbZCMFFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:05:24 -0400
Message-Id: <20090313050521.535041167@goodmis.org>
References: <20090313050446.277065036@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 13 Mar 2009 01:04:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/4] tracing: move binary buffers into per cpu directory
Content-Disposition: inline; filename=0003-tracing-move-binary-buffers-into-per-cpu-directory.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The binary_buffers directory in /debugfs/tracing held the files
to read the trace buffers in a binary format. This held one file
per CPU buffer. But we also have a per_cpu directory that holds
a way to read the pretty-print formats.

This patch moves the binary buffers into the per_cpu_directory:

 # ls /debug/tracing/per_cpu/cpu1/
trace  trace_pipe  trace_pipe_raw

The new name is called "trace_pipe_raw". The binary buffers always
acted similar to trace_pipe, except that they produce raw data.

Requested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   26 +++++---------------------
 1 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dbb077d..efe3202 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3543,6 +3543,11 @@ static void tracing_init_debugfs_percpu(long cpu)
 				(void *) cpu, &tracing_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs 'trace' entry\n");
+
+	entry = debugfs_create_file("trace_pipe_raw", 0444, d_cpu,
+				    (void *) cpu, &tracing_buffers_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'trace_pipe_raw' entry\n");
 }
 
 #ifdef CONFIG_FTRACE_SELFTEST
@@ -3826,7 +3831,6 @@ static __init void create_trace_options_dir(void)
 static __init int tracer_init_debugfs(void)
 {
 	struct dentry *d_tracer;
-	struct dentry *buffers;
 	struct dentry *entry;
 	int cpu;
 
@@ -3899,26 +3903,6 @@ static __init int tracer_init_debugfs(void)
 		pr_warning("Could not create debugfs "
 			   "'trace_marker' entry\n");
 
-	buffers = debugfs_create_dir("binary_buffers", d_tracer);
-
-	if (!buffers)
-		pr_warning("Could not create buffers directory\n");
-	else {
-		int cpu;
-		char buf[64];
-
-		for_each_tracing_cpu(cpu) {
-			sprintf(buf, "%d", cpu);
-
-			entry = debugfs_create_file(buf, 0444, buffers,
-						    (void *)(long)cpu,
-						    &tracing_buffers_fops);
-			if (!entry)
-				pr_warning("Could not create debugfs buffers "
-					   "'%s' entry\n", buf);
-		}
-	}
-
 #ifdef CONFIG_DYNAMIC_FTRACE
 	entry = debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 				    &ftrace_update_tot_cnt,
-- 
1.6.1.3

-- 
