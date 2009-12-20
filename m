Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbZLTSB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbZLTSB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 13:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbZLTSB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 13:01:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:33697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbZLTSBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 13:01:25 -0500
Date: Sun, 20 Dec 2009 18:00:38 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joe@perches.com, torvalds@linux-foundation.org, efault@gmx.de,
       peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, torvalds@linux-foundation.org, peterz@infradead.org,
       efault@gmx.de, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1261315437.4314.6.camel@laptop>
References: <1261315437.4314.6.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Restore printk sanity
Message-ID: <tip-6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c@git.kernel.org>
Git-Commit-ID: 6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c
Gitweb:     http://git.kernel.org/tip/6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sun, 20 Dec 2009 14:23:57 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Dec 2009 18:45:57 +0100

sched: Restore printk sanity

Revert the braindead pr_* crap. (Commit 663997d "sched: Use
pr_fmt() and pr_<level>()")

It's dumb and causes stupid "sched: " strings all over the place.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Mike Galbraith <efault@gmx.de>
Cc: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1261315437.4314.6.camel@laptop>
[ i dont mind the pr_*() patterns that much - but Peter dislikes them with a vengence. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
--
 kernel/sched.c          |   89 ++++++++++++++++++++++++++----------------------
 kernel/sched_idletask.c |    2 -
 2 files changed, 50 insertions(+), 41 deletions(-)
---
 kernel/sched.c          |   89 ++++++++++++++++++++++++++---------------------
 kernel/sched_idletask.c |    2 +-
 2 files changed, 50 insertions(+), 41 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 720df10..7ffde2a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -26,8 +26,6 @@
  *              Thomas Gleixner, Mike Kravetz
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/nmi.h>
@@ -5375,8 +5373,8 @@ static noinline void __schedule_bug(struct task_struct *prev)
 {
 	struct pt_regs *regs = get_irq_regs();
 
-	pr_err("BUG: scheduling while atomic: %s/%d/0x%08x\n",
-	       prev->comm, prev->pid, preempt_count());
+	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
+		prev->comm, prev->pid, preempt_count());
 
 	debug_show_held_locks(prev);
 	print_modules();
@@ -6940,23 +6938,23 @@ void sched_show_task(struct task_struct *p)
 	unsigned state;
 
 	state = p->state ? __ffs(p->state) + 1 : 0;
-	pr_info("%-13.13s %c", p->comm,
+	printk(KERN_INFO "%-13.13s %c", p->comm,
 		state < sizeof(stat_nam) - 1 ? stat_nam[state] : '?');
 #if BITS_PER_LONG == 32
 	if (state == TASK_RUNNING)
-		pr_cont(" running  ");
+		printk(KERN_CONT " running  ");
 	else
-		pr_cont(" %08lx ", thread_saved_pc(p));
+		printk(KERN_CONT " %08lx ", thread_saved_pc(p));
 #else
 	if (state == TASK_RUNNING)
-		pr_cont("  running task    ");
+		printk(KERN_CONT "  running task    ");
 	else
-		pr_cont(" %016lx ", thread_saved_pc(p));
+		printk(KERN_CONT " %016lx ", thread_saved_pc(p));
 #endif
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	free = stack_not_used(p);
 #endif
-	pr_cont("%5lu %5d %6d 0x%08lx\n", free,
+	printk(KERN_CONT "%5lu %5d %6d 0x%08lx\n", free,
 		task_pid_nr(p), task_pid_nr(p->real_parent),
 		(unsigned long)task_thread_info(p)->flags);
 
@@ -6968,9 +6966,11 @@ void show_state_filter(unsigned long state_filter)
 	struct task_struct *g, *p;
 
 #if BITS_PER_LONG == 32
-	pr_info("  task                PC stack   pid father\n");
+	printk(KERN_INFO
+		"  task                PC stack   pid father\n");
 #else
-	pr_info("  task                        PC stack   pid father\n");
+	printk(KERN_INFO
+		"  task                        PC stack   pid father\n");
 #endif
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
@@ -7828,44 +7828,48 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
 
 	if (!(sd->flags & SD_LOAD_BALANCE)) {
-		pr_cont("does not load-balance\n");
+		printk("does not load-balance\n");
 		if (sd->parent)
-			pr_err("ERROR: !SD_LOAD_BALANCE domain has parent\n");
+			printk(KERN_ERR "ERROR: !SD_LOAD_BALANCE domain"
+					" has parent");
 		return -1;
 	}
 
-	pr_cont("span %s level %s\n", str, sd->name);
+	printk(KERN_CONT "span %s level %s\n", str, sd->name);
 
 	if (!cpumask_test_cpu(cpu, sched_domain_span(sd))) {
-		pr_err("ERROR: domain->span does not contain CPU%d\n", cpu);
+		printk(KERN_ERR "ERROR: domain->span does not contain "
+				"CPU%d\n", cpu);
 	}
 	if (!cpumask_test_cpu(cpu, sched_group_cpus(group))) {
-		pr_err("ERROR: domain->groups does not contain CPU%d\n", cpu);
+		printk(KERN_ERR "ERROR: domain->groups does not contain"
+				" CPU%d\n", cpu);
 	}
 
 	printk(KERN_DEBUG "%*s groups:", level + 1, "");
 	do {
 		if (!group) {
-			pr_cont("\n");
-			pr_err("ERROR: group is NULL\n");
+			printk("\n");
+			printk(KERN_ERR "ERROR: group is NULL\n");
 			break;
 		}
 
 		if (!group->cpu_power) {
-			pr_cont("\n");
-			pr_err("ERROR: domain->cpu_power not set\n");
+			printk(KERN_CONT "\n");
+			printk(KERN_ERR "ERROR: domain->cpu_power not "
+					"set\n");
 			break;
 		}
 
 		if (!cpumask_weight(sched_group_cpus(group))) {
-			pr_cont("\n");
-			pr_err("ERROR: empty group\n");
+			printk(KERN_CONT "\n");
+			printk(KERN_ERR "ERROR: empty group\n");
 			break;
 		}
 
 		if (cpumask_intersects(groupmask, sched_group_cpus(group))) {
-			pr_cont("\n");
-			pr_err("ERROR: repeated CPUs\n");
+			printk(KERN_CONT "\n");
+			printk(KERN_ERR "ERROR: repeated CPUs\n");
 			break;
 		}
 
@@ -7873,21 +7877,23 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
 
-		pr_cont(" %s", str);
+		printk(KERN_CONT " %s", str);
 		if (group->cpu_power != SCHED_LOAD_SCALE) {
-			pr_cont(" (cpu_power = %d)", group->cpu_power);
+			printk(KERN_CONT " (cpu_power = %d)",
+				group->cpu_power);
 		}
 
 		group = group->next;
 	} while (group != sd->groups);
-	pr_cont("\n");
+	printk(KERN_CONT "\n");
 
 	if (!cpumask_equal(sched_domain_span(sd), groupmask))
-		pr_err("ERROR: groups don't span domain->span\n");
+		printk(KERN_ERR "ERROR: groups don't span domain->span\n");
 
 	if (sd->parent &&
 	    !cpumask_subset(groupmask, sched_domain_span(sd->parent)))
-		pr_err("ERROR: parent span is not a superset of domain->span\n");
+		printk(KERN_ERR "ERROR: parent span is not a superset "
+			"of domain->span\n");
 	return 0;
 }
 
@@ -8443,7 +8449,8 @@ static int build_numa_sched_groups(struct s_data *d,
 	sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
 			  GFP_KERNEL, num);
 	if (!sg) {
-		pr_warning("Can not alloc domain group for node %d\n", num);
+		printk(KERN_WARNING "Can not alloc domain group for node %d\n",
+		       num);
 		return -ENOMEM;
 	}
 	d->sched_group_nodes[num] = sg;
@@ -8472,8 +8479,8 @@ static int build_numa_sched_groups(struct s_data *d,
 		sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
 				  GFP_KERNEL, num);
 		if (!sg) {
-			pr_warning("Can not alloc domain group for node %d\n",
-				   j);
+			printk(KERN_WARNING
+			       "Can not alloc domain group for node %d\n", j);
 			return -ENOMEM;
 		}
 		sg->cpu_power = 0;
@@ -8701,7 +8708,7 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 	d->sched_group_nodes = kcalloc(nr_node_ids,
 				      sizeof(struct sched_group *), GFP_KERNEL);
 	if (!d->sched_group_nodes) {
-		pr_warning("Can not alloc sched group node list\n");
+		printk(KERN_WARNING "Can not alloc sched group node list\n");
 		return sa_notcovered;
 	}
 	sched_group_nodes_bycpu[cpumask_first(cpu_map)] = d->sched_group_nodes;
@@ -8718,7 +8725,7 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 		return sa_send_covered;
 	d->rd = alloc_rootdomain();
 	if (!d->rd) {
-		pr_warning("Cannot alloc root domain\n");
+		printk(KERN_WARNING "Cannot alloc root domain\n");
 		return sa_tmpmask;
 	}
 	return sa_rootdomain;
@@ -9700,11 +9707,13 @@ void __might_sleep(char *file, int line, int preempt_offset)
 		return;
 	prev_jiffy = jiffies;
 
-	pr_err("BUG: sleeping function called from invalid context at %s:%d\n",
-	       file, line);
-	pr_err("in_atomic(): %d, irqs_disabled(): %d, pid: %d, name: %s\n",
-	       in_atomic(), irqs_disabled(),
-	       current->pid, current->comm);
+	printk(KERN_ERR
+		"BUG: sleeping function called from invalid context at %s:%d\n",
+			file, line);
+	printk(KERN_ERR
+		"in_atomic(): %d, irqs_disabled(): %d, pid: %d, name: %s\n",
+			in_atomic(), irqs_disabled(),
+			current->pid, current->comm);
 
 	debug_show_held_locks(current);
 	if (irqs_disabled())
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 21b969a..5f93b57 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -35,7 +35,7 @@ static void
 dequeue_task_idle(struct rq *rq, struct task_struct *p, int sleep)
 {
 	raw_spin_unlock_irq(&rq->lock);
-	pr_err("bad: scheduling from the idle thread!\n");
+	printk(KERN_ERR "bad: scheduling from the idle thread!\n");
 	dump_stack();
 	raw_spin_lock_irq(&rq->lock);
 }
