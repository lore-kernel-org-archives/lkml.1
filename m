Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbZDQV2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbZDQV2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZDQV2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:28:37 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:58521 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbZDQV2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:28:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jgQ7cb5Rp9GoVcXNajRpALZ8BpfGof40odZ5Xn2i0TZ1XIQSECeOm59pwq9v4o1Aps
         J0P+qRETWdocW4hoS0DrylXMt+XxR6HUthGLXvERRuXHh5GixV6obp0dfReeWmlJygVl
         5AjfnQLFtWYLjVPzTfYICmRqi7T7/ivzGSGlc=
Subject: Re: [PATCH] x86 microcode: revert some work_on_cpu
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 17 Apr 2009 23:28:32 +0200
Message-Id: <1240003712.10641.10.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Disclaimer: it's not even compilation-tested, consider it merely as an
> illustration of an approach. I'll be able to test it later.

And here is the version that works for me.

(Perhaps, will still take another round as some parts seem vague to me.)

---

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index c882664..0389381 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -13,10 +13,16 @@ struct microcode_ops {
 	int  (*request_microcode_user) (int cpu, const void __user *buf, size_t size);
 	int  (*request_microcode_fw) (int cpu, struct device *device);
 
-	void (*apply_microcode) (int cpu);
+	void (*microcode_fini_cpu) (int cpu);
 
+	/* 
+	 * The generic 'microcode_core' part guarantees that
+	 * the callbacks below run on a target cpu when they
+	 * are being called.
+	 * See also the "Synchronization" section in microcode_core.c.
+	 */
+	void (*apply_microcode) (int cpu);
 	int  (*collect_cpu_info) (int cpu, struct cpu_signature *csig);
-	void (*microcode_fini_cpu) (int cpu);
 };
 
 struct ucode_cpu_info {
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 453b579..0900d9c 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -17,7 +17,6 @@
 #include <linux/capability.h>
 #include <linux/miscdevice.h>
 #include <linux/firmware.h>
-#include <linux/spinlock.h>
 #include <linux/cpumask.h>
 #include <linux/pci_ids.h>
 #include <linux/uaccess.h>
@@ -79,9 +78,6 @@ struct microcode_amd {
 #define UCODE_CONTAINER_SECTION_HDR	8
 #define UCODE_CONTAINER_HEADER_SIZE	12
 
-/* serialize access to the physical write */
-static DEFINE_SPINLOCK(microcode_update_lock);
-
 static struct equiv_cpu_entry *equiv_cpu_table;
 
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
@@ -146,7 +142,6 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 
 static void apply_microcode_amd(int cpu)
 {
-	unsigned long flags;
 	u32 rev, dummy;
 	int cpu_num = raw_smp_processor_id();
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
@@ -158,11 +153,9 @@ static void apply_microcode_amd(int cpu)
 	if (mc_amd == NULL)
 		return;
 
-	spin_lock_irqsave(&microcode_update_lock, flags);
 	wrmsrl(MSR_AMD64_PATCH_LOADER, (u64)(long)&mc_amd->hdr.data_code);
 	/* get patch id after patching */
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
-	spin_unlock_irqrestore(&microcode_update_lock, flags);
 
 	/* check current patch id and patch's id for match */
 	if (rev != mc_amd->hdr.patch_id) {
@@ -327,9 +320,6 @@ static int request_microcode_fw(int cpu, struct device *device)
 	const struct firmware *firmware;
 	int ret;
 
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu != raw_smp_processor_id());
-
 	ret = request_firmware(&firmware, fw_name, device);
 	if (ret) {
 		printk(KERN_ERR "microcode: failed to load file %s\n", fw_name);
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 2e0eb41..9ee151f 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -101,36 +101,97 @@ MODULE_LICENSE("GPL");
 
 static struct microcode_ops	*microcode_ops;
 
-/* no concurrent ->write()s are allowed on /dev/cpu/microcode */
+/*
+ * Synchronization.
+ *
+ * All non cpu-hotplug-callback call sites use:
+ *
+ * - microcode_mutex to synchronize with each other;
+ * - get/put_online_cpus() to synchronize with
+ *   the cpu-hotplug-callback call sites.
+ *
+ * We guarantee that only a single cpu is being
+ * updated at any particular moment of time.
+ */
 static DEFINE_MUTEX(microcode_mutex);
 
 struct ucode_cpu_info		ucode_cpu_info[NR_CPUS];
 EXPORT_SYMBOL_GPL(ucode_cpu_info);
 
+/*
+ * Operations that are run on a target cpu: 
+ */
+
+struct collect_for_cpu {
+	struct cpu_signature	*cpu_sig;
+	int			cpu;
+};
+
+static long collect_cpu_info_local(void *arg)
+{
+	struct collect_for_cpu *cfc = arg;
+
+	BUG_ON(cfc->cpu != raw_smp_processor_id());
+
+	return microcode_ops->collect_cpu_info(cfc->cpu, cfc->cpu_sig);
+}
+
+static int collect_cpu_info_on_target(int cpu, struct cpu_signature *cpu_sig)
+{
+	struct collect_for_cpu cfc = { .cpu_sig = cpu_sig, .cpu = cpu };
+
+	return work_on_cpu(cpu, collect_cpu_info_local, &cfc);
+}
+
+static void collect_cpu_info(int cpu)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+
+	memset(uci, 0, sizeof(*uci));
+	if (!collect_cpu_info_on_target(cpu, &uci->cpu_sig))
+		uci->valid = 1;
+}
+
+struct apply_for_cpu {
+	int cpu;
+};
+
+static long apply_microcode_local(void *arg)
+{
+	struct apply_for_cpu *afc = arg;
+
+	BUG_ON(afc->cpu != raw_smp_processor_id());
+	microcode_ops->apply_microcode(afc->cpu);
+
+	return 0;
+}
+
+static int apply_microcode_on_target(int cpu)
+{
+	struct apply_for_cpu afc = { .cpu = cpu };
+
+	return work_on_cpu(cpu, apply_microcode_local, &afc);
+}
+
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
-			goto out;
+			break;
 		if (!error)
-			microcode_ops->apply_microcode(cpu);
+			apply_microcode_on_target(cpu);
 	}
-out:
-	set_cpus_allowed_ptr(current, &old);
+
 	return error;
 }
 
@@ -205,17 +266,16 @@ MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 /* fake device for request_firmware */
 static struct platform_device	*microcode_pdev;
 
-static long reload_for_cpu(void *unused)
+static int reload_for_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + smp_processor_id();
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	int err = 0;
 
 	mutex_lock(&microcode_mutex);
 	if (uci->valid) {
-		err = microcode_ops->request_microcode_fw(smp_processor_id(),
-							  &microcode_pdev->dev);
+		err = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
 		if (!err)
-			microcode_ops->apply_microcode(smp_processor_id());
+			apply_microcode_on_target(cpu);
 	}
 	mutex_unlock(&microcode_mutex);
 	return err;
@@ -235,7 +295,7 @@ static ssize_t reload_store(struct sys_device *dev,
 	if (val == 1) {
 		get_online_cpus();
 		if (cpu_online(cpu))
-			err = work_on_cpu(cpu, reload_for_cpu, NULL);
+			err = reload_for_cpu(cpu);
 		put_online_cpus();
 	}
 	if (err)
@@ -275,7 +335,7 @@ static struct attribute_group mc_attr_group = {
 	.name		= "microcode",
 };
 
-static void __microcode_fini_cpu(int cpu)
+static void microcode_fini_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
@@ -283,85 +343,44 @@ static void __microcode_fini_cpu(int cpu)
 	uci->valid = 0;
 }
 
-static void microcode_fini_cpu(int cpu)
-{
-	mutex_lock(&microcode_mutex);
-	__microcode_fini_cpu(cpu);
-	mutex_unlock(&microcode_mutex);
-}
-
-static void collect_cpu_info(int cpu)
+static void microcode_resume_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
-	memset(uci, 0, sizeof(*uci));
-	if (!microcode_ops->collect_cpu_info(cpu, &uci->cpu_sig))
-		uci->valid = 1;
+	if (!uci->valid || !uci->mc)
+		return;
+
+	pr_debug("microcode: CPU%d updated upon resume\n", cpu);
+	apply_microcode_on_target(cpu);
 }
 
-static int microcode_resume_cpu(int cpu)
+static void microcode_init_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	struct cpu_signature nsig;
+	int err;
 
-	pr_debug("microcode: CPU%d resumed\n", cpu);
+	collect_cpu_info(cpu);
 
-	if (!uci->mc)
-		return 1;
+	if (!uci->valid)
+		return;
+	if (system_state != SYSTEM_RUNNING)
+		return;
 
-	/*
-	 * Let's verify that the 'cached' ucode does belong
-	 * to this cpu (a bit of paranoia):
-	 */
-	if (microcode_ops->collect_cpu_info(cpu, &nsig)) {
-		__microcode_fini_cpu(cpu);
-		printk(KERN_ERR "failed to collect_cpu_info for resuming cpu #%d\n",
-				cpu);
-		return -1;
+	err = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
+	if (!err) {
+		pr_debug("microcode: CPU%d updated upon init\n", cpu);
+		apply_microcode_on_target(cpu);
 	}
-
-	if ((nsig.sig != uci->cpu_sig.sig) || (nsig.pf != uci->cpu_sig.pf)) {
-		__microcode_fini_cpu(cpu);
-		printk(KERN_ERR "cached ucode doesn't match the resuming cpu #%d\n",
-				cpu);
-		/* Should we look for a new ucode here? */
-		return 1;
-	}
-
-	return 0;
 }
 
-static long microcode_update_cpu(void *unused)
+static void microcode_update_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + smp_processor_id();
-	int err = 0;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
-	/*
-	 * Check if the system resume is in progress (uci->valid != NULL),
-	 * otherwise just request a firmware:
-	 */
-	if (uci->valid) {
-		err = microcode_resume_cpu(smp_processor_id());
-	} else {
-		collect_cpu_info(smp_processor_id());
-		if (uci->valid && system_state == SYSTEM_RUNNING)
-			err = microcode_ops->request_microcode_fw(
-					smp_processor_id(),
-					&microcode_pdev->dev);
-	}
-	if (!err)
-		microcode_ops->apply_microcode(smp_processor_id());
-	return err;
-}
-
-static int microcode_init_cpu(int cpu)
-{
-	int err;
-	mutex_lock(&microcode_mutex);
-	err = work_on_cpu(cpu, microcode_update_cpu, NULL);
-	mutex_unlock(&microcode_mutex);
-
-	return err;
+	if (uci->valid)
+		microcode_resume_cpu(cpu);
+	else
+		microcode_init_cpu(cpu);
 }
 
 static int mc_sysdev_add(struct sys_device *sys_dev)
@@ -379,9 +398,10 @@ static int mc_sysdev_add(struct sys_device *sys_dev)
 	if (err)
 		return err;
 
-	err = microcode_init_cpu(cpu);
-	if (err)
-		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+	microcode_init_cpu(cpu);
+	if (!uci->valid)
+		/* can't work with this cpu */
+		err = -1;
 
 	return err;
 }
@@ -402,12 +422,23 @@ static int mc_sysdev_remove(struct sys_device *sys_dev)
 static int mc_sysdev_resume(struct sys_device *dev)
 {
 	int cpu = dev->id;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
 	if (!cpu_online(cpu))
 		return 0;
 
-	/* only CPU 0 will apply ucode here */
-	microcode_update_cpu(NULL);
+	/*
+	 * All non-bootup cpus are still disabled,
+	 * so only CPU 0 will apply ucode here.
+	 *
+	 * Moreover, there can be no concurrent
+	 * updates from any other places at this point.
+	 */
+	WARN_ON(cpu != 0);
+
+	if (uci->valid && uci->mc)
+		microcode_ops->apply_microcode(cpu);
+
 	return 0;
 }
 
@@ -427,9 +458,7 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		if (microcode_init_cpu(cpu))
-			printk(KERN_ERR "microcode: failed to init CPU%d\n",
-			       cpu);
+		microcode_update_cpu(cpu);
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		pr_debug("microcode: CPU%d added\n", cpu);
@@ -471,9 +500,6 @@ static int __init microcode_init(void)
 		return -ENODEV;
 	}
 
-	error = microcode_dev_init();
-	if (error)
-		return error;
 	microcode_pdev = platform_device_register_simple("microcode", -1,
 							 NULL, 0);
 	if (IS_ERR(microcode_pdev)) {
@@ -482,14 +508,26 @@ static int __init microcode_init(void)
 	}
 
 	get_online_cpus();
+	/*
+	 * --dimm. Hmm, we can avoid it if we perhaps first
+	 * try to apply ucode in mc_sysdev_add() and only 
+	 * then create a sysfs group.
+	 */
+	mutex_lock(&microcode_mutex);
 	error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
+	mutex_unlock(&microcode_mutex);
+
 	put_online_cpus();
+
 	if (error) {
-		microcode_dev_exit();
 		platform_device_unregister(microcode_pdev);
 		return error;
 	}
 
+	error = microcode_dev_init();
+	if (error)
+		return error;
+
 	register_hotcpu_notifier(&mc_cpu_notifier);
 
 	printk(KERN_INFO
@@ -507,7 +545,9 @@ static void __exit microcode_exit(void)
 	unregister_hotcpu_notifier(&mc_cpu_notifier);
 
 	get_online_cpus();
+	mutex_lock(&microcode_mutex);
 	sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
+	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
 
 	platform_device_unregister(microcode_pdev);
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 149b9ec..bc824bb 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -75,7 +75,6 @@
 #include <linux/miscdevice.h>
 #include <linux/firmware.h>
 #include <linux/smp_lock.h>
-#include <linux/spinlock.h>
 #include <linux/cpumask.h>
 #include <linux/uaccess.h>
 #include <linux/vmalloc.h>
@@ -150,13 +149,9 @@ struct extended_sigtable {
 
 #define exttable_size(et) ((et)->count * EXT_SIGNATURE_SIZE + EXT_HEADER_SIZE)
 
-/* serialize access to the physical write to MSR 0x79 */
-static DEFINE_SPINLOCK(microcode_update_lock);
-
 static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
-	unsigned long flags;
 	unsigned int val[2];
 
 	memset(csig, 0, sizeof(*csig));
@@ -176,15 +171,11 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 		csig->pf = 1 << ((val[1] >> 18) & 7);
 	}
 
-	/* serialize access to the physical write to MSR 0x79 */
-	spin_lock_irqsave(&microcode_update_lock, flags);
-
 	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
 	/* see notes above for revision 1.07.  Apparent chip bug */
 	sync_core();
 	/* get the current revision from MSR 0x8B */
 	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
-	spin_unlock_irqrestore(&microcode_update_lock, flags);
 
 	pr_debug("microcode: collect_cpu_info : sig=0x%x, pf=0x%x, rev=0x%x\n",
 			csig->sig, csig->pf, csig->rev);
@@ -322,7 +313,6 @@ static void apply_microcode(int cpu)
 {
 	struct microcode_intel *mc_intel;
 	struct ucode_cpu_info *uci;
-	unsigned long flags;
 	unsigned int val[2];
 	int cpu_num;
 
@@ -336,9 +326,6 @@ static void apply_microcode(int cpu)
 	if (mc_intel == NULL)
 		return;
 
-	/* serialize access to the physical write to MSR 0x79 */
-	spin_lock_irqsave(&microcode_update_lock, flags);
-
 	/* write microcode via MSR 0x79 */
 	wrmsr(MSR_IA32_UCODE_WRITE,
 	      (unsigned long) mc_intel->bits,
@@ -351,7 +338,6 @@ static void apply_microcode(int cpu)
 	/* get the current revision from MSR 0x8B */
 	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
 
-	spin_unlock_irqrestore(&microcode_update_lock, flags);
 	if (val[1] != mc_intel->hdr.rev) {
 		printk(KERN_ERR "microcode: CPU%d update from revision "
 				"0x%x to 0x%x failed\n",
@@ -445,8 +431,6 @@ static int request_microcode_fw(int cpu, struct device *device)
 	const struct firmware *firmware;
 	int ret;
 
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu != raw_smp_processor_id());
 	sprintf(name, "intel-ucode/%02x-%02x-%02x",
 		c->x86, c->x86_model, c->x86_mask);
 	ret = request_firmware(&firmware, name, device);
@@ -470,9 +454,6 @@ static int get_ucode_user(void *to, const void *from, size_t n)
 
 static int request_microcode_user(int cpu, const void __user *buf, size_t size)
 {
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu != raw_smp_processor_id());
-
 	return generic_load_microcode(cpu, (void *)buf, size, &get_ucode_user);
 }
 


