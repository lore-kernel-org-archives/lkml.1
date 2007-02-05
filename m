Return-Path: <linux-kernel-owner+w=401wt.eu-S1751960AbXBERUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbXBERUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbXBERUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:20:15 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:16960 "EHLO
	outbound1-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960AbXBERUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:20:12 -0500
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Mon, 5 Feb 2007 18:19:59 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: linux-kernel@vger.kernel.org, discuss@x86-64.org,
       "Richard Gooch" <rgooch@safe-mbox.com>
Subject: [patch] mtrr: fix issues with large addresses
Message-ID: <20070205171959.GF8665@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Feb 2007 17:20:00.0100 (UTC)
 FILETIME=[DD80E240:01C74949]
X-WSS-ID: 69D9B8C92MC7090153-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a repost of a mail sent to Richard Gooch and lkml some time
ago. Meanwhile I noticed that Richard has a new email address. And it
seems that he does not maintain the mtrr code anymore. (So how about
updating the MAINTAINERS file?)

Here we go again -- with new recipient and a slightly modified
version of the patch.


Regards,

Andreas


mtrr: fix issues with large addresses

Fixes some issues with /proc/mtrr interface:
o If physical address size crosses the 44 bit boundary
  size_or_mask is evaluated wrong
o size_and_mask limits physical base
  address for an MTRR to be less than 44 bit
o added check to restrict base address to 36 bit on i386

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

--
diff --git a/arch/i386/kernel/cpu/mtrr/generic.c b/arch/i386/kernel/cpu/mtrr/generic.c
index f77fc53..aa21d15 100644
--- a/arch/i386/kernel/cpu/mtrr/generic.c
+++ b/arch/i386/kernel/cpu/mtrr/generic.c
@@ -172,7 +172,7 @@ int generic_get_free_region(unsigned long base, unsigned long size, int replace_
 static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 			     unsigned long *size, mtrr_type *type)
 {
-	unsigned int mask_lo, mask_hi, base_lo, base_hi;
+	unsigned long mask_lo, mask_hi, base_lo, base_hi;
 
 	rdmsr(MTRRphysMask_MSR(reg), mask_lo, mask_hi);
 	if ((mask_lo & 0x800) == 0) {
diff --git a/arch/i386/kernel/cpu/mtrr/if.c b/arch/i386/kernel/cpu/mtrr/if.c
index 5ae1705..3abc3f1 100644
--- a/arch/i386/kernel/cpu/mtrr/if.c
+++ b/arch/i386/kernel/cpu/mtrr/if.c
@@ -137,6 +137,10 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 	for (i = 0; i < MTRR_NUM_TYPES; ++i) {
 		if (strcmp(ptr, mtrr_strings[i]))
 			continue;
+#ifndef CONFIG_X86_64
+		if (base > 0xfffffffffULL)
+			return -EINVAL;
+#endif
 		base >>= PAGE_SHIFT;
 		size >>= PAGE_SHIFT;
 		err =
diff --git a/arch/i386/kernel/cpu/mtrr/main.c b/arch/i386/kernel/cpu/mtrr/main.c
index 16bb7ea..0acfb6a 100644
--- a/arch/i386/kernel/cpu/mtrr/main.c
+++ b/arch/i386/kernel/cpu/mtrr/main.c
@@ -50,7 +50,7 @@ u32 num_var_ranges = 0;
 unsigned int *usage_table;
 static DEFINE_MUTEX(mtrr_mutex);
 
-u32 size_or_mask, size_and_mask;
+u64 size_or_mask, size_and_mask;
 
 static struct mtrr_ops * mtrr_ops[X86_VENDOR_NUM] = {};
 
@@ -662,8 +662,8 @@ void __init mtrr_bp_init(void)
 			     boot_cpu_data.x86_mask == 0x4))
 				phys_addr = 36;
 
-			size_or_mask = ~((1 << (phys_addr - PAGE_SHIFT)) - 1);
-			size_and_mask = ~size_or_mask & 0xfff00000;
+			size_or_mask = ~((1ULL << (phys_addr - PAGE_SHIFT)) - 1);
+			size_and_mask = ~size_or_mask & 0xfffff00000ULL;
 		} else if (boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR &&
 			   boot_cpu_data.x86 == 6) {
 			/* VIA C* family have Intel style MTRRs, but
diff --git a/arch/i386/kernel/cpu/mtrr/mtrr.h b/arch/i386/kernel/cpu/mtrr/mtrr.h
index d61ea9d..289dfe6 100644
--- a/arch/i386/kernel/cpu/mtrr/mtrr.h
+++ b/arch/i386/kernel/cpu/mtrr/mtrr.h
@@ -84,7 +84,7 @@ void get_mtrr_state(void);
 
 extern void set_mtrr_ops(struct mtrr_ops * ops);
 
-extern u32 size_or_mask, size_and_mask;
+extern u64 size_or_mask, size_and_mask;
 extern struct mtrr_ops * mtrr_if;
 
 #define is_cpu(vnd)	(mtrr_if && mtrr_if->vendor == X86_VENDOR_##vnd)



