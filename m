Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbXJQGsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbXJQGsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 02:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbXJQGsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 02:48:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47120 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752010AbXJQGsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 02:48:32 -0400
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Dinakar Guniguntala <dino@in.ibm.com>, Cliff Wickman <cpw@sgi.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Tue, 16 Oct 2007 23:48:29 -0700
Message-Id: <20071017064829.31240.15296.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH] cpuset sched_load_balance kmalloc fix
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Properly check return value of kmalloc'd dynamic sched domain
cpumasks, and fallback to a non-kmalloc'd default (one large
sched domain) if kmalloc fails.

Signed-off-by: Paul Jackson <pj@sgi.com>

---

This fix applies to and goes anywhere after the patch:

  cpuset-sched_load_balance-flag.patch

 kernel/cpuset.c |    4 +++-
 kernel/sched.c  |   25 ++++++++++++++++++++++---
 2 files changed, 25 insertions(+), 4 deletions(-)

--- 2.6.23-mm1.orig/kernel/cpuset.c	2007-10-16 19:00:34.009537656 -0700
+++ 2.6.23-mm1/kernel/cpuset.c	2007-10-16 23:21:08.036687381 -0700
@@ -587,6 +587,8 @@ static void rebuild_sched_domains(void)
 	if (is_sched_load_balance(&top_cpuset)) {
 		ndoms = 1;
 		doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+		if (!doms)
+			goto rebuild;
 		*doms = top_cpuset.cpus_allowed;
 		goto rebuild;
 	}
@@ -640,7 +642,7 @@ restart:
 	/* Convert <csn, csa> to <ndoms, doms> */
 	doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
 	if (!doms)
-		goto done;
+		goto rebuild;
 
 	for (nslot = 0, i = 0; i < csn; i++) {
 		struct cpuset *a = csa[i];
--- 2.6.23-mm1.orig/kernel/sched.c	2007-10-16 18:55:35.325048140 -0700
+++ 2.6.23-mm1/kernel/sched.c	2007-10-16 23:28:30.635328289 -0700
@@ -6209,6 +6209,13 @@ static cpumask_t *doms_cur;	/* current s
 static int ndoms_cur;		/* number of sched domains in 'doms_cur' */
 
 /*
+ * Special case: If a kmalloc of a doms_cur partition (array of
+ * cpumask_t) fails, then fallback to a single sched domain,
+ * as determined by the single cpumask_t fallback_doms.
+ */
+static cpumask_t fallback_doms;
+
+/*
  * Set up scheduler domains and groups.  Callers must hold the hotplug lock.
  * For now this just excludes isolated cpus, but could be used to
  * exclude other special cases in the future.
@@ -6217,6 +6224,8 @@ static int arch_init_sched_domains(const
 {
 	ndoms_cur = 1;
 	doms_cur =  kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+	if (!doms_cur)
+		doms_cur = &fallback_doms;
 	cpus_andnot(*doms_cur, *cpu_map, cpu_isolated_map);
 
 	return build_sched_domains(doms_cur);
@@ -6254,8 +6263,11 @@ static void detach_destroy_domains(const
  * current 'doms_cur' domains and in the new 'doms_new', we can leave
  * it as it is.
  *
- * The passed in 'doms_new' must be kmalloc'd, and this routine takes
- * ownership of it and will kfree it when done with it.
+ * The passed in 'doms_new' should be kmalloc'd.  This routine takes
+ * ownership of it and will kfree it when done with it.  If the caller
+ * failed the kmalloc call, then it can pass in doms_new == NULL,
+ * and partition_sched_domains() will fallback to the single partition
+ * 'fallback_doms'.
  *
  * Call with hotplug lock held
  */
@@ -6263,6 +6275,12 @@ void partition_sched_domains(int ndoms_n
 {
 	int i, j;
 
+	if (doms_new == NULL) {
+		ndoms_new = 1;
+		doms_new = &fallback_doms;
+		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
+	}
+
 	/* Destroy deleted domains */
 	for (i = 0; i < ndoms_cur; i++) {
 		for (j = 0; j < ndoms_new; j++) {
@@ -6288,7 +6306,8 @@ match2:
 	}
 
 	/* Remember the new sched domains */
-	kfree(doms_cur);
+	if (doms_cur != &fallback_doms)
+		kfree(doms_cur);
 	doms_cur = doms_new;
 	ndoms_cur = ndoms_new;
 }

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
