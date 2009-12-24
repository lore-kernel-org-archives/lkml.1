Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZLXI6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZLXI6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 03:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZLXI6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 03:58:19 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34230 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZLXI6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 03:58:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4B332D7C.7050704@np.css.fujitsu.com>
Date: Thu, 24 Dec 2009 17:59:40 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: tglx@linutronix.de
Cc: mingo@redhat.com, hpa@zytor.com, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: [PATCH-next]Fix wrong local_cpulist displayed
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my machine(Not NUMA), when the CONFIG_NUMA is selected, the value of
local_cpulist is displayed wrong. Because the value of numa_node is -1, so the
wrong address will be returned and the wrong value of local_cpulist is
displayed.

The example on my machine is as following:
Before my patch
        #cd /sys/device/pci0000:00/0000:00:1c.0
        #cat cpulist
                /* nothing */

After my pache
        #cd /sys/device/pci0000:00/0000:00:1c.0
        #cat cpulist
         0-1

I confirmed this patch fixes the above problem.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 arch/x86/include/asm/topology.h |    2 +-
 arch/x86/mm/numa.c              |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index c5087d7..c63921a 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -99,7 +99,7 @@ extern const struct cpumask *cpumask_of_node(int node);
 /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
 static inline const struct cpumask *cpumask_of_node(int node)
 {
-	return node_to_cpumask_map[node];
+	return node == -1 ? cpu_online_mask : node_to_cpumask_map[node];
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
+		return cpu_online_mask;
+
 	if (node >= nr_node_ids) {
 		printk(KERN_WARNING
 			"cpumask_of_node(%d): node > nr_node_ids(%d)\n",
-- 
1.6.4

