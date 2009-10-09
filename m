Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbZJIIc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbZJIIc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760314AbZJIIb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:31:57 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:56965 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760285AbZJIIbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:31:50 -0400
Subject: [PATCH v4 3/4] pseries: Add code to online/offline CPUs of a DLPAR
	node.
To: Nathan Fontenot <nfont@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
Date: Fri, 09 Oct 2009 14:01:00 +0530
Message-ID: <20091009083100.32381.1994.stgit@sofia.in.ibm.com>
In-Reply-To: <20091009082952.32381.32794.stgit@sofia.in.ibm.com>
References: <20091009082952.32381.32794.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the cpu-allocation/deallocation on pSeries is a
two step process from the Userspace.

- Set the indicators and update the device tree by writing to the sysfs
  tunable "probe" during allocation and "release" during deallocation.
- Online / Offline the CPUs of the allocated/would_be_deallocated node by
  writing to the sysfs tunable "online".

This patch adds kernel code to online/offline the CPUs soon_after/just_before
they have been allocated/would_be_deallocated. This way, the userspace tool
that performs DLPAR operations would only have to deal with one set of sysfs
tunables namely "probe" and release".

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
---
 arch/powerpc/platforms/pseries/dlpar.c |  103 ++++++++++++++++++++++++++++++++
 1 files changed, 102 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index 84d156b..9752386 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -20,7 +20,7 @@
 #include <linux/sysdev.h>
 #include <linux/sysfs.h>
 #include <linux/cpu.h>
-
+#include "offline_states.h"
 
 #include <asm/prom.h>
 #include <asm/machdep.h>
@@ -357,6 +357,98 @@ int remove_device_tree_nodes(struct device_node *dn)
 	return rc;
 }
 
+int online_node_cpus(struct device_node *dn)
+{
+	int rc = 0;
+	unsigned int cpu;
+	int len, nthreads, i;
+	const u32 *intserv;
+
+	intserv = of_get_property(dn, "ibm,ppc-interrupt-server#s", &len);
+	if (!intserv)
+		return -EINVAL;
+
+	nthreads = len / sizeof(u32);
+
+	cpu_maps_update_begin();
+	for (i = 0; i < nthreads; i++) {
+		for_each_present_cpu(cpu) {
+			if (get_hard_smp_processor_id(cpu) != intserv[i])
+				continue;
+			BUG_ON(get_cpu_current_state(cpu)
+					!= CPU_STATE_OFFLINE);
+			cpu_maps_update_done();
+			rc = cpu_up(cpu);
+			if (rc)
+				goto out;
+			cpu_maps_update_begin();
+
+			break;
+		}
+		if (cpu == num_possible_cpus())
+			printk(KERN_WARNING "Could not find cpu to online "
+			       "with physical id 0x%x\n", intserv[i]);
+	}
+	cpu_maps_update_done();
+
+out:
+	return rc;
+
+}
+
+int offline_node_cpus(struct device_node *dn)
+{
+	int rc = 0;
+	unsigned int cpu;
+	int len, nthreads, i;
+	const u32 *intserv;
+
+	intserv = of_get_property(dn, "ibm,ppc-interrupt-server#s", &len);
+	if (!intserv)
+		return -EINVAL;
+
+	nthreads = len / sizeof(u32);
+
+	cpu_maps_update_begin();
+	for (i = 0; i < nthreads; i++) {
+		for_each_present_cpu(cpu) {
+			if (get_hard_smp_processor_id(cpu) != intserv[i])
+				continue;
+
+			if (get_cpu_current_state(cpu) == CPU_STATE_OFFLINE)
+				break;
+
+			if (get_cpu_current_state(cpu) == CPU_STATE_ONLINE) {
+				cpu_maps_update_done();
+				rc = cpu_down(cpu);
+				if (rc)
+					goto out;
+				cpu_maps_update_begin();
+				break;
+
+			}
+
+			/*
+			 * The cpu is in CPU_STATE_INACTIVE.
+			 * Upgrade it's state to CPU_STATE_OFFLINE.
+			 */
+			set_preferred_offline_state(cpu, CPU_STATE_OFFLINE);
+			BUG_ON(plpar_hcall_norets(H_PROD, intserv[i])
+								!= H_SUCCESS);
+			__cpu_die(cpu);
+			break;
+		}
+		if (cpu == num_possible_cpus())
+			printk(KERN_WARNING "Could not find cpu to offline "
+			       "with physical id 0x%x\n", intserv[i]);
+	}
+	cpu_maps_update_done();
+
+out:
+	return rc;
+
+}
+
 #define DR_ENTITY_SENSE		9003
 #define DR_ENTITY_PRESENT	1
 #define DR_ENTITY_UNUSABLE	2
@@ -591,6 +683,8 @@ static ssize_t cpu_probe_store(struct class *class, const char *buf,
 	if (rc)
 		release_drc(drc_index);
 
+	rc = online_node_cpus(dn);
+
 	return rc ? rc : count;
 }
 
@@ -611,6 +705,11 @@ static ssize_t cpu_release_store(struct class *class, const char *buf,
 		return -EINVAL;
 	}
 
+	rc = offline_node_cpus(dn);
+
+	if (rc)
+		goto out;
+
 	rc = release_drc(*drc_index);
 	if (rc) {
 		of_node_put(dn);
@@ -622,6 +721,8 @@ static ssize_t cpu_release_store(struct class *class, const char *buf,
 		acquire_drc(*drc_index);
 
 	of_node_put(dn);
+
+out:
 	return rc ? rc : count;
 }
 

