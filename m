Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbYLPSXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbYLPSXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYLPSWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:22:54 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:29592 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYLPSWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:22:53 -0500
X-BigFish: VPS-2(zz154dMzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KBZF1L-01-D6O-01
Date: Tue, 16 Dec 2008 19:22:36 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [PATCH 10/10] x86: microcode_amd: modify log messages
Message-ID: <20081216182236.GQ7013@alberich.amd.com>
References: <20081216180639.GG7013@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081216180639.GG7013@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Dec 2008 18:22:40.0025 (UTC) FILETIME=[477DE890:01C95FAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log level and provide (at least I tried to;-) consistent, short,
meaningful content.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   58 +++++++++++++++++---------------------
 1 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index e1ce650..24c256f 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -91,18 +91,13 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 	u32 dummy;
 
 	memset(csig, 0, sizeof(*csig));
-
 	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
-		printk(KERN_ERR "microcode: CPU%d not a capable AMD processor\n",
-		       cpu);
+		printk(KERN_WARNING "microcode: CPU%d: AMD CPU family 0x%x not "
+		       "supported\n", cpu, c->x86);
 		return -1;
 	}
-
 	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
-
-	printk(KERN_INFO "microcode: collect_cpu_info_amd : patch_id=0x%x\n",
-		csig->rev);
-
+	printk(KERN_INFO "microcode: CPU%d: patch_level=0x%x\n", cpu, csig->rev);
 	return 0;
 }
 
@@ -125,21 +120,21 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 	}
 
 	if (!equiv_cpu_id) {
-		printk(KERN_ERR "microcode: CPU%d cpu_id "
-		       "not found in equivalent cpu table\n", cpu);
+		printk(KERN_WARNING "microcode: CPU%d: cpu revision "
+		       "not listed in equivalent cpu table\n", cpu);
 		return 0;
 	}
 
 	if (mc_header->processor_rev_id != equiv_cpu_id) {
-		printk(KERN_ERR	"microcode: CPU%d patch does not match "
-		       "(processor_rev_id: %x, eqiv_cpu_id: %x)\n",
+		printk(KERN_ERR	"microcode: CPU%d: patch mismatch "
+		       "(processor_rev_id: %x, equiv_cpu_id: %x)\n",
 		       cpu, mc_header->processor_rev_id, equiv_cpu_id);
 		return 0;
 	}
 
 	/* ucode might be chipset specific -- currently we don't support this */
 	if (mc_header->nb_dev_id || mc_header->sb_dev_id) {
-		printk(KERN_WARNING "microcode: CPU%d loading of chipset "
+		printk(KERN_ERR "microcode: CPU%d: loading of chipset "
 		       "specific code not yet supported\n", cpu);
 		return 0;
 	}
@@ -172,15 +167,13 @@ static void apply_microcode_amd(int cpu)
 
 	/* check current patch id and patch's id for match */
 	if (rev != mc_amd->hdr.patch_id) {
-		printk(KERN_ERR "microcode: CPU%d update from revision "
-		       "0x%x to 0x%x failed\n", cpu_num,
-		       mc_amd->hdr.patch_id, rev);
+		printk(KERN_ERR "microcode: CPU%d: update failed "
+		       "(for patch_level=0x%x)\n", cpu, mc_amd->hdr.patch_id);
 		return;
 	}
 
-	printk(KERN_INFO "microcode: CPU%d updated from revision "
-	       "0x%x to 0x%x\n",
-	       cpu_num, uci->cpu_sig.rev, mc_amd->hdr.patch_id);
+	printk(KERN_INFO "microcode: CPU%d: updated (new patch_level=0x%x)\n",
+	       cpu, rev);
 
 	uci->cpu_sig.rev = rev;
 }
@@ -202,18 +195,18 @@ static void *get_next_ucode(const u8 *buf, unsigned int size,
 		return NULL;
 
 	if (section_hdr[0] != UCODE_UCODE_TYPE) {
-		printk(KERN_ERR "microcode: error! "
-		       "Wrong microcode payload type field\n");
+		printk(KERN_ERR "microcode: error: invalid type field in "
+		       "container file section header\n");
 		return NULL;
 	}
 
 	total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
 
-	printk(KERN_INFO "microcode: size %u, total_size %u\n",
-		size, total_size);
+	printk(KERN_DEBUG "microcode: size %u, total_size %u\n",
+	       size, total_size);
 
 	if (total_size > size || total_size > UCODE_MAX_SIZE) {
-		printk(KERN_ERR "microcode: error! Bad data in microcode data file\n");
+		printk(KERN_ERR "microcode: error: size mismatch\n");
 		return NULL;
 	}
 
@@ -243,14 +236,15 @@ static int install_equiv_cpu_table(const u8 *buf)
 	size = buf_pos[2];
 
 	if (buf_pos[1] != UCODE_EQUIV_CPU_TABLE_TYPE || !size) {
-		printk(KERN_ERR "microcode: error! "
-		       "Wrong microcode equivalent cpu table\n");
+		printk(KERN_ERR "microcode: error: invalid type field in "
+		       "container file section header\n");
 		return 0;
 	}
 
 	equiv_cpu_table = (struct equiv_cpu_entry *) vmalloc(size);
 	if (!equiv_cpu_table) {
-		printk(KERN_ERR "microcode: error, can't allocate memory for equiv CPU table\n");
+		printk(KERN_ERR "microcode: failed to allocate "
+		       "equivalent CPU table\n");
 		return 0;
 	}
 
@@ -283,7 +277,8 @@ static int generic_load_microcode(int cpu, const u8 *data, size_t size)
 
 	offset = install_equiv_cpu_table(ucode_ptr);
 	if (!offset) {
-		printk(KERN_ERR "microcode: installing equivalent cpu table failed\n");
+		printk(KERN_ERR "microcode: failed to create "
+		       "equivalent cpu table\n");
 		return -EINVAL;
 	}
 
@@ -339,8 +334,7 @@ static int request_microcode_fw(int cpu, struct device *device)
 
 	ret = request_firmware(&firmware, fw_name, device);
 	if (ret) {
-		printk(KERN_ERR "microcode: ucode data file %s load failed\n",
-		       fw_name);
+		printk(KERN_ERR "microcode: failed to load file %s\n", fw_name);
 		return ret;
 	}
 
@@ -353,8 +347,8 @@ static int request_microcode_fw(int cpu, struct device *device)
 
 static int request_microcode_user(int cpu, const void __user *buf, size_t size)
 {
-	printk(KERN_WARNING "microcode: AMD microcode update via "
-	       "/dev/cpu/microcode is not supported\n");
+	printk(KERN_INFO "microcode: AMD microcode update via "
+	       "/dev/cpu/microcode not supported\n");
 	return -1;
 }
 
-- 
1.6.0.4



