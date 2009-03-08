Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbZCHQ2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbZCHQ2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbZCHQ16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:27:58 -0400
Received: from smtp-out.google.com ([216.239.33.17]:52640 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZCHQ15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:27:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=kX1JJp1s14BRgBMxWrVGYsfRnTOFr7Tiqd+gSfuD8551p6CPbuz7IyaVpi8fMFfNM
	LtXiaUUgzU/WK1hh+XbUw==
Date: Sun, 8 Mar 2009 09:27:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm] cpusets: add memory_slab_hardwall flag
Message-ID: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a per-cpuset `memory_slab_hardwall' flag.

The slab allocator interface for determining whether an object is allowed
is

	int current_cpuset_object_allowed(int node, gfp_t flags)

This returns non-zero when the object is allowed, either because
current's cpuset does not have memory_slab_hardwall enabled or because
it allows allocation on the node.  Otherwise, it returns zero.

This interface is lockless because a task's cpuset can always be safely
dereferenced atomically.

For slab, if the physical node id of the cpu cache is not from an
allowable node, the allocation will fail.  If an allocation is targeted
for a node that is not allowed, we allocate from an appropriate one
instead of failing.

For slob, if the page from the slob list is not from an allowable node,
we continue to scan for an appropriate slab.  If none can be used, a new
slab is allocated.

For slub, if the cpu slab is not from an allowable node, the partial list
is scanned for a replacement.  If none can be used, a new slab is
allocated.

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/cgroups/cpusets.txt |   54 ++++++++++++++++++++++++-------------
 include/linux/cpuset.h            |    6 ++++
 kernel/cpuset.c                   |   34 +++++++++++++++++++++++
 mm/slab.c                         |    4 +++
 mm/slob.c                         |    6 +++-
 mm/slub.c                         |   12 +++++---
 6 files changed, 91 insertions(+), 25 deletions(-)

diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
--- a/Documentation/cgroups/cpusets.txt
+++ b/Documentation/cgroups/cpusets.txt
@@ -14,20 +14,21 @@ CONTENTS:
 =========
 
 1. Cpusets
-  1.1 What are cpusets ?
-  1.2 Why are cpusets needed ?
-  1.3 How are cpusets implemented ?
-  1.4 What are exclusive cpusets ?
-  1.5 What is memory_pressure ?
-  1.6 What is memory spread ?
-  1.7 What is sched_load_balance ?
-  1.8 What is sched_relax_domain_level ?
-  1.9 How do I use cpusets ?
+  1.1  What are cpusets ?
+  1.2  Why are cpusets needed ?
+  1.3  How are cpusets implemented ?
+  1.4  What are exclusive cpusets ?
+  1.5  What is memory_pressure ?
+  1.6  What is memory spread ?
+  1.7  What is sched_load_balance ?
+  1.8  What is sched_relax_domain_level ?
+  1.9  What is memory_slab_hardwall ?
+  1.10 How do I use cpusets ?
 2. Usage Examples and Syntax
-  2.1 Basic Usage
-  2.2 Adding/removing cpus
-  2.3 Setting flags
-  2.4 Attaching processes
+  2.1  Basic Usage
+  2.2  Adding/removing cpus
+  2.3  Setting flags
+  2.4  Attaching processes
 3. Questions
 4. Contact
 
@@ -581,8 +582,22 @@ If your situation is:
 then increasing 'sched_relax_domain_level' would benefit you.
 
 
-1.9 How do I use cpusets ?
---------------------------
+1.9 What is memory_slab_hardwall ?
+----------------------------------
+
+A cpuset may require that slab object allocations all originate from
+its set of mems, either for memory isolation or NUMA optimizations.  Slab
+allocators normally optimize allocations in the fastpath by returning
+objects from a cpu slab.  These objects do not necessarily originate from
+slabs allocated on a cpuset's mems.
+
+When memory_slab_hardwall is set, all objects are allocated from slabs on
+the cpuset's set of mems.  This may incur a performance penalty if the
+cpu slab must be swapped for a different slab.
+
+
+1.10 How do I use cpusets ?
+---------------------------
 
 In order to minimize the impact of cpusets on critical kernel
 code, such as the scheduler, and due to the fact that the kernel
@@ -725,10 +740,11 @@ Now you want to do something with this cpuset.
 
 In this directory you can find several files:
 # ls
-cpu_exclusive  memory_migrate      mems                      tasks
-cpus           memory_pressure     notify_on_release
-mem_exclusive  memory_spread_page  sched_load_balance
-mem_hardwall   memory_spread_slab  sched_relax_domain_level
+cpu_exclusive		memory_pressure			notify_on_release
+cpus			memory_slab_hardwall		sched_load_balance
+mem_exclusive		memory_spread_page		sched_relax_domain_level
+mem_hardwall		memory_spread_slab		tasks
+memory_migrate		mems
 
 Reading them will give you information about the state of this cpuset:
 the CPUs and Memory Nodes it can use, the processes that are using
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -87,6 +87,7 @@ static inline int cpuset_do_slab_mem_spread(void)
 }
 
 extern int current_cpuset_is_being_rebound(void);
+extern int current_cpuset_object_allowed(int node, gfp_t flags);
 
 extern void rebuild_sched_domains(void);
 
@@ -179,6 +180,11 @@ static inline int current_cpuset_is_being_rebound(void)
 	return 0;
 }
 
+static inline int current_cpuset_object_allowed(int node, gfp_t flags)
+{
+	return 1;
+}
+
 static inline void rebuild_sched_domains(void)
 {
 	partition_sched_domains(1, NULL, NULL);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -142,6 +142,7 @@ typedef enum {
 	CS_SCHED_LOAD_BALANCE,
 	CS_SPREAD_PAGE,
 	CS_SPREAD_SLAB,
+	CS_SLAB_HARDWALL,
 } cpuset_flagbits_t;
 
 /* convenient tests for these bits */
@@ -180,6 +181,11 @@ static inline int is_spread_slab(const struct cpuset *cs)
 	return test_bit(CS_SPREAD_SLAB, &cs->flags);
 }
 
+static inline int is_slab_hardwall(const struct cpuset *cs)
+{
+	return test_bit(CS_SLAB_HARDWALL, &cs->flags);
+}
+
 /*
  * Increment this integer everytime any cpuset changes its
  * mems_allowed value.  Users of cpusets can track this generation
@@ -1190,6 +1196,19 @@ int current_cpuset_is_being_rebound(void)
 	return task_cs(current) == cpuset_being_rebound;
 }
 
+/**
+ * current_cpuset_object_allowed - can a slab object be allocated on a node?
+ * @node: the node for object allocation
+ * @flags: allocation flags
+ *
+ * Return non-zero if object is allowed, zero otherwise.
+ */
+int current_cpuset_object_allowed(int node, gfp_t flags)
+{
+	return !is_slab_hardwall(task_cs(current)) ||
+	       cpuset_node_allowed_hardwall(node, flags);
+}
+
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
 	if (val < -1 || val >= SD_LV_MAX)
@@ -1417,6 +1436,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_SLAB_HARDWALL,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
@@ -1458,6 +1478,9 @@ static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
 		retval = update_flag(CS_SPREAD_SLAB, cs, val);
 		cs->mems_generation = cpuset_mems_generation++;
 		break;
+	case FILE_SLAB_HARDWALL:
+		retval = update_flag(CS_SLAB_HARDWALL, cs, val);
+		break;
 	default:
 		retval = -EINVAL;
 		break;
@@ -1614,6 +1637,8 @@ static u64 cpuset_read_u64(struct cgroup *cont, struct cftype *cft)
 		return is_spread_page(cs);
 	case FILE_SPREAD_SLAB:
 		return is_spread_slab(cs);
+	case FILE_SLAB_HARDWALL:
+		return is_slab_hardwall(cs);
 	default:
 		BUG();
 	}
@@ -1721,6 +1746,13 @@ static struct cftype files[] = {
 		.write_u64 = cpuset_write_u64,
 		.private = FILE_SPREAD_SLAB,
 	},
+
+	{
+		.name = "memory_slab_hardwall",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SLAB_HARDWALL,
+	},
 };
 
 static struct cftype cft_memory_pressure_enabled = {
@@ -1814,6 +1846,8 @@ static struct cgroup_subsys_state *cpuset_create(
 		set_bit(CS_SPREAD_PAGE, &cs->flags);
 	if (is_spread_slab(parent))
 		set_bit(CS_SPREAD_SLAB, &cs->flags);
+	if (is_slab_hardwall(parent))
+		set_bit(CS_SLAB_HARDWALL, &cs->flags);
 	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	cpumask_clear(cs->cpus_allowed);
 	nodes_clear(cs->mems_allowed);
diff --git a/mm/slab.c b/mm/slab.c
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3124,6 +3124,8 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 	check_irq_off();
 
 	ac = cpu_cache_get(cachep);
+	if (!current_cpuset_object_allowed(numa_node_id(), flags))
+		return NULL;
 	if (likely(ac->avail)) {
 		STATS_INC_ALLOCHIT(cachep);
 		ac->touched = 1;
@@ -3249,6 +3251,8 @@ static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
 	void *obj;
 	int x;
 
+	if (!current_cpuset_object_allowed(nodeid, flags))
+		nodeid = cpuset_mem_spread_node();
 	l3 = cachep->nodelists[nodeid];
 	BUG_ON(!l3);
 
diff --git a/mm/slob.c b/mm/slob.c
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -319,14 +319,18 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node)
 	spin_lock_irqsave(&slob_lock, flags);
 	/* Iterate through each partially free page, try to find room */
 	list_for_each_entry(sp, slob_list, list) {
+		int slab_node = page_to_nid(&sp->page);
+
 #ifdef CONFIG_NUMA
 		/*
 		 * If there's a node specification, search for a partial
 		 * page with a matching node id in the freelist.
 		 */
-		if (node != -1 && page_to_nid(&sp->page) != node)
+		if (node != -1 && slab_node != node)
 			continue;
 #endif
+		if (!current_cpuset_object_allowed(slab_node, gfp))
+			continue;
 		/* Enough room on this page? */
 		if (sp->units < SLOB_UNITS(size))
 			continue;
diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1353,6 +1353,8 @@ static struct page *get_partial(struct kmem_cache *s, gfp_t flags, int node)
 	struct page *page;
 	int searchnode = (node == -1) ? numa_node_id() : node;
 
+	if (!current_cpuset_object_allowed(node, flags))
+		searchnode = cpuset_mem_spread_node();
 	page = get_partial_node(get_node(s, searchnode));
 	if (page || (flags & __GFP_THISNODE))
 		return page;
@@ -1475,15 +1477,15 @@ static void flush_all(struct kmem_cache *s)
 
 /*
  * Check if the objects in a per cpu structure fit numa
- * locality expectations.
+ * locality expectations and is allowed in current's cpuset.
  */
-static inline int node_match(struct kmem_cache_cpu *c, int node)
+static inline int check_node(struct kmem_cache_cpu *c, int node, gfp_t flags)
 {
 #ifdef CONFIG_NUMA
 	if (node != -1 && c->node != node)
 		return 0;
 #endif
-	return 1;
+	return current_cpuset_object_allowed(node, flags);
 }
 
 /*
@@ -1517,7 +1519,7 @@ static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 		goto new_slab;
 
 	slab_lock(c->page);
-	if (unlikely(!node_match(c, node)))
+	if (unlikely(!check_node(c, node, gfpflags)))
 		goto another_slab;
 
 	stat(c, ALLOC_REFILL);
@@ -1604,7 +1606,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
 	objsize = c->objsize;
-	if (unlikely(!c->freelist || !node_match(c, node)))
+	if (unlikely(!c->freelist || !check_node(c, node, gfpflags)))
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
