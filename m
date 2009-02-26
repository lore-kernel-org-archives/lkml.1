Return-Path: <linux-kernel-owner+w=401wt.eu-S1760911AbZBZFj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbZBZFj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZBZFih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:38:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62686 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbZBZFif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:38:35 -0500
Message-Id: <20090226053832.533613534@goodmis.org>
References: <20090226053240.607719846@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 26 Feb 2009 00:32:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 4/5] tracing: convert ftrace_regex_write to use copy_strtok_from_user
Content-Disposition: inline; filename=0004-tracing-convert-ftrace_regex_write-to-use-copy_strt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

This removes the open coded parsing of a word sent in by the user
and replaces it with copy_strtok_from_user.

Also removes cnt < 0 check since cnt is unsigned.

Also uses (*ppos) += cnt, instead of file->pos += cnt.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |  103 ++++++++++++++++++++++++++++---------------------
 1 files changed, 59 insertions(+), 44 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5a3a06b..4ecce15 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1690,11 +1690,13 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos, int enable)
 {
 	struct ftrace_iterator *iter;
-	char ch;
+	unsigned int copied;
 	size_t read = 0;
+	int len, skip;
 	ssize_t ret;
+	char *buf;
 
-	if (!cnt || cnt < 0)
+	if (!cnt)
 		return 0;
 
 	mutex_lock(&ftrace_regex_lock);
@@ -1710,58 +1712,71 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 		iter->buffer_idx = 0;
 	}
 
-	ret = get_user(ch, ubuf++);
-	if (ret)
-		goto out;
-	read++;
-	cnt--;
+	if (iter->flags & FTRACE_ITER_CONT) {
+		/*
+		 * We split on a word, continue from where
+		 * we left off.
+		*/
+		buf = &iter->buffer[iter->buffer_idx];
+		len = FTRACE_BUFF_MAX - iter->buffer_idx;
+		/* Stop on leading spaces */
+		skip = 0;
+	} else {
+		buf = iter->buffer;
+		/* iter->buffer is size of FTRACE_BUF_MAX + 1 */
+		len = FTRACE_BUFF_MAX;
+		iter->buffer_idx = 0;
+		/* Skip over any leading spaces */
+		skip = 1;
+	}
 
-	if (!(iter->flags & ~FTRACE_ITER_CONT)) {
-		/* skip white space */
-		while (cnt && isspace(ch)) {
-			ret = get_user(ch, ubuf++);
-			if (ret)
+	ret = copy_strtok_from_user(buf, ubuf, len, cnt, &copied, skip, SPACES);
+
+	if (ret == -EAGAIN) {
+		if (copied) {
+			/* we split on a word */
+			iter->buffer_idx += copied;
+			if (iter->buffer_idx >= FTRACE_BUFF_MAX) {
+				/* too big of a word */
+				iter->buffer_idx = 0;
+				iter->flags &= ~FTRACE_ITER_CONT;
+				ret = -EINVAL;
 				goto out;
-			read++;
-			cnt--;
-		}
+			}
 
-		if (isspace(ch)) {
-			file->f_pos += read;
-			ret = read;
+			(*ppos) += cnt;
+			ret = cnt;
+			iter->flags |= FTRACE_ITER_CONT;
 			goto out;
 		}
-
-		iter->buffer_idx = 0;
-	}
-
-	while (cnt && !isspace(ch)) {
-		if (iter->buffer_idx < FTRACE_BUFF_MAX)
-			iter->buffer[iter->buffer_idx++] = ch;
-		else {
-			ret = -EINVAL;
+		/* We only read white space. */
+		if (!(iter->flags & FTRACE_ITER_CONT)) {
+			(*ppos) += cnt;
+			ret = cnt;
 			goto out;
 		}
-		ret = get_user(ch, ubuf++);
-		if (ret)
-			goto out;
-		read++;
-		cnt--;
+
+		/*
+		 * We read white space but we are also at the end
+		 * of a word in the buffer. Continue processing.
+		 */
+		ret = cnt;
 	}
 
-	if (isspace(ch)) {
-		iter->filtered++;
-		iter->buffer[iter->buffer_idx] = 0;
-		ret = ftrace_process_regex(iter->buffer,
-					   iter->buffer_idx, enable);
-		if (ret)
-			goto out;
-		iter->buffer_idx = 0;
-	} else
-		iter->flags |= FTRACE_ITER_CONT;
+	if (ret < 0)
+		goto out;
 
+	/* NULL terminate the string */
+	buf[copied] = 0;
 
-	file->f_pos += read;
+	read = ret;
+
+	ret = ftrace_process_regex(iter->buffer, iter->buffer_idx, enable);
+	if (ret)
+		goto out;
+	iter->buffer_idx = 0;
+
+	(*ppos) += read;
 
 	ret = read;
  out:
-- 
1.5.6.5

-- 
