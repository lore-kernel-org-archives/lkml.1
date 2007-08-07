Return-Path: <linux-kernel-owner+w=401wt.eu-S937331AbXHGWjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937331AbXHGWjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759320AbXHGWjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:39:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48529 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262AbXHGWjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:39:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched debug: Cleanup the sysctl registration code.
Date: Tue, 07 Aug 2007 16:38:39 -0600
Message-ID: <m1sl6vezrk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


- Use C99 initializers (struct ctl_table may change again)
- We don't need to set ctl_name anywhere to anything besides CTL_UNNUMBERED
- memset after kmalloc isn't needed if we just use kzalloc
- Directories under /proc/sys should always be 0555.
  User space programs can not write to them.

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/sched.c |   56 ++++++++++++++++++++++++++++++++------------------------
 1 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 72bb948..77dfdb2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5210,32 +5210,40 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
 #if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_SYSCTL)
 
 static struct ctl_table sd_ctl_dir[] = {
-	{CTL_UNNUMBERED, "sched_domain", NULL, 0, 0755, NULL, },
-	{0,},
+	{
+		.ctl_name 	= CTL_UNNUMBERED,
+		.procname	= "sched_domain",
+		.mode		= 0555,
+	},
+	{}
 };
 
 static struct ctl_table sd_ctl_root[] = {
-	{CTL_UNNUMBERED, "kernel", NULL, 0, 0755, sd_ctl_dir, },
-	{0,},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= sd_ctl_dir,
+	},
+	{}
 };
 
 static struct ctl_table *sd_alloc_ctl_entry(int n)
 {
 	struct ctl_table *entry =
-		kmalloc(n * sizeof(struct ctl_table), GFP_KERNEL);
+		kzalloc(n * sizeof(struct ctl_table), GFP_KERNEL);
 
 	BUG_ON(!entry);
-	memset(entry, 0, n * sizeof(struct ctl_table));
 
 	return entry;
 }
 
 static void
-set_table_entry(struct ctl_table *entry, int ctl_name,
+set_table_entry(struct ctl_table *entry,
 		const char *procname, void *data, int maxlen,
 		mode_t mode, proc_handler *proc_handler)
 {
-	entry->ctl_name = ctl_name;
+	entry->ctl_name = CTL_UNNUMBERED;
 	entry->procname = procname;
 	entry->data = data;
 	entry->maxlen = maxlen;
@@ -5248,34 +5256,34 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
 	struct ctl_table *table = sd_alloc_ctl_entry(14);
 
-	set_table_entry(&table[0], 1, "min_interval", &sd->min_interval,
+	set_table_entry(&table[0], "min_interval", &sd->min_interval,
 		sizeof(long), 0644, proc_doulongvec_minmax);
-	set_table_entry(&table[1], 2, "max_interval", &sd->max_interval,
+	set_table_entry(&table[1], "max_interval", &sd->max_interval,
 		sizeof(long), 0644, proc_doulongvec_minmax);
-	set_table_entry(&table[2], 3, "busy_idx", &sd->busy_idx,
+	set_table_entry(&table[2], "busy_idx", &sd->busy_idx,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[3], 4, "idle_idx", &sd->idle_idx,
+	set_table_entry(&table[3], "idle_idx", &sd->idle_idx,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[4], 5, "newidle_idx", &sd->newidle_idx,
+	set_table_entry(&table[4], "newidle_idx", &sd->newidle_idx,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[5], 6, "wake_idx", &sd->wake_idx,
+	set_table_entry(&table[5], "wake_idx", &sd->wake_idx,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[6], 7, "forkexec_idx", &sd->forkexec_idx,
+	set_table_entry(&table[6], "forkexec_idx", &sd->forkexec_idx,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[7], 8, "busy_factor", &sd->busy_factor,
+	set_table_entry(&table[7], "busy_factor", &sd->busy_factor,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[8], 9, "imbalance_pct", &sd->imbalance_pct,
+	set_table_entry(&table[8], "imbalance_pct", &sd->imbalance_pct,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[10], 11, "cache_nice_tries",
+	set_table_entry(&table[10], "cache_nice_tries",
 		&sd->cache_nice_tries,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[12], 13, "flags", &sd->flags,
+	set_table_entry(&table[12], "flags", &sd->flags,
 		sizeof(int), 0644, proc_dointvec_minmax);
 
 	return table;
 }
 
-static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
+static struct ctl_table *sd_alloc_ctl_cpu_table(int cpu)
 {
 	struct ctl_table *entry, *table;
 	struct sched_domain *sd;
@@ -5289,9 +5297,9 @@ static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
 	i = 0;
 	for_each_domain(cpu, sd) {
 		snprintf(buf, 32, "domain%d", i);
-		entry->ctl_name = i + 1;
+		entry->ctl_name = CTL_UNNUMBERED;
 		entry->procname = kstrdup(buf, GFP_KERNEL);
-		entry->mode = 0755;
+		entry->mode = 0555;
 		entry->child = sd_alloc_ctl_domain_table(sd);
 		entry++;
 		i++;
@@ -5310,9 +5318,9 @@ static void init_sched_domain_sysctl(void)
 
 	for (i = 0; i < cpu_num; i++, entry++) {
 		snprintf(buf, 32, "cpu%d", i);
-		entry->ctl_name = i + 1;
+		entry->ctl_name = CTL_UNNUMBERED;
 		entry->procname = kstrdup(buf, GFP_KERNEL);
-		entry->mode = 0755;
+		entry->mode = 0555;
 		entry->child = sd_alloc_ctl_cpu_table(i);
 	}
 	sd_sysctl_header = register_sysctl_table(sd_ctl_root);
-- 
1.5.1.1.181.g2de0

