Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbZGWDhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbZGWDhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 23:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZGWDhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 23:37:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37711 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZGWDhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 23:37:03 -0400
Message-Id: <20090723033701.821625999@goodmis.org>
References: <20090723033514.153354674@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 22 Jul 2009 23:35:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] tracing: only truncate ftrace files when O_TRUNC is set
Content-Disposition: inline; filename=0002-tracing-only-truncate-ftrace-files-when-O_TRUNC-is-s.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The current code will truncate the ftrace files contents if O_APPEND
is not set and the file is opened in write mode. This is incorrect.
It should only truncate the file if O_TRUNC is set. Otherwise
if one of these files is opened by a C program with fopen "r+",
it will incorrectly truncate the file.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c       |    4 ++--
 kernel/trace/trace.c        |    2 +-
 kernel/trace/trace_events.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 24e3ff5..bb6b566 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1617,7 +1617,7 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 
 	mutex_lock(&ftrace_regex_lock);
 	if ((file->f_mode & FMODE_WRITE) &&
-	    !(file->f_flags & O_APPEND))
+	    (file->f_flags & O_TRUNC))
 		ftrace_filter_reset(enable);
 
 	if (file->f_mode & FMODE_READ) {
@@ -2527,7 +2527,7 @@ ftrace_graph_open(struct inode *inode, struct file *file)
 
 	mutex_lock(&graph_lock);
 	if ((file->f_mode & FMODE_WRITE) &&
-	    !(file->f_flags & O_APPEND)) {
+	    (file->f_flags & O_TRUNC)) {
 		ftrace_graph_count = 0;
 		memset(ftrace_graph_funcs, 0, sizeof(ftrace_graph_funcs));
 	}
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 38a4a3e..3a522a0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2031,7 +2031,7 @@ static int tracing_open(struct inode *inode, struct file *file)
 
 	/* If this file was open for write, then erase contents */
 	if ((file->f_mode & FMODE_WRITE) &&
-	    !(file->f_flags & O_APPEND)) {
+	    (file->f_flags & O_TRUNC)) {
 		long cpu = (long) inode->i_private;
 
 		if (cpu == TRACE_PIPE_ALL_CPU)
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 90cf936..90cdec5 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -378,7 +378,7 @@ ftrace_event_seq_open(struct inode *inode, struct file *file)
 	const struct seq_operations *seq_ops;
 
 	if ((file->f_mode & FMODE_WRITE) &&
-	    !(file->f_flags & O_APPEND))
+	    (file->f_flags & O_TRUNC))
 		ftrace_clear_events();
 
 	seq_ops = inode->i_private;
-- 
1.6.3.3

-- 
