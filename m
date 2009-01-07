Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbZAGT77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbZAGT77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbZAGT6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:58:38 -0500
Received: from relay1.sgi.com ([192.48.179.29]:34074 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754281AbZAGT6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:58:36 -0500
Message-Id: <20090107195832.601131000@polaris-admin.engr.sgi.com>
References: <20090107195832.265117000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 07 Jan 2009 11:58:34 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       linux-net-drivers@solarflare.com
Subject: [PATCH 2/5] cpumask: Use topology_core_cpumask()/topology_thread_cpumask()
Content-Disposition: inline; filename=cpumask:use-topology_core_cpumask-and-topology_thread_cpumask.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Impact: reduce stack usage, use new cpumask API.

This actually uses topology_core_cpumask() and
topology_thread_cpumask(), removing the only users of
topology_core_siblings() and topology_thread_siblings()

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: linux-net-drivers@solarflare.com
---
 Documentation/cputopology.txt |    6 +++---
 drivers/base/topology.c       |   35 +++++++++++++++++------------------
 drivers/net/sfc/efx.c         |    4 ++--
 include/linux/topology.h      |    6 ++++++
 4 files changed, 28 insertions(+), 23 deletions(-)

--- linux-2.6-for-ingo.orig/Documentation/cputopology.txt
+++ linux-2.6-for-ingo/Documentation/cputopology.txt
@@ -18,11 +18,11 @@ For an architecture to support this feat
 these macros in include/asm-XXX/topology.h:
 #define topology_physical_package_id(cpu)
 #define topology_core_id(cpu)
-#define topology_thread_siblings(cpu)
-#define topology_core_siblings(cpu)
+#define topology_thread_cpumask(cpu)
+#define topology_core_cpumask(cpu)
 
 The type of **_id is int.
-The type of siblings is cpumask_t.
+The type of siblings is (const) struct cpumask *.
 
 To be consistent on all architectures, include/linux/topology.h
 provides default definitions for any of the above macros that are
--- linux-2.6-for-ingo.orig/drivers/base/topology.c
+++ linux-2.6-for-ingo/drivers/base/topology.c
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
--- linux-2.6-for-ingo.orig/drivers/net/sfc/efx.c
+++ linux-2.6-for-ingo/drivers/net/sfc/efx.c
@@ -863,8 +863,8 @@ static int efx_wanted_rx_queues(void)
 	for_each_online_cpu(cpu) {
 		if (!cpu_isset(cpu, core_mask)) {
 			++count;
-			cpus_or(core_mask, core_mask,
-				topology_core_siblings(cpu));
+			cpumask_or(&core_mask, &core_mask,
+				   topology_core_cpumask(cpu));
 		}
 	}
 
--- linux-2.6-for-ingo.orig/include/linux/topology.h
+++ linux-2.6-for-ingo/include/linux/topology.h
@@ -193,5 +193,11 @@ int arch_update_cpu_topology(void);
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

-- 
