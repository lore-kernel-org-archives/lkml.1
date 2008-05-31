Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYEaVpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYEaVpf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 17:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbYEaVpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 17:45:25 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:37645 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751812AbYEaVpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 17:45:24 -0400
Date: Sat, 31 May 2008 22:44:30 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] cputopology: Add default CPU topology information [3rd try]
Message-ID: <20080531214429.GQ1743@solarflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the macros topology_{physical_package,core}_id() and
topology_{thread,core}_siblings() in <asm-generic/topology.h> if they are not
already defined.

Move inclusion of <asm-generic/topology.h> after definitions of these
macros in <asm-powerpc/topology.h> and <asm-x86/topology.h>.

Change drivers/base/topology.c to use the topology macros unconditionally and
to cope with definitions that aren't lvalues.

Update documentation accordingly.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
---
 Documentation/cputopology.txt  |   26 +++++++++-----------------
 drivers/base/topology.c        |   38 ++++++++++----------------------------
 include/asm-generic/topology.h |   15 +++++++++++++++
 include/asm-powerpc/topology.h |    4 ++--
 include/asm-x86/topology.h     |    4 ++--
 5 files changed, 38 insertions(+), 49 deletions(-)

diff --git a/Documentation/cputopology.txt b/Documentation/cputopology.txt
index b61cb95..c035481 100644
--- a/Documentation/cputopology.txt
+++ b/Documentation/cputopology.txt
@@ -14,9 +14,8 @@ represent the thread siblings to cpu X in the same physical package;
 To implement it in an architecture-neutral way, a new source file,
 drivers/base/topology.c, is to export the 4 attributes.
 
-If one architecture wants to support this feature, it just needs to
-implement 4 defines, typically in file include/asm-XXX/topology.h.
-The 4 defines are:
+If one architecture wants to support this feature, it must define
+some of these macros in include/asm-XXX/topology.h:
 #define topology_physical_package_id(cpu)
 #define topology_core_id(cpu)
 #define topology_thread_siblings(cpu)
@@ -25,17 +24,10 @@ The 4 defines are:
 The type of **_id is int.
 The type of siblings is cpumask_t.
 
-To be consistent on all architectures, the 4 attributes should have
-default values if their values are unavailable. Below is the rule.
-1) physical_package_id: If cpu has no physical package id, -1 is the
-default value.
-2) core_id: If cpu doesn't support multi-core, its core id is 0.
-3) thread_siblings: Just include itself, if the cpu doesn't support
-HT/multi-thread.
-4) core_siblings: Just include itself, if the cpu doesn't support
-multi-core and HT/Multi-thread.
-
-So be careful when declaring the 4 defines in include/asm-XXX/topology.h.
-
-If an attribute isn't defined on an architecture, it won't be exported.
-
+To be consistent on all architectures, include/asm-generic/topology.h
+provides default definitions for any of the above macros that are
+not already defined:
+1) physical_package_id: -1
+2) core_id: 0
+3) thread_siblings: just the given CPU
+4) core_siblings: just the given CPU
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index fdf4044..24d29a9 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -59,60 +59,42 @@ static ssize_t show_cpumap(int type, cpumask_t *mask, char *buf)
 static inline ssize_t show_##name(struct sys_device *dev, char *buf)	\
 {									\
 	unsigned int cpu = dev->id;					\
-	return show_cpumap(0, &(topology_##name(cpu)), buf);		\
+	cpumask_t siblings = topology_##name(cpu);			\
+	return show_cpumap(0, &siblings, buf);				\
 }
 
 #define define_siblings_show_list(name)					\
 static inline ssize_t show_##name##_list(struct sys_device *dev, char *buf) \
 {									\
 	unsigned int cpu = dev->id;					\
-	return show_cpumap(1, &(topology_##name(cpu)), buf);		\
+	cpumask_t siblings = topology_##name(cpu);			\
+	return show_cpumap(1, &siblings, buf);				\
 }
 
 #define define_siblings_show_func(name)		\
 	define_siblings_show_map(name); define_siblings_show_list(name)
 
-#ifdef	topology_physical_package_id
 define_id_show_func(physical_package_id);
 define_one_ro(physical_package_id);
-#define ref_physical_package_id_attr	&attr_physical_package_id.attr,
-#else
-#define ref_physical_package_id_attr
-#endif
 
-#ifdef topology_core_id
 define_id_show_func(core_id);
 define_one_ro(core_id);
-#define ref_core_id_attr		&attr_core_id.attr,
-#else
-#define ref_core_id_attr
-#endif
 
-#ifdef topology_thread_siblings
 define_siblings_show_func(thread_siblings);
 define_one_ro(thread_siblings);
 define_one_ro(thread_siblings_list);
-#define ref_thread_siblings_attr	\
-		&attr_thread_siblings.attr, &attr_thread_siblings_list.attr,
-#else
-#define ref_thread_siblings_attr
-#endif
 
-#ifdef topology_core_siblings
 define_siblings_show_func(core_siblings);
 define_one_ro(core_siblings);
 define_one_ro(core_siblings_list);
-#define ref_core_siblings_attr		\
-		&attr_core_siblings.attr, &attr_core_siblings_list.attr,
-#else
-#define ref_core_siblings_attr
-#endif
 
 static struct attribute *default_attrs[] = {
-	ref_physical_package_id_attr
-	ref_core_id_attr
-	ref_thread_siblings_attr
-	ref_core_siblings_attr
+	&attr_physical_package_id.attr,
+	&attr_core_id.attr,
+	&attr_thread_siblings.attr,
+	&attr_thread_siblings_list.attr,
+	&attr_core_siblings.attr,
+	&attr_core_siblings_list.attr,
 	NULL
 };
 
diff --git a/include/asm-generic/topology.h b/include/asm-generic/topology.h
index a6aea79..8ad8aa0 100644
--- a/include/asm-generic/topology.h
+++ b/include/asm-generic/topology.h
@@ -27,6 +27,8 @@
 #ifndef _ASM_GENERIC_TOPOLOGY_H
 #define _ASM_GENERIC_TOPOLOGY_H
 
+#include <linux/cpumask.h>
+
 #ifndef	CONFIG_NUMA
 
 /* Other architectures wishing to use this simple topology API should fill
@@ -66,4 +68,17 @@
 			  _##v = node_to_cpumask(node)
 #endif
 
+#ifndef topology_physical_package_id
+#define topology_physical_package_id(cpu)	((void)(cpu), -1)
+#endif
+#ifndef topology_core_id
+#define topology_core_id(cpu)			((void)(cpu), 0)
+#endif
+#ifndef topology_thread_siblings
+#define topology_thread_siblings(cpu)		cpumask_of_cpu(cpu)
+#endif
+#ifndef topology_core_siblings
+#define topology_core_siblings(cpu)		cpumask_of_cpu(cpu)
+#endif
+
 #endif /* _ASM_GENERIC_TOPOLOGY_H */
diff --git a/include/asm-powerpc/topology.h b/include/asm-powerpc/topology.h
index 100c6fb..e587788 100644
--- a/include/asm-powerpc/topology.h
+++ b/include/asm-powerpc/topology.h
@@ -98,8 +98,6 @@ static inline void sysfs_remove_device_from_node(struct sys_device *dev,
 
 #endif /* CONFIG_NUMA */
 
-#include <asm-generic/topology.h>
-
 #ifdef CONFIG_SMP
 #include <asm/cputable.h>
 #define smt_capable()		(cpu_has_feature(CPU_FTR_SMT))
@@ -111,5 +109,7 @@ static inline void sysfs_remove_device_from_node(struct sys_device *dev,
 #endif
 #endif
 
+#include <asm-generic/topology.h>
+
 #endif /* __KERNEL__ */
 #endif	/* _ASM_POWERPC_TOPOLOGY_H */
diff --git a/include/asm-x86/topology.h b/include/asm-x86/topology.h
index dcf3f81..c4c28c6 100644
--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
@@ -184,8 +184,6 @@ extern int __node_distance(int, int);
 
 #endif
 
-#include <asm-generic/topology.h>
-
 extern cpumask_t cpu_coregroup_map(int cpu);
 
 #ifdef ENABLE_TOPO_DEFINES
@@ -220,4 +218,6 @@ static inline void set_mp_bus_to_node(int busnum, int node)
 }
 #endif
 
+#include <asm-generic/topology.h>
+
 #endif

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
