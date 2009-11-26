Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbZKZT7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbZKZT7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 14:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbZKZT7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 14:59:00 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:46026 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbZKZT66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 14:58:58 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [PATCH v6 1/2] pseries: Add code to online/offline CPUs of a DLPAR
	node
To: Nathan Fontenot <nfont@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Balbir Singh <balbir@in.ibm.com>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Gautham R Shenoy <ego@in.ibm.com>, Vaidy <svaidy@linux.vnet.ibm.com>
Date: Fri, 27 Nov 2009 01:28:55 +0530
Message-ID: <20091126195855.29159.29613.stgit@drishya>
In-Reply-To: <20091126195121.29159.66098.stgit@drishya>
References: <20091126195121.29159.66098.stgit@drishya>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gautham R Shenoy <ego@in.ibm.com>

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
Acked-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 arch/powerpc/platforms/pseries/dlpar.c |  101 ++++++++++++++++++++++++++++++++
 1 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index fe8d4b3..642e1b2 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -16,6 +16,7 @@
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <linux/cpu.h>
+#include "offline_states.h"
 
 #include <asm/prom.h>
 #include <asm/machdep.h>
@@ -287,6 +288,98 @@ int dlpar_detach_node(struct device_node *dn)
 	return 0;
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
@@ -385,6 +478,8 @@ static ssize_t dlpar_cpu_probe(const char *buf, size_t count)
 		dlpar_free_cc_nodes(dn);
 	}
 
+	rc = online_node_cpus(dn);
+
 	return rc ? rc : count;
 }
 
@@ -404,6 +499,12 @@ static ssize_t dlpar_cpu_release(const char *buf, size_t count)
 		return -EINVAL;
 	}
 
+	rc = offline_node_cpus(dn);
+	if (rc) {
+		of_node_put(dn);
+		return -EINVAL;
+	}
+
 	rc = dlpar_release_drc(*drc_index);
 	if (rc) {
 		of_node_put(dn);

