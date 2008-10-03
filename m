Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYJCWwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYJCWwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 18:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYJCWwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 18:52:31 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:58341 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076AbYJCWwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 18:52:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEAO065khMQWq+/2dsb2JhbACBcbo3gWg
Date: Fri, 3 Oct 2008 18:47:25 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       "rth@twiddle.net" <rth@twiddle.net>,
       "paulus@samba.org" <paulus@samba.org>,
       "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "colpatch@us.ibm.com" <colpatch@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       "hch@lst.de" <hch@lst.de>, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] topology.h define mess fix v2
Message-ID: <20081003224725.GA22997@Krystal>
References: <20081002093835.GA17699@elte.hu> <alpine.DEB.1.10.0810021917030.26504@gandalf.stny.rr.com> <20081003045607.GA5940@Krystal> <alpine.DEB.1.10.0810030117280.26504@gandalf.stny.rr.com> <20081003155605.GC1607@Krystal> <alpine.DEB.1.10.0810031223060.26504@gandalf.stny.rr.com> <20081003172143.GA7733@Krystal> <alpine.DEB.1.10.0810031349210.26504@gandalf.stny.rr.com> <20081003185333.GA9626@Krystal> <57C9024A16AD2D4C97DC78E552063EA352D499CB@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA352D499CB@orsmsx505.amr.corp.intel.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:45:13 up 121 days,  3:25,  8 users,  load average: 0.34, 0.15,
	0.19
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luck, Tony (tony.luck@intel.com) wrote:
> > - Major cross-architecture built test is required.
> 
> Some problems on ia64.  With defconfig build (which has
> CONFIG_NUMA=y) I see this:
> 
[...]

Ah, I did not select config "generic" for ia64, and thus did not get
CONFIG_NUMA. Here is a v2 which fixes this.

Thanks for testing this.

Mathieu


topology.h define mess fix v2

Update : build fix for ia64 CONFIG_NUMA.

Original goal : Declare NUMA-less cpu_to_node with a check that the cpu
parameter exists so people without NUMA test configs (namely Steven Rostedt and
myself who ran into this error both in the same day with different
implementations) stop doing this trivial mistake.

End result :

Argh, I think topology.h is utterly broken :-(

Have you noticed the subtile interaction between the

include/asm-x86/topology.h :

#define numa_node_id()          0
#define cpu_to_node(cpu)        0
#define early_cpu_to_node(cpu)  0
...
#include <asm-generic/topology.h>


and
include/asm-generic/topology.h :
#ifndef cpu_to_node
#define cpu_to_node(cpu)        ((void)(cpu),0)
#endif

If any architecture decide for some reason to use a static inline rather
than a define, as currently done with node_to_first_cpu :

include/asm-x86/topology.h :
static inline int node_to_first_cpu(int node)
{
        return first_cpu(cpu_online_map);
}
...
#include <asm-generic/topology.h>

include/asm-generic/topology.h :
#ifndef node_to_first_cpu
#define node_to_first_cpu(node) ((void)(node),0)
#endif

(which will override the static inline !)

It results in an override of the arch-specific version. Nice eh ?

This patch fixes this issue by declaring static inlines in
asm-generic/topology.h and by requiring a _complete_ override of the
topology functions when an architecture needs to override them. An
architecture overriding the topology functions should not include
asm-generic/topology.h anymore.

- alpha needs careful checking, as it did not implement parent_node nor
  node_to_first_cpu previously.
- Major cross-architecture built test is required.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: rth@twiddle.net
CC: tony.luck@intel.com
CC: paulus@samba.org
CC: benh@kernel.crashing.org
CC: lethal@linux-sh.org
---
 arch/alpha/include/asm/topology.h   |   38 +++++++++++++++++++
 arch/ia64/include/asm/topology.h    |   24 ++++++++----
 arch/powerpc/include/asm/topology.h |   12 +++++-
 arch/sh/include/asm/topology.h      |   11 -----
 include/asm-generic/topology.h      |   70 ++++++++++++++++++++----------------
 include/asm-x86/topology.h          |   66 +++++++++++++++++++++++++--------
 6 files changed, 152 insertions(+), 69 deletions(-)

Index: linux-2.6-lttng/include/asm-x86/topology.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/topology.h	2008-10-03 17:58:00.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/topology.h	2008-10-03 17:59:12.000000000 -0400
@@ -38,6 +38,8 @@
 /* Node not present */
 #define NUMA_NO_NODE	(-1)
 
+struct pci_bus;
+
 #ifdef CONFIG_NUMA
 #include <linux/cpumask.h>
 #include <asm/mpspec.h>
@@ -116,7 +118,6 @@ static inline cpumask_t node_to_cpumask(
 
 #endif /* !CONFIG_DEBUG_PER_CPU_MAPS */
 
-/* Replace default node_to_cpumask_ptr with optimized version */
 #define node_to_cpumask_ptr(v, node)		\
 		const cpumask_t *v = _node_to_cpumask_ptr(node)
 
@@ -129,8 +130,14 @@ static inline cpumask_t node_to_cpumask(
  * Returns the number of the node containing Node 'node'. This
  * architecture is flat, so it is a pretty simple function!
  */
-#define parent_node(node) (node)
+static inline int parent_node(int node)
+{
+	return node;
+}
 
+/*
+ * Leave those as defines so we don't have to include linux/pci.h.
+ */
 #define pcibus_to_node(bus) __pcibus_to_node(bus)
 #define pcibus_to_cpumask(bus) __pcibus_to_cpumask(bus)
 
@@ -180,42 +187,67 @@ extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
 #endif
 
+/* Returns the number of the first CPU on Node 'node'. */
+static inline int node_to_first_cpu(int node)
+{
+	node_to_cpumask_ptr(mask, node);
+	return first_cpu(*mask);
+}
+
 #else /* !CONFIG_NUMA */
 
-#define numa_node_id()		0
-#define	cpu_to_node(cpu)	0
-#define	early_cpu_to_node(cpu)	0
+static inline int numa_node_id(void)
+{
+	return 0;
+}
 
-static inline const cpumask_t *_node_to_cpumask_ptr(int node)
+/*
+ * We override asm-generic/topology.h.
+ */
+static inline int cpu_to_node(int cpu)
 {
-	return &cpu_online_map;
+	return 0;
 }
+
+static inline int parent_node(int node)
+{
+	return 0;
+}
+
 static inline cpumask_t node_to_cpumask(int node)
 {
 	return cpu_online_map;
 }
+
 static inline int node_to_first_cpu(int node)
 {
 	return first_cpu(cpu_online_map);
 }
 
+static inline int pcibus_to_node(struct pci_bus *bus)
+{
+	return -1;
+}
+
+static inline cpumask_t pcibus_to_cpumask(struct pci_bus *bus)
+{
+	return pcibus_to_node(bus) == -1 ?
+		CPU_MASK_ALL :
+		node_to_cpumask(pcibus_to_node(bus));
+}
+
+static inline const cpumask_t *_node_to_cpumask_ptr(int node)
+{
+	return &cpu_online_map;
+}
+
 /* Replace default node_to_cpumask_ptr with optimized version */
 #define node_to_cpumask_ptr(v, node)		\
 		const cpumask_t *v = _node_to_cpumask_ptr(node)
 
 #define node_to_cpumask_ptr_next(v, node)	\
 			   v = _node_to_cpumask_ptr(node)
-#endif
-
-#include <asm-generic/topology.h>
 
-#ifdef CONFIG_NUMA
-/* Returns the number of the first CPU on Node 'node'. */
-static inline int node_to_first_cpu(int node)
-{
-	node_to_cpumask_ptr(mask, node);
-	return first_cpu(*mask);
-}
 #endif
 
 extern cpumask_t cpu_coregroup_map(int cpu);
Index: linux-2.6-lttng/arch/alpha/include/asm/topology.h
===================================================================
--- linux-2.6-lttng.orig/arch/alpha/include/asm/topology.h	2008-10-03 17:58:00.000000000 -0400
+++ linux-2.6-lttng/arch/alpha/include/asm/topology.h	2008-10-03 17:59:12.000000000 -0400
@@ -41,7 +41,43 @@ static inline cpumask_t node_to_cpumask(
 
 #define pcibus_to_cpumask(bus)	(cpu_online_map)
 
+struct pci_bus;
+
+static inline int parent_node(int node)
+{
+	return node;
+}
+
+static inline int pcibus_to_node(struct pci_bus *bus)
+{
+	return -1;
+}
+
+static inline cpumask_t pcibus_to_cpumask(struct pci_bus *bus)
+{
+	return pcibus_to_node(bus) == -1 ?
+		CPU_MASK_ALL :
+		node_to_cpumask(pcibus_to_node(bus));
+}
+
+/* returns pointer to cpumask for specified node */
+#define	node_to_cpumask_ptr(v, node) 					\
+		cpumask_t _##v = node_to_cpumask(node);			\
+		const cpumask_t *v = &_##v
+
+#define node_to_cpumask_ptr_next(v, node)				\
+			  _##v = node_to_cpumask(node)
+
+static inline int node_to_first_cpu(int node)
+{
+	node_to_cpumask_ptr(mask, node);
+	return first_cpu(*mask);
+}
+
+#else
+
+#include <asm-generic/topology.h>
+
 #endif /* !CONFIG_NUMA */
-# include <asm-generic/topology.h>
 
 #endif /* _ASM_ALPHA_TOPOLOGY_H */
Index: linux-2.6-lttng/arch/ia64/include/asm/topology.h
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/include/asm/topology.h	2008-10-03 17:58:00.000000000 -0400
+++ linux-2.6-lttng/arch/ia64/include/asm/topology.h	2008-10-03 18:36:47.000000000 -0400
@@ -104,6 +104,23 @@ void build_cpu_to_node_map(void);
 	.nr_balance_failed	= 0,			\
 }
 
+#define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
+					CPU_MASK_ALL : \
+					node_to_cpumask(pcibus_to_node(bus)) \
+				)
+
+/* returns pointer to cpumask for specified node */
+#define	node_to_cpumask_ptr(v, node) 					\
+		cpumask_t _##v = node_to_cpumask(node);			\
+		const cpumask_t *v = &_##v
+
+#define node_to_cpumask_ptr_next(v, node)				\
+			  _##v = node_to_cpumask(node)
+
+#else
+
+#include <asm-generic/topology.h>
+
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_SMP
@@ -116,11 +133,4 @@ void build_cpu_to_node_map(void);
 
 extern void arch_fix_phys_package_id(int num, u32 slot);
 
-#define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
-					CPU_MASK_ALL : \
-					node_to_cpumask(pcibus_to_node(bus)) \
-				)
-
-#include <asm-generic/topology.h>
-
 #endif /* _ASM_IA64_TOPOLOGY_H */
Index: linux-2.6-lttng/arch/powerpc/include/asm/topology.h
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/include/asm/topology.h	2008-10-03 17:58:00.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/include/asm/topology.h	2008-10-03 17:59:12.000000000 -0400
@@ -77,6 +77,14 @@ extern void __init dump_numa_cpu_topolog
 extern int sysfs_add_device_to_node(struct sys_device *dev, int nid);
 extern void sysfs_remove_device_from_node(struct sys_device *dev, int nid);
 
+/* returns pointer to cpumask for specified node */
+#define	node_to_cpumask_ptr(v, node) 					\
+		cpumask_t _##v = node_to_cpumask(node);			\
+		const cpumask_t *v = &_##v
+
+#define node_to_cpumask_ptr_next(v, node)				\
+			  _##v = node_to_cpumask(node)
+
 #else
 
 static inline int of_node_to_nid(struct device_node *device)
@@ -96,10 +104,10 @@ static inline void sysfs_remove_device_f
 {
 }
 
-#endif /* CONFIG_NUMA */
-
 #include <asm-generic/topology.h>
 
+#endif /* CONFIG_NUMA */
+
 #ifdef CONFIG_SMP
 #include <asm/cputable.h>
 #define smt_capable()		(cpu_has_feature(CPU_FTR_SMT))
Index: linux-2.6-lttng/arch/sh/include/asm/topology.h
===================================================================
--- linux-2.6-lttng.orig/arch/sh/include/asm/topology.h	2008-10-03 17:58:00.000000000 -0400
+++ linux-2.6-lttng/arch/sh/include/asm/topology.h	2008-10-03 17:59:12.000000000 -0400
@@ -29,17 +29,6 @@
 	.nr_balance_failed	= 0,			\
 }
 
-#define cpu_to_node(cpu)	((void)(cpu),0)
-#define parent_node(node)	((void)(node),0)
-
-#define node_to_cpumask(node)	((void)node, cpu_online_map)
-#define node_to_first_cpu(node)	((void)(node),0)
-
-#define pcibus_to_node(bus)	((void)(bus), -1)
-#define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
-					CPU_MASK_ALL : \
-					node_to_cpumask(pcibus_to_node(bus)) \
-				)
 #endif
 
 #include <asm-generic/topology.h>
Index: linux-2.6-lttng/include/asm-generic/topology.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/topology.h	2008-10-03 17:58:00.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/topology.h	2008-10-03 17:59:12.000000000 -0400
@@ -27,44 +27,52 @@
 #ifndef _ASM_GENERIC_TOPOLOGY_H
 #define _ASM_GENERIC_TOPOLOGY_H
 
-#ifndef	CONFIG_NUMA
-
-/* Other architectures wishing to use this simple topology API should fill
-   in the below functions as appropriate in their own <asm/topology.h> file. */
-#ifndef cpu_to_node
-#define cpu_to_node(cpu)	((void)(cpu),0)
-#endif
-#ifndef parent_node
-#define parent_node(node)	((void)(node),0)
-#endif
-#ifndef node_to_cpumask
-#define node_to_cpumask(node)	((void)node, cpu_online_map)
-#endif
-#ifndef node_to_first_cpu
-#define node_to_first_cpu(node)	((void)(node),0)
-#endif
-#ifndef pcibus_to_node
-#define pcibus_to_node(bus)	((void)(bus), -1)
-#endif
-
-#ifndef pcibus_to_cpumask
-#define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
-					CPU_MASK_ALL : \
-					node_to_cpumask(pcibus_to_node(bus)) \
-				)
-#endif
-
-#endif	/* CONFIG_NUMA */
+/*
+ * Other architectures wishing to use this simple topology API should fill
+ * in the below functions as appropriate in their own <asm/topology.h> file,
+ * and _don't_ include asm-generic/topology.h.
+ */
+
+struct pci_bus;
+
+static inline int cpu_to_node(int cpu)
+{
+	return 0;
+}
+
+static inline int parent_node(int node)
+{
+	return 0;
+}
+
+static inline cpumask_t node_to_cpumask(int node)
+{
+	return cpu_online_map;
+}
+
+static inline int node_to_first_cpu(int node)
+{
+	return 0;
+}
+
+static inline int pcibus_to_node(struct pci_bus *bus)
+{
+	return -1;
+}
+
+static inline cpumask_t pcibus_to_cpumask(struct pci_bus *bus)
+{
+	return pcibus_to_node(bus) == -1 ?
+		CPU_MASK_ALL :
+		node_to_cpumask(pcibus_to_node(bus));
+}
 
 /* returns pointer to cpumask for specified node */
-#ifndef node_to_cpumask_ptr
-
 #define	node_to_cpumask_ptr(v, node) 					\
 		cpumask_t _##v = node_to_cpumask(node);			\
 		const cpumask_t *v = &_##v
 
 #define node_to_cpumask_ptr_next(v, node)				\
 			  _##v = node_to_cpumask(node)
-#endif
 
 #endif /* _ASM_GENERIC_TOPOLOGY_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
