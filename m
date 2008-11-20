Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbYKTI3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbYKTI3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 03:29:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYKTI2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 03:28:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47345 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbYKTI2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:28:50 -0500
Date: Thu, 20 Nov 2008 09:27:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       paulus@samba.org, mingo@redhat.com, tony.luck@intel.com,
       ralf@linux-mips.org, Greg Kroah-Hartman <gregkh@suse.de>,
       cl@linux-foundation.org, srostedt@redhat.com
Subject: Re: [PATCH 2/2] cpumask: change cpumask_scnprintf,
	cpumask_parse_user, cpulist_parse, and cpulist_scnprintf to take
	pointers.
Message-ID: <20081120082759.GG21785@elte.hu>
References: <200811200108.10789.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811200108.10789.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> (Linux-next again, but simple conversion...)
> 
> Most cpumask functions started with cpus_: these have been replaced by
> cpumask_ ones which take struct cpumask pointers as expected.
> 
> These four functions don't have good replacement names; fortunately
> they're rarely used, so we just change them over.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Cc: paulus@samba.org
> Cc: mingo@redhat.com
> Cc: tony.luck@intel.com
> Cc: ralf@linux-mips.org
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: cl@linux-foundation.org
> Cc: srostedt@redhat.com

Sigh, you've lost the acked-by/signoff lines and the impact-lines as 
well.

  Acked-by: Ingo Molnar <mingo@elte.hu>

find below how the commit looked like at a certain point. Yes, i know 
the APIs changed somewhat.

	Ingo

------------->
>From 549ce94d9dcd49001258842c147e2214a3bda676 Mon Sep 17 00:00:00 2001
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 22 Oct 2008 19:08:33 -0700
Subject: [PATCH] cpumask: change cpumask/list_scnprintf(), cpumask/list_parse() APIs to take pointers

Impact: change calling convention of existing cpumask APIs

We want to move cpumasks off the stack: no local decls, no passing by
copy.

Most cpumask functions started with cpus_: these have been replaced by
cpumask_ ones which take struct cpumask pointers as expected, and macro
stubs used for the transition.

These four functions don't have good replacement names; fortunately
they're rarely used, so we just change them over.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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

diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
index 26228e2..58db6ae 100644
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -217,7 +217,7 @@ static ssize_t show_shared_cpu_map(struct cache_info *this_leaf, char *buf)
 	cpumask_t shared_cpu_map;
 
 	cpus_and(shared_cpu_map, this_leaf->shared_cpu_map, cpu_online_map);
-	len = cpumask_scnprintf(buf, NR_CPUS+1, shared_cpu_map);
+	len = cpumask_scnprintf(buf, NR_CPUS+1, &shared_cpu_map);
 	len += sprintf(buf+len, "\n");
 	return len;
 }
diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
index 6789c1a..f27beca 100644
--- a/arch/mips/kernel/smp-cmp.c
+++ b/arch/mips/kernel/smp-cmp.c
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
diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index e190477..64d2431 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -358,7 +358,7 @@ static void xics_set_affinity(unsigned int virq, cpumask_t cpumask)
 	irq_server = get_irq_server(virq, 1);
 	if (irq_server == -1) {
 		char cpulist[128];
-		cpumask_scnprintf(cpulist, sizeof(cpulist), cpumask);
+		cpumask_scnprintf(cpulist, sizeof(cpulist), &cpumask);
 		printk(KERN_WARNING
 			"%s: No online cpus in the mask %s for irq %d\n",
 			__func__, cpulist, virq);
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 3f46afb..43ea612 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -626,8 +626,8 @@ static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
 		cpumask_t *mask = &this_leaf->shared_cpu_map;
 
 		n = type?
-			cpulist_scnprintf(buf, len-2, *mask):
-			cpumask_scnprintf(buf, len-2, *mask);
+			cpulist_scnprintf(buf, len-2, mask) :
+			cpumask_scnprintf(buf, len-2, mask);
 		buf[n++] = '\n';
 		buf[n] = '\0';
 	}
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 410c88f..40969f8 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -282,7 +282,7 @@ static void __cpuinit numa_set_cpumask(int cpu, int enable)
 	else
 		cpu_clear(cpu, *mask);
 
-	cpulist_scnprintf(buf, sizeof(buf), *mask);
+	cpulist_scnprintf(buf, sizeof(buf), mask);
 	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
 		enable? "numa_add_cpu":"numa_remove_cpu", cpu, node, buf);
  }
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 64f5d54..4259072 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -109,7 +109,7 @@ static SYSDEV_ATTR(crash_notes, 0400, show_crash_notes, NULL);
  */
 static ssize_t print_cpus_map(char *buf, cpumask_t *map)
 {
-	int n = cpulist_scnprintf(buf, PAGE_SIZE-2, *map);
+	int n = cpulist_scnprintf(buf, PAGE_SIZE-2, map);
 
 	buf[n++] = '\n';
 	buf[n] = '\0';
diff --git a/drivers/base/node.c b/drivers/base/node.c
index f520709..91636cd 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -30,8 +30,8 @@ static ssize_t node_read_cpumap(struct sys_device *dev, int type, char *buf)
 	BUILD_BUG_ON((NR_CPUS/32 * 9) > (PAGE_SIZE-1));
 
 	len = type?
-		cpulist_scnprintf(buf, PAGE_SIZE-2, *mask):
-		cpumask_scnprintf(buf, PAGE_SIZE-2, *mask);
+		cpulist_scnprintf(buf, PAGE_SIZE-2, mask) :
+		cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
  	buf[len++] = '\n';
  	buf[len] = '\0';
 	return len;
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index 199cd97..a8bc1cb 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -49,8 +49,8 @@ static ssize_t show_cpumap(int type, cpumask_t *mask, char *buf)
 
 	if (len > 1) {
 		n = type?
-			cpulist_scnprintf(buf, len-2, *mask):
-			cpumask_scnprintf(buf, len-2, *mask);
+			cpulist_scnprintf(buf, len-2, mask) :
+			cpumask_scnprintf(buf, len-2, mask);
 		buf[n++] = '\n';
 		buf[n] = '\0';
 	}
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 110022d..0f7a291 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -74,7 +74,7 @@ static ssize_t local_cpus_show(struct device *dev,
 	int len;
 
 	mask = pcibus_to_cpumask(to_pci_dev(dev)->bus);
-	len = cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
+	len = cpumask_scnprintf(buf, PAGE_SIZE-2, &mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
 	return len;
@@ -88,7 +88,7 @@ static ssize_t local_cpulist_show(struct device *dev,
 	int len;
 
 	mask = pcibus_to_cpumask(to_pci_dev(dev)->bus);
-	len = cpulist_scnprintf(buf, PAGE_SIZE-2, mask);
+	len = cpulist_scnprintf(buf, PAGE_SIZE-2, &mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
 	return len;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index aaaf0a1..65404bb 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -55,8 +55,8 @@ static ssize_t pci_bus_show_cpuaffinity(struct device *dev,
 
 	cpumask = pcibus_to_cpumask(to_pci_bus(dev));
 	ret = type?
-		cpulist_scnprintf(buf, PAGE_SIZE-2, cpumask):
-		cpumask_scnprintf(buf, PAGE_SIZE-2, cpumask);
+		cpulist_scnprintf(buf, PAGE_SIZE-2, &cpumask) :
+		cpumask_scnprintf(buf, PAGE_SIZE-2, &cpumask);
 	buf[ret++] = '\n';
 	buf[ret] = '\0';
 	return ret;
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 6e624d1..9f5d5ed 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
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
@@ -303,25 +296,25 @@ static inline void cpumask_shift_left(struct cpumask *dstp,
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
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3e00526..13422a3 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -891,7 +891,7 @@ static int update_cpumask(struct cpuset *cs, const char *buf)
 	if (!*buf) {
 		cpus_clear(trialcs.cpus_allowed);
 	} else {
-		retval = cpulist_parse(buf, trialcs.cpus_allowed);
+		retval = cpulist_parse(buf, &trialcs.cpus_allowed);
 		if (retval < 0)
 			return retval;
 
@@ -1477,7 +1477,7 @@ static int cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
 	mask = cs->cpus_allowed;
 	mutex_unlock(&callback_mutex);
 
-	return cpulist_scnprintf(page, PAGE_SIZE, mask);
+	return cpulist_scnprintf(page, PAGE_SIZE, &mask);
 }
 
 static int cpuset_sprintf_memlist(char *page, struct cpuset *cs)
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index fac014a..8df0448 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -47,7 +47,7 @@ static ssize_t irq_affinity_proc_write(struct file *file,
 	    irq_balancing_disabled(irq))
 		return -EIO;
 
-	err = cpumask_parse_user(buffer, count, new_value);
+	err = cpumask_parse_user(buffer, count, &new_value);
 	if (err)
 		return err;
 
@@ -95,7 +95,7 @@ static ssize_t default_affinity_write(struct file *file,
 	cpumask_t new_value;
 	int err;
 
-	err = cpumask_parse_user(buffer, count, new_value);
+	err = cpumask_parse_user(buffer, count, &new_value);
 	if (err)
 		return err;
 
diff --git a/kernel/profile.c b/kernel/profile.c
index a9e422d..c900ff3 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -442,7 +442,7 @@ void profile_tick(int type)
 static int prof_cpu_mask_read_proc(char *page, char **start, off_t off,
 			int count, int *eof, void *data)
 {
-	int len = cpumask_scnprintf(page, count, *(cpumask_t *)data);
+	int len = cpumask_scnprintf(page, count, (cpumask_t *)data);
 	if (count - len < 2)
 		return -EINVAL;
 	len += sprintf(page + len, "\n");
@@ -456,7 +456,7 @@ static int prof_cpu_mask_write_proc(struct file *file,
 	unsigned long full_count = count, err;
 	cpumask_t new_value;
 
-	err = cpumask_parse_user(buffer, count, new_value);
+	err = cpumask_parse_user(buffer, count, &new_value);
 	if (err)
 		return err;
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 269d6f2..2af03e4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6651,7 +6651,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 	struct sched_group *group = sd->groups;
 	char str[256];
 
-	cpulist_scnprintf(str, sizeof(str), sd->span);
+	cpulist_scnprintf(str, sizeof(str), &sd->span);
 	cpus_clear(*groupmask);
 
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
@@ -6705,7 +6705,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 
 		cpus_or(*groupmask, *groupmask, group->cpumask);
 
-		cpulist_scnprintf(str, sizeof(str), group->cpumask);
+		cpulist_scnprintf(str, sizeof(str), &group->cpumask);
 		printk(KERN_CONT " %s", str);
 
 		group = group->next;
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index b8c1569..4e0e2c0 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -42,7 +42,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
 		for_each_domain(cpu, sd) {
 			enum cpu_idle_type itype;
 
-			cpumask_scnprintf(mask_str, mask_len, sd->span);
+			cpumask_scnprintf(mask_str, mask_len, &sd->span);
 			seq_printf(seq, "domain%d %s", dcount++, mask_str);
 			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
 					itype++) {
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index bd6be76..6d7dc4e 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -352,7 +352,7 @@ static int parse(struct nlattr *na, cpumask_t *mask)
 	if (!data)
 		return -ENOMEM;
 	nla_strlcpy(data, na, len);
-	ret = cpulist_parse(data, *mask);
+	ret = cpulist_parse(data, mask);
 	kfree(data);
 	return ret;
 }
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d345d64..b9e777b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2117,7 +2117,7 @@ tracing_cpumask_read(struct file *filp, char __user *ubuf,
 
 	mutex_lock(&tracing_cpumask_update_lock);
 
-	len = cpumask_scnprintf(mask_str, count, tracing_cpumask);
+	len = cpumask_scnprintf(mask_str, count, &tracing_cpumask);
 	if (count - len < 2) {
 		count = -EINVAL;
 		goto out_err;
@@ -2138,7 +2138,7 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 	int err, cpu;
 
 	mutex_lock(&tracing_cpumask_update_lock);
-	err = cpumask_parse_user(ubuf, count, tracing_cpumask_new);
+	err = cpumask_parse_user(ubuf, count, &tracing_cpumask_new);
 	if (err)
 		goto err_unlock;
 
diff --git a/mm/slub.c b/mm/slub.c
index 0c83e6a..3e4e6e5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3623,7 +3623,7 @@ static int list_locations(struct kmem_cache *s, char *buf,
 				len < PAGE_SIZE - 60) {
 			len += sprintf(buf + len, " cpus=");
 			len += cpulist_scnprintf(buf + len, PAGE_SIZE - len - 50,
-					l->cpus);
+					&l->cpus);
 		}
 
 		if (num_online_nodes() > 1 && !nodes_empty(l->nodes) &&
