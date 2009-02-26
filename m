Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbZBZS7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbZBZS7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZBZS7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:59:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48046 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZBZS7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:59:05 -0500
Message-Id: <20090226185901.936039304@goodmis.org>
References: <20090226185419.371469287@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 26 Feb 2009 13:54:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 6/6] tracing: convert ftrace_graph_write to use copy_strtok_from_user
Content-Disposition: inline; filename=0006-tracing-convert-ftrace_graph_write-to-use-copy_strt.patch
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
 kernel/trace/ftrace.c |   48 ++++++++++++++++--------------------------------
 1 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 963dc14..4ed0a8e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2083,10 +2083,9 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
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
@@ -2102,48 +2101,33 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 	} else
 		array = file->private_data;
 
-	ret = get_user(ch, ubuf++);
-	if (ret)
+	ret = copy_strtok_from_user(buffer, ubuf, FTRACE_BUFF_MAX + 1,
+				    cnt, &copied, SPACES);
+	if (ret < 0)
 		goto out;
-	read++;
-	cnt--;
 
-	/* skip white space */
-	while (cnt && isspace(ch)) {
-		ret = get_user(ch, ubuf++);
-		if (ret)
-			goto out;
-		read++;
-		cnt--;
+	/* We only read white space. */
+	if (!copied) {
+		(*ppos) += cnt;
+		ret = cnt;
+		goto out;
 	}
 
-	if (isspace(ch)) {
-		*ppos += read;
-		ret = read;
+	/* Check if we hit a terminating space */
+	if (buffer[copied - 1] != 0) {
+		/* This does not deal with split words */
+		ret = -EINVAL;
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
+	read = ret;
 
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
