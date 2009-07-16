Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbZGPGVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbZGPGVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 02:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZGPGVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 02:21:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52473 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbZGPGVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 02:21:09 -0400
Message-ID: <4A5EC6D4.5040007@cn.fujitsu.com>
Date: Thu, 16 Jul 2009 14:21:08 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] tracing/function: cleanup for function tracer
References: <4A5EC5E7.6080307@cn.fujitsu.com>
In-Reply-To: <4A5EC5E7.6080307@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use %pf input format instead of kallsyms_lookup()
and %s input format

Thanks for Li Zefan's offline review.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c          |   17 +++--------------
 kernel/trace/trace_functions.c |    4 +---
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4521c77..8f7d28e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1438,18 +1438,13 @@ static int t_hash_show(struct seq_file *m, void *v)
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
@@ -1547,7 +1542,6 @@ static int t_show(struct seq_file *m, void *v)
 {
 	struct ftrace_iterator *iter = m->private;
 	struct dyn_ftrace *rec = v;
-	char str[KSYM_SYMBOL_LEN];
 
 	if (iter->flags & FTRACE_ITER_HASH)
 		return t_hash_show(m, v);
@@ -1560,9 +1554,7 @@ static int t_show(struct seq_file *m, void *v)
 	if (!rec)
 		return 0;
 
-	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
-
-	seq_printf(m, "%s\n", str);
+	seq_printf(m, "%pf\n", (void *)rec->ip);
 
 	return 0;
 }
@@ -2543,7 +2535,6 @@ static void g_stop(struct seq_file *m, void *p)
 static int g_show(struct seq_file *m, void *v)
 {
 	unsigned long *ptr = v;
-	char str[KSYM_SYMBOL_LEN];
 
 	if (!ptr)
 		return 0;
@@ -2553,9 +2544,7 @@ static int g_show(struct seq_file *m, void *v)
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
1.6.1.2

