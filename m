Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbYJWCLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbYJWCLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbYJWCIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:36 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46593 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753215AbYJWCI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:28 -0400
Message-Id: <20081023020827.718858000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:33 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/35] cpumask: change cpumask/list_scnprintf, cpumask/list_parse to take pointers. From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:convert-few-difficult-cpumask_t-users.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to move cpumasks off the stack: no local decls, no passing by
copy.

Most cpumask functions started with cpus_: these have been replaced by
cpumask_ ones which take struct cpumask pointers as expected, and macro
stubs used for the transition.

These four functions don't have good replacement names; fortunately
they're rarely used, so we just change them over.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/ia64/kernel/topology.c           |    2 +-
 arch/mips/kernel/smp-cmp.c            |    4 ++--
 arch/powerpc/platforms/pseries/xics.c |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c |    4 ++--
 arch/x86/kernel/setup_percpu.c        |    2 +-
 drivers/base/cpu.c                    |    2 +-
 drivers/base/node.c                   |    4 ++--
 drivers/base/topology.c               |    4 ++--
 drivers/pci/pci-sysfs.c               |    4 ++--
 drivers/pci/probe.c                   |    4 ++--
 include/linux/cpumask.h               |   21 +++++++--------------
 kernel/cpuset.c                       |    4 ++--
 kernel/irq/proc.c                     |    4 ++--
 kernel/profile.c                      |    4 ++--
 kernel/sched.c                        |    4 ++--
 kernel/sched_stats.h                  |    2 +-
 kernel/taskstats.c                    |    2 +-
 kernel/trace/trace.c                  |    4 ++--
 mm/slub.c                             |    2 +-
 19 files changed, 36 insertions(+), 43 deletions(-)

--- linux-2.6.28.orig/arch/ia64/kernel/topology.c
+++ linux-2.6.28/arch/ia64/kernel/topology.c
@@ -217,7 +217,7 @@ static ssize_t show_shared_cpu_map(struc
 	cpumask_t shared_cpu_map;
 
 	cpus_and(shared_cpu_map, this_leaf->shared_cpu_map, cpu_online_map);
-	len = cpumask_scnprintf(buf, NR_CPUS+1, shared_cpu_map);
+	len = cpumask_scnprintf(buf, NR_CPUS+1, &shared_cpu_map);
 	len += sprintf(buf+len, "\n");
 	return len;
 }
--- linux-2.6.28.orig/arch/mips/kernel/smp-cmp.c
+++ linux-2.6.28/arch/mips/kernel/smp-cmp.c
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
--- linux-2.6.28.orig/arch/powerpc/platforms/pseries/xics.c
+++ linux-2.6.28/arch/powerpc/platforms/pseries/xics.c
@@ -358,7 +358,7 @@ static void xics_set_affinity(unsigned i
 	irq_server = get_irq_server(virq, 1);
 	if (irq_server == -1) {
 		char cpulist[128];
-		cpumask_scnprintf(cpulist, sizeof(cpulist), cpumask);
+		cpumask_scnprintf(cpulist, sizeof(cpulist), &cpumask);
 		printk(KERN_WARNING
 			"%s: No online cpus in the mask %s for irq %d\n",
 			__func__, cpulist, virq);
--- linux-2.6.28.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ linux-2.6.28/arch/x86/kernel/cpu/intel_cacheinfo.c
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
--- linux-2.6.28.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6.28/arch/x86/kernel/setup_percpu.c
@@ -282,7 +282,7 @@ static void __cpuinit numa_set_cpumask(i
 	else
 		cpu_clear(cpu, *mask);
 
-	cpulist_scnprintf(buf, sizeof(buf), *mask);
+	cpulist_scnprintf(buf, sizeof(buf), mask);
 	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
 		enable? "numa_add_cpu":"numa_remove_cpu", cpu, node, buf);
  }
--- linux-2.6.28.orig/drivers/base/cpu.c
+++ linux-2.6.28/drivers/base/cpu.c
@@ -109,7 +109,7 @@ static SYSDEV_ATTR(crash_notes, 0400, sh
  */
 static ssize_t print_cpus_map(char *buf, cpumask_t *map)
 {
-	int n = cpulist_scnprintf(buf, PAGE_SIZE-2, *map);
+	int n = cpulist_scnprintf(buf, PAGE_SIZE-2, map);
 
 	buf[n++] = '\n';
 	buf[n] = '\0';
--- linux-2.6.28.orig/drivers/base/node.c
+++ linux-2.6.28/drivers/base/node.c
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
--- linux-2.6.28.orig/drivers/base/topology.c
+++ linux-2.6.28/drivers/base/topology.c
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
--- linux-2.6.28.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6.28/drivers/pci/pci-sysfs.c
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
--- linux-2.6.28.orig/drivers/pci/probe.c
+++ linux-2.6.28/drivers/pci/probe.c
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
--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -174,13 +174,6 @@ extern cpumask_t _unused_cpumask_arg_;
 			cpumask_shift_right(&(dst), &(src), (n))
 #define cpus_shift_left(dst, src, n) \
 			cpumask_shift_left(&(dst), &(src), (n))
-#define cpumask_scnprintf(buf, len, src) \
-			__cpumask_scnprintf((buf), (len), &(src))
-#define cpumask_parse_user(ubuf, ulen, dst) \
-			__cpumask_parse_user((ubuf), (ulen), &(dst))
-#define cpulist_scnprintf(buf, len, src) \
-			__cpulist_scnprintf((buf), (len), &(src))
-#define cpulist_parse(buf, dst) __cpulist_parse((buf), &(dst))
 #define cpu_remap(oldbit, old, new) \
 		cpumask_cpuremap((oldbit), &(old), &(new))
 #define cpus_remap(dst, src, old, new) \
@@ -303,25 +296,25 @@ static inline void cpumask_shift_left(st
 	bitmap_shift_left(dstp->bits, srcp->bits, n, NR_CPUS);
 }
 
-static inline int __cpumask_scnprintf(char *buf, int len,
-				      const struct cpumask *srcp)
+static inline int cpumask_scnprintf(char *buf, int len,
+				    const struct cpumask *srcp)
 {
 	return bitmap_scnprintf(buf, len, srcp->bits, NR_CPUS);
 }
 
-static inline int __cpumask_parse_user(const char __user *buf, int len,
-				       struct cpumask *dstp)
+static inline int cpumask_parse_user(const char __user *buf, int len,
+				     struct cpumask *dstp)
 {
 	return bitmap_parse_user(buf, len, dstp->bits, NR_CPUS);
 }
 
-static inline int __cpulist_scnprintf(char *buf, int len,
-				      const struct cpumask *srcp)
+static inline int cpulist_scnprintf(char *buf, int len,
+				    const struct cpumask *srcp)
 {
 	return bitmap_scnlistprintf(buf, len, srcp->bits, NR_CPUS);
 }
 
-static inline int __cpulist_parse(const char *buf, struct cpumask *dstp)
+static inline int cpulist_parse(const char *buf, struct cpumask *dstp)
 {
 	return bitmap_parselist(buf, dstp->bits, NR_CPUS);
 }
--- linux-2.6.28.orig/kernel/cpuset.c
+++ linux-2.6.28/kernel/cpuset.c
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
--- linux-2.6.28.orig/kernel/irq/proc.c
+++ linux-2.6.28/kernel/irq/proc.c
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
 
--- linux-2.6.28.orig/kernel/profile.c
+++ linux-2.6.28/kernel/profile.c
@@ -446,7 +446,7 @@ void profile_tick(int type)
 static int prof_cpu_mask_read_proc(char *page, char **start, off_t off,
 			int count, int *eof, void *data)
 {
-	int len = cpumask_scnprintf(page, count, *(cpumask_t *)data);
+	int len = cpumask_scnprintf(page, count, (cpumask_t *)data);
 	if (count - len < 2)
 		return -EINVAL;
 	len += sprintf(page + len, "\n");
@@ -460,7 +460,7 @@ static int prof_cpu_mask_write_proc(stru
 	unsigned long full_count = count, err;
 	cpumask_t new_value;
 
-	err = cpumask_parse_user(buffer, count, new_value);
+	err = cpumask_parse_user(buffer, count, &new_value);
 	if (err)
 		return err;
 
--- linux-2.6.28.orig/kernel/sched.c
+++ linux-2.6.28/kernel/sched.c
@@ -6646,7 +6646,7 @@ static int sched_domain_debug_one(struct
 	struct sched_group *group = sd->groups;
 	char str[256];
 
-	cpulist_scnprintf(str, sizeof(str), sd->span);
+	cpulist_scnprintf(str, sizeof(str), &sd->span);
 	cpus_clear(*groupmask);
 
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
@@ -6700,7 +6700,7 @@ static int sched_domain_debug_one(struct
 
 		cpus_or(*groupmask, *groupmask, group->cpumask);
 
-		cpulist_scnprintf(str, sizeof(str), group->cpumask);
+		cpulist_scnprintf(str, sizeof(str), &group->cpumask);
 		printk(KERN_CONT " %s", str);
 
 		group = group->next;
--- linux-2.6.28.orig/kernel/sched_stats.h
+++ linux-2.6.28/kernel/sched_stats.h
@@ -42,7 +42,7 @@ static int show_schedstat(struct seq_fil
 		for_each_domain(cpu, sd) {
 			enum cpu_idle_type itype;
 
-			cpumask_scnprintf(mask_str, mask_len, sd->span);
+			cpumask_scnprintf(mask_str, mask_len, &sd->span);
 			seq_printf(seq, "domain%d %s", dcount++, mask_str);
 			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
 					itype++) {
--- linux-2.6.28.orig/kernel/taskstats.c
+++ linux-2.6.28/kernel/taskstats.c
@@ -352,7 +352,7 @@ static int parse(struct nlattr *na, cpum
 	if (!data)
 		return -ENOMEM;
 	nla_strlcpy(data, na, len);
-	ret = cpulist_parse(data, *mask);
+	ret = cpulist_parse(data, mask);
 	kfree(data);
 	return ret;
 }
--- linux-2.6.28.orig/kernel/trace/trace.c
+++ linux-2.6.28/kernel/trace/trace.c
@@ -2117,7 +2117,7 @@ tracing_cpumask_read(struct file *filp, 
 
 	mutex_lock(&tracing_cpumask_update_lock);
 
-	len = cpumask_scnprintf(mask_str, count, tracing_cpumask);
+	len = cpumask_scnprintf(mask_str, count, &tracing_cpumask);
 	if (count - len < 2) {
 		count = -EINVAL;
 		goto out_err;
@@ -2138,7 +2138,7 @@ tracing_cpumask_write(struct file *filp,
 	int err, cpu;
 
 	mutex_lock(&tracing_cpumask_update_lock);
-	err = cpumask_parse_user(ubuf, count, tracing_cpumask_new);
+	err = cpumask_parse_user(ubuf, count, &tracing_cpumask_new);
 	if (err)
 		goto err_unlock;
 
--- linux-2.6.28.orig/mm/slub.c
+++ linux-2.6.28/mm/slub.c
@@ -3637,7 +3637,7 @@ static int list_locations(struct kmem_ca
 				len < PAGE_SIZE - 60) {
 			len += sprintf(buf + len, " cpus=");
 			len += cpulist_scnprintf(buf + len, PAGE_SIZE - len - 50,
-					l->cpus);
+					&l->cpus);
 		}
 
 		if (num_online_nodes() > 1 && !nodes_empty(l->nodes) &&

-- 
