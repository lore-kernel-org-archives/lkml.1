Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZJ3FXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZJ3FXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 01:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbZJ3FXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 01:23:04 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:34237 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346AbZJ3FXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 01:23:02 -0400
Subject: [PATCH v5 4/4] pseries: Serialize cpu hotplug operations during
	deactivate Vs deallocate
To: Nathan Fontenot <nfont@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Balbir Singh <balbir@in.ibm.com>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>
Date: Fri, 30 Oct 2009 10:53:04 +0530
Message-ID: <20091030052304.25493.41341.stgit@sofia.in.ibm.com>
In-Reply-To: <20091030052106.25493.42109.stgit@sofia.in.ibm.com>
References: <20091030052106.25493.42109.stgit@sofia.in.ibm.com>
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
 arch/powerpc/platforms/pseries/dlpar.c |   28 +++++++++++++++++++++++-----
 drivers/base/cpu.c                     |    2 ++
 include/linux/cpu.h                    |   13 +++++++++++++
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index 8e04a69..b6fc6ab 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -501,6 +501,18 @@ int release_drc(u32 drc_index)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
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
@@ -509,18 +521,19 @@ static ssize_t cpu_probe_store(struct class *class, const char *buf,
 	char *cpu_name;
 	int rc;
 
+	cpu_hotplug_driver_lock();
 	rc = strict_strtoul(buf, 0, &drc_index);
 	if (rc)
-		return -EINVAL;
+		goto out;
 
 	rc = acquire_drc(drc_index);
 	if (rc)
-		return -EINVAL;
+		goto out;
 
 	dn = configure_connector(drc_index);
 	if (!dn) {
 		release_drc(drc_index);
-		return -EINVAL;
+		goto out;
 	}
 
 	/* fixup dn name */
@@ -529,7 +542,8 @@ static ssize_t cpu_probe_store(struct class *class, const char *buf,
 	if (!cpu_name) {
 		free_cc_nodes(dn);
 		release_drc(drc_index);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out;
 	}
 
 	sprintf(cpu_name, "/cpus/%s", dn->full_name);
@@ -541,6 +555,8 @@ static ssize_t cpu_probe_store(struct class *class, const char *buf,
 		release_drc(drc_index);
 
 	rc = online_node_cpus(dn);
+out:
+	cpu_hotplug_driver_unlock();
 
 	return rc ? -EINVAL : count;
 }
@@ -562,6 +578,7 @@ static ssize_t cpu_release_store(struct class *class, const char *buf,
 		return -EINVAL;
 	}
 
+	cpu_hotplug_driver_lock();
 	rc = offline_node_cpus(dn);
 
 	if (rc)
@@ -570,7 +587,7 @@ static ssize_t cpu_release_store(struct class *class, const char *buf,
 	rc = release_drc(*drc_index);
 	if (rc) {
 		of_node_put(dn);
-		return -EINVAL;
+		goto out;
 	}
 
 	rc = remove_device_tree_nodes(dn);
@@ -579,6 +596,7 @@ static ssize_t cpu_release_store(struct class *class, const char *buf,
 
 	of_node_put(dn);
 out:
+	cpu_hotplug_driver_unlock();
 	return rc ? -EINVAL : count;
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

