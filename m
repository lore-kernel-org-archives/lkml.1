Return-Path: <linux-kernel-owner+w=401wt.eu-S1761351AbYGOCha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761351AbYGOCha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbYGOCe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:34:28 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:39322 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbYGOCe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:34:26 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 08/14] [S390] Populate cpu_enabled_map
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Alex Chiang <achiang@hp.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Mon, 14 Jul 2008 20:34:25 -0600
Message-ID: <20080715023425.2528.9544.stgit@blender.achiang>
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
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 arch/s390/kernel/smp.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 5d4fa4b..f7ae20b 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -458,6 +458,7 @@ static int smp_rescan_cpus_sigp(cpumask_t avail)
 		if (!cpu_stopped(logical_cpu))
 			continue;
 		cpu_set(logical_cpu, cpu_present_map);
+		cpu_set(logical_cpu, cpu_enabled_map);
 		smp_cpu_state[logical_cpu] = CPU_STATE_CONFIGURED;
 		logical_cpu = next_cpu(logical_cpu, avail);
 		if (logical_cpu == NR_CPUS)
@@ -490,6 +491,7 @@ static int smp_rescan_cpus_sclp(cpumask_t avail)
 		__cpu_logical_map[logical_cpu] = cpu_id;
 		smp_cpu_polarization[logical_cpu] = POLARIZATION_UNKNWN;
 		cpu_set(logical_cpu, cpu_present_map);
+		cpu_set(logical_cpu, cpu_enabled_map);
 		if (cpu >= info->configured)
 			smp_cpu_state[logical_cpu] = CPU_STATE_STANDBY;
 		else
@@ -844,6 +846,7 @@ void __init smp_prepare_boot_cpu(void)
 
 	current_thread_info()->cpu = 0;
 	cpu_set(0, cpu_present_map);
+	cpu_set(0, cpu_enabled_map);
 	cpu_set(0, cpu_online_map);
 	S390_lowcore.percpu_offset = __per_cpu_offset[0];
 	current_set[0] = current;
@@ -1104,8 +1107,10 @@ int __ref smp_rescan_cpus(void)
 	cpus_andnot(newcpus, cpu_present_map, newcpus);
 	for_each_cpu_mask(cpu, newcpus) {
 		rc = smp_add_present_cpu(cpu);
-		if (rc)
+		if (rc) {
 			cpu_clear(cpu, cpu_present_map);
+			cpu_clear(cpu, cpu_enabled_map);
+		}
 	}
 	rc = 0;
 out:

