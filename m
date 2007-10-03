Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbXJCGXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbXJCGXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 02:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXJCGXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 02:23:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39568 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbXJCGXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 02:23:06 -0400
Date: Wed, 3 Oct 2007 08:22:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, cpw@sgi.com
Subject: [patch] sched: fix sched-domains partitioning by cpusets
Message-ID: <20071003062240.GA19027@elte.hu>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <200709301335.00441.nickpiggin@yahoo.com.au> <20071001111528.5487b4f4.pj@sgi.com> <200710022335.05357.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710022335.05357.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> BTW. as far as the sched.c changes in your patch go, I much prefer the 
> partition_sched_domains API: http://lkml.org/lkml/2006/10/19/85
> 
> The caller should manage everything itself, rather than 
> partition_sched_domains doing half of the memory allocation.

i've merged your patch to my scheduler queue - see the patch below. (And 
could you send me your SoB line too?) Paul, if we went with the patch 
below, what else would be needed for your purposes?

	Ingo

--------------------------------->
Subject: sched: fix sched-domains partitioning by cpusets
From: Nick Piggin <nickpiggin@yahoo.com.au>

Fix sched-domains partitioning by cpusets. Walk the whole cpusets tree after
something interesting changes, and recreate all partitions.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/cpuset.h |    2 
 include/linux/sched.h  |    3 -
 kernel/cpuset.c        |  109 ++++++++++++++++++++++---------------------------
 kernel/sched.c         |   31 +++++++------
 4 files changed, 70 insertions(+), 75 deletions(-)

Index: linux/include/linux/cpuset.h
===================================================================
--- linux.orig/include/linux/cpuset.h
+++ linux/include/linux/cpuset.h
@@ -14,6 +14,8 @@
 
 #ifdef CONFIG_CPUSETS
 
+extern int cpuset_hotplug_update_sched_domains(void);
+
 extern int number_of_cpusets;	/* How many cpusets are defined in system? */
 
 extern int cpuset_init_early(void);
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -798,8 +798,7 @@ struct sched_domain {
 #endif
 };
 
-extern int partition_sched_domains(cpumask_t *partition1,
-				    cpumask_t *partition2);
+extern int partition_sched_domains(cpumask_t *partition);
 
 #endif	/* CONFIG_SMP */
 
Index: linux/kernel/cpuset.c
===================================================================
--- linux.orig/kernel/cpuset.c
+++ linux/kernel/cpuset.c
@@ -752,6 +752,24 @@ static int validate_change(const struct 
 	return 0;
 }
 
+static void update_cpu_domains_children(struct cpuset *par,
+					cpumask_t *non_partitioned)
+{
+	struct cpuset *c;
+
+	list_for_each_entry(c, &par->children, sibling) {
+		if (cpus_empty(c->cpus_allowed))
+			continue;
+		if (is_cpu_exclusive(c)) {
+			if (!partition_sched_domains(&c->cpus_allowed)) {
+				cpus_andnot(*non_partitioned,
+					*non_partitioned, c->cpus_allowed);
+			}
+		} else
+			update_cpu_domains_children(c, non_partitioned);
+	}
+}
+
 /*
  * For a given cpuset cur, partition the system as follows
  * a. All cpus in the parent cpuset's cpus_allowed that are not part of any
@@ -761,53 +779,38 @@ static int validate_change(const struct 
  * Build these two partitions by calling partition_sched_domains
  *
  * Call with manage_mutex held.  May nest a call to the
- * lock_cpu_hotplug()/unlock_cpu_hotplug() pair.
- * Must not be called holding callback_mutex, because we must
- * not call lock_cpu_hotplug() while holding callback_mutex.
+ * lock_cpu_hotplug()/unlock_cpu_hotplug() pair.  Must not be called holding
+ * callback_mutex, because we must not call lock_cpu_hotplug() while holding
+ * callback_mutex.
  */
 
-static void update_cpu_domains(struct cpuset *cur)
+static void update_cpu_domains(void)
 {
-	struct cpuset *c, *par = cur->parent;
-	cpumask_t pspan, cspan;
-
-	if (par == NULL || cpus_empty(cur->cpus_allowed))
-		return;
+	cpumask_t non_partitioned;
 
-	/*
-	 * Get all cpus from parent's cpus_allowed not part of exclusive
-	 * children
-	 */
-	pspan = par->cpus_allowed;
-	list_for_each_entry(c, &par->children, sibling) {
-		if (is_cpu_exclusive(c))
-			cpus_andnot(pspan, pspan, c->cpus_allowed);
-	}
-	if (!is_cpu_exclusive(cur)) {
-		cpus_or(pspan, pspan, cur->cpus_allowed);
-		if (cpus_equal(pspan, cur->cpus_allowed))
-			return;
-		cspan = CPU_MASK_NONE;
-	} else {
-		if (cpus_empty(pspan))
-			return;
-		cspan = cur->cpus_allowed;
-		/*
-		 * Get all cpus from current cpuset's cpus_allowed not part
-		 * of exclusive children
-		 */
-		list_for_each_entry(c, &cur->children, sibling) {
-			if (is_cpu_exclusive(c))
-				cpus_andnot(cspan, cspan, c->cpus_allowed);
-		}
-	}
+	BUG_ON(!mutex_is_locked(&manage_mutex));
 
 	lock_cpu_hotplug();
-	partition_sched_domains(&pspan, &cspan);
+	non_partitioned = top_cpuset.cpus_allowed;
+	update_cpu_domains_children(&top_cpuset, &non_partitioned);
+	partition_sched_domains(&non_partitioned);
 	unlock_cpu_hotplug();
 }
 
 /*
+ * Same as above except called with lock_cpu_hotplug and without manage_mutex.
+ */
+
+int cpuset_hotplug_update_sched_domains(void)
+{
+	cpumask_t non_partitioned;
+
+	non_partitioned = top_cpuset.cpus_allowed;
+	update_cpu_domains_children(&top_cpuset, &non_partitioned);
+	return partition_sched_domains(&non_partitioned);
+}
+
+/*
  * Call with manage_mutex held.  May take callback_mutex during call.
  */
 
@@ -845,8 +848,8 @@ static int update_cpumask(struct cpuset 
 	mutex_lock(&callback_mutex);
 	cs->cpus_allowed = trialcs.cpus_allowed;
 	mutex_unlock(&callback_mutex);
-	if (is_cpu_exclusive(cs) && !cpus_unchanged)
-		update_cpu_domains(cs);
+	if (!cpus_unchanged)
+		update_cpu_domains();
 	return 0;
 }
 
@@ -1087,7 +1090,7 @@ static int update_flag(cpuset_flagbits_t
 	mutex_unlock(&callback_mutex);
 
 	if (cpu_exclusive_changed)
-                update_cpu_domains(cs);
+                update_cpu_domains();
 	return 0;
 }
 
@@ -1947,19 +1950,9 @@ static int cpuset_mkdir(struct inode *di
 	return cpuset_create(c_parent, dentry->d_name.name, mode | S_IFDIR);
 }
 
-/*
- * Locking note on the strange update_flag() call below:
- *
- * If the cpuset being removed is marked cpu_exclusive, then simulate
- * turning cpu_exclusive off, which will call update_cpu_domains().
- * The lock_cpu_hotplug() call in update_cpu_domains() must not be
- * made while holding callback_mutex.  Elsewhere the kernel nests
- * callback_mutex inside lock_cpu_hotplug() calls.  So the reverse
- * nesting would risk an ABBA deadlock.
- */
-
 static int cpuset_rmdir(struct inode *unused_dir, struct dentry *dentry)
 {
+	int is_exclusive;
 	struct cpuset *cs = dentry->d_fsdata;
 	struct dentry *d;
 	struct cpuset *parent;
@@ -1977,13 +1970,8 @@ static int cpuset_rmdir(struct inode *un
 		mutex_unlock(&manage_mutex);
 		return -EBUSY;
 	}
-	if (is_cpu_exclusive(cs)) {
-		int retval = update_flag(CS_CPU_EXCLUSIVE, cs, "0");
-		if (retval < 0) {
-			mutex_unlock(&manage_mutex);
-			return retval;
-		}
-	}
+	is_exclusive = is_cpu_exclusive(cs);
+
 	parent = cs->parent;
 	mutex_lock(&callback_mutex);
 	set_bit(CS_REMOVED, &cs->flags);
@@ -1998,8 +1986,13 @@ static int cpuset_rmdir(struct inode *un
 	mutex_unlock(&callback_mutex);
 	if (list_empty(&parent->children))
 		check_for_release(parent, &pathbuf);
+
+	if (is_exclusive)
+		update_cpu_domains();
+
 	mutex_unlock(&manage_mutex);
 	cpuset_release_agent(pathbuf);
+
 	return 0;
 }
 
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -6274,6 +6274,9 @@ error:
  */
 static int arch_init_sched_domains(const cpumask_t *cpu_map)
 {
+#ifdef CONFIG_CPUSETS
+	return cpuset_hotplug_update_sched_domains();
+#else
 	cpumask_t cpu_default_map;
 	int err;
 
@@ -6287,6 +6290,7 @@ static int arch_init_sched_domains(const
 	err = build_sched_domains(&cpu_default_map);
 
 	return err;
+#endif
 }
 
 static void arch_destroy_sched_domains(const cpumask_t *cpu_map)
@@ -6310,29 +6314,26 @@ static void detach_destroy_domains(const
 
 /*
  * Partition sched domains as specified by the cpumasks below.
- * This attaches all cpus from the cpumasks to the NULL domain,
+ * This attaches all cpus from the partition to the NULL domain,
  * waits for a RCU quiescent period, recalculates sched
- * domain information and then attaches them back to the
- * correct sched domains
- * Call with hotplug lock held
+ * domain information and then attaches them back to their own
+ * isolated partition.
+ *
+ * Called with hotplug lock held
+ *
+ * Returns 0 on success.
  */
-int partition_sched_domains(cpumask_t *partition1, cpumask_t *partition2)
+int partition_sched_domains(cpumask_t *partition)
 {
+	cpumask_t non_isolated_cpus;
 	cpumask_t change_map;
-	int err = 0;
 
-	cpus_and(*partition1, *partition1, cpu_online_map);
-	cpus_and(*partition2, *partition2, cpu_online_map);
-	cpus_or(change_map, *partition1, *partition2);
+	cpus_andnot(non_isolated_cpus, cpu_online_map, cpu_isolated_map);
+	cpus_and(change_map, *partition, non_isolated_cpus);
 
 	/* Detach sched domains from all of the affected cpus */
 	detach_destroy_domains(&change_map);
-	if (!cpus_empty(*partition1))
-		err = build_sched_domains(partition1);
-	if (!err && !cpus_empty(*partition2))
-		err = build_sched_domains(partition2);
-
-	return err;
+	return build_sched_domains(&change_map);
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
