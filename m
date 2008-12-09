Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYLIRyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYLIRyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYLIRxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:53:41 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:37196 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbYLIRxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:53:40 -0500
Message-Id: <20081209175337.926065536@de.ibm.com>
References: <20081209174949.355669577@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 09 Dec 2008 18:49:50 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: akpm@linux-foundation.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 1/2] sched: let arch_update_cpu_topology indicate if topology changed
Content-Disposition: inline; filename=001_arch_topology.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Change arch_update_cpu_topology so it returns 1 if the cpu topology changed
and 0 if it didn't change. This will be useful for the next patch which adds
a call to this function in partition_sched_domains.

Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/topology.c |    5 +++--
 include/linux/topology.h    |    2 +-
 kernel/sched.c              |    8 +++++++-
 3 files changed, 11 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7710,8 +7710,14 @@ static struct sched_domain_attr *dattr_c
  */
 static cpumask_t fallback_doms;
 
-void __attribute__((weak)) arch_update_cpu_topology(void)
+/*
+ * arch_update_cpu_topology lets virtualized architectures update the
+ * cpu core maps. It is supposed to return 1 if the topology changed
+ * or 0 if it stayed the same.
+ */
+int __attribute__((weak)) arch_update_cpu_topology(void)
 {
+	return 0;
 }
 
 /*
Index: linux-2.6/arch/s390/kernel/topology.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/topology.c
+++ linux-2.6/arch/s390/kernel/topology.c
@@ -212,7 +212,7 @@ static void update_cpu_core_map(void)
 		cpu_core_map[cpu] = cpu_coregroup_map(cpu);
 }
 
-void arch_update_cpu_topology(void)
+int arch_update_cpu_topology(void)
 {
 	struct tl_info *info = tl_info;
 	struct sys_device *sysdev;
@@ -221,7 +221,7 @@ void arch_update_cpu_topology(void)
 	if (!machine_has_topology) {
 		update_cpu_core_map();
 		topology_update_polarization_simple();
-		return;
+		return 0;
 	}
 	stsi(info, 15, 1, 2);
 	tl_to_cores(info);
@@ -230,6 +230,7 @@ void arch_update_cpu_topology(void)
 		sysdev = get_cpu_sysdev(cpu);
 		kobject_uevent(&sysdev->kobj, KOBJ_CHANGE);
 	}
+	return 1;
 }
 
 static void topology_work_fn(struct work_struct *work)
Index: linux-2.6/include/linux/topology.h
===================================================================
--- linux-2.6.orig/include/linux/topology.h
+++ linux-2.6/include/linux/topology.h
@@ -49,7 +49,7 @@
 	for_each_online_node(node)			\
 		if (nr_cpus_node(node))
 
-void arch_update_cpu_topology(void);
+int arch_update_cpu_topology(void);
 
 /* Conform to ACPI 2.0 SLIT distance definitions */
 #define LOCAL_DISTANCE		10

-- 
