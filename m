Return-Path: <linux-kernel-owner+w=401wt.eu-S934531AbZHEO0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934531AbZHEO0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934290AbZHEO0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:26:05 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:37596 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934466AbZHEO0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:26:02 -0400
Subject: [PATCH 1/3] cpu: Offline state Framework.
To: Joel Schopp <jschopp@austin.ibm.com>, len.brown@intel.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, shaohua.li@intel.com,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Wed, 05 Aug 2009 19:55:58 +0530
Message-ID: <20090805142558.553.44602.stgit@sofia.in.ibm.com>
In-Reply-To: <20090805142311.553.78286.stgit@sofia.in.ibm.com>
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an interface by which the system administrator can decide what state
should the CPU go to when it is offlined.

To query the available offline states, on needs to perform a read on:
/sys/devices/system/cpu/cpu<number>/available_offline_states

To query or set the preferred offline state for a particular CPU, one needs to
use the sysfs interface

/sys/devices/system/cpu/cpu<number>/preferred_offline_state

This patch implements the architecture independent bits of the
cpu-offline-state framework.

The architecture specific bits are expected to register the actual code which
implements the callbacks when the above mentioned sysfs interfaces are read or
written into. Thus the values provided by reading available_offline_states are
expected to vary with the architecture.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 drivers/base/cpu.c  |  111 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cpu.h |   15 +++++++
 2 files changed, 126 insertions(+), 0 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index e62a4cc..1a63de0 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -56,26 +56,137 @@ static ssize_t __ref store_online(struct sys_device *dev, struct sysdev_attribut
 }
 static SYSDEV_ATTR(online, 0644, show_online, store_online);
 
+static struct cpu_offline_driver *cpu_offline_driver;
+static SYSDEV_ATTR(available_offline_states, 0444, NULL, NULL);
+static SYSDEV_ATTR(preferred_offline_state, 0644, NULL, NULL);
+
+/* Should be called with cpu_add_remove_lock held */
+void cpu_offline_driver_add_cpu(struct sys_device *cpu_sys_dev)
+{
+	if (!cpu_offline_driver)
+		return;
+
+	sysdev_create_file(cpu_sys_dev, &attr_available_offline_states);
+	sysdev_create_file(cpu_sys_dev, &attr_preferred_offline_state);
+}
+
+/* Should be called with cpu_add_remove_lock held */
+void cpu_offline_driver_remove_cpu(struct sys_device *cpu_sys_dev)
+{
+	if (!cpu_offline_driver)
+		return;
+
+	sysdev_remove_file(cpu_sys_dev, &attr_available_offline_states);
+	sysdev_remove_file(cpu_sys_dev, &attr_preferred_offline_state);
+
+}
+
 static void __cpuinit register_cpu_control(struct cpu *cpu)
 {
 	sysdev_create_file(&cpu->sysdev, &attr_online);
+	cpu_offline_driver_add_cpu(&cpu->sysdev);
 }
+
 void unregister_cpu(struct cpu *cpu)
 {
 	int logical_cpu = cpu->sysdev.id;
 
 	unregister_cpu_under_node(logical_cpu, cpu_to_node(logical_cpu));
 
+	cpu_offline_driver_remove_cpu(&cpu->sysdev);
 	sysdev_remove_file(&cpu->sysdev, &attr_online);
 
 	sysdev_unregister(&cpu->sysdev);
 	per_cpu(cpu_sys_devices, logical_cpu) = NULL;
 	return;
 }
+
+static int __cpuinit
+cpu_driver_callback(struct notifier_block *nfb, unsigned long action,
+								void *hcpu)
+{
+	struct sys_device *cpu_sysdev = per_cpu(cpu_sys_devices,
+						(unsigned long)(hcpu));
+
+	switch (action) {
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		cpu_offline_driver_remove_cpu(cpu_sysdev);
+		break;
+
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		cpu_offline_driver_add_cpu(cpu_sysdev);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata cpu_driver_notifier = {
+	.notifier_call = cpu_driver_callback,
+	.priority = 0
+};
+
+int register_cpu_offline_driver(struct cpu_offline_driver *arch_cpu_driver)
+{
+	int ret = 0;
+	cpu_maps_update_begin();
+
+	if (cpu_offline_driver != NULL) {
+		ret = -EEXIST;
+		goto out_unlock;
+	}
+
+	if (!(arch_cpu_driver->show_available_states &&
+	      arch_cpu_driver->show_preferred_state &&
+	      arch_cpu_driver->store_preferred_state)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	attr_available_offline_states.show =
+		arch_cpu_driver->show_available_states;
+	attr_preferred_offline_state.show =
+		arch_cpu_driver->show_preferred_state;
+	attr_preferred_offline_state.store =
+		arch_cpu_driver->store_preferred_state;
+
+	cpu_offline_driver = arch_cpu_driver;
+
+out_unlock:
+	cpu_maps_update_done();
+	if (!ret)
+		register_cpu_notifier(&cpu_driver_notifier);
+	return ret;
+}
+
+void unregister_cpu_offline_driver(struct cpu_offline_driver *arch_cpu_driver)
+{
+	cpu_maps_update_begin();
+
+	if (!cpu_offline_driver) {
+		WARN_ON(1);
+		cpu_maps_update_done();
+		return;
+	}
+
+	cpu_offline_driver = NULL;
+	attr_available_offline_states.show = NULL;
+	attr_preferred_offline_state.show = NULL;
+	attr_preferred_offline_state.store = NULL;
+
+	cpu_maps_update_done();
+	unregister_cpu_notifier(&cpu_driver_notifier);
+}
+
 #else /* ... !CONFIG_HOTPLUG_CPU */
 static inline void register_cpu_control(struct cpu *cpu)
 {
 }
+
 #endif /* CONFIG_HOTPLUG_CPU */
 
 #ifdef CONFIG_KEXEC
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 4d668e0..e2150be 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -51,6 +51,21 @@ struct notifier_block;
 #ifdef CONFIG_HOTPLUG_CPU
 extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
+
+struct cpu_offline_driver {
+	ssize_t (*show_available_states)(struct sys_device *dev,
+			struct sysdev_attribute *attr, char *buf);
+	ssize_t (*show_preferred_state)(struct sys_device *dev,
+			struct sysdev_attribute *attr, char *buf);
+
+	ssize_t (*store_preferred_state)(struct sys_device *dev,
+			struct sysdev_attribute *attr,
+			const char *buf, size_t count);
+};
+
+extern int register_cpu_offline_driver(struct cpu_offline_driver *driver);
+extern void unregister_cpu_offline_driver(struct cpu_offline_driver *driver);
+
 #else
 
 #ifndef MODULE

