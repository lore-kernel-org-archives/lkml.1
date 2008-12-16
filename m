Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbYLPSRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbYLPSRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYLPSRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:17:00 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:45200 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYLPSQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:16:59 -0500
X-BigFish: VPS5(z34a4jzzzzzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBZERT-02-W5F-01
Date: Tue, 16 Dec 2008 19:16:34 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [PATCH 6/10] x86: microcode_amd: replace inline asm by common
	rdmsr/wrmsr functions
Message-ID: <20081216181634.GM7013@alberich.amd.com>
References: <20081216180639.GG7013@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081216180639.GG7013@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Dec 2008 18:16:37.0888 (UTC) FILETIME=[6FA43000:01C95FAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/msr-index.h |    2 ++
 arch/x86/kernel/microcode_amd.c  |   23 +++++------------------
 2 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index e38859d..cb58643 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -85,7 +85,9 @@
 /* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
 
+#define MSR_AMD64_PATCH_LEVEL		0x0000008b
 #define MSR_AMD64_NB_CFG		0xc001001f
+#define MSR_AMD64_PATCH_LOADER		0xc0010020
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
 #define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index c7f225c..2856955 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -93,6 +93,7 @@ static struct equiv_cpu_entry *equiv_cpu_table;
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	u32 dummy;
 
 	memset(csig, 0, sizeof(*csig));
 
@@ -102,9 +103,7 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 		return -1;
 	}
 
-	asm volatile("movl %1, %%ecx; rdmsr"
-		     : "=a" (csig->rev)
-		     : "i" (0x0000008B) : "ecx");
+	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
 
 	printk(KERN_INFO "microcode: collect_cpu_info_amd : patch_id=0x%x\n",
 		csig->rev);
@@ -181,12 +180,10 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 static void apply_microcode_amd(int cpu)
 {
 	unsigned long flags;
-	unsigned int eax, edx;
-	unsigned int rev;
+	u32 rev, dummy;
 	int cpu_num = raw_smp_processor_id();
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
 	struct microcode_amd *mc_amd = uci->mc;
-	unsigned long addr;
 
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu_num != cpu);
@@ -195,19 +192,9 @@ static void apply_microcode_amd(int cpu)
 		return;
 
 	spin_lock_irqsave(&microcode_update_lock, flags);
-
-	addr = (unsigned long)&mc_amd->hdr.data_code;
-	edx = (unsigned int)(((unsigned long)upper_32_bits(addr)));
-	eax = (unsigned int)(((unsigned long)lower_32_bits(addr)));
-
-	asm volatile("movl %0, %%ecx; wrmsr" :
-		     : "i" (0xc0010020), "a" (eax), "d" (edx) : "ecx");
-
+	wrmsrl(MSR_AMD64_PATCH_LOADER, &mc_amd->hdr.data_code);
 	/* get patch id after patching */
-	asm volatile("movl %1, %%ecx; rdmsr"
-		     : "=a" (rev)
-		     : "i" (0x0000008B) : "ecx");
-
+	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 	spin_unlock_irqrestore(&microcode_update_lock, flags);
 
 	/* check current patch id and patch's id for match */
-- 
1.6.0.4



