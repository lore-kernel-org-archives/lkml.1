Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbZFXBwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbZFXBwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 21:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZFXBwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 21:52:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64966 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbZFXBwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 21:52:02 -0400
Message-ID: <4A4186FA.1020106@cn.fujitsu.com>
Date: Wed, 24 Jun 2009 09:52:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Liming Wang <liming.wang@windriver.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/7] tracing_bprintk: don't increment @pos in t_start()
References: <4A4186C6.9090706@cn.fujitsu.com>
In-Reply-To: <4A4186C6.9090706@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's wrong to increment @pos in t_start(), otherwise we'll lose
some entries when reading printk_formats, if the output is larger
than PAGE_SIZE.

[ Impact: fix missing entries when reading printk_formats ]

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reviewed-by: Liming Wang <liming.wang@windriver.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.5.4.rc3
