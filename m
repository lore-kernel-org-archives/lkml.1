Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbYFAQS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbYFAQS5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYFAQS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:18:28 -0400
Received: from hu-out-0506.google.com ([72.14.214.224]:12878 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbYFAQS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:18:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=IYlc30HiRwpaugNo1VW6qOmh6Op+5yShsEBRsOgaNNbSD/xhzh5e9TOMv/z1Xxx9WH0kP5KLg/iWUDPjdZBhKSuT83eB0P3WBYGelJW5+lLN5+FgMa3wp6n3UlUZes7wbbI37HFzvBAtOycLvAwmFt1QPuMvpVuHUnKFhIu226Y=
Message-ID: <4842CBB2.9040401@gmail.com>
Date: Sun, 01 Jun 2008 21:47:54 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] ftrace: add debugfs entry 'failures'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Identify functions which had their mcount call-site updates failed. This can
help us track functions which ftrace shouldn't fiddle with, and are thus not
being traced. If there is no race with any external agent which is modifying
the mcount call-site, then this file displays no entries (normal case).

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2b287ea..0119d62 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -743,6 +743,7 @@ enum {
 	FTRACE_ITER_FILTER	= (1 << 0),
 	FTRACE_ITER_CONT	= (1 << 1),
 	FTRACE_ITER_NOTRACE	= (1 << 2),
+	FTRACE_ITER_FAILURES	= (1 << 3),
 };
 
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
@@ -774,9 +775,16 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		}
 	} else {
 		rec = &iter->pg->records[iter->idx++];
-		if ((rec->flags & FTRACE_FL_FAILED) ||
+		if ((!(iter->flags & FTRACE_ITER_FAILURES) &&
+		     (rec->flags & FTRACE_FL_FAILED)) ||
+
+		    ((iter->flags & FTRACE_ITER_FAILURES) &&
+		     (!(rec->flags & FTRACE_FL_FAILED) ||
+		      (rec->flags & FTRACE_FL_FREE))) ||
+
 		    ((iter->flags & FTRACE_ITER_FILTER) &&
 		     !(rec->flags & FTRACE_FL_FILTER)) ||
+
 		    ((iter->flags & FTRACE_ITER_NOTRACE) &&
 		     !(rec->flags & FTRACE_FL_NOTRACE))) {
 			rec = NULL;
@@ -871,6 +879,24 @@ int ftrace_avail_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int
+ftrace_failures_open(struct inode *inode, struct file *file)
+{
+	int ret;
+	struct seq_file *m;
+	struct ftrace_iterator *iter;
+
+	ret = ftrace_avail_open(inode, file);
+	if (!ret) {
+		m = (struct seq_file *)file->private_data;
+		iter = (struct ftrace_iterator *)m->private;
+		iter->flags = FTRACE_ITER_FAILURES;
+	}
+
+	return ret;
+}
+
+
 static void ftrace_filter_reset(int enable)
 {
 	struct ftrace_page *pg;
@@ -1235,6 +1261,13 @@ static struct file_operations ftrace_avail_fops = {
 	.release = ftrace_avail_release,
 };
 
+static struct file_operations ftrace_failures_fops = {
+	.open = ftrace_failures_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = ftrace_avail_release,
+};
+
 static struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
 	.read = ftrace_regex_read,
@@ -1329,6 +1362,11 @@ static __init int ftrace_init_debugfs(void)
 		pr_warning("Could not create debugfs "
 			   "'available_filter_functions' entry\n");
 
+	entry = debugfs_create_file("failures", 0444,
+				    d_tracer, NULL, &ftrace_failures_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'failures' entry\n");
+
 	entry = debugfs_create_file("set_ftrace_filter", 0644, d_tracer,
 				    NULL, &ftrace_filter_fops);
 	if (!entry)
