Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYKUDP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYKUDP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 22:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYKUDPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 22:15:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:50988 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbYKUDPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 22:15:15 -0500
From: Liming Wang <liming.wang@windriver.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Liming Wang <liming.wang@windriver.com>
Subject: [PATCH 1/1] function tracing: fix wrong position computing of stack_trace
Date: Fri, 21 Nov 2008 11:00:18 +0800
Message-Id: <1227236418-6023-2-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1227236418-6023-1-git-send-email-liming.wang@windriver.com>
References: <1227236418-6023-1-git-send-email-liming.wang@windriver.com>
X-OriginalArrivalTime: 21 Nov 2008 03:15:02.0904 (UTC) FILETIME=[5830EF80:01C94B87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: make output of stack_trace complete if buffer overflow

When read buffer overflows, the output of stack_trace isn't complete.

When printing records with seq_printf in t_show, if the read buffer
has overflowed by the current record, then this record won't be printed
to user space through read buffer, it will just be dropped in this printing.

When next printing, t_start should return the "*pos"th record, which is the one
dropped by previous printing, but it just returns (m->private + *pos)th record.

Here we use a more sane method to implement seq_operations which can be found
in kernel code. Thus we needn't initialize m->private.

About testing, it's not easy to overflow read buffer, but we can use
seq_printf to print more padding bytes in t_show, then it's easy to check
whether or not records are lost.

This commit has been tested on both condition of overflow and non overflow.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
---
 kernel/trace/trace_stack.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index d39e8b7..7801052 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -180,11 +180,16 @@ static struct file_operations stack_max_size_fops = {
 static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	long i = (long)m->private;
+	long i;
 
 	(*pos)++;
 
-	i++;
+	if (v == SEQ_START_TOKEN )
+		i = 0;
+	else {
+		i = *(long *)v;
+		i++;
+	}
 
 	if (i >= max_stack_trace.nr_entries ||
 	    stack_dump_trace[i] == ULONG_MAX)
@@ -197,12 +202,15 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
-	void *t = &m->private;
+	void *t = SEQ_START_TOKEN;
 	loff_t l = 0;
 
 	local_irq_disable();
 	__raw_spin_lock(&max_stack_lock);
 
+	if (*pos == 0)
+		return SEQ_START_TOKEN;
+
 	for (; t && l < *pos; t = t_next(m, t, &l))
 		;
 
@@ -231,10 +239,10 @@ static int trace_lookup_stack(struct seq_file *m, long i)
 
 static int t_show(struct seq_file *m, void *v)
 {
-	long i = *(long *)v;
+	long i;
 	int size;
 
-	if (i < 0) {
+	if (v == SEQ_START_TOKEN ) {
 		seq_printf(m, "        Depth   Size      Location"
 			   "    (%d entries)\n"
 			   "        -----   ----      --------\n",
@@ -242,6 +250,8 @@ static int t_show(struct seq_file *m, void *v)
 		return 0;
 	}
 
+	i = *(long *)v;
+
 	if (i >= max_stack_trace.nr_entries ||
 	    stack_dump_trace[i] == ULONG_MAX)
 		return 0;
@@ -271,10 +281,6 @@ static int stack_trace_open(struct inode *inode, struct file *file)
 	int ret;
 
 	ret = seq_open(file, &stack_trace_seq_ops);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		m->private = (void *)-1;
-	}
 
 	return ret;
 }
-- 
1.6.0.3

