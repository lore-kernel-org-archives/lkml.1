Return-Path: <linux-kernel-owner+w=401wt.eu-S1758613AbZEDRgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbZEDRgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758676AbZEDRf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:35:27 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:28207 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666AbZEDRfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:35:25 -0400
X-BigFish: VPS2(z34a4jz936eQzz1202hzzz32i6bh15fn43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KJ4RII-01-2H6-01
Date: Mon, 4 May 2009 19:34:50 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: introduce cpuinfo->cpu_node_id to reflect
	topology of multi-node CPU
Message-ID: <20090504173450.GG28728@alberich.amd.com>
References: <20090504173330.GF28728@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090504173330.GF28728@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 04 May 2009 17:35:11.0476 (UTC) FILETIME=[AD0B1340:01C9CCDE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/cpu/common.c     |    2 ++
 arch/x86/kernel/cpu/proc.c       |    1 +
 arch/x86/kernel/smpboot.c        |    5 ++++-
 4 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 0b2fab0..b49d72b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -106,6 +106,8 @@ struct cpuinfo_x86 {
 	u16			booted_cores;
 	/* Physical processor id: */
 	u16			phys_proc_id;
+	/* Node id in case of multi-node processor: */
+	u16			cpu_node_id;
 	/* Core id: */
 	u16			cpu_core_id;
 	/* Index into per_cpu list: */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 591012f..9bff330 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -470,6 +470,8 @@ out:
 	if ((c->x86_max_cores * smp_num_siblings) > 1) {
 		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
 		       c->phys_proc_id);
+		printk(KERN_INFO  "CPU: Processor Node ID: %d\n",
+		       c->cpu_node_id);
 		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
 		       c->cpu_core_id);
 	}
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index f93047f..e761c90 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -13,6 +13,7 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 #ifdef CONFIG_SMP
 	if (c->x86_max_cores * smp_num_siblings > 1) {
 		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
+		seq_printf(m, "node id\t\t: %d\n", c->cpu_node_id);
 		seq_printf(m, "siblings\t: %d\n",
 			   cpumask_weight(cpu_sibling_mask(cpu)));
 		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index d2e8de9..dc0e735 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -374,6 +374,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 			struct cpuinfo_x86 *o = &cpu_data(i);
 
 			if (c->phys_proc_id == o->phys_proc_id &&
+			    c->cpu_node_id == o->cpu_node_id &&
 			    c->cpu_core_id == o->cpu_core_id) {
 				cpumask_set_cpu(i, cpu_sibling_mask(cpu));
 				cpumask_set_cpu(cpu, cpu_sibling_mask(i));
@@ -401,7 +402,8 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 			cpumask_set_cpu(i, c->llc_shared_map);
 			cpumask_set_cpu(cpu, cpu_data(i).llc_shared_map);
 		}
-		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
+		if (c->phys_proc_id == cpu_data(i).phys_proc_id &&
+		    c->cpu_node_id == cpu_data(i).cpu_node_id) {
 			cpumask_set_cpu(i, cpu_core_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_core_mask(i));
 			/*
@@ -1218,6 +1220,7 @@ static void remove_siblinginfo(int cpu)
 	cpumask_clear(cpu_sibling_mask(cpu));
 	cpumask_clear(cpu_core_mask(cpu));
 	c->phys_proc_id = 0;
+	c->cpu_node_id = 0;
 	c->cpu_core_id = 0;
 	cpumask_clear_cpu(cpu, cpu_sibling_setup_mask);
 }
-- 
1.6.2



