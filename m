Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbZCJCXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbZCJCXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 22:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZCJCW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 22:22:59 -0400
Received: from smtp-out.google.com ([216.239.45.13]:25655 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZCJCW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 22:22:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=qtDDptm9OzeIsZ+PWZzd+y6rXUtcTBP+CEAp6rhtQI8l93wO73RxEg7XBy8TfM7Su
	jvI+39DRG54VDYEQwQgAw==
Date: Mon, 9 Mar 2009 19:22:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm v2] cpusets: add memory_slab_hardwall flag
Message-ID: <alpine.DEB.2.00.0903091920100.7539@chino.kir.corp.google.com>
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

There are two possibilities for requiring objects originate from the
allocating task's set of allowable nodes: memory isolation between
disjoint cpusets and NUMA optimizations for cpu affinity to memory the
object is being allocated from.

This interface is lockless and very quick in the slab allocator fastpath
when not enabled because a new task flag, PF_SLAB_HARDWALL, is added to
determine whether or not its cpuset has mandated objects be allocated on
the set of allowed nodes.  If the option is not set for a task's cpuset
(or only a single cpuset exists), this reduces to only checking for a
specific bit in current->flags.

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

Tasks that allocate objects from cpusets that do not have
memory_slab_hardwall set can still allocate from cpu slabs that were
allocated in a disjoint cpuset.

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/cgroups/cpusets.txt |   54 ++++++++++++++++++++++++-------------
 include/linux/cpuset.h            |   11 +++++++
 include/linux/sched.h             |    1 +
 kernel/cpuset.c                   |   26 +++++++++++++++++
 mm/slab.c                         |    4 +++
 mm/slob.c                         |    6 +++-
 mm/slub.c                         |   12 +++++---
 7 files changed, 89 insertions(+), 25 deletions(-)

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
@@ -86,6 +86,12 @@ static inline int cpuset_do_slab_mem_spread(void)
 	return current->flags & PF_SPREAD_SLAB;
 }
 
+static inline int current_cpuset_object_allowed(int node, gfp_t flags)
+{
+	return !(current->flags & PF_SPREAD_SLAB) ||
+	       cpuset_node_allowed_hardwall(node, flags);
+}
+
 extern int current_cpuset_is_being_rebound(void);
 
 extern void rebuild_sched_domains(void);
@@ -174,6 +180,11 @@ static inline int cpuset_do_slab_mem_spread(void)
 	return 0;
 }
 
+static inline int current_cpuset_object_allowed(int node, gfp_t flags)
+{
+	return 1;
+}
+
 static inline int current_cpuset_is_being_rebound(void)
 {
 	return 0;
diff --git a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1623,6 +1623,7 @@ extern cputime_t task_gtime(struct task_struct *p);
 #define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_THREAD_BOUND	0x04000000	/* Thread bound to specific cpu */
+#define PF_SLAB_HARDWALL 0x08000000	/* Allocate slab objects only in cpuset */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
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
@@ -400,6 +406,10 @@ void cpuset_update_task_memory_state(void)
 			tsk->flags |= PF_SPREAD_SLAB;
 		else
 			tsk->flags &= ~PF_SPREAD_SLAB;
+		if (is_slab_hardwall(cs))
+			tsk->flags |= PF_SLAB_HARDWALL;
+		else
+			tsk->flags &= ~PF_SLAB_HARDWALL;
 		task_unlock(tsk);
 		mutex_unlock(&callback_mutex);
 		mpol_rebind_task(tsk, &tsk->mems_allowed);
@@ -1417,6 +1427,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_SLAB_HARDWALL,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
@@ -1458,6 +1469,10 @@ static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
 		retval = update_flag(CS_SPREAD_SLAB, cs, val);
 		cs->mems_generation = cpuset_mems_generation++;
 		break;
+	case FILE_SLAB_HARDWALL:
+		retval = update_flag(CS_SLAB_HARDWALL, cs, val);
+		cs->mems_generation = cpuset_mems_generation++;
+		break;
 	default:
 		retval = -EINVAL;
 		break;
@@ -1614,6 +1629,8 @@ static u64 cpuset_read_u64(struct cgroup *cont, struct cftype *cft)
 		return is_spread_page(cs);
 	case FILE_SPREAD_SLAB:
 		return is_spread_slab(cs);
+	case FILE_SLAB_HARDWALL:
+		return is_slab_hardwall(cs);
 	default:
 		BUG();
 	}
@@ -1721,6 +1738,13 @@ static struct cftype files[] = {
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
@@ -1814,6 +1838,8 @@ static struct cgroup_subsys_state *cpuset_create(
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
 
