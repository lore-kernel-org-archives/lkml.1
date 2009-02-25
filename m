Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbZBYUe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbZBYUe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758930AbZBYUec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:34:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63682 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977AbZBYUea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:34:30 -0500
Message-Id: <20090225203427.998866064@goodmis.org>
References: <20090225203007.582030664@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 15:30:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/4] tracing: convert ftrace_graph_write to use copy_word_from_user
Content-Disposition: inline; filename=0004-tracing-convert-ftrace_graph_write-to-use-copy_word.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

This removes the open coded parsing of a word sent in by the user
and replaces it with copy_word_from_user.

Also removes cnt < 0 check since cnt is unsigned.

Also uses (*ppos) += cnt, instead of file->pos += cnt.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   52 +++++++++++++++++-------------------------------
 1 files changed, 19 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index aaa541d..a84915b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2079,10 +2079,9 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 	unsigned long *array;
 	size_t read = 0;
 	ssize_t ret;
-	int index = 0;
-	char ch;
+	int copied;
 
-	if (!cnt || cnt < 0)
+	if (!cnt)
 		return 0;
 
 	mutex_lock(&graph_lock);
@@ -2098,48 +2097,35 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 	} else
 		array = file->private_data;
 
-	ret = get_user(ch, ubuf++);
-	if (ret)
-		goto out;
-	read++;
-	cnt--;
+	ret = copy_word_from_user(buffer, ubuf, FTRACE_BUFF_MAX,
+				  cnt, &copied, 1);
 
-	/* skip white space */
-	while (cnt && isspace(ch)) {
-		ret = get_user(ch, ubuf++);
-		if (ret)
+	if (ret == -EAGAIN) {
+		if (copied) {
+			/* This do not deal with split words */
+			ret = -EINVAL;
 			goto out;
-		read++;
-		cnt--;
-	}
+		}
 
-	if (isspace(ch)) {
-		*ppos += read;
-		ret = read;
+		/* Just white space */
+		(*ppos) += cnt;
+		ret = cnt;
 		goto out;
 	}
 
-	while (cnt && !isspace(ch)) {
-		if (index < FTRACE_BUFF_MAX)
-			buffer[index++] = ch;
-		else {
-			ret = -EINVAL;
-			goto out;
-		}
-		ret = get_user(ch, ubuf++);
-		if (ret)
-			goto out;
-		read++;
-		cnt--;
-	}
-	buffer[index] = 0;
+	if (ret < 0)
+		goto out;
+
+	read = ret;
+
+	buffer[copied] = 0;
 
 	/* we allow only one expression at a time */
 	ret = ftrace_set_func(array, &ftrace_graph_count, buffer);
 	if (ret)
 		goto out;
 
-	file->f_pos += read;
+	(*ppos) += read;
 
 	ret = read;
  out:
-- 
1.5.6.5

-- 
