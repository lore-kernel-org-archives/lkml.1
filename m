Return-Path: <linux-kernel-owner+w=401wt.eu-S1751378AbZLMHhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbZLMHhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 02:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZLMHhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 02:37:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:48653 "HELO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751199AbZLMHhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 02:37:39 -0500
Date: Sun, 13 Dec 2009 07:37:00 GMT
From: tip-bot for Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joe@perches.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1260655047.2637.7.camel@Joe-Laptop.home>
References: <1260655047.2637.7.camel@Joe-Laptop.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Use pr_fmt() and pr_<level>()
Message-ID: <tip-663997d417330a59a566452f52cfa04c8ffd190b@git.kernel.org>
Git-Commit-ID: 663997d417330a59a566452f52cfa04c8ffd190b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  663997d417330a59a566452f52cfa04c8ffd190b
Gitweb:     http://git.kernel.org/tip/663997d417330a59a566452f52cfa04c8ffd190b
Author:     Joe Perches <joe@perches.com>
AuthorDate: Sat, 12 Dec 2009 13:57:27 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Dec 2009 08:13:55 +0100

sched: Use pr_fmt() and pr_<level>()

- Convert printk(KERN_<level> to pr_<level> (not KERN_DEBUG)
 - Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 - Coalesce long format strings
 - Add missing \n to "ERROR: !SD_LOAD_BALANCE domain has parent"

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1260655047.2637.7.camel@Joe-Laptop.home>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c          |   94 +++++++++++++++++++++--------------------------
 kernel/sched_idletask.c |    2 +-
 2 files changed, 43 insertions(+), 53 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8b3532f..258c73c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -26,6 +26,8 @@
  *              Thomas Gleixner, Mike Kravetz
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/nmi.h>
@@ -5337,8 +5339,8 @@ static noinline void __schedule_bug(struct task_struct *prev)
 {
 	struct pt_regs *regs = get_irq_regs();
 
-	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
-		prev->comm, prev->pid, preempt_count());
+	pr_err("BUG: scheduling while atomic: %s/%d/0x%08x\n",
+	       prev->comm, prev->pid, preempt_count());
 
 	debug_show_held_locks(prev);
 	print_modules();
@@ -6906,23 +6908,23 @@ void sched_show_task(struct task_struct *p)
 	unsigned state;
 
 	state = p->state ? __ffs(p->state) + 1 : 0;
-	printk(KERN_INFO "%-13.13s %c", p->comm,
+	pr_info("%-13.13s %c", p->comm,
 		state < sizeof(stat_nam) - 1 ? stat_nam[state] : '?');
 #if BITS_PER_LONG == 32
 	if (state == TASK_RUNNING)
-		printk(KERN_CONT " running  ");
+		pr_cont(" running  ");
 	else
-		printk(KERN_CONT " %08lx ", thread_saved_pc(p));
+		pr_cont(" %08lx ", thread_saved_pc(p));
 #else
 	if (state == TASK_RUNNING)
-		printk(KERN_CONT "  running task    ");
+		pr_cont("  running task    ");
 	else
-		printk(KERN_CONT " %016lx ", thread_saved_pc(p));
+		pr_cont(" %016lx ", thread_saved_pc(p));
 #endif
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	free = stack_not_used(p);
 #endif
-	printk(KERN_CONT "%5lu %5d %6d 0x%08lx\n", free,
+	pr_cont("%5lu %5d %6d 0x%08lx\n", free,
 		task_pid_nr(p), task_pid_nr(p->real_parent),
 		(unsigned long)task_thread_info(p)->flags);
 
@@ -6934,11 +6936,9 @@ void show_state_filter(unsigned long state_filter)
 	struct task_struct *g, *p;
 
 #if BITS_PER_LONG == 32
-	printk(KERN_INFO
-		"  task                PC stack   pid father\n");
+	pr_info("  task                PC stack   pid father\n");
 #else
-	printk(KERN_INFO
-		"  task                        PC stack   pid father\n");
+	pr_info("  task                        PC stack   pid father\n");
 #endif
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
@@ -7296,9 +7296,8 @@ again:
 		 * leave kernel.
 		 */
 		if (p->mm && printk_ratelimit()) {
-			printk(KERN_INFO "process %d (%s) no "
-			       "longer affine to cpu%d\n",
-			       task_pid_nr(p), p->comm, dead_cpu);
+			pr_info("process %d (%s) no longer affine to cpu%d\n",
+				task_pid_nr(p), p->comm, dead_cpu);
 		}
 	}
 
@@ -7805,48 +7804,44 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
 
 	if (!(sd->flags & SD_LOAD_BALANCE)) {
-		printk("does not load-balance\n");
+		pr_cont("does not load-balance\n");
 		if (sd->parent)
-			printk(KERN_ERR "ERROR: !SD_LOAD_BALANCE domain"
-					" has parent");
+			pr_err("ERROR: !SD_LOAD_BALANCE domain has parent\n");
 		return -1;
 	}
 
-	printk(KERN_CONT "span %s level %s\n", str, sd->name);
+	pr_cont("span %s level %s\n", str, sd->name);
 
 	if (!cpumask_test_cpu(cpu, sched_domain_span(sd))) {
-		printk(KERN_ERR "ERROR: domain->span does not contain "
-				"CPU%d\n", cpu);
+		pr_err("ERROR: domain->span does not contain CPU%d\n", cpu);
 	}
 	if (!cpumask_test_cpu(cpu, sched_group_cpus(group))) {
-		printk(KERN_ERR "ERROR: domain->groups does not contain"
-				" CPU%d\n", cpu);
+		pr_err("ERROR: domain->groups does not contain CPU%d\n", cpu);
 	}
 
 	printk(KERN_DEBUG "%*s groups:", level + 1, "");
 	do {
 		if (!group) {
-			printk("\n");
-			printk(KERN_ERR "ERROR: group is NULL\n");
+			pr_cont("\n");
+			pr_err("ERROR: group is NULL\n");
 			break;
 		}
 
 		if (!group->cpu_power) {
-			printk(KERN_CONT "\n");
-			printk(KERN_ERR "ERROR: domain->cpu_power not "
-					"set\n");
+			pr_cont("\n");
+			pr_err("ERROR: domain->cpu_power not set\n");
 			break;
 		}
 
 		if (!cpumask_weight(sched_group_cpus(group))) {
-			printk(KERN_CONT "\n");
-			printk(KERN_ERR "ERROR: empty group\n");
+			pr_cont("\n");
+			pr_err("ERROR: empty group\n");
 			break;
 		}
 
 		if (cpumask_intersects(groupmask, sched_group_cpus(group))) {
-			printk(KERN_CONT "\n");
-			printk(KERN_ERR "ERROR: repeated CPUs\n");
+			pr_cont("\n");
+			pr_err("ERROR: repeated CPUs\n");
 			break;
 		}
 
@@ -7854,23 +7849,21 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
 
-		printk(KERN_CONT " %s", str);
+		pr_cont(" %s", str);
 		if (group->cpu_power != SCHED_LOAD_SCALE) {
-			printk(KERN_CONT " (cpu_power = %d)",
-				group->cpu_power);
+			pr_cont(" (cpu_power = %d)", group->cpu_power);
 		}
 
 		group = group->next;
 	} while (group != sd->groups);
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 
 	if (!cpumask_equal(sched_domain_span(sd), groupmask))
-		printk(KERN_ERR "ERROR: groups don't span domain->span\n");
+		pr_err("ERROR: groups don't span domain->span\n");
 
 	if (sd->parent &&
 	    !cpumask_subset(groupmask, sched_domain_span(sd->parent)))
-		printk(KERN_ERR "ERROR: parent span is not a superset "
-			"of domain->span\n");
+		pr_err("ERROR: parent span is not a superset of domain->span\n");
 	return 0;
 }
 
@@ -8426,8 +8419,7 @@ static int build_numa_sched_groups(struct s_data *d,
 	sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
 			  GFP_KERNEL, num);
 	if (!sg) {
-		printk(KERN_WARNING "Can not alloc domain group for node %d\n",
-		       num);
+		pr_warning("Can not alloc domain group for node %d\n", num);
 		return -ENOMEM;
 	}
 	d->sched_group_nodes[num] = sg;
@@ -8456,8 +8448,8 @@ static int build_numa_sched_groups(struct s_data *d,
 		sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
 				  GFP_KERNEL, num);
 		if (!sg) {
-			printk(KERN_WARNING
-			       "Can not alloc domain group for node %d\n", j);
+			pr_warning("Can not alloc domain group for node %d\n",
+				   j);
 			return -ENOMEM;
 		}
 		sg->cpu_power = 0;
@@ -8685,7 +8677,7 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 	d->sched_group_nodes = kcalloc(nr_node_ids,
 				      sizeof(struct sched_group *), GFP_KERNEL);
 	if (!d->sched_group_nodes) {
-		printk(KERN_WARNING "Can not alloc sched group node list\n");
+		pr_warning("Can not alloc sched group node list\n");
 		return sa_notcovered;
 	}
 	sched_group_nodes_bycpu[cpumask_first(cpu_map)] = d->sched_group_nodes;
@@ -8702,7 +8694,7 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 		return sa_send_covered;
 	d->rd = alloc_rootdomain();
 	if (!d->rd) {
-		printk(KERN_WARNING "Cannot alloc root domain\n");
+		pr_warning("Cannot alloc root domain\n");
 		return sa_tmpmask;
 	}
 	return sa_rootdomain;
@@ -9684,13 +9676,11 @@ void __might_sleep(char *file, int line, int preempt_offset)
 		return;
 	prev_jiffy = jiffies;
 
-	printk(KERN_ERR
-		"BUG: sleeping function called from invalid context at %s:%d\n",
-			file, line);
-	printk(KERN_ERR
-		"in_atomic(): %d, irqs_disabled(): %d, pid: %d, name: %s\n",
-			in_atomic(), irqs_disabled(),
-			current->pid, current->comm);
+	pr_err("BUG: sleeping function called from invalid context at %s:%d\n",
+	       file, line);
+	pr_err("in_atomic(): %d, irqs_disabled(): %d, pid: %d, name: %s\n",
+	       in_atomic(), irqs_disabled(),
+	       current->pid, current->comm);
 
 	debug_show_held_locks(current);
 	if (irqs_disabled())
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 33d5384..b810e22 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -35,7 +35,7 @@ static void
 dequeue_task_idle(struct rq *rq, struct task_struct *p, int sleep)
 {
 	spin_unlock_irq(&rq->lock);
-	printk(KERN_ERR "bad: scheduling from the idle thread!\n");
+	pr_err("bad: scheduling from the idle thread!\n");
 	dump_stack();
 	spin_lock_irq(&rq->lock);
 }
