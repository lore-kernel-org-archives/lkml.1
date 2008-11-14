Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYKNRkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYKNRkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYKNRkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:40:22 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:1890 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYKNRkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:40:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jZUTciYNrzbQx+tqwQ7gwAz388gKI/6BTyV0GPxbqWLqVhhKrwX6PCDERLCmq7YAjK
         94r3or+laDEosO+tUmE09ra6AtPmJT29shxzdyOAmtMowtKR0JbppSzxd4UOsmRwft/g
         yB6KlrSaNXfMBRHBLSKKQxl7QW4XRG+66erfw=
From: walimis <walimisdev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ftrace: fix wrong pos computing when read buffer has been fulfilled.
Date: Sat, 15 Nov 2008 01:40:11 +0800
Message-Id: <1226684411-14281-1-git-send-email-walimisdev@gmail.com>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

phenomenon:

The first value of dyn_ftrace_total_info is not equal with
`cat available_filter_functions | wc -l`, but they should be equal.

root cause:

When printing functions with seq_printf in t_show, if the read buffer
is just overflowed by current function record, then this function
won't be printed to user space through read buffer, it will
just be dropped. So we can't see this function printing.
So, every time the last function to fill the read buffer, if overflowed,
will be dropped.
This also applies to set_ftrace_filter if set_ftrace_filter has
more bytes than read buffer.

fix:

Through checking return value of seq_printf, if less than 0, we know
this function doesn't be printed. Then we decrease position to force
this function to be printed next time, in next read buffer.

another little fix is to show correct allocating pages count.

Signed-off-by: walimis <walimisdev@gmail.com>
---
 kernel/trace/ftrace.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index beb21a5..b47718b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -700,7 +700,7 @@ static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
 
 	cnt = num_to_init / ENTRIES_PER_PAGE;
 	pr_info("ftrace: allocating %ld entries in %d pages\n",
-		num_to_init, cnt);
+		num_to_init, cnt + 1);
 
 	for (i = 0; i < cnt; i++) {
 		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
@@ -783,13 +783,11 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	void *p = NULL;
 	loff_t l = -1;
 
-	if (*pos != iter->pos) {
-		for (p = t_next(m, p, &l); p && l < *pos; p = t_next(m, p, &l))
-			;
-	} else {
-		l = *pos;
-		p = t_next(m, p, &l);
+	if (*pos > iter->pos) {
+		*pos=iter->pos;
 	}
+	l = *pos;
+	p = t_next(m, p, &l);
 
 	return p;
 }
@@ -800,15 +798,21 @@ static void t_stop(struct seq_file *m, void *p)
 
 static int t_show(struct seq_file *m, void *v)
 {
+	struct ftrace_iterator *iter = m->private;
 	struct dyn_ftrace *rec = v;
 	char str[KSYM_SYMBOL_LEN];
+	int ret = 0;
 
 	if (!rec)
 		return 0;
 
 	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
 
-	seq_printf(m, "%s\n", str);
+	ret = seq_printf(m, "%s\n", str);
+	if (ret < 0) {
+		iter->pos--;
+		iter->idx--;
+	}
 
 	return 0;
 }
@@ -834,7 +838,7 @@ ftrace_avail_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	iter->pg = ftrace_pages_start;
-	iter->pos = -1;
+	iter->pos = 0;
 
 	ret = seq_open(file, &show_ftrace_seq_ops);
 	if (!ret) {
@@ -921,7 +925,7 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 
 	if (file->f_mode & FMODE_READ) {
 		iter->pg = ftrace_pages_start;
-		iter->pos = -1;
+		iter->pos = 0;
 		iter->flags = enable ? FTRACE_ITER_FILTER :
 			FTRACE_ITER_NOTRACE;
 
-- 
1.6.0.3

