Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbYFJOc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbYFJOc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYFJOcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:32:48 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:7566 "EHLO
	mail38-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYFJOcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:32:47 -0400
X-BigFish: VPS2(zzzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K2934P-01-IOP-01
Date: Tue, 10 Jun 2008 16:05:18 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 2/5] x86: PAT: fix ambiguous paranoia check in pat_init()
Message-ID: <20080610140518.GF5024@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 10 Jun 2008 14:05:12.0580 (UTC) FILETIME=[00061C40:01C8CB03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting with commit 8d4a4300854f3971502e81dacd930704cb88f606 (x86:
cleanup PAT cpu validation) the PAT CPU feature flag is not cleared
anymore. Now the error message

  "PAT enabled, but CPU feature cleared"

in pat_init() is misleading.

Furthermore the current code does not check for existence of the PAT
CPU feature flag if a CPU is whitelisted in validate_pat_support.

This patch clears pat_wc_enabled if boot CPU has no PAT feature flag
and adapts the paranoia check.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |    7 ++++---
 arch/x86/mm/pat.c                          |   11 ++++++-----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 0fbd062..2df461f 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -53,6 +53,9 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_PAT
 void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 {
+	if (!cpu_has_pat)
+		pat_disable("PAT not supported by CPU.");
+
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
 		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
@@ -64,8 +67,6 @@ void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 		return;
 	}
 
-	pat_disable(cpu_has_pat ?
-		    "PAT disabled. Not yet verified on this CPU type." :
-		    "PAT not supported by CPU.");
+	pat_disable("PAT disabled. Not yet verified on this CPU type.");
 }
 #endif
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index e83b770..8f288f8 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -76,14 +76,15 @@ void pat_init(void)
 		return;
 
 	/* Paranoia check. */
-	if (!cpu_has_pat) {
-		printk(KERN_ERR "PAT enabled, but CPU feature cleared\n");
+	if (!cpu_has_pat && boot_pat_state) {
 		/*
-		 * Panic if this happens on the secondary CPU, and we
+		 * If this happens we are on a secondary CPU, but
 		 * switched to PAT on the boot CPU. We have no way to
 		 * undo PAT.
-		*/
-		BUG_ON(boot_pat_state);
+		 */
+		printk(KERN_ERR "PAT enabled, "
+		       "but not supported by secondary CPU\n");
+		BUG();
 	}
 
 	/* Set PWT to Write-Combining. All other bits stay the same */
-- 
1.5.5.3



