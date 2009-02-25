Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbZBZGMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbZBZGMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 01:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbZBZGLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 01:11:54 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:49098 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbZBZGLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 01:11:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:date:to:cc:subject;
        b=Tz2113XeqAEuv3s5BGO9LVsdPSCd3K3DBiOpKqPeMvx+2uOd08QPFSU1CmXgXRhDjW
         S88QfKVXEJoThQsfKYY5MGKK2Q14GqEg8qsZxQqvkaw8QeuLzTy0zyfO3XPvoY+/355x
         y+VVf+YZPD5tRVxAkMeFc7ozOK7lbwuRJmGXk=
Message-ID: <49a632a5.0707d00a.296d.24b3@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 26 Feb 2009 00:41:38 +0100
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2] tracing/core: make the per cpu trace files in per cpu directories
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: scale per cpu tracing

The per cpu trace files are all in a single directory: /debug/tracing/per_cpu.
In case of a large number of cpu, the content of this directory becomes messy
so we create now one directory per cpu inside /debug/tracing/per_cpu which contain
each their own trace_pipe and trace files.

Ie:

nobody@nowhere:/debug/tracing$ ls -R per_cpu
per_cpu:
cpu0  cpu1

per_cpu/cpu0:
trace  trace_pipe

per_cpu/cpu1:
trace  trace_pipe

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/trace/trace.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b7eeecc..b1f7105 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3061,28 +3061,31 @@ struct dentry *tracing_dentry_percpu(void)
 static void tracing_init_debugfs_percpu(long cpu)
 {
 	struct dentry *d_percpu = tracing_dentry_percpu();
-	struct dentry *entry;
-	/* strlen(trace_pipe) + MAX(log10(cpu)) + '\0' */
-	char filename[17];
+	struct dentry *entry, *d_cpu;
+	/* strlen(cpu) + MAX(log10(cpu)) + '\0' */
+	char cpu_dir[7];
 
 	if (cpu > 999 || cpu < 0)
 		return;
 
-	/* per cpu trace_pipe */
-	sprintf(filename, "trace_pipe%ld", cpu);
+	sprintf(cpu_dir, "cpu%ld", cpu);
+	d_cpu = debugfs_create_dir(cpu_dir, d_percpu);
+	if (!d_cpu) {
+		pr_warning("Could not create debugfs '%s' entry\n", cpu_dir);
+		return;
+	}
 
-	entry = debugfs_create_file(filename, 0444, d_percpu,
+	/* per cpu trace_pipe */
+	entry = debugfs_create_file("trace_pipe", 0444, d_cpu,
 				(void *) cpu, &tracing_pipe_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs '%s' entry\n", filename);
+		pr_warning("Could not create debugfs 'trace_pipe' entry\n");
 
 	/* per cpu trace */
-	sprintf(filename, "trace%ld", cpu);
-
-	entry = debugfs_create_file(filename, 0444, d_percpu,
+	entry = debugfs_create_file("trace", 0444, d_cpu,
 				(void *) cpu, &tracing_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs '%s' entry\n", filename);
+		pr_warning("Could not create debugfs 'trace' entry\n");
 
 }
 
-- 
1.6.1


