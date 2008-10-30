Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbYJ3T0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbYJ3T0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbYJ3T0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:26:06 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39941 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534AbYJ3T0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:26:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=icrrxzXYhJm8SN8JoewMW0lVkJnolEl7DLF/nO9UTaId0+G6qmAn/g5eJLqXUvW/1
	xotL1mXYvAMd3IqCgngSw==
Date: Thu, 30 Oct 2008 12:23:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch 6/7] cpusets: per cpuset dirty ratios
In-Reply-To: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0810300311430.18283@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux-foundation.org>

This implements dirty ratios per cpuset.  Two new files are added to the
cpuset directories:

dirty_background_ratio	Percentage at which background writeback starts

dirty_ratio		Percentage at which the application is throttled
			and we start synchrononous writeout

Both variables are set to -1 by default which means that the global
limits (/proc/sys/vm/dirty_background_ratio and /proc/sys/vm/dirty_ratio)
are used for a cpuset.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Menage <menage@google.com>
Cc: Derek Fults <dfults@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/cpuset.h |    7 ++++
 kernel/cpuset.c        |   91 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c    |   12 ++++---
 3 files changed, 105 insertions(+), 5 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -76,6 +76,8 @@ static inline int cpuset_do_slab_mem_spread(void)
 
 extern void cpuset_track_online_nodes(void);
 
+extern void cpuset_get_current_dirty_ratios(int *background, int *throttle);
+
 extern int current_cpuset_is_being_rebound(void);
 
 extern void rebuild_sched_domains(void);
@@ -183,6 +185,11 @@ static inline int cpuset_do_slab_mem_spread(void)
 
 static inline void cpuset_track_online_nodes(void) {}
 
+static inline void cpuset_get_current_dirty_ratios(int *background,
+						   int *throttle)
+{
+}
+
 static inline int current_cpuset_is_being_rebound(void)
 {
 	return 0;
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -53,6 +53,7 @@
 #include <linux/time.h>
 #include <linux/backing-dev.h>
 #include <linux/sort.h>
+#include <linux/writeback.h>
 
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
@@ -105,6 +106,9 @@ struct cpuset {
 
 	/* used for walking a cpuset heirarchy */
 	struct list_head stack_list;
+
+	int dirty_background_ratio;
+	int cpuset_dirty_ratio;
 };
 
 /* Retrieve the cpuset for a cgroup */
@@ -197,6 +201,8 @@ static struct cpuset top_cpuset = {
 	.flags = ((1 << CS_CPU_EXCLUSIVE) | (1 << CS_MEM_EXCLUSIVE)),
 	.cpus_allowed = CPU_MASK_ALL,
 	.mems_allowed = NODE_MASK_ALL,
+	.dirty_background_ratio = -1,
+	.cpuset_dirty_ratio = -1,
 };
 
 /*
@@ -1198,6 +1204,42 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	return 0;
 }
 
+static int update_int(int *cs_int, int val, int min, int max)
+{
+	if (val < min || val > max)
+		return -EINVAL;
+	mutex_lock(&callback_mutex);
+	*cs_int = val;
+	mutex_unlock(&callback_mutex);
+	return 0;
+}
+
+static u64 get_dirty_background_ratio(struct cpuset *cs)
+{
+	int ret;
+
+	mutex_lock(&callback_mutex);
+	ret = cs->dirty_background_ratio;
+	mutex_unlock(&callback_mutex);
+
+	if (ret == -1)
+		ret = dirty_background_ratio;
+	return (u64)ret;
+}
+
+static u64 get_dirty_ratio(struct cpuset *cs)
+{
+	int ret;
+
+	mutex_lock(&callback_mutex);
+	ret = cs->cpuset_dirty_ratio;
+	mutex_unlock(&callback_mutex);
+
+	if (ret == -1)
+		ret = vm_dirty_ratio;
+	return (u64)ret;
+}
+
 /*
  * Frequency meter - How fast is some event occurring?
  *
@@ -1362,6 +1404,8 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_DIRTY_BACKGROUND_RATIO,
+	FILE_DIRTY_RATIO,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
@@ -1424,6 +1468,12 @@ static int cpuset_write_s64(struct cgroup *cgrp, struct cftype *cft, s64 val)
 	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
 		retval = update_relax_domain_level(cs, val);
 		break;
+	case FILE_DIRTY_BACKGROUND_RATIO:
+		retval = update_int(&cs->dirty_background_ratio, val, -1, 100);
+		break;
+	case FILE_DIRTY_RATIO:
+		retval = update_int(&cs->cpuset_dirty_ratio, val, -1, 100);
+		break;
 	default:
 		retval = -EINVAL;
 		break;
@@ -1551,6 +1601,10 @@ static u64 cpuset_read_u64(struct cgroup *cont, struct cftype *cft)
 		return is_spread_page(cs);
 	case FILE_SPREAD_SLAB:
 		return is_spread_slab(cs);
+	case FILE_DIRTY_BACKGROUND_RATIO:
+		return get_dirty_background_ratio(cs);
+	case FILE_DIRTY_RATIO:
+		return get_dirty_ratio(cs);
 	default:
 		BUG();
 	}
@@ -1658,6 +1712,20 @@ static struct cftype files[] = {
 		.write_u64 = cpuset_write_u64,
 		.private = FILE_SPREAD_SLAB,
 	},
+
+	{
+		.name = "dirty_background_ratio",
+		.read_u64 = cpuset_read_u64,
+		.write_s64 = cpuset_write_s64,
+		.private = FILE_DIRTY_BACKGROUND_RATIO,
+	},
+
+	{
+		.name = "dirty_ratio",
+		.read_u64 = cpuset_read_u64,
+		.write_s64 = cpuset_write_s64,
+		.private = FILE_DIRTY_RATIO,
+	},
 };
 
 static struct cftype cft_memory_pressure_enabled = {
@@ -1753,6 +1821,8 @@ static struct cgroup_subsys_state *cpuset_create(
 	cs->mems_generation = cpuset_mems_generation++;
 	fmeter_init(&cs->fmeter);
 	cs->relax_domain_level = -1;
+	cs->dirty_background_ratio = parent->dirty_background_ratio;
+	cs->cpuset_dirty_ratio = parent->cpuset_dirty_ratio;
 
 	cs->parent = parent;
 	number_of_cpusets++;
@@ -2021,6 +2091,27 @@ void cpuset_track_online_nodes(void)
 }
 #endif
 
+/*
+ * Determine the dirty ratios for the currently active cpuset
+ */
+void cpuset_get_current_dirty_ratios(int *background, int *throttle)
+{
+	if (task_cs(current) == &top_cpuset) {
+		*background = top_cpuset.dirty_background_ratio;
+		*throttle = top_cpuset.cpuset_dirty_ratio;
+	} else {
+		rcu_read_lock();
+		*background = task_cs(current)->dirty_background_ratio;
+		*throttle = task_cs(current)->cpuset_dirty_ratio;
+		rcu_read_unlock();
+	}
+
+	if (*background == -1)
+		*background = dirty_background_ratio;
+	if (*throttle == -1)
+		*throttle = vm_dirty_ratio;
+}
+
 /**
  * cpuset_init_smp - initialize cpus_allowed
  *
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -424,17 +424,19 @@ get_dirty_limits(struct dirty_limits *dl, struct backing_dev_info *bdi,
 
 	memset(dl, 0, sizeof(struct dirty_limits));
 	is_subset = nodes && !nodes_subset(node_online_map, *nodes);
-	if (unlikely(is_subset))
+	if (unlikely(is_subset)) {
 		populate_nodemask_dirty_limits(dl, &dirtyable_memory,
 					       &nr_mapped, nodes);
-	else
+		cpuset_get_current_dirty_ratios(&background_ratio,
+						&dirty_ratio);
+	} else {
 		populate_global_dirty_limits(dl, &dirtyable_memory, &nr_mapped);
+		dirty_ratio = vm_dirty_ratio;
+		background_ratio = dirty_background_ratio;
+	}
 
-	dirty_ratio = vm_dirty_ratio;
 	if (dirty_ratio < 5)
 		dirty_ratio = 5;
-
-	background_ratio = dirty_background_ratio;
 	if (background_ratio >= dirty_ratio)
 		background_ratio = dirty_ratio / 2;
 
