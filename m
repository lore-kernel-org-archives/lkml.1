Return-Path: <linux-kernel-owner+w=401wt.eu-S1762186AbYGOCjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762186AbYGOCjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758485AbYGOCe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:34:58 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:19462 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761643AbYGOCez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:34:55 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 07/14] [POWERPC] Populate cpu_enabled_map
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Alex Chiang <achiang@hp.com>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 14 Jul 2008 20:34:20 -0600
Message-ID: <20080715023420.2528.44404.stgit@blender.achiang>
In-Reply-To: <20080715023344.2528.1836.stgit@blender.achiang>
References: <20080715023344.2528.1836.stgit@blender.achiang>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populate the cpu_enabled_map correctly.

Note that this patch does not actually make any decisions based
on the contents of the map.

However, as the map is presented via sysfs in:

	/sys/devices/system/cpu/

It should be populated correctly.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 arch/powerpc/kernel/setup-common.c           |    1 +
 arch/powerpc/platforms/powermac/smp.c        |    1 +
 arch/powerpc/platforms/pseries/hotplug-cpu.c |    2 ++
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index db540ea..a4c894a 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -413,6 +413,7 @@ void __init smp_setup_cpu_maps(void)
 			DBG("    thread %d -> cpu %d (hard id %d)\n",
 			    j, cpu, intserv[j]);
 			cpu_set(cpu, cpu_present_map);
+			cpu_set(cpu, cpu_enabled_map);
 			set_hard_smp_processor_id(cpu, intserv[j]);
 			cpu_set(cpu, cpu_possible_map);
 			cpu++;
diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index cb2d894..a74dada 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -317,6 +317,7 @@ static int __init smp_psurge_probe(void)
 		ncpus = NR_CPUS;
 	for (i = 1; i < ncpus ; ++i) {
 		cpu_set(i, cpu_present_map);
+		cpu_set(i, cpu_enabled_map);
 		set_hard_smp_processor_id(i, i);
 	}
 
diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index 1f03248..e738b07 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -186,6 +186,7 @@ static int pseries_add_processor(struct device_node *np)
 	for_each_cpu_mask(cpu, tmp) {
 		BUG_ON(cpu_isset(cpu, cpu_present_map));
 		cpu_set(cpu, cpu_present_map);
+		cpu_set(cpu, cpu_enabled_map);
 		set_hard_smp_processor_id(cpu, *intserv++);
 	}
 	err = 0;
@@ -218,6 +219,7 @@ static void pseries_remove_processor(struct device_node *np)
 				continue;
 			BUG_ON(cpu_online(cpu));
 			cpu_clear(cpu, cpu_present_map);
+			cpu_clear(cpu, cpu_enabled_map);
 			set_hard_smp_processor_id(cpu, -1);
 			break;
 		}

