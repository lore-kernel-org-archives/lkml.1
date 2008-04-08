Return-Path: <linux-kernel-owner+w=401wt.eu-S1758439AbYDHSny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439AbYDHSny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 14:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbYDHSnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 14:43:08 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42600 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755503AbYDHSnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 14:43:03 -0400
Message-Id: <20080408184301.975491000@polaris-admin.engr.sgi.com>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 08 Apr 2008 11:43:03 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Bert Wesarg <bert.wesarg@googlemail.com>, Paul Jackson <pj@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] cpumask: use new cpus_scnprintf function v3
Content-Disposition: inline; filename=cleanup-cpumask_scnprintf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Cleaned up references to cpumask_scnprintf() and added new
    cpulist_scnprintf() interfaces where appropriate.

  * Fix some small bugs (or code efficiency improvments) for various uses
    of cpumask_scnprintf.

  * Clean up some checkpatch errors.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
v3:
    Removed cpus_scnprintf() and all references.
    Removed changes to sched_stat.h (now cleanup only).

    Three unfixable checkpatch warnings/errors:

WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc
#49: FILE: drivers/base/node.c:29:
+	BUILD_BUG_ON((NR_CPUS/32 * 9) > (PAGE_SIZE-1));

ERROR: Macros with complex values should be enclosed in parenthesis
#115: FILE: drivers/base/topology.c:59:
+static inline ssize_t show_##name(struct sys_device *dev, char *buf)	\

ERROR: Macros with complex values should be enclosed in parenthesis
#125: FILE: drivers/base/topology.c:66:
+static inline ssize_t show_##name##_list(struct sys_device *dev, char *buf) \

v2:
    Renamed cpuset_scnprintf() to cpus_scnprintf to avoid confusion with
    "cpusets", and changed the other names to match.
---
 drivers/base/node.c     |   24 +++++++++++++++++++-----
 drivers/base/topology.c |   41 ++++++++++++++++++++++++++++++++++-------
 drivers/pci/pci-sysfs.c |   20 ++++++++++++++++++--
 drivers/pci/probe.c     |   27 +++++++++++++++++++++++----
 kernel/cpuset.c         |    8 ++++++++
 kernel/sched_stats.h    |    8 ++++++--
 6 files changed, 108 insertions(+), 20 deletions(-)

--- linux-2.6.x86.sched.orig/drivers/base/node.c
+++ linux-2.6.x86.sched/drivers/base/node.c
@@ -19,22 +19,34 @@ static struct sysdev_class node_class = 
 };
 
 
-static ssize_t node_read_cpumap(struct sys_device * dev, char * buf)
+static ssize_t node_read_cpumap(struct sys_device *dev, int type, char *buf)
 {
 	struct node *node_dev = to_node(dev);
 	node_to_cpumask_ptr(mask, node_dev->sysdev.id);
 	int len;
 
-	/* 2004/06/03: buf currently PAGE_SIZE, need > 1 char per 4 bits. */
-	BUILD_BUG_ON(MAX_NUMNODES/4 > PAGE_SIZE/2);
+	/* 2008/04/07: buf currently PAGE_SIZE, need 9 chars per 32 bits. */
+	BUILD_BUG_ON((NR_CPUS/32 * 9) > (PAGE_SIZE-1));
 
-	len = cpumask_scnprintf(buf, PAGE_SIZE-2, *mask);
+	len = type?
+		cpulist_scnprintf(buf, PAGE_SIZE-2, *mask):
+		cpumask_scnprintf(buf, PAGE_SIZE-2, *mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
 	return len;
 }
 
-static SYSDEV_ATTR(cpumap, S_IRUGO, node_read_cpumap, NULL);
+static inline ssize_t node_read_cpumask(struct sys_device *dev, char *buf)
+{
+	return node_read_cpumap(dev, 0, buf);
+}
+static inline ssize_t node_read_cpulist(struct sys_device *dev, char *buf)
+{
+	return node_read_cpumap(dev, 1, buf);
+}
+
+static SYSDEV_ATTR(cpumap,  S_IRUGO, node_read_cpumask, NULL);
+static SYSDEV_ATTR(cpulist, S_IRUGO, node_read_cpulist, NULL);
 
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 static ssize_t node_read_meminfo(struct sys_device * dev, char * buf)
@@ -150,6 +162,7 @@ int register_node(struct node *node, int
 
 	if (!error){
 		sysdev_create_file(&node->sysdev, &attr_cpumap);
+		sysdev_create_file(&node->sysdev, &attr_cpulist);
 		sysdev_create_file(&node->sysdev, &attr_meminfo);
 		sysdev_create_file(&node->sysdev, &attr_numastat);
 		sysdev_create_file(&node->sysdev, &attr_distance);
@@ -167,6 +180,7 @@ int register_node(struct node *node, int
 void unregister_node(struct node *node)
 {
 	sysdev_remove_file(&node->sysdev, &attr_cpumap);
+	sysdev_remove_file(&node->sysdev, &attr_cpulist);
 	sysdev_remove_file(&node->sysdev, &attr_meminfo);
 	sysdev_remove_file(&node->sysdev, &attr_numastat);
 	sysdev_remove_file(&node->sysdev, &attr_distance);
--- linux-2.6.x86.sched.orig/drivers/base/topology.c
+++ linux-2.6.x86.sched/drivers/base/topology.c
@@ -40,15 +40,38 @@ static ssize_t show_##name(struct sys_de
 	return sprintf(buf, "%d\n", topology_##name(cpu));	\
 }
 
-#define define_siblings_show_func(name)					\
-static ssize_t show_##name(struct sys_device *dev, char *buf)		\
+static ssize_t show_cpumap(int type, cpumask_t *mask, char *buf)
+{
+	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
+	int n = 0;
+
+	if (len > 1) {
+		n = type?
+			cpulist_scnprintf(buf, len-2, *mask):
+			cpumask_scnprintf(buf, len-2, *mask);
+		buf[n++] = '\n';
+		buf[n] = '\0';
+	}
+	return n;
+}
+
+#define define_siblings_show_map(name)					\
+static inline ssize_t show_##name(struct sys_device *dev, char *buf)	\
 {									\
-	ssize_t len = -1;						\
 	unsigned int cpu = dev->id;					\
-	len = cpumask_scnprintf(buf, NR_CPUS+1, topology_##name(cpu));	\
-	return (len + sprintf(buf + len, "\n"));			\
+	return show_cpumap(0, &(topology_##name(cpu)), buf);		\
 }
 
+#define define_siblings_show_list(name)					\
+static inline ssize_t show_##name##_list(struct sys_device *dev, char *buf) \
+{									\
+	unsigned int cpu = dev->id;					\
+	return show_cpumap(1, &(topology_##name(cpu)), buf);		\
+}
+
+#define define_siblings_show_func(name)		\
+	define_siblings_show_map(name); define_siblings_show_list(name)
+
 #ifdef	topology_physical_package_id
 define_id_show_func(physical_package_id);
 define_one_ro(physical_package_id);
@@ -68,7 +91,9 @@ define_one_ro(core_id);
 #ifdef topology_thread_siblings
 define_siblings_show_func(thread_siblings);
 define_one_ro(thread_siblings);
-#define ref_thread_siblings_attr	&attr_thread_siblings.attr,
+define_one_ro(thread_siblings_list);
+#define ref_thread_siblings_attr	\
+		&attr_thread_siblings.attr, &attr_thread_siblings_list.attr,
 #else
 #define ref_thread_siblings_attr
 #endif
@@ -76,7 +101,9 @@ define_one_ro(thread_siblings);
 #ifdef topology_core_siblings
 define_siblings_show_func(core_siblings);
 define_one_ro(core_siblings);
-#define ref_core_siblings_attr		&attr_core_siblings.attr,
+define_one_ro(core_siblings_list);
+#define ref_core_siblings_attr		\
+		&attr_core_siblings.attr, &attr_core_siblings_list.attr,
 #else
 #define ref_core_siblings_attr
 #endif
--- linux-2.6.x86.sched.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6.x86.sched/drivers/pci/pci-sysfs.c
@@ -73,8 +73,23 @@ static ssize_t local_cpus_show(struct de
 
 	mask = pcibus_to_cpumask(to_pci_dev(dev)->bus);
 	len = cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
-	strcat(buf,"\n"); 
-	return 1+len;
+	buf[len++] = '\n';
+	buf[len] = '\0';
+	return len;
+}
+
+
+static ssize_t local_cpulist_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	cpumask_t mask;
+	int len;
+
+	mask = pcibus_to_cpumask(to_pci_dev(dev)->bus);
+	len = cpulist_scnprintf(buf, PAGE_SIZE-2, mask);
+	buf[len++] = '\n';
+	buf[len] = '\0';
+	return len;
 }
 
 /* show resources */
@@ -201,6 +216,7 @@ struct device_attribute pci_dev_attrs[] 
 	__ATTR_RO(class),
 	__ATTR_RO(irq),
 	__ATTR_RO(local_cpus),
+	__ATTR_RO(local_cpulist),
 	__ATTR_RO(modalias),
 #ifdef CONFIG_NUMA
 	__ATTR_RO(numa_node),
--- linux-2.6.x86.sched.orig/drivers/pci/probe.c
+++ linux-2.6.x86.sched/drivers/pci/probe.c
@@ -82,6 +82,7 @@ void pci_remove_legacy_files(struct pci_
  * PCI Bus Class Devices
  */
 static ssize_t pci_bus_show_cpuaffinity(struct device *dev,
+					int type,
 					struct device_attribute *attr,
 					char *buf)
 {
@@ -89,12 +90,30 @@ static ssize_t pci_bus_show_cpuaffinity(
 	cpumask_t cpumask;
 
 	cpumask = pcibus_to_cpumask(to_pci_bus(dev));
-	ret = cpumask_scnprintf(buf, PAGE_SIZE, cpumask);
-	if (ret < PAGE_SIZE)
-		buf[ret++] = '\n';
+	ret = type?
+		cpulist_scnprintf(buf, PAGE_SIZE-2, cpumask):
+		cpumask_scnprintf(buf, PAGE_SIZE-2, cpumask);
+	buf[ret++] = '\n';
+	buf[ret] = '\0';
 	return ret;
 }
-DEVICE_ATTR(cpuaffinity, S_IRUGO, pci_bus_show_cpuaffinity, NULL);
+
+static ssize_t inline pci_bus_show_cpumaskaffinity(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return pci_bus_show_cpuaffinity(dev, 0, attr, buf);
+}
+
+static ssize_t inline pci_bus_show_cpulistaffinity(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return pci_bus_show_cpuaffinity(dev, 1, attr, buf);
+}
+
+DEVICE_ATTR(cpuaffinity,     S_IRUGO, pci_bus_show_cpumaskaffinity, NULL);
+DEVICE_ATTR(cpulistaffinity, S_IRUGO, pci_bus_show_cpulistaffinity, NULL);
 
 /*
  * PCI Bus Class
--- linux-2.6.x86.sched.orig/kernel/cpuset.c
+++ linux-2.6.x86.sched/kernel/cpuset.c
@@ -2369,8 +2369,16 @@ void cpuset_task_status_allowed(struct s
 	m->count += cpumask_scnprintf(m->buf + m->count, m->size - m->count,
 					task->cpus_allowed);
 	seq_printf(m, "\n");
+	seq_printf(m, "Cpus_allowed_list:\t");
+	m->count += cpulist_scnprintf(m->buf + m->count, m->size - m->count,
+					task->cpus_allowed);
+	seq_printf(m, "\n");
 	seq_printf(m, "Mems_allowed:\t");
 	m->count += nodemask_scnprintf(m->buf + m->count, m->size - m->count,
 					task->mems_allowed);
 	seq_printf(m, "\n");
+	seq_printf(m, "Mems_allowed_list:\t");
+	m->count += nodelist_scnprintf(m->buf + m->count, m->size - m->count,
+					task->mems_allowed);
+	seq_printf(m, "\n");
 }
--- linux-2.6.x86.sched.orig/kernel/sched_stats.h
+++ linux-2.6.x86.sched/kernel/sched_stats.h
@@ -9,6 +9,11 @@
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
+			cpumask_scnprintf(mask_str, mask_len, sd->span);
 			seq_printf(seq, "domain%d %s", dcount++, mask_str);
 			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
 					itype++) {

-- 
