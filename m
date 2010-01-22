Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142Ab0AVUfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0AVUfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 15:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074Ab0AVUfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 15:35:02 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:55940 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab0AVUfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 15:35:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=FaNdMZode7yUGU7tE7JeQ26qy4NT7xb3vHE4HaPsnxvZC3DAkjvfXxWGkbPFQEuHWr
         iYa7V3dX+GcAKEpmCYQ33sF+raYHzZLohUl5WESRA8uRq6MO5ln0EiACfu/qfdnaGD94
         bQ4R6U3sbXYFAN2VjPDkNN2GnBp8MqliXFKss=
Date: Fri, 22 Jan 2010 21:34:56 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Gene Heskett <gene.heskett@verizon.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "x86: ucode-amd: Load ucode-patches once ..."
Message-ID: <20100122203456.GB13792@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

Commit d1c84f79a6ba992dc01e312c44a21496303874d6
leads to a regression when microcode_amd.c is compiled into the kernel.
It causes a big boot delay because the firmware is not available.
See http://marc.info/?l=linux-kernel&m=126267290920060

It also renders the reload sysfs attribute useless.
Fixing this is too intrusive for an -rc5 kernel.

Thus I'd like to restore the microcode loading behaviour of kernel
2.6.32.

CC: Gene Heskett <gene.heskett@verizon.net>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/microcode.h |    2 -
 arch/x86/kernel/microcode_amd.c  |   44 +++++++++++--------------------------
 arch/x86/kernel/microcode_core.c |    6 -----
 3 files changed, 13 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index c24ca9a..ef51b50 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -12,8 +12,6 @@ struct device;
 enum ucode_state { UCODE_ERROR, UCODE_OK, UCODE_NFOUND };
 
 struct microcode_ops {
-	void (*init)(struct device *device);
-	void (*fini)(void);
 	enum ucode_state (*request_microcode_user) (int cpu,
 				const void __user *buf, size_t size);
 
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 37542b6..e1af7c0 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -36,9 +36,6 @@ MODULE_LICENSE("GPL v2");
 #define UCODE_EQUIV_CPU_TABLE_TYPE 0x00000000
 #define UCODE_UCODE_TYPE           0x00000001
 
-const struct firmware *firmware;
-static int supported_cpu;
-
 struct equiv_cpu_entry {
 	u32	installed_cpu;
 	u32	fixed_errata_mask;
@@ -77,12 +74,15 @@ static struct equiv_cpu_entry *equiv_cpu_table;
 
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	u32 dummy;
 
-	if (!supported_cpu)
-		return -1;
-
 	memset(csig, 0, sizeof(*csig));
+	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
+		pr_warning("microcode: CPU%d: AMD CPU family 0x%x not "
+			   "supported\n", cpu, c->x86);
+		return -1;
+	}
 	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
 	pr_info("CPU%d: patch_level=0x%x\n", cpu, csig->rev);
 	return 0;
@@ -294,10 +294,14 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 
 static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 {
+	const char *fw_name = "amd-ucode/microcode_amd.bin";
+	const struct firmware *firmware;
 	enum ucode_state ret;
 
-	if (firmware == NULL)
+	if (request_firmware(&firmware, fw_name, device)) {
+		printk(KERN_ERR "microcode: failed to load file %s\n", fw_name);
 		return UCODE_NFOUND;
+	}
 
 	if (*(u32 *)firmware->data != UCODE_MAGIC) {
 		pr_err("invalid UCODE_MAGIC (0x%08x)\n",
@@ -307,6 +311,8 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 
 	ret = generic_load_microcode(cpu, firmware->data, firmware->size);
 
+	release_firmware(firmware);
+
 	return ret;
 }
 
@@ -325,31 +331,7 @@ static void microcode_fini_cpu_amd(int cpu)
 	uci->mc = NULL;
 }
 
-void init_microcode_amd(struct device *device)
-{
-	const char *fw_name = "amd-ucode/microcode_amd.bin";
-	struct cpuinfo_x86 *c = &boot_cpu_data;
-
-	WARN_ON(c->x86_vendor != X86_VENDOR_AMD);
-
-	if (c->x86 < 0x10) {
-		pr_warning("AMD CPU family 0x%x not supported\n", c->x86);
-		return;
-	}
-	supported_cpu = 1;
-
-	if (request_firmware(&firmware, fw_name, device))
-		pr_err("failed to load file %s\n", fw_name);
-}
-
-void fini_microcode_amd(void)
-{
-	release_firmware(firmware);
-}
-
 static struct microcode_ops microcode_amd_ops = {
-	.init				  = init_microcode_amd,
-	.fini				  = fini_microcode_amd,
 	.request_microcode_user           = request_microcode_user,
 	.request_microcode_fw             = request_microcode_fw,
 	.collect_cpu_info                 = collect_cpu_info_amd,
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 0c86324..cceb5bc 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -521,9 +521,6 @@ static int __init microcode_init(void)
 		return PTR_ERR(microcode_pdev);
 	}
 
-	if (microcode_ops->init)
-		microcode_ops->init(&microcode_pdev->dev);
-
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
@@ -566,9 +563,6 @@ static void __exit microcode_exit(void)
 
 	platform_device_unregister(microcode_pdev);
 
-	if (microcode_ops->fini)
-		microcode_ops->fini();
-
 	microcode_ops = NULL;
 
 	pr_info("Microcode Update Driver: v" MICROCODE_VERSION " removed.\n");
-- 
1.6.6

