Return-Path: <linux-kernel-owner+w=401wt.eu-S1761242AbZBZFkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761242AbZBZFkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbZBZFii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:38:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44756 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbZBZFif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:38:35 -0500
Message-Id: <20090226053832.771105053@goodmis.org>
References: <20090226053240.607719846@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 26 Feb 2009 00:32:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 5/5] tracing: convert ftrace_graph_write to use copy_strtok_from_user
Content-Disposition: inline; filename=0005-tracing-convert-ftrace_graph_write-to-use-copy_strt.patch
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
 kernel/trace/ftrace.c |   52 +++++++++++++++++-------------------------------
 1 files changed, 19 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4ecce15..6204b3c 100644
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
+	ret = copy_strtok_from_user(buffer, ubuf, FTRACE_BUFF_MAX,
+				    cnt, &copied, 1, SPACES);
 
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
