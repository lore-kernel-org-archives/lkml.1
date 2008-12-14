Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbYLNGHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbYLNGHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 01:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbYLNGHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 01:07:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:39459 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbYLNGHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 01:07:33 -0500
Message-ID: <4944A279.5020009@kernel.org>
Date: Sat, 13 Dec 2008 22:06:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] add command line init_start_cpus
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: new command line

so could select cpus to be started during init stage

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 Documentation/kernel-parameters.txt |   14 ++++++++++++++
 init/main.c                         |   29 ++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -918,6 +918,20 @@ and is between 256 and 4096 characters.
 		forcesac
 		soft
 
+	init_start_cpus=	[KNL,SMP] set CPUs that will be started during
+			init stage.
+			Format:
+			<cpu number>,...,<cpu number>
+			or
+			<cpu number>-<cpu number>
+			(must be a positive range in ascending order)
+			or a mixture
+			<cpu number>,...,<cpu number>-<cpu number>
+
+			This option can be used to specify one or more CPUs
+			to be started during init stage.
+			<cpu number> begins at 0 and the maximum value is
+			"number of CPUs in system - 1".
 
 	intel_iommu=	[DMAR] Intel IOMMU driver (DMAR) option
 		off
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -413,11 +413,35 @@ static void __init setup_per_cpu_areas(v
 }
 #endif /* CONFIG_HAVE_SETUP_PER_CPU_AREA */
 
+static __initdata cpumask_var_t cpu_init_start_mask;
+
+/* Setup the mask of cpus configured for init start */
+static int __init init_start_cpu_setup(char *str)
+{
+	cpulist_parse(str, *cpu_init_start_mask);
+
+	return 1;
+}
+
+__setup("init_start_cpus=", init_start_cpu_setup);
+
 /* Called by boot processor to activate the rest. */
 static void __init smp_init(void)
 {
 	unsigned int cpu;
+	struct cpumask *start_mask;
+
+	if (cpumask_empty(cpu_init_start_mask))
+		start_mask = &cpu_present_map;
+	else {
+		start_mask = kmalloc(cpumask_size(), GFP_KERNEL);
 
+		if (!start_mask)
+			start_mask = &cpu_present_map;
+		else
+			cpumask_and(start_mask, cpu_init_start_mask,
+					 &cpu_present_map);
+	}
 	/*
 	 * Set up the current CPU as possible to migrate to.
 	 * The other ones will be done by cpu_up/cpu_down()
@@ -426,13 +450,16 @@ static void __init smp_init(void)
 	cpu_set(cpu, cpu_active_map);
 
 	/* FIXME: This should be done in userspace --RR */
-	for_each_present_cpu(cpu) {
+	for_each_cpu_mask_nr(cpu, *start_mask) {
 		if (num_online_cpus() >= setup_max_cpus)
 			break;
 		if (!cpu_online(cpu))
 			cpu_up(cpu);
 	}
 
+	if (start_mask != &cpu_present_map)
+		kfree(start_mask);
+
 	/* Any cleanup work */
 	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
 	smp_cpus_done(setup_max_cpus);

