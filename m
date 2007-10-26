Return-Path: <linux-kernel-owner+w=401wt.eu-S1761996AbXJZCPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761996AbXJZCPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762052AbXJZCOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:14:48 -0400
Received: from smtp-out.google.com ([216.239.33.17]:37139 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761427AbXJZCOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:14:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=JYfA6ORLu4FimRbxD8QKQW18lRsABoIWKI+Tapu0wrJaikRFRzPaV4HMDmtbimOeB
	60X/U4sqLAnaI1UV/aEVA==
Date: Thu, 25 Oct 2007 19:14:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 3/3] cpusets: add memory_spread_user option
In-Reply-To: <alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.0.9999.0710251913350.30400@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251912300.30400@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a new 'memory_spread_user' option to cpusets.

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
 Documentation/cpusets.txt |   29 +++++++++++++-------
 include/linux/cpuset.h    |    6 ++++
 kernel/cpuset.c           |   62 +++++++++++++++++++++++++++++++++++++++++++++
 mm/mempolicy.c            |    5 +++-
 4 files changed, 91 insertions(+), 11 deletions(-)

diff --git a/Documentation/cpusets.txt b/Documentation/cpusets.txt
--- a/Documentation/cpusets.txt
+++ b/Documentation/cpusets.txt
@@ -292,10 +292,10 @@ times 1000.
 
 1.6 What is memory spread ?
 ---------------------------
-There are two boolean flag files per cpuset that control where the
-kernel allocates pages for the file system buffers and related in
-kernel data structures.  They are called 'memory_spread_page' and
-'memory_spread_slab'.
+There are three boolean flag files per cpuset that control where the
+kernel allocates pages for the file system buffers, kernel data
+structures, and user memory.  They are called 'memory_spread_page',
+'memory_spread_slab', and 'memory_spread_user'.
 
 If the per-cpuset boolean flag file 'memory_spread_page' is set, then
 the kernel will spread the file system buffers (page cache) evenly
@@ -308,8 +308,13 @@ such as for inodes and dentries evenly over all the nodes that the
 faulting task is allowed to use, instead of preferring to put those
 pages on the node where the task is running.
 
-The setting of these flags does not affect anonymous data segment or
-stack segment pages of a task.
+If the per-cpuset boolean flag file 'memory_spread_user' is set, then
+all tasks with MPOL_INTERLEAVE memory policies that are attached to
+the cpuset will receive interleaved nodemasks equal to the cpuset's
+mems_allowed, regardless of what nodemask was passed to
+set_mempolicy().  This nodemask will reflect the cpuset's mems_allowed
+whenever a task is attached to the cpuset or the 'mems' file changes
+for a cpuset with this boolean flag set.
 
 By default, both kinds of memory spreading are off, and memory
 pages are allocated on the node local to where the task is running,
@@ -327,10 +332,10 @@ their containing tasks memory spread settings.  If memory spreading
 is turned off, then the currently specified NUMA mempolicy once again
 applies to memory page allocations.
 
-Both 'memory_spread_page' and 'memory_spread_slab' are boolean flag
-files.  By default they contain "0", meaning that the feature is off
-for that cpuset.  If a "1" is written to that file, then that turns
-the named feature on.
+'memory_spread_page', 'memory_spread_slab', and 'memory_spread_user'
+are boolean flag files.  By default they contain "0", meaning that
+the feature is off for that cpuset.  If a "1" is written to that
+file, then that turns the named feature on.
 
 The implementation is simple.
 
@@ -345,6 +350,10 @@ Similarly, setting 'memory_spread_cache' turns on the flag
 PF_SPREAD_SLAB, and appropriately marked slab caches will allocate
 pages from the node returned by cpuset_mem_spread_node().
 
+Setting 'memory_spread_user' rebinds an MPOL_INTERLEAVE mempolicy to
+the cpuset's mems_allowed whenever a task is attached to the cpuset
+or the 'mems' file changes.
+
 The cpuset_mem_spread_node() routine is also simple.  It uses the
 value of a per-task rotor cpuset_mem_spread_rotor to select the next
 node in the current tasks mems_allowed to prefer for the allocation.
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -77,6 +77,7 @@ static inline int cpuset_do_slab_mem_spread(void)
 extern void cpuset_track_online_nodes(void);
 
 extern int current_cpuset_is_being_rebound(void);
+extern int current_cpuset_is_spread_user(void);
 
 #else /* !CONFIG_CPUSETS */
 
@@ -157,6 +158,11 @@ static inline int current_cpuset_is_being_rebound(void)
 	return 0;
 }
 
+static inline int current_cpuset_is_spread_user(void)
+{
+	return 0;
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
+	CS_SPREAD_USER,
 } cpuset_flagbits_t;
 
 /* convenient tests for these bits */
@@ -154,6 +155,11 @@ static inline int is_spread_slab(const struct cpuset *cs)
 	return test_bit(CS_SPREAD_SLAB, &cs->flags);
 }
 
+static inline int is_spread_user(const struct cpuset *cs)
+{
+	return test_bit(CS_SPREAD_USER, &cs->flags);
+}
+
 /*
  * Increment this integer everytime any cpuset changes its
  * mems_allowed value.  Users of cpusets can track this generation
@@ -1089,6 +1095,44 @@ static int update_memory_pressure_enabled(struct cpuset *cs, char *buf)
 	return 0;
 }
 
+/* Rebinds the memory policies of all tasks attached to cs.
+ *
+ * Call with cgroup_mutex held.
+ */
+static int update_spread_user(struct cpuset *cs, char *buf)
+{
+	struct mm_struct **mmarray;
+	int ntasks;
+	int i;
+
+	if (!simple_strtoul(buf, NULL, 10)) {
+		clear_bit(CS_SPREAD_USER, &cs->flags);
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
+	set_bit(CS_SPREAD_USER, &cs->flags);
+	return 0;
+}
+
+int current_cpuset_is_spread_user(void)
+{
+	int ret;
+	mutex_lock(&callback_mutex);
+	ret = is_spread_user(task_cs(current));
+	mutex_unlock(&callback_mutex);
+	return ret;
+}
+
 /*
  * update_flag - read a 0 or a 1 in a file and update associated flag
  * bit:	the bit to update (CS_CPU_EXCLUSIVE, CS_MEM_EXCLUSIVE,
@@ -1283,6 +1327,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_SPREAD_USER,
 } cpuset_filetype_t;
 
 static ssize_t cpuset_common_file_write(struct cgroup *cont,
@@ -1350,6 +1395,9 @@ static ssize_t cpuset_common_file_write(struct cgroup *cont,
 		retval = update_flag(CS_SPREAD_SLAB, cs, buffer);
 		cs->mems_generation = cpuset_mems_generation++;
 		break;
+	case FILE_SPREAD_USER:
+		retval = update_spread_user(cs, buffer);
+		break;
 	default:
 		retval = -EINVAL;
 		goto out2;
@@ -1446,6 +1494,9 @@ static ssize_t cpuset_common_file_read(struct cgroup *cont,
 	case FILE_SPREAD_SLAB:
 		*s++ = is_spread_slab(cs) ? '1' : '0';
 		break;
+	case FILE_SPREAD_USER:
+		*s++ = is_spread_user(cs) ? '1' : '0';
+		break;
 	default:
 		retval = -EINVAL;
 		goto out;
@@ -1536,6 +1587,13 @@ static struct cftype cft_spread_slab = {
 	.private = FILE_SPREAD_SLAB,
 };
 
+static struct cftype cft_spread_user = {
+	.name = "memory_spread_user",
+	.read = cpuset_common_file_read,
+	.write = cpuset_common_file_write,
+	.private = FILE_SPREAD_USER,
+};
+
 static int cpuset_populate(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	int err;
@@ -1558,6 +1616,8 @@ static int cpuset_populate(struct cgroup_subsys *ss, struct cgroup *cont)
 		return err;
 	if ((err = cgroup_add_file(cont, ss, &cft_spread_slab)) < 0)
 		return err;
+	if ((err = cgroup_add_file(cont, ss, &cft_spread_user)) < 0)
+		return err;
 	/* memory_pressure_enabled is in root cpuset only */
 	if (err == 0 && !cont->parent)
 		err = cgroup_add_file(cont, ss,
@@ -1633,6 +1693,8 @@ static struct cgroup_subsys_state *cpuset_create(
 		set_bit(CS_SPREAD_PAGE, &cs->flags);
 	if (is_spread_slab(parent))
 		set_bit(CS_SPREAD_SLAB, &cs->flags);
+	if (is_spread_user(parent))
+		set_bit(CS_SPREAD_USER, &cs->flags);
 	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	cs->cpus_allowed = CPU_MASK_NONE;
 	cs->mems_allowed = NODE_MASK_NONE;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1739,7 +1739,10 @@ static void mpol_rebind_policy(struct mempolicy *pol,
 	case MPOL_DEFAULT:
 		break;
 	case MPOL_INTERLEAVE:
-		nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
+		if (current_cpuset_is_spread_user())
+			tmp = cpuset_mems_allowed(current);
+		else
+			nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
 		pol->v.nodes = tmp;
 		current->il_next = node_remap(current->il_next,
 						*mpolmask, *newmask);
