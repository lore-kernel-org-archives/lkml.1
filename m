Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZIKP3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZIKP3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZIKP3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:29:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446AbZIKP3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:29:41 -0400
From: jolsa@redhat.com
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv3 2/3] [PATCHv3 2/3] tracing - trace parser support for set_event
Date: Fri, 11 Sep 2009 17:29:28 +0200
Message-Id: <1252682969-3366-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1252682969-3366-1-git-send-email-jolsa@redhat.com>
References: <1252682969-3366-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated 'set_event' write method to use the 'trace_get_user' function.

wbr,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_events.c |   60 +++++++++---------------------------------
 1 files changed, 13 insertions(+), 47 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 78b1ed2..db0f75c 100644
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
1.6.2.5

