Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbZDUUHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbZDUUHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 16:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZDUUH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 16:07:28 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:59459 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbZDUUH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 16:07:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=M0GwaNonej6jIHvt/l6AHe29ZM1u0UlPmr93JYhCQhDzhuuW/Xn8I2yRw47DxZqPca
         snhLScns//n2uVQEctzxGOJ+4L1CegaRUsDM/7SJUTvK1AMkQz4MBr/Adr5VFn+IGx7p
         0PUI7UAO9OWSj7LmrB76zcJuYyUiZqMuvHFgg=
Subject: Re: [PATCH] x86 microcode: work_on_cpu and cleanup of the
	synchronization logic
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1240258569.6195.8.camel@earth>
References: <1240258569.6195.8.camel@earth>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 22:07:20 +0200
Message-Id: <1240344440.5861.10.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The version below is based on the latest -git.


From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: x86 microcode: work_on_cpu and cleanup of the synchronization logic
    
* Solve an issue described in 6f66cbc63081fd70e3191b4dbb796746780e5ae1
  in a different way, without resorting to set_cpus_allowed();
    
* in fact, only collect_cpu_info and apply_microcode callbacks require to be run
  on a target cpu, others will do just fine on any other cpu.

  We impose this requirement and update all the relevant places;
    
* cleanup of the synchronization logic of the 'microcode_core' part

  The generic 'microcode_core' part guarantees that only a single cpu is being
  updated at any particular moment of time.

  In general, there is no need for any additional sync. logic in arch-specific parts
  (the patch removes existing spinlocks).

  See also the "Synchronization" section in microcode_core.c.
    
* some minor cleanups
    

Remarks:

* BUG_ON() in collect_cpu_info_local() and apply_microcode_local()
  are signs of paranoia. Remove them?
  
  This would also avoid the need for 'cpu' member in struct collect_for_cpu
  and remove struct apply_for_cpu altogether. 

  The reason why apply_for_cpu is there at all, is that gcc spews warnings
  for void* <-> int translations on my setup. Alternatively, define 'cpu' as long?
  (long <-> int or also re-define 'cpu' in callbacks' definitions -> not nice).
  

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Peter Oruba <peter.oruba@amd.com>
CC: Arjan van de Ven <arjan@infradead.org>
CC: Hugh Dickins <hugh@veritas.com>


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
index 98c470c..cddf25e 100644
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
-
-	pr_debug("microcode: CPU%d resumed\n", cpu);
-
-	if (!uci->mc)
-		return 1;
-
-	/*
-	 * Let's verify that the 'cached' ucode does belong
-	 * to this cpu (a bit of paranoia):
-	 */
-	if (microcode_ops->collect_cpu_info(cpu, &nsig)) {
-		__microcode_fini_cpu(cpu);
-		printk(KERN_ERR "failed to collect_cpu_info for resuming cpu #%d\n",
-				cpu);
-		return -1;
-	}
-
-	if ((nsig.sig != uci->cpu_sig.sig) || (nsig.pf != uci->cpu_sig.pf)) {
-		__microcode_fini_cpu(cpu);
-		printk(KERN_ERR "cached ucode doesn't match the resuming cpu #%d\n",
-				cpu);
-		/* Should we look for a new ucode here? */
-		return 1;
-	}
+	int err;
 
-	return 0;
-}
+	collect_cpu_info(cpu);
 
-static long microcode_update_cpu(void *unused)
-{
-	struct ucode_cpu_info *uci = ucode_cpu_info + smp_processor_id();
-	int err = 0;
+	if (!uci->valid)
+		return;
+	if (system_state != SYSTEM_RUNNING)
+		return;
 
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
+	err = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
+	if (!err) {
+		pr_debug("microcode: CPU%d updated upon init\n", cpu);
+		apply_microcode_on_target(cpu);
 	}
-	if (!err)
-		microcode_ops->apply_microcode(smp_processor_id());
-	return err;
 }
 
-static int microcode_init_cpu(int cpu)
+static void microcode_update_cpu(int cpu)
 {
-	int err;
-	mutex_lock(&microcode_mutex);
-	err = work_on_cpu(cpu, microcode_update_cpu, NULL);
-	mutex_unlock(&microcode_mutex);
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
-	return err;
+	if (uci->valid)
+		microcode_resume_cpu(cpu);
+	else
+		microcode_init_cpu(cpu);
 }
 
 static int mc_sysdev_add(struct sys_device *sys_dev)
@@ -379,7 +398,11 @@ static int mc_sysdev_add(struct sys_device *sys_dev)
 	if (err)
 		return err;
 
-	err = microcode_init_cpu(cpu);
+	microcode_init_cpu(cpu);
+	if (!uci->valid) {
+		WARN_ON(1);
+		err = -1
+	}
 
 	return err;
 }
@@ -400,12 +423,23 @@ static int mc_sysdev_remove(struct sys_device *sys_dev)
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
 
@@ -425,9 +459,7 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
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
@@ -469,9 +501,6 @@ static int __init microcode_init(void)
 		return -ENODEV;
 	}
 
-	error = microcode_dev_init();
-	if (error)
-		return error;
 	microcode_pdev = platform_device_register_simple("microcode", -1,
 							 NULL, 0);
 	if (IS_ERR(microcode_pdev)) {
@@ -480,14 +509,26 @@ static int __init microcode_init(void)
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
@@ -505,7 +546,9 @@ static void __exit microcode_exit(void)
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
 


