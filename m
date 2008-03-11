Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYCKF5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYCKF5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 01:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbYCKF5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 01:57:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9888 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYCKF5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 01:57:30 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5248"; a="1027101"
From: maxk@qualcomm.com
To: mingo@elte.hu
Cc: pj@sgi.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com
Subject: [PATCH 1/2] cpuset: cpuset irq affinities
Date: Mon, 10 Mar 2008 22:57:25 -0700
Message-Id: <1205215046-27085-2-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1205215046-27085-1-git-send-email-maxk@qualcomm.com>
References: <1205215046-27085-1-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Hi Paul,

How about something like this; along with the in-kernel version
of /cgroup/boot this could also provide the desired semantics.

Another benefit of this approach would be that it no longer requires
PF_THREAD_BIND, as we'd only stick unbounded kthreads into that cgroup.

(compile tested only)
---
 include/linux/irq.h |    9 +++
 kernel/cpuset.c     |  160 +++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/irq/manage.c |   19 ++++++
 3 files changed, 188 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 176e5e7..450c0de 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -174,11 +174,20 @@ struct irq_desc {
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*dir;
 #endif
+#ifdef CONFIG_CPUSETS
+	struct cpuset		*cs;
+#endif
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
 extern struct irq_desc irq_desc[NR_IRQS];
 
+struct irq_iterator {
+	int (*function)(struct irq_iterator *, int, struct irq_desc *);
+};
+
+extern int irq_iterator(struct irq_iterator *);
+
 /*
  * Migration helpers for obsolete names, they will go away:
  */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index a1b61f4..e82a258 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -50,6 +50,9 @@
 #include <linux/time.h>
 #include <linux/backing-dev.h>
 #include <linux/sort.h>
+#ifdef CONFIG_GENERIC_HARDIRQS
+#include <linux/irq.h>
+#endif
 
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
@@ -732,6 +735,44 @@ void cpuset_change_cpumask(struct task_struct *tsk, struct cgroup_scanner *scan)
 	set_cpus_allowed(tsk, (cgroup_cs(scan->cg))->cpus_allowed);
 }
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+struct cpuset_irq_cpumask {
+	struct irq_iterator v;
+	struct cpuset *cs;
+	cpumask_t mask;
+};
+
+static int
+update_irq_cpumask(struct irq_iterator *v, int irq, struct irq_desc *desc)
+{
+	struct cpuset_irq_cpumask *s =
+		container_of(v, struct cpuset_irq_cpumask, v);
+
+	if (desc->cs != s->cs)
+		return 0;
+
+	irq_set_affinity(irq, s->mask);
+
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
+#else
+static void update_irqs_cpumask(struct cpuset *cs)
+{
+}
+#endif
+
 /**
  * update_cpumask - update the cpus_allowed mask of a cpuset and all tasks in it
  * @cs: the cpuset to consider
@@ -795,6 +836,8 @@ static int update_cpumask(struct cpuset *cs, char *buf)
 	cgroup_scan_tasks(&scan);
 	heap_free(&heap);
 
+	update_irqs_cpumask(cs);
+
 	if (is_load_balanced)
 		rebuild_sched_domains();
 	return 0;
@@ -1056,6 +1099,52 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs, char *buf)
 	return 0;
 }
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+struct cpuset_irq_update {
+	struct irq_iterator v;
+	struct cpuset *cs;
+	int irq;
+};
+
+static int
+cpuset_update_irq(struct irq_iterator *v, int irq, struct irq_desc *desc)
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
+	ret = irq_set_affinity(irq, online_set);
+	if (!ret)
+		desc->cs = s->cs;
+
+	return ret;
+}
+
+static int update_irqs(struct cpuset *cs, char *buf)
+{
+	struct cpuset_irq_update s = {
+		.v = { .function = cpuset_update_irq },
+		.cs = cs,
+	};
+
+	if (sscanf(buf, "%d", &s.irq) != 1)
+		return -EIO;
+
+	return irq_iterator(&s.v);
+}
+#else
+static int update_irqs(struct cpuset *cs, char *buf)
+{
+	return 0;
+}
+#endif
+
 /*
  * Frequency meter - How fast is some event occurring?
  *
@@ -1206,6 +1295,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_IRQS,
 } cpuset_filetype_t;
 
 static ssize_t cpuset_common_file_write(struct cgroup *cont,
@@ -1273,6 +1363,9 @@ static ssize_t cpuset_common_file_write(struct cgroup *cont,
 		retval = update_flag(CS_SPREAD_SLAB, cs, buffer);
 		cs->mems_generation = cpuset_mems_generation++;
 		break;
+	case FILE_IRQS:
+		retval = update_irqs(cs, buffer);
+		break;
 	default:
 		retval = -EINVAL;
 		goto out2;
@@ -1321,6 +1414,59 @@ static int cpuset_sprintf_memlist(char *page, struct cpuset *cs)
 	return nodelist_scnprintf(page, PAGE_SIZE, mask);
 }
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+struct cpuset_irq_print {
+	struct irq_iterator v;
+	struct cpuset *cs;
+	char *buf;
+	int len;
+	int buflen;
+};
+
+static int
+cpuset_sprintf_irq(struct irq_iterator *v, int irq, struct irq_desc *desc)
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
+#else
+static int cpuset_sprintf_irqlist(char *page, struct cpuset *cs)
+{
+	return 0;
+}
+#endif
+
 static ssize_t cpuset_common_file_read(struct cgroup *cont,
 				       struct cftype *cft,
 				       struct file *file,
@@ -1369,6 +1515,9 @@ static ssize_t cpuset_common_file_read(struct cgroup *cont,
 	case FILE_SPREAD_SLAB:
 		*s++ = is_spread_slab(cs) ? '1' : '0';
 		break;
+	case FILE_IRQS:
+		s += cpuset_sprintf_irqlist(s, cs);
+		break;
 	default:
 		retval = -EINVAL;
 		goto out;
@@ -1459,6 +1608,13 @@ static struct cftype cft_spread_slab = {
 	.private = FILE_SPREAD_SLAB,
 };
 
+static struct cftype cft_irqs = {
+	.name = "irqs",
+	.read = cpuset_common_file_read,
+	.write = cpuset_common_file_write,
+	.private = FILE_IRQS,
+};
+
 static int cpuset_populate(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	int err;
@@ -1481,6 +1637,10 @@ static int cpuset_populate(struct cgroup_subsys *ss, struct cgroup *cont)
 		return err;
 	if ((err = cgroup_add_file(cont, ss, &cft_spread_slab)) < 0)
 		return err;
+#ifdef CONFIG_GENERIC_HARDIRQS
+	if ((err = cgroup_add_file(cont, ss, &cft_irqs)) < 0)
+		return err;
+#endif
 	/* memory_pressure_enabled is in root cpuset only */
 	if (err == 0 && !cont->parent)
 		err = cgroup_add_file(cont, ss,
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 438a014..5154c25 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -96,6 +96,25 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 
 #endif
 
+int irq_iterator(struct irq_iterator *v)
+{
+	int ret = 0;
+	int irq;
+
+	for (irq = 0; irq < NR_IRQS; irq++) {
+		struct irq_desc *desc = &irq_desc[irq];
+
+		if (desc->chip == &no_irq_chip)
+			continue;
+
+		ret = v->function(v, irq, desc);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
 /**
  *	disable_irq_nosync - disable an irq without waiting
  *	@irq: Interrupt to disable
-- 
1.5.4.1

