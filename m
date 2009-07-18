Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbZGRHR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbZGRHR2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 03:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932582AbZGRHRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 03:17:15 -0400
Received: from mail-qy0-f198.google.com ([209.85.221.198]:53553 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520AbZGRHRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 03:17:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=I/rIonAsAdOYSq6hgN3Pr/5IUMqBmh3Zk44VuduF4W1t5ZAKaOfWDeqoSJH9mUUhO0
         9o40woi4f/OgMI1oiMtmwe6yqGJtMVaRPE9a1q8g5iKaqh8z3hbWJf7GdrRoGQ6uCQ8m
         XA9U0cvxBmjmfTdH9H9wXa+/t5q4kCqg/30bo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/4] tracing/function: Cleanup for function tracer
Date: Sat, 18 Jul 2009 03:17:01 -0400
Message-Id: <1247901421-6389-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1247901421-6389-1-git-send-email-fweisbec@gmail.com>
References: <1247901421-6389-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

We can directly use %pf input format instead of kallsyms_lookup()
and %s input format

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/ftrace.c          |   17 +++--------------
 kernel/trace/trace_functions.c |    4 +---
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 217caec..80a97a5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1403,18 +1403,13 @@ static int t_hash_show(struct seq_file *m, void *v)
 {
 	struct ftrace_func_probe *rec;
 	struct hlist_node *hnd = v;
-	char str[KSYM_SYMBOL_LEN];
 
 	rec = hlist_entry(hnd, struct ftrace_func_probe, node);
 
 	if (rec->ops->print)
 		return rec->ops->print(m, rec->ip, rec->ops, rec->data);
 
-	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
-	seq_printf(m, "%s:", str);
-
-	kallsyms_lookup((unsigned long)rec->ops->func, NULL, NULL, NULL, str);
-	seq_printf(m, "%s", str);
+	seq_printf(m, "%pf:%pf", (void *)rec->ip, (void *)rec->ops->func);
 
 	if (rec->data)
 		seq_printf(m, ":%p", rec->data);
@@ -1512,7 +1507,6 @@ static int t_show(struct seq_file *m, void *v)
 {
 	struct ftrace_iterator *iter = m->private;
 	struct dyn_ftrace *rec = v;
-	char str[KSYM_SYMBOL_LEN];
 
 	if (iter->flags & FTRACE_ITER_HASH)
 		return t_hash_show(m, v);
@@ -1525,9 +1519,7 @@ static int t_show(struct seq_file *m, void *v)
 	if (!rec)
 		return 0;
 
-	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
-
-	seq_printf(m, "%s\n", str);
+	seq_printf(m, "%pf\n", (void *)rec->ip);
 
 	return 0;
 }
@@ -2508,7 +2500,6 @@ static void g_stop(struct seq_file *m, void *p)
 static int g_show(struct seq_file *m, void *v)
 {
 	unsigned long *ptr = v;
-	char str[KSYM_SYMBOL_LEN];
 
 	if (!ptr)
 		return 0;
@@ -2518,9 +2509,7 @@ static int g_show(struct seq_file *m, void *v)
 		return 0;
 	}
 
-	kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
-
-	seq_printf(m, "%s\n", str);
+	seq_printf(m, "%pf\n", v);
 
 	return 0;
 }
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 7402144..b53dc99 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -288,11 +288,9 @@ static int
 ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
 			 struct ftrace_probe_ops *ops, void *data)
 {
-	char str[KSYM_SYMBOL_LEN];
 	long count = (long)data;
 
-	kallsyms_lookup(ip, NULL, NULL, NULL, str);
-	seq_printf(m, "%s:", str);
+	seq_printf(m, "%pf:", (void *)ip);
 
 	if (ops == &traceon_probe_ops)
 		seq_printf(m, "traceon");
-- 
1.6.2.3

