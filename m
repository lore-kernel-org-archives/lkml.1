Return-Path: <linux-kernel-owner+w=401wt.eu-S965948AbZLHT5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965948AbZLHT5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965926AbZLHT51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:57:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239AbZLHT50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:57:26 -0500
X-Authority-Analysis: v=1.0 c=1 a=8SZt-bVv9bwA:10 a=20KFwNOVAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=Q7tOuroGd9pSVVEP3cQA:9 a=bMqyXDSbIQhVsu8Koq8A:7 a=GqzjSsG7p6-IK-TaHUVK0wqFw8EA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=1JCLseEUMIDt3x-0:21 a=eeQa0qiLiz2Bz2A4:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091208195731.376084898@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Dec 2009 14:54:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/2][RFC] [PATCH 2/2] tracing: Write directly into splice page for trace_pipe
References: <20091208195405.653797300@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Write-directly-into-splice-page-for-trace_pi.patch
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

Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   32 +++++---------------------------
 1 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index df25c4f..0ee4e0e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -468,25 +468,6 @@ ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
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
@@ -3240,21 +3221,18 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
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
+	trace_seq_init(&iter->seq, &iter->buffer, FTRACE_SEQ_BUFSIZE);
 
 	trace_event_read_unlock();
 	mutex_unlock(&iter->mutex);
-- 
1.6.5


