Return-Path: <linux-kernel-owner+w=401wt.eu-S934867AbZLGUWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934867AbZLGUWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964908AbZLGUWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:22:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61314 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964888AbZLGUWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:22:03 -0500
Message-Id: <20091207202208.775755384@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Dec 2009 15:19:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/4] [PATCH 1/4] tracing: Add pipe_close interface
References: <20091207201903.864817226@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-pipe_close-interface.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

An ftrace plugin can add a pipe_open interface when the user opens
trace_pipe. But if the plugin allocates something within the pipe_open
it can not free it because there exists no pipe_close. The hook to
the trace file open has a corresponding close. The closing of the
trace_pipe file should also have a corresponding close.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    4 ++++
 kernel/trace/trace.h |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 874f289..f804b40 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2898,6 +2898,10 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 	else
 		cpumask_clear_cpu(iter->cpu_file, tracing_reader_cpumask);
 
+
+	if (iter->trace->pipe_open)
+		iter->trace->pipe_close(iter);
+
 	mutex_unlock(&trace_types_lock);
 
 	free_cpumask_var(iter->started);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 1d7f483..7fa33ca 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -272,6 +272,7 @@ struct tracer_flags {
  * @pipe_open: called when the trace_pipe file is opened
  * @wait_pipe: override how the user waits for traces on trace_pipe
  * @close: called when the trace file is released
+ * @pipe_close: called when the trace_pipe file is released
  * @read: override the default read callback on trace_pipe
  * @splice_read: override the default splice_read callback on trace_pipe
  * @selftest: selftest to run on boot (see trace_selftest.c)
@@ -290,6 +291,7 @@ struct tracer {
 	void			(*pipe_open)(struct trace_iterator *iter);
 	void			(*wait_pipe)(struct trace_iterator *iter);
 	void			(*close)(struct trace_iterator *iter);
+	void			(*pipe_close)(struct trace_iterator *iter);
 	ssize_t			(*read)(struct trace_iterator *iter,
 					struct file *filp, char __user *ubuf,
 					size_t cnt, loff_t *ppos);
-- 
1.6.5


