Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZLUSHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZLUSHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 13:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZLUSHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 13:07:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35370 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZLUSHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 13:07:30 -0500
Date: Mon, 21 Dec 2009 19:07:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20091221180721.GA13983@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (2):
      sched: Restore printk sanity
      sched: Fix hotplug hang


 kernel/sched.c          |   91 ++++++++++++++++++++++++++---------------------
 kernel/sched_idletask.c |    2 +-
 2 files changed, 51 insertions(+), 42 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 720df10..87f1f47 100644
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
@@ -2348,7 +2346,7 @@ int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
 	 *   not worry about this generic constraint ]
 	 */
 	if (unlikely(!cpumask_test_cpu(cpu, &p->cpus_allowed) ||
-		     !cpu_active(cpu)))
+		     !cpu_online(cpu)))
 		cpu = select_fallback_rq(task_cpu(p), p);
 
 	return cpu;
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
