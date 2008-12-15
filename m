Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYLOOxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYLOOxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYLOOwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:52:53 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:39582 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbYLOOww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:52:52 -0500
Message-Id: <20081215145249.579042637@de.ibm.com>
References: <20081215143437.843064041@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 15:34:38 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: mingo@elte.hu, akpm@linux-foundation.org
Cc: maxk@qualcomm.com, schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RESEND 1/2] sched: let arch_update_cpu_topology indicate if topology changed
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
@@ -7712,8 +7712,14 @@ static struct sched_domain_attr *dattr_c
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
