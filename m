Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbYLACCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbYLACCM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 21:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYLACBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 21:01:55 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49147 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbYLACBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 21:01:54 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Zhang Xiantao <xiantao.zhang@intel.com>, Avi Kivity <avi@qumranet.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [mmotm] fix arch/ia64/kernel/iosapic.c warning
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081201105410.8179.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon,  1 Dec 2008 11:01:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


patch against: mmotm 29 Nov 2008
applied after: linux-next.patch
==
fix following warnings.

arch/ia64/kernel/iosapic.c:708: warning: passing argument 2 of '__cpu_clear' from incompatible pointer type
arch/ia64/kernel/iosapic.c:711: warning: passing argument 1 of '__cpus_weight' from incompatible pointer type
arch/ia64/kernel/iosapic.c:719: warning: passing argument 1 of '__first_cpu' from incompatible pointer type
arch/ia64/kernel/iosapic.c:720: warning: passing argument 2 of '__next_cpu' from incompatible pointer type

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Zhang Xiantao <xiantao.zhang@intel.com>
CC: Avi Kivity <avi@qumranet.com>
CC: "Luck, Tony" <tony.luck@intel.com>
---
 arch/ia64/kernel/iosapic.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: b/arch/ia64/kernel/iosapic.c
===================================================================
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -695,7 +695,7 @@ get_target_cpu (unsigned int gsi, int ir
 #ifdef CONFIG_NUMA
 	{
 		int num_cpus, cpu_index, iosapic_index, numa_cpu, i = 0;
-		const struct cpumask *cpu_mask;
+		struct cpumask *cpu_mask;
 
 		iosapic_index = find_iosapic(gsi);
 		if (iosapic_index < 0 ||
@@ -705,10 +705,10 @@ get_target_cpu (unsigned int gsi, int ir
 		cpu_mask = cpumask_of_node(iosapic_lists[iosapic_index].node);
 		for_each_cpu_and(numa_cpu, cpu_mask, &domain) {
 			if (!cpu_online(numa_cpu))
-				cpu_clear(numa_cpu, cpu_mask);
+				cpu_clear(numa_cpu, *cpu_mask);
 		}
 
-		num_cpus = cpus_weight(cpu_mask);
+		num_cpus = cpus_weight(*cpu_mask);
 
 		if (!num_cpus)
 			goto skip_numa_setup;
@@ -716,8 +716,8 @@ get_target_cpu (unsigned int gsi, int ir
 		/* Use irq assignment to distribute across cpus in node */
 		cpu_index = irq % num_cpus;
 
-		for (numa_cpu = first_cpu(cpu_mask) ; i < cpu_index ; i++)
-			numa_cpu = next_cpu(numa_cpu, cpu_mask);
+		for (numa_cpu = first_cpu(*cpu_mask) ; i < cpu_index ; i++)
+			numa_cpu = next_cpu(numa_cpu, *cpu_mask);
 
 		if (numa_cpu != NR_CPUS)
 			return cpu_physical_id(numa_cpu);


