Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbZIDNbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbZIDNbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 09:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbZIDNba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 09:31:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803AbZIDNbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 09:31:24 -0400
From: jolsa@redhat.com
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] tracing - adding common method for reading/parsing user input
Date: Fri,  4 Sep 2009 15:31:12 +0200
Message-Id: <1252071073-27134-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1252071073-27134-1-git-send-email-jolsa@redhat.com>
References: <1252071073-27134-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated 'set_event' write method to use the 'trace_get_user' function.

wbr,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>

---
 kernel/trace/trace_events.c |   58 +++++++++---------------------------------
 1 files changed, 13 insertions(+), 45 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index d33bcde..7e5703c 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -230,11 +230,9 @@ static ssize_t
 ftrace_event_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
+	struct trace_biter biter;
 	size_t read = 0;
-	int i, set = 1;
 	ssize_t ret;
-	char *buf;
-	char ch;
 
 	if (!cnt || cnt < 0)
 		return 0;
@@ -243,60 +241,30 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
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
+	if (trace_biter_alloc(&biter, EVENT_BUF_SIZE + 1))
 		return -ENOMEM;
 
-	if (cnt > EVENT_BUF_SIZE)
-		cnt = EVENT_BUF_SIZE;
+	read = trace_get_user(&biter, ubuf, cnt, ppos);
+
+	if (TRACE_BITER_LOADED((&biter))) {
+		char *buf = biter.buffer;
+		int set = 1;
 
-	i = 0;
-	while (cnt && !isspace(ch)) {
-		if (!i && ch == '!')
+		if (*buf == '!') {
 			set = 0;
-		else
-			buf[i++] = ch;
+			buf++;
+		}
+		biter.buffer[biter.idx] = 0;
 
-		ret = get_user(ch, ubuf++);
+		ret = ftrace_set_clr_event(buf, set);
 		if (ret)
 			goto out_free;
-		read++;
-		cnt--;
 	}
-	buf[i] = 0;
-
-	file->f_pos += read;
-
-	ret = ftrace_set_clr_event(buf, set);
-	if (ret)
-		goto out_free;
 
 	ret = read;
 
  out_free:
-	kfree(buf);
+	trace_biter_free(&biter);
 
 	return ret;
 }
-- 
1.6.2.5

