Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbZFSGqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbZFSGqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 02:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZFSGqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 02:46:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51114 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbZFSGqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 02:46:24 -0400
Message-ID: <4A3B34A9.30602@cn.fujitsu.com>
Date: Fri, 19 Jun 2009 14:48:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] tracing: reset iterator in t_start()
References: <4A3B3372.4040608@cn.fujitsu.com>
In-Reply-To: <4A3B3372.4040608@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iterator is m->private, but it's not reset to trace_types in
t_start(). If the output is larger than PAGE_SIZE and t_start()
is called the 2nd time, things will go wrong.

[ Impact: fix output of current_tracer when it's larger than PAGE_SIZE ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 076fa6f..3bb3100 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2053,25 +2053,23 @@ static int tracing_open(struct inode *inode, struct file *file)
 static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct tracer *t = m->private;
+	struct tracer *t = v;
 
 	(*pos)++;
 
 	if (t)
 		t = t->next;
 
-	m->private = t;
-
 	return t;
 }
 
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
-	struct tracer *t = m->private;
+	struct tracer *t;
 	loff_t l = 0;
 
 	mutex_lock(&trace_types_lock);
-	for (; t && l < *pos; t = t_next(m, t, &l))
+	for (t = trace_types; t && l < *pos; t = t_next(m, t, &l))
 		;
 
 	return t;
@@ -2107,18 +2105,10 @@ static struct seq_operations show_traces_seq_ops = {
 
 static int show_traces_open(struct inode *inode, struct file *file)
 {
-	int ret;
-
 	if (tracing_disabled)
 		return -ENODEV;
 
-	ret = seq_open(file, &show_traces_seq_ops);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		m->private = trace_types;
-	}
-
-	return ret;
+	return seq_open(file, &show_traces_seq_ops);
 }
 
 static ssize_t
-- 
1.5.4.rc3

