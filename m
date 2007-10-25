Return-Path: <linux-kernel-owner+w=401wt.eu-S1760412AbXJYWyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412AbXJYWyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbXJYWyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:54:22 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31103 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbXJYWyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:54:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=p1UsqFbzUNDfNb5gQE3J62D/bqdx4yzDaltMPyGKuvijYinX+IAVHV9BipVqhOMxb
	0Oppxz4rRnBOyxiLhyVZg==
Date: Thu, 25 Oct 2007 15:54:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 1/2] cpusets: extract mmarray loading from update_nodemask
Message-ID: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Extract a helper function from update_nodemask() to load an array of
mm_struct pointers with references to each task's mm_struct that is
currently attached to a given cpuset.

This will be used later for other purposes where memory policies need to
be rebound for each task attached to a cpuset.

Cc: Andi Kleen <ak@suse.de>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/cpuset.c |  130 ++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 81 insertions(+), 49 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -702,6 +702,79 @@ done:
 	/* Don't kfree(doms) -- partition_sched_domains() does that. */
 }
 
+/*
+ * Loads mmarray with pointers to all the mm_struct's of tasks attached to
+ * cpuset cs.
+ *
+ * The reference count to each mm is incremented before loading it into the
+ * array, so put_cpuset_mm_array() must be called after this function to
+ * decrement each reference count and free the memory allocated for mmarray
+ * via this function.
+ */
+static struct mm_struct **get_cpuset_mm_array(const struct cpuset *cs,
+					      int *ntasks)
+{
+	struct mm_struct **mmarray;
+	struct task_struct *p;
+	struct cgroup_iter it;
+	int count;
+	int fudge;
+
+	*ntasks = 0;
+	fudge = 10;				/* spare mmarray[] slots */
+	fudge += cpus_weight(cs->cpus_allowed);	/* imagine one fork-bomb/cpu */
+	/*
+	 * Allocate mmarray[] to hold mm reference for each task in cpuset cs.
+	 * Can't kmalloc GFP_KERNEL while holding tasklist_lock.  We could use
+	 * GFP_ATOMIC, but with a few more lines of code, we can retry until
+	 * we get a big enough mmarray[] w/o using GFP_ATOMIC.
+	 */
+	while (1) {
+		count = cgroup_task_count(cs->css.cgroup);  /* guess */
+		count += fudge;
+		mmarray = kmalloc(count * sizeof(*mmarray), GFP_KERNEL);
+		if (!mmarray)
+			return NULL;
+		read_lock(&tasklist_lock);		/* block fork */
+		if (cgroup_task_count(cs->css.cgroup) <= count)
+			break;				/* got enough */
+		read_unlock(&tasklist_lock);		/* try again */
+		kfree(mmarray);
+	}
+
+	/* Load up mmarray[] with mm reference for each task in cpuset. */
+	cgroup_iter_start(cs->css.cgroup, &it);
+	while ((p = cgroup_iter_next(cs->css.cgroup, &it))) {
+		struct mm_struct *mm;
+
+		if (*ntasks >= count) {
+			printk(KERN_WARNING
+				"Cpuset mempolicy rebind incomplete.\n");
+			break;
+		}
+		mm = get_task_mm(p);
+		if (!mm)
+			continue;
+		mmarray[(*ntasks)++] = mm;
+	}
+	cgroup_iter_end(cs->css.cgroup, &it);
+	read_unlock(&tasklist_lock);
+	return mmarray;
+}
+
+/*
+ * Decrements the reference count to each mm in mmarray and frees the memory
+ * allocated for mmarray.
+ *
+ * To be used in conjunction with get_cpuset_mm_array().
+ */
+static void put_cpuset_mm_array(struct mm_struct **mmarray, int ntasks)
+{
+	while (ntasks-- > 0)
+		mmput(mmarray[ntasks]);
+	kfree(mmarray);
+}
+
 static inline int started_after_time(struct task_struct *t1,
 				     struct timespec *time,
 				     struct task_struct *t2)
@@ -915,13 +988,10 @@ static int update_nodemask(struct cpuset *cs, char *buf)
 {
 	struct cpuset trialcs;
 	nodemask_t oldmem;
-	struct task_struct *p;
 	struct mm_struct **mmarray;
-	int i, n, ntasks;
+	int i, n;
 	int migrate;
-	int fudge;
 	int retval;
-	struct cgroup_iter it;
 
 	/*
 	 * top_cpuset.mems_allowed tracks node_stats[N_HIGH_MEMORY];
@@ -963,50 +1033,12 @@ static int update_nodemask(struct cpuset *cs, char *buf)
 	mutex_unlock(&callback_mutex);
 
 	cpuset_being_rebound = cs;		/* causes mpol_copy() rebind */
-
-	fudge = 10;				/* spare mmarray[] slots */
-	fudge += cpus_weight(cs->cpus_allowed);	/* imagine one fork-bomb/cpu */
 	retval = -ENOMEM;
-
-	/*
-	 * Allocate mmarray[] to hold mm reference for each task
-	 * in cpuset cs.  Can't kmalloc GFP_KERNEL while holding
-	 * tasklist_lock.  We could use GFP_ATOMIC, but with a
-	 * few more lines of code, we can retry until we get a big
-	 * enough mmarray[] w/o using GFP_ATOMIC.
-	 */
-	while (1) {
-		ntasks = cgroup_task_count(cs->css.cgroup);  /* guess */
-		ntasks += fudge;
-		mmarray = kmalloc(ntasks * sizeof(*mmarray), GFP_KERNEL);
-		if (!mmarray)
-			goto done;
-		read_lock(&tasklist_lock);		/* block fork */
-		if (cgroup_task_count(cs->css.cgroup) <= ntasks)
-			break;				/* got enough */
-		read_unlock(&tasklist_lock);		/* try again */
-		kfree(mmarray);
-	}
-
-	n = 0;
-
-	/* Load up mmarray[] with mm reference for each task in cpuset. */
-	cgroup_iter_start(cs->css.cgroup, &it);
-	while ((p = cgroup_iter_next(cs->css.cgroup, &it))) {
-		struct mm_struct *mm;
-
-		if (n >= ntasks) {
-			printk(KERN_WARNING
-				"Cpuset mempolicy rebind incomplete.\n");
-			break;
-		}
-		mm = get_task_mm(p);
-		if (!mm)
-			continue;
-		mmarray[n++] = mm;
-	}
-	cgroup_iter_end(cs->css.cgroup, &it);
-	read_unlock(&tasklist_lock);
+	mmarray = get_cpuset_mm_array(cs, &n);
+	if (!mmarray)
+		goto done;
+	if (!n)
+		goto done_success;
 
 	/*
 	 * Now that we've dropped the tasklist spinlock, we can
@@ -1028,12 +1060,12 @@ static int update_nodemask(struct cpuset *cs, char *buf)
 		mpol_rebind_mm(mm, &cs->mems_allowed);
 		if (migrate)
 			cpuset_migrate_mm(mm, &oldmem, &cs->mems_allowed);
-		mmput(mm);
 	}
 
 	/* We're done rebinding vma's to this cpusets new mems_allowed. */
-	kfree(mmarray);
 	cpuset_being_rebound = NULL;
+done_success:
+	put_cpuset_mm_array(mmarray, n);
 	retval = 0;
 done:
 	return retval;
