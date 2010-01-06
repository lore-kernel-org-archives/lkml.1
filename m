Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172Ab0AFGLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0AFGLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 01:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813Ab0AFGLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 01:11:31 -0500
Received: from ozlabs.org ([203.10.76.45]:32975 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab0AFGKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 01:10:44 -0500
Message-Id: <20100106045525.476396870@samba.org>
References: <20100106045509.245662398@samba.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 Jan 2010 15:55:15 +1100
From: Anton Blanchard <anton@samba.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 6/6] x86: cpumask_of_node() should handle -1 as a node
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

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index c5087d7..cc4f136 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -99,7 +99,8 @@ extern const struct cpumask *cpumask_of_node(int node);
 /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
 static inline const struct cpumask *cpumask_of_node(int node)
 {
-	return node_to_cpumask_map[node];
+	return (node == -1) ? cpu_all_mask :
+		node_to_cpumask_map[node];
 }
 #endif
 
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 550df48..e57a7f5 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -47,6 +47,9 @@ void __init setup_node_to_cpumask_map(void)
  */
 const struct cpumask *cpumask_of_node(int node)
 {
+	if (node == -1)
+		return cpu_all_mask;
+
 	if (node >= nr_node_ids) {
 		printk(KERN_WARNING
 			"cpumask_of_node(%d): node > nr_node_ids(%d)\n",

-- 

