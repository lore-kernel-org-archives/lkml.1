Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbZFOIXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbZFOIXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZFOIXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:23:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45637 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZFOIW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:22:59 -0400
Message-ID: <4A3604D9.8030505@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:22:49 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/16] x86, mce: make mce_disabled boolean
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mce_disabled on 32bit is a tristate variable [1,0,-1],
while 64bit version is boolean [0,1].
This patch makes mce_disabled always boolean, and use mce_p5_enabled
to indicate the third state instead.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h       |    8 +++-----
 arch/x86/kernel/cpu/mcheck/mce.c |    8 +++-----
 arch/x86/kernel/cpu/mcheck/p5.c  |   12 +++++-------
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index aae6fe2..6568cde 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -107,6 +107,7 @@ struct mce_log {
 #include <asm/atomic.h>
 
 extern int mce_disabled;
+extern int mce_p5_enabled;
 
 #ifdef CONFIG_X86_OLD_MCE
 void amd_mcheck_init(struct cpuinfo_x86 *c);
@@ -117,14 +118,11 @@ void intel_p6_mcheck_init(struct cpuinfo_x86 *c);
 #ifdef CONFIG_X86_ANCIENT_MCE
 void intel_p5_mcheck_init(struct cpuinfo_x86 *c);
 void winchip_mcheck_init(struct cpuinfo_x86 *c);
-extern int mce_p5_enable;
-static inline int mce_p5_enabled(void) { return mce_p5_enable; }
-static inline void enable_p5_mce(void) { mce_p5_enable = 1; }
+static inline void enable_p5_mce(void) { mce_p5_enabled = 1; }
 #else
 static inline void intel_p5_mcheck_init(struct cpuinfo_x86 *c) {}
 static inline void winchip_mcheck_init(struct cpuinfo_x86 *c) {}
-static inline int mce_p5_enabled(void) { return 0; }
-static inline void enable_p5_mce(void) { }
+static inline void enable_p5_mce(void) {}
 #endif
 
 /* Call the installed machine check handler for this CPU setup. */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index c184dc7..e0d5af0 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1279,8 +1279,7 @@ static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
 		return;
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
-		if (mce_p5_enabled())
-			intel_p5_mcheck_init(c);
+		intel_p5_mcheck_init(c);
 		break;
 	case X86_VENDOR_CENTAUR:
 		winchip_mcheck_init(c);
@@ -1995,7 +1994,7 @@ EXPORT_SYMBOL_GPL(nr_mce_banks);	/* non-fatal.o */
 /* This has to be run for each processor */
 void mcheck_init(struct cpuinfo_x86 *c)
 {
-	if (mce_disabled == 1)
+	if (mce_disabled)
 		return;
 
 	switch (c->x86_vendor) {
@@ -2025,10 +2024,9 @@ void mcheck_init(struct cpuinfo_x86 *c)
 
 static int __init mcheck_enable(char *str)
 {
-	mce_disabled = -1;
+	mce_p5_enabled = 1;
 	return 1;
 }
-
 __setup("mce", mcheck_enable);
 
 #endif /* CONFIG_X86_OLD_MCE */
diff --git a/arch/x86/kernel/cpu/mcheck/p5.c b/arch/x86/kernel/cpu/mcheck/p5.c
index 747853f..5c0e653 100644
--- a/arch/x86/kernel/cpu/mcheck/p5.c
+++ b/arch/x86/kernel/cpu/mcheck/p5.c
@@ -14,7 +14,7 @@
 #include <asm/msr.h>
 
 /* By default disabled */
-int		mce_p5_enable;
+int mce_p5_enabled __read_mostly;
 
 /* Machine check handler for Pentium class Intel CPUs: */
 static void pentium_machine_check(struct pt_regs *regs, long error_code)
@@ -42,15 +42,13 @@ void intel_p5_mcheck_init(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
 
-	/* Check for MCE support: */
-	if (!cpu_has(c, X86_FEATURE_MCE))
+	/* Default P5 to off as its often misconnected: */
+	if (!mce_p5_enabled)
 		return;
 
-#ifdef CONFIG_X86_OLD_MCE
-	/* Default P5 to off as its often misconnected: */
-	if (mce_disabled != -1)
+	/* Check for MCE support: */
+	if (!cpu_has(c, X86_FEATURE_MCE))
 		return;
-#endif
 
 	machine_check_vector = pentium_machine_check;
 	/* Make sure the vector pointer is visible before we enable MCEs: */
-- 
1.6.3


