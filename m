Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbXCTSPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbXCTSPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbXCTSPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:15:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56336 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753877AbXCTSPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:15:14 -0400
Date: Tue, 20 Mar 2007 13:14:35 -0600
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] cpusets/sched_domain reconciliation
Message-ID: <4600329B.mailxHGH16L00Y@eag09.americas.sgi.com>
User-Agent: nail 11.4 8/29/04
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: cpw@sgi.com (Cliff Wickman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Cliff Wickman <cpw@sgi.com>

This patch reconciles cpusets and sched_domains that get out of sync
due to disabling and re-enabling of cpu's.

Dinakar Guniguntala (IBM) is working on his own version of fixing this.
But as of this date that fix doesn't seem to be ready.

Here is an example of how the problem can occur:

   system of cpu's 0-31
   create cpuset /x  16-31
   create cpuset /x/y  16-23
   all cpu_exclusive

   disable cpu 17
     x is now    16,18-31
     x/y is now 16,18-23
   enable cpu 17
     x and x/y are unchanged

   to restore the cpusets:
     echo 16-31 > /dev/cpuset/x
     echo 16-23 > /dev/cpuset/x/y

   At the first echo, update_cpu_domains() is called for cpuset x/.

   The system is partitioned between:
	its parent, the root cpuset of 0-31, minus its
				    children (x/ is 16-31): 0-15
        and x/ (16-31), minus its children (x/y/ 16,18-23): 17,24-31

   The sched_domain's for parent 0-15 are updated.
   The sched_domain's for current 17,24-31 are updated.

   But 16 has been untouched.
   As a result, 17's SD points to sched_group_phys[17] which is the only
   sched_group_phys on 17's list.  It points to itself.
   But 16's SD points to sched_group_phys[16], which still points to
   sched_group_phys[17].
   When cpu 16 executes find_busiest_group() it will hang on the non-
   circular sched_group list.
           
This solution is to update the sched_domain's for the cpuset
whose cpu's were changed and, in addition, all its children.
The update_cpu_domains() will end with a (recursive) call to itself
for each child.
The extra sched_domain reconstruction is overhead, but only at the
frequency of administrative change to the cpusets.

This patch also includes checks in find_busiest_group() and
find_idlest_group() that break from their loops on a sched_group that
points to itself.  This is needed because other cpu's are going through
load balancing while the sched_domains are being reconstructed.

There seems to be no administrative procedural work-around.  In the
example above one could not reverse the two echo's and set x/y before
x/.  It is not logical, so not allowed (Permission denied).

Diffed against 2.6.20-rc6

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 kernel/cpuset.c |   11 +++++++++--
 kernel/sched.c  |   19 +++++++++++++++----
 2 files changed, 24 insertions(+), 6 deletions(-)

Index: morton.070205/kernel/sched.c
===================================================================
--- morton.070205.orig/kernel/sched.c
+++ morton.070205/kernel/sched.c
@@ -1201,11 +1201,14 @@ static inline unsigned long cpu_avg_load
 static struct sched_group *
 find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 {
-	struct sched_group *idlest = NULL, *this = NULL, *group = sd->groups;
+	struct sched_group *idlest = NULL, *this = sd->groups, *group = sd->groups;
+	struct sched_group *self, *prev;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
 	int load_idx = sd->forkexec_idx;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
+	prev = group;
+	self = group;
 	do {
 		unsigned long load, avg_load;
 		int local_group;
@@ -1241,8 +1244,10 @@ find_idlest_group(struct sched_domain *s
 			idlest = group;
 		}
 nextgroup:
+		prev = self;
+		self = group;
 		group = group->next;
-	} while (group != sd->groups);
+	} while (group != sd->groups && group != self && group != prev);
 
 	if (!idlest || 100*this_load < imbalance*min_load)
 		return NULL;
@@ -2259,7 +2264,8 @@ find_busiest_group(struct sched_domain *
 		   unsigned long *imbalance, enum idle_type idle, int *sd_idle,
 		   cpumask_t *cpus, int *balance)
 {
-	struct sched_group *busiest = NULL, *this = NULL, *group = sd->groups;
+	struct sched_group *busiest = NULL, *this = sd->groups, *group = sd->groups;
+	struct sched_group *self, *prev;
 	unsigned long max_load, avg_load, total_load, this_load, total_pwr;
 	unsigned long max_pull;
 	unsigned long busiest_load_per_task, busiest_nr_running;
@@ -2282,6 +2288,8 @@ find_busiest_group(struct sched_domain *
 	else
 		load_idx = sd->idle_idx;
 
+	prev = group;
+	self = group;
 	do {
 		unsigned long load, group_capacity;
 		int local_group;
@@ -2410,8 +2418,11 @@ find_busiest_group(struct sched_domain *
 		}
 group_next:
 #endif
+		prev = self;
+		self = group;
 		group = group->next;
-	} while (group != sd->groups);
+		/* careful, a printk here can cause a spinlock hang */
+	} while (group != sd->groups && group != self && group != prev);
 
 	if (!busiest || this_load >= max_load || busiest_nr_running == 0)
 		goto out_balanced;
Index: morton.070205/kernel/cpuset.c
===================================================================
--- morton.070205.orig/kernel/cpuset.c
+++ morton.070205/kernel/cpuset.c
@@ -765,6 +765,8 @@ static int validate_change(const struct 
  * lock_cpu_hotplug()/unlock_cpu_hotplug() pair.
  * Must not be called holding callback_mutex, because we must
  * not call lock_cpu_hotplug() while holding callback_mutex.
+ *
+ * Recursive, on depth of cpuset subtree.
  */
 
 static void update_cpu_domains(struct cpuset *cur)
@@ -790,8 +792,8 @@ static void update_cpu_domains(struct cp
 			return;
 		cspan = CPU_MASK_NONE;
 	} else {
-		if (cpus_empty(pspan))
-			return;
+		/* parent may be empty, but update anyway */
+
 		cspan = cur->cpus_allowed;
 		/*
 		 * Get all cpus from current cpuset's cpus_allowed not part
@@ -806,6 +808,11 @@ static void update_cpu_domains(struct cp
 	lock_cpu_hotplug();
 	partition_sched_domains(&pspan, &cspan);
 	unlock_cpu_hotplug();
+
+	/* walk all its children to make sure it's all consistent */
+	list_for_each_entry(c, &cur->children, sibling) {
+		update_cpu_domains(c);
+	}
 }
 
 /*
