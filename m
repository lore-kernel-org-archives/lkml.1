Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYK1E3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYK1E3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 23:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYK1E2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 23:28:55 -0500
Received: from mail.windriver.com ([147.11.1.11]:57304 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbYK1E2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 23:28:54 -0500
From: Liming Wang <liming.wang@windriver.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Liming Wang <liming.wang@windriver.com>
Subject: [PATCH 1/1] ftrace: improve seq_operation of ftrace
Date: Fri, 28 Nov 2008 12:13:21 +0800
Message-Id: <1227845601-4691-1-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
X-OriginalArrivalTime: 28 Nov 2008 04:28:36.0169 (UTC) FILETIME=[C797FB90:01C95111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: make position computing more sane

First remove useless ->pos field. Then we needn't check seq_printf
in .show like other place.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
Reviewed-by: Bruce Ashfield <bruce.ashfield@windriver.com>
---
 kernel/trace/ftrace.c |   27 ++++++++++-----------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cbf8b09..08b536a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -786,7 +786,6 @@ enum {
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
 
 struct ftrace_iterator {
-	loff_t			pos;
 	struct ftrace_page	*pg;
 	unsigned		idx;
 	unsigned		flags;
@@ -811,6 +810,8 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 			iter->pg = iter->pg->next;
 			iter->idx = 0;
 			goto retry;
+		} else {
+			iter->idx = -1;
 		}
 	} else {
 		rec = &iter->pg->records[iter->idx++];
@@ -833,8 +834,6 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 	}
 	spin_unlock(&ftrace_lock);
 
-	iter->pos = *pos;
-
 	return rec;
 }
 
@@ -842,13 +841,15 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 {
 	struct ftrace_iterator *iter = m->private;
 	void *p = NULL;
-	loff_t l = -1;
 
-	if (*pos > iter->pos)
-		*pos = iter->pos;
+	if (*pos > 0) {
+		if (iter->idx < 0)
+			return p;
+		(*pos)--;
+		iter->idx--;
+	}
 
-	l = *pos;
-	p = t_next(m, p, &l);
+	p = t_next(m, p, pos);
 
 	return p;
 }
@@ -859,21 +860,15 @@ static void t_stop(struct seq_file *m, void *p)
 
 static int t_show(struct seq_file *m, void *v)
 {
-	struct ftrace_iterator *iter = m->private;
 	struct dyn_ftrace *rec = v;
 	char str[KSYM_SYMBOL_LEN];
-	int ret = 0;
 
 	if (!rec)
 		return 0;
 
 	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
 
-	ret = seq_printf(m, "%s\n", str);
-	if (ret < 0) {
-		iter->pos--;
-		iter->idx--;
-	}
+	seq_printf(m, "%s\n", str);
 
 	return 0;
 }
@@ -899,7 +894,6 @@ ftrace_avail_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	iter->pg = ftrace_pages_start;
-	iter->pos = 0;
 
 	ret = seq_open(file, &show_ftrace_seq_ops);
 	if (!ret) {
@@ -986,7 +980,6 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 
 	if (file->f_mode & FMODE_READ) {
 		iter->pg = ftrace_pages_start;
-		iter->pos = 0;
 		iter->flags = enable ? FTRACE_ITER_FILTER :
 			FTRACE_ITER_NOTRACE;
 
-- 
1.6.0.3

