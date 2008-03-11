Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbYCKF6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbYCKF6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 01:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYCKF5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 01:57:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64060 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbYCKF5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 01:57:31 -0400
X-IronPort-AV: E=McAfee;i="5100,188,5248"; a="1211828"
From: maxk@qualcomm.com
To: mingo@elte.hu
Cc: pj@sgi.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH 2/2] cpusets: Improved irq affinity handling
Date: Mon, 10 Mar 2008 22:57:26 -0700
Message-Id: <1205215046-27085-3-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1205215046-27085-2-git-send-email-maxk@qualcomm.com>
References: <1205215046-27085-1-git-send-email-maxk@qualcomm.com>
 <1205215046-27085-2-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Krasnyansky <maxk@qualcomm.com>

This builds on top of Peter's patch. Irqs are handled just like
tasks now. ie Moved when set goes empty, etc.
irq_set_affinity() now ensures that specified mask is a subset
of allowed cpus just like sched_setscheduler() does for tasks.
Other minor bugfixes.
Booted and tested on a couple of differnet x86-64 boxes:
Core2Duo lapttop and dual Opteron numa machine.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 include/linux/cpuset.h |    8 +
 include/linux/irq.h    |    2 +
 kernel/cpuset.c        |  367 ++++++++++++++++++++++++++++++------------------
 kernel/irq/chip.c      |    5 +
 kernel/irq/manage.c    |   27 +++-
 5 files changed, 265 insertions(+), 144 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 0a26be3..e3d4daf 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -13,6 +13,8 @@
 #include <linux/nodemask.h>
 #include <linux/cgroup.h>
 
+struct cpuset;
+
 #ifdef CONFIG_CPUSETS
 
 extern int number_of_cpusets;	/* How many cpusets are defined in system? */
@@ -20,6 +22,7 @@ extern int number_of_cpusets;	/* How many cpusets are defined in system? */
 extern int cpuset_init_early(void);
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
+extern int cpuset_cpumask_allowed(cpumask_t *mask, struct cpuset *cs);
 extern cpumask_t cpuset_cpus_allowed(struct task_struct *p);
 extern cpumask_t cpuset_cpus_allowed_locked(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
@@ -93,6 +96,11 @@ static inline cpumask_t cpuset_cpus_allowed_locked(struct task_struct *p)
 	return cpu_possible_map;
 }
 
+static inline int cpuset_cpumask_allowed(cpumask_t *mask, struct cpuset *cs)
+{
+	return 1;
+}
+
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
 {
 	return node_possible_map;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 450c0de..28799b5 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -17,6 +17,7 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/cpumask.h>
+#include <linux/cpuset.h>
 #include <linux/irqreturn.h>
 #include <linux/errno.h>
 
@@ -238,6 +239,7 @@ static inline void set_pending_irq(unsigned int irq, cpumask_t mask)
 #endif /* CONFIG_GENERIC_PENDING_IRQ */
 
 extern int irq_set_affinity(unsigned int irq, cpumask_t cpumask);
+extern int __irq_set_affinity(unsigned int irq, cpumask_t cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
 
 #else /* CONFIG_SMP */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index e82a258..b59d635 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -260,6 +260,214 @@ static struct file_system_type cpuset_fs_type = {
 	.get_sb = cpuset_get_sb,
 };
 
+
+#ifdef CONFIG_GENERIC_HARDIRQS
+struct cpuset_irq_cpumask {
+	struct irq_iterator v;
+	struct cpuset *cs;
+	cpumask_t mask;
+};
+
+static int update_irq_cpumask(struct irq_iterator *v, int irq, struct irq_desc *desc)
+{
+	struct cpuset_irq_cpumask *s =
+		container_of(v, struct cpuset_irq_cpumask, v);
+
+	if (desc->cs != s->cs)
+		return 0;
+
+	__irq_set_affinity(irq, s->mask);
+	return 0;
+}
+
+static void update_irqs_cpumask(struct cpuset *cs)
+{
+	struct cpuset_irq_cpumask s = {
+		.v = { .function = update_irq_cpumask },
+		.cs = cs,
+	};
+
+	cpus_and(s.mask, cpu_online_map, cs->cpus_allowed);
+
+	irq_iterator(&s.v);
+}
+
+struct cpuset_irq_update {
+	struct irq_iterator v;
+	struct cpuset *cs;
+	int irq;
+	int force;
+};
+
+static int cpuset_update_irq(struct irq_iterator *v, int irq, struct irq_desc *desc)
+{
+	struct cpuset_irq_update *s =
+		container_of(v, struct cpuset_irq_update, v);
+	cpumask_t online_set;
+	int ret;
+
+	if (irq != s->irq)
+		return 0;
+
+	cpus_and(online_set, cpu_online_map, s->cs->cpus_allowed);
+
+	ret = __irq_set_affinity(irq, online_set);
+	if (!ret)
+		desc->cs = s->cs;
+	else if (s->force) {
+		/* Move to the new cpuset failed, we're forced
+ 		 * to move it all the way up. Should we maybe 
+ 		 * printk some warning here ? */
+		__irq_set_affinity(irq, cpu_online_map);
+		desc->cs = NULL;
+	}
+
+	return ret;
+}
+
+static int update_irqs(struct cpuset *cs, char *buf)
+{
+	struct cpuset_irq_update s = {
+		.v = { .function = cpuset_update_irq },
+		.cs = cs,
+		.force = 0
+	};
+
+	if (sscanf(buf, "%d", &s.irq) != 1)
+		return -EIO;
+
+	return irq_iterator(&s.v);
+}
+
+struct cpuset_irq_print {
+	struct irq_iterator v;
+	struct cpuset *cs;
+	char *buf;
+	int len;
+	int buflen;
+};
+
+static int cpuset_sprintf_irq(struct irq_iterator *v, int irq, struct irq_desc *desc)
+{
+	struct cpuset_irq_print *s =
+		container_of(v, struct cpuset_irq_print, v);
+
+	if (desc->cs != s->cs)
+		return 0;
+
+	if (s->len > 0)
+		s->len += scnprintf(s->buf + s->len, s->buflen - s->len, " ");
+	s->len += scnprintf(s->buf + s->len, s->buflen - s->len, "%d", irq);
+
+	return 0;
+}
+
+static int cpuset_sprintf_irqlist(char *page, struct cpuset *cs)
+{
+	int ret;
+
+	struct cpuset_irq_print s = {
+		.v = { .function = cpuset_sprintf_irq },
+		.cs = cs,
+		.buf = page,
+		.len = 0,
+		.buflen = PAGE_SIZE,
+	};
+
+	mutex_lock(&callback_mutex);
+	ret = irq_iterator(&s.v);
+	mutex_unlock(&callback_mutex);
+
+	if (!ret)
+		ret = s.len;
+
+	return ret;
+}
+
+struct cpuset_irq_count {
+	struct irq_iterator v;
+	const struct cpuset *cs;
+	int count;
+};
+
+static int cpuset_count_irq(struct irq_iterator *v, int irq, struct irq_desc *desc)
+{
+	struct cpuset_irq_count *s =
+		container_of(v, struct cpuset_irq_count, v);
+
+	if (desc->cs != s->cs)
+		return 0;
+
+	s->count++;
+	return 0;
+}
+
+static int cpuset_count_irqs(const struct cpuset *cs)
+{
+	struct cpuset_irq_count s = {
+		.v = { .function = cpuset_count_irq },
+		.cs = cs,
+		.count = 0
+	};
+
+	irq_iterator(&s.v);
+
+	return s.count;
+}
+
+/*
+ * This is called if last CPU is removed from a cpuset or cpuset is destroyed. 
+ * We move the irqs in the cpuset to its next-highest non-empty parent.
+ *
+ * Called with cgroup_mutex held
+ * callback_mutex must not be held, as cpuset_attach() will take it.
+ */
+static void move_irqs_to_parent(struct cpuset *cs)
+{
+	struct cpuset_irq_update s = {
+		.v = { .function = cpuset_update_irq },
+		.force = 1
+	};
+
+	struct cpuset *parent;
+
+	/*
+	 * Find its next-highest non-empty parent, (top cpuset
+	 * has online cpus, it can't be empty).
+	 */
+	parent = cs->parent;
+	while (cpus_empty(parent->cpus_allowed))
+		parent = parent->parent;
+
+	s.cs = parent;
+	irq_iterator(&s.v);
+}
+
+#else /* CONFIG_GENERIC_HARDIRQS */
+static void update_irqs_cpumask(struct cpuset *cs)
+{
+}
+
+static int update_irqs(struct cpuset *cs, char *buf)
+{
+	return 0;
+}
+
+static int cpuset_sprintf_irqlist(char *page, struct cpuset *cs)
+{
+	return 0;
+}
+
+static int cpuset_count_irqs(const struct cpuset *cs)
+{
+	return 0;
+}
+
+static void move_irqs_to_parent(struct cpuset *cs)
+{
+}
+#endif
+
 /*
  * Return in *pmask the portion of a cpusets's cpus_allowed that
  * are online.  If none are online, walk up the cpuset hierarchy
@@ -468,6 +676,10 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 		}
 	}
 
+	/* Cpusets with irqs can't have empty cpus_allowed */
+	if (cpus_empty(trial->cpus_allowed) && cpuset_count_irqs(cur))
+		return -ENOSPC;
+
 	return 0;
 }
 
@@ -735,44 +947,6 @@ void cpuset_change_cpumask(struct task_struct *tsk, struct cgroup_scanner *scan)
 	set_cpus_allowed(tsk, (cgroup_cs(scan->cg))->cpus_allowed);
 }
 
-#ifdef CONFIG_GENERIC_HARDIRQS
-struct cpuset_irq_cpumask {
-	struct irq_iterator v;
-	struct cpuset *cs;
-	cpumask_t mask;
-};
-
-static int
-update_irq_cpumask(struct irq_iterator *v, int irq, struct irq_desc *desc)
-{
-	struct cpuset_irq_cpumask *s =
-		container_of(v, struct cpuset_irq_cpumask, v);
-
-	if (desc->cs != s->cs)
-		return 0;
-
-	irq_set_affinity(irq, s->mask);
-
-	return 0;
-}
-
-static void update_irqs_cpumask(struct cpuset *cs)
-{
-	struct cpuset_irq_cpumask s = {
-		.v = { .function = update_irq_cpumask },
-		.cs = cs,
-	};
-
-	cpus_and(s.mask, cpu_online_map, cs->cpus_allowed);
-
-	irq_iterator(&s.v);
-}
-#else
-static void update_irqs_cpumask(struct cpuset *cs)
-{
-}
-#endif
-
 /**
  * update_cpumask - update the cpus_allowed mask of a cpuset and all tasks in it
  * @cs: the cpuset to consider
@@ -1099,52 +1273,6 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs, char *buf)
 	return 0;
 }
 
-#ifdef CONFIG_GENERIC_HARDIRQS
-struct cpuset_irq_update {
-	struct irq_iterator v;
-	struct cpuset *cs;
-	int irq;
-};
-
-static int
-cpuset_update_irq(struct irq_iterator *v, int irq, struct irq_desc *desc)
-{
-	struct cpuset_irq_update *s =
-		container_of(v, struct cpuset_irq_update, v);
-	cpumask_t online_set;
-	int ret;
-
-	if (irq != s->irq)
-		return 0;
-
-	cpus_and(online_set, cpu_online_map, s->cs->cpus_allowed);
-
-	ret = irq_set_affinity(irq, online_set);
-	if (!ret)
-		desc->cs = s->cs;
-
-	return ret;
-}
-
-static int update_irqs(struct cpuset *cs, char *buf)
-{
-	struct cpuset_irq_update s = {
-		.v = { .function = cpuset_update_irq },
-		.cs = cs,
-	};
-
-	if (sscanf(buf, "%d", &s.irq) != 1)
-		return -EIO;
-
-	return irq_iterator(&s.v);
-}
-#else
-static int update_irqs(struct cpuset *cs, char *buf)
-{
-	return 0;
-}
-#endif
-
 /*
  * Frequency meter - How fast is some event occurring?
  *
@@ -1414,59 +1542,6 @@ static int cpuset_sprintf_memlist(char *page, struct cpuset *cs)
 	return nodelist_scnprintf(page, PAGE_SIZE, mask);
 }
 
-#ifdef CONFIG_GENERIC_HARDIRQS
-struct cpuset_irq_print {
-	struct irq_iterator v;
-	struct cpuset *cs;
-	char *buf;
-	int len;
-	int buflen;
-};
-
-static int
-cpuset_sprintf_irq(struct irq_iterator *v, int irq, struct irq_desc *desc)
-{
-	struct cpuset_irq_print *s =
-		container_of(v, struct cpuset_irq_print, v);
-
-	if (desc->cs != s->cs)
-		return 0;
-
-	if (s->len > 0)
-		s->len += scnprintf(s->buf + s->len, s->buflen - s->len, " ");
-	s->len += scnprintf(s->buf + s->len, s->buflen - s->len, "%d", irq);
-
-	return 0;
-}
-
-static int cpuset_sprintf_irqlist(char *page, struct cpuset *cs)
-{
-	int ret;
-
-	struct cpuset_irq_print s = {
-		.v = { .function = cpuset_sprintf_irq },
-		.cs = cs,
-		.buf = page,
-		.len = 0,
-		.buflen = PAGE_SIZE,
-	};
-
-	mutex_lock(&callback_mutex);
-	ret = irq_iterator(&s.v);
-	mutex_unlock(&callback_mutex);
-
-	if (!ret)
-		ret = s.len;
-
-	return ret;
-}
-#else
-static int cpuset_sprintf_irqlist(char *page, struct cpuset *cs)
-{
-	return 0;
-}
-#endif
-
 static ssize_t cpuset_common_file_read(struct cgroup *cont,
 				       struct cftype *cft,
 				       struct file *file,
@@ -1743,6 +1818,11 @@ static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
 
 	cpuset_update_task_memory_state();
 
+	/* Move irqs (if any) to the parent set. Ideally we should disallow 
+ 	 * destruction of the cpusets that have irqs (that's how it works
+ 	 * for the tasks), but refcounting seems messy. */
+	move_irqs_to_parent(cs);
+
 	if (is_sched_load_balance(cs))
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, "0");
 
@@ -1927,6 +2007,10 @@ static void scan_for_empty_cpusets(const struct cpuset *root)
 		if (cpus_empty(cp->cpus_allowed) ||
 		     nodes_empty(cp->mems_allowed))
 			remove_tasks_in_empty_cpuset(cp);
+
+		/* Move irqs from the empty cpuset to a parent */
+		if (cpus_empty(cp->cpus_allowed))
+			move_irqs_to_parent(cp);
 	}
 }
 
@@ -2037,6 +2121,15 @@ cpumask_t cpuset_cpus_allowed_locked(struct task_struct *tsk)
 	return mask;
 }
 
+/**
+ * cpuset_cpumask_allowed - returns 1 if provided cpumask is a subset 
+ * of allowed cpus in the set.
+ **/
+int cpuset_cpumask_allowed(cpumask_t *mask, struct cpuset *cs)
+{
+	return cpus_subset(*mask, cs->cpus_allowed);
+}
+
 void cpuset_init_current_mems_allowed(void)
 {
 	current->mems_allowed = NODE_MASK_ALL;
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index fdb3fbe..2588d08 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -49,6 +49,11 @@ void dynamic_irq_init(unsigned int irq)
 #ifdef CONFIG_SMP
 	desc->affinity = CPU_MASK_ALL;
 #endif
+
+#ifdef CONFIG_CPUSETS
+	desc->cs = NULL;
+#endif
+
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 5154c25..5a91d1c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -70,13 +70,7 @@ int irq_can_set_affinity(unsigned int irq)
 	return 1;
 }
 
-/**
- *	irq_set_affinity - Set the irq affinity of a given irq
- *	@irq:		Interrupt to set affinity
- *	@cpumask:	cpumask
- *
- */
-int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
+int __irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 {
 	struct irq_desc *desc = irq_desc + irq;
 
@@ -94,6 +88,25 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 	return 0;
 }
 
+/**
+ *	irq_set_affinity - Set the irq affinity of a given irq
+ *	@irq:		Interrupt to set affinity
+ *	@cpumask:	cpumask
+ *
+ */
+int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
+{
+	struct irq_desc *desc = irq_desc + irq;
+
+#ifdef CONFIG_CPUSETS
+	/* FIXME: Not sure about locking here. maxk */
+	if (desc->cs && !cpuset_cpumask_allowed(&cpumask, desc->cs))
+		return -EINVAL;
+#endif
+
+	return __irq_set_affinity(irq, cpumask);
+}
+
 #endif
 
 int irq_iterator(struct irq_iterator *v)
-- 
1.5.4.1

