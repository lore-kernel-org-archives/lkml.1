Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbYHFPe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbYHFPe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758518AbYHFPd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:33:28 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:43246 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550AbYHFPdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:33:23 -0400
X-BigFish: VPS12(z5edJ1039oz1cddkzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K56R70-02-ZRK-01
Message-ID: <20080806152319.178515745@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Wed, 6 Aug 2008 17:21:18 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyansky <maxk@qualcomm.com>
CC: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 1/5] [PATCH 1/5] x86: microcode generic updates
References: <20080806152117.198754464@amd.com>
Content-Disposition: inline;
	filename="0001-x86-microcode-generic-updates.patch"
X-OriginalArrivalTime: 06 Aug 2008 15:32:09.0993 (UTC) FILETIME=[9763E790:01C8F7D9]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode.c       |   83 ++++++++++++++-----------------
 arch/x86/kernel/microcode_intel.c |   97 +++++++++++++++++++------------------
 include/asm-x86/microcode.h       |   27 +++++-----
 3 files changed, 101 insertions(+), 106 deletions(-)

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index ad136ad..b797692 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -234,22 +234,6 @@ MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 struct platform_device *microcode_pdev;
 EXPORT_SYMBOL_GPL(microcode_pdev);
 
-static void microcode_init_cpu(int cpu, int resume)
-{
-	cpumask_t old;
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
-	old = current->cpus_allowed;
-
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	mutex_lock(&microcode_mutex);
-	microcode_ops->collect_cpu_info(cpu);
-	if (uci->valid && system_state == SYSTEM_RUNNING && !resume)
-		microcode_ops->cpu_request_microcode(cpu);
-	mutex_unlock(&microcode_mutex);
-	set_cpus_allowed_ptr(current, &old);
-}
-
 static ssize_t reload_store(struct sys_device *dev,
 			    struct sysdev_attribute *attr,
 			    const char *buf, size_t sz)
@@ -266,14 +250,15 @@ static ssize_t reload_store(struct sys_device *dev,
 		cpumask_t old = current->cpus_allowed;
 
 		get_online_cpus();
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-
-		mutex_lock(&microcode_mutex);
-		if (uci->valid)
-			err = microcode_ops->cpu_request_microcode(cpu);
-		mutex_unlock(&microcode_mutex);
+		if (cpu_online(cpu)) {
+			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+			mutex_lock(&microcode_mutex);
+			if (uci->valid)
+				err = microcode_ops->cpu_request_microcode(cpu);
+			mutex_unlock(&microcode_mutex);
+			set_cpus_allowed_ptr(current, &old);
+		}
 		put_online_cpus();
-		set_cpus_allowed_ptr(current, &old);
 	}
 	if (err)
 		return err;
@@ -312,7 +297,16 @@ static struct attribute_group mc_attr_group = {
 	.name = "microcode",
 };
 
-static int __mc_sysdev_add(struct sys_device *sys_dev, int resume)
+static void microcode_init_cpu(int cpu)
+{
+        cpumask_t old = current->cpus_allowed;
+
+        set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+        microcode_ops->microcode_update_cpu(cpu);
+        set_cpus_allowed_ptr(current, &old);
+}
+
+static int mc_sysdev_add(struct sys_device *sys_dev)
 {
 	int err, cpu = sys_dev->id;
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
@@ -327,16 +321,11 @@ static int __mc_sysdev_add(struct sys_device *sys_dev, int resume)
 	if (err)
 		return err;
 
-	microcode_init_cpu(cpu, resume);
+	microcode_init_cpu(cpu);
 
 	return 0;
 }
 
-static int mc_sysdev_add(struct sys_device *sys_dev)
-{
-	return __mc_sysdev_add(sys_dev, 0);
-}
-
 static int mc_sysdev_remove(struct sys_device *sys_dev)
 {
 	int cpu = sys_dev->id;
@@ -362,6 +351,16 @@ static int mc_sysdev_resume(struct sys_device *dev)
 	return 0;
 }
 
+static void microcode_set_cpu_frozen(int cpu)
+{
+        struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+
+        mutex_lock(&microcode_mutex);
+        if (uci->valid)
+                uci->resume = 1;
+        mutex_unlock(&microcode_mutex);
+}
+
 static struct sysdev_driver mc_sysdev_driver = {
 	.add = mc_sysdev_add,
 	.remove = mc_sysdev_remove,
@@ -376,34 +375,26 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 
 	sys_dev = get_cpu_sysdev(cpu);
 	switch (action) {
-	case CPU_UP_CANCELED_FROZEN:
-		/* The CPU refused to come up during a system resume */
-		microcode_ops->microcode_fini_cpu(cpu);
-		break;
 	case CPU_ONLINE:
-	case CPU_DOWN_FAILED:
-		mc_sysdev_add(sys_dev);
-		break;
 	case CPU_ONLINE_FROZEN:
-		/* System-wide resume is in progress, try to apply microcode */
-		if (microcode_ops->apply_microcode_check_cpu(cpu)) {
-			/* The application of microcode failed */
-			microcode_ops->microcode_fini_cpu(cpu);
-			__mc_sysdev_add(sys_dev, 1);
-			break;
-		}
+	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		if (sysfs_create_group(&sys_dev->kobj, &mc_attr_group))
 			printk(KERN_ERR "microcode: Failed to create the sysfs "
 				"group for CPU%d\n", cpu);
 		break;
 	case CPU_DOWN_PREPARE:
-		mc_sysdev_remove(sys_dev);
-		break;
 	case CPU_DOWN_PREPARE_FROZEN:
 		/* Suspend is in progress, only remove the interface */
 		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
 		break;
+	case CPU_DEAD:
+	case CPU_UP_CANCELED_FROZEN:
+		/* The CPU refused to come up during a system resume */
+		microcode_ops->microcode_fini_cpu(cpu);
+		break;
+	case CPU_DEAD_FROZEN:
+		microcode_set_cpu_frozen(cpu);
 	}
 	return NOTIFY_OK;
 }
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index a61986e..efe2ee9 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -127,10 +127,9 @@ extern struct mutex microcode_mutex;
 
 extern struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
 
-static void collect_cpu_info(int cpu_num)
+static void collect_cpu_info(int cpu_num, struct ucode_cpu_info *uci)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
 	unsigned int val[2];
 
 	/* We should bind the task to the CPU */
@@ -456,70 +455,74 @@ static int cpu_request_microcode(int cpu)
 	return error;
 }
 
-static int apply_microcode_check_cpu(int cpu)
+static void microcode_fini_cpu(int cpu)
 {
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	cpumask_t old;
-	unsigned int val[2];
-	int err = 0;
+	
+	mutex_lock(&microcode_mutex);
+	uci->valid = 0;
+	uci->resume = 0;
+	vfree(uci->mc.mc_intel);
+	uci->mc.mc_intel = NULL;
+	mutex_unlock(&microcode_mutex);
+}
 
-	/* Check if the microcode is available */
-	if (!uci->mc.mc_intel)
+static int microcode_resume_cpu(int cpu, struct ucode_cpu_info *new_uci)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+
+	if (uci->resume)
 		return 0;
 
-	old = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	uci->resume = 0;
 
-	/* Check if the microcode we have in memory matches the CPU */
-	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
-	    cpu_has(c, X86_FEATURE_IA64) || uci->sig != cpuid_eax(0x00000001))
-		err = -EINVAL;
-
-	if (!err && ((c->x86_model >= 5) || (c->x86 > 6))) {
-		/* get processor flags from MSR 0x17 */
-		rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
-		if (uci->pf != (1 << ((val[1] >> 18) & 7)))
-			err = -EINVAL;
-	}
-
-	if (!err) {
-		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-		/* see notes above for revision 1.07.  Apparent chip bug */
-		sync_core();
-		/* get the current revision from MSR 0x8B */
-		rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
-		if (uci->rev != val[1])
-			err = -EINVAL;
-	}
+	/* check if the 'cached' microcode is ok: */
+	if (!uci->mc.mc_intel)
+		return 1;
 
-	if (!err)
+	if (new_uci->sig == uci->sig &&
+	    new_uci->pf  == uci->pf &&
+	    new_uci->rev == uci->rev) {
 		apply_microcode(cpu);
-	else
-		printk(KERN_ERR "microcode: Could not apply microcode to CPU%d:"
-			" sig=0x%x, pf=0x%x, rev=0x%x\n",
-			cpu, uci->sig, uci->pf, uci->rev);
+	} else {
+		microcode_fini_cpu(cpu);
+		*uci = *new_uci;
+	}
 
-	set_cpus_allowed_ptr(current, &old);
-	return err;
+	return 1;
 }
 
-static void microcode_fini_cpu(int cpu)
+void microcode_update_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+        struct ucode_cpu_info *uci = ucode_cpu_info + cpu, new_uci;
 
-	mutex_lock(&microcode_mutex);
-	uci->valid = 0;
-	vfree(uci->mc.mc_intel);
-	uci->mc.mc_intel = NULL;
-	mutex_unlock(&microcode_mutex);
+        memset (&new_uci, 0, sizeof(new_uci));
+
+        mutex_lock(&microcode_mutex);
+
+        collect_cpu_info(cpu, &new_uci);
+
+        if (new_uci.valid) {
+                /*                                                                                                    
+                 * Check if the system resume is in progress,                                                         
+                 * otherwise just request a firmware:                                                                 
+                 */
+                if (!microcode_resume_cpu(cpu, &new_uci)) {
+                        *uci = new_uci;
+
+                        if (system_state == SYSTEM_RUNNING)
+                                cpu_request_microcode(cpu);
+                }
+        }
+
+        mutex_unlock(&microcode_mutex);
 }
 
 static struct microcode_ops microcode_intel_ops = {
 	.get_next_ucode                   = get_next_ucode,
+	.microcode_update_cpu             = microcode_update_cpu,
 	.get_matching_microcode           = get_matching_microcode,
 	.microcode_sanity_check           = microcode_sanity_check,
-	.apply_microcode_check_cpu        = apply_microcode_check_cpu,
 	.cpu_request_microcode            = cpu_request_microcode,
 	.collect_cpu_info                 = collect_cpu_info,
 	.apply_microcode                  = apply_microcode,
diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
index 18b2aee..072bef1 100644
--- a/include/asm-x86/microcode.h
+++ b/include/asm-x86/microcode.h
@@ -1,19 +1,6 @@
 extern int microcode_init(void *opaque, struct module *module);
 extern void microcode_exit(void);
 
-struct microcode_ops {
-	long (*get_next_ucode)(void **mc, long offset);
-	long (*microcode_get_next_ucode)(void **mc, long offset);
-	int (*get_matching_microcode)(void *mc, int cpu);
-	int (*apply_microcode_check_cpu)(int cpu);
-	int (*microcode_sanity_check)(void *mc);
-	int (*cpu_request_microcode)(int cpu);
-	void (*collect_cpu_info)(int cpu_num);
-	void (*apply_microcode)(int cpu);
-	void (*microcode_fini_cpu)(int cpu);
-	void (*clear_patch)(void *data);
-};
-
 struct microcode_header_intel {
 	unsigned int            hdrver;
 	unsigned int            rev;
@@ -77,6 +64,7 @@ struct microcode_amd {
 
 struct ucode_cpu_info {
 	int valid;
+	int resume;
 	unsigned int sig;
 	unsigned int pf;
 	unsigned int rev;
@@ -85,3 +73,16 @@ struct ucode_cpu_info {
 		struct microcode_amd *mc_amd;
 	} mc;
 };
+
+struct microcode_ops {
+	long (*get_next_ucode)(void **mc, long offset);
+	void (*microcode_update_cpu)(int cpu);
+	long (*microcode_get_next_ucode)(void **mc, long offset);
+	int (*get_matching_microcode)(void *mc, int cpu);
+	int (*microcode_sanity_check)(void *mc);
+	int (*cpu_request_microcode)(int cpu);
+	void (*collect_cpu_info)(int cpu_num, struct ucode_cpu_info *uci);
+	void (*apply_microcode)(int cpu);
+	void (*microcode_fini_cpu)(int cpu);
+	void (*clear_patch)(void *data);
+};
-- 
1.5.4.5




