Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbZILHzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbZILHzJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZILHzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:55:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:38974 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZILHzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:55:06 -0400
Date: Sat, 12 Sep 2009 07:54:49 GMT
From: "tip-bot for jolsa@redhat.com" <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1252682969-3366-3-git-send-email-jolsa@redhat.com>
References: <1252682969-3366-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: trace parser support for set_event
Message-ID: <tip-489663644c35d50a20f58d468a7cbc705e6a29ce@git.kernel.org>
Git-Commit-ID: 489663644c35d50a20f58d468a7cbc705e6a29ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 12 Sep 2009 07:54:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  489663644c35d50a20f58d468a7cbc705e6a29ce
Gitweb:     http://git.kernel.org/tip/489663644c35d50a20f58d468a7cbc705e6a29ce
Author:     jolsa@redhat.com <jolsa@redhat.com>
AuthorDate: Fri, 11 Sep 2009 17:29:28 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 11 Sep 2009 14:47:11 -0400

tracing: trace parser support for set_event

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
