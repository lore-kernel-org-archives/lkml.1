Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903Ab0AFGLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0AFGLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 01:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188Ab0AFGLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 01:11:32 -0500
Received: from ozlabs.org ([203.10.76.45]:32963 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab0AFGKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 01:10:44 -0500
Message-Id: <20100106045525.329010098@samba.org>
References: <20100106045509.245662398@samba.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 Jan 2010 15:55:14 +1100
From: Anton Blanchard <anton@samba.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 5/6] sparc: cpumask_of_node() should handle -1 as a node
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcibus_to_node can return -1 if we cannot determine which node a pci bus
is on. If passed -1, cpumask_of_node will negatively index the lookup array
and pull in random data:

# cat /sys/devices/pci0000:00/0000:00:01.0/local_cpus
00000000,00000003,00000000,00000000
# cat /sys/devices/pci0000:00/0000:00:01.0/local_cpulist
64-65

Change cpumask_of_node to check for -1 and return cpu_all_mask in this
case:

# cat /sys/devices/pci0000:00/0000:00:01.0/local_cpus
ffffffff,ffffffff,ffffffff,ffffffff
# cat /sys/devices/pci0000:00/0000:00:01.0/local_cpulist
0-127

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-cpumask/arch/sparc/include/asm/topology_64.h
===================================================================
--- linux-cpumask.orig/arch/sparc/include/asm/topology_64.h	2010-01-06 15:20:22.912584116 +1100
+++ linux-cpumask/arch/sparc/include/asm/topology_64.h	2010-01-06 15:27:17.209419879 +1100
@@ -12,7 +12,9 @@ static inline int cpu_to_node(int cpu)
 
 #define parent_node(node)	(node)
 
-#define cpumask_of_node(node) (&numa_cpumask_lookup_table[node])
+#define cpumask_of_node(node) ((node) == -1 ?				\
+			       cpu_all_mask :				\
+			       &numa_cpumask_lookup_table[node])
 
 struct pci_bus;
 #ifdef CONFIG_PCI

-- 

