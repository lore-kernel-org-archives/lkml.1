Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZFLNjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZFLNjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760322AbZFLNbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:05 -0400
Received: from ozlabs.org ([203.10.76.45]:55285 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758199AbZFLNbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:03 -0400
CC: linux-kernel@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:33:14 +0930
Subject: [PATCH 3/13] cpumask: Use accessors for cpu_*_mask: mips
Cc: Mike Travis <travis@sgi.com>
Message-Id: <20090612133105.A1BFDDDDA2@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the accessors rather than frobbing bits directly (the new versions
are const).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/mips/kernel/smp-cmp.c |    5 ++++-
 arch/mips/kernel/smp.c     |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- linux-2.6.28.orig/arch/mips/kernel/smp-cmp.c
+++ linux-2.6.28/arch/mips/kernel/smp-cmp.c
@@ -52,8 +52,11 @@ static int __init allowcpus(char *str)
 
 	cpus_clear(cpu_allow_map);
 	if (cpulist_parse(str, &cpu_allow_map) == 0) {
 		cpu_set(0, cpu_allow_map);
-		cpus_and(cpu_possible_map, cpu_possible_map, cpu_allow_map);
+		unsigned int i;
+		for (i = 1; i < nr_cpu_ids; i++)
+			if (!cpumask_test_cpu(i, cpu_allow_map))
+				set_cpu_possible(i, false);
 		len = cpulist_scnprintf(buf, sizeof(buf)-1, &cpu_possible_map);
 		buf[len] = '\0';
 		pr_debug("Allowable CPUs: %s\n", buf);
--- linux-2.6.28.orig/arch/mips/kernel/smp.c
+++ linux-2.6.28/arch/mips/kernel/smp.c
@@ -186,7 +186,7 @@ void __init smp_prepare_cpus(unsigned in
 	mp_ops->prepare_cpus(max_cpus);
 	set_cpu_sibling_map(0);
 #ifndef CONFIG_HOTPLUG_CPU
-	cpu_present_map = cpu_possible_map;
+	init_cpu_present(&cpu_possible_map);
 #endif
 }
 

