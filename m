Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbZIVIk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbZIVIk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbZIVIk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:40:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:42218 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbZIVIk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:40:26 -0400
Date: Tue, 22 Sep 2009 08:39:50 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, jolsa@redhat.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, jolsa@redhat.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AB86614.7020803@cn.fujitsu.com>
References: <4AB86614.7020803@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Check the return value of trace_get_user()
Message-ID: <tip-4ba7978e98a3ff92cebfb0f31a02c309e3ffa1fe@git.kernel.org>
Git-Commit-ID: 4ba7978e98a3ff92cebfb0f31a02c309e3ffa1fe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 08:39:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ba7978e98a3ff92cebfb0f31a02c309e3ffa1fe
Gitweb:     http://git.kernel.org/tip/4ba7978e98a3ff92cebfb0f31a02c309e3ffa1fe
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 22 Sep 2009 13:52:20 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 10:28:55 +0200

tracing: Check the return value of trace_get_user()

Return immediately if trace_get_user() returned failure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4AB86614.7020803@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c       |    9 ++++-----
 kernel/trace/trace_events.c |    7 +++----
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c71e91b..a8fe478 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2202,7 +2202,7 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	struct trace_parser *parser;
 	ssize_t ret, read;
 
-	if (!cnt || cnt < 0)
+	if (!cnt)
 		return 0;
 
 	mutex_lock(&ftrace_regex_lock);
@@ -2216,7 +2216,7 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	parser = &iter->parser;
 	read = trace_get_user(parser, ubuf, cnt, ppos);
 
-	if (trace_parser_loaded(parser) &&
+	if (read >= 0 && trace_parser_loaded(parser) &&
 	    !trace_parser_cont(parser)) {
 		ret = ftrace_process_regex(parser->buffer,
 					   parser->idx, enable);
@@ -2552,8 +2552,7 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
 	struct trace_parser parser;
-	size_t read = 0;
-	ssize_t ret;
+	ssize_t read, ret;
 
 	if (!cnt || cnt < 0)
 		return 0;
@@ -2572,7 +2571,7 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 
 	read = trace_get_user(&parser, ubuf, cnt, ppos);
 
-	if (trace_parser_loaded((&parser))) {
+	if (read >= 0 && trace_parser_loaded((&parser))) {
 		parser.buffer[parser.idx] = 0;
 
 		/* we allow only one expression at a time */
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 6f03c8a..d128f65 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -232,10 +232,9 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
 	struct trace_parser parser;
-	size_t read = 0;
-	ssize_t ret;
+	ssize_t read, ret;
 
-	if (!cnt || cnt < 0)
+	if (!cnt)
 		return 0;
 
 	ret = tracing_update_buffers();
@@ -247,7 +246,7 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
 
 	read = trace_get_user(&parser, ubuf, cnt, ppos);
 
-	if (trace_parser_loaded((&parser))) {
+	if (read >= 0 && trace_parser_loaded((&parser))) {
 		int set = 1;
 
 		if (*parser.buffer == '!')
