Return-Path: <linux-kernel-owner+w=401wt.eu-S1760330AbZJIIcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330AbZJIIcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760321AbZJIIb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:31:59 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:56979 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbZJIIbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:31:55 -0400
Subject: [PATCH v4 4/4] pseries: Serialize cpu hotplug operations during
	deactivate Vs deallocate
To: Nathan Fontenot <nfont@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
Date: Fri, 09 Oct 2009 14:01:05 +0530
Message-ID: <20091009083105.32381.42354.stgit@sofia.in.ibm.com>
In-Reply-To: <20091009082952.32381.32794.stgit@sofia.in.ibm.com>
References: <20091009082952.32381.32794.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/powerpc/platforms/pseries/dlpar.c |   26 ++++++++++++++++++++++----
 drivers/base/cpu.c                     |    2 ++
 include/linux/cpu.h                    |   13 +++++++++++++
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index 9752386..fc261e6 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -644,6 +644,18 @@ static ssize_t memory_release_store(struct class *class, const char *buf,
 	return rc ? -1 : count;
 }
 
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
 static ssize_t cpu_probe_store(struct class *class, const char *buf,
 			       size_t count)
 {
@@ -656,14 +668,15 @@ static ssize_t cpu_probe_store(struct class *class, const char *buf,
 	if (rc)
 		return -EINVAL;
 
+	cpu_hotplug_driver_lock();
 	rc = acquire_drc(drc_index);
 	if (rc)
-		return rc;
+		goto out;
 
 	dn = configure_connector(drc_index);
 	if (!dn) {
 		release_drc(drc_index);
-		return rc;
+		goto out;
 	}
 
 	/* fixup dn name */
@@ -672,7 +685,8 @@ static ssize_t cpu_probe_store(struct class *class, const char *buf,
 	if (!cpu_name) {
 		free_cc_nodes(dn);
 		release_drc(drc_index);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out;
 	}
 
 	sprintf(cpu_name, "/cpus/%s", dn->full_name);
@@ -684,6 +698,8 @@ static ssize_t cpu_probe_store(struct class *class, const char *buf,
 		release_drc(drc_index);
 
 	rc = online_node_cpus(dn);
+out:
+	cpu_hotplug_driver_unlock();
 
 	return rc ? rc : count;
 }
@@ -705,6 +721,7 @@ static ssize_t cpu_release_store(struct class *class, const char *buf,
 		return -EINVAL;
 	}
 
+	cpu_hotplug_driver_lock();
 	rc = offline_node_cpus(dn);
 
 	if (rc)
@@ -713,7 +730,7 @@ static ssize_t cpu_release_store(struct class *class, const char *buf,
 	rc = release_drc(*drc_index);
 	if (rc) {
 		of_node_put(dn);
-		return rc;
+		goto out;
 	}
 
 	rc = remove_device_tree_nodes(dn);
@@ -723,6 +740,7 @@ static ssize_t cpu_release_store(struct class *class, const char *buf,
 	of_node_put(dn);
 
 out:
+	cpu_hotplug_driver_unlock();
 	return rc ? rc : count;
 }
 
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index e62a4cc..07c3f05 100644
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
index 4753619..b0ad4e1 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -115,6 +115,19 @@ extern void put_online_cpus(void);
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
 int cpu_down(unsigned int cpu);
 
+#ifdef CONFIG_PPC_PSERIES
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

