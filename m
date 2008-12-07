Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYLGLC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYLGLC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 06:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbYLGLBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 06:01:48 -0500
Received: from ozlabs.org ([203.10.76.45]:59379 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbYLGLBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 06:01:46 -0500
To: linux-kernel@vger.kernel.org
Cc: Mike Travis <travis@sgi.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 7 Dec 2008 21:31:35 +1030
Subject: [PATCH 6/6] cpumask: Use topology_core_cpumask()/topology_thread_cpumask()
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072131.35648.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This actually uses topology_core_cpumask() and
topology_thread_cpumask(), removing the only users of
topology_core_siblings() and topology_thread_siblings()

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 drivers/base/topology.c  |   35 +++++++++++++++++------------------
 drivers/net/sfc/efx.c    |    4 ++--
 include/linux/topology.h |    6 ++++++
 3 files changed, 25 insertions(+), 20 deletions(-)

--- linux-2.6.orig/drivers/base/topology.c
+++ linux-2.6/drivers/base/topology.c
@@ -30,7 +30,10 @@
 #include <linux/module.h>
 #include <linux/topology.h>
 
-#define define_one_ro(_name) 		\
+#define define_one_ro_named(_name, _func)				\
+static SYSDEV_ATTR(_name, 0444, _func, NULL)
+
+#define define_one_ro(_name)				\
 static SYSDEV_ATTR(_name, 0444, show_##_name, NULL)
 
 #define define_id_show_func(name)				\
@@ -41,8 +44,8 @@ static ssize_t show_##name(struct sys_de
 	return sprintf(buf, "%d\n", topology_##name(cpu));	\
 }
 
-#if defined(topology_thread_siblings) || defined(topology_core_siblings)
-static ssize_t show_cpumap(int type, cpumask_t *mask, char *buf)
+#if defined(topology_thread_cpumask) || defined(topology_core_cpumask)
+static ssize_t show_cpumap(int type, const struct cpumask *mask, char *buf)
 {
 	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
 	int n = 0;
@@ -64,7 +67,7 @@ static ssize_t show_##name(struct sys_de
 			   struct sysdev_attribute *attr, char *buf)	\
 {									\
 	unsigned int cpu = dev->id;					\
-	return show_cpumap(0, &(topology_##name(cpu)), buf);		\
+	return show_cpumap(0, topology_##name(cpu), buf);		\
 }
 
 #define define_siblings_show_list(name)					\
@@ -73,7 +76,7 @@ static ssize_t show_##name##_list(struct
 				  char *buf)				\
 {									\
 	unsigned int cpu = dev->id;					\
-	return show_cpumap(1, &(topology_##name(cpu)), buf);		\
+	return show_cpumap(1, topology_##name(cpu), buf);		\
 }
 
 #else
@@ -81,9 +84,7 @@ static ssize_t show_##name##_list(struct
 static ssize_t show_##name(struct sys_device *dev,			\
 			   struct sysdev_attribute *attr, char *buf)	\
 {									\
-	unsigned int cpu = dev->id;					\
-	cpumask_t mask = topology_##name(cpu);				\
-	return show_cpumap(0, &mask, buf);				\
+	return show_cpumap(0, topology_##name(dev->id), buf);		\
 }
 
 #define define_siblings_show_list(name)					\
@@ -91,9 +92,7 @@ static ssize_t show_##name##_list(struct
 				  struct sysdev_attribute *attr,	\
 				  char *buf)				\
 {									\
-	unsigned int cpu = dev->id;					\
-	cpumask_t mask = topology_##name(cpu);				\
-	return show_cpumap(1, &mask, buf);				\
+	return show_cpumap(1, topology_##name(dev->id), buf);		\
 }
 #endif
 
@@ -106,13 +105,13 @@ define_one_ro(physical_package_id);
 define_id_show_func(core_id);
 define_one_ro(core_id);
 
-define_siblings_show_func(thread_siblings);
-define_one_ro(thread_siblings);
-define_one_ro(thread_siblings_list);
-
-define_siblings_show_func(core_siblings);
-define_one_ro(core_siblings);
-define_one_ro(core_siblings_list);
+define_siblings_show_func(thread_cpumask);
+define_one_ro_named(thread_siblings, show_thread_cpumask);
+define_one_ro_named(thread_siblings_list, show_thread_cpumask_list);
+
+define_siblings_show_func(core_cpumask);
+define_one_ro_named(core_siblings, show_core_cpumask);
+define_one_ro_named(core_siblings_list, show_core_cpumask_list);
 
 static struct attribute *default_attrs[] = {
 	&attr_physical_package_id.attr,
--- linux-2.6.orig/drivers/net/sfc/efx.c
+++ linux-2.6/drivers/net/sfc/efx.c
@@ -820,8 +820,8 @@ static int efx_wanted_rx_queues(void)
 	for_each_online_cpu(cpu) {
 		if (!cpu_isset(cpu, core_mask)) {
 			++count;
-			cpus_or(core_mask, core_mask,
-				topology_core_siblings(cpu));
+			cpumask_or(&core_mask, &core_mask,
+				   topology_core_cpumask(cpu));
 		}
 	}
 
--- linux-2.6.orig/include/linux/topology.h
+++ linux-2.6/include/linux/topology.h
@@ -191,5 +191,11 @@ void arch_update_cpu_topology(void);
 #ifndef topology_core_siblings
 #define topology_core_siblings(cpu)		cpumask_of_cpu(cpu)
 #endif
+#ifndef topology_thread_cpumask
+#define topology_thread_cpumask(cpu)		cpumask_of(cpu)
+#endif
+#ifndef topology_core_cpumask
+#define topology_core_cpumask(cpu)		cpumask_of(cpu)
+#endif
 
 #endif /* _LINUX_TOPOLOGY_H */

