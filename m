Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbZKJLHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbZKJLHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZKJLHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:07:23 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:56431 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbZKJLHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:07:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y05SOjk8myBt5N+kQmvCf0dxdZ8oyHzCNP7pIr4hK4H40+8dT2gr+MCEl9TrKcGV+u
         r2cqecUaztulGuhJEREYPf9CI6niUOrLtW7dRenf6FJb2eXcQa3BQsS4berqPQ2ryMN8
         q/UFUYhsOam2bJFYieZ+8LsxJLiE+/VzPsvds=
Date: Tue, 10 Nov 2009 12:07:23 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, dimm <dmitry.adamushko@gmail.com>
Subject: [PATCH 1/3] x86, ucode-amd: Load ucode-patches once and not
 separately fo each CPU
Message-ID: <20091110110723.GH30802@alberich.amd.com>
References: <20091110110601.GG30802@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110110601.GG30802@alberich.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This also implies that corresponding log messages, e.g.

  platform microcode: firmware: requesting amd-ucode/microcode_amd.bin

show up only once on module load and not when ucode is updated for
each CPU.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
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
index 2bcad39..230fb09 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -518,6 +518,9 @@ static int __init microcode_init(void)
 		return PTR_ERR(microcode_pdev);
 	}
 
+	if (microcode_ops->init)
+		microcode_ops->init(&microcode_pdev->dev);
+
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
@@ -561,6 +564,9 @@ static void __exit microcode_exit(void)
 
 	platform_device_unregister(microcode_pdev);
 
+	if (microcode_ops->fini)
+		microcode_ops->fini();
+
 	microcode_ops = NULL;
 
 	pr_info("Microcode Update Driver: v" MICROCODE_VERSION " removed.\n");
-- 
1.6.5.2

