Return-Path: <linux-kernel-owner+w=401wt.eu-S1761782AbZDQOpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782AbZDQOpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761504AbZDQOnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:43:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62636 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294AbZDQOne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:43:34 -0400
Message-Id: <20090417144332.227759396@goodmis.org>
References: <20090417144055.857407604@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 17 Apr 2009 10:40:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Avadh Patel <avadh4all@gmail.com>
Subject: [PATCH v2 4/5] tracing: add saved_cmdlines file to show cached task comms
Content-Disposition: inline; filename=0004-tracing-add-saved_cmdlines-file-to-show-cached-task.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avadh Patel <avadh4all@gmail.com>

Export the cached task comms to userspace. This allows user apps to translate
the pids from a trace into their respective task command lines.

[ added error checking and use of buf pointer to index file_buf
    - Steven Rostedt ]

Impact: let userspace apps reading binary buffer know comm's of pids
Signed-off-by: Avadh Patel <avadh4all@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2d69b26..031c46f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2422,6 +2422,56 @@ static const struct file_operations tracing_readme_fops = {
 };
 
 static ssize_t
+tracing_saved_cmdlines_read(struct file *file, char __user *ubuf,
+				size_t cnt, loff_t *ppos)
+{
+	char *buf_comm;
+	char *file_buf;
+	char *buf;
+	int len = 0;
+	int pid;
+	int i;
+
+	file_buf = kmalloc(SAVED_CMDLINES*(16+TASK_COMM_LEN), GFP_KERNEL);
+	if (!file_buf)
+		return -ENOMEM;
+
+	buf_comm = kmalloc(TASK_COMM_LEN, GFP_KERNEL);
+	if (!buf_comm) {
+		kfree(file_buf);
+		return -ENOMEM;
+	}
+
+	buf = file_buf;
+
+	for (i = 0; i < SAVED_CMDLINES; i++) {
+		int r;
+
+		pid = map_cmdline_to_pid[i];
+		if (pid == -1 || pid == NO_CMDLINE_MAP)
+			continue;
+
+		trace_find_cmdline(pid, buf_comm);
+		r = sprintf(buf, "%d %s\n", pid, buf_comm);
+		buf += r;
+		len += r;
+	}
+
+	len = simple_read_from_buffer(ubuf, cnt, ppos,
+				      file_buf, len);
+
+	kfree(file_buf);
+	kfree(buf_comm);
+
+	return len;
+}
+
+static const struct file_operations tracing_saved_cmdlines_fops = {
+    .open       = tracing_open_generic,
+    .read       = tracing_saved_cmdlines_read,
+};
+
+static ssize_t
 tracing_ctrl_read(struct file *filp, char __user *ubuf,
 		  size_t cnt, loff_t *ppos)
 {
@@ -3973,6 +4023,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("trace_marker", 0220, d_tracer,
 			NULL, &tracing_mark_fops);
 
+	trace_create_file("saved_cmdlines", 0444, d_tracer,
+			NULL, &tracing_saved_cmdlines_fops);
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
-- 
1.6.2.1

-- 
