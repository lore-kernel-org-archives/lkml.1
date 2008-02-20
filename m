Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbYBTSpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbYBTSpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYBTSpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:45:31 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:9856 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbYBTSpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:45:30 -0500
Message-ID: <47BC7549.4050709@ct.jp.nec.com>
Date: Wed, 20 Feb 2008 10:45:29 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] x86: make cpu/proc|_64.c similar
References: <47BC746F.2000608@ct.jp.nec.com>
In-Reply-To: <47BC746F.2000608@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

clean up for unification.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/cpu/proc.c    |  120 +++++++++++++++++++++++-----------------
 arch/x86/kernel/cpu/proc_64.c |   63 ++++++++++++---------
 2 files changed, 105 insertions(+), 78 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index af11d31..9bc3b04 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -8,75 +8,90 @@
 /*
  *	Get CPU information for use by the procfs.
  */
+static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
+			      unsigned int cpu)
+{
+#ifdef CONFIG_X86_HT
+	if (c->x86_max_cores * smp_num_siblings > 1) {
+		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
+		seq_printf(m, "siblings\t: %d\n",
+			   cpus_weight(per_cpu(cpu_core_map, cpu)));
+		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
+		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
+	}
+#endif
+}
+
+static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
+{
+	/*
+	 * We use exception 16 if we have hardware math and we've either seen
+	 * it or the CPU claims it is internal
+	 */
+	int fpu_exception = c->hard_math && (ignore_fpu_irq || cpu_has_fpu);
+	seq_printf(m,
+		   "fdiv_bug\t: %s\n"
+		   "hlt_bug\t\t: %s\n"
+		   "f00f_bug\t: %s\n"
+		   "coma_bug\t: %s\n"
+		   "fpu\t\t: %s\n"
+		   "fpu_exception\t: %s\n"
+		   "cpuid level\t: %d\n"
+		   "wp\t\t: %s\n",
+		   c->fdiv_bug ? "yes" : "no",
+		   c->hlt_works_ok ? "no" : "yes",
+		   c->f00f_bug ? "yes" : "no",
+		   c->coma_bug ? "yes" : "no",
+		   c->hard_math ? "yes" : "no",
+		   fpu_exception ? "yes" : "no",
+		   c->cpuid_level,
+		   c->wp_works_ok ? "yes" : "no");
+}
+
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
 	struct cpuinfo_x86 *c = v;
-	int i, n = 0;
-	int fpu_exception;
+	unsigned int cpu = 0;
+	int i;
 
 #ifdef CONFIG_SMP
-	n = c->cpu_index;
+	cpu = c->cpu_index;
 #endif
-	seq_printf(m, "processor\t: %d\n"
-		"vendor_id\t: %s\n"
-		"cpu family\t: %d\n"
-		"model\t\t: %d\n"
-		"model name\t: %s\n",
-		n,
-		c->x86_vendor_id[0] ? c->x86_vendor_id : "unknown",
-		c->x86,
-		c->x86_model,
-		c->x86_model_id[0] ? c->x86_model_id : "unknown");
+	seq_printf(m, "processor\t: %u\n"
+		   "vendor_id\t: %s\n"
+		   "cpu family\t: %d\n"
+		   "model\t\t: %u\n"
+		   "model name\t: %s\n",
+		   cpu,
+		   c->x86_vendor_id[0] ? c->x86_vendor_id : "unknown",
+		   c->x86,
+		   c->x86_model,
+		   c->x86_model_id[0] ? c->x86_model_id : "unknown");
 
 	if (c->x86_mask || c->cpuid_level >= 0)
 		seq_printf(m, "stepping\t: %d\n", c->x86_mask);
 	else
 		seq_printf(m, "stepping\t: unknown\n");
 
-	if ( cpu_has(c, X86_FEATURE_TSC) ) {
-		unsigned int freq = cpufreq_quick_get(n);
+	if (cpu_has(c, X86_FEATURE_TSC)) {
+		unsigned int freq = cpufreq_quick_get(cpu);
+
 		if (!freq)
 			freq = cpu_khz;
 		seq_printf(m, "cpu MHz\t\t: %u.%03u\n",
-			freq / 1000, (freq % 1000));
+			   freq / 1000, (freq % 1000));
 	}
 
 	/* Cache size */
 	if (c->x86_cache_size >= 0)
 		seq_printf(m, "cache size\t: %d KB\n", c->x86_cache_size);
-#ifdef CONFIG_X86_HT
-	if (c->x86_max_cores * smp_num_siblings > 1) {
-		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
-		seq_printf(m, "siblings\t: %d\n",
-				cpus_weight(per_cpu(cpu_core_map, n)));
-		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
-		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
-	}
-#endif
-	
-	/* We use exception 16 if we have hardware math and we've either seen it or the CPU claims it is internal */
-	fpu_exception = c->hard_math && (ignore_fpu_irq || cpu_has_fpu);
-	seq_printf(m, "fdiv_bug\t: %s\n"
-			"hlt_bug\t\t: %s\n"
-			"f00f_bug\t: %s\n"
-			"coma_bug\t: %s\n"
-			"fpu\t\t: %s\n"
-			"fpu_exception\t: %s\n"
-			"cpuid level\t: %d\n"
-			"wp\t\t: %s\n"
-			"flags\t\t:",
-		     c->fdiv_bug ? "yes" : "no",
-		     c->hlt_works_ok ? "no" : "yes",
-		     c->f00f_bug ? "yes" : "no",
-		     c->coma_bug ? "yes" : "no",
-		     c->hard_math ? "yes" : "no",
-		     fpu_exception ? "yes" : "no",
-		     c->cpuid_level,
-		     c->wp_works_ok ? "yes" : "no");
-
-	for ( i = 0 ; i < 32*NCAPINTS ; i++ )
-		if ( test_bit(i, c->x86_capability) &&
-		     x86_cap_flags[i] != NULL )
+
+	show_cpuinfo_core(m, c, cpu);
+	show_cpuinfo_misc(m, c);
+
+	seq_printf(m, "flags\t\t:");
+	for (i = 0; i < 32*NCAPINTS; i++)
+		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
 			seq_printf(m, " %s", x86_cap_flags[i]);
 
 	for (i = 0; i < 32; i++)
@@ -91,8 +106,8 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		}
 
 	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
-		     c->loops_per_jiffy/(500000/HZ),
-		     (c->loops_per_jiffy/(5000/HZ)) % 100);
+		   c->loops_per_jiffy/(500000/HZ),
+		   (c->loops_per_jiffy/(5000/HZ)) % 100);
 	seq_printf(m, "clflush size\t: %u\n\n", c->x86_clflush_size);
 
 	return 0;
@@ -106,14 +121,17 @@ static void *c_start(struct seq_file *m, loff_t *pos)
 		return &cpu_data(*pos);
 	return NULL;
 }
+
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	*pos = next_cpu(*pos, cpu_online_map);
 	return c_start(m, pos);
 }
+
 static void c_stop(struct seq_file *m, void *v)
 {
 }
+
 const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
diff --git a/arch/x86/kernel/cpu/proc_64.c b/arch/x86/kernel/cpu/proc_64.c
index bf4a94b..ce1b08f 100644
--- a/arch/x86/kernel/cpu/proc_64.c
+++ b/arch/x86/kernel/cpu/proc_64.c
@@ -8,25 +8,48 @@
 /*
  *	Get CPU information for use by the procfs.
  */
+static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
+			      unsigned int cpu)
+{
+#ifdef CONFIG_SMP
+	if (c->x86_max_cores * smp_num_siblings > 1) {
+		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
+		seq_printf(m, "siblings\t: %d\n",
+			   cpus_weight(per_cpu(cpu_core_map, cpu)));
+		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
+		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
+	}
+#endif
+}
+
+static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
+{
+	seq_printf(m,
+		   "fpu\t\t: yes\n"
+		   "fpu_exception\t: yes\n"
+		   "cpuid level\t: %d\n"
+		   "wp\t\t: yes\n",
+		   c->cpuid_level);
+}
 
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
 	struct cpuinfo_x86 *c = v;
-	int cpu = 0, i;
+	unsigned int cpu = 0;
+	int i;
 
 #ifdef CONFIG_SMP
 	cpu = c->cpu_index;
 #endif
-
 	seq_printf(m, "processor\t: %u\n"
 		   "vendor_id\t: %s\n"
 		   "cpu family\t: %d\n"
-		   "model\t\t: %d\n"
+		   "model\t\t: %u\n"
 		   "model name\t: %s\n",
-		   (unsigned)cpu,
+		   cpu,
 		   c->x86_vendor_id[0] ? c->x86_vendor_id : "unknown",
 		   c->x86,
-		   (int)c->x86_model,
+		   c->x86_model,
 		   c->x86_model_id[0] ? c->x86_model_id : "unknown");
 
 	if (c->x86_mask || c->cpuid_level >= 0)
@@ -35,7 +58,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		seq_printf(m, "stepping\t: unknown\n");
 
 	if (cpu_has(c, X86_FEATURE_TSC)) {
-		unsigned int freq = cpufreq_quick_get((unsigned)cpu);
+		unsigned int freq = cpufreq_quick_get(cpu);
 
 		if (!freq)
 			freq = cpu_khz;
@@ -47,24 +70,10 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	if (c->x86_cache_size >= 0)
 		seq_printf(m, "cache size\t: %d KB\n", c->x86_cache_size);
 
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
+	show_cpuinfo_core(m, c, cpu);
+	show_cpuinfo_misc(m, c);
 
+	seq_printf(m, "flags\t\t:");
 	for (i = 0; i < 32*NCAPINTS; i++)
 		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
 			seq_printf(m, " %s", x86_cap_flags[i]);
@@ -119,8 +128,8 @@ static void c_stop(struct seq_file *m, void *v)
 }
 
 const struct seq_operations cpuinfo_op = {
-	.start = c_start,
-	.next =	c_next,
-	.stop =	c_stop,
-	.show =	show_cpuinfo,
+	.start	= c_start,
+	.next	= c_next,
+	.stop	= c_stop,
+	.show	= show_cpuinfo,
 };
-- 
1.5.3.8


