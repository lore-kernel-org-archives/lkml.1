Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbXJYWy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbXJYWy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbXJYWyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:54:21 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31099 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbXJYWyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:54:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=ejMvvQVjIX1VvRabH+e/BYOYQ4IUCXmxOCNvk2s/4xhMcsYgbacW2OaWeLYPlluxl
	9izM1jC5hDuabqR2+wEYQ==
Date: Thu, 25 Oct 2007 15:54:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a new 'interleave_over_allowed' option to cpusets.

When a task with an MPOL_INTERLEAVE memory policy is attached to a cpuset
with this option set, the interleaved nodemask becomes the cpuset's
mems_allowed.  When the cpuset's mems_allowed changes, the interleaved
nodemask for all tasks with MPOL_INTERLEAVE memory policies is also
updated to be the new mems_allowed nodemask.

This allows applications to specify that they want to interleave over all
nodes that they are allowed to access.  This set of nodes can be changed
at any time via the cpuset interface and each individual memory policy is
updated to reflect the changes for all attached tasks when this option is
set.

Cc: Andi Kleen <ak@suse.de>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/cpusets.txt |   30 +++++++++++++++++++-
 include/linux/cpuset.h    |    6 ++++
 kernel/cpuset.c           |   64 +++++++++++++++++++++++++++++++++++++++++++++
 mm/mempolicy.c            |    6 ++++
 4 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/Documentation/cpusets.txt b/Documentation/cpusets.txt
--- a/Documentation/cpusets.txt
+++ b/Documentation/cpusets.txt
@@ -20,7 +20,8 @@ CONTENTS:
   1.5 What is memory_pressure ?
   1.6 What is memory spread ?
   1.7 What is sched_load_balance ?
-  1.8 How do I use cpusets ?
+  1.8 What is interleave_over_allowed ?
+  1.9 How do I use cpusets ?
 2. Usage Examples and Syntax
   2.1 Basic Usage
   2.2 Adding/removing cpus
@@ -497,7 +498,32 @@ the cpuset code to update these sched domains, it compares the new
 partition requested with the current, and updates its sched domains,
 removing the old and adding the new, for each change.
 
-1.8 How do I use cpusets ?
+1.8 What is interleave_over_allowed ?
+-------------------------------------
+
+Tasks may specify a memory policy of MPOL_INTERLEAVE with the desired
+result of interleaving memory allocations over their set of allowed
+nodes.
+
+Since the set of allowed nodes may change via cpusets (through the
+'mems' file) without knowledge to the application, a mechanism needs
+to exist such that applications can specify that they desire to
+interleave over all nodes to which they have access.  This avoids a
+constant get_mempolicy() and set_mempolicy() loop to update an
+interleaved memory policy that respects both its cpuset's mems_allowed
+and the intent of the application.
+
+When interleave_over_allowed is set, all attached tasks with
+MPOL_INTERLEAVE memory policies automatically interleave over all
+available cpuset nodes regardless of what nodemask was passed to
+set_mempolicy().  When the cpuset's mems change, all attached tasks
+with interleaved policies automatically gets updated with the new
+nodemask.
+
+The value of 'interleave_over_allowed' is inherited from a cpuset's
+parent upon creation.
+
+1.9 How do I use cpusets ?
 --------------------------
 
 In order to minimize the impact of cpusets on critical kernel
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -77,6 +77,7 @@ static inline int cpuset_do_slab_mem_spread(void)
 extern void cpuset_track_online_nodes(void);
 
 extern int current_cpuset_is_being_rebound(void);
+extern nodemask_t current_cpuset_interleaved_mems(void);
 
 #else /* !CONFIG_CPUSETS */
 
@@ -157,6 +158,11 @@ static inline int current_cpuset_is_being_rebound(void)
 	return 0;
 }
 
+static inline nodemask_t current_cpuset_interleaved_mems(void)
+{
+	return NODE_MASK_NONE;
+}
+
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -121,6 +121,7 @@ typedef enum {
 	CS_SCHED_LOAD_BALANCE,
 	CS_SPREAD_PAGE,
 	CS_SPREAD_SLAB,
+	CS_INTERLEAVE,
 } cpuset_flagbits_t;
 
 /* convenient tests for these bits */
@@ -154,6 +155,11 @@ static inline int is_spread_slab(const struct cpuset *cs)
 	return test_bit(CS_SPREAD_SLAB, &cs->flags);
 }
 
+static inline int is_interleave_over_allowed(const struct cpuset *cs)
+{
+	return test_bit(CS_INTERLEAVE, &cs->flags);
+}
+
 /*
  * Increment this integer everytime any cpuset changes its
  * mems_allowed value.  Users of cpusets can track this generation
@@ -1089,6 +1095,46 @@ static int update_memory_pressure_enabled(struct cpuset *cs, char *buf)
 	return 0;
 }
 
+/* Rebinds the memory policies of all tasks attached to cs.
+ *
+ * Call with cgroup_mutex held.
+ */
+static int update_interleave(struct cpuset *cs, char *buf)
+{
+	struct mm_struct **mmarray;
+	int ntasks;
+	int i;
+
+	if (!simple_strtoul(buf, NULL, 10)) {
+		clear_bit(CS_INTERLEAVE, &cs->flags);
+		return 0;
+	}
+
+	mmarray = get_cpuset_mm_array(cs, &ntasks);
+	if (!mmarray)
+		return -ENOMEM;
+	if (!ntasks)
+		goto done;
+
+	for (i = 0; i < ntasks; i++)
+		mpol_rebind_mm(mmarray[i], &cs->mems_allowed);
+done:
+	put_cpuset_mm_array(mmarray, ntasks);
+	set_bit(CS_INTERLEAVE, &cs->flags);
+	return 0;
+}
+
+nodemask_t current_cpuset_interleaved_mems(void)
+{
+	nodemask_t mask = NODE_MASK_NONE;
+
+	mutex_lock(&callback_mutex);
+	if (is_interleave_over_allowed(task_cs(current)))
+		mask = task_cs(current)->mems_allowed;
+	mutex_unlock(&callback_mutex);
+	return mask;
+}
+
 /*
  * update_flag - read a 0 or a 1 in a file and update associated flag
  * bit:	the bit to update (CS_CPU_EXCLUSIVE, CS_MEM_EXCLUSIVE,
@@ -1283,6 +1329,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_INTERLEAVE_OVER_ALLOWED,
 } cpuset_filetype_t;
 
 static ssize_t cpuset_common_file_write(struct cgroup *cont,
@@ -1350,6 +1397,9 @@ static ssize_t cpuset_common_file_write(struct cgroup *cont,
 		retval = update_flag(CS_SPREAD_SLAB, cs, buffer);
 		cs->mems_generation = cpuset_mems_generation++;
 		break;
+	case FILE_INTERLEAVE_OVER_ALLOWED:
+		retval = update_interleave(cs, buffer);
+		break;
 	default:
 		retval = -EINVAL;
 		goto out2;
@@ -1446,6 +1496,9 @@ static ssize_t cpuset_common_file_read(struct cgroup *cont,
 	case FILE_SPREAD_SLAB:
 		*s++ = is_spread_slab(cs) ? '1' : '0';
 		break;
+	case FILE_INTERLEAVE_OVER_ALLOWED:
+		*s++ = is_interleave_over_allowed(cs) ? '1' : '0';
+		break;
 	default:
 		retval = -EINVAL;
 		goto out;
@@ -1536,6 +1589,13 @@ static struct cftype cft_spread_slab = {
 	.private = FILE_SPREAD_SLAB,
 };
 
+static struct cftype cft_interleave_over_allowed = {
+	.name = "interleave_over_allowed",
+	.read = cpuset_common_file_read,
+	.write = cpuset_common_file_write,
+	.private = FILE_INTERLEAVE_OVER_ALLOWED,
+};
+
 static int cpuset_populate(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	int err;
@@ -1558,6 +1618,8 @@ static int cpuset_populate(struct cgroup_subsys *ss, struct cgroup *cont)
 		return err;
 	if ((err = cgroup_add_file(cont, ss, &cft_spread_slab)) < 0)
 		return err;
+	if ((err = cgroup_add_file(cont, ss, &cft_interleave_over_allowed)) < 0)
+		return err;
 	/* memory_pressure_enabled is in root cpuset only */
 	if (err == 0 && !cont->parent)
 		err = cgroup_add_file(cont, ss,
@@ -1633,6 +1695,8 @@ static struct cgroup_subsys_state *cpuset_create(
 		set_bit(CS_SPREAD_PAGE, &cs->flags);
 	if (is_spread_slab(parent))
 		set_bit(CS_SPREAD_SLAB, &cs->flags);
+	if (is_interleave_over_allowed(parent))
+		set_bit(CS_INTERLEAVE, &cs->flags);
 	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	cs->cpus_allowed = CPU_MASK_NONE;
 	cs->mems_allowed = NODE_MASK_NONE;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1739,6 +1739,12 @@ static void mpol_rebind_policy(struct mempolicy *pol,
 	case MPOL_DEFAULT:
 		break;
 	case MPOL_INTERLEAVE:
+		tmp = current_cpuset_interleaved_mems();
+		if (!nodes_empty(tmp)) {
+			pol->v.nodes = tmp;
+			*mpolmask = tmp;
+			break;
+		}
 		nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
 		pol->v.nodes = tmp;
 		*mpolmask = *newmask;
