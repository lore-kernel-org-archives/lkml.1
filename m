Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbZL3Jcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbZL3Jcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbZL3Jcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:32:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:57520 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZL3Jc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:32:29 -0500
Date: Wed, 30 Dec 2009 09:31:40 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <4B3AF203.40200@cn.fujitsu.com>
References: <4B3AF203.40200@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] ksym_tracer: Remove trace_stat
Message-ID: <tip-53ab668064edaeef99c0ee22799483d45f4c81f6@git.kernel.org>
Git-Commit-ID: 53ab668064edaeef99c0ee22799483d45f4c81f6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53ab668064edaeef99c0ee22799483d45f4c81f6
Gitweb:     http://git.kernel.org/tip/53ab668064edaeef99c0ee22799483d45f4c81f6
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 30 Dec 2009 14:24:03 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 30 Dec 2009 07:50:50 +0100

ksym_tracer: Remove trace_stat

trace_stat is problematic. Don't use it, use seqfile instead.

This fixes a race that reading the stat file is not protected by
any lock, which can lead to use after free.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B3AF203.40200@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_ksym.c |  127 ++++++++++++++++++---------------------------
 1 files changed, 50 insertions(+), 77 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 67d79f7..94103cd 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -26,7 +26,6 @@
 #include <linux/fs.h>
 
 #include "trace_output.h"
-#include "trace_stat.h"
 #include "trace.h"
 
 #include <linux/hw_breakpoint.h>
@@ -444,103 +443,77 @@ struct tracer ksym_tracer __read_mostly =
 	.print_line	= ksym_trace_output
 };
 
-__init static int init_ksym_trace(void)
-{
-	struct dentry *d_tracer;
-	struct dentry *entry;
-
-	d_tracer = tracing_init_dentry();
-	ksym_filter_entry_count = 0;
-
-	entry = debugfs_create_file("ksym_trace_filter", 0644, d_tracer,
-				    NULL, &ksym_tracing_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'ksym_trace_filter' file\n");
-
-	return register_tracer(&ksym_tracer);
-}
-device_initcall(init_ksym_trace);
-
-
 #ifdef CONFIG_PROFILE_KSYM_TRACER
-static int ksym_tracer_stat_headers(struct seq_file *m)
+static int ksym_profile_show(struct seq_file *m, void *v)
 {
+	struct hlist_node *node;
+	struct trace_ksym *entry;
+	int access_type = 0;
+	char fn_name[KSYM_NAME_LEN];
+
 	seq_puts(m, "  Access Type ");
 	seq_puts(m, "  Symbol                                       Counter\n");
 	seq_puts(m, "  ----------- ");
 	seq_puts(m, "  ------                                       -------\n");
-	return 0;
-}
 
-static int ksym_tracer_stat_show(struct seq_file *m, void *v)
-{
-	struct hlist_node *stat = v;
-	struct trace_ksym *entry;
-	int access_type = 0;
-	char fn_name[KSYM_NAME_LEN];
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(entry, node, &ksym_filter_head, ksym_hlist) {
 
-	entry = hlist_entry(stat, struct trace_ksym, ksym_hlist);
+		access_type = entry->attr.bp_type;
 
-	access_type = entry->attr.bp_type;
+		switch (access_type) {
+		case HW_BREAKPOINT_R:
+			seq_puts(m, "  R           ");
+			break;
+		case HW_BREAKPOINT_W:
+			seq_puts(m, "  W           ");
+			break;
+		case HW_BREAKPOINT_R | HW_BREAKPOINT_W:
+			seq_puts(m, "  RW          ");
+			break;
+		default:
+			seq_puts(m, "  NA          ");
+		}
 
-	switch (access_type) {
-	case HW_BREAKPOINT_R:
-		seq_puts(m, "  R           ");
-		break;
-	case HW_BREAKPOINT_W:
-		seq_puts(m, "  W           ");
-		break;
-	case HW_BREAKPOINT_R | HW_BREAKPOINT_W:
-		seq_puts(m, "  RW          ");
-		break;
-	default:
-		seq_puts(m, "  NA          ");
+		if (lookup_symbol_name(entry->attr.bp_addr, fn_name) >= 0)
+			seq_printf(m, "  %-36s", fn_name);
+		else
+			seq_printf(m, "  %-36s", "<NA>");
+		seq_printf(m, " %15llu\n",
+			   (unsigned long long)atomic64_read(&entry->counter));
 	}
-
-	if (lookup_symbol_name(entry->attr.bp_addr, fn_name) >= 0)
-		seq_printf(m, "  %-36s", fn_name);
-	else
-		seq_printf(m, "  %-36s", "<NA>");
-	seq_printf(m, " %15llu\n",
-		   (unsigned long long)atomic64_read(&entry->counter));
+	rcu_read_unlock();
 
 	return 0;
 }
 
-static void *ksym_tracer_stat_start(struct tracer_stat *trace)
+static int ksym_profile_open(struct inode *node, struct file *file)
 {
-	return ksym_filter_head.first;
-}
-
-static void *
-ksym_tracer_stat_next(void *v, int idx)
-{
-	struct hlist_node *stat = v;
-
-	return stat->next;
+	return single_open(file, ksym_profile_show, NULL);
 }
 
-static struct tracer_stat ksym_tracer_stats = {
-	.name = "ksym_tracer",
-	.stat_start = ksym_tracer_stat_start,
-	.stat_next = ksym_tracer_stat_next,
-	.stat_headers = ksym_tracer_stat_headers,
-	.stat_show = ksym_tracer_stat_show
+static const struct file_operations ksym_profile_fops = {
+	.open		= ksym_profile_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
 };
+#endif /* CONFIG_PROFILE_KSYM_TRACER */
 
-__init static int ksym_tracer_stat_init(void)
+__init static int init_ksym_trace(void)
 {
-	int ret;
+	struct dentry *d_tracer;
 
-	ret = register_stat_tracer(&ksym_tracer_stats);
-	if (ret) {
-		printk(KERN_WARNING "Warning: could not register "
-				    "ksym tracer stats\n");
-		return 1;
-	}
+	d_tracer = tracing_init_dentry();
 
-	return 0;
+	trace_create_file("ksym_trace_filter", 0644, d_tracer,
+			  NULL, &ksym_tracing_fops);
+
+#ifdef CONFIG_PROFILE_KSYM_TRACER
+	trace_create_file("ksym_profile", 0444, d_tracer,
+			  NULL, &ksym_profile_fops);
+#endif
+
+	return register_tracer(&ksym_tracer);
 }
-fs_initcall(ksym_tracer_stat_init);
-#endif /* CONFIG_PROFILE_KSYM_TRACER */
+device_initcall(init_ksym_trace);
