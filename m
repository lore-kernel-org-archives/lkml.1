Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbYCXW7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbYCXW7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 18:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYCXW7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 18:59:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:10618 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbYCXW7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 18:59:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:reply-to:content-type:content-transfer-encoding:from;
        b=Jjlw+6r9r8lujVl8BhjlwUySh02ZbUg/WV6rU8DPv5wqMCrjSkgqzM54OYXTYzDlmD2WsRV0DXYRzT+GqQOOBWGL5JH9WdPga02PqY21YjjPtcApXKgZ0F9aqdX1QSmGmHG48MHZBp99l84VzPh+lecpGeIv85sre7RGdEL6gqs=
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: enable PAT for amd k8 and fam10h
Date: Mon, 24 Mar 2008 16:02:01 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803241602.01957.yhlu.kernel@gmail.com>
Reply-To: yhlu.kernel@gmail.com
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: enable PAT for amd k8 and fam10h

make known_pat_cpu to think amd k8 and fam10h is ok too.

also make tom2 below to be WRBACK

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 011e07e..74ec2ea 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -37,6 +37,7 @@ static struct fixed_range_block fixed_range_blocks[] = {
 static unsigned long smp_changes_mask;
 static struct mtrr_state mtrr_state = {};
 static int mtrr_state_set;
+static u64 tom2;
 
 #undef MODULE_PARAM_PREFIX
 #define MODULE_PARAM_PREFIX "mtrr."
@@ -138,6 +139,11 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 		}
 	}
 
+	if (tom2) {
+		if (start >= (1ULL<<32) && (end < tom2))
+			return MTRR_TYPE_WRBACK;
+	}
+
 	if (prev_match != 0xFF)
 		return prev_match;
 
@@ -206,6 +212,15 @@ void __init get_mtrr_state(void)
 	mtrr_state.def_type = (lo & 0xff);
 	mtrr_state.enabled = (lo & 0xc00) >> 10;
 
+	if (amd_special_default_mtrr()) {
+		unsigned lo, hi;
+		/* TOP_MEM2 */
+		rdmsr(MSR_K8_TOP_MEM2, lo, hi);
+		tom2 = hi;
+		tom2 <<= 32;
+		tom2 |= lo;
+		tom2 &= 0xffffff8000000ULL;
+	}
 	if (mtrr_show) {
 		int high_width;
 
@@ -236,6 +251,8 @@ void __init get_mtrr_state(void)
 			else
 				printk(KERN_INFO "MTRR %u disabled\n", i);
 		}
+		if (tom2)
+			printk(KERN_INFO "TOM2: %016lx aka %ldM\n", tom2, tom2>>20);
 	}
 	mtrr_state_set = 1;
 
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index a6450b3..6a1e278 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -627,7 +627,7 @@ early_param("disable_mtrr_trim", disable_mtrr_trim_setup);
 #define Tom2Enabled (1U << 21)
 #define Tom2ForceMemTypeWB (1U << 22)
 
-static __init int amd_special_default_mtrr(void)
+int __init amd_special_default_mtrr(void)
 {
 	u32 l, h;
 
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index f74505f..a9e1a27 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -49,6 +49,12 @@ static int pat_known_cpu(void)
 			return 1;
 		}
 	}
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+	     boot_cpu_data.x86 >= 0xf && boot_cpu_data.x86 <= 0x11) {
+		if (cpu_has_pat) {
+			return 1;
+		}
+	}
 
 	pat_wc_enabled = 0;
 	printk(KERN_INFO "CPU and/or kernel does not support PAT.\n");
diff --git a/include/asm-x86/mtrr.h b/include/asm-x86/mtrr.h
index ee17229..d3d2662 100644
--- a/include/asm-x86/mtrr.h
+++ b/include/asm-x86/mtrr.h
@@ -99,6 +99,7 @@ extern void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi);
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
 extern int mtrr_trim_uncached_memory(unsigned long end_pfn);
+extern int amd_special_default_mtrr(void);
 #  else
 static inline u8 mtrr_type_lookup(u64 addr, u64 end)
 {
