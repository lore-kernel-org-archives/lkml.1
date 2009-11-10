Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbZKJNWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbZKJNWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbZKJNWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:22:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:34014 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbZKJNWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:22:18 -0500
Date: Tue, 10 Nov 2009 13:21:46 GMT
From: tip-bot for Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, dmitry.adamushko@gmail.com,
       herrmann.der.user@googlemail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, dmitry.adamushko@gmail.com,
       herrmann.der.user@googlemail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091110110723.GH30802@alberich.amd.com>
References: <20091110110723.GH30802@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86: ucode-amd: Load ucode-patches once and not separately of each CPU
Message-ID: <tip-d1c84f79a6ba992dc01e312c44a21496303874d6@git.kernel.org>
Git-Commit-ID: d1c84f79a6ba992dc01e312c44a21496303874d6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1c84f79a6ba992dc01e312c44a21496303874d6
Gitweb:     http://git.kernel.org/tip/d1c84f79a6ba992dc01e312c44a21496303874d6
Author:     Andreas Herrmann <herrmann.der.user@googlemail.com>
AuthorDate: Tue, 10 Nov 2009 12:07:23 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 12:15:48 +0100

x86: ucode-amd: Load ucode-patches once and not separately of each CPU

This also implies that corresponding log messages, e.g.

  platform microcode: firmware: requesting amd-ucode/microcode_amd.bin

show up only once on module load and not when ucode is updated
for each CPU.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: dimm <dmitry.adamushko@gmail.com>
LKML-Reference: <20091110110723.GH30802@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/microcode.h |    2 ++
 arch/x86/kernel/microcode_amd.c  |   24 +++++++++++++++++-------
 arch/x86/kernel/microcode_core.c |    6 ++++++
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index ef51b50..c24ca9a 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -12,6 +12,8 @@ struct device;
 enum ucode_state { UCODE_ERROR, UCODE_OK, UCODE_NFOUND };
 
 struct microcode_ops {
+	void (*init)(struct device *device);
+	void (*fini)(void);
 	enum ucode_state (*request_microcode_user) (int cpu,
 				const void __user *buf, size_t size);
 
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index c043534..75538f6 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -33,6 +33,8 @@ MODULE_LICENSE("GPL v2");
 #define UCODE_EQUIV_CPU_TABLE_TYPE 0x00000000
 #define UCODE_UCODE_TYPE           0x00000001
 
+const struct firmware *firmware;
+
 struct equiv_cpu_entry {
 	u32	installed_cpu;
 	u32	fixed_errata_mask;
@@ -301,14 +303,10 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 
 static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 {
-	const char *fw_name = "amd-ucode/microcode_amd.bin";
-	const struct firmware *firmware;
 	enum ucode_state ret;
 
-	if (request_firmware(&firmware, fw_name, device)) {
-		printk(KERN_ERR "microcode: failed to load file %s\n", fw_name);
+	if (firmware == NULL)
 		return UCODE_NFOUND;
-	}
 
 	if (*(u32 *)firmware->data != UCODE_MAGIC) {
 		printk(KERN_ERR "microcode: invalid UCODE_MAGIC (0x%08x)\n",
@@ -318,8 +316,6 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 
 	ret = generic_load_microcode(cpu, firmware->data, firmware->size);
 
-	release_firmware(firmware);
-
 	return ret;
 }
 
@@ -339,7 +335,21 @@ static void microcode_fini_cpu_amd(int cpu)
 	uci->mc = NULL;
 }
 
+void init_microcode_amd(struct device *device)
+{
+	const char *fw_name = "amd-ucode/microcode_amd.bin";
+	if (request_firmware(&firmware, fw_name, device))
+		printk(KERN_ERR "microcode: failed to load file %s\n", fw_name);
+}
+
+void fini_microcode_amd(void)
+{
+	release_firmware(firmware);
+}
+
 static struct microcode_ops microcode_amd_ops = {
+	.init				  = init_microcode_amd,
+	.fini				  = fini_microcode_amd,
 	.request_microcode_user           = request_microcode_user,
 	.request_microcode_fw             = request_microcode_fw,
 	.collect_cpu_info                 = collect_cpu_info_amd,
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 378e9a8..d2a8160 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -520,6 +520,9 @@ static int __init microcode_init(void)
 		return PTR_ERR(microcode_pdev);
 	}
 
+	if (microcode_ops->init)
+		microcode_ops->init(&microcode_pdev->dev);
+
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
@@ -563,6 +566,9 @@ static void __exit microcode_exit(void)
 
 	platform_device_unregister(microcode_pdev);
 
+	if (microcode_ops->fini)
+		microcode_ops->fini();
+
 	microcode_ops = NULL;
 
 	pr_info("Microcode Update Driver: v" MICROCODE_VERSION " removed.\n");
