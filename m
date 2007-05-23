Return-Path: <linux-kernel-owner+w=401wt.eu-S934249AbXEWPKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249AbXEWPKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbXEWPKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:10:24 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:7269 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbXEWPKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:10:23 -0400
Subject: [PATCH 8/7] new output format
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20070523072618.129001605@chello.nl>
References: <20070523072618.129001605@chello.nl>
Content-Type: text/plain
Date: Wed, 23 May 2007 17:10:19 +0200
Message-Id: <1179933019.7019.94.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps this makes things more clear...

----

<edited output - real one is waaaay to big>

$ cat /proc/lock_stat
T                               class name    contentions   waittime-min   waittime-max waittime-total   acquisitions   holdtime-min   holdtime-max holdtime-total
------------------------------------------------------------------------------------------------------------------------------------------------------------------
X                              dcache_lock            543            478          23751         427570         166757            217         572426       90179147

                               dcache_lock            192          [<ffffffff802a5980>] d_instantiate+0x2a/0xad
                               dcache_lock            215          [<ffffffff8033b7a1>] _atomic_dec_and_lock+0x39/0x58
                               dcache_lock              2          [<ffffffff802a4703>] d_rehash+0x1b/0x44
                               dcache_lock              1          [<ffffffff802a5c53>] d_alloc+0x170/0x1d0

W                            tasklist_lock              9           1322          12870          21729           7543            593         125518       25759730
R                            tasklist_lock             36           1742          10475          76717           6104            417          56540        9121541

                             tasklist_lock             42          [<ffffffff80235240>] do_wait+0x7b/0xaa1
                             tasklist_lock              0          [<ffffffff802406a3>] sys_setpriority+0x4a/0x1ca
                             tasklist_lock              0          [<ffffffff80231786>] copy_process+0x116b/0x1689
                             tasklist_lock              0          [<ffffffff802361ac>] do_exit+0x4d2/0x878

X                       nl_table_wait.lock              0              0              0              0           1133            365         103424         581560
X                      cpufreq_driver_lock              0              0              0              0            122            438          44040         136777
X                       net_todo_run_mutex              0              0              0              0            121            636          42205         112073


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep_proc.c |  241 ++++++++++++++++++++++++++------------------------
 1 file changed, 129 insertions(+), 112 deletions(-)

Index: linux-2.6/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.orig/kernel/lockdep_proc.c	2007-05-23 12:08:18.000000000 +0200
+++ linux-2.6/kernel/lockdep_proc.c	2007-05-23 15:14:03.000000000 +0200
@@ -15,6 +15,8 @@
 #include <linux/seq_file.h>
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
+#include <linux/vmalloc.h>
+#include <linux/sort.h>
 #include <asm/uaccess.h>
 #include <asm/div64.h>
 
@@ -345,49 +347,145 @@ static const struct file_operations proc
 };
 
 #ifdef CONFIG_LOCK_STAT
-static int lock_contentions_show(struct seq_file *m, void *v)
-{
-	char sym[KSYM_SYMBOL_LEN];
+
+struct lock_stat_data {
 	struct lock_class *class;
 	struct lock_class_stats stats;
-	int i;
+};
+
+/*
+ * sort on absolute number of contentions
+ */
+int lock_stat_cmp(const void *l, const void *r)
+{
+	const struct lock_stat_data *dl = l, *dr = r;
+	unsigned long nl, nr;
+
+	nl = dl->stats.read_waittime.nr + dl->stats.write_waittime.nr;
+	nr = dr->stats.read_waittime.nr + dr->stats.write_waittime.nr;
+
+	return nr - nl;
+}
+
+static int lock_stat_show(struct seq_file *m, void *v)
+{
+	struct lock_class *class;
+	struct lock_stat_data *stat, *stat_end;
+	struct lock_stat_data *stat_snapshot =
+		vmalloc(sizeof(struct lock_stat_data) * MAX_LOCKDEP_KEYS);
+
+	if (!stat_snapshot) {
+		seq_printf(m, "-ENOMEM\n");
+		return 0;
+	}
+
+	stat_end = stat_snapshot;
 
 	list_for_each_entry(class, &all_lock_classes, lock_entry) {
-		stats = lock_stats(class);
+		stat_end->class = class;
+		stat_end->stats = lock_stats(class);
+		stat_end++;
+	}
 
-		if (stats.read_contentions || stats.write_contentions) {
-			seq_printf(m, "%s: %lu %lu", class->name,
-					stats.write_contentions,
-					stats.read_contentions);
-
-			for (i = 0; i < ARRAY_SIZE(class->contention_point);
-					i++) {
-				if (class->contention_point[i] == 0)
-					break;
-				sprint_symbol(sym, class->contention_point[i]);
-				seq_printf(m, " %lu [<%p>] %s",
-					stats.contention_point[i],
-					(void *)class->contention_point[i],
-					sym);
-			}
-			seq_printf(m, "\n");
+	sort(stat_snapshot, stat_end - stat_snapshot,
+			sizeof(struct lock_stat_data),
+			lock_stat_cmp, NULL);
+
+	seq_printf(m, "%1s %40s %14s %14s %14s %14s %14s %14s %14s %14s\n",
+			"T",
+			"class name",
+			"contentions",
+			"waittime-min",
+			"waittime-max",
+			"waittime-total",
+			"acquisitions",
+			"holdtime-min",
+			"holdtime-max",
+			"holdtime-total");
+	seq_printf(m, "-" "-"
+		      "----------------------------------------" "-"
+	              "--------------" "-"
+	              "--------------" "-"
+	              "--------------" "-"
+	              "--------------" "-"
+	              "--------------" "-"
+	              "--------------" "-"
+	              "--------------" "-"
+	              "--------------" "\n");
+
+	for (stat = stat_snapshot; stat != stat_end; stat++) {
+		struct lock_class_stats *stats = &stat->stats;
+		int i;
+
+		class = stat->class;
+
+		if (stats->write_waittime.nr ||
+				stats->write_holdtime.nr)
+			seq_printf(m, "%c %40s %14lu %14llu %14llu %14llu"
+					" %14lu %14llu %14llu %14llu\n",
+					(stats->read_holdtime.nr ? 'W' : 'X'),
+					class->name,
+					stats->write_waittime.nr,
+					stats->write_waittime.min,
+					stats->write_waittime.max,
+					stats->write_waittime.total,
+					stats->write_holdtime.nr,
+					stats->write_holdtime.min,
+					stats->write_holdtime.max,
+					stats->write_holdtime.total);
+
+		if (stats->read_waittime.nr ||
+				stats->read_holdtime.nr)
+			seq_printf(m, "%c %40s %14lu %14llu %14llu %14llu"
+					" %14lu %14llu %14llu %14llu\n",
+					'R',
+					class->name,
+					stats->read_waittime.nr,
+					stats->read_waittime.min,
+					stats->read_waittime.max,
+					stats->read_waittime.total,
+					stats->read_holdtime.nr,
+					stats->read_holdtime.min,
+					stats->read_holdtime.max,
+					stats->read_holdtime.total);
+
+		for (i = 0; i < ARRAY_SIZE(class->contention_point); i++) {
+			char sym[KSYM_SYMBOL_LEN];
+			char ip[32];
+
+			if (class->contention_point[i] == 0)
+				break;
+
+			if (!i)
+				seq_printf(m, "\n");
+
+			sprint_symbol(sym, class->contention_point[i]);
+			snprintf(ip, sizeof(ip), "[<%p>]",
+					(void *)class->contention_point[i]);
+			seq_printf(m, "  %40s %14lu %29s %s\n",
+					class->name,
+					stats->contention_point[i],
+					ip, sym);
 		}
+		if (i)
+			seq_printf(m, "\n");
 	}
 
+	vfree(stat_snapshot);
+
 	return 0;
 }
 
-static int lock_contentions_open(struct inode *inode, struct file *file)
+static int lock_stat_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, lock_contentions_show, NULL);
+	return single_open(file, lock_stat_show, NULL);
 }
 
-ssize_t lock_contentions_write(struct file *file, const char __user *buf,
+ssize_t lock_stat_write(struct file *file, const char __user *buf,
 		size_t count, loff_t *ppos)
 {
 	struct lock_class *class;
 	char c;
-	int i;
 
 	if (count) {
 		if (get_user(c, buf))
@@ -402,83 +501,9 @@ ssize_t lock_contentions_write(struct fi
 	return count;
 }
 
-static const struct file_operations proc_lock_contentions_operations = {
-	.open		= lock_contentions_open,
-	.write		= lock_contentions_write,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
-static void print_time(struct seq_file *m, struct lock_time *lt)
-{
-	seq_printf(m, " %lu %llu %llu %llu",
-			lt->nr, lt->min, lt->max, lt->total);
-}
-
-static int lock_waittime_show(struct seq_file *m, void *v)
-{
-	struct lock_class *class;
-	struct lock_class_stats stats;
-
-	list_for_each_entry(class, &all_lock_classes, lock_entry) {
-		stats = lock_stats(class);
-
-		if (stats.read_contentions || stats.write_contentions) {
-			seq_printf(m, "%s: %lu %lu", class->name,
-					stats.write_contentions,
-					stats.read_contentions);
-			print_time(m, &stats.write_waittime);
-			print_time(m, &stats.read_waittime);
-			seq_printf(m, "\n");
-		}
-	}
-
-	return 0;
-}
-
-static int lock_waittime_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, lock_waittime_show, NULL);
-}
-
-static const struct file_operations proc_lock_waittime_operations = {
-	.open		= lock_waittime_open,
-	.write		= lock_contentions_write,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
-static int lock_holdtime_show(struct seq_file *m, void *v)
-{
-	struct lock_class *class;
-	struct lock_class_stats stats;
-
-	list_for_each_entry(class, &all_lock_classes, lock_entry) {
-		stats = lock_stats(class);
-
-		if (stats.read_contentions || stats.write_contentions) {
-			seq_printf(m, "%s: %lu %lu", class->name,
-					stats.write_contentions,
-					stats.read_contentions);
-			print_time(m, &stats.write_holdtime);
-			print_time(m, &stats.read_holdtime);
-			seq_printf(m, "\n");
-		}
-	}
-
-	return 0;
-}
-
-static int lock_holdtime_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, lock_holdtime_show, NULL);
-}
-
-static const struct file_operations proc_lock_holdtime_operations = {
-	.open		= lock_holdtime_open,
-	.write		= lock_contentions_write,
+static const struct file_operations proc_lock_stat_operations = {
+	.open		= lock_stat_open,
+	.write		= lock_stat_write,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
@@ -498,17 +523,9 @@ static int __init lockdep_proc_init(void
 		entry->proc_fops = &proc_lockdep_stats_operations;
 
 #ifdef CONFIG_LOCK_STAT
-	entry = create_proc_entry("lock_contentions", S_IRUSR, NULL);
-	if (entry)
-		entry->proc_fops = &proc_lock_contentions_operations;
-
-	entry = create_proc_entry("lock_waittime", S_IRUSR, NULL);
-	if (entry)
-		entry->proc_fops = &proc_lock_waittime_operations;
-
-	entry = create_proc_entry("lock_holdtime", S_IRUSR, NULL);
+	entry = create_proc_entry("lock_stat", S_IRUSR, NULL);
 	if (entry)
-		entry->proc_fops = &proc_lock_holdtime_operations;
+		entry->proc_fops = &proc_lock_stat_operations;
 #endif
 
 	return 0;


