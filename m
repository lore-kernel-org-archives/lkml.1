Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZCITjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZCITjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 15:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZCITjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 15:39:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:5855 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbZCITjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 15:39:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FurhdAXRPgEC5BH8wm386BCLL4rjXf0xoHQOxHx9J6JX5b3E7geJVHyW7yIzYJ85PM
         EbNLFbENGV6PRCtQTWb2+Jt9QipqThPlin322s4sFGL4q/DDpM7/vaafjUx/YZhsy+aP
         Om+vI55wYcG4Km1eswn2bjlabklgUhQjoHdOk=
Subject: x86-microcode: get rid of set_cpus_allowed()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Andreas Herrmann <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 09 Mar 2009 20:38:59 +0100
Message-Id: <1236627539.5168.48.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,


here is a possible candidate for Rusty's cpumask-refactored series.
Note the [*] remark below though.

---


From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

Subject: x86-microcode: get rid of set_cpus_allowed() 

- Get rid of set_cpus_allowed() in the generic 'microcode_core' part and
instead use either smp_call_function_single() or {rd,wr}msr_on_cpu()
in the cpu-specific parts [*];

That said, if need be, the 'struct microcode_ops' callbacks must ensure that
they run on a target cpu.

- Cleanup of the synchronization logic in the 'microcode_core' part

The generic 'microcode_core' part guarantees that only a single cpu is being
updated at any particular moment of time.


[*] regarding the (ugly) call-sites marked with "Sigh, smp_call_function_single() gets upset when called..."

The problem is that smp_call_function_single() does

       /* Can deadlock when called with interrupts disabled */
       WARN_ON(irqs_disabled());

even when (cpu == me) [ for the sake of consistency as I can imagine ]

The warning is harmless in our case (only cpu#0 is running at this point
so this is the "cpu == me" case for smp_call_function_single()) and
originates from the following path:

(suspend_enter() runs with interrupts disabled)

suspend_enter() -> device_power_up() -> ... -> mc_sysdev_resume() ->
microcode_init_cpu(0)

It does make this code look ugly though :-(


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>

---

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index c25fdb3..ff98c97 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -80,15 +80,13 @@ struct microcode_amd {
 #define UCODE_CONTAINER_SECTION_HDR	8
 #define UCODE_CONTAINER_HEADER_SIZE	12
 
-/* serialize access to the physical write */
-static DEFINE_SPINLOCK(microcode_update_lock);
-
 static struct equiv_cpu_entry *equiv_cpu_table;
 
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	u32 dummy;
+	int ret = 0;
 
 	memset(csig, 0, sizeof(*csig));
 	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
@@ -96,9 +94,19 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 		       "supported\n", cpu, c->x86);
 		return -1;
 	}
-	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
+
+	/*
+	 * Sigh, smp_call_function_single() gets upset when called with irqs disabled,
+	 * but it's OK for the mc_sysdev_resume() (cpu == 0) case.
+	 */
+	if (raw_smp_processor_id() == cpu)
+		rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
+	else
+		ret = rdmsr_on_cpu(cpu, MSR_AMD64_PATCH_LEVEL, &csig->rev, &dummy);
+
 	printk(KERN_INFO "microcode: CPU%d: patch_level=0x%x\n", cpu, csig->rev);
-	return 0;
+
+	return ret;
 }
 
 static int get_matching_microcode(int cpu, void *mc, int rev)
@@ -145,37 +153,54 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 	return 1;
 }
 
+struct ucode_am_info {
+	unsigned long data_code;
+	u32 rev;
+};
+
+static void __apply_microcode_amd(void *info)
+{
+	struct ucode_am_info *mi = info;
+	u32 dummy;
+
+	wrmsrl(MSR_AMD64_PATCH_LOADER, mi->data_code);
+	/* get patch id after patching */
+	rdmsr(MSR_AMD64_PATCH_LEVEL, mi->rev, dummy);
+}
+
 static void apply_microcode_amd(int cpu)
 {
-	unsigned long flags;
-	u32 rev, dummy;
-	int cpu_num = raw_smp_processor_id();
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	struct microcode_amd *mc_amd = uci->mc;
-
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu_num != cpu);
+	struct ucode_am_info mi;
+	int ret = 0;
 
 	if (mc_amd == NULL)
 		return;
 
-	spin_lock_irqsave(&microcode_update_lock, flags);
-	wrmsrl(MSR_AMD64_PATCH_LOADER, (u64)(long)&mc_amd->hdr.data_code);
-	/* get patch id after patching */
-	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
-	spin_unlock_irqrestore(&microcode_update_lock, flags);
+	memset(&mi, 0, sizeof(mi));
+	mi.data_code = (unsigned long)&mc_amd->hdr.data_code;
+
+	/*
+	 * Sigh, smp_call_function_single() gets upset when called with irqs disabled,
+	 * but it's OK for the mc_sysdev_resume() (cpu == 0) case.
+	 */
+	if (raw_smp_processor_id() == cpu)
+		__apply_microcode_amd(&mi);
+	else
+		ret = smp_call_function_single(cpu, __apply_microcode_amd, &mi, 1);
 
 	/* check current patch id and patch's id for match */
-	if (rev != mc_amd->hdr.patch_id) {
+	if (ret || mi.rev != mc_amd->hdr.patch_id) {
 		printk(KERN_ERR "microcode: CPU%d: update failed "
 		       "(for patch_level=0x%x)\n", cpu, mc_amd->hdr.patch_id);
 		return;
 	}
 
 	printk(KERN_INFO "microcode: CPU%d: updated (new patch_level=0x%x)\n",
-	       cpu, rev);
+	       cpu, mi.rev);
 
-	uci->cpu_sig.rev = rev;
+	uci->cpu_sig.rev = mi.rev;
 }
 
 static int get_ucode_data(void *to, const u8 *from, size_t n)
@@ -329,9 +354,6 @@ static int request_microcode_fw(int cpu, struct device *device)
 	const struct firmware *firmware;
 	int ret;
 
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu != raw_smp_processor_id());
-
 	ret = request_firmware(&firmware, fw_name, device);
 	if (ret) {
 		printk(KERN_ERR "microcode: failed to load file %s\n", fw_name);
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index c9b721b..caaa2e6 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -101,7 +101,15 @@ MODULE_LICENSE("GPL");
 
 static struct microcode_ops *microcode_ops;
 
-/* no concurrent ->write()s are allowed on /dev/cpu/microcode */
+/*
+ * Synchronization.
+ *
+ * All non cpu-hotplug-callback call sites use:
+ *
+ * - microcode_mutex to synchronize with each other;
+ * - get/put_online_cpus() to synchronize with
+ *   the cpu-hotplug-callback call sites.
+ */
 static DEFINE_MUTEX(microcode_mutex);
 
 struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
@@ -110,19 +118,15 @@ EXPORT_SYMBOL_GPL(ucode_cpu_info);
 #ifdef CONFIG_MICROCODE_OLD_INTERFACE
 static int do_microcode_update(const void __user *buf, size_t size)
 {
-	cpumask_t old;
 	int error = 0;
 	int cpu;
 
-	old = current->cpus_allowed;
-
 	for_each_online_cpu(cpu) {
 		struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
 		if (!uci->valid)
 			continue;
 
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 		error = microcode_ops->request_microcode_user(cpu, buf, size);
 		if (error < 0)
 			goto out;
@@ -130,7 +134,6 @@ static int do_microcode_update(const void __user *buf, size_t size)
 			microcode_ops->apply_microcode(cpu);
 	}
 out:
-	set_cpus_allowed_ptr(current, &old);
 	return error;
 }
 
@@ -218,11 +221,8 @@ static ssize_t reload_store(struct sys_device *dev,
 	if (end == buf)
 		return -EINVAL;
 	if (val == 1) {
-		cpumask_t old = current->cpus_allowed;
-
 		get_online_cpus();
 		if (cpu_online(cpu)) {
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 			mutex_lock(&microcode_mutex);
 			if (uci->valid) {
 				err = microcode_ops->request_microcode_fw(cpu,
@@ -231,7 +231,6 @@ static ssize_t reload_store(struct sys_device *dev,
 					microcode_ops->apply_microcode(cpu);
 			}
 			mutex_unlock(&microcode_mutex);
-			set_cpus_allowed_ptr(current, &old);
 		}
 		put_online_cpus();
 	}
@@ -272,7 +271,7 @@ static struct attribute_group mc_attr_group = {
 	.name = "microcode",
 };
 
-static void __microcode_fini_cpu(int cpu)
+static void microcode_fini_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
@@ -280,13 +279,6 @@ static void __microcode_fini_cpu(int cpu)
 	uci->valid = 0;
 }
 
-static void microcode_fini_cpu(int cpu)
-{
-	mutex_lock(&microcode_mutex);
-	__microcode_fini_cpu(cpu);
-	mutex_unlock(&microcode_mutex);
-}
-
 static void collect_cpu_info(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
@@ -311,14 +303,14 @@ static int microcode_resume_cpu(int cpu)
 	 * to this cpu (a bit of paranoia):
 	 */
 	if (microcode_ops->collect_cpu_info(cpu, &nsig)) {
-		__microcode_fini_cpu(cpu);
+		microcode_fini_cpu(cpu);
 		printk(KERN_ERR "failed to collect_cpu_info for resuming cpu #%d\n",
 				cpu);
 		return -1;
 	}
 
 	if ((nsig.sig != uci->cpu_sig.sig) || (nsig.pf != uci->cpu_sig.pf)) {
-		__microcode_fini_cpu(cpu);
+		microcode_fini_cpu(cpu);
 		printk(KERN_ERR "cached ucode doesn't match the resuming cpu #%d\n",
 				cpu);
 		/* Should we look for a new ucode here? */
@@ -328,7 +320,7 @@ static int microcode_resume_cpu(int cpu)
 	return 0;
 }
 
-static void microcode_update_cpu(int cpu)
+static void microcode_init_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	int err = 0;
@@ -349,21 +341,6 @@ static void microcode_update_cpu(int cpu)
 		microcode_ops->apply_microcode(cpu);
 }
 
-static void microcode_init_cpu(int cpu)
-{
-	cpumask_t old = current->cpus_allowed;
-
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	/* We should bind the task to the CPU */
-	BUG_ON(raw_smp_processor_id() != cpu);
-
-	mutex_lock(&microcode_mutex);
-	microcode_update_cpu(cpu);
-	mutex_unlock(&microcode_mutex);
-
-	set_cpus_allowed_ptr(current, &old);
-}
-
 static int mc_sysdev_add(struct sys_device *sys_dev)
 {
 	int err, cpu = sys_dev->id;
@@ -403,8 +380,16 @@ static int mc_sysdev_resume(struct sys_device *dev)
 	if (!cpu_online(cpu))
 		return 0;
 
-	/* only CPU 0 will apply ucode here */
-	microcode_update_cpu(0);
+	/* 
+	 * All non-bootup cpus are still disabled,
+	 * so only CPU 0 will apply ucode here.
+	 * 
+	 * Moreover, there can be no concurrent
+	 * updates from any other places at this point.
+	 */
+	WARN_ON(cpu != 0);
+
+	microcode_init_cpu(cpu);
 	return 0;
 }
 
@@ -477,8 +462,13 @@ static int __init microcode_init(void)
 	}
 
 	get_online_cpus();
+	mutex_lock(&microcode_mutex);
+
 	error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
+
+	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
+
 	if (error) {
 		microcode_dev_exit();
 		platform_device_unregister(microcode_pdev);
@@ -502,7 +492,11 @@ static void __exit microcode_exit(void)
 	unregister_hotcpu_notifier(&mc_cpu_notifier);
 
 	get_online_cpus();
+	mutex_lock(&microcode_mutex);
+
 	sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
+
+	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
 
 	platform_device_unregister(microcode_pdev);
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index b7f4c92..9dc21dc 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -74,7 +74,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
+#include <linux/smp.h>
 #include <linux/cpumask.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -149,46 +149,64 @@ struct extended_sigtable {
 
 #define exttable_size(et) ((et)->count * EXT_SIGNATURE_SIZE + EXT_HEADER_SIZE)
 
-/* serialize access to the physical write to MSR 0x79 */
-static DEFINE_SPINLOCK(microcode_update_lock);
+struct ucode_cc_info {
+	struct cpu_signature *csig;
+	int do_pf;
+};
 
-static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
+static void __collect_cpu_info(void *info)
 {
-	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
-	unsigned long flags;
+	struct ucode_cc_info *cc = info;
 	unsigned int val[2];
 
+	if (cc->do_pf) {
+		/* get processor flags from MSR 0x17 */
+		rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
+		cc->csig->pf = 1 << ((val[1] >> 18) & 7);
+	}
+
+	wrmsrl(MSR_IA32_UCODE_REV, 0);
+	/* see notes above for revision 1.07.  Apparent chip bug */
+	sync_core();
+	/* get the current revision from MSR 0x8B */
+	rdmsr(MSR_IA32_UCODE_REV, val[0], cc->csig->rev);
+}
+
+static int collect_cpu_info(int cpu, struct cpu_signature *csig)
+{
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	struct ucode_cc_info cc;
+	int ret = 0;
+
 	memset(csig, 0, sizeof(*csig));
 
 	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
 	    cpu_has(c, X86_FEATURE_IA64)) {
 		printk(KERN_ERR "microcode: CPU%d not a capable Intel "
-			"processor\n", cpu_num);
+			"processor\n", cpu);
 		return -1;
 	}
 
 	csig->sig = cpuid_eax(0x00000001);
 
-	if ((c->x86_model >= 5) || (c->x86 > 6)) {
-		/* get processor flags from MSR 0x17 */
-		rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
-		csig->pf = 1 << ((val[1] >> 18) & 7);
-	}
+	cc.do_pf = 0;
+	cc.csig  = csig;
+	if ((c->x86_model >= 5) || (c->x86 > 6))
+		cc.do_pf = 1;
 
-	/* serialize access to the physical write to MSR 0x79 */
-	spin_lock_irqsave(&microcode_update_lock, flags);
-
-	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-	/* see notes above for revision 1.07.  Apparent chip bug */
-	sync_core();
-	/* get the current revision from MSR 0x8B */
-	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
-	spin_unlock_irqrestore(&microcode_update_lock, flags);
+	/*
+	 * Sigh, smp_call_function_single() gets upset when called with irqs disabled,
+	 * but it's OK for the mc_sysdev_resume() (cpu == 0) case.
+	 */
+	if (raw_smp_processor_id() == cpu)
+		__collect_cpu_info(&cc);
+	else
+		ret = smp_call_function_single(cpu, __collect_cpu_info, &cc, 1);
 
 	pr_debug("microcode: collect_cpu_info : sig=0x%x, pf=0x%x, rev=0x%x\n",
 			csig->sig, csig->pf, csig->rev);
 
-	return 0;
+	return ret;
 }
 
 static inline int update_match_cpu(struct cpu_signature *csig, int sig, int pf)
@@ -316,48 +334,59 @@ get_matching_microcode(struct cpu_signature *cpu_sig, void *mc, int rev)
 	return 0;
 }
 
-static void apply_microcode(int cpu)
-{
-	unsigned long flags;
+struct ucode_am_info {
+	unsigned long bits;
 	unsigned int val[2];
-	int cpu_num = raw_smp_processor_id();
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	struct microcode_intel *mc_intel = uci->mc;
-
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu_num != cpu);
-
-	if (mc_intel == NULL)
-		return;
+};
 
-	/* serialize access to the physical write to MSR 0x79 */
-	spin_lock_irqsave(&microcode_update_lock, flags);
+static void __apply_microcode(void *info)
+{
+	struct ucode_am_info *mi = info;
 
 	/* write microcode via MSR 0x79 */
-	wrmsr(MSR_IA32_UCODE_WRITE,
-	      (unsigned long) mc_intel->bits,
-	      (unsigned long) mc_intel->bits >> 16 >> 16);
-	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
+	wrmsrl(MSR_IA32_UCODE_WRITE, mi->bits);
+	wrmsrl(MSR_IA32_UCODE_REV, 0);
 
 	/* see notes above for revision 1.07.  Apparent chip bug */
 	sync_core();
 
 	/* get the current revision from MSR 0x8B */
-	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
+	rdmsr(MSR_IA32_UCODE_REV, mi->val[0], mi->val[1]);
+}
 
-	spin_unlock_irqrestore(&microcode_update_lock, flags);
-	if (val[1] != mc_intel->hdr.rev) {
+static void apply_microcode(int cpu)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct microcode_intel *mc_intel = uci->mc;
+	struct ucode_am_info mi;
+	int ret = 0;
+
+	if (mc_intel == NULL)
+		return;
+
+	mi.bits = (unsigned long)mc_intel->bits;
+
+	/*
+	 * Sigh, smp_call_function_single() gets upset when called with irqs disabled,
+	 * but it's OK for the mc_sysdev_resume() (cpu == 0) case.
+	 */
+	if (raw_smp_processor_id() == cpu)
+		__apply_microcode(&mi);
+	else
+		ret = smp_call_function_single(cpu, __apply_microcode, &mi, 1);
+
+	if (ret || mi.val[1] != mc_intel->hdr.rev) {
 		printk(KERN_ERR "microcode: CPU%d update from revision "
-			"0x%x to 0x%x failed\n", cpu_num, uci->cpu_sig.rev, val[1]);
+			"0x%x to 0x%x failed\n", cpu, uci->cpu_sig.rev, mi.val[1]);
 		return;
 	}
 	printk(KERN_INFO "microcode: CPU%d updated from revision "
 	       "0x%x to 0x%x, date = %04x-%02x-%02x \n",
-		cpu_num, uci->cpu_sig.rev, val[1],
+		cpu, uci->cpu_sig.rev, mi.val[1],
 		mc_intel->hdr.date & 0xffff,
 		mc_intel->hdr.date >> 24,
 		(mc_intel->hdr.date >> 16) & 0xff);
-	uci->cpu_sig.rev = val[1];
+	uci->cpu_sig.rev = mi.val[1];
 }
 
 static int generic_load_microcode(int cpu, void *data, size_t size,
@@ -432,8 +461,6 @@ static int request_microcode_fw(int cpu, struct device *device)
 	const struct firmware *firmware;
 	int ret;
 
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu != raw_smp_processor_id());
 	sprintf(name, "intel-ucode/%02x-%02x-%02x",
 		c->x86, c->x86_model, c->x86_mask);
 	ret = request_firmware(&firmware, name, device);
@@ -457,9 +484,6 @@ static int get_ucode_user(void *to, const void *from, size_t n)
 
 static int request_microcode_user(int cpu, const void __user *buf, size_t size)
 {
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu != raw_smp_processor_id());
-
 	return generic_load_microcode(cpu, (void*)buf, size, &get_ucode_user);
 }
 


