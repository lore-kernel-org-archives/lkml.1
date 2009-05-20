Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbZETJmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbZETJmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZETJmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:42:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59492 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbZETJmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:42:43 -0400
Message-ID: <4A13D056.8040309@jp.fujitsu.com>
Date: Wed, 20 May 2009 18:41:42 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH -tip 1/2] x86, mce: Revert "add mce_threshold option for intel
 cmci"
References: <20090519215631.GA15626@basil.nowhere.org>
In-Reply-To: <20090519215631.GA15626@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 0b66224ac2fd303cd2858bf313058c555a555642.

After having some discussion with Andi Kleen, we have concluded
that setting threshold >1 will not work properly.
This patch reverts the previous patch that introduces mce_threshold
option.

However cmci is a new feature so having boot controls to disable it
is generally a good idea, and it might be handy if the hw is
misbehaving.

So instead of mce_threshold, I will introduce "mce=no_cmci" option
to support cmci disablement in later patch.
Compare with mce_threshold, it lacks threshold >1 support but it
does not matter because it will not work.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/kernel-parameters.txt       |    5 ---
 arch/x86/include/asm/msr-index.h          |    1 -
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |   56 ++---------------------------
 3 files changed, 3 insertions(+), 59 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 5e966a9..6172e43 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1208,11 +1208,6 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	mce=option	[X86-64] See Documentation/x86/x86_64/boot-options.txt
 
-	mce_threshold=	[X86-64,intel] Default CMCI threshold
-			Should be unsigned integer. Setting 0 disables cmci.
-			Format: <integer>
-			Default: 1
-
 	md=		[HW] RAID subsystems devices and level
 			See Documentation/md.txt.
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1ea4055..bc2f045 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -85,7 +85,6 @@
 #define MSR_IA32_MC0_CTL2		0x00000280
 #define CMCI_EN			(1ULL << 30)
 #define CMCI_THRESHOLD_MASK		0xffffULL
-#define CMCI_THRESHOLD_VAL_MASK		0x7fffULL
 
 #define MSR_P6_PERFCTR0			0x000000c1
 #define MSR_P6_PERFCTR1			0x000000c2
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index 2970e14..e46c608 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -51,6 +51,8 @@ static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
  */
 static DEFINE_SPINLOCK(cmci_discover_lock);
 
+#define CMCI_THRESHOLD 1
+
 static int cmci_supported(int *banks)
 {
 	u64 cap;
@@ -81,51 +83,6 @@ static void intel_threshold_interrupt(void)
 	mce_notify_user();
 }
 
-/*
- * Default threshold, setting 0 disables cmci
- */
-static unsigned long threshold_limit = 1;
-
-static int __init mcheck_threshold(char *str)
-{
-	int val;
-
-	get_option(&str, &val);
-	if (val < 0) {
-		printk(KERN_INFO "mce_threshold argument ignored.\n");
-		return 0;
-	}
-	threshold_limit = val;
-
-	return 1;
-}
-__setup("mce_threshold=", mcheck_threshold);
-
-void static cmci_set_threshold(int bank)
-{
-	u64 val, limit, max, new;
-
-	rdmsrl(MSR_IA32_MC0_CTL2 + bank, val);
-	limit = val & CMCI_THRESHOLD_VAL_MASK;
-
-	/* Thresholding available? */
-	if (!limit)
-		return;
-	/* Return if no need to change */
-	if (limit == threshold_limit)
-		return;
-
-	/* Find the maximum threshold value */
-	max = (val & ~CMCI_THRESHOLD_MASK) | CMCI_THRESHOLD_VAL_MASK;
-	wrmsrl(MSR_IA32_MC0_CTL2 + bank, max);
-	rdmsrl(MSR_IA32_MC0_CTL2 + bank, max);
-	max &= CMCI_THRESHOLD_VAL_MASK;
-	max = (threshold_limit > max ? max : threshold_limit);
-
-	new = (val & ~CMCI_THRESHOLD_MASK) | max;
-	wrmsrl(MSR_IA32_MC0_CTL2 + bank, new);
-}
-
 static void print_update(char *type, int *hdr, int num)
 {
 	if (*hdr == 0)
@@ -134,9 +91,6 @@ static void print_update(char *type, int *hdr, int num)
 	printk(KERN_CONT " %s:%d", type, num);
 }
 
-/* Used to determine whether thresholding is available or not */
-#define CMCI_THRESHOLD_FIRST 1
-
 /*
  * Enable CMCI (Corrected Machine Check Interrupt) for available MCE banks
  * on this CPU. Use the algorithm recommended in the SDM to discover shared
@@ -148,9 +102,6 @@ static void cmci_discover(int banks, int boot)
 	int hdr = 0;
 	int i;
 
-	if (!threshold_limit)
-		return;
-
 	spin_lock(&cmci_discover_lock);
 	for (i = 0; i < banks; i++) {
 		u64 val;
@@ -168,7 +119,7 @@ static void cmci_discover(int banks, int boot)
 			continue;
 		}
 
-		val |= CMCI_EN | CMCI_THRESHOLD_FIRST;
+		val |= CMCI_EN | CMCI_THRESHOLD;
 		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
 		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
 
@@ -177,7 +128,6 @@ static void cmci_discover(int banks, int boot)
 			if (!test_and_set_bit(i, owned) || boot)
 				print_update("CMCI", &hdr, i);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
-			cmci_set_threshold(i);
 		} else {
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
 		}
-- 
1.6.3

