Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbZLJTnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbZLJTnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761624AbZLJTnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:43:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49091 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761622AbZLJTnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:43:06 -0500
Date: Thu, 10 Dec 2009 20:42:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20091210194253.GA2605@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andy Isaacson (2):
      x86: Factor duplicated code out of __show_regs() into show_regs_common()
      x86: Print DMI_BOARD_NAME as well as DMI_PRODUCT_NAME from __show_regs()

Hidetoshi Seto (1):
      x86, mce: fix confusion between bank attributes and mce attributes

Jan Beulich (1):
      x86/mce: Set up timer unconditionally

Joe Perches (6):
      arch/x86/kernel/microcode*: Use pr_fmt() and remove duplicated KERN_ERR prefix
      x86: es7000_32.c: Use pr_<level> and add pr_fmt(fmt)
      x86: setup_percpu.c: Use pr_<level> and add pr_fmt(fmt)
      x86: i8254.c: Add pr_fmt(fmt)
      x86: kmmio.c: Add and use pr_fmt(fmt)
      x86: mmio-mod.c: Use pr_fmt

Joerg Roedel (2):
      x86/amd-iommu: Fix passthrough mode
      x86/amd-iommu: Fix PCI hotplug with passthrough mode

Leann Ogasawara (1):
      x86: ASUS P4S800 reboot=bios quirk

Shaun Patterson (1):
      x86: Fix typo in arch/x86/mm/kmmio.c

Thomas Gleixner (1):
      x86: Fix bogus warning in apic_noop.apic_write()


 arch/x86/include/asm/amd_iommu_proto.h |    4 +-
 arch/x86/include/asm/system.h          |    1 +
 arch/x86/kernel/amd_iommu.c            |   46 +++++++++++++++++++--
 arch/x86/kernel/amd_iommu_init.c       |    9 ++++
 arch/x86/kernel/apic/apic_noop.c       |    2 +-
 arch/x86/kernel/apic/es7000_32.c       |   12 +++--
 arch/x86/kernel/cpu/mcheck/mce.c       |    5 +-
 arch/x86/kernel/microcode_amd.c        |   40 ++++++++---------
 arch/x86/kernel/microcode_core.c       |   26 ++++++-----
 arch/x86/kernel/microcode_intel.c      |   47 +++++++++------------
 arch/x86/kernel/process.c              |   21 +++++++++
 arch/x86/kernel/process_32.c           |   14 +------
 arch/x86/kernel/process_64.c           |   16 +------
 arch/x86/kernel/reboot.c               |    8 ++++
 arch/x86/kernel/setup_percpu.c         |   13 +++---
 arch/x86/kvm/i8254.c                   |   12 +++--
 arch/x86/mm/kmmio.c                    |   42 +++++++++---------
 arch/x86/mm/mmio-mod.c                 |   71 ++++++++++++++++----------------
 18 files changed, 221 insertions(+), 168 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/arch/x86/include/asm/amd_iommu_proto.h
index 84786fb..4d817f9 100644
--- a/arch/x86/include/asm/amd_iommu_proto.h
+++ b/arch/x86/include/asm/amd_iommu_proto.h
@@ -28,7 +28,9 @@ extern void amd_iommu_flush_all_domains(void);
 extern void amd_iommu_flush_all_devices(void);
 extern void amd_iommu_apply_erratum_63(u16 devid);
 extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
-
+extern int amd_iommu_init_devices(void);
+extern void amd_iommu_uninit_devices(void);
+extern void amd_iommu_init_notifier(void);
 #ifndef CONFIG_AMD_IOMMU_STATS
 
 static inline void amd_iommu_stats_init(void) { }
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 022a843..ecb544e 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -23,6 +23,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
 struct tss_struct;
 void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		      struct tss_struct *tss);
+extern void show_regs_common(void);
 
 #ifdef CONFIG_X86_32
 
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 32fb091..a831850 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -166,6 +166,43 @@ static void iommu_uninit_device(struct device *dev)
 {
 	kfree(dev->archdata.iommu);
 }
+
+void __init amd_iommu_uninit_devices(void)
+{
+	struct pci_dev *pdev = NULL;
+
+	for_each_pci_dev(pdev) {
+
+		if (!check_device(&pdev->dev))
+			continue;
+
+		iommu_uninit_device(&pdev->dev);
+	}
+}
+
+int __init amd_iommu_init_devices(void)
+{
+	struct pci_dev *pdev = NULL;
+	int ret = 0;
+
+	for_each_pci_dev(pdev) {
+
+		if (!check_device(&pdev->dev))
+			continue;
+
+		ret = iommu_init_device(&pdev->dev);
+		if (ret)
+			goto out_free;
+	}
+
+	return 0;
+
+out_free:
+
+	amd_iommu_uninit_devices();
+
+	return ret;
+}
 #ifdef CONFIG_AMD_IOMMU_STATS
 
 /*
@@ -1587,6 +1624,11 @@ static struct notifier_block device_nb = {
 	.notifier_call = device_change_notifier,
 };
 
+void amd_iommu_init_notifier(void)
+{
+	bus_register_notifier(&pci_bus_type, &device_nb);
+}
+
 /*****************************************************************************
  *
  * The next functions belong to the dma_ops mapping/unmapping code.
@@ -2145,8 +2187,6 @@ static void prealloc_protection_domains(void)
 		if (!check_device(&dev->dev))
 			continue;
 
-		iommu_init_device(&dev->dev);
-
 		/* Is there already any domain for it? */
 		if (domain_for_device(&dev->dev))
 			continue;
@@ -2215,8 +2255,6 @@ int __init amd_iommu_init_dma_ops(void)
 
 	register_iommu(&amd_iommu_ops);
 
-	bus_register_notifier(&pci_bus_type, &device_nb);
-
 	amd_iommu_stats_init();
 
 	return 0;
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 7ffc399..309a52f 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1274,6 +1274,10 @@ static int __init amd_iommu_init(void)
 	if (ret)
 		goto free;
 
+	ret = amd_iommu_init_devices();
+	if (ret)
+		goto free;
+
 	if (iommu_pass_through)
 		ret = amd_iommu_init_passthrough();
 	else
@@ -1281,6 +1285,8 @@ static int __init amd_iommu_init(void)
 	if (ret)
 		goto free;
 
+	amd_iommu_init_notifier();
+
 	enable_iommus();
 
 	if (iommu_pass_through)
@@ -1296,6 +1302,9 @@ out:
 	return ret;
 
 free:
+
+	amd_iommu_uninit_devices();
+
 	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
 		   get_order(MAX_DOMAIN_ID/8));
 
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index d9acc3b..e31b9ff 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -127,7 +127,7 @@ static u32 noop_apic_read(u32 reg)
 
 static void noop_apic_write(u32 reg, u32 v)
 {
-	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
+	WARN_ON_ONCE(cpu_has_apic && !disable_apic);
 }
 
 struct apic apic_noop = {
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index e85f8fb..dd2b5f2 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -27,6 +27,9 @@
  *
  * http://www.unisys.com
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/notifier.h>
 #include <linux/spinlock.h>
 #include <linux/cpumask.h>
@@ -223,9 +226,9 @@ static int parse_unisys_oem(char *oemptr)
 			mip_addr = val;
 			mip = (struct mip_reg *)val;
 			mip_reg = __va(mip);
-			pr_debug("es7000_mipcfg: host_reg = 0x%lx \n",
+			pr_debug("host_reg = 0x%lx\n",
 				 (unsigned long)host_reg);
-			pr_debug("es7000_mipcfg: mip_reg = 0x%lx \n",
+			pr_debug("mip_reg = 0x%lx\n",
 				 (unsigned long)mip_reg);
 			success++;
 			break;
@@ -401,7 +404,7 @@ static void es7000_enable_apic_mode(void)
 	if (!es7000_plat)
 		return;
 
-	printk(KERN_INFO "ES7000: Enabling APIC mode.\n");
+	pr_info("Enabling APIC mode.\n");
 	memset(&es7000_mip_reg, 0, sizeof(struct mip_reg));
 	es7000_mip_reg.off_0x00 = MIP_SW_APIC;
 	es7000_mip_reg.off_0x38 = MIP_VALID;
@@ -514,8 +517,7 @@ static void es7000_setup_apic_routing(void)
 {
 	int apic = per_cpu(x86_bios_cpu_apicid, smp_processor_id());
 
-	printk(KERN_INFO
-	  "Enabling APIC mode:  %s. Using %d I/O APICs, target cpus %lx\n",
+	pr_info("Enabling APIC mode:  %s. Using %d I/O APICs, target cpus %lx\n",
 		(apic_version[apic] == 0x14) ?
 			"Physical Cluster" : "Logical Cluster",
 		nr_ioapics, cpumask_bits(es7000_target_cpus())[0]);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d7ebf25..a8aacd4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1388,13 +1388,14 @@ static void __mcheck_cpu_init_timer(void)
 	struct timer_list *t = &__get_cpu_var(mce_timer);
 	int *n = &__get_cpu_var(mce_next_interval);
 
+	setup_timer(t, mce_start_timer, smp_processor_id());
+
 	if (mce_ignore_ce)
 		return;
 
 	*n = check_interval * HZ;
 	if (!*n)
 		return;
-	setup_timer(t, mce_start_timer, smp_processor_id());
 	t->expires = round_jiffies(jiffies + *n);
 	add_timer_on(t, smp_processor_id());
 }
@@ -1928,7 +1929,7 @@ error2:
 		sysdev_remove_file(&per_cpu(mce_dev, cpu), &mce_banks[j].attr);
 error:
 	while (--i >= 0)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), &mce_banks[i].attr);
+		sysdev_remove_file(&per_cpu(mce_dev, cpu), mce_attrs[i]);
 
 	sysdev_unregister(&per_cpu(mce_dev, cpu));
 
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 63123d9..37542b6 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -13,6 +13,9 @@
  *  Licensed under the terms of the GNU General Public
  *  License version 2. See file COPYING for details.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/firmware.h>
 #include <linux/pci_ids.h>
 #include <linux/uaccess.h>
@@ -81,7 +84,7 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 
 	memset(csig, 0, sizeof(*csig));
 	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
-	pr_info("microcode: CPU%d: patch_level=0x%x\n", cpu, csig->rev);
+	pr_info("CPU%d: patch_level=0x%x\n", cpu, csig->rev);
 	return 0;
 }
 
@@ -111,8 +114,8 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 
 	/* ucode might be chipset specific -- currently we don't support this */
 	if (mc_header->nb_dev_id || mc_header->sb_dev_id) {
-		pr_err(KERN_ERR "microcode: CPU%d: loading of chipset "
-		       "specific code not yet supported\n", cpu);
+		pr_err("CPU%d: loading of chipset specific code not yet supported\n",
+		       cpu);
 		return 0;
 	}
 
@@ -141,12 +144,12 @@ static int apply_microcode_amd(int cpu)
 
 	/* check current patch id and patch's id for match */
 	if (rev != mc_amd->hdr.patch_id) {
-		pr_err("microcode: CPU%d: update failed "
-		       "(for patch_level=0x%x)\n", cpu, mc_amd->hdr.patch_id);
+		pr_err("CPU%d: update failed (for patch_level=0x%x)\n",
+		       cpu, mc_amd->hdr.patch_id);
 		return -1;
 	}
 
-	pr_info("microcode: CPU%d: updated (new patch_level=0x%x)\n", cpu, rev);
+	pr_info("CPU%d: updated (new patch_level=0x%x)\n", cpu, rev);
 	uci->cpu_sig.rev = rev;
 
 	return 0;
@@ -169,15 +172,14 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 		return NULL;
 
 	if (section_hdr[0] != UCODE_UCODE_TYPE) {
-		pr_err("microcode: error: invalid type field in "
-		       "container file section header\n");
+		pr_err("error: invalid type field in container file section header\n");
 		return NULL;
 	}
 
 	total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
 
 	if (total_size > size || total_size > UCODE_MAX_SIZE) {
-		pr_err("microcode: error: size mismatch\n");
+		pr_err("error: size mismatch\n");
 		return NULL;
 	}
 
@@ -206,14 +208,13 @@ static int install_equiv_cpu_table(const u8 *buf)
 	size = buf_pos[2];
 
 	if (buf_pos[1] != UCODE_EQUIV_CPU_TABLE_TYPE || !size) {
-		pr_err("microcode: error: invalid type field in "
-		       "container file section header\n");
+		pr_err("error: invalid type field in container file section header\n");
 		return 0;
 	}
 
 	equiv_cpu_table = (struct equiv_cpu_entry *) vmalloc(size);
 	if (!equiv_cpu_table) {
-		pr_err("microcode: failed to allocate equivalent CPU table\n");
+		pr_err("failed to allocate equivalent CPU table\n");
 		return 0;
 	}
 
@@ -246,7 +247,7 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 
 	offset = install_equiv_cpu_table(ucode_ptr);
 	if (!offset) {
-		pr_err("microcode: failed to create equivalent cpu table\n");
+		pr_err("failed to create equivalent cpu table\n");
 		return UCODE_ERROR;
 	}
 
@@ -277,8 +278,7 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 		if (!leftover) {
 			vfree(uci->mc);
 			uci->mc = new_mc;
-			pr_debug("microcode: CPU%d found a matching microcode "
-				 "update with version 0x%x (current=0x%x)\n",
+			pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",
 				 cpu, new_rev, uci->cpu_sig.rev);
 		} else {
 			vfree(new_mc);
@@ -300,7 +300,7 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 		return UCODE_NFOUND;
 
 	if (*(u32 *)firmware->data != UCODE_MAGIC) {
-		pr_err("microcode: invalid UCODE_MAGIC (0x%08x)\n",
+		pr_err("invalid UCODE_MAGIC (0x%08x)\n",
 		       *(u32 *)firmware->data);
 		return UCODE_ERROR;
 	}
@@ -313,8 +313,7 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 static enum ucode_state
 request_microcode_user(int cpu, const void __user *buf, size_t size)
 {
-	pr_info("microcode: AMD microcode update via "
-		"/dev/cpu/microcode not supported\n");
+	pr_info("AMD microcode update via /dev/cpu/microcode not supported\n");
 	return UCODE_ERROR;
 }
 
@@ -334,14 +333,13 @@ void init_microcode_amd(struct device *device)
 	WARN_ON(c->x86_vendor != X86_VENDOR_AMD);
 
 	if (c->x86 < 0x10) {
-		pr_warning("microcode: AMD CPU family 0x%x not supported\n",
-			   c->x86);
+		pr_warning("AMD CPU family 0x%x not supported\n", c->x86);
 		return;
 	}
 	supported_cpu = 1;
 
 	if (request_firmware(&firmware, fw_name, device))
-		pr_err("microcode: failed to load file %s\n", fw_name);
+		pr_err("failed to load file %s\n", fw_name);
 }
 
 void fini_microcode_amd(void)
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index e68aae3..844c02c 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -70,6 +70,9 @@
  *		Fix sigmatch() macro to handle old CPUs with pf == 0.
  *		Thanks to Stuart Swales for pointing out this bug.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/platform_device.h>
 #include <linux/miscdevice.h>
 #include <linux/capability.h>
@@ -209,7 +212,7 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
 	ssize_t ret = -EINVAL;
 
 	if ((len >> PAGE_SHIFT) > totalram_pages) {
-		pr_err("microcode: too much data (max %ld pages)\n", totalram_pages);
+		pr_err("too much data (max %ld pages)\n", totalram_pages);
 		return ret;
 	}
 
@@ -244,7 +247,7 @@ static int __init microcode_dev_init(void)
 
 	error = misc_register(&microcode_dev);
 	if (error) {
-		pr_err("microcode: can't misc_register on minor=%d\n", MICROCODE_MINOR);
+		pr_err("can't misc_register on minor=%d\n", MICROCODE_MINOR);
 		return error;
 	}
 
@@ -359,7 +362,7 @@ static enum ucode_state microcode_resume_cpu(int cpu)
 	if (!uci->mc)
 		return UCODE_NFOUND;
 
-	pr_debug("microcode: CPU%d updated upon resume\n", cpu);
+	pr_debug("CPU%d updated upon resume\n", cpu);
 	apply_microcode_on_target(cpu);
 
 	return UCODE_OK;
@@ -379,7 +382,7 @@ static enum ucode_state microcode_init_cpu(int cpu)
 	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
 
 	if (ustate == UCODE_OK) {
-		pr_debug("microcode: CPU%d updated upon init\n", cpu);
+		pr_debug("CPU%d updated upon init\n", cpu);
 		apply_microcode_on_target(cpu);
 	}
 
@@ -406,7 +409,7 @@ static int mc_sysdev_add(struct sys_device *sys_dev)
 	if (!cpu_online(cpu))
 		return 0;
 
-	pr_debug("microcode: CPU%d added\n", cpu);
+	pr_debug("CPU%d added\n", cpu);
 
 	err = sysfs_create_group(&sys_dev->kobj, &mc_attr_group);
 	if (err)
@@ -425,7 +428,7 @@ static int mc_sysdev_remove(struct sys_device *sys_dev)
 	if (!cpu_online(cpu))
 		return 0;
 
-	pr_debug("microcode: CPU%d removed\n", cpu);
+	pr_debug("CPU%d removed\n", cpu);
 	microcode_fini_cpu(cpu);
 	sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
 	return 0;
@@ -473,15 +476,15 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 		microcode_update_cpu(cpu);
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		pr_debug("microcode: CPU%d added\n", cpu);
+		pr_debug("CPU%d added\n", cpu);
 		if (sysfs_create_group(&sys_dev->kobj, &mc_attr_group))
-			pr_err("microcode: Failed to create group for CPU%d\n", cpu);
+			pr_err("Failed to create group for CPU%d\n", cpu);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		/* Suspend is in progress, only remove the interface */
 		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
-		pr_debug("microcode: CPU%d removed\n", cpu);
+		pr_debug("CPU%d removed\n", cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_UP_CANCELED_FROZEN:
@@ -507,7 +510,7 @@ static int __init microcode_init(void)
 		microcode_ops = init_amd_microcode();
 
 	if (!microcode_ops) {
-		pr_err("microcode: no support for this CPU vendor\n");
+		pr_err("no support for this CPU vendor\n");
 		return -ENODEV;
 	}
 
@@ -541,8 +544,7 @@ static int __init microcode_init(void)
 	register_hotcpu_notifier(&mc_cpu_notifier);
 
 	pr_info("Microcode Update Driver: v" MICROCODE_VERSION
-	       " <tigran@aivazian.fsnet.co.uk>,"
-	       " Peter Oruba\n");
+		" <tigran@aivazian.fsnet.co.uk>, Peter Oruba\n");
 
 	return 0;
 }
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 0d334dd..ebd193e 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -70,6 +70,9 @@
  *		Fix sigmatch() macro to handle old CPUs with pf == 0.
  *		Thanks to Stuart Swales for pointing out this bug.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/firmware.h>
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
@@ -146,8 +149,7 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 
 	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
 	    cpu_has(c, X86_FEATURE_IA64)) {
-		printk(KERN_ERR "microcode: CPU%d not a capable Intel "
-			"processor\n", cpu_num);
+		pr_err("CPU%d not a capable Intel processor\n", cpu_num);
 		return -1;
 	}
 
@@ -165,8 +167,8 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 	/* get the current revision from MSR 0x8B */
 	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
 
-	printk(KERN_INFO "microcode: CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
-			cpu_num, csig->sig, csig->pf, csig->rev);
+	pr_info("CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
+		cpu_num, csig->sig, csig->pf, csig->rev);
 
 	return 0;
 }
@@ -194,28 +196,24 @@ static int microcode_sanity_check(void *mc)
 	data_size = get_datasize(mc_header);
 
 	if (data_size + MC_HEADER_SIZE > total_size) {
-		printk(KERN_ERR "microcode: error! "
-				"Bad data size in microcode data file\n");
+		pr_err("error! Bad data size in microcode data file\n");
 		return -EINVAL;
 	}
 
 	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
-		printk(KERN_ERR "microcode: error! "
-				"Unknown microcode update format\n");
+		pr_err("error! Unknown microcode update format\n");
 		return -EINVAL;
 	}
 	ext_table_size = total_size - (MC_HEADER_SIZE + data_size);
 	if (ext_table_size) {
 		if ((ext_table_size < EXT_HEADER_SIZE)
 		 || ((ext_table_size - EXT_HEADER_SIZE) % EXT_SIGNATURE_SIZE)) {
-			printk(KERN_ERR "microcode: error! "
-				"Small exttable size in microcode data file\n");
+			pr_err("error! Small exttable size in microcode data file\n");
 			return -EINVAL;
 		}
 		ext_header = mc + MC_HEADER_SIZE + data_size;
 		if (ext_table_size != exttable_size(ext_header)) {
-			printk(KERN_ERR "microcode: error! "
-				"Bad exttable size in microcode data file\n");
+			pr_err("error! Bad exttable size in microcode data file\n");
 			return -EFAULT;
 		}
 		ext_sigcount = ext_header->count;
@@ -230,8 +228,7 @@ static int microcode_sanity_check(void *mc)
 		while (i--)
 			ext_table_sum += ext_tablep[i];
 		if (ext_table_sum) {
-			printk(KERN_WARNING "microcode: aborting, "
-				"bad extended signature table checksum\n");
+			pr_warning("aborting, bad extended signature table checksum\n");
 			return -EINVAL;
 		}
 	}
@@ -242,7 +239,7 @@ static int microcode_sanity_check(void *mc)
 	while (i--)
 		orig_sum += ((int *)mc)[i];
 	if (orig_sum) {
-		printk(KERN_ERR "microcode: aborting, bad checksum\n");
+		pr_err("aborting, bad checksum\n");
 		return -EINVAL;
 	}
 	if (!ext_table_size)
@@ -255,7 +252,7 @@ static int microcode_sanity_check(void *mc)
 			- (mc_header->sig + mc_header->pf + mc_header->cksum)
 			+ (ext_sig->sig + ext_sig->pf + ext_sig->cksum);
 		if (sum) {
-			printk(KERN_ERR "microcode: aborting, bad checksum\n");
+			pr_err("aborting, bad checksum\n");
 			return -EINVAL;
 		}
 	}
@@ -327,13 +324,11 @@ static int apply_microcode(int cpu)
 	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
 
 	if (val[1] != mc_intel->hdr.rev) {
-		printk(KERN_ERR "microcode: CPU%d update "
-				"to revision 0x%x failed\n",
-			cpu_num, mc_intel->hdr.rev);
+		pr_err("CPU%d update to revision 0x%x failed\n",
+		       cpu_num, mc_intel->hdr.rev);
 		return -1;
 	}
-	printk(KERN_INFO "microcode: CPU%d updated to revision "
-			 "0x%x, date = %04x-%02x-%02x \n",
+	pr_info("CPU%d updated to revision 0x%x, date = %04x-%02x-%02x \n",
 		cpu_num, val[1],
 		mc_intel->hdr.date & 0xffff,
 		mc_intel->hdr.date >> 24,
@@ -362,8 +357,7 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 
 		mc_size = get_totalsize(&mc_header);
 		if (!mc_size || mc_size > leftover) {
-			printk(KERN_ERR "microcode: error!"
-					"Bad data in microcode data file\n");
+			pr_err("error! Bad data in microcode data file\n");
 			break;
 		}
 
@@ -405,9 +399,8 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 		vfree(uci->mc);
 	uci->mc = (struct microcode_intel *)new_mc;
 
-	pr_debug("microcode: CPU%d found a matching microcode update with"
-		 " version 0x%x (current=0x%x)\n",
-			cpu, new_rev, uci->cpu_sig.rev);
+	pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",
+		 cpu, new_rev, uci->cpu_sig.rev);
 out:
 	return state;
 }
@@ -429,7 +422,7 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 		c->x86, c->x86_model, c->x86_mask);
 
 	if (request_firmware(&firmware, name, device)) {
-		pr_debug("microcode: data file %s load failed\n", name);
+		pr_debug("data file %s load failed\n", name);
 		return UCODE_NFOUND;
 	}
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 5e2ba63..7a7bd4e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -10,6 +10,8 @@
 #include <linux/clockchips.h>
 #include <linux/random.h>
 #include <linux/user-return-notifier.h>
+#include <linux/dmi.h>
+#include <linux/utsname.h>
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
 #include <asm/system.h>
@@ -90,6 +92,25 @@ void exit_thread(void)
 	}
 }
 
+void show_regs_common(void)
+{
+	const char *board, *product;
+
+	board = dmi_get_system_info(DMI_BOARD_NAME);
+	if (!board)
+		board = "";
+	product = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!product)
+		product = "";
+
+	printk("\n");
+	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s %s/%s\n",
+		current->pid, current->comm, print_tainted(),
+		init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version, board, product);
+}
+
 void flush_thread(void)
 {
 	struct task_struct *tsk = current;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 075580b..120b887 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -23,7 +23,6 @@
 #include <linux/vmalloc.h>
 #include <linux/user.h>
 #include <linux/interrupt.h>
-#include <linux/utsname.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
@@ -35,7 +34,6 @@
 #include <linux/tick.h>
 #include <linux/percpu.h>
 #include <linux/prctl.h>
-#include <linux/dmi.h>
 #include <linux/ftrace.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
@@ -128,7 +126,6 @@ void __show_regs(struct pt_regs *regs, int all)
 	unsigned long d0, d1, d2, d3, d6, d7;
 	unsigned long sp;
 	unsigned short ss, gs;
-	const char *board;
 
 	if (user_mode_vm(regs)) {
 		sp = regs->sp;
@@ -140,16 +137,7 @@ void __show_regs(struct pt_regs *regs, int all)
 		savesegment(gs, gs);
 	}
 
-	printk("\n");
-
-	board = dmi_get_system_info(DMI_PRODUCT_NAME);
-	if (!board)
-		board = "";
-	printk("Pid: %d, comm: %s %s (%s %.*s) %s\n",
-			task_pid_nr(current), current->comm,
-			print_tainted(), init_utsname()->release,
-			(int)strcspn(init_utsname()->version, " "),
-			init_utsname()->version, board);
+	show_regs_common();
 
 	printk("EIP: %04x:[<%08lx>] EFLAGS: %08lx CPU: %d\n",
 			(u16)regs->cs, regs->ip, regs->flags,
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index c95c8f4..e5ab0cd 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 #include <linux/user.h>
 #include <linux/interrupt.h>
-#include <linux/utsname.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/ptrace.h>
@@ -38,7 +37,6 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/ftrace.h>
-#include <linux/dmi.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -163,18 +161,8 @@ void __show_regs(struct pt_regs *regs, int all)
 	unsigned long d0, d1, d2, d3, d6, d7;
 	unsigned int fsindex, gsindex;
 	unsigned int ds, cs, es;
-	const char *board;
-
-	printk("\n");
-	print_modules();
-	board = dmi_get_system_info(DMI_PRODUCT_NAME);
-	if (!board)
-		board = "";
-	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s %s\n",
-		current->pid, current->comm, print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version, board);
+
+	show_regs_common();
 	printk(KERN_INFO "RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->ip);
 	printk_address(regs->ip, 1);
 	printk(KERN_INFO "RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss,
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 2b97fc5..1545bc0 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -259,6 +259,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
 		},
 	},
+	{       /* Handle problems with rebooting on ASUS P4S800 */
+		.callback = set_bios_reboot,
+		.ident = "ASUS P4S800",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
+		},
+	},
 	{ }
 };
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index d559af9..35abcb8 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -20,9 +22,9 @@
 #include <asm/stackprotector.h>
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
-# define DBG(x...) printk(KERN_DEBUG x)
+# define DBG(fmt, ...) pr_dbg(fmt, ##__VA_ARGS__)
 #else
-# define DBG(x...)
+# define DBG(fmt, ...) do { if (0) pr_dbg(fmt, ##__VA_ARGS__); } while (0)
 #endif
 
 DEFINE_PER_CPU(int, cpu_number);
@@ -116,8 +118,8 @@ static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
 	} else {
 		ptr = __alloc_bootmem_node_nopanic(NODE_DATA(node),
 						   size, align, goal);
-		pr_debug("per cpu data for cpu%d %lu bytes on node%d at "
-			 "%016lx\n", cpu, size, node, __pa(ptr));
+		pr_debug("per cpu data for cpu%d %lu bytes on node%d at %016lx\n",
+			 cpu, size, node, __pa(ptr));
 	}
 	return ptr;
 #else
@@ -198,8 +200,7 @@ void __init setup_per_cpu_areas(void)
 					    pcpu_cpu_distance,
 					    pcpu_fc_alloc, pcpu_fc_free);
 		if (rc < 0)
-			pr_warning("PERCPU: %s allocator failed (%d), "
-				   "falling back to page size\n",
+			pr_warning("%s allocator failed (%d), falling back to page size\n",
 				   pcpu_fc_names[pcpu_chosen_fc], rc);
 	}
 	if (rc < 0)
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index fab7440..296aba4 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -29,6 +29,8 @@
  *   Based on QEMU and Xen.
  */
 
+#define pr_fmt(fmt) "pit: " fmt
+
 #include <linux/kvm_host.h>
 
 #include "irq.h"
@@ -262,7 +264,7 @@ void __kvm_migrate_pit_timer(struct kvm_vcpu *vcpu)
 
 static void destroy_pit_timer(struct kvm_timer *pt)
 {
-	pr_debug("pit: execute del timer!\n");
+	pr_debug("execute del timer!\n");
 	hrtimer_cancel(&pt->timer);
 }
 
@@ -284,7 +286,7 @@ static void create_pit_timer(struct kvm_kpit_state *ps, u32 val, int is_period)
 
 	interval = muldiv64(val, NSEC_PER_SEC, KVM_PIT_FREQ);
 
-	pr_debug("pit: create pit timer, interval is %llu nsec\n", interval);
+	pr_debug("create pit timer, interval is %llu nsec\n", interval);
 
 	/* TODO The new value only affected after the retriggered */
 	hrtimer_cancel(&pt->timer);
@@ -309,7 +311,7 @@ static void pit_load_count(struct kvm *kvm, int channel, u32 val)
 
 	WARN_ON(!mutex_is_locked(&ps->lock));
 
-	pr_debug("pit: load_count val is %d, channel is %d\n", val, channel);
+	pr_debug("load_count val is %d, channel is %d\n", val, channel);
 
 	/*
 	 * The largest possible initial count is 0; this is equivalent
@@ -395,8 +397,8 @@ static int pit_ioport_write(struct kvm_io_device *this,
 	mutex_lock(&pit_state->lock);
 
 	if (val != 0)
-		pr_debug("pit: write addr is 0x%x, len is %d, val is 0x%x\n",
-			  (unsigned int)addr, len, val);
+		pr_debug("write addr is 0x%x, len is %d, val is 0x%x\n",
+			 (unsigned int)addr, len, val);
 
 	if (addr == 3) {
 		channel = val >> 6;
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 11a4ad4..68c3e89 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -5,6 +5,8 @@
  *     2008 Pekka Paalanen <pq@iki.fi>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/spinlock.h>
@@ -136,7 +138,7 @@ static int clear_page_presence(struct kmmio_fault_page *f, bool clear)
 	pte_t *pte = lookup_address(f->page, &level);
 
 	if (!pte) {
-		pr_err("kmmio: no pte for page 0x%08lx\n", f->page);
+		pr_err("no pte for page 0x%08lx\n", f->page);
 		return -1;
 	}
 
@@ -148,7 +150,7 @@ static int clear_page_presence(struct kmmio_fault_page *f, bool clear)
 		clear_pte_presence(pte, clear, &f->old_presence);
 		break;
 	default:
-		pr_err("kmmio: unexpected page level 0x%x.\n", level);
+		pr_err("unexpected page level 0x%x.\n", level);
 		return -1;
 	}
 
@@ -170,13 +172,14 @@ static int clear_page_presence(struct kmmio_fault_page *f, bool clear)
 static int arm_kmmio_fault_page(struct kmmio_fault_page *f)
 {
 	int ret;
-	WARN_ONCE(f->armed, KERN_ERR "kmmio page already armed.\n");
+	WARN_ONCE(f->armed, KERN_ERR pr_fmt("kmmio page already armed.\n"));
 	if (f->armed) {
-		pr_warning("kmmio double-arm: page 0x%08lx, ref %d, old %d\n",
-					f->page, f->count, !!f->old_presence);
+		pr_warning("double-arm: page 0x%08lx, ref %d, old %d\n",
+			   f->page, f->count, !!f->old_presence);
 	}
 	ret = clear_page_presence(f, true);
-	WARN_ONCE(ret < 0, KERN_ERR "kmmio arming 0x%08lx failed.\n", f->page);
+	WARN_ONCE(ret < 0, KERN_ERR pr_fmt("arming 0x%08lx failed.\n"),
+		  f->page);
 	f->armed = true;
 	return ret;
 }
@@ -240,24 +243,21 @@ int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 			 * condition needs handling by do_page_fault(), the
 			 * page really not being present is the most common.
 			 */
-			pr_debug("kmmio: secondary hit for 0x%08lx CPU %d.\n",
-					addr, smp_processor_id());
+			pr_debug("secondary hit for 0x%08lx CPU %d.\n",
+				 addr, smp_processor_id());
 
 			if (!faultpage->old_presence)
-				pr_info("kmmio: unexpected secondary hit for "
-					"address 0x%08lx on CPU %d.\n", addr,
-					smp_processor_id());
+				pr_info("unexpected secondary hit for address 0x%08lx on CPU %d.\n",
+					addr, smp_processor_id());
 		} else {
 			/*
 			 * Prevent overwriting already in-flight context.
 			 * This should not happen, let's hope disarming at
 			 * least prevents a panic.
 			 */
-			pr_emerg("kmmio: recursive probe hit on CPU %d, "
-					"for address 0x%08lx. Ignoring.\n",
-					smp_processor_id(), addr);
-			pr_emerg("kmmio: previous hit was at 0x%08lx.\n",
-						ctx->addr);
+			pr_emerg("recursive probe hit on CPU %d, for address 0x%08lx. Ignoring.\n",
+				 smp_processor_id(), addr);
+			pr_emerg("previous hit was at 0x%08lx.\n", ctx->addr);
 			disarm_kmmio_fault_page(faultpage);
 		}
 		goto no_kmmio_ctx;
@@ -316,8 +316,8 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 		 * something external causing them (f.e. using a debugger while
 		 * mmio tracing enabled), or erroneous behaviour
 		 */
-		pr_warning("kmmio: unexpected debug trap on CPU %d.\n",
-							smp_processor_id());
+		pr_warning("unexpected debug trap on CPU %d.\n",
+			   smp_processor_id());
 		goto out;
 	}
 
@@ -425,7 +425,7 @@ int register_kmmio_probe(struct kmmio_probe *p)
 	list_add_rcu(&p->list, &kmmio_probes);
 	while (size < size_lim) {
 		if (add_kmmio_fault_page(p->addr + size))
-			pr_err("kmmio: Unable to set page fault.\n");
+			pr_err("Unable to set page fault.\n");
 		size += PAGE_SIZE;
 	}
 out:
@@ -490,7 +490,7 @@ static void remove_kmmio_fault_pages(struct rcu_head *head)
  * 2. remove_kmmio_fault_pages()
  *    Remove the pages from kmmio_page_table.
  * 3. rcu_free_kmmio_fault_pages()
- *    Actally free the kmmio_fault_page structs as with RCU.
+ *    Actually free the kmmio_fault_page structs as with RCU.
  */
 void unregister_kmmio_probe(struct kmmio_probe *p)
 {
@@ -511,7 +511,7 @@ void unregister_kmmio_probe(struct kmmio_probe *p)
 
 	drelease = kmalloc(sizeof(*drelease), GFP_ATOMIC);
 	if (!drelease) {
-		pr_crit("kmmio: leaking kmmio_fault_page objects.\n");
+		pr_crit("leaking kmmio_fault_page objects.\n");
 		return;
 	}
 	drelease->release_list = release_list;
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 132772a..4c765e9 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -19,6 +19,9 @@
  *
  * Derived from the read-mod example from relay-examples by Tom Zanussi.
  */
+
+#define pr_fmt(fmt) "mmiotrace: "
+
 #define DEBUG 1
 
 #include <linux/module.h>
@@ -36,8 +39,6 @@
 
 #include "pf_in.h"
 
-#define NAME "mmiotrace: "
-
 struct trap_reason {
 	unsigned long addr;
 	unsigned long ip;
@@ -96,17 +97,18 @@ static void print_pte(unsigned long address)
 	pte_t *pte = lookup_address(address, &level);
 
 	if (!pte) {
-		pr_err(NAME "Error in %s: no pte for page 0x%08lx\n",
-							__func__, address);
+		pr_err("Error in %s: no pte for page 0x%08lx\n",
+		       __func__, address);
 		return;
 	}
 
 	if (level == PG_LEVEL_2M) {
-		pr_emerg(NAME "4MB pages are not currently supported: "
-							"0x%08lx\n", address);
+		pr_emerg("4MB pages are not currently supported: 0x%08lx\n",
+			 address);
 		BUG();
 	}
-	pr_info(NAME "pte for 0x%lx: 0x%llx 0x%llx\n", address,
+	pr_info("pte for 0x%lx: 0x%llx 0x%llx\n",
+		address,
 		(unsigned long long)pte_val(*pte),
 		(unsigned long long)pte_val(*pte) & _PAGE_PRESENT);
 }
@@ -118,22 +120,21 @@ static void print_pte(unsigned long address)
 static void die_kmmio_nesting_error(struct pt_regs *regs, unsigned long addr)
 {
 	const struct trap_reason *my_reason = &get_cpu_var(pf_reason);
-	pr_emerg(NAME "unexpected fault for address: 0x%08lx, "
-					"last fault for address: 0x%08lx\n",
-					addr, my_reason->addr);
+	pr_emerg("unexpected fault for address: 0x%08lx, last fault for address: 0x%08lx\n",
+		 addr, my_reason->addr);
 	print_pte(addr);
 	print_symbol(KERN_EMERG "faulting IP is at %s\n", regs->ip);
 	print_symbol(KERN_EMERG "last faulting IP was at %s\n", my_reason->ip);
 #ifdef __i386__
 	pr_emerg("eax: %08lx   ebx: %08lx   ecx: %08lx   edx: %08lx\n",
-			regs->ax, regs->bx, regs->cx, regs->dx);
+		 regs->ax, regs->bx, regs->cx, regs->dx);
 	pr_emerg("esi: %08lx   edi: %08lx   ebp: %08lx   esp: %08lx\n",
-			regs->si, regs->di, regs->bp, regs->sp);
+		 regs->si, regs->di, regs->bp, regs->sp);
 #else
 	pr_emerg("rax: %016lx   rcx: %016lx   rdx: %016lx\n",
-					regs->ax, regs->cx, regs->dx);
+		 regs->ax, regs->cx, regs->dx);
 	pr_emerg("rsi: %016lx   rdi: %016lx   rbp: %016lx   rsp: %016lx\n",
-				regs->si, regs->di, regs->bp, regs->sp);
+		 regs->si, regs->di, regs->bp, regs->sp);
 #endif
 	put_cpu_var(pf_reason);
 	BUG();
@@ -213,7 +214,7 @@ static void post(struct kmmio_probe *p, unsigned long condition,
 	/* this should always return the active_trace count to 0 */
 	my_reason->active_traces--;
 	if (my_reason->active_traces) {
-		pr_emerg(NAME "unexpected post handler");
+		pr_emerg("unexpected post handler");
 		BUG();
 	}
 
@@ -244,7 +245,7 @@ static void ioremap_trace_core(resource_size_t offset, unsigned long size,
 	};
 
 	if (!trace) {
-		pr_err(NAME "kmalloc failed in ioremap\n");
+		pr_err("kmalloc failed in ioremap\n");
 		return;
 	}
 
@@ -282,8 +283,8 @@ void mmiotrace_ioremap(resource_size_t offset, unsigned long size,
 	if (!is_enabled()) /* recheck and proper locking in *_core() */
 		return;
 
-	pr_debug(NAME "ioremap_*(0x%llx, 0x%lx) = %p\n",
-				(unsigned long long)offset, size, addr);
+	pr_debug("ioremap_*(0x%llx, 0x%lx) = %p\n",
+		 (unsigned long long)offset, size, addr);
 	if ((filter_offset) && (offset != filter_offset))
 		return;
 	ioremap_trace_core(offset, size, addr);
@@ -301,7 +302,7 @@ static void iounmap_trace_core(volatile void __iomem *addr)
 	struct remap_trace *tmp;
 	struct remap_trace *found_trace = NULL;
 
-	pr_debug(NAME "Unmapping %p.\n", addr);
+	pr_debug("Unmapping %p.\n", addr);
 
 	spin_lock_irq(&trace_lock);
 	if (!is_enabled())
@@ -363,9 +364,8 @@ static void clear_trace_list(void)
 	 * Caller also ensures is_enabled() cannot change.
 	 */
 	list_for_each_entry(trace, &trace_list, list) {
-		pr_notice(NAME "purging non-iounmapped "
-					"trace @0x%08lx, size 0x%lx.\n",
-					trace->probe.addr, trace->probe.len);
+		pr_notice("purging non-iounmapped trace @0x%08lx, size 0x%lx.\n",
+			  trace->probe.addr, trace->probe.len);
 		if (!nommiotrace)
 			unregister_kmmio_probe(&trace->probe);
 	}
@@ -387,7 +387,7 @@ static void enter_uniprocessor(void)
 
 	if (downed_cpus == NULL &&
 	    !alloc_cpumask_var(&downed_cpus, GFP_KERNEL)) {
-		pr_notice(NAME "Failed to allocate mask\n");
+		pr_notice("Failed to allocate mask\n");
 		goto out;
 	}
 
@@ -395,20 +395,19 @@ static void enter_uniprocessor(void)
 	cpumask_copy(downed_cpus, cpu_online_mask);
 	cpumask_clear_cpu(cpumask_first(cpu_online_mask), downed_cpus);
 	if (num_online_cpus() > 1)
-		pr_notice(NAME "Disabling non-boot CPUs...\n");
+		pr_notice("Disabling non-boot CPUs...\n");
 	put_online_cpus();
 
 	for_each_cpu(cpu, downed_cpus) {
 		err = cpu_down(cpu);
 		if (!err)
-			pr_info(NAME "CPU%d is down.\n", cpu);
+			pr_info("CPU%d is down.\n", cpu);
 		else
-			pr_err(NAME "Error taking CPU%d down: %d\n", cpu, err);
+			pr_err("Error taking CPU%d down: %d\n", cpu, err);
 	}
 out:
 	if (num_online_cpus() > 1)
-		pr_warning(NAME "multiple CPUs still online, "
-						"may miss events.\n");
+		pr_warning("multiple CPUs still online, may miss events.\n");
 }
 
 /* __ref because leave_uniprocessor calls cpu_up which is __cpuinit,
@@ -420,13 +419,13 @@ static void __ref leave_uniprocessor(void)
 
 	if (downed_cpus == NULL || cpumask_weight(downed_cpus) == 0)
 		return;
-	pr_notice(NAME "Re-enabling CPUs...\n");
+	pr_notice("Re-enabling CPUs...\n");
 	for_each_cpu(cpu, downed_cpus) {
 		err = cpu_up(cpu);
 		if (!err)
-			pr_info(NAME "enabled CPU%d.\n", cpu);
+			pr_info("enabled CPU%d.\n", cpu);
 		else
-			pr_err(NAME "cannot re-enable CPU%d: %d\n", cpu, err);
+			pr_err("cannot re-enable CPU%d: %d\n", cpu, err);
 	}
 }
 
@@ -434,8 +433,8 @@ static void __ref leave_uniprocessor(void)
 static void enter_uniprocessor(void)
 {
 	if (num_online_cpus() > 1)
-		pr_warning(NAME "multiple CPUs are online, may miss events. "
-			"Suggest booting with maxcpus=1 kernel argument.\n");
+		pr_warning("multiple CPUs are online, may miss events. "
+			   "Suggest booting with maxcpus=1 kernel argument.\n");
 }
 
 static void leave_uniprocessor(void)
@@ -450,13 +449,13 @@ void enable_mmiotrace(void)
 		goto out;
 
 	if (nommiotrace)
-		pr_info(NAME "MMIO tracing disabled.\n");
+		pr_info("MMIO tracing disabled.\n");
 	kmmio_init();
 	enter_uniprocessor();
 	spin_lock_irq(&trace_lock);
 	atomic_inc(&mmiotrace_enabled);
 	spin_unlock_irq(&trace_lock);
-	pr_info(NAME "enabled.\n");
+	pr_info("enabled.\n");
 out:
 	mutex_unlock(&mmiotrace_mutex);
 }
@@ -475,7 +474,7 @@ void disable_mmiotrace(void)
 	clear_trace_list(); /* guarantees: no more kmmio callbacks */
 	leave_uniprocessor();
 	kmmio_cleanup();
-	pr_info(NAME "disabled.\n");
+	pr_info("disabled.\n");
 out:
 	mutex_unlock(&mmiotrace_mutex);
 }
