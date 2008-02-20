Return-Path: <linux-kernel-owner+w=401wt.eu-S1765592AbYBTStT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765592AbYBTStT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYBTSs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:48:58 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:11558 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYBTSs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:48:56 -0500
Message-ID: <47BC7617.1020202@ct.jp.nec.com>
Date: Wed, 20 Feb 2008 10:48:55 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] x86: unify cpu/proc|_64.c
References: <47BC746F.2000608@ct.jp.nec.com>
In-Reply-To: <47BC746F.2000608@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Now cpu/proc.c and cpu/proc_64.c are same.
So cpu/proc_64.c can be removed.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/cpu/Makefile  |    5 +-
 arch/x86/kernel/cpu/proc_64.c |  180 -----------------------------------------
 2 files changed, 2 insertions(+), 183 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/proc_64.c

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 8ba7d28..ee7c452 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -3,9 +3,9 @@
 #
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
-obj-y			+= feature_names.o
+obj-y			+= proc.o feature_names.o
 
-obj-$(CONFIG_X86_32)	+= common.o proc.o bugs.o
+obj-$(CONFIG_X86_32)	+= common.o bugs.o
 obj-$(CONFIG_X86_32)	+= amd.o
 obj-$(CONFIG_X86_32)	+= cyrix.o
 obj-$(CONFIG_X86_32)	+= centaur.o
@@ -13,7 +13,6 @@ obj-$(CONFIG_X86_32)	+= transmeta.o
 obj-$(CONFIG_X86_32)	+= intel.o
 obj-$(CONFIG_X86_32)	+= nexgen.o
 obj-$(CONFIG_X86_32)	+= umc.o
-obj-$(CONFIG_X86_64)	+= proc_64.o
 
 obj-$(CONFIG_X86_MCE)	+= mcheck/
 obj-$(CONFIG_MTRR)	+= mtrr/
diff --git a/arch/x86/kernel/cpu/proc_64.c b/arch/x86/kernel/cpu/proc_64.c
deleted file mode 100644
index 15043a3..0000000
--- a/arch/x86/kernel/cpu/proc_64.c
+++ /dev/null
@@ -1,180 +0,0 @@
-#include <linux/smp.h>
-#include <linux/timex.h>
-#include <linux/string.h>
-#include <asm/semaphore.h>
-#include <linux/seq_file.h>
-#include <linux/cpufreq.h>
-
-/*
- *	Get CPU information for use by the procfs.
- */
-#ifdef CONFIG_X86_32
-static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
-			      unsigned int cpu)
-{
-#ifdef CONFIG_X86_HT
-	if (c->x86_max_cores * smp_num_siblings > 1) {
-		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
-		seq_printf(m, "siblings\t: %d\n",
-			   cpus_weight(per_cpu(cpu_core_map, cpu)));
-		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
-		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
-	}
-#endif
-}
-
-static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
-{
-	/*
-	 * We use exception 16 if we have hardware math and we've either seen
-	 * it or the CPU claims it is internal
-	 */
-	int fpu_exception = c->hard_math && (ignore_fpu_irq || cpu_has_fpu);
-	seq_printf(m,
-		   "fdiv_bug\t: %s\n"
-		   "hlt_bug\t\t: %s\n"
-		   "f00f_bug\t: %s\n"
-		   "coma_bug\t: %s\n"
-		   "fpu\t\t: %s\n"
-		   "fpu_exception\t: %s\n"
-		   "cpuid level\t: %d\n"
-		   "wp\t\t: %s\n",
-		   c->fdiv_bug ? "yes" : "no",
-		   c->hlt_works_ok ? "no" : "yes",
-		   c->f00f_bug ? "yes" : "no",
-		   c->coma_bug ? "yes" : "no",
-		   c->hard_math ? "yes" : "no",
-		   fpu_exception ? "yes" : "no",
-		   c->cpuid_level,
-		   c->wp_works_ok ? "yes" : "no");
-}
-#else
-static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
-			      unsigned int cpu)
-{
-#ifdef CONFIG_SMP
-	if (c->x86_max_cores * smp_num_siblings > 1) {
-		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
-		seq_printf(m, "siblings\t: %d\n",
-			   cpus_weight(per_cpu(cpu_core_map, cpu)));
-		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
-		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
-	}
-#endif
-}
-
-static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
-{
-	seq_printf(m,
-		   "fpu\t\t: yes\n"
-		   "fpu_exception\t: yes\n"
-		   "cpuid level\t: %d\n"
-		   "wp\t\t: yes\n",
-		   c->cpuid_level);
-}
-#endif
-
-static int show_cpuinfo(struct seq_file *m, void *v)
-{
-	struct cpuinfo_x86 *c = v;
-	unsigned int cpu = 0;
-	int i;
-
-#ifdef CONFIG_SMP
-	cpu = c->cpu_index;
-#endif
-	seq_printf(m, "processor\t: %u\n"
-		   "vendor_id\t: %s\n"
-		   "cpu family\t: %d\n"
-		   "model\t\t: %u\n"
-		   "model name\t: %s\n",
-		   cpu,
-		   c->x86_vendor_id[0] ? c->x86_vendor_id : "unknown",
-		   c->x86,
-		   c->x86_model,
-		   c->x86_model_id[0] ? c->x86_model_id : "unknown");
-
-	if (c->x86_mask || c->cpuid_level >= 0)
-		seq_printf(m, "stepping\t: %d\n", c->x86_mask);
-	else
-		seq_printf(m, "stepping\t: unknown\n");
-
-	if (cpu_has(c, X86_FEATURE_TSC)) {
-		unsigned int freq = cpufreq_quick_get(cpu);
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
-	show_cpuinfo_core(m, c, cpu);
-	show_cpuinfo_misc(m, c);
-
-	seq_printf(m, "flags\t\t:");
-	for (i = 0; i < 32*NCAPINTS; i++)
-		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
-			seq_printf(m, " %s", x86_cap_flags[i]);
-
-	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
-		   c->loops_per_jiffy/(500000/HZ),
-		   (c->loops_per_jiffy/(5000/HZ)) % 100);
-
-#ifdef CONFIG_X86_64
-	if (c->x86_tlbsize > 0)
-		seq_printf(m, "TLB size\t: %d 4K pages\n", c->x86_tlbsize);
-#endif
-	seq_printf(m, "clflush size\t: %u\n", c->x86_clflush_size);
-#ifdef CONFIG_X86_64
-	seq_printf(m, "cache_alignment\t: %d\n", c->x86_cache_alignment);
-	seq_printf(m, "address sizes\t: %u bits physical, %u bits virtual\n",
-		   c->x86_phys_bits, c->x86_virt_bits);
-#endif
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
-	.start	= c_start,
-	.next	= c_next,
-	.stop	= c_stop,
-	.show	= show_cpuinfo,
-};
-- 
1.5.3.8


