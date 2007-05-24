Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbXEXMLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbXEXMLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbXEXMKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:10:21 -0400
Received: from il.qumranet.com ([82.166.9.18]:36440 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbXEXMKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:10:18 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com,
       lhcs-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 5/7] KVM: Keep track of which cpus have virtualization enabled
Date: Thu, 24 May 2007 15:10:13 +0300
Message-Id: <11800086154082-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1180008615579-git-send-email-avi@qumranet.com>
References: <1180008615579-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

By keeping track of which cpus have virtualization enabled, we
prevent double-enable or double-disable during hotplug, which is a
very fatal oops.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   47 +++++++++++++++++++++++++++++++++++------------
 1 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 0d89260..9738d51 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -40,6 +40,8 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
+#include <linux/sched.h>
+#include <linux/cpumask.h>
 
 #include "x86_emulate.h"
 #include "segment_descriptor.h"
@@ -50,8 +52,12 @@ MODULE_LICENSE("GPL");
 static DEFINE_SPINLOCK(kvm_lock);
 static LIST_HEAD(vm_list);
 
+static cpumask_t cpus_hardware_enabled;
+
 struct kvm_arch_ops *kvm_arch_ops;
 
+static void hardware_disable(void *ignored);
+
 #define STAT_OFFSET(x) offsetof(struct kvm_vcpu, stat.x)
 
 static struct kvm_stats_debugfs_item {
@@ -2839,7 +2845,7 @@ static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 		 * in vmx root mode.
 		 */
 		printk(KERN_INFO "kvm: exiting hardware virtualization\n");
-		on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
+		on_each_cpu(hardware_disable, NULL, 0, 1);
 	}
 	return NOTIFY_OK;
 }
@@ -2882,6 +2888,27 @@ static void decache_vcpus_on_cpu(int cpu)
 	spin_unlock(&kvm_lock);
 }
 
+static void hardware_enable(void *junk)
+{
+	int cpu = raw_smp_processor_id();
+
+	if (cpu_isset(cpu, cpus_hardware_enabled))
+		return;
+	cpu_set(cpu, cpus_hardware_enabled);
+	kvm_arch_ops->hardware_enable(NULL);
+}
+
+static void hardware_disable(void *junk)
+{
+	int cpu = raw_smp_processor_id();
+
+	if (!cpu_isset(cpu, cpus_hardware_enabled))
+		return;
+	cpu_clear(cpu, cpus_hardware_enabled);
+	decache_vcpus_on_cpu(cpu);
+	kvm_arch_ops->hardware_disable(NULL);
+}
+
 static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 			   void *v)
 {
@@ -2894,16 +2921,13 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	case CPU_UP_CANCELED_FROZEN:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
-		decache_vcpus_on_cpu(cpu);
-		smp_call_function_single(cpu, kvm_arch_ops->hardware_disable,
-					 NULL, 0, 1);
+		smp_call_function_single(cpu, hardware_disable, NULL, 0, 1);
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
-		smp_call_function_single(cpu, kvm_arch_ops->hardware_enable,
-					 NULL, 0, 1);
+		smp_call_function_single(cpu, hardware_enable, NULL, 0, 1);
 		break;
 	}
 	return NOTIFY_OK;
@@ -2960,14 +2984,13 @@ static void kvm_exit_debug(void)
 
 static int kvm_suspend(struct sys_device *dev, pm_message_t state)
 {
-	decache_vcpus_on_cpu(raw_smp_processor_id());
-	on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
+	on_each_cpu(hardware_disable, NULL, 0, 0);
 	return 0;
 }
 
 static int kvm_resume(struct sys_device *dev)
 {
-	on_each_cpu(kvm_arch_ops->hardware_enable, NULL, 0, 1);
+	on_each_cpu(hardware_disable, NULL, 0, 0);
 	return 0;
 }
 
@@ -3020,7 +3043,7 @@ int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 	if (r < 0)
 		goto out;
 
-	on_each_cpu(kvm_arch_ops->hardware_enable, NULL, 0, 1);
+	on_each_cpu(hardware_enable, NULL, 0, 1);
 	r = register_cpu_notifier(&kvm_cpu_notifier);
 	if (r)
 		goto out_free_1;
@@ -3052,7 +3075,7 @@ out_free_2:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 out_free_1:
-	on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
+	on_each_cpu(hardware_disable, NULL, 0, 1);
 	kvm_arch_ops->hardware_unsetup();
 out:
 	kvm_arch_ops = NULL;
@@ -3066,7 +3089,7 @@ void kvm_exit_arch(void)
 	sysdev_class_unregister(&kvm_sysdev_class);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
-	on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
+	on_each_cpu(hardware_disable, NULL, 0, 1);
 	kvm_arch_ops->hardware_unsetup();
 	kvm_arch_ops = NULL;
 }
-- 
1.5.0.6

