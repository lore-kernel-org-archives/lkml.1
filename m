Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYINIOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYINIOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 04:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYINIOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 04:14:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:4077 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYINIOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 04:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SymopjIVfr/4MImIGsdB3ckng15K8b5iZr2XBiQZEpEeaxgQAEvo/tfIBpasQ0kFIB
         Epc7BbslC42Xuc7mVi0FJNjsXlejeVukeROjf3GwjI1GzcWCJ2W9xBGPgw0ULQRv3JoM
         SmznvQFvblwP4XZCNy8StC3hk6fZSam8+afu8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: move transmeta cap read to early_init_transmeta()
Date: Sun, 14 Sep 2008 01:13:30 -0700
Message-Id: <1221380010-6433-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |    8 --------
 arch/x86/kernel/cpu/transmeta.c |   28 +++++++++++++++-------------
 2 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8c831a0..b305664 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -465,14 +465,6 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 	}
 
 #ifdef CONFIG_X86_64
-	/* Transmeta-defined flags: level 0x80860001 */
-	xlvl = cpuid_eax(0x80860000);
-	if ((xlvl & 0xffff0000) == 0x80860000) {
-		/* Don't set x86_cpuid_level here for now to not confuse. */
-		if (xlvl >= 0x80860001)
-			c->x86_capability[2] = cpuid_edx(0x80860001);
-	}
-
 	if (c->extended_cpuid_level >= 0x80000008) {
 		u32 eax = cpuid_eax(0x80000008);
 
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index 738e032..52b3fef 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -5,6 +5,18 @@
 #include <asm/msr.h>
 #include "cpu.h"
 
+static void __cpuinit early_init_transmeta(struct cpuinfo_x86 *c)
+{
+	u32 xlvl;
+
+	/* Transmeta-defined flags: level 0x80860001 */
+	xlvl = cpuid_eax(0x80860000);
+	if ((xlvl & 0xffff0000) == 0x80860000) {
+		if (xlvl >= 0x80860001)
+			c->x86_capability[2] = cpuid_edx(0x80860001);
+	}
+}
+
 static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 {
 	unsigned int cap_mask, uk, max, dummy;
@@ -12,6 +24,8 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 	unsigned int cpu_rev, cpu_freq = 0, cpu_flags, new_cpu_rev;
 	char cpu_info[65];
 
+	early_init_transmeta(c);
+
 	display_cacheinfo(c);
 
 	/* Print CMS and CPU revision */
@@ -84,23 +98,11 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 #endif
 }
 
-static void __cpuinit transmeta_identify(struct cpuinfo_x86 *c)
-{
-	u32 xlvl;
-
-	/* Transmeta-defined flags: level 0x80860001 */
-	xlvl = cpuid_eax(0x80860000);
-	if ((xlvl & 0xffff0000) == 0x80860000) {
-		if (xlvl >= 0x80860001)
-			c->x86_capability[2] = cpuid_edx(0x80860001);
-	}
-}
-
 static struct cpu_dev transmeta_cpu_dev __cpuinitdata = {
 	.c_vendor	= "Transmeta",
 	.c_ident	= { "GenuineTMx86", "TransmetaCPU" },
+	.c_early_init	= early_init_transmeta,
 	.c_init		= init_transmeta,
-	.c_identify	= transmeta_identify,
 	.c_x86_vendor	= X86_VENDOR_TRANSMETA,
 };
 
-- 
1.5.6

