Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbZFXJqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbZFXJqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZFXJq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:46:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:37569 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758010AbZFXJqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:46:25 -0400
Date: Wed, 24 Jun 2009 09:45:48 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, liming.wang@windriver.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, liming.wang@windriver.com,
       mingo@elte.hu
In-Reply-To: <4A4186FA.1020106@cn.fujitsu.com>
References: <4A4186FA.1020106@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing_bprintk: Don't increment @pos in t_start()
Message-ID: <tip-c8961ec6da22ea010bf4470a8e0fb3fdad0f11c4@git.kernel.org>
Git-Commit-ID: c8961ec6da22ea010bf4470a8e0fb3fdad0f11c4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 09:45:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8961ec6da22ea010bf4470a8e0fb3fdad0f11c4
Gitweb:     http://git.kernel.org/tip/c8961ec6da22ea010bf4470a8e0fb3fdad0f11c4
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 24 Jun 2009 09:52:58 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 24 Jun 2009 11:02:50 +0200

tracing_bprintk: Don't increment @pos in t_start()

It's wrong to increment @pos in t_start(), otherwise we'll lose
some entries when reading printk_formats, if the output is larger
than PAGE_SIZE.

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reviewed-by: Liming Wang <liming.wang@windriver.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A4186FA.1020106@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_printk.c |   26 ++++++--------------------
 1 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 9bece96..7b62781 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -155,25 +155,19 @@ int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
 EXPORT_SYMBOL_GPL(__ftrace_vprintk);
 
 static void *
-t_next(struct seq_file *m, void *v, loff_t *pos)
+t_start(struct seq_file *m, loff_t *pos)
 {
-	const char **fmt = m->private;
-	const char **next = fmt;
-
-	(*pos)++;
+	const char **fmt = __start___trace_bprintk_fmt + *pos;
 
 	if ((unsigned long)fmt >= (unsigned long)__stop___trace_bprintk_fmt)
 		return NULL;
-
-	next = fmt;
-	m->private = ++next;
-
 	return fmt;
 }
 
-static void *t_start(struct seq_file *m, loff_t *pos)
+static void *t_next(struct seq_file *m, void * v, loff_t *pos)
 {
-	return t_next(m, NULL, pos);
+	(*pos)++;
+	return t_start(m, pos);
 }
 
 static int t_show(struct seq_file *m, void *v)
@@ -224,15 +218,7 @@ static const struct seq_operations show_format_seq_ops = {
 static int
 ftrace_formats_open(struct inode *inode, struct file *file)
 {
-	int ret;
-
-	ret = seq_open(file, &show_format_seq_ops);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-
-		m->private = __start___trace_bprintk_fmt;
-	}
-	return ret;
+	return seq_open(file, &show_format_seq_ops);
 }
 
 static const struct file_operations ftrace_formats_fops = {
