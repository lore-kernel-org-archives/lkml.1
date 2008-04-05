Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbYDEBZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbYDEBZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYDEBYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:24:50 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57013 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751073AbYDEBYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:24:48 -0400
Message-Id: <20080405012447.924854000@polaris-admin.engr.sgi.com>
References: <20080405012447.440875000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:24:50 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] cpumask: use new cpus_scnprintf function v2
Content-Disposition: inline; filename=use-cpuset_scnprintf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpus_scnprintf to print cpumask sets where appropriate.  This is used
when the number of cpus present in a system is so large that the current
method of printing cpumask_t sets as mask bits result in a large number
of output lines.  See Documentation/sysctl/kernel.txt(compat_cpus_printf)
for usage info.

The version for kernel/sched_stats.h is bumped to 15 with a note in
Documentation/scheduler/sched-stats.txt describing the change.

Also some small bugs fixed (or code efficiency improvments) for various uses
of cpus_scnprintf.

[Depends on: x86: add cpus_scnprintf function patch]

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
v2:
    Renamed cpuset_scnprintf() to cpus_scnprintf to avoid confusion with
    "cpusets", and changed the other names to match.
---
 Documentation/scheduler/sched-stats.txt |    6 ++++++
 drivers/base/node.c                     |    2 +-
 drivers/base/topology.c                 |   14 +++++++++++---
 drivers/pci/pci-sysfs.c                 |    7 ++++---
 drivers/pci/probe.c                     |    6 +++---
 kernel/cpuset.c                         |    4 ++--
 kernel/irq/proc.c                       |    2 +-
 kernel/profile.c                        |    2 +-
 kernel/sched_stats.h                    |   11 ++++++++---
 kernel/trace/trace.c                    |    2 +-
 10 files changed, 38 insertions(+), 18 deletions(-)

--- linux-2.6.x86.orig/Documentation/scheduler/sched-stats.txt
+++ linux-2.6.x86/Documentation/scheduler/sched-stats.txt
@@ -1,3 +1,9 @@
+Version 15 is a slight change to the output format.  The list of cpus in
+a group may be sent in one of two formats.  This is to accomodate systems
+with very large count of cpus. There is a sysctl bit that changes this
+behaviour.  See the Documentation/sysctl/kernel.txt:"compat_cpus_printf"
+flag for further info.
+
 Version 14 of schedstats includes support for sched_domains, which hit the
 mainline kernel in 2.6.20 although it is identical to the stats from version
 12 which was in the kernel from 2.6.13-2.6.19 (version 13 never saw a kernel
--- linux-2.6.x86.orig/drivers/base/node.c
+++ linux-2.6.x86/drivers/base/node.c
@@ -28,7 +28,7 @@ static ssize_t node_read_cpumap(struct s
 	/* 2004/06/03: buf currently PAGE_SIZE, need > 1 char per 4 bits. */
 	BUILD_BUG_ON(MAX_NUMNODES/4 > PAGE_SIZE/2);
 
-	len = cpumask_scnprintf(buf, PAGE_SIZE-2, *mask);
+	len = cpus_scnprintf(buf, PAGE_SIZE-2, *mask);
  	buf[len++] = '\n';
  	buf[len] = '\0';
 	return len;
--- linux-2.6.x86.orig/drivers/base/topology.c
+++ linux-2.6.x86/drivers/base/topology.c
@@ -43,10 +43,18 @@ static ssize_t show_##name(struct sys_de
 #define define_siblings_show_func(name)					\
 static ssize_t show_##name(struct sys_device *dev, char *buf)		\
 {									\
-	ssize_t len = -1;						\
+	unsigned long end = ALIGN((unsigned long)buf, PAGE_SIZE);	\
+	int len = end - (unsigned long)buf;				\
+	int n = 0;							\
 	unsigned int cpu = dev->id;					\
-	len = cpumask_scnprintf(buf, NR_CPUS+1, topology_##name(cpu));	\
-	return (len + sprintf(buf + len, "\n"));			\
+	if (len == 0)							\
+		len = PAGE_SIZE;					\
+	if (len > 1) {							\
+		n = cpus_scnprintf(buf, len-2, topology_##name(cpu));	\
+		buf[n++] = '\n';					\
+		buf[n] = '\0';						\
+	}								\
+	return n;							\
 }
 
 #ifdef	topology_physical_package_id
--- linux-2.6.x86.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6.x86/drivers/pci/pci-sysfs.c
@@ -72,9 +72,10 @@ static ssize_t local_cpus_show(struct de
 	int len;
 
 	mask = pcibus_to_cpumask(to_pci_dev(dev)->bus);
-	len = cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
-	strcat(buf,"\n"); 
-	return 1+len;
+	len = cpus_scnprintf(buf, PAGE_SIZE-2, mask);
+	buf[len++] = '\n';
+	buf[len] = '\0';
+	return len;
 }
 
 /* show resources */
--- linux-2.6.x86.orig/drivers/pci/probe.c
+++ linux-2.6.x86/drivers/pci/probe.c
@@ -89,9 +89,9 @@ static ssize_t pci_bus_show_cpuaffinity(
 	cpumask_t cpumask;
 
 	cpumask = pcibus_to_cpumask(to_pci_bus(dev));
-	ret = cpumask_scnprintf(buf, PAGE_SIZE, cpumask);
-	if (ret < PAGE_SIZE)
-		buf[ret++] = '\n';
+	ret = cpus_scnprintf(buf, PAGE_SIZE-2, cpumask);
+	buf[ret++] = '\n';
+	buf[ret] = '\0';
 	return ret;
 }
 DEVICE_ATTR(cpuaffinity, S_IRUGO, pci_bus_show_cpuaffinity, NULL);
--- linux-2.6.x86.orig/kernel/cpuset.c
+++ linux-2.6.x86/kernel/cpuset.c
@@ -2364,11 +2364,11 @@ const struct file_operations proc_cpuset
 void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
 {
 	seq_printf(m, "Cpus_allowed:\t");
-	m->count += cpumask_scnprintf(m->buf + m->count, m->size - m->count,
+	m->count += cpus_scnprintf(m->buf + m->count, m->size - m->count,
 					task->cpus_allowed);
 	seq_printf(m, "\n");
 	seq_printf(m, "Mems_allowed:\t");
-	m->count += nodemask_scnprintf(m->buf + m->count, m->size - m->count,
+	m->count += nodes_scnprintf(m->buf + m->count, m->size - m->count,
 					task->mems_allowed);
 	seq_printf(m, "\n");
 }
--- linux-2.6.x86.orig/kernel/irq/proc.c
+++ linux-2.6.x86/kernel/irq/proc.c
@@ -27,7 +27,7 @@ static int irq_affinity_read_proc(char *
 	if (desc->status & IRQ_MOVE_PENDING)
 		mask = &desc->pending_mask;
 #endif
-	len = cpumask_scnprintf(page, count, *mask);
+	len = cpus_scnprintf(page, count, *mask);
 
 	if (count - len < 2)
 		return -EINVAL;
--- linux-2.6.x86.orig/kernel/profile.c
+++ linux-2.6.x86/kernel/profile.c
@@ -426,7 +426,7 @@ void profile_tick(int type)
 static int prof_cpu_mask_read_proc(char *page, char **start, off_t off,
 			int count, int *eof, void *data)
 {
-	int len = cpumask_scnprintf(page, count, *(cpumask_t *)data);
+	int len = cpus_scnprintf(page, count, *(cpumask_t *)data);
 	if (count - len < 2)
 		return -EINVAL;
 	len += sprintf(page + len, "\n");
--- linux-2.6.x86.orig/kernel/sched_stats.h
+++ linux-2.6.x86/kernel/sched_stats.h
@@ -4,11 +4,16 @@
  * bump this up when changing the output format or the meaning of an existing
  * format, so that tools can adapt (or abort)
  */
-#define SCHEDSTAT_VERSION 14
+#define SCHEDSTAT_VERSION 15
 
 static int show_schedstat(struct seq_file *seq, void *v)
 {
 	int cpu;
+	int mask_len = NR_CPUS/32 * 9;
+	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
+
+	if (mask_str == NULL)
+		return -ENOMEM;
 
 	seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
 	seq_printf(seq, "timestamp %lu\n", jiffies);
@@ -36,9 +41,8 @@ static int show_schedstat(struct seq_fil
 		preempt_disable();
 		for_each_domain(cpu, sd) {
 			enum cpu_idle_type itype;
-			char mask_str[NR_CPUS];
 
-			cpumask_scnprintf(mask_str, NR_CPUS, sd->span);
+			cpus_scnprintf(mask_str, mask_len, sd->span);
 			seq_printf(seq, "domain%d %s", dcount++, mask_str);
 			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
 					itype++) {
@@ -63,6 +67,7 @@ static int show_schedstat(struct seq_fil
 		preempt_enable();
 #endif
 	}
+	kfree(mask_str);
 	return 0;
 }
 
--- linux-2.6.x86.orig/kernel/trace/trace.c
+++ linux-2.6.x86/kernel/trace/trace.c
@@ -1799,7 +1799,7 @@ tracing_cpumask_read(struct file *filp, 
 
 	mutex_lock(&tracing_cpumask_update_lock);
 
-	len = cpumask_scnprintf(mask_str, count, tracing_cpumask);
+	len = cpus_scnprintf(mask_str, count, tracing_cpumask);
 	if (count - len < 2) {
 		count = -EINVAL;
 		goto out_err;

-- 
