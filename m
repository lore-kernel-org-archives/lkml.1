Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZLCVCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZLCVCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZLCVCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:02:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41769 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbZLCVCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:02:52 -0500
Date: Thu, 3 Dec 2009 22:02:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [GIT PULL] x86/microcode for v2.6.33
Message-ID: <20091203210246.GA24240@elte.hu>
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

Please pull the latest x86-microcode-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-microcode-for-linus

 Thanks,

	Ingo

------------------>
Andreas Herrmann (6):
      x86, amd-ucode: Remove needless log messages
      x86: ucode-amd: Load ucode-patches once and not separately of each CPU
      x86: ucode-amd: Don't warn when no ucode is available for a CPU revision
      x86: ucode-amd: Convert printk(KERN_*...) to pr_*(...)
      x86, ucode-amd: Ensure ucode update on suspend/resume after CPU off/online cycle
      x86: ucode-amd: Move family check to microcde_amd.c's init function


 arch/x86/include/asm/microcode.h |    2 +
 arch/x86/kernel/microcode_amd.c  |   87 ++++++++++++++++++++------------------
 arch/x86/kernel/microcode_core.c |    8 +++-
 3 files changed, 55 insertions(+), 42 deletions(-)

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
index f4c538b..63123d9 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -33,6 +33,9 @@ MODULE_LICENSE("GPL v2");
 #define UCODE_EQUIV_CPU_TABLE_TYPE 0x00000000
 #define UCODE_UCODE_TYPE           0x00000001
 
+const struct firmware *firmware;
+static int supported_cpu;
+
 struct equiv_cpu_entry {
 	u32	installed_cpu;
 	u32	fixed_errata_mask;
@@ -71,17 +74,14 @@ static struct equiv_cpu_entry *equiv_cpu_table;
 
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	u32 dummy;
 
-	memset(csig, 0, sizeof(*csig));
-	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
-		printk(KERN_WARNING "microcode: CPU%d: AMD CPU family 0x%x not "
-		       "supported\n", cpu, c->x86);
+	if (!supported_cpu)
 		return -1;
-	}
+
+	memset(csig, 0, sizeof(*csig));
 	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
-	printk(KERN_INFO "microcode: CPU%d: patch_level=0x%x\n", cpu, csig->rev);
+	pr_info("microcode: CPU%d: patch_level=0x%x\n", cpu, csig->rev);
 	return 0;
 }
 
@@ -103,22 +103,15 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 		i++;
 	}
 
-	if (!equiv_cpu_id) {
-		printk(KERN_WARNING "microcode: CPU%d: cpu revision "
-		       "not listed in equivalent cpu table\n", cpu);
+	if (!equiv_cpu_id)
 		return 0;
-	}
 
-	if (mc_header->processor_rev_id != equiv_cpu_id) {
-		printk(KERN_ERR	"microcode: CPU%d: patch mismatch "
-		       "(processor_rev_id: %x, equiv_cpu_id: %x)\n",
-		       cpu, mc_header->processor_rev_id, equiv_cpu_id);
+	if (mc_header->processor_rev_id != equiv_cpu_id)
 		return 0;
-	}
 
 	/* ucode might be chipset specific -- currently we don't support this */
 	if (mc_header->nb_dev_id || mc_header->sb_dev_id) {
-		printk(KERN_ERR "microcode: CPU%d: loading of chipset "
+		pr_err(KERN_ERR "microcode: CPU%d: loading of chipset "
 		       "specific code not yet supported\n", cpu);
 		return 0;
 	}
@@ -148,14 +141,12 @@ static int apply_microcode_amd(int cpu)
 
 	/* check current patch id and patch's id for match */
 	if (rev != mc_amd->hdr.patch_id) {
-		printk(KERN_ERR "microcode: CPU%d: update failed "
+		pr_err("microcode: CPU%d: update failed "
 		       "(for patch_level=0x%x)\n", cpu, mc_amd->hdr.patch_id);
 		return -1;
 	}
 
-	printk(KERN_INFO "microcode: CPU%d: updated (new patch_level=0x%x)\n",
-	       cpu, rev);
-
+	pr_info("microcode: CPU%d: updated (new patch_level=0x%x)\n", cpu, rev);
 	uci->cpu_sig.rev = rev;
 
 	return 0;
@@ -178,18 +169,15 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 		return NULL;
 
 	if (section_hdr[0] != UCODE_UCODE_TYPE) {
-		printk(KERN_ERR "microcode: error: invalid type field in "
+		pr_err("microcode: error: invalid type field in "
 		       "container file section header\n");
 		return NULL;
 	}
 
 	total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
 
-	printk(KERN_DEBUG "microcode: size %u, total_size %u\n",
-	       size, total_size);
-
 	if (total_size > size || total_size > UCODE_MAX_SIZE) {
-		printk(KERN_ERR "microcode: error: size mismatch\n");
+		pr_err("microcode: error: size mismatch\n");
 		return NULL;
 	}
 
@@ -218,15 +206,14 @@ static int install_equiv_cpu_table(const u8 *buf)
 	size = buf_pos[2];
 
 	if (buf_pos[1] != UCODE_EQUIV_CPU_TABLE_TYPE || !size) {
-		printk(KERN_ERR "microcode: error: invalid type field in "
+		pr_err("microcode: error: invalid type field in "
 		       "container file section header\n");
 		return 0;
 	}
 
 	equiv_cpu_table = (struct equiv_cpu_entry *) vmalloc(size);
 	if (!equiv_cpu_table) {
-		printk(KERN_ERR "microcode: failed to allocate "
-		       "equivalent CPU table\n");
+		pr_err("microcode: failed to allocate equivalent CPU table\n");
 		return 0;
 	}
 
@@ -259,8 +246,7 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 
 	offset = install_equiv_cpu_table(ucode_ptr);
 	if (!offset) {
-		printk(KERN_ERR "microcode: failed to create "
-		       "equivalent cpu table\n");
+		pr_err("microcode: failed to create equivalent cpu table\n");
 		return UCODE_ERROR;
 	}
 
@@ -308,33 +294,27 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 
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
-		printk(KERN_ERR "microcode: invalid UCODE_MAGIC (0x%08x)\n",
+		pr_err("microcode: invalid UCODE_MAGIC (0x%08x)\n",
 		       *(u32 *)firmware->data);
 		return UCODE_ERROR;
 	}
 
 	ret = generic_load_microcode(cpu, firmware->data, firmware->size);
 
-	release_firmware(firmware);
-
 	return ret;
 }
 
 static enum ucode_state
 request_microcode_user(int cpu, const void __user *buf, size_t size)
 {
-	printk(KERN_INFO "microcode: AMD microcode update via "
-	       "/dev/cpu/microcode not supported\n");
+	pr_info("microcode: AMD microcode update via "
+		"/dev/cpu/microcode not supported\n");
 	return UCODE_ERROR;
 }
 
@@ -346,7 +326,32 @@ static void microcode_fini_cpu_amd(int cpu)
 	uci->mc = NULL;
 }
 
+void init_microcode_amd(struct device *device)
+{
+	const char *fw_name = "amd-ucode/microcode_amd.bin";
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	WARN_ON(c->x86_vendor != X86_VENDOR_AMD);
+
+	if (c->x86 < 0x10) {
+		pr_warning("microcode: AMD CPU family 0x%x not supported\n",
+			   c->x86);
+		return;
+	}
+	supported_cpu = 1;
+
+	if (request_firmware(&firmware, fw_name, device))
+		pr_err("microcode: failed to load file %s\n", fw_name);
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
index 378e9a8..adf2340 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -393,7 +393,7 @@ static enum ucode_state microcode_update_cpu(int cpu)
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	enum ucode_state ustate;
 
-	if (uci->valid)
+	if (uci->valid && uci->mc)
 		ustate = microcode_resume_cpu(cpu);
 	else
 		ustate = microcode_init_cpu(cpu);
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
