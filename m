Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYKSOiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYKSOiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 09:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbYKSOiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 09:38:16 -0500
Received: from ozlabs.org ([203.10.76.45]:50953 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbYKSOiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 09:38:14 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 20 Nov 2008 01:08:09 +1030
Subject: [PATCH 2/2] cpumask: change cpumask_scnprintf, cpumask_parse_user, cpulist_parse, and cpulist_scnprintf to take pointers.
Cc: Mike Travis <travis@sgi.com>, paulus@samba.org, mingo@redhat.com,
       tony.luck@intel.com, ralf@linux-mips.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>, cl@linux-foundation.org,
       srostedt@redhat.com
Cc: paulus@samba.org
Cc: mingo@redhat.com
Cc: tony.luck@intel.com
Cc: ralf@linux-mips.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: cl@linux-foundation.org
Cc: srostedt@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811200108.10789.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Linux-next again, but simple conversion...)

Most cpumask functions started with cpus_: these have been replaced by
cpumask_ ones which take struct cpumask pointers as expected.

These four functions don't have good replacement names; fortunately
they're rarely used, so we just change them over.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: paulus@samba.org
Cc: mingo@redhat.com
Cc: tony.luck@intel.com
Cc: ralf@linux-mips.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: cl@linux-foundation.org
Cc: srostedt@redhat.com
---
 arch/ia64/kernel/topology.c           |    2 
 arch/mips/kernel/smp-cmp.c            |    4 -
 arch/powerpc/platforms/pseries/xics.c |    2 
 arch/x86/kernel/cpu/intel_cacheinfo.c |    4 -
 arch/x86/kernel/setup_percpu.c        |    2 
 drivers/base/cpu.c                    |    2 
 drivers/base/node.c                   |    4 -
 drivers/base/topology.c               |    4 -
 drivers/pci/pci-sysfs.c               |    4 -
 drivers/pci/probe.c                   |    4 -
 include/linux/cpumask.h               |   87 ++++++++++++++++++++++------------
 kernel/cpuset.c                       |    4 -
 kernel/irq/proc.c                     |    4 -
 kernel/profile.c                      |    4 -
 kernel/sched.c                        |    4 -
 kernel/sched_stats.h                  |    2 
 kernel/taskstats.c                    |    2 
 kernel/trace/trace.c                  |    4 -
 mm/slub.c                             |    2 
 19 files changed, 86 insertions(+), 59 deletions(-)

diff -r 6c44aeb88161 arch/ia64/kernel/topology.c
--- a/arch/ia64/kernel/topology.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/arch/ia64/kernel/topology.c	Fri Nov 07 10:23:40 2008 +1100
@@ -217,7 +217,7 @@ static ssize_t show_shared_cpu_map(struc
 	cpumask_t shared_cpu_map;
 
 	cpus_and(shared_cpu_map, this_leaf->shared_cpu_map, cpu_online_map);
-	len = cpumask_scnprintf(buf, NR_CPUS+1, shared_cpu_map);
+	len = cpumask_scnprintf(buf, NR_CPUS+1, &shared_cpu_map);
 	len += sprintf(buf+len, "\n");
 	return len;
 }
diff -r 6c44aeb88161 arch/mips/kernel/smp-cmp.c
--- a/arch/mips/kernel/smp-cmp.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/arch/mips/kernel/smp-cmp.c	Fri Nov 07 10:23:40 2008 +1100
@@ -51,10 +51,10 @@ static int __init allowcpus(char *str)
 	int len;
 
 	cpus_clear(cpu_allow_map);
-	if (cpulist_parse(str, cpu_allow_map) == 0) {
+	if (cpulist_parse(str, &cpu_allow_map) == 0) {
 		cpu_set(0, cpu_allow_map);
 		cpus_and(cpu_possible_map, cpu_possible_map, cpu_allow_map);
-		len = cpulist_scnprintf(buf, sizeof(buf)-1, cpu_possible_map);
+		len = cpulist_scnprintf(buf, sizeof(buf)-1, &cpu_possible_map);
 		buf[len] = '\0';
 		pr_debug("Allowable CPUs: %s\n", buf);
 		return 1;
diff -r 6c44aeb88161 arch/powerpc/platforms/pseries/xics.c
--- a/arch/powerpc/platforms/pseries/xics.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/arch/powerpc/platforms/pseries/xics.c	Fri Nov 07 10:23:40 2008 +1100
@@ -358,7 +358,7 @@ static void xics_set_affinity(unsigned i
 	irq_server = get_irq_server(virq, 1);
 	if (irq_server == -1) {
 		char cpulist[128];
-		cpumask_scnprintf(cpulist, sizeof(cpulist), cpumask);
+		cpumask_scnprintf(cpulist, sizeof(cpulist), &cpumask);
 		printk(KERN_WARNING
 			"%s: No online cpus in the mask %s for irq %d\n",
 			__func__, cpulist, virq);
diff -r 6c44aeb88161 arch/x86/kernel/cpu/intel_cacheinfo.c
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c	Fri Nov 07 10:23:40 2008 +1100
@@ -626,8 +626,8 @@ static ssize_t show_shared_cpu_map_func(
 		cpumask_t *mask = &this_leaf->shared_cpu_map;
 
 		n = type?
-			cpulist_scnprintf(buf, len-2, *mask):
-			cpumask_scnprintf(buf, len-2, *mask);
+			cpulist_scnprintf(buf, len-2, mask) :
+			cpumask_scnprintf(buf, len-2, mask);
 		buf[n++] = '\n';
 		buf[n] = '\0';
 	}
diff -r 6c44aeb88161 arch/x86/kernel/setup_percpu.c
--- a/arch/x86/kernel/setup_percpu.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/arch/x86/kernel/setup_percpu.c	Fri Nov 07 10:23:40 2008 +1100
@@ -282,7 +282,7 @@ static void __cpuinit numa_set_cpumask(i
 	else
 		cpu_clear(cpu, *mask);
 
-	cpulist_scnprintf(buf, sizeof(buf), *mask);
+	cpulist_scnprintf(buf, sizeof(buf), mask);
 	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
 		enable? "numa_add_cpu":"numa_remove_cpu", cpu, node, buf);
  }
diff -r 6c44aeb88161 drivers/base/cpu.c
--- a/drivers/base/cpu.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/drivers/base/cpu.c	Fri Nov 07 10:23:40 2008 +1100
@@ -109,7 +109,7 @@ static SYSDEV_ATTR(crash_notes, 0400, sh
  */
 static ssize_t print_cpus_map(char *buf, cpumask_t *map)
 {
-	int n = cpulist_scnprintf(buf, PAGE_SIZE-2, *map);
+	int n = cpulist_scnprintf(buf, PAGE_SIZE-2, map);
 
 	buf[n++] = '\n';
 	buf[n] = '\0';
diff -r 6c44aeb88161 drivers/base/node.c
--- a/drivers/base/node.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/drivers/base/node.c	Fri Nov 07 10:23:40 2008 +1100
@@ -30,8 +30,8 @@ static ssize_t node_read_cpumap(struct s
 	BUILD_BUG_ON((NR_CPUS/32 * 9) > (PAGE_SIZE-1));
 
 	len = type?
-		cpulist_scnprintf(buf, PAGE_SIZE-2, *mask):
-		cpumask_scnprintf(buf, PAGE_SIZE-2, *mask);
+		cpulist_scnprintf(buf, PAGE_SIZE-2, mask) :
+		cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
  	buf[len++] = '\n';
  	buf[len] = '\0';
 	return len;
diff -r 6c44aeb88161 drivers/base/topology.c
--- a/drivers/base/topology.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/drivers/base/topology.c	Fri Nov 07 10:23:40 2008 +1100
@@ -49,8 +49,8 @@ static ssize_t show_cpumap(int type, cpu
 
 	if (len > 1) {
 		n = type?
-			cpulist_scnprintf(buf, len-2, *mask):
-			cpumask_scnprintf(buf, len-2, *mask);
+			cpulist_scnprintf(buf, len-2, mask) :
+			cpumask_scnprintf(buf, len-2, mask);
 		buf[n++] = '\n';
 		buf[n] = '\0';
 	}
diff -r 6c44aeb88161 drivers/pci/pci-sysfs.c
--- a/drivers/pci/pci-sysfs.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/drivers/pci/pci-sysfs.c	Fri Nov 07 10:23:40 2008 +1100
@@ -74,7 +74,7 @@ static ssize_t local_cpus_show(struct de
 	int len;
 
 	mask = pcibus_to_cpumask(to_pci_dev(dev)->bus);
-	len = cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
+	len = cpumask_scnprintf(buf, PAGE_SIZE-2, &mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
 	return len;
@@ -88,7 +88,7 @@ static ssize_t local_cpulist_show(struct
 	int len;
 
 	mask = pcibus_to_cpumask(to_pci_dev(dev)->bus);
-	len = cpulist_scnprintf(buf, PAGE_SIZE-2, mask);
+	len = cpulist_scnprintf(buf, PAGE_SIZE-2, &mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
 	return len;
diff -r 6c44aeb88161 drivers/pci/probe.c
--- a/drivers/pci/probe.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/drivers/pci/probe.c	Fri Nov 07 10:23:40 2008 +1100
@@ -55,8 +55,8 @@ static ssize_t pci_bus_show_cpuaffinity(
 
 	cpumask = pcibus_to_cpumask(to_pci_bus(dev));
 	ret = type?
-		cpulist_scnprintf(buf, PAGE_SIZE-2, cpumask):
-		cpumask_scnprintf(buf, PAGE_SIZE-2, cpumask);
+		cpulist_scnprintf(buf, PAGE_SIZE-2, &cpumask) :
+		cpumask_scnprintf(buf, PAGE_SIZE-2, &cpumask);
 	buf[ret++] = '\n';
 	buf[ret] = '\0';
 	return ret;
diff -r 6c44aeb88161 include/linux/cpumask.h
--- a/include/linux/cpumask.h	Fri Nov 07 10:23:17 2008 +1100
+++ b/include/linux/cpumask.h	Fri Nov 07 10:23:40 2008 +1100
@@ -338,36 +338,6 @@ extern cpumask_t cpu_mask_all;
 #define	CPUMASK_FREE(m)
 #endif
 #define	CPUMASK_PTR(v, m) 	cpumask_t *v = &(m->v)
-
-#define cpumask_scnprintf(buf, len, src) \
-			__cpumask_scnprintf((buf), (len), &(src), NR_CPUS)
-static inline int __cpumask_scnprintf(char *buf, int len,
-					const cpumask_t *srcp, int nbits)
-{
-	return bitmap_scnprintf(buf, len, srcp->bits, nbits);
-}
-
-#define cpumask_parse_user(ubuf, ulen, dst) \
-			__cpumask_parse_user((ubuf), (ulen), &(dst), NR_CPUS)
-static inline int __cpumask_parse_user(const char __user *buf, int len,
-					cpumask_t *dstp, int nbits)
-{
-	return bitmap_parse_user(buf, len, dstp->bits, nbits);
-}
-
-#define cpulist_scnprintf(buf, len, src) \
-			__cpulist_scnprintf((buf), (len), &(src), NR_CPUS)
-static inline int __cpulist_scnprintf(char *buf, int len,
-					const cpumask_t *srcp, int nbits)
-{
-	return bitmap_scnlistprintf(buf, len, srcp->bits, nbits);
-}
-
-#define cpulist_parse(buf, dst) __cpulist_parse((buf), &(dst), NR_CPUS)
-static inline int __cpulist_parse(const char *buf, cpumask_t *dstp, int nbits)
-{
-	return bitmap_parselist(buf, dstp->bits, nbits);
-}
 
 #define cpu_remap(oldbit, old, new) \
 		__cpu_remap((oldbit), &(old), &(new), NR_CPUS)
@@ -900,6 +870,63 @@ static inline void cpumask_copy(struct c
 #define cpumask_of(cpu) (get_cpu_mask(cpu))
 
 /**
+ * cpumask_scnprintf - print a cpumask into a string as comma-separated hex
+ * @buf: the buffer to sprintf into
+ * @len: the length of the buffer
+ * @srcp: the cpumask to print
+ *
+ * If len is zero, returns zero.  Otherwise returns the length of the
+ * (nul-terminated) @buf string.
+ */
+static inline int cpumask_scnprintf(char *buf, int len,
+				    const struct cpumask *srcp)
+{
+	return bitmap_scnprintf(buf, len, srcp->bits, nr_cpumask_bits);
+}
+
+/**
+ * cpumask_parse_user - extract a cpumask from a user string
+ * @buf: the buffer to extract from
+ * @len: the length of the buffer
+ * @dstp: the cpumask to set.
+ *
+ * Returns -errno, or 0 for success.
+ */
+static inline int cpumask_parse_user(const char __user *buf, int len,
+				     struct cpumask *dstp)
+{
+	return bitmap_parse_user(buf, len, dstp->bits, nr_cpumask_bits);
+}
+
+/**
+ * cpulist_scnprintf - print a cpumask into a string as comma-separated list
+ * @buf: the buffer to sprintf into
+ * @len: the length of the buffer
+ * @srcp: the cpumask to print
+ *
+ * If len is zero, returns zero.  Otherwise returns the length of the
+ * (nul-terminated) @buf string.
+ */
+static inline int cpulist_scnprintf(char *buf, int len,
+				    const struct cpumask *srcp)
+{
+	return bitmap_scnlistprintf(buf, len, srcp->bits, nr_cpumask_bits);
+}
+
+/**
+ * cpulist_parse_user - extract a cpumask from a user string of ranges
+ * @buf: the buffer to extract from
+ * @len: the length of the buffer
+ * @dstp: the cpumask to set.
+ *
+ * Returns -errno, or 0 for success.
+ */
+static inline int cpulist_parse(const char *buf, struct cpumask *dstp)
+{
+	return bitmap_parselist(buf, dstp->bits, nr_cpumask_bits);
+}
+
+/**
  * to_cpumask - convert an NR_CPUS bitmap to a struct cpumask *
  * @bitmap: the bitmap
  *
diff -r 6c44aeb88161 kernel/cpuset.c
--- a/kernel/cpuset.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/kernel/cpuset.c	Fri Nov 07 10:23:40 2008 +1100
@@ -891,7 +891,7 @@ static int update_cpumask(struct cpuset 
 	if (!*buf) {
 		cpus_clear(trialcs.cpus_allowed);
 	} else {
-		retval = cpulist_parse(buf, trialcs.cpus_allowed);
+		retval = cpulist_parse(buf, &trialcs.cpus_allowed);
 		if (retval < 0)
 			return retval;
 
@@ -1477,7 +1477,7 @@ static int cpuset_sprintf_cpulist(char *
 	mask = cs->cpus_allowed;
 	mutex_unlock(&callback_mutex);
 
-	return cpulist_scnprintf(page, PAGE_SIZE, mask);
+	return cpulist_scnprintf(page, PAGE_SIZE, &mask);
 }
 
 static int cpuset_sprintf_memlist(char *page, struct cpuset *cs)
diff -r 6c44aeb88161 kernel/irq/proc.c
--- a/kernel/irq/proc.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/kernel/irq/proc.c	Fri Nov 07 10:23:40 2008 +1100
@@ -47,7 +47,7 @@ static ssize_t irq_affinity_proc_write(s
 	    irq_balancing_disabled(irq))
 		return -EIO;
 
-	err = cpumask_parse_user(buffer, count, new_value);
+	err = cpumask_parse_user(buffer, count, &new_value);
 	if (err)
 		return err;
 
@@ -95,7 +95,7 @@ static ssize_t default_affinity_write(st
 	cpumask_t new_value;
 	int err;
 
-	err = cpumask_parse_user(buffer, count, new_value);
+	err = cpumask_parse_user(buffer, count, &new_value);
 	if (err)
 		return err;
 
diff -r 6c44aeb88161 kernel/profile.c
--- a/kernel/profile.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/kernel/profile.c	Fri Nov 07 10:23:40 2008 +1100
@@ -442,7 +442,7 @@ static int prof_cpu_mask_read_proc(char 
 static int prof_cpu_mask_read_proc(char *page, char **start, off_t off,
 			int count, int *eof, void *data)
 {
-	int len = cpumask_scnprintf(page, count, *(cpumask_t *)data);
+	int len = cpumask_scnprintf(page, count, (cpumask_t *)data);
 	if (count - len < 2)
 		return -EINVAL;
 	len += sprintf(page + len, "\n");
@@ -456,7 +456,7 @@ static int prof_cpu_mask_write_proc(stru
 	unsigned long full_count = count, err;
 	cpumask_t new_value;
 
-	err = cpumask_parse_user(buffer, count, new_value);
+	err = cpumask_parse_user(buffer, count, &new_value);
 	if (err)
 		return err;
 
diff -r 6c44aeb88161 kernel/sched.c
--- a/kernel/sched.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/kernel/sched.c	Fri Nov 07 10:23:40 2008 +1100
@@ -6650,7 +6650,7 @@ static int sched_domain_debug_one(struct
 	struct sched_group *group = sd->groups;
 	char str[256];
 
-	cpulist_scnprintf(str, sizeof(str), sd->span);
+	cpulist_scnprintf(str, sizeof(str), &sd->span);
 	cpus_clear(*groupmask);
 
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
@@ -6704,7 +6704,7 @@ static int sched_domain_debug_one(struct
 
 		cpus_or(*groupmask, *groupmask, group->cpumask);
 
-		cpulist_scnprintf(str, sizeof(str), group->cpumask);
+		cpulist_scnprintf(str, sizeof(str), &group->cpumask);
 		printk(KERN_CONT " %s", str);
 
 		group = group->next;
diff -r 6c44aeb88161 kernel/sched_stats.h
--- a/kernel/sched_stats.h	Fri Nov 07 10:23:17 2008 +1100
+++ b/kernel/sched_stats.h	Fri Nov 07 10:23:40 2008 +1100
@@ -42,7 +42,7 @@ static int show_schedstat(struct seq_fil
 		for_each_domain(cpu, sd) {
 			enum cpu_idle_type itype;
 
-			cpumask_scnprintf(mask_str, mask_len, sd->span);
+			cpumask_scnprintf(mask_str, mask_len, &sd->span);
 			seq_printf(seq, "domain%d %s", dcount++, mask_str);
 			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
 					itype++) {
diff -r 6c44aeb88161 kernel/taskstats.c
--- a/kernel/taskstats.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/kernel/taskstats.c	Fri Nov 07 10:23:40 2008 +1100
@@ -352,7 +352,7 @@ static int parse(struct nlattr *na, cpum
 	if (!data)
 		return -ENOMEM;
 	nla_strlcpy(data, na, len);
-	ret = cpulist_parse(data, *mask);
+	ret = cpulist_parse(data, mask);
 	kfree(data);
 	return ret;
 }
diff -r 6c44aeb88161 kernel/trace/trace.c
--- a/kernel/trace/trace.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/kernel/trace/trace.c	Fri Nov 07 10:23:40 2008 +1100
@@ -2125,7 +2125,7 @@ tracing_cpumask_read(struct file *filp, 
 
 	mutex_lock(&tracing_cpumask_update_lock);
 
-	len = cpumask_scnprintf(mask_str, count, tracing_cpumask);
+	len = cpumask_scnprintf(mask_str, count, &tracing_cpumask);
 	if (count - len < 2) {
 		count = -EINVAL;
 		goto out_err;
@@ -2146,7 +2146,7 @@ tracing_cpumask_write(struct file *filp,
 	int err, cpu;
 
 	mutex_lock(&tracing_cpumask_update_lock);
-	err = cpumask_parse_user(ubuf, count, tracing_cpumask_new);
+	err = cpumask_parse_user(ubuf, count, &tracing_cpumask_new);
 	if (err)
 		goto err_unlock;
 
diff -r 6c44aeb88161 mm/slub.c
--- a/mm/slub.c	Fri Nov 07 10:23:17 2008 +1100
+++ b/mm/slub.c	Fri Nov 07 10:23:40 2008 +1100
@@ -3624,7 +3624,7 @@ static int list_locations(struct kmem_ca
 				len < PAGE_SIZE - 60) {
 			len += sprintf(buf + len, " cpus=");
 			len += cpulist_scnprintf(buf + len, PAGE_SIZE - len - 50,
-					l->cpus);
+					&l->cpus);
 		}
 
 		if (num_online_nodes() > 1 && !nodes_empty(l->nodes) &&


