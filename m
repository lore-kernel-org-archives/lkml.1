Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZKZT7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZKZT7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 14:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZKZT7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 14:59:11 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:53267 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZKZT7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 14:59:08 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [PATCH v6 2/2] pseries: Serialize cpu hotplug operations during
	deactivate Vs deallocate
To: Nathan Fontenot <nfont@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Balbir Singh <balbir@in.ibm.com>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Gautham R Shenoy <ego@in.ibm.com>, Vaidy <svaidy@linux.vnet.ibm.com>
Date: Fri, 27 Nov 2009 01:29:05 +0530
Message-ID: <20091126195905.29159.82837.stgit@drishya>
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

Currently the cpu-allocation/deallocation process comprises of two steps:
- Set the indicators and to update the device tree with DLPAR node
  information.

- Online/offline the allocated/deallocated CPU.

This is achieved by writing to the sysfs tunables "probe" during allocation
and "release" during deallocation.

At the sametime, the userspace can independently online/offline the CPUs of
the system using the sysfs tunable "online".

It is quite possible that when a userspace tool offlines a CPU
for the purpose of deallocation and is in the process of updating the device
tree, some other userspace tool could bring the CPU back online by writing to
the "online" sysfs tunable thereby causing the deallocate process to fail.

The solution to this is to serialize writes to the "probe/release" sysfs
tunable with the writes to the "online" sysfs tunable.

This patch employs a mutex to provide this serialization, which is a no-op on
all architectures except PPC_PSERIES

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Acked-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 arch/powerpc/platforms/pseries/dlpar.c |   45 +++++++++++++++++++++++++-------
 drivers/base/cpu.c                     |    2 +
 include/linux/cpu.h                    |   13 +++++++++
 3 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index 642e1b2..fd2f0af 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -436,6 +436,18 @@ int dlpar_release_drc(u32 drc_index)
 
 #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
 
+static DEFINE_MUTEX(pseries_cpu_hotplug_mutex);
+
+void cpu_hotplug_driver_lock()
+{
+	mutex_lock(&pseries_cpu_hotplug_mutex);
+}
+
+void cpu_hotplug_driver_unlock()
+{
+	mutex_unlock(&pseries_cpu_hotplug_mutex);
+}
+
 static ssize_t dlpar_cpu_probe(const char *buf, size_t count)
 {
 	struct device_node *dn;
@@ -443,13 +455,18 @@ static ssize_t dlpar_cpu_probe(const char *buf, size_t count)
 	char *cpu_name;
 	int rc;
 
+	cpu_hotplug_driver_lock();
 	rc = strict_strtoul(buf, 0, &drc_index);
-	if (rc)
-		return -EINVAL;
+	if (rc) {
+		rc = -EINVAL;
+		goto out;
+	}
 
 	dn = dlpar_configure_connector(drc_index);
-	if (!dn)
-		return -EINVAL;
+	if (!dn) {
+		rc = -EINVAL;
+		goto out;
+	}
 
 	/* configure-connector reports cpus as living in the base
 	 * directory of the device tree.  CPUs actually live in the
@@ -459,7 +476,8 @@ static ssize_t dlpar_cpu_probe(const char *buf, size_t count)
 			   GFP_KERNEL);
 	if (!cpu_name) {
 		dlpar_free_cc_nodes(dn);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out;
 	}
 
 	sprintf(cpu_name, "/cpus%s", dn->full_name);
@@ -469,7 +487,8 @@ static ssize_t dlpar_cpu_probe(const char *buf, size_t count)
 	rc = dlpar_acquire_drc(drc_index);
 	if (rc) {
 		dlpar_free_cc_nodes(dn);
-		return -EINVAL;
+		rc = -EINVAL;
+		goto out;
 	}
 
 	rc = dlpar_attach_node(dn);
@@ -479,6 +498,8 @@ static ssize_t dlpar_cpu_probe(const char *buf, size_t count)
 	}
 
 	rc = online_node_cpus(dn);
+out:
+	cpu_hotplug_driver_unlock();
 
 	return rc ? rc : count;
 }
@@ -499,26 +520,30 @@ static ssize_t dlpar_cpu_release(const char *buf, size_t count)
 		return -EINVAL;
 	}
 
+	cpu_hotplug_driver_lock();
 	rc = offline_node_cpus(dn);
 	if (rc) {
 		of_node_put(dn);
-		return -EINVAL;
+		rc = -EINVAL;
+		goto out;
 	}
 
 	rc = dlpar_release_drc(*drc_index);
 	if (rc) {
 		of_node_put(dn);
-		return -EINVAL;
+		goto out;
 	}
 
 	rc = dlpar_detach_node(dn);
 	if (rc) {
 		dlpar_acquire_drc(*drc_index);
-		return rc;
+		goto out;
 	}
 
 	of_node_put(dn);
-	return count;
+out:
+	cpu_hotplug_driver_unlock();
+	return rc ? rc : count;
 }
 
 static int __init pseries_dlpar_init(void)
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 7c03af7..27fd775 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -35,6 +35,7 @@ static ssize_t __ref store_online(struct sys_device *dev, struct sysdev_attribut
 	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
 	ssize_t ret;
 
+	cpu_hotplug_driver_lock();
 	switch (buf[0]) {
 	case '0':
 		ret = cpu_down(cpu->sysdev.id);
@@ -49,6 +50,7 @@ static ssize_t __ref store_online(struct sys_device *dev, struct sysdev_attribut
 	default:
 		ret = -EINVAL;
 	}
+	cpu_hotplug_driver_unlock();
 
 	if (ret >= 0)
 		ret = count;
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index c972f7c..e287863 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -117,6 +117,19 @@ extern void put_online_cpus(void);
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
 int cpu_down(unsigned int cpu);
 
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+extern void cpu_hotplug_driver_lock(void);
+extern void cpu_hotplug_driver_unlock(void);
+#else
+static inline void cpu_hotplug_driver_lock(void)
+{
+}
+
+static inline void cpu_hotplug_driver_unlock(void)
+{
+}
+#endif
+
 #else		/* CONFIG_HOTPLUG_CPU */
 
 #define get_online_cpus()	do { } while (0)

