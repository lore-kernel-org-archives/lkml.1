Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbYLKL24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbYLKL24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 06:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYLKL2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 06:28:17 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54786 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755048AbYLKL2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 06:28:11 -0500
Message-Id: <20081211112807.139220000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 11 Dec 2008 03:28:10 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] cpumask: add sysfs displays for configured and disabled cpu maps
References: <20081211112806.499831000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=cpumask:add-sysfs-files.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add new functionality.

Add sysfs files "kernel_max" and "offline" to display the max CPU index
allowed (NR_CPUS-1), and the map of cpus that are offline. 

Cpus can be offlined via HOTPLUG, disabled by the BIOS ACPI tables, or
if they exceed the number of cpus allowed by the NR_CPUS config option,
or the "maxcpus=NUM" kernel start parameter.  The "maxcpus=NUM" parameter
can also extend the number of possible cpus allowed, in which case the
cpus not present at startup will be in the offline state.  (These cpus
can be HOTPLUGGED ON after system startup [pending a follow-on patch
to provide the capability via the /sys/devices/sys/cpu/cpuN/online
mechanism to bring them online.])

By design, the "offlined cpus > possible cpus" display will always
use the following formats:

  * all possible cpus online:   "x$"    or "x-y$" 
  * some possible cpus offline: ".*,x$" or ".*,x-y$"

where:
  x == number of possible cpus (nr_cpu_ids); and
  y == number of cpus >= NR_CPUS or maxcpus (if y > x).

One use of this feature is for distros to select (or configure) the
appropriate kernel to install for the resident system.

Notes:
  * cpus offlined <= possible cpus will be printed for all architectures.
  * cpus offlined >  possible cpus will only be printed for arches that
  	set 'total_cpus' [X86 only in this patch].

Based on:
  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
+ git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git/cpus4096
+ git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-ingo.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/smpboot.c |    2 ++
 drivers/base/cpu.c        |   45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/smp.h       |    3 +++
 3 files changed, 50 insertions(+)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6-for-ingo/arch/x86/kernel/smpboot.c
@@ -1286,6 +1286,8 @@ __init void prefill_possible_map(void)
 	else				/* user specified */
 		possible = setup_max_cpus;
 
+	total_cpus = max_t(int, possible, num_processors + disabled_cpus);
+
 	if (possible > CONFIG_NR_CPUS) {
 		printk(KERN_WARNING
 			"%d Processors exceeds NR_CPUS limit of %d\n",
--- linux-2.6-for-ingo.orig/drivers/base/cpu.c
+++ linux-2.6-for-ingo/drivers/base/cpu.c
@@ -128,10 +128,55 @@ print_cpus_func(online);
 print_cpus_func(possible);
 print_cpus_func(present);
 
+/*
+ * Print values for NR_CPUS and offlined cpus
+ */
+static ssize_t print_cpus_kernel_max(struct sysdev_class *class, char *buf)
+{
+	int n = snprintf(buf, PAGE_SIZE-2, "%d\n", CONFIG_NR_CPUS - 1);
+	return n;
+}
+static SYSDEV_CLASS_ATTR(kernel_max, 0444, print_cpus_kernel_max, NULL);
+
+/* arch-optional setting to enable display of offline cpus >= nr_cpu_ids */
+unsigned int total_cpus;
+
+static ssize_t print_cpus_offline(struct sysdev_class *class, char *buf)
+{
+	int n = 0, len = PAGE_SIZE-2;
+	cpumask_var_t offline;
+
+	/* display offline cpus < nr_cpu_ids */
+	if (!alloc_cpumask_var(&offline, GFP_KERNEL))
+		goto next;
+	cpumask_complement(offline, cpu_online_mask);
+	n = cpulist_scnprintf(buf, len, offline);
+	free_cpumask_var(offline);
+
+next:
+	/* display offline cpus >= nr_cpu_ids */
+	if (total_cpus && nr_cpu_ids < total_cpus) {
+		if (n && n < len)
+			buf[n++] = ',';
+
+		if (nr_cpu_ids == total_cpus-1)
+			n += snprintf(&buf[n], len - n, "%d", nr_cpu_ids);
+		else
+			n += snprintf(&buf[n], len - n, "%d-%d",
+						      nr_cpu_ids, total_cpus-1);
+	}
+
+	n += snprintf(&buf[n], len - n, "\n");
+	return n;
+}
+static SYSDEV_CLASS_ATTR(offline, 0444, print_cpus_offline, NULL);
+
 static struct sysdev_class_attribute *cpu_state_attr[] = {
 	&attr_online_map,
 	&attr_possible_map,
 	&attr_present_map,
+	&attr_kernel_max,
+	&attr_offline,
 };
 
 static int cpu_states_init(void)
--- linux-2.6-for-ingo.orig/include/linux/smp.h
+++ linux-2.6-for-ingo/include/linux/smp.h
@@ -21,6 +21,9 @@ struct call_single_data {
 	u16 priv;
 };
 
+/* total number of cpus in this system (may exceed NR_CPUS) */
+extern unsigned int total_cpus;
+
 #ifdef CONFIG_SMP
 
 #include <linux/preempt.h>

