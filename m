Return-Path: <linux-kernel-owner+w=401wt.eu-S934481AbYEHXDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481AbYEHXDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933143AbYEHXCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:02:43 -0400
Received: from relay2.sgi.com ([192.48.171.30]:34471 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763311AbYEHXCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:02:41 -0400
Message-Id: <20080508230238.649815000@polaris-admin.engr.sgi.com>
References: <20080508230238.468043000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 08 May 2008 16:02:39 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       bunk@kernel.org
Cc: linux-sh@vger.kernel.org, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/1] mm: define default cpu_to_node
Content-Disposition: inline; filename=fix-cpu_to_node
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Some architectures have CONFIG_NUMA=y but do not define a
    default cpu_to_node macro.  This provides the default in
    asm-generic/topology.h but it relies on the fact that
    cpu_to_node is a defined macro (and not an inline function).

    Which means that those architecutures that define cpu_to_node
    as a function are changed to:

    #define cpu_to_node(cpu)  _cpu_to_node(cpu)
    < ... declare the _cpu_to_node(int cpu) function. ... >
    
Based on:
    //git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

Signed-off-by: Mike Travis <travis@sgi.com>

# alpha
Cc: Richard Henderson <rth@twiddle.net>

# powerpc
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>

# sh
Cc: Adrian Bunk <bunk@kernel.org>
Cc: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org

# sparc
Cc: David S. Miller <davem@davemloft.net>
Cc: William L. Irwin <wli@holomorphy.com>

# x86
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-alpha/topology.h   |    3 ++-
 include/asm-generic/topology.h |   11 ++++++++---
 include/asm-powerpc/topology.h |    3 ++-
 include/asm-sparc64/topology.h |    3 ++-
 include/asm-x86/topology.h     |    6 ++++--
 5 files changed, 18 insertions(+), 8 deletions(-)

--- linux-2.6-next.orig/include/asm-alpha/topology.h
+++ linux-2.6-next/include/asm-alpha/topology.h
@@ -6,7 +6,8 @@
 #include <asm/machvec.h>
 
 #ifdef CONFIG_NUMA
-static inline int cpu_to_node(int cpu)
+#define cpu_to_node(cpu) _cpu_to_node(cpu)
+static inline int _cpu_to_node(int cpu)
 {
 	int node;
 	
--- linux-2.6-next.orig/include/asm-generic/topology.h
+++ linux-2.6-next/include/asm-generic/topology.h
@@ -27,13 +27,18 @@
 #ifndef _ASM_GENERIC_TOPOLOGY_H
 #define _ASM_GENERIC_TOPOLOGY_H
 
+/*
+ * cpu_to_node is referenced but not defined in some arch's that
+ * have CONFIG_NUMA=y
+ */
+#ifndef cpu_to_node
+#define cpu_to_node(cpu)	((void)(cpu),0)
+#endif
+
 #ifndef	CONFIG_NUMA
 
 /* Other architectures wishing to use this simple topology API should fill
    in the below functions as appropriate in their own <asm/topology.h> file. */
-#ifndef cpu_to_node
-#define cpu_to_node(cpu)	((void)(cpu),0)
-#endif
 #ifndef parent_node
 #define parent_node(node)	((void)(node),0)
 #endif
--- linux-2.6-next.orig/include/asm-powerpc/topology.h
+++ linux-2.6-next/include/asm-powerpc/topology.h
@@ -10,7 +10,8 @@ struct device_node;
 
 #include <asm/mmzone.h>
 
-static inline int cpu_to_node(int cpu)
+#define cpu_to_node(cpu) _cpu_to_node(cpu)
+static inline int _cpu_to_node(int cpu)
 {
 	return numa_cpu_lookup_table[cpu];
 }
--- linux-2.6-next.orig/include/asm-sparc64/topology.h
+++ linux-2.6-next/include/asm-sparc64/topology.h
@@ -5,7 +5,8 @@
 
 #include <asm/mmzone.h>
 
-static inline int cpu_to_node(int cpu)
+#define cpu_to_node(cpu) _cpu_to_node(cpu)
+static inline int _cpu_to_node(int cpu)
 {
 	return numa_cpu_lookup_table[cpu];
 }
--- linux-2.6-next.orig/include/asm-x86/topology.h
+++ linux-2.6-next/include/asm-x86/topology.h
@@ -53,7 +53,8 @@ extern cpumask_t node_to_cpumask_map[];
 /* Returns the number of the node containing CPU 'cpu' */
 #ifdef CONFIG_X86_32
 #define early_cpu_to_node(cpu)	cpu_to_node(cpu)
-static inline int cpu_to_node(int cpu)
+#define cpu_to_node(cpu) _cpu_to_node(cpu)
+static inline int _cpu_to_node(int cpu)
 {
 	return cpu_to_node_map[cpu];
 }
@@ -76,7 +77,8 @@ static inline int early_cpu_to_node(int 
 #define	early_cpu_to_node(cpu)	cpu_to_node(cpu)
 #endif
 
-static inline int cpu_to_node(int cpu)
+#define cpu_to_node(cpu) _cpu_to_node(cpu)
+static inline int _cpu_to_node(int cpu)
 {
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 	if (x86_cpu_to_node_map_early_ptr) {

-- 
