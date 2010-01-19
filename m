Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338Ab0ASHgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0ASHgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991Ab0ASHf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:35:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63027 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755339Ab0ASHfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:35:55 -0500
Message-ID: <4B556086.7000909@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 15:34:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 6/6] tracing: Write directly into splice page for trace_pipe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Now that the trace_seq has a separate buffer space, we can use this
feature to write directly into the splice page, instead of writing
to the trace_seq buffer and then copying it. This has shown almost
a 4% improvement in reading trace_pipe via splice:

Average timing of reading 10megs from trace_pipe before patch:

real	0m1.619s
user	0m0.002s
sys	0m1.596s

After patch:

real	0m1.561s
user    0m0.002s
sys	0m1.535s

These were the average of five runs of reading 10megs.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 74ad344..0030d4b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -544,25 +544,6 @@ ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
 	return cnt;
 }
 
-static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
-{
-	int len;
-	void *ret;
-
-	if (s->len <= s->readpos)
-		return -EBUSY;
-
-	len = s->len - s->readpos;
-	if (cnt > len)
-		cnt = len;
-	ret = memcpy(buf, s->buffer + s->readpos, cnt);
-	if (!ret)
-		return -EFAULT;
-
-	s->readpos += cnt;
-	return cnt;
-}
-
 /*
  * ftrace_max_lock is used to protect the swapping of buffers
  * when taking a max snapshot. The buffers themselves are
@@ -3280,21 +3261,18 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		if (!pages[i])
 			break;
 
-		rem = tracing_fill_pipe_page(rem, iter);
+		trace_seq_init(&iter->seq, page_address(pages[i]), PAGE_SIZE);
 
-		/* Copy the data into the page, so we can start over. */
-		ret = trace_seq_to_buffer(&iter->seq,
-					  page_address(pages[i]),
-					  iter->seq.len);
-		if (ret < 0) {
+		rem = tracing_fill_pipe_page(rem, iter);
+		if (!iter->seq.len) {
 			__free_page(pages[i]);
 			break;
 		}
+
 		partial[i].offset = 0;
 		partial[i].len = iter->seq.len;
-
-		trace_seq_reset(&iter->seq);
 	}
+	trace_seq_init(&iter->seq, iter->buffer, FTRACE_SEQ_BUFSIZE);
 
 	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();

