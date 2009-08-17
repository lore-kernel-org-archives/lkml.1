Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbZHQI47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbZHQI47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbZHQI46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:56:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57027 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757401AbZHQI45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:56:57 -0400
Message-ID: <4A891A91.4030602@cn.fujitsu.com>
Date: Mon, 17 Aug 2009 16:53:37 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] trace_stack: Simplify seqfile code
References: <4A891A65.70009@cn.fujitsu.com>
In-Reply-To: <4A891A65.70009@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract duplicate code in t_start() and t_next().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_stack.c |   34 ++++++++++++----------------------
 1 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 0da1cff..0f6facb 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -186,43 +186,33 @@ static const struct file_operations stack_max_size_fops = {
 };
 
 static void *
-t_next(struct seq_file *m, void *v, loff_t *pos)
+__next(struct seq_file *m, loff_t *pos)
 {
-	long i;
+	long n = *pos - 1;
 
-	(*pos)++;
-
-	if (v == SEQ_START_TOKEN)
-		i = 0;
-	else {
-		i = *(long *)v;
-		i++;
-	}
-
-	if (i >= max_stack_trace.nr_entries ||
-	    stack_dump_trace[i] == ULONG_MAX)
+	if (n >= max_stack_trace.nr_entries || stack_dump_trace[n] == ULONG_MAX)
 		return NULL;
 
-	m->private = (void *)i;
-
+	m->private = (void *)n;
 	return &m->private;
 }
 
-static void *t_start(struct seq_file *m, loff_t *pos)
+static void *
+t_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	void *t = SEQ_START_TOKEN;
-	loff_t l = 0;
+	(*pos)++;
+	return __next(m, pos);
+}
 
+static void *t_start(struct seq_file *m, loff_t *pos)
+{
 	local_irq_disable();
 	__raw_spin_lock(&max_stack_lock);
 
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	for (; t && l < *pos; t = t_next(m, t, &l))
-		;
-
-	return t;
+	return __next(m, pos);
 }
 
 static void t_stop(struct seq_file *m, void *p)
-- 
1.6.3

