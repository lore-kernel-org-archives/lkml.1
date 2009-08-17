Return-Path: <linux-kernel-owner+w=401wt.eu-S932528AbZHQJcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbZHQJcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932329AbZHQJcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:32:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:44539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294AbZHQJcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:32:13 -0400
Date: Mon, 17 Aug 2009 09:31:21 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A891A91.4030602@cn.fujitsu.com>
References: <4A891A91.4030602@cn.fujitsu.com>
Subject: [tip:tracing/core] trace_stack: Simplify seqfile code
Message-ID: <tip-2fc5f0cff4cf1c4cd336d0f61f11bca6eeee1d84@git.kernel.org>
Git-Commit-ID: 2fc5f0cff4cf1c4cd336d0f61f11bca6eeee1d84
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 09:31:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fc5f0cff4cf1c4cd336d0f61f11bca6eeee1d84
Gitweb:     http://git.kernel.org/tip/2fc5f0cff4cf1c4cd336d0f61f11bca6eeee1d84
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 17 Aug 2009 16:53:37 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 17 Aug 2009 11:25:09 +0200

trace_stack: Simplify seqfile code

Extract duplicate code in t_start() and t_next().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A891A91.4030602@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
