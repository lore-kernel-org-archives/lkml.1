Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbZH1KAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbZH1KAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 06:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZH1KAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 06:00:32 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:39955 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbZH1KAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 06:00:31 -0400
Subject: [PATCH v2 1/2] cpu: Offline state Framework.
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Date: Fri, 28 Aug 2009 15:30:16 +0530
Message-ID: <20090828100016.10641.62621.stgit@sofia.in.ibm.com>
In-Reply-To: <20090828095741.10641.32053.stgit@sofia.in.ibm.com>
References: <20090828095741.10641.32053.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an interface by which the system administrator can decide what state
should the CPU go to when it is offlined.

To query the hotplug states, on needs to perform a read on the sysfs tunable:
	/sys/devices/system/cpu/cpu<number>/available_hotplug_states

To query or set the current state for a particular CPU, one needs to
use the sysfs interface:
	/sys/devices/system/cpu/cpu<number>/current_state

This patch implements the architecture independent bits of the
cpu-offline-state framework.

Architectures which want to expose the multiple offline-states to the
userspace are expected to write a driver which can register
with this framework.

Such a driver should:
- Implement the callbacks defined in the structure struct cpu_offline_driver
  which can be called into by this framework when the corresponding
  sysfs interfaces are read or written into.

- Ensure that the following operation puts the CPU in the same state
  as it did in the absence of the driver.
	echo 0 > /sys/devices/system/cpu/cpu<number>/online

This framework also serializes the writes to the "current_state"
with respect to with the writes to the "online" sysfs tunable.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 drivers/base/cpu.c  |  176 ++++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/cpu.h |   30 +++++++++
 2 files changed, 197 insertions(+), 9 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index e62a4cc..73efc55 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -20,7 +20,161 @@ EXPORT_SYMBOL(cpu_sysdev_class);
 
 static DEFINE_PER_CPU(struct sys_device *, cpu_sys_devices);
 
+struct sys_device *get_cpu_sysdev(unsigned cpu)
+{
+	if (cpu < nr_cpu_ids && cpu_possible(cpu))
+		return per_cpu(cpu_sys_devices, cpu);
+	else
+		return NULL;
+}
+EXPORT_SYMBOL_GPL(get_cpu_sysdev);
+
+
 #ifdef CONFIG_HOTPLUG_CPU
+
+struct cpu_offline_driver *cpu_offline_driver;
+static DEFINE_MUTEX(cpu_offline_driver_lock);
+
+ssize_t show_available_states(struct sys_device *dev,
+			struct sysdev_attribute *attr, char *buf)
+{
+	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+	int cpu_num = cpu->sysdev.id;
+	ssize_t ret;
+
+	mutex_lock(&cpu_offline_driver_lock);
+	if (!cpu_offline_driver) {
+		ret = -EEXIST;
+		goto out_unlock;
+	}
+
+	ret = cpu_offline_driver->read_available_states(cpu_num, buf);
+
+out_unlock:
+	mutex_unlock(&cpu_offline_driver_lock);
+
+	return ret;
+
+}
+
+ssize_t show_current_state(struct sys_device *dev,
+			struct sysdev_attribute *attr, char *buf)
+{
+	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+	int cpu_num = cpu->sysdev.id;
+	ssize_t ret = 0;
+
+	mutex_lock(&cpu_offline_driver_lock);
+	if (!cpu_offline_driver) {
+		ret = -EEXIST;
+		goto out_unlock;
+	}
+
+	ret = cpu_offline_driver->read_current_state(cpu_num, buf);
+
+out_unlock:
+	mutex_unlock(&cpu_offline_driver_lock);
+
+	return ret;
+}
+
+ssize_t store_current_state(struct sys_device *dev,
+			struct sysdev_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+	int cpu_num = cpu->sysdev.id;
+	ssize_t ret = count;
+
+	mutex_lock(&cpu_offline_driver_lock);
+	if (!cpu_offline_driver) {
+		ret = -EEXIST;
+		goto out_unlock;
+	}
+
+	ret = cpu_offline_driver->write_current_state(cpu_num, buf);
+
+out_unlock:
+	mutex_unlock(&cpu_offline_driver_lock);
+
+	if (ret >= 0)
+		ret = count;
+	return ret;
+}
+
+static SYSDEV_ATTR(available_hotplug_states, 0444, show_available_states,
+								NULL);
+static SYSDEV_ATTR(current_state, 0644, show_current_state,
+						store_current_state);
+
+/* Should be called with cpu_offline_driver_lock held */
+void cpu_offline_driver_add_cpu(struct sys_device *cpu_sys_dev)
+{
+	if (!cpu_offline_driver || !cpu_sys_dev)
+		return;
+
+	sysdev_create_file(cpu_sys_dev, &attr_available_hotplug_states);
+	sysdev_create_file(cpu_sys_dev, &attr_current_state);
+}
+
+/* Should be called with cpu_offline_driver_lock held */
+void cpu_offline_driver_remove_cpu(struct sys_device *cpu_sys_dev)
+{
+	if (!cpu_offline_driver || !cpu_sys_dev)
+		return;
+
+	sysdev_remove_file(cpu_sys_dev, &attr_available_hotplug_states);
+	sysdev_remove_file(cpu_sys_dev, &attr_current_state);
+
+}
+
+int register_cpu_offline_driver(struct cpu_offline_driver *arch_cpu_driver)
+{
+	int ret = 0;
+	int cpu;
+	mutex_lock(&cpu_offline_driver_lock);
+
+	if (cpu_offline_driver != NULL) {
+		ret = -EEXIST;
+		goto out_unlock;
+	}
+
+	if (!(arch_cpu_driver->read_available_states &&
+	      arch_cpu_driver->read_current_state &&
+	      arch_cpu_driver->write_current_state)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	cpu_offline_driver = arch_cpu_driver;
+
+	for_each_possible_cpu(cpu)
+		cpu_offline_driver_add_cpu(get_cpu_sysdev(cpu));
+
+out_unlock:
+	mutex_unlock(&cpu_offline_driver_lock);
+	return ret;
+}
+
+void unregister_cpu_offline_driver(struct cpu_offline_driver *arch_cpu_driver)
+{
+	int cpu;
+	mutex_lock(&cpu_offline_driver_lock);
+
+	if (!cpu_offline_driver) {
+		WARN_ON(1);
+		mutex_unlock(&cpu_offline_driver_lock);
+		return;
+	}
+
+	for_each_possible_cpu(cpu)
+		cpu_offline_driver_remove_cpu(get_cpu_sysdev(cpu));
+
+	cpu_offline_driver = NULL;
+	mutex_unlock(&cpu_offline_driver_lock);
+}
+
+
 static ssize_t show_online(struct sys_device *dev, struct sysdev_attribute *attr,
 			   char *buf)
 {
@@ -35,6 +189,7 @@ static ssize_t __ref store_online(struct sys_device *dev, struct sysdev_attribut
 	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
 	ssize_t ret;
 
+	mutex_lock(&cpu_offline_driver_lock);
 	switch (buf[0]) {
 	case '0':
 		ret = cpu_down(cpu->sysdev.id);
@@ -50,6 +205,8 @@ static ssize_t __ref store_online(struct sys_device *dev, struct sysdev_attribut
 		ret = -EINVAL;
 	}
 
+	mutex_unlock(&cpu_offline_driver_lock);
+
 	if (ret >= 0)
 		ret = count;
 	return ret;
@@ -59,23 +216,33 @@ static SYSDEV_ATTR(online, 0644, show_online, store_online);
 static void __cpuinit register_cpu_control(struct cpu *cpu)
 {
 	sysdev_create_file(&cpu->sysdev, &attr_online);
+	mutex_lock(&cpu_offline_driver_lock);
+	cpu_offline_driver_add_cpu(&cpu->sysdev);
+	mutex_unlock(&cpu_offline_driver_lock);
 }
+
 void unregister_cpu(struct cpu *cpu)
 {
 	int logical_cpu = cpu->sysdev.id;
 
 	unregister_cpu_under_node(logical_cpu, cpu_to_node(logical_cpu));
 
+	mutex_lock(&cpu_offline_driver_lock);
+	cpu_offline_driver_remove_cpu(&cpu->sysdev);
+	mutex_unlock(&cpu_offline_driver_lock);
+
 	sysdev_remove_file(&cpu->sysdev, &attr_online);
 
 	sysdev_unregister(&cpu->sysdev);
 	per_cpu(cpu_sys_devices, logical_cpu) = NULL;
 	return;
 }
+
 #else /* ... !CONFIG_HOTPLUG_CPU */
 static inline void register_cpu_control(struct cpu *cpu)
 {
 }
+
 #endif /* CONFIG_HOTPLUG_CPU */
 
 #ifdef CONFIG_KEXEC
@@ -224,15 +391,6 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
 	return error;
 }
 
-struct sys_device *get_cpu_sysdev(unsigned cpu)
-{
-	if (cpu < nr_cpu_ids && cpu_possible(cpu))
-		return per_cpu(cpu_sys_devices, cpu);
-	else
-		return NULL;
-}
-EXPORT_SYMBOL_GPL(get_cpu_sysdev);
-
 int __init cpu_dev_init(void)
 {
 	int err;
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 4d668e0..7636420 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -51,6 +51,36 @@ struct notifier_block;
 #ifdef CONFIG_HOTPLUG_CPU
 extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
+
+/*
+ * struct cpu_offline_driver: Callbacks for cpu-offline state framework.
+ *
+ * Defines the hooks for the architecture dependent callbacks
+ * which can be invoked when the user queries the
+ * available_hotplug_states and current_state and sets the current_state.
+ *
+ * read_available_state: Called when the user queries available_hotplug_states.
+ * @cpu: Cpu for which available_hotplug_states are being queried.
+ * @buf: Buffer in which the available hotplug states are to be populated.
+ *
+ * read_current_state: Called when the user queries current_state.
+ * @cpu: Cpu for which current_state is being queried.
+ * @buf: Buffer in which the current_state value is to be returned.
+ *
+ * write_current_state: Called when the user wants to set the current_state.
+ * @cpu: Cpu for which the current state is being set.
+ * @buf: Buffer containing the string corresponding to the current_state
+ * that needs to be set.
+ */
+struct cpu_offline_driver {
+	ssize_t (*read_available_states)(unsigned int cpu, char *buf);
+	ssize_t (*read_current_state)(unsigned int cpu, char *buf);
+	ssize_t (*write_current_state)(unsigned int cpu, const char *buf);
+};
+
+extern int register_cpu_offline_driver(struct cpu_offline_driver *driver);
+extern void unregister_cpu_offline_driver(struct cpu_offline_driver *driver);
+
 #else
 
 #ifndef MODULE

