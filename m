Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbYBTSmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbYBTSmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYBTSly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:41:54 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:6760 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbYBTSlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:41:53 -0500
Message-ID: <47BC746F.2000608@ct.jp.nec.com>
Date: Wed, 20 Feb 2008 10:41:51 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] x86_64: split cpuinfo from setup_64.c into cpu/proc_64.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

x86 /proc/cpuinfo code can be unified.
This is the first step of unification.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/cpu/Makefile  |    1 +
 arch/x86/kernel/cpu/proc_64.c |  126 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup_64.c    |  120 ---------------------------------------
 3 files changed, 127 insertions(+), 120 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/proc_64.c

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index a0c4d7c..8ba7d28 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_X86_32)	+= transmeta.o
 obj-$(CONFIG_X86_32)	+= intel.o
 obj-$(CONFIG_X86_32)	+= nexgen.o
 obj-$(CONFIG_X86_32)	+= umc.o
+obj-$(CONFIG_X86_64)	+= proc_64.o
 
 obj-$(CONFIG_X86_MCE)	+= mcheck/
 obj-$(CONFIG_MTRR)	+= mtrr/
diff --git a/arch/x86/kernel/cpu/proc_64.c b/arch/x86/kernel/cpu/proc_64.c
new file mode 100644
index 0000000..bf4a94b
--- /dev/null
+++ b/arch/x86/kernel/cpu/proc_64.c
@@ -0,0 +1,126 @@
+#include <linux/smp.h>
+#include <linux/timex.h>
+#include <linux/string.h>
+#include <asm/semaphore.h>
+#include <linux/seq_file.h>
+#include <linux/cpufreq.h>
+
+/*
+ *	Get CPU information for use by the procfs.
+ */
+
+static int show_cpuinfo(struct seq_file *m, void *v)
+{
+	struct cpuinfo_x86 *c = v;
+	int cpu = 0, i;
+
+#ifdef CONFIG_SMP
+	cpu = c->cpu_index;
+#endif
+
+	seq_printf(m, "processor\t: %u\n"
+		   "vendor_id\t: %s\n"
+		   "cpu family\t: %d\n"
+		   "model\t\t: %d\n"
+		   "model name\t: %s\n",
+		   (unsigned)cpu,
+		   c->x86_vendor_id[0] ? c->x86_vendor_id : "unknown",
+		   c->x86,
+		   (int)c->x86_model,
+		   c->x86_model_id[0] ? c->x86_model_id : "unknown");
+
+	if (c->x86_mask || c->cpuid_level >= 0)
+		seq_printf(m, "stepping\t: %d\n", c->x86_mask);
+	else
+		seq_printf(m, "stepping\t: unknown\n");
+
+	if (cpu_has(c, X86_FEATURE_TSC)) {
+		unsigned int freq = cpufreq_quick_get((unsigned)cpu);
+
+		if (!freq)
+			freq = cpu_khz;
+		seq_printf(m, "cpu MHz\t\t: %u.%03u\n",
+			   freq / 1000, (freq % 1000));
+	}
+
+	/* Cache size */
+	if (c->x86_cache_size >= 0)
+		seq_printf(m, "cache size\t: %d KB\n", c->x86_cache_size);
+
+#ifdef CONFIG_SMP
+	if (smp_num_siblings * c->x86_max_cores > 1) {
+		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
+		seq_printf(m, "siblings\t: %d\n",
+			       cpus_weight(per_cpu(cpu_core_map, cpu)));
+		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
+		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
+	}
+#endif
+
+	seq_printf(m,
+		   "fpu\t\t: yes\n"
+		   "fpu_exception\t: yes\n"
+		   "cpuid level\t: %d\n"
+		   "wp\t\t: yes\n"
+		   "flags\t\t:",
+		   c->cpuid_level);
+
+	for (i = 0; i < 32*NCAPINTS; i++)
+		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
+			seq_printf(m, " %s", x86_cap_flags[i]);
+
+	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
+		   c->loops_per_jiffy/(500000/HZ),
+		   (c->loops_per_jiffy/(5000/HZ)) % 100);
+
+	if (c->x86_tlbsize > 0)
+		seq_printf(m, "TLB size\t: %d 4K pages\n", c->x86_tlbsize);
+	seq_printf(m, "clflush size\t: %d\n", c->x86_clflush_size);
+	seq_printf(m, "cache_alignment\t: %d\n", c->x86_cache_alignment);
+
+	seq_printf(m, "address sizes\t: %u bits physical, %u bits virtual\n",
+		   c->x86_phys_bits, c->x86_virt_bits);
+
+	seq_printf(m, "power management:");
+	for (i = 0; i < 32; i++) {
+		if (c->x86_power & (1 << i)) {
+			if (i < ARRAY_SIZE(x86_power_flags) &&
+			    x86_power_flags[i])
+				seq_printf(m, "%s%s",
+					   x86_power_flags[i][0]?" ":"",
+					   x86_power_flags[i]);
+			else
+				seq_printf(m, " [%d]", i);
+		}
+	}
+
+	seq_printf(m, "\n\n");
+
+	return 0;
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	if (*pos == 0)	/* just in case, cpu 0 is not the first */
+		*pos = first_cpu(cpu_online_map);
+	if ((*pos) < NR_CPUS && cpu_online(*pos))
+		return &cpu_data(*pos);
+	return NULL;
+}
+
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	*pos = next_cpu(*pos, cpu_online_map);
+	return c_start(m, pos);
+}
+
+static void c_stop(struct seq_file *m, void *v)
+{
+}
+
+const struct seq_operations cpuinfo_op = {
+	.start = c_start,
+	.next =	c_next,
+	.stop =	c_stop,
+	.show =	show_cpuinfo,
+};
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 6fd804f..668508d 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -1064,123 +1064,3 @@ static __init int setup_disablecpuid(char *arg)
 	return 1;
 }
 __setup("clearcpuid=", setup_disablecpuid);
-
-/*
- *	Get CPU information for use by the procfs.
- */
-
-static int show_cpuinfo(struct seq_file *m, void *v)
-{
-	struct cpuinfo_x86 *c = v;
-	int cpu = 0, i;
-
-#ifdef CONFIG_SMP
-	cpu = c->cpu_index;
-#endif
-
-	seq_printf(m, "processor\t: %u\n"
-		   "vendor_id\t: %s\n"
-		   "cpu family\t: %d\n"
-		   "model\t\t: %d\n"
-		   "model name\t: %s\n",
-		   (unsigned)cpu,
-		   c->x86_vendor_id[0] ? c->x86_vendor_id : "unknown",
-		   c->x86,
-		   (int)c->x86_model,
-		   c->x86_model_id[0] ? c->x86_model_id : "unknown");
-
-	if (c->x86_mask || c->cpuid_level >= 0)
-		seq_printf(m, "stepping\t: %d\n", c->x86_mask);
-	else
-		seq_printf(m, "stepping\t: unknown\n");
-
-	if (cpu_has(c, X86_FEATURE_TSC)) {
-		unsigned int freq = cpufreq_quick_get((unsigned)cpu);
-
-		if (!freq)
-			freq = cpu_khz;
-		seq_printf(m, "cpu MHz\t\t: %u.%03u\n",
-			   freq / 1000, (freq % 1000));
-	}
-
-	/* Cache size */
-	if (c->x86_cache_size >= 0)
-		seq_printf(m, "cache size\t: %d KB\n", c->x86_cache_size);
-
-#ifdef CONFIG_SMP
-	if (smp_num_siblings * c->x86_max_cores > 1) {
-		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
-		seq_printf(m, "siblings\t: %d\n",
-			       cpus_weight(per_cpu(cpu_core_map, cpu)));
-		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
-		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
-	}
-#endif
-
-	seq_printf(m,
-		   "fpu\t\t: yes\n"
-		   "fpu_exception\t: yes\n"
-		   "cpuid level\t: %d\n"
-		   "wp\t\t: yes\n"
-		   "flags\t\t:",
-		   c->cpuid_level);
-
-	for (i = 0; i < 32*NCAPINTS; i++)
-		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
-			seq_printf(m, " %s", x86_cap_flags[i]);
-
-	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
-		   c->loops_per_jiffy/(500000/HZ),
-		   (c->loops_per_jiffy/(5000/HZ)) % 100);
-
-	if (c->x86_tlbsize > 0)
-		seq_printf(m, "TLB size\t: %d 4K pages\n", c->x86_tlbsize);
-	seq_printf(m, "clflush size\t: %d\n", c->x86_clflush_size);
-	seq_printf(m, "cache_alignment\t: %d\n", c->x86_cache_alignment);
-
-	seq_printf(m, "address sizes\t: %u bits physical, %u bits virtual\n",
-		   c->x86_phys_bits, c->x86_virt_bits);
-
-	seq_printf(m, "power management:");
-	for (i = 0; i < 32; i++) {
-		if (c->x86_power & (1 << i)) {
-			if (i < ARRAY_SIZE(x86_power_flags) &&
-			    x86_power_flags[i])
-				seq_printf(m, "%s%s",
-					   x86_power_flags[i][0]?" ":"",
-					   x86_power_flags[i]);
-			else
-				seq_printf(m, " [%d]", i);
-		}
-	}
-
-	seq_printf(m, "\n\n");
-
-	return 0;
-}
-
-static void *c_start(struct seq_file *m, loff_t *pos)
-{
-	if (*pos == 0)	/* just in case, cpu 0 is not the first */
-		*pos = first_cpu(cpu_online_map);
-	if ((*pos) < NR_CPUS && cpu_online(*pos))
-		return &cpu_data(*pos);
-	return NULL;
-}
-
-static void *c_next(struct seq_file *m, void *v, loff_t *pos)
-{
-	*pos = next_cpu(*pos, cpu_online_map);
-	return c_start(m, pos);
-}
-
-static void c_stop(struct seq_file *m, void *v)
-{
-}
-
-const struct seq_operations cpuinfo_op = {
-	.start = c_start,
-	.next =	c_next,
-	.stop =	c_stop,
-	.show =	show_cpuinfo,
-};
-- 
1.5.3.8

