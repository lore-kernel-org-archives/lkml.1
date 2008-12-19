Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYLSGql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYLSGql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 01:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYLSGqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 01:46:32 -0500
Received: from ozlabs.org ([203.10.76.45]:53324 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYLSGqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 01:46:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 3/3] cpumask: add sysfs displays for configured and disabled cpu maps
Date: Fri, 19 Dec 2008 17:16:25 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@redhat.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
References: <20081216042645.629941000@polaris-admin.engr.sgi.com> <20081216042646.088194000@polaris-admin.engr.sgi.com>
In-Reply-To: <20081216042646.088194000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812191716.25868.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 December 2008 14:56:48 Mike Travis wrote:
> Impact: add new functionality.
> 
> Add sysfs files "kernel_max" and "offline" to display the max CPU index
> allowed (NR_CPUS-1), and the map of cpus that are offline. 

OK, I removed the x86 part and applied this with the following fix.

Greg Acked the documentation patch, so I'll assume he had no problem
with this patch either (appended below in case he wanted to re-review).

Cheers,
Rusty.

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -148,12 +148,11 @@ static ssize_t print_cpus_offline(struct
 
 	/* display offline cpus < nr_cpu_ids */
 	if (!alloc_cpumask_var(&offline, GFP_KERNEL))
-		goto next;
+		return -ENOMEM;
 	cpumask_complement(offline, cpu_online_mask);
 	n = cpulist_scnprintf(buf, len, offline);
 	free_cpumask_var(offline);
 
-next:
 	/* display offline cpus >= nr_cpu_ids */
 	if (total_cpus && nr_cpu_ids < total_cpus) {
 		if (n && n < len)

Subject: cpumask: add sysfs displays for configured and disabled cpu maps
Date: Mon, 15 Dec 2008 20:26:48 -0800
From: Mike Travis <travis@sgi.com>

Impact: add new sysfs files.

Add sysfs files "kernel_max" and "offline" to display the max CPU index
allowed (NR_CPUS-1), and the map of cpus that are offline. 

Cpus can be offlined via HOTPLUG, disabled by the BIOS ACPI tables, or
if they exceed the number of cpus allowed by the NR_CPUS config option,
or the "maxcpus=NUM" kernel start parameter.

The "possible_cpus=NUM" parameter can also extend the number of possible
cpus allowed, in which case the cpus not present at startup will be
in the offline state.  (These cpus can be HOTPLUGGED ON after system
startup [pending a follow-on patch to provide the capability via the
/sys/devices/sys/cpu/cpuN/online mechanism to bring them online.])

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

Based on tip/cpus4096 + .../rusty/linux-2.6-for-ingo.git/master +
	 x86-only-patches sent 12/15.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/smpboot.c |    2 ++
 drivers/base/cpu.c        |   45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/smp.h       |    3 +++
 3 files changed, 50 insertions(+)

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

