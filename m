Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZIVFxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZIVFxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbZIVFxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:53:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59236 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbZIVFxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:53:31 -0400
Message-ID: <4AB86614.7020803@cn.fujitsu.com>
Date: Tue, 22 Sep 2009 13:52:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] tracing: check the return value of trace_get_user()
References: <4AB865FA.5080801@cn.fujitsu.com>
In-Reply-To: <4AB865FA.5080801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return immediately if trace_get_user() returned failure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.6.3

