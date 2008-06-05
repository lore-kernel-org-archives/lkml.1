Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbYFEQht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbYFEQht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbYFEQhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:37:41 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:49065 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752589AbYFEQhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:37:40 -0400
Date: Thu, 5 Jun 2008 17:37:15 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: [PATCH] cputopology: Always define CPU topology information [5th try]
Message-ID: <20080605163714.GO11300@solarflare.com>
References: <20080604154454.GD11300@solarflare.com> <20080604214715.bbebe325.akpm@linux-foundation.org> <20080605120829.GI11300@solarflare.com> <20080605092831.a77d164d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605092831.a77d164d.akpm@linux-foundation.org>
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

- Adds default definitions of the 4 topology macros to <linux/topology.h>
- Changes drivers/base/topology.c to use the topology macros unconditionally
- Updates documentation accordingly

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
---
 Documentation/cputopology.txt |   26 +++++++++-----------------
 drivers/base/topology.c       |   32 ++++++--------------------------
 include/linux/topology.h      |   13 +++++++++++++
 3 files changed, 28 insertions(+), 43 deletions(-)

diff --git a/Documentation/cputopology.txt b/Documentation/cputopology.txt
index b61cb95..bd699da 100644
--- a/Documentation/cputopology.txt
+++ b/Documentation/cputopology.txt
@@ -14,9 +14,8 @@ represent the thread siblings to cpu X in the same physical package;
 To implement it in an architecture-neutral way, a new source file,
 drivers/base/topology.c, is to export the 4 attributes.
 
-If one architecture wants to support this feature, it just needs to
-implement 4 defines, typically in file include/asm-XXX/topology.h.
-The 4 defines are:
+For an architecture to support this feature, it must define some of
+these macros in include/asm-XXX/topology.h:
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
+To be consistent on all architectures, include/linux/topology.h
+provides default definitions for any of the above macros that are
+not defined by include/asm-XXX/topology.h:
+1) physical_package_id: -1
+2) core_id: 0
+3) thread_siblings: just the given CPU
+4) core_siblings: just the given CPU
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index 1efe162..3f6d9b0 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -93,47 +93,27 @@ static ssize_t show_##name##_list(struct sys_device *dev, char *buf) \
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
 
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 24f3d22..2158fc0 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -179,4 +179,17 @@ void arch_update_cpu_topology(void);
 #endif
 #endif /* CONFIG_NUMA */
 
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
 #endif /* _LINUX_TOPOLOGY_H */

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
