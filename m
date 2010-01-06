Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729Ab0AFGKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab0AFGKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 01:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509Ab0AFGKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 01:10:42 -0500
Received: from ozlabs.org ([203.10.76.45]:32918 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab0AFGKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 01:10:41 -0500
Message-Id: <20100106045525.207405499@samba.org>
References: <20100106045509.245662398@samba.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 Jan 2010 15:55:13 +1100
From: Anton Blanchard <anton@samba.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 4/6] mips: cpumask_of_node() should handle -1 as a node
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

Index: linux-cpumask/arch/mips/include/asm/mach-ip27/topology.h
===================================================================
--- linux-cpumask.orig/arch/mips/include/asm/mach-ip27/topology.h	2010-01-06 15:20:22.872583883 +1100
+++ linux-cpumask/arch/mips/include/asm/mach-ip27/topology.h	2010-01-06 15:20:47.310083709 +1100
@@ -24,7 +24,9 @@ extern struct cpuinfo_ip27 sn_cpu_info[N
 
 #define cpu_to_node(cpu)	(sn_cpu_info[(cpu)].p_nodeid)
 #define parent_node(node)	(node)
-#define cpumask_of_node(node)	(&hub_data(node)->h_cpus)
+#define cpumask_of_node(node)	((node) == -1 ?				\
+				 cpu_all_mask :				\
+				 &hub_data(node)->h_cpus)
 struct pci_bus;
 extern int pcibus_to_node(struct pci_bus *);
 

-- 

