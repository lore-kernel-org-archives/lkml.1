Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbYGMVdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbYGMVdi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbYGMVdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:33:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:35967 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbYGMVdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:33:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Kr4sruDIgREpJ6ntz3XdblnjMSybfSS1z+NUceujCye+oBLBY1XNU4/j2UMGuLV4oC
         pUsGMyZ+YkIO95fK1fMLnv5ObiEk7mhpaDffY6Fufw+A+XIqZkcd+hFgpoNmiUDBRQ07
         y15c37GlQqoHoIK/dacq84KpzqhKjli7PdBWw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: get x86_phys_bits early
Date: Sun, 13 Jul 2008 14:30:35 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com> <200807121432.45759.yhlu.kernel@gmail.com>
In-Reply-To: <200807121432.45759.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807131430.36478.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



when try to make hpet_enable use io_remap instead fixmap got

ioremap: invalid physical address fed00000
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:161 __ioremap_caller+0x8c/0x2f3()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.26-rc9-tip-01873-ga9827e7-dirty #358

Call Trace:
 [<ffffffff8026615e>] warn_on_slowpath+0x6c/0xa7
 [<ffffffff802e2313>] ? __slab_alloc+0x20a/0x3fb
 [<ffffffff802d85c5>] ? mpol_new+0x88/0x17d
 [<ffffffff8022a4f4>] ? mcount_call+0x5/0x31
 [<ffffffff8022a4f4>] ? mcount_call+0x5/0x31
 [<ffffffff8024b0d2>] __ioremap_caller+0x8c/0x2f3
 [<ffffffff80e86dbd>] ? hpet_enable+0x39/0x241
 [<ffffffff8022a4f4>] ? mcount_call+0x5/0x31
 [<ffffffff8024b466>] ioremap_nocache+0x2a/0x40
 [<ffffffff80e86dbd>] hpet_enable+0x39/0x241
 [<ffffffff80e7a1f6>] hpet_time_init+0x21/0x4e
 [<ffffffff80e730e9>] start_kernel+0x302/0x395
 [<ffffffff80e722aa>] x86_64_start_reservations+0xb9/0xd4
 [<ffffffff80e722fe>] ? x86_64_init_pda+0x39/0x4f
 [<ffffffff80e72400>] x86_64_start_kernel+0xec/0x107

---[ end trace a7919e7f17c0a725 ]---


it seems for amd system that is set later...
try to move setting early in early_identify_cpu.
and remove same code for intel and centaur.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>


---
 arch/x86/kernel/cpu/centaur_64.c |   10 ----------
 arch/x86/kernel/cpu/common_64.c  |   12 +++++++-----
 arch/x86/kernel/cpu/intel_64.c   |   10 ----------
 3 files changed, 7 insertions(+), 25 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/centaur_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/centaur_64.c
+++ linux-2.6/arch/x86/kernel/cpu/centaur_64.c
@@ -16,16 +16,6 @@ static void __cpuinit early_init_centaur
 
 static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 {
-	/* Cache sizes */
-	unsigned n;
-
-	n = c->extended_cpuid_level;
-	if (n >= 0x80000008) {
-		unsigned eax = cpuid_eax(0x80000008);
-		c->x86_virt_bits = (eax >> 8) & 0xff;
-		c->x86_phys_bits = eax & 0xff;
-	}
-
 	if (c->x86 == 0x6 && c->x86_model >= 0xf) {
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
Index: linux-2.6/arch/x86/kernel/cpu/common_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common_64.c
+++ linux-2.6/arch/x86/kernel/cpu/common_64.c
@@ -99,7 +99,7 @@ int __cpuinit get_model_name(struct cpui
 
 void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 {
-	unsigned int n, dummy, eax, ebx, ecx, edx;
+	unsigned int n, dummy, ebx, ecx, edx;
 
 	n = c->extended_cpuid_level;
 
@@ -122,11 +122,6 @@ void __cpuinit display_cacheinfo(struct
 		printk(KERN_INFO "CPU: L2 Cache: %dK (%d bytes/line)\n",
 		c->x86_cache_size, ecx & 0xFF);
 	}
-	if (n >= 0x80000008) {
-		cpuid(0x80000008, &eax, &dummy, &dummy, &dummy);
-		c->x86_virt_bits = (eax >> 8) & 0xff;
-		c->x86_phys_bits = eax & 0xff;
-	}
 }
 
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
@@ -315,6 +310,13 @@ static void __cpuinit early_identify_cpu
 	if (c->extended_cpuid_level >= 0x80000007)
 		c->x86_power = cpuid_edx(0x80000007);
 
+	if (c->extended_cpuid_level >= 0x80000008) {
+		u32 eax = cpuid_eax(0x80000008);
+
+		c->x86_virt_bits = (eax >> 8) & 0xff;
+		c->x86_phys_bits = eax & 0xff;
+	}
+
 	/* Assume all 64-bit CPUs support 32-bit syscall */
 	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
 
Index: linux-2.6/arch/x86/kernel/cpu/intel_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel_64.c
+++ linux-2.6/arch/x86/kernel/cpu/intel_64.c
@@ -54,9 +54,6 @@ static void __cpuinit srat_detect_node(v
 
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
-	/* Cache sizes */
-	unsigned n;
-
 	init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9) {
 		unsigned eax = cpuid_eax(10);
@@ -78,13 +75,6 @@ static void __cpuinit init_intel(struct
 	if (cpu_has_bts)
 		ds_init_intel(c);
 
-	n = c->extended_cpuid_level;
-	if (n >= 0x80000008) {
-		unsigned eax = cpuid_eax(0x80000008);
-		c->x86_virt_bits = (eax >> 8) & 0xff;
-		c->x86_phys_bits = eax & 0xff;
-	}
-
 	if (c->x86 == 15)
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
 	if (c->x86 == 6)
