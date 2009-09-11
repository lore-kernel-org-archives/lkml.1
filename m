Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbZIKTch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbZIKTch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbZIKTcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:32:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38254 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbZIKTce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:32:34 -0400
Message-Id: <20090911193237.064765399@goodmis.org>
References: <20090911193153.444303577@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 15:31:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/6] tracing: trace parser support for set_event
Content-Disposition: inline; filename=0005-tracing-trace-parser-support-for-set_event.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jolsa@redhat.com <jolsa@redhat.com>

Convert the parsing of the file 'set_event' to use the generic
trace_praser 'trace_get_user' function.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <1252682969-3366-3-git-send-email-jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   60 +++++++++---------------------------------
 1 files changed, 13 insertions(+), 47 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 975f324..f46d14c 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -230,11 +230,9 @@ static ssize_t
 ftrace_event_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
+	struct trace_parser parser;
 	size_t read = 0;
-	int i, set = 1;
 	ssize_t ret;
-	char *buf;
-	char ch;
 
 	if (!cnt || cnt < 0)
 		return 0;
@@ -243,60 +241,28 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
 	if (ret < 0)
 		return ret;
 
-	ret = get_user(ch, ubuf++);
-	if (ret)
-		return ret;
-	read++;
-	cnt--;
-
-	/* skip white space */
-	while (cnt && isspace(ch)) {
-		ret = get_user(ch, ubuf++);
-		if (ret)
-			return ret;
-		read++;
-		cnt--;
-	}
-
-	/* Only white space found? */
-	if (isspace(ch)) {
-		file->f_pos += read;
-		ret = read;
-		return ret;
-	}
-
-	buf = kmalloc(EVENT_BUF_SIZE+1, GFP_KERNEL);
-	if (!buf)
+	if (trace_parser_get_init(&parser, EVENT_BUF_SIZE + 1))
 		return -ENOMEM;
 
-	if (cnt > EVENT_BUF_SIZE)
-		cnt = EVENT_BUF_SIZE;
+	read = trace_get_user(&parser, ubuf, cnt, ppos);
+
+	if (trace_parser_loaded((&parser))) {
+		int set = 1;
 
-	i = 0;
-	while (cnt && !isspace(ch)) {
-		if (!i && ch == '!')
+		if (*parser.buffer == '!')
 			set = 0;
-		else
-			buf[i++] = ch;
 
-		ret = get_user(ch, ubuf++);
+		parser.buffer[parser.idx] = 0;
+
+		ret = ftrace_set_clr_event(parser.buffer + !set, set);
 		if (ret)
-			goto out_free;
-		read++;
-		cnt--;
+			goto out_put;
 	}
-	buf[i] = 0;
-
-	file->f_pos += read;
-
-	ret = ftrace_set_clr_event(buf, set);
-	if (ret)
-		goto out_free;
 
 	ret = read;
 
- out_free:
-	kfree(buf);
+ out_put:
+	trace_parser_put(&parser);
 
 	return ret;
 }
-- 
1.6.3.3

-- 
