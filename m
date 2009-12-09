Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbZLIGar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbZLIGar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 01:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZLIGaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 01:30:46 -0500
Received: from mail.perches.com ([173.55.12.10]:1025 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbZLIGap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 01:30:45 -0500
Subject: [PATCH] arch/x86/kernel/microcode*: Use pr_fmt and remove
 duplicated KERN_ERR prefix
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andy Whitcroft <apw@canonical.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Herrmann <herrmann.der.user@googlemail.com>
In-Reply-To: <20091209060538.GD2512@elte.hu>
References: <200912082259.nB8Mx2ih008207@hera.kernel.org>
	 <1260313613.27677.169.camel@Joe-Laptop.home>
	 <20091209060538.GD2512@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 22:30:50 -0800
Message-ID: <1260340250.27677.191.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 07:05 +0100, Ingo Molnar wrote:
> > > -		printk(KERN_ERR "microcode: CPU%d: loading of chipset "
> > > +		pr_err(KERN_ERR "microcode: CPU%d: loading of chipset "
> > Duplicates KERN_ERR
> Indeed - please send a delta fix as this has been merged already.

Use #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Remove "microcode: " prefix from each pr_<level>
Fix duplicated KERN_ERR prefix
Coalesce pr_<level> format strings
Add a space after an exclamation point
No other change in output

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/microcode_amd.c   |   40 +++++++++++++++----------------
 arch/x86/kernel/microcode_core.c  |   26 +++++++++++---------
 arch/x86/kernel/microcode_intel.c |   47 +++++++++++++++---------------------
 3 files changed, 53 insertions(+), 60 deletions(-)

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
index 0d334dd..00ff0dd 100644
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
 


