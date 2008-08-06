Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbYHFPet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbYHFPet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758519AbYHFPd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:33:29 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:43284 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758569AbYHFPdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:33:24 -0400
X-BigFish: VPS3(z5edJz1cddkzz10d3izzz32i63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K56R70-02-ZRN-01
Message-ID: <20080806152319.773811325@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Wed, 6 Aug 2008 17:21:20 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyansky <maxk@qualcomm.com>
CC: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 3/5] [PATCH 3/5] x86: Run Intel ucode-updates via workqueue.
References: <20080806152117.198754464@amd.com>
Content-Disposition: inline;
	filename="0003-x86-Run-Intel-ucode-updates-via-workqueue.patch"
X-OriginalArrivalTime: 06 Aug 2008 15:32:10.0040 (UTC) FILETIME=[976B1380:01C8F7D9]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode.c       |   49 ++++++++++++++----------
 arch/x86/kernel/microcode_intel.c |   74 ++++++++++++++++++++++--------------
 include/asm-x86/microcode.h       |    9 +++-
 3 files changed, 80 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index b797692..0264c76 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -110,6 +110,14 @@ EXPORT_SYMBOL_GPL(microcode_mutex);
 struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
 EXPORT_SYMBOL_GPL(ucode_cpu_info);
 
+struct ucode_work_info ucode_work_info[NR_CPUS];
+EXPORT_SYMBOL_GPL(ucode_work_info);
+
+static inline struct ucode_cpu_info *get_ucode_cpu_info(int cpu)
+{
+	return &ucode_work_info[cpu].uci;
+}
+
 #ifdef CONFIG_MICROCODE_OLD_INTERFACE
 void __user *user_buffer;		/* user area microcode data buffer */
 EXPORT_SYMBOL_GPL(user_buffer);
@@ -238,7 +246,7 @@ static ssize_t reload_store(struct sys_device *dev,
 			    struct sysdev_attribute *attr,
 			    const char *buf, size_t sz)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
+	struct ucode_cpu_info *uci = get_ucode_cpu_info(dev->id);
 	char *end;
 	unsigned long val = simple_strtoul(buf, &end, 0);
 	int err = 0;
@@ -268,7 +276,7 @@ static ssize_t reload_store(struct sys_device *dev,
 static ssize_t version_show(struct sys_device *dev,
 			struct sysdev_attribute *attr, char *buf)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
+	struct ucode_cpu_info *uci = get_ucode_cpu_info(dev->id);
 
 	return sprintf(buf, "0x%x\n", uci->rev);
 }
@@ -276,7 +284,7 @@ static ssize_t version_show(struct sys_device *dev,
 static ssize_t pf_show(struct sys_device *dev,
 			struct sysdev_attribute *attr, char *buf)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
+	struct ucode_cpu_info *uci = get_ucode_cpu_info(dev->id);
 
 	return sprintf(buf, "0x%x\n", uci->pf);
 }
@@ -297,31 +305,22 @@ static struct attribute_group mc_attr_group = {
 	.name = "microcode",
 };
 
-static void microcode_init_cpu(int cpu)
-{
-        cpumask_t old = current->cpus_allowed;
-
-        set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-        microcode_ops->microcode_update_cpu(cpu);
-        set_cpus_allowed_ptr(current, &old);
-}
-
 static int mc_sysdev_add(struct sys_device *sys_dev)
 {
 	int err, cpu = sys_dev->id;
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_work_info *wi = ucode_work_info + cpu;
 
 	if (!cpu_online(cpu))
 		return 0;
 
 	pr_debug("microcode: CPU%d added\n", cpu);
-	memset(uci, 0, sizeof(*uci));
+	memset(&wi->uci, 0, sizeof(wi->uci));
 
 	err = sysfs_create_group(&sys_dev->kobj, &mc_attr_group);
 	if (err)
 		return err;
 
-	microcode_init_cpu(cpu);
+	schedule_work_on(cpu, &wi->work);
 
 	return 0;
 }
@@ -353,12 +352,14 @@ static int mc_sysdev_resume(struct sys_device *dev)
 
 static void microcode_set_cpu_frozen(int cpu)
 {
-        struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_work_info *wi = ucode_work_info + cpu;
+
+	pr_debug("microcode: CPU%d frozen\n", cpu);
 
-        mutex_lock(&microcode_mutex);
-        if (uci->valid)
-                uci->resume = 1;
-        mutex_unlock(&microcode_mutex);
+	mutex_lock(&microcode_mutex);
+	if (wi->uci.valid)
+		wi->resume = 1;
+	mutex_unlock(&microcode_mutex);
 }
 
 static struct sysdev_driver mc_sysdev_driver = {
@@ -377,6 +378,7 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
+		schedule_work_on(cpu, &ucode_work_info[cpu].work);
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		if (sysfs_create_group(&sys_dev->kobj, &mc_attr_group))
@@ -387,6 +389,7 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	case CPU_DOWN_PREPARE_FROZEN:
 		/* Suspend is in progress, only remove the interface */
 		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+		cancel_work_sync(&ucode_work_info[cpu].work);
 		break;
 	case CPU_DEAD:
 	case CPU_UP_CANCELED_FROZEN:
@@ -406,7 +409,7 @@ static struct notifier_block __refdata mc_cpu_notifier = {
 int microcode_init(void *opaque, struct module *module)
 {
 	struct microcode_ops *ops = (struct microcode_ops *)opaque;
-	int error;
+	int error, i;
 
 	if (microcode_ops) {
 		printk(KERN_ERR "microcode: already loaded the other module\n");
@@ -425,6 +428,10 @@ int microcode_init(void *opaque, struct module *module)
 		return PTR_ERR(microcode_pdev);
 	}
 
+	for (i = 0; i < NR_CPUS; i++)
+		INIT_WORK(&ucode_work_info[i].work,
+			  microcode_ops->microcode_update_cpu);
+
 	get_online_cpus();
 	error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
 	put_online_cpus();
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index efe2ee9..4ab6ce3 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -126,6 +126,12 @@ static DEFINE_SPINLOCK(microcode_update_lock);
 extern struct mutex microcode_mutex;
 
 extern struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
+extern struct ucode_work_info ucode_work_info[NR_CPUS];
+
+static inline struct ucode_cpu_info *get_ucode_cpu_info(int cpu)
+{
+	return &ucode_work_info[cpu].uci;
+}
 
 static void collect_cpu_info(int cpu_num, struct ucode_cpu_info *uci)
 {
@@ -159,6 +165,7 @@ static void collect_cpu_info(int cpu_num, struct ucode_cpu_info *uci)
 	sync_core();
 	/* get the current revision from MSR 0x8B */
 	rdmsr(MSR_IA32_UCODE_REV, val[0], uci->rev);
+
 	pr_debug("microcode: collect_cpu_info : sig=0x%x, pf=0x%x, rev=0x%x\n",
 			uci->sig, uci->pf, uci->rev);
 }
@@ -166,7 +173,7 @@ static void collect_cpu_info(int cpu_num, struct ucode_cpu_info *uci)
 static inline int microcode_update_match(int cpu_num,
 	struct microcode_header_intel *mc_header, int sig, int pf)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
+	struct ucode_cpu_info *uci = get_ucode_cpu_info(cpu_num);
 
 	if (!sigmatch(sig, uci->sig, pf, uci->pf)
 		|| mc_header->rev <= uci->rev)
@@ -260,7 +267,7 @@ static int microcode_sanity_check(void *mc)
  */
 static int get_matching_microcode(void *mc, int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_cpu_info *uci = get_ucode_cpu_info(cpu);
 	struct microcode_header_intel *mc_header = mc;
 	struct extended_sigtable *ext_header;
 	unsigned long total_size = get_totalsize(mc_header);
@@ -308,7 +315,7 @@ static void apply_microcode(int cpu)
 	unsigned long flags;
 	unsigned int val[2];
 	int cpu_num = raw_smp_processor_id();
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
+	struct ucode_cpu_info *uci = get_ucode_cpu_info(cpu);
 
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu_num != cpu);
@@ -457,24 +464,28 @@ static int cpu_request_microcode(int cpu)
 
 static void microcode_fini_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	
+	struct ucode_work_info *wi = ucode_work_info + cpu;
+
 	mutex_lock(&microcode_mutex);
-	uci->valid = 0;
-	uci->resume = 0;
-	vfree(uci->mc.mc_intel);
-	uci->mc.mc_intel = NULL;
+	wi->uci.valid = 0;
+	vfree(wi->uci.mc.mc_intel);
+	wi->uci.mc.mc_intel = NULL;
+	wi->resume = 0;
 	mutex_unlock(&microcode_mutex);
 }
 
 static int microcode_resume_cpu(int cpu, struct ucode_cpu_info *new_uci)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_work_info *wi = ucode_work_info + cpu;
+	struct ucode_cpu_info *uci = &wi->uci;
 
-	if (uci->resume)
+	if (!wi->resume)
 		return 0;
 
-	uci->resume = 0;
+	pr_debug("microcode: CPU%d resumed (ucode: %p)\n",
+		 cpu, uci->mc.mc_intel);
+
+	wi->resume = 0;
 
 	/* check if the 'cached' microcode is ok: */
 	if (!uci->mc.mc_intel)
@@ -492,30 +503,35 @@ static int microcode_resume_cpu(int cpu, struct ucode_cpu_info *new_uci)
 	return 1;
 }
 
-void microcode_update_cpu(int cpu)
+static void microcode_update_cpu(struct work_struct *w)
 {
-        struct ucode_cpu_info *uci = ucode_cpu_info + cpu, new_uci;
+	struct ucode_work_info *wi = container_of(w, struct ucode_work_info,
+						  work);
+	int cpu = raw_smp_processor_id(); /* keventd is per-cpu */
+	struct ucode_cpu_info new_uci;
 
-        memset (&new_uci, 0, sizeof(new_uci));
+	pr_debug("microcode: CPU%d workqueue\n", cpu);
 
-        mutex_lock(&microcode_mutex);
+	memset(&new_uci, 0, sizeof(new_uci));
 
-        collect_cpu_info(cpu, &new_uci);
+	mutex_lock(&microcode_mutex);
 
-        if (new_uci.valid) {
-                /*                                                                                                    
-                 * Check if the system resume is in progress,                                                         
-                 * otherwise just request a firmware:                                                                 
-                 */
-                if (!microcode_resume_cpu(cpu, &new_uci)) {
-                        *uci = new_uci;
+	collect_cpu_info(cpu, &new_uci);
 
-                        if (system_state == SYSTEM_RUNNING)
-                                cpu_request_microcode(cpu);
-                }
-        }
+	if (new_uci.valid) {
+                /*
+		 * Check if the system resume is in progress,
+		 * otherwise just request a firmware:
+		 */
+		if (!microcode_resume_cpu(cpu, &new_uci)) {
+			wi->uci = new_uci;
 
-        mutex_unlock(&microcode_mutex);
+			if (system_state == SYSTEM_RUNNING)
+				cpu_request_microcode(cpu);
+		}
+	}
+
+	mutex_unlock(&microcode_mutex);
 }
 
 static struct microcode_ops microcode_intel_ops = {
diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
index fb08022..69388fa 100644
--- a/include/asm-x86/microcode.h
+++ b/include/asm-x86/microcode.h
@@ -64,7 +64,6 @@ struct microcode_amd {
 
 struct ucode_cpu_info {
 	int valid;
-	int resume;
 	unsigned int sig;
 	unsigned int pf;
 	unsigned int rev;
@@ -74,9 +73,15 @@ struct ucode_cpu_info {
 	} mc;
 };
 
+struct ucode_work_info {
+	struct ucode_cpu_info uci;
+	int resume;
+	struct work_struct work;
+};
+
 struct microcode_ops {
 	long (*get_next_ucode)(void **mc, long offset);
-	void (*microcode_update_cpu)(int cpu);
+	void (*microcode_update_cpu)(struct work_struct *w);
 	long (*microcode_get_next_ucode)(void **mc, long offset);
 	int (*get_matching_microcode)(void *mc, int cpu);
 	int (*microcode_sanity_check)(void *mc);
-- 
1.5.4.5




