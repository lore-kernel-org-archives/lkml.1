Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbYHDGAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbYHDGAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbYHDGAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:00:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33237 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753492AbYHDGAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:00:38 -0400
Date: Mon, 4 Aug 2008 01:00:33 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
Message-Id: <20080804010033.0d1b0549.pj@sgi.com>
In-Reply-To: <4895F3ED.4020805@qualcomm.com>
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>
	<20080802063900.6615e5ca.pj@sgi.com>
	<48948C3A.6050805@qualcomm.com>
	<20080802225127.2b0d138b.pj@sgi.com>
	<4895F3ED.4020805@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far as I can tell, the logic and design is ok.

I found some of the comments, function names and code factoring
to be confusing or incomplete.  And I suspect that the rebuilding
of sched domains in the case that sched_power_savings_store()
is called in kernel/sched.c, on systems using cpusets, is not
needed or desirable (I could easily be wrong here - beware!).

I'm attaching a patch that has the changes that I would like
to suggest for your consideration.  I have only recompiled this
patch, for one configuration - x86_64 with CPUSETS.  I am hoping,
Max, that you can complete the testing.

The patch below applies to 2.6.27-rc1, plus the first patch,
"origin.patch" in Andrew's 2.6.27-rc1-mm1 quilt patch stack,
plus your (Max's) latest:
    [PATCH] cpuset: Rework sched domains and CPU hotplug handling (2.6.27-rc1)

Here's a description of most of what I noticed:

 1) Unrelated spacing tweak, changing:
        LIST_HEAD(q);           /* queue of cpusets to be scanned*/
    to:
        LIST_HEAD(q);           /* queue of cpusets to be scanned */

 2) The phrasing:
	Must be called with cgroup_lock held.
    seems imprecise to me; "cgroup_lock" is the name of a wrapper
    function, not of a lock.  The underlying lock is cgroup_mutex,
    which is still mentioned by name in various kernel/cpuset.c
    comments, even though cgroup_mutex is static in kernel/cgroup.c
    So I fiddled with the wording of this phrasing.

 3) You removed the paragraph:
	  * ...  May take callback_mutex during
	  * call due to the kfifo_alloc() and kmalloc() calls.  May nest
	  * a call to the get_online_cpus()/put_online_cpus() pair.
	  * Must not be called holding callback_mutex, because we must not
	  * call get_online_cpus() while holding callback_mutex.  Elsewhere
	  * the kernel nests callback_mutex inside get_online_cpus() calls.
	  * So the reverse nesting would risk an ABBA deadlock.
   
   But you didn't replace it with an updated locking description.
   I expanded and tweaked various locking comments.

 4) The alignment of the right side of consecutive assignment statements,
    as in:
        ndoms = 0;
        doms  = NULL;
        dattr = NULL;
        csa   = NULL;
    or
        *domains    = doms;
        *attributes = dattr;
    is not usually done in kernel code.  I suggest obeying convention,
    and not aligning these here either.

 5) The rebuilding of sched domains in the sched_power_savings_store()
    routine in kernel/sched.c struck me as inappropriate for systems
    that were managing sched domains using cpusets.  So I made that
    sched.c rebuild only apply if CONFIG_CPUSETS was not configured,
    which in turn enabled me to remove rebuild_sched_domains() from
    being externally visible outside kernel/cpuset.c
    
    I don't know if this change is correct, however.

 6) The renaming of rebuild_sched_domains() to generate_sched_domains()
    was only partial, and along with the added similarly named routines
    seemed confusing to me.  Also, that rename of rebuild_sched_domains()
    was only partially accomplished, not being done in some comments
    and in one printk kernel warning.

    I reverted that rename.
    
    I also reduced by one the number of functions needed to handle
    the asynchronous invocation of this rebuild, essentially collapsing
    your routines rebuild_sched_domains() and rebuild_domains_callback()
    into a single routine, named rebuild_sched_domains_thread().

    Thanks to the above change (5), the naming and structure of these
    routines was no longer visible outside kernel/cpuset.c, making
    this collapsing of two functions into one easier.

---
 include/linux/cpuset.h |    7 ----
 kernel/cpuset.c        |   73 ++++++++++++++++++++++++-------------------------
 kernel/sched.c         |   18 ++++--------
 3 files changed, 43 insertions(+), 55 deletions(-)

--- 2.6.27-rc1-mm1.orig/include/linux/cpuset.h	2008-08-02 03:51:59.000000000 -0700
+++ 2.6.27-rc1-mm1/include/linux/cpuset.h	2008-08-03 19:24:40.306964316 -0700
@@ -78,8 +78,6 @@ extern void cpuset_track_online_nodes(vo
 
 extern int current_cpuset_is_being_rebound(void);
 
-extern void rebuild_sched_domains(void);
-
 #else /* !CONFIG_CPUSETS */
 
 static inline int cpuset_init_early(void) { return 0; }
@@ -158,11 +156,6 @@ static inline int current_cpuset_is_bein
 	return 0;
 }
 
-static inline void rebuild_sched_domains(void)
-{
-	partition_sched_domains(0, NULL, NULL);
-}
-
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
--- 2.6.27-rc1-mm1.orig/kernel/cpuset.c	2008-08-02 09:42:56.000000000 -0700
+++ 2.6.27-rc1-mm1/kernel/cpuset.c	2008-08-03 21:55:31.983690126 -0700
@@ -482,7 +482,7 @@ static int validate_change(const struct 
 }
 
 /*
- * Helper routine for generate_sched_domains().
+ * Helper routine for rebuild_sched_domains().
  * Do cpusets a, b have overlapping cpus_allowed masks?
  */
 static int cpusets_overlap(struct cpuset *a, struct cpuset *b)
@@ -526,11 +526,12 @@ update_domain_attr_tree(struct sched_dom
 }
 
 /*
- * generate_sched_domains()
+ * rebuild_sched_domains()
  *
  * This function builds a partial partition of the systems CPUs
  * A 'partial partition' is a set of non-overlapping subsets whose
  * union is a subset of that set.
+ *
  * The output of this function needs to be passed to kernel/sched.c
  * partition_sched_domains() routine, which will rebuild the scheduler's
  * load balancing domains (sched domains) as specified by that partial
@@ -579,10 +580,10 @@ update_domain_attr_tree(struct sched_dom
  *	element of the partition (one sched domain) to be passed to
  *	partition_sched_domains().
  */
-static int generate_sched_domains(cpumask_t **domains,
+static int rebuild_sched_domains(cpumask_t **domains,
 			struct sched_domain_attr **attributes)
 {
-	LIST_HEAD(q);		/* queue of cpusets to be scanned*/
+	LIST_HEAD(q);		/* queue of cpusets to be scanned */
 	struct cpuset *cp;	/* scans q */
 	struct cpuset **csa;	/* array of all cpuset ptrs */
 	int csn;		/* how many cpuset ptrs in csa so far */
@@ -593,9 +594,9 @@ static int generate_sched_domains(cpumas
 	int nslot;		/* next empty doms[] cpumask_t slot */
 
 	ndoms = 0;
-	doms  = NULL;
+	doms = NULL;
 	dattr = NULL;
-	csa   = NULL;
+	csa = NULL;
 
 	/* Special case for the 99% of systems with one, full, sched domain */
 	if (is_sched_load_balance(&top_cpuset)) {
@@ -733,49 +734,41 @@ restart:
 done:
 	kfree(csa);
 
-	*domains    = doms;
+	*domains = doms;
 	*attributes = dattr;
 	return ndoms;
 }
 
 /*
- * Rebuilds scheduler domains. See generate_sched_domains() description
- * for details.
+ * Rebuild scheduler domains, called from rebuild_sched_domains_work
+ * work queue.
+ *
+ * Call with neither cgroup_mutex held nor within get_online_cpus().
+ * Takes both cgroup_mutex and get_online_cpus().
  *
- * Must be called under get_online_cpus(). This is an external interface
- * and must not be used inside the cpuset code to avoid circular locking
- * dependency. cpuset code should use async_rebuild_sched_domains() instead.
+ * Cannot be directly called from cpuset code handling changes
+ * to the cpuset pseudo-filesystem, because it cannot be called
+ * from code that already holds cgroup_mutex.
  */
-void rebuild_sched_domains(void)
+static void rebuild_sched_domains_thread(struct work_struct *unused)
 {
 	struct sched_domain_attr *attr;
 	cpumask_t *doms;
 	int ndoms;
 
-	/*
-	 * We have to iterate cgroup hierarch which requires cgroup lock.
-	 */
+	get_online_cpus();
 	cgroup_lock();
-	ndoms = generate_sched_domains(&doms, &attr);
+	ndoms = rebuild_sched_domains(&doms, &attr);
 	cgroup_unlock();
 
 	/* Have scheduler rebuild the domains */
 	partition_sched_domains(ndoms, doms, attr);
-}
-
-/*
- * Simply calls rebuild_sched_domains() with correct locking rules.
- */
-static void rebuild_domains_callback(struct work_struct *work)
-{
-	get_online_cpus();
-	rebuild_sched_domains();
 	put_online_cpus();
 }
-static DECLARE_WORK(rebuild_domains_work, rebuild_domains_callback);
+static DECLARE_WORK(rebuild_sched_domains_work, rebuild_sched_domains_thread);
 
 /*
- * Internal helper for rebuilding sched domains when something changes.
+ * Rebuild scheduler domains, asynchronously in a separate thread.
  *
  * If the flag 'sched_load_balance' of any cpuset with non-empty
  * 'cpus' changes, or if the 'cpus' allowed changes in any cpuset
@@ -783,14 +776,19 @@ static DECLARE_WORK(rebuild_domains_work
  * 'cpus' is removed, then call this routine to rebuild the
  * scheduler's dynamic sched domains.
  *
- * rebuild_sched_domains() must be called under get_online_cpus() and
- * it needs to take cgroup_lock(). But most of the cpuset code is already
- * holding cgroup_lock(). In order to avoid incorrect lock nesting we
- * delegate the actual domain rebuilding to the workqueue.
+ * The rebuild_sched_domains() and partition_sched_domains()
+ * routines must nest cgroup_lock() inside get_online_cpus(),
+ * but such cpuset changes as these must nest that locking the
+ * other way, holding cgroup_lock() for much of the code.
+ *
+ * So in order to avoid an ABBA deadlock, the cpuset code handling
+ * these user changes delegates the actual sched domain rebuilding
+ * to a separate workqueue thread, which ends up processing the
+ * above rebuild_sched_domains_thread() function.
  */
 static void async_rebuild_sched_domains(void)
 {
-	queue_work(cpuset_wq, &rebuild_domains_work);
+	queue_work(cpuset_wq, &rebuild_sched_domains_work);
 }
 
 /**
@@ -1756,7 +1754,7 @@ static struct cgroup_subsys_state *cpuse
 /*
  * If the cpuset being removed has its flag 'sched_load_balance'
  * enabled, then simulate turning sched_load_balance off, which
- * will call rebuild_sched_domains().
+ * will call async_rebuild_sched_domains().
  */
 
 static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
@@ -1775,7 +1773,7 @@ static void cpuset_destroy(struct cgroup
 struct cgroup_subsys cpuset_subsys = {
 	.name = "cpuset",
 	.create = cpuset_create,
-	.destroy  = cpuset_destroy,
+	.destroy = cpuset_destroy,
 	.can_attach = cpuset_can_attach,
 	.attach = cpuset_attach,
 	.populate = cpuset_populate,
@@ -1966,6 +1964,9 @@ static void scan_for_empty_cpusets(const
  *
  * This routine ensures that top_cpuset.cpus_allowed tracks
  * cpu_online_map on each CPU hotplug (cpuhp) event.
+ *
+ * Called within get_online_cpus().  Needs to call cgroup_lock()
+ * before calling rebuild_sched_domains().
  */
 static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
 				unsigned long phase, void *unused_cpu)
@@ -1988,7 +1989,7 @@ static int cpuset_track_online_cpus(stru
 	cgroup_lock();
 	top_cpuset.cpus_allowed = cpu_online_map;
 	scan_for_empty_cpusets(&top_cpuset);
-	ndoms = generate_sched_domains(&doms, &attr);
+	ndoms = rebuild_sched_domains(&doms, &attr);
 	cgroup_unlock();
 
 	/* Have scheduler rebuild the domains */
--- 2.6.27-rc1-mm1.orig/kernel/sched.c	2008-08-02 04:12:13.000000000 -0700
+++ 2.6.27-rc1-mm1/kernel/sched.c	2008-08-03 19:55:40.128044004 -0700
@@ -7645,18 +7645,8 @@ match2:
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-int arch_reinit_sched_domains(void)
-{
-	get_online_cpus();
-	rebuild_sched_domains();
-	put_online_cpus();
-	return 0;
-}
-
 static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 {
-	int ret;
-
 	if (buf[0] != '0' && buf[0] != '1')
 		return -EINVAL;
 
@@ -7665,9 +7655,13 @@ static ssize_t sched_power_savings_store
 	else
 		sched_mc_power_savings = (buf[0] == '1');
 
-	ret = arch_reinit_sched_domains();
+#ifndef CONFIG_CPUSETS
+	get_online_cpus();
+	partition_sched_domains(0, NULL, NULL);
+	put_online_cpus();
+#endif
 
-	return ret ? ret : count;
+	return count;
 }
 
 #ifdef CONFIG_SCHED_MC


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
