Return-Path: <linux-kernel-owner+w=401wt.eu-S1752112AbZBZTAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbZBZTAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZBZS7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:59:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48034 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZBZS7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:59:05 -0500
Message-Id: <20090226185901.508760454@goodmis.org>
References: <20090226185419.371469287@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 26 Feb 2009 13:54:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 4/6] tracing: convert event_trace to use copy_strtok_from_user
Content-Disposition: inline; filename=0004-tracing-convert-event_trace-to-use-copy_strtok_from.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

This patch converts the open coded retrieving of a word from user
space to use copy_strtok_from_user.

Also removed a cnt < 0 check that Andrew Morton pointed out saying
that it was irrelevant since cnt is unsigned.

Also changed file->pos += to (*ppos) += which is the proper way
to modify positions of the file.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.h        |    2 +
 kernel/trace/trace_events.c |   69 +++++++++++++++---------------------------
 2 files changed, 27 insertions(+), 44 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6321917..e75b673 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -720,4 +720,6 @@ static inline void trace_branch_disable(void)
 }
 #endif /* CONFIG_BRANCH_TRACER */
 
+#define SPACES	" \t\r\n"
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3bcb9df..9e71755 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -80,62 +80,43 @@ static ssize_t
 ftrace_event_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
-	size_t read = 0;
-	int i, set = 1;
+	unsigned int copied;
+	size_t read;
 	ssize_t ret;
+	int set = 1;
 	char *buf;
-	char ch;
 
-	if (!cnt || cnt < 0)
+	if (!cnt)
 		return 0;
 
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
 	buf = kmalloc(EVENT_BUF_SIZE+1, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	if (cnt > EVENT_BUF_SIZE)
-		cnt = EVENT_BUF_SIZE;
-
-	i = 0;
-	while (cnt && !isspace(ch)) {
-		if (!i && ch == '!')
-			set = 0;
-		else
-			buf[i++] = ch;
-
-		ret = get_user(ch, ubuf++);
-		if (ret)
-			goto out_free;
-		read++;
-		cnt--;
+	ret = copy_strtok_from_user(buf, ubuf, EVENT_BUF_SIZE,
+				    cnt, &copied, SPACES);
+	if (ret < 0)
+		goto out_free;
+
+	if (!copied) {
+		ret = cnt;
+		(*ppos) += cnt;
+
+		/* TODO, handle split words */
+		goto out_free;
 	}
-	buf[i] = 0;
 
-	file->f_pos += read;
+	if (buf[0] == '!')
+		set = 0;
+
+	(*ppos) += ret;
+	read = ret;
 
-	ret = ftrace_set_clr_event(buf, set);
+	/*
+	 * A little hack here. If set is true, we want to use buf.
+	 * Otherwise, we want to use buf+1 (to skip the '!').
+	 */
+	ret = ftrace_set_clr_event(buf + !set, set);
 	if (ret)
 		goto out_free;
 
-- 
1.5.6.5

-- 
