Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYCaM0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYCaM0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 08:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYCaM0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 08:26:10 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:44329 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753582AbYCaM0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 08:26:09 -0400
X-Greylist: delayed 2512 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Mar 2008 08:26:08 EDT
Date: Mon, 31 Mar 2008 12:44:13 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][RFC] Add default CPU topology information
Message-ID: <20080331114412.GH21637@solarflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all architectures and configurations define CPU topology information.
This can result in an empty topology directory in sysfs, and requires
in-kernel users to protect all uses with #ifdef - see
<http://marc.info/?l=linux-netdev&m=120639033904472&w=2>.

The documentation of CPU topology specifies what the defaults should be
if only partial information is available from the hardware.  So we can
provide these defaults as a fallback.

This patch:

- Adds default definitions of the 4 topology macros to
  include/asm-generic/topology.h.
- Changes include/asm-*/topology.h to include <asm-generic/topology.h>
  unconditionally.
- Changes drivers/base/topology.c to use the topology macros unconditionally
  and to cope with definitions that aren't lvalues.
- Updates documentation accordingly.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
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
index e1d3ad4..dfcb2e2 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -45,47 +45,28 @@ static ssize_t show_##name(struct sys_device *dev, char *buf)		\
 {									\
 	ssize_t len = -1;						\
 	unsigned int cpu = dev->id;					\
-	len = cpumask_scnprintf(buf, NR_CPUS+1, topology_##name(cpu));	\
+	cpumask_t siblings = topology_##name(cpu);			\
+	len = cpumask_scnprintf(buf, NR_CPUS+1, siblings);		\
 	return (len + sprintf(buf + len, "\n"));			\
 }
 
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
-#define ref_thread_siblings_attr	&attr_thread_siblings.attr,
-#else
-#define ref_thread_siblings_attr
-#endif
 
-#ifdef topology_core_siblings
 define_siblings_show_func(core_siblings);
 define_one_ro(core_siblings);
-#define ref_core_siblings_attr		&attr_core_siblings.attr,
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
+	&attr_core_siblings.attr,
 	NULL
 };
 
diff --git a/include/asm-alpha/topology.h b/include/asm-alpha/topology.h
index 420ccde..e59ec8a 100644
--- a/include/asm-alpha/topology.h
+++ b/include/asm-alpha/topology.h
@@ -41,8 +41,8 @@ static inline cpumask_t node_to_cpumask(int node)
 
 #define pcibus_to_cpumask(bus)	(cpu_online_map)
 
-#else /* CONFIG_NUMA */
-# include <asm-generic/topology.h>
-#endif /* !CONFIG_NUMA */
+#endif /* CONFIG_NUMA */
+
+#include <asm-generic/topology.h>
 
 #endif /* _ASM_ALPHA_TOPOLOGY_H */
diff --git a/include/asm-frv/topology.h b/include/asm-frv/topology.h
index abe7298..9427243 100644
--- a/include/asm-frv/topology.h
+++ b/include/asm-frv/topology.h
@@ -5,10 +5,8 @@
 
 #error NUMA not supported yet
 
-#else /* !CONFIG_NUMA */
+#endif /* CONFIG_NUMA */
 
 #include <asm-generic/topology.h>
 
-#endif /* CONFIG_NUMA */
-
 #endif /* _ASM_TOPOLOGY_H */
diff --git a/include/asm-generic/topology.h b/include/asm-generic/topology.h
index 342a2a0..373502b 100644
--- a/include/asm-generic/topology.h
+++ b/include/asm-generic/topology.h
@@ -27,6 +27,8 @@
 #ifndef _ASM_GENERIC_TOPOLOGY_H
 #define _ASM_GENERIC_TOPOLOGY_H
 
+#include <linux/cpumask.h>
+
 /* Other architectures wishing to use this simple topology API should fill
    in the below functions as appropriate in their own <asm/topology.h> file. */
 #ifndef cpu_to_node
@@ -52,4 +54,17 @@
 				)
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
diff --git a/include/asm-mips/topology.h b/include/asm-mips/topology.h
index 259145e..ce837a4 100644
--- a/include/asm-mips/topology.h
+++ b/include/asm-mips/topology.h
@@ -8,10 +8,10 @@
 #ifndef __ASM_TOPOLOGY_H
 #define __ASM_TOPOLOGY_H
 
-#include <topology.h>
-
 #ifdef CONFIG_SMP
 #define smt_capable()   (smp_num_siblings > 1)
 #endif
 
+#include <asm-generic/topology.h>
+
 #endif /* __ASM_TOPOLOGY_H */
diff --git a/include/asm-powerpc/topology.h b/include/asm-powerpc/topology.h
index ca23b68..e587788 100644
--- a/include/asm-powerpc/topology.h
+++ b/include/asm-powerpc/topology.h
@@ -96,9 +96,6 @@ static inline void sysfs_remove_device_from_node(struct sys_device *dev,
 {
 }
 
-
-#include <asm-generic/topology.h>
-
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_SMP
@@ -112,5 +109,7 @@ static inline void sysfs_remove_device_from_node(struct sys_device *dev,
 #endif
 #endif
 
+#include <asm-generic/topology.h>
+
 #endif /* __KERNEL__ */
 #endif	/* _ASM_POWERPC_TOPOLOGY_H */
diff --git a/include/asm-x86/topology.h b/include/asm-x86/topology.h
index 8af05a9..7f31b8d 100644
--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
@@ -165,11 +165,7 @@ extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
 #endif
 
-#else /* CONFIG_NUMA */
-
-#include <asm-generic/topology.h>
-
-#endif
+#endif /* CONFIG_NUMA */
 
 extern cpumask_t cpu_coregroup_map(int cpu);
 
@@ -185,4 +181,6 @@ extern cpumask_t cpu_coregroup_map(int cpu);
 #define smt_capable()			(smp_num_siblings > 1)
 #endif
 
+#include <asm-generic/topology.h>
+
 #endif

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
