Return-Path: <linux-kernel-owner+w=401wt.eu-S932853AbYB2S4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853AbYB2S4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759134AbYB2S41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:56:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55531 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758161AbYB2S40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:56:26 -0500
Subject: [RFC/PATCH] cpuset: cpuset irq affinities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Jackson <pj@sgi.com>,
       Max Krasnyanskiy <maxk@qualcomm.com>, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>
In-Reply-To: <20080227222103.673194000@chello.nl>
References: <20080227222103.673194000@chello.nl>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 19:55:51 +0100
Message-Id: <1204311351.6243.130.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

How about something like this; along with the in-kernel version
of /cgroup/boot this could also provide the desired semantics.

Another benefit of this approach would be that it no longer requires
PF_THREAD_BIND, as we'd only stick unbounded kthreads into that cgroup.

(compile tested only)
---
Subject: cpuset: cpuset irq affinities

Allow for an association between cpusets and irqs. 

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/irq.h |    9 ++
 kernel/cpuset.c     |  160 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/irq/manage.c |   19 ++++++
 3 files changed, 188 insertions(+)

Index: linux-2.6-2/include/linux/irq.h
===================================================================
--- linux-2.6-2.orig/include/linux/irq.h
+++ linux-2.6-2/include/linux/irq.h
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
Index: linux-2.6-2/kernel/cpuset.c
===================================================================
--- linux-2.6-2.orig/kernel/cpuset.c
+++ linux-2.6-2/kernel/cpuset.c
@@ -50,6 +50,9 @@
 #include <linux/time.h>
 #include <linux/backing-dev.h>
 #include <linux/sort.h>
+#ifdef CONFIG_GENERIC_HARDIRQS
+#include <linux/irq.h>
+#endif
 
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
@@ -732,6 +735,44 @@ void cpuset_change_cpumask(struct task_s
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
@@ -795,6 +836,8 @@ static int update_cpumask(struct cpuset 
 	cgroup_scan_tasks(&scan);
 	heap_free(&heap);
 
+	update_irqs_cpumask(cs);
+
 	if (is_load_balanced)
 		rebuild_sched_domains();
 	return 0;
@@ -1056,6 +1099,52 @@ static int update_flag(cpuset_flagbits_t
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
@@ -1273,6 +1363,9 @@ static ssize_t cpuset_common_file_write(
 		retval = update_flag(CS_SPREAD_SLAB, cs, buffer);
 		cs->mems_generation = cpuset_mems_generation++;
 		break;
+	case FILE_IRQS:
+		retval = update_irqs(cs, buffer);
+		break;
 	default:
 		retval = -EINVAL;
 		goto out2;
@@ -1321,6 +1414,59 @@ static int cpuset_sprintf_memlist(char *
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
@@ -1369,6 +1515,9 @@ static ssize_t cpuset_common_file_read(s
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
@@ -1481,6 +1637,10 @@ static int cpuset_populate(struct cgroup
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
Index: linux-2.6-2/kernel/irq/manage.c
===================================================================
--- linux-2.6-2.orig/kernel/irq/manage.c
+++ linux-2.6-2/kernel/irq/manage.c
@@ -96,6 +96,25 @@ int irq_set_affinity(unsigned int irq, c
 
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


