Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZIOMHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZIOMHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 08:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZIOMHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 08:07:17 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:40276 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbZIOMHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 08:07:05 -0400
Subject: [PATCH v3 2/3] cpu: Offline state Framework.
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>
Date: Tue, 15 Sep 2009 17:37:06 +0530
Message-ID: <20090915120706.20523.95464.stgit@sofia.in.ibm.com>
In-Reply-To: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an interface by which the system administrator can decide what state
should the CPU go to when it is offlined.

To query the hotplug states, on needs to perform a read on:
/sys/devices/system/cpu/cpu<number>/available_hotplug_states

To query or set the current state for a particular CPU, one needs to
use the sysfs interface

/sys/devices/system/cpu/cpu<number>/current_hotplug_state

This patch implements the architecture independent bits of the
cpu-offline-state framework.

The architecture specific bits are expected to register the actual code which
implements the callbacks when the above mentioned sysfs interfaces are read or
written into. Thus the values provided by reading available_offline_states vary
with the architecture.

The patch provides serialization for writes to the "current_hotplug_state"
with respect to with the writes to the "online" sysfs tunable.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 Documentation/cpu-hotplug.txt |   22 +++++
 drivers/base/cpu.c            |  181 +++++++++++++++++++++++++++++++++++++++--
 include/linux/cpu.h           |   10 ++
 3 files changed, 204 insertions(+), 9 deletions(-)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index 9d620c1..dcec06d 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -115,6 +115,28 @@ Just remember the critical section cannot call any
 function that can sleep or schedule this process away. The preempt_disable()
 will work as long as stop_machine_run() is used to take a cpu down.
 
+CPU-offline states
+--------------------------------------
+On architectures which allow the more than one valid state when
+the CPU goes offline, the system administrator can decide
+the state the CPU needs to go to when it is offlined.
+
+If the architecture has implemented a cpu-offline driver exposing these
+multiple offline states, the system administrator can use the following sysfs
+interfaces to query the available hotplug states and also query and set the
+current hotplug state for a given cpu:
+
+To query the hotplug states, on needs to perform a read on:
+/sys/devices/system/cpu/cpu<number>/available_hotplug_states
+
+To query or set the current state for a particular CPU,
+one needs to use the sysfs interface
+
+/sys/devices/system/cpu/cpu<number>/current_hotplug_state
+
+Writes to the "online" sysfs files are serialized against the writes to the
+"current_hotplug_state" file.
+
 CPU Hotplug - Frequently Asked Questions.
 
 Q: How to enable my kernel to support CPU hotplug?
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index e62a4cc..00c38be 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -20,7 +20,166 @@ EXPORT_SYMBOL(cpu_sysdev_class);
 
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
+ssize_t show_available_hotplug_states(struct sys_device *dev,
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
+ssize_t show_current_hotplug_state(struct sys_device *dev,
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
+ssize_t store_current_hotplug_state(struct sys_device *dev,
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
+static SYSDEV_ATTR(available_hotplug_states, 0444,
+			show_available_hotplug_states, NULL);
+static SYSDEV_ATTR(current_hotplug_state, 0644,
+		show_current_hotplug_state, store_current_hotplug_state);
+
+/* Should be called with cpu_add_remove_lock held */
+void cpu_offline_driver_add_cpu(struct sys_device *cpu_sys_dev)
+{
+	int rc;
+
+	if (!cpu_offline_driver || !cpu_sys_dev)
+		return;
+
+	rc = sysdev_create_file(cpu_sys_dev, &attr_available_hotplug_states);
+	BUG_ON(rc == -EEXIST);
+
+	rc = sysdev_create_file(cpu_sys_dev, &attr_current_hotplug_state);
+	BUG_ON(rc == -EEXIST);
+}
+
+/* Should be called with cpu_add_remove_lock held */
+void cpu_offline_driver_remove_cpu(struct sys_device *cpu_sys_dev)
+{
+	if (!cpu_offline_driver || !cpu_sys_dev)
+		return;
+
+	sysdev_remove_file(cpu_sys_dev, &attr_available_hotplug_states);
+	sysdev_remove_file(cpu_sys_dev, &attr_current_hotplug_state);
+
+}
+
+int register_cpu_offline_driver(struct cpu_offline_driver *arch_cpu_driver)
+{
+	int ret = 0;
+	int cpu;
+
+	mutex_lock(&cpu_offline_driver_lock);
+
+	if (cpu_offline_driver != NULL) {
+		ret = -EEXIST;
+		goto out_unlock;
+	}
+
+	if (WARN_ON(!(arch_cpu_driver->read_available_states &&
+	      arch_cpu_driver->read_current_state &&
+	      arch_cpu_driver->write_current_state))) {
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
+	if (WARN_ON(!cpu_offline_driver)) {
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
@@ -35,6 +194,7 @@ static ssize_t __ref store_online(struct sys_device *dev, struct sysdev_attribut
 	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
 	ssize_t ret;
 
+	mutex_lock(&cpu_offline_driver_lock);
 	switch (buf[0]) {
 	case '0':
 		ret = cpu_down(cpu->sysdev.id);
@@ -50,6 +210,8 @@ static ssize_t __ref store_online(struct sys_device *dev, struct sysdev_attribut
 		ret = -EINVAL;
 	}
 
+	mutex_unlock(&cpu_offline_driver_lock);
+
 	if (ret >= 0)
 		ret = count;
 	return ret;
@@ -59,23 +221,33 @@ static SYSDEV_ATTR(online, 0644, show_online, store_online);
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
@@ -224,15 +396,6 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
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
index 4d668e0..8ac12e8 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -51,6 +51,16 @@ struct notifier_block;
 #ifdef CONFIG_HOTPLUG_CPU
 extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
+
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

