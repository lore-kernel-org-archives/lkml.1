Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYIAEIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYIAEIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 00:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbYIAEIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 00:08:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:60666 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYIAEID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 00:08:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NwtUViSI3IIjN5a3ad6Va2CzXQX5IIG+L6gW55YVoMPw5H2EzBY8d+8lzesCslhyN0
         zu3n6Ik3ssXH090cvQNQ8JnXna8ZwYMeo+Dn6+8c1XDI4k58hPM05R/esV61SiBjbvxX
         FJDASAsFDUWir1a1h7tYxkUbMDAqHLY5GG5OU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: [PATCH] x86: move mtrr cpu cap setting early in early_init_xxxx
Date: Sun, 31 Aug 2008 21:07:05 -0700
Message-Id: <1220242025-15113-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Helt <krzysztof.h1@wp.pl> found mtrr is not detected on k6-2

root case:
	we move mtrr_bp_init early for mtrr trimming.
and in early_detect, only read cap from cpuid, so some cpu doesn't have
that bit in cpuid and need to set workaround bit will have problem.

need to add early_init_xxxx to preset those bit before mtrr_bp_init
for those earlier cpus.

this patch is for 2.6.27

Reported-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>

---
 arch/x86/kernel/cpu/amd.c     |    9 +++++----
 arch/x86/kernel/cpu/centaur.c |   11 +++++++++++
 arch/x86/kernel/cpu/cyrix.c   |   32 ++++++++++++++++++++++++++++----
 3 files changed, 44 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6/arch/x86/kernel/cpu/amd.c
@@ -31,6 +31,11 @@ static void __cpuinit early_init_amd(str
 		if (c->x86_power & (1<<8))
 			set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 	}
+
+	/*  Set MTRR capability flag if appropriate */
+	if (c->x86_model == 13 || c->x86_model == 9 ||
+	   (c->x86_model == 8 && c->x86_mask >= 8))
+		set_cpu_cap(c, X86_FEATURE_K6_MTRR);
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
@@ -166,10 +171,6 @@ static void __cpuinit init_amd(struct cp
 						mbytes);
 				}
 
-				/*  Set MTRR capability flag if appropriate */
-				if (c->x86_model == 13 || c->x86_model == 9 ||
-				   (c->x86_model == 8 && c->x86_mask >= 8))
-					set_cpu_cap(c, X86_FEATURE_K6_MTRR);
 				break;
 			}
 
Index: linux-2.6/arch/x86/kernel/cpu/centaur.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/centaur.c
+++ linux-2.6/arch/x86/kernel/cpu/centaur.c
@@ -314,6 +314,16 @@ enum {
 		EAMD3D		= 1<<20,
 };
 
+static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
+{
+	switch (c->x86) {
+	case 5:
+		/* Emulate MTRRs using Centaur's MCR. */
+		set_cpu_cap(c, X86_FEATURE_CENTAUR_MCR);
+		break;
+	}
+}
+
 static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 {
 
@@ -462,6 +472,7 @@ centaur_size_cache(struct cpuinfo_x86 *c
 static struct cpu_dev centaur_cpu_dev __cpuinitdata = {
 	.c_vendor	= "Centaur",
 	.c_ident	= { "CentaurHauls" },
+	.c_early_init	= early_init_centaur,
 	.c_init		= init_centaur,
 	.c_size_cache	= centaur_size_cache,
 };
Index: linux-2.6/arch/x86/kernel/cpu/cyrix.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cyrix.c
+++ linux-2.6/arch/x86/kernel/cpu/cyrix.c
@@ -15,13 +15,11 @@
 /*
  * Read NSC/Cyrix DEVID registers (DIR) to get more detailed info. about the CPU
  */
-static void __cpuinit do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
+static void __cpuinit __do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
 {
 	unsigned char ccr2, ccr3;
-	unsigned long flags;
 
 	/* we test for DEVID by checking whether CCR3 is writable */
-	local_irq_save(flags);
 	ccr3 = getCx86(CX86_CCR3);
 	setCx86(CX86_CCR3, ccr3 ^ 0x80);
 	getCx86(0xc0);   /* dummy to change bus */
@@ -44,9 +42,16 @@ static void __cpuinit do_cyrix_devid(uns
 		*dir0 = getCx86(CX86_DIR0);
 		*dir1 = getCx86(CX86_DIR1);
 	}
-	local_irq_restore(flags);
 }
 
+static void __cpuinit do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__do_cyrix_devid(dir0, dir1);
+	local_irq_restore(flags);
+}
 /*
  * Cx86_dir0_msb is a HACK needed by check_cx686_cpuid/slop in bugs.h in
  * order to identify the Cyrix CPU model after we're out of setup.c
@@ -161,6 +166,24 @@ static void __cpuinit geode_configure(vo
 	local_irq_restore(flags);
 }
 
+static void __cpuinit early_init_cyrix(struct cpuinfo_x86 *c)
+{
+	unsigned char dir0, dir0_msn, dir1 = 0;
+
+	__do_cyrix_devid(&dir0, &dir1);
+	dir0_msn = dir0 >> 4; /* identifies CPU "family"   */
+
+	switch (dir0_msn) {
+	case 3: /* 6x86/6x86L */
+		/* Emulate MTRRs using Cyrix's ARRs. */
+		set_cpu_cap(c, X86_FEATURE_CYRIX_ARR);
+		break;
+	case 5: /* 6x86MX/M II */
+		/* Emulate MTRRs using Cyrix's ARRs. */
+		set_cpu_cap(c, X86_FEATURE_CYRIX_ARR);
+		break;
+	}
+}
 
 static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 {
@@ -416,6 +439,7 @@ static void __cpuinit cyrix_identify(str
 static struct cpu_dev cyrix_cpu_dev __cpuinitdata = {
 	.c_vendor	= "Cyrix",
 	.c_ident	= { "CyrixInstead" },
+	.c_early_init	= early_init_cyrix,
 	.c_init		= init_cyrix,
 	.c_identify	= cyrix_identify,
 };
