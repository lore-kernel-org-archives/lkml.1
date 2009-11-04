Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbZKDP1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbZKDP1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbZKDP1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:27:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:57406 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085AbZKDP1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:27:07 -0500
Date: Wed, 4 Nov 2009 15:26:25 GMT
From: tip-bot for Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <200911031453.40668.rusty@rustcorp.com.au>
References: <200911031453.40668.rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] cpumask: Partition_sched_domains takes array of cpumask_var_t
Message-ID: <tip-acc3f5d7cabbfd6cec71f0c1f9900621fa2d6ae7@git.kernel.org>
Git-Commit-ID: acc3f5d7cabbfd6cec71f0c1f9900621fa2d6ae7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  acc3f5d7cabbfd6cec71f0c1f9900621fa2d6ae7
Gitweb:     http://git.kernel.org/tip/acc3f5d7cabbfd6cec71f0c1f9900621fa2d6ae7
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Tue, 3 Nov 2009 14:53:40 +1030
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 13:16:40 +0100

cpumask: Partition_sched_domains takes array of cpumask_var_t

Currently partition_sched_domains() takes a 'struct cpumask
*doms_new' which is a kmalloc'ed array of cpumask_t.  You can't
have such an array if 'struct cpumask' is undefined, as we plan
for CONFIG_CPUMASK_OFFSTACK=y.

So, we make this an array of cpumask_var_t instead: this is the
same for the CONFIG_CPUMASK_OFFSTACK=n case, but requires
multiple allocations for the CONFIG_CPUMASK_OFFSTACK=y case.
Hence we add alloc_sched_domains() and free_sched_domains()
functions.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <200911031453.40668.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    8 ++++-
 kernel/cpuset.c       |   19 ++++++-------
 kernel/sched.c        |   68 +++++++++++++++++++++++++++++++++----------------
 3 files changed, 61 insertions(+), 34 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index dfc21fb..78ba664 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1009,9 +1009,13 @@ static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
 	return to_cpumask(sd->span);
 }
 
-extern void partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
+extern void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 				    struct sched_domain_attr *dattr_new);
 
+/* Allocate an array of sched domains, for partition_sched_domains(). */
+cpumask_var_t *alloc_sched_domains(unsigned int ndoms);
+void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
+
 /* Test a flag in parent sched domain */
 static inline int test_sd_parent(struct sched_domain *sd, int flag)
 {
@@ -1029,7 +1033,7 @@ unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
 struct sched_domain_attr;
 
 static inline void
-partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
+partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 			struct sched_domain_attr *dattr_new)
 {
 }
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d247381..3cf2183 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -537,8 +537,7 @@ update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
  *	element of the partition (one sched domain) to be passed to
  *	partition_sched_domains().
  */
-/* FIXME: see the FIXME in partition_sched_domains() */
-static int generate_sched_domains(struct cpumask **domains,
+static int generate_sched_domains(cpumask_var_t **domains,
 			struct sched_domain_attr **attributes)
 {
 	LIST_HEAD(q);		/* queue of cpusets to be scanned */
@@ -546,7 +545,7 @@ static int generate_sched_domains(struct cpumask **domains,
 	struct cpuset **csa;	/* array of all cpuset ptrs */
 	int csn;		/* how many cpuset ptrs in csa so far */
 	int i, j, k;		/* indices for partition finding loops */
-	struct cpumask *doms;	/* resulting partition; i.e. sched domains */
+	cpumask_var_t *doms;	/* resulting partition; i.e. sched domains */
 	struct sched_domain_attr *dattr;  /* attributes for custom domains */
 	int ndoms = 0;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] struct cpumask slot */
@@ -557,7 +556,8 @@ static int generate_sched_domains(struct cpumask **domains,
 
 	/* Special case for the 99% of systems with one, full, sched domain */
 	if (is_sched_load_balance(&top_cpuset)) {
-		doms = kmalloc(cpumask_size(), GFP_KERNEL);
+		ndoms = 1;
+		doms = alloc_sched_domains(ndoms);
 		if (!doms)
 			goto done;
 
@@ -566,9 +566,8 @@ static int generate_sched_domains(struct cpumask **domains,
 			*dattr = SD_ATTR_INIT;
 			update_domain_attr_tree(dattr, &top_cpuset);
 		}
-		cpumask_copy(doms, top_cpuset.cpus_allowed);
+		cpumask_copy(doms[0], top_cpuset.cpus_allowed);
 
-		ndoms = 1;
 		goto done;
 	}
 
@@ -636,7 +635,7 @@ restart:
 	 * Now we know how many domains to create.
 	 * Convert <csn, csa> to <ndoms, doms> and populate cpu masks.
 	 */
-	doms = kmalloc(ndoms * cpumask_size(), GFP_KERNEL);
+	doms = alloc_sched_domains(ndoms);
 	if (!doms)
 		goto done;
 
@@ -656,7 +655,7 @@ restart:
 			continue;
 		}
 
-		dp = doms + nslot;
+		dp = doms[nslot];
 
 		if (nslot == ndoms) {
 			static int warnings = 10;
@@ -718,7 +717,7 @@ done:
 static void do_rebuild_sched_domains(struct work_struct *unused)
 {
 	struct sched_domain_attr *attr;
-	struct cpumask *doms;
+	cpumask_var_t *doms;
 	int ndoms;
 
 	get_online_cpus();
@@ -2052,7 +2051,7 @@ static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
 				unsigned long phase, void *unused_cpu)
 {
 	struct sched_domain_attr *attr;
-	struct cpumask *doms;
+	cpumask_var_t *doms;
 	int ndoms;
 
 	switch (phase) {
diff --git a/kernel/sched.c b/kernel/sched.c
index 30fd0ba..ae026aa 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8846,7 +8846,7 @@ static int build_sched_domains(const struct cpumask *cpu_map)
 	return __build_sched_domains(cpu_map, NULL);
 }
 
-static struct cpumask *doms_cur;	/* current sched domains */
+static cpumask_var_t *doms_cur;	/* current sched domains */
 static int ndoms_cur;		/* number of sched domains in 'doms_cur' */
 static struct sched_domain_attr *dattr_cur;
 				/* attribues of custom domains in 'doms_cur' */
@@ -8868,6 +8868,31 @@ int __attribute__((weak)) arch_update_cpu_topology(void)
 	return 0;
 }
 
+cpumask_var_t *alloc_sched_domains(unsigned int ndoms)
+{
+	int i;
+	cpumask_var_t *doms;
+
+	doms = kmalloc(sizeof(*doms) * ndoms, GFP_KERNEL);
+	if (!doms)
+		return NULL;
+	for (i = 0; i < ndoms; i++) {
+		if (!alloc_cpumask_var(&doms[i], GFP_KERNEL)) {
+			free_sched_domains(doms, i);
+			return NULL;
+		}
+	}
+	return doms;
+}
+
+void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms)
+{
+	unsigned int i;
+	for (i = 0; i < ndoms; i++)
+		free_cpumask_var(doms[i]);
+	kfree(doms);
+}
+
 /*
  * Set up scheduler domains and groups. Callers must hold the hotplug lock.
  * For now this just excludes isolated cpus, but could be used to
@@ -8879,12 +8904,12 @@ static int arch_init_sched_domains(const struct cpumask *cpu_map)
 
 	arch_update_cpu_topology();
 	ndoms_cur = 1;
-	doms_cur = kmalloc(cpumask_size(), GFP_KERNEL);
+	doms_cur = alloc_sched_domains(ndoms_cur);
 	if (!doms_cur)
-		doms_cur = fallback_doms;
-	cpumask_andnot(doms_cur, cpu_map, cpu_isolated_map);
+		doms_cur = &fallback_doms;
+	cpumask_andnot(doms_cur[0], cpu_map, cpu_isolated_map);
 	dattr_cur = NULL;
-	err = build_sched_domains(doms_cur);
+	err = build_sched_domains(doms_cur[0]);
 	register_sched_domain_sysctl();
 
 	return err;
@@ -8934,19 +8959,19 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
  * doms_new[] to the current sched domain partitioning, doms_cur[].
  * It destroys each deleted domain and builds each new domain.
  *
- * 'doms_new' is an array of cpumask's of length 'ndoms_new'.
+ * 'doms_new' is an array of cpumask_var_t's of length 'ndoms_new'.
  * The masks don't intersect (don't overlap.) We should setup one
  * sched domain for each mask. CPUs not in any of the cpumasks will
  * not be load balanced. If the same cpumask appears both in the
  * current 'doms_cur' domains and in the new 'doms_new', we can leave
  * it as it is.
  *
- * The passed in 'doms_new' should be kmalloc'd. This routine takes
- * ownership of it and will kfree it when done with it. If the caller
- * failed the kmalloc call, then it can pass in doms_new == NULL &&
- * ndoms_new == 1, and partition_sched_domains() will fallback to
- * the single partition 'fallback_doms', it also forces the domains
- * to be rebuilt.
+ * The passed in 'doms_new' should be allocated using
+ * alloc_sched_domains.  This routine takes ownership of it and will
+ * free_sched_domains it when done with it. If the caller failed the
+ * alloc call, then it can pass in doms_new == NULL && ndoms_new == 1,
+ * and partition_sched_domains() will fallback to the single partition
+ * 'fallback_doms', it also forces the domains to be rebuilt.
  *
  * If doms_new == NULL it will be replaced with cpu_online_mask.
  * ndoms_new == 0 is a special case for destroying existing domains,
@@ -8954,8 +8979,7 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
  *
  * Call with hotplug lock held
  */
-/* FIXME: Change to struct cpumask *doms_new[] */
-void partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
+void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 			     struct sched_domain_attr *dattr_new)
 {
 	int i, j, n;
@@ -8974,40 +8998,40 @@ void partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
 	/* Destroy deleted domains */
 	for (i = 0; i < ndoms_cur; i++) {
 		for (j = 0; j < n && !new_topology; j++) {
-			if (cpumask_equal(&doms_cur[i], &doms_new[j])
+			if (cpumask_equal(doms_cur[i], doms_new[j])
 			    && dattrs_equal(dattr_cur, i, dattr_new, j))
 				goto match1;
 		}
 		/* no match - a current sched domain not in new doms_new[] */
-		detach_destroy_domains(doms_cur + i);
+		detach_destroy_domains(doms_cur[i]);
 match1:
 		;
 	}
 
 	if (doms_new == NULL) {
 		ndoms_cur = 0;
-		doms_new = fallback_doms;
-		cpumask_andnot(&doms_new[0], cpu_online_mask, cpu_isolated_map);
+		doms_new = &fallback_doms;
+		cpumask_andnot(doms_new[0], cpu_online_mask, cpu_isolated_map);
 		WARN_ON_ONCE(dattr_new);
 	}
 
 	/* Build new domains */
 	for (i = 0; i < ndoms_new; i++) {
 		for (j = 0; j < ndoms_cur && !new_topology; j++) {
-			if (cpumask_equal(&doms_new[i], &doms_cur[j])
+			if (cpumask_equal(doms_new[i], doms_cur[j])
 			    && dattrs_equal(dattr_new, i, dattr_cur, j))
 				goto match2;
 		}
 		/* no match - add a new doms_new */
-		__build_sched_domains(doms_new + i,
+		__build_sched_domains(doms_new[i],
 					dattr_new ? dattr_new + i : NULL);
 match2:
 		;
 	}
 
 	/* Remember the new sched domains */
-	if (doms_cur != fallback_doms)
-		kfree(doms_cur);
+	if (doms_cur != &fallback_doms)
+		free_sched_domains(doms_cur, ndoms_cur);
 	kfree(dattr_cur);	/* kfree(NULL) is safe */
 	doms_cur = doms_new;
 	dattr_cur = dattr_new;
