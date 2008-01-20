Return-Path: <linux-kernel-owner+w=401wt.eu-S1752197AbYATILY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbYATILY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 03:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYATILO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 03:11:14 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:53297 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbYATILN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 03:11:13 -0500
Date: Sun, 20 Jan 2008 00:17:24 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: update e820 instead of updating end_pfn
In-reply-to: <4792DE0C.9060906@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200801200017.24445.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com> <4792DE0C.9060906@zytor.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: update e820 instead of updating end_pfn

when mtrr is not covering all e820 table, need to trim the ram, need to update e820

so we can reuse some code for x86_32.

need to add early_identify_cpu for x86_32, and move mtrr_bp_init early

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 46763e3..28ae79a 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -644,16 +644,17 @@ early_param("disable_mtrr_trim", disable_mtrr_trim_setup);
  * it from the kernel's allocation pools, warning the user with an obnoxious
  * message.
  */
-void __init mtrr_trim_uncached_memory(void)
+int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 {
 	unsigned long i, base, size, highest_addr = 0, def, dummy;
 	mtrr_type type;
+	u64 trim_start, trim_size;
 
 	/* Make sure we only trim uncachable memory on Intel machines */
 	rdmsr(MTRRdefType_MSR, def, dummy);
 	def &= 0xff;
 	if (!is_cpu(INTEL) || disable_mtrr_trim || def != MTRR_TYPE_UNCACHABLE)
-		return;
+		return 0;
 
 	/* Find highest cached pfn */
 	for (i = 0; i < num_var_ranges; i++) {
@@ -673,8 +674,18 @@ void __init mtrr_trim_uncached_memory(void)
 		       "memory, trimmed %ld pages\n", end_pfn -
 		       (highest_addr >> PAGE_SHIFT));
 		printk(KERN_WARNING "***************\n");
-		end_pfn = highest_addr >> PAGE_SHIFT;
+
+		printk(KERN_INFO "update e820 for mtrr\n");
+		trim_start = highest_addr;
+		trim_size = end_pfn;
+		trim_size <<= PAGE_SHIFT;
+		trim_size -= trim_start;
+		add_memory_region(trim_start, trim_size, E820_RESERVED);
+		update_e820();
+		return 1;
 	}
+
+	return 0;
 }
 #endif
 
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 2ad8bdd..5194c2a 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -324,9 +324,12 @@ void __init setup_arch(char **cmdline_p)
 	 * we are rounding upwards:
 	 */
 	end_pfn = e820_end_of_ram();
-	/* Trim memory not covered by WB MTRRs */
+	/* update e820 for memory not covered by WB MTRRs */
 	mtrr_bp_init();
-	mtrr_trim_uncached_memory();
+	if (mtrr_trim_uncached_memory(end_pfn)) {
+		e820_register_active_regions(0, 0, -1UL);
+		end_pfn = e820_end_of_ram();
+	}
 
 	num_physpages = end_pfn;
 
diff --git a/include/asm-x86/mtrr.h b/include/asm-x86/mtrr.h
index 96876ec..e552503 100644
--- a/include/asm-x86/mtrr.h
+++ b/include/asm-x86/mtrr.h
@@ -97,7 +97,7 @@ extern int mtrr_del_page (int reg, unsigned long base, unsigned long size);
 extern void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi);
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
-extern void mtrr_trim_uncached_memory(void);
+extern int mtrr_trim_uncached_memory(unsigned long end_pfn);
 #  else
 #define mtrr_save_fixed_ranges(arg) do {} while (0)
 #define mtrr_save_state() do {} while (0)
@@ -121,8 +121,9 @@ static __inline__ int mtrr_del_page (int reg, unsigned long base,
 {
     return -ENODEV;
 }
-static __inline__ void mtrr_trim_uncached_memory(void)
+static __inline__ int mtrr_trim_uncached_memory(unsigned long end_pfn)
 {
+	return 0;
 }
 static __inline__ void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi) {;}
 
