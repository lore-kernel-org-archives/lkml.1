Return-Path: <linux-kernel-owner+w=401wt.eu-S1765290AbYBTSs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765290AbYBTSs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYBTSsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:48:05 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:11198 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbYBTSsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:48:04 -0500
Message-ID: <47BC75E2.6010207@ct.jp.nec.com>
Date: Wed, 20 Feb 2008 10:48:02 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] x86: cosmetic unification cpu/proc|_64.c
References: <47BC746F.2000608@ct.jp.nec.com>
In-Reply-To: <47BC746F.2000608@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

make cpu/proc.c and cpu/proc_64.c same.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/cpu/proc.c    |   36 ++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/proc_64.c |   49 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index fd3823a..15043a3 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -8,6 +8,7 @@
 /*
  *	Get CPU information for use by the procfs.
  */
+#ifdef CONFIG_X86_32
 static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 			      unsigned int cpu)
 {
@@ -47,6 +48,31 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   c->cpuid_level,
 		   c->wp_works_ok ? "yes" : "no");
 }
+#else
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
+#endif
 
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
@@ -97,7 +123,17 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
 		   c->loops_per_jiffy/(500000/HZ),
 		   (c->loops_per_jiffy/(5000/HZ)) % 100);
+
+#ifdef CONFIG_X86_64
+	if (c->x86_tlbsize > 0)
+		seq_printf(m, "TLB size\t: %d 4K pages\n", c->x86_tlbsize);
+#endif
 	seq_printf(m, "clflush size\t: %u\n", c->x86_clflush_size);
+#ifdef CONFIG_X86_64
+	seq_printf(m, "cache_alignment\t: %d\n", c->x86_cache_alignment);
+	seq_printf(m, "address sizes\t: %u bits physical, %u bits virtual\n",
+		   c->x86_phys_bits, c->x86_virt_bits);
+#endif
 
 	seq_printf(m, "power management:");
 	for (i = 0; i < 32; i++) {
diff --git a/arch/x86/kernel/cpu/proc_64.c b/arch/x86/kernel/cpu/proc_64.c
index ce1b08f..15043a3 100644
--- a/arch/x86/kernel/cpu/proc_64.c
+++ b/arch/x86/kernel/cpu/proc_64.c
@@ -8,6 +8,47 @@
 /*
  *	Get CPU information for use by the procfs.
  */
+#ifdef CONFIG_X86_32
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
+#else
 static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 			      unsigned int cpu)
 {
@@ -31,6 +72,7 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   "wp\t\t: yes\n",
 		   c->cpuid_level);
 }
+#endif
 
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
@@ -82,13 +124,16 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		   c->loops_per_jiffy/(500000/HZ),
 		   (c->loops_per_jiffy/(5000/HZ)) % 100);
 
+#ifdef CONFIG_X86_64
 	if (c->x86_tlbsize > 0)
 		seq_printf(m, "TLB size\t: %d 4K pages\n", c->x86_tlbsize);
-	seq_printf(m, "clflush size\t: %d\n", c->x86_clflush_size);
+#endif
+	seq_printf(m, "clflush size\t: %u\n", c->x86_clflush_size);
+#ifdef CONFIG_X86_64
 	seq_printf(m, "cache_alignment\t: %d\n", c->x86_cache_alignment);
-
 	seq_printf(m, "address sizes\t: %u bits physical, %u bits virtual\n",
 		   c->x86_phys_bits, c->x86_virt_bits);
+#endif
 
 	seq_printf(m, "power management:");
 	for (i = 0; i < 32; i++) {
-- 
1.5.3.8


