Return-Path: <linux-kernel-owner+w=401wt.eu-S1765375AbXJSM4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765375AbXJSM4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759531AbXJSM4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:56:41 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:42022 "EHLO
	outbound6-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757982AbXJSM4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:56:40 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, "Joerg Roedel" <joerg.roedel@amd.com>,
       "Christoph Egger" <Christoph.Egger@amd.com>
Subject: [PATCH 1/2] x86: MCE optimization/refactoring
Date: Fri, 19 Oct 2007 14:54:56 +0200
Message-ID: <11927984971209-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11927984973809-git-send-email-joerg.roedel@amd.com>
References: <11927984973809-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Oct 2007 12:54:58.0064 (UTC)
 FILETIME=[40E6C100:01C8124F]
MIME-Version: 1.0
X-WSS-ID: 6B0676DD1DW2377950-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

MCG_CAP never reports a negative count of available error-reporting banks.
Therefore, make nr_mce_banks unsigned.
Check for MCE feature bit as early as possible and clean up the extra _MCE
checks in the various cpu init type functions per request from Thomas Gleixner.

Signed-off-by: Christoph Egger <Christoph.Egger@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/cpu/mcheck/k7.c  |    6 +-----
 arch/x86/kernel/cpu/mcheck/mce.c |   12 ++++++++++--
 arch/x86/kernel/cpu/mcheck/mce.h |    2 +-
 arch/x86/kernel/cpu/mcheck/p5.c  |    4 ----
 arch/x86/kernel/cpu/mcheck/p6.c  |    4 ----
 5 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/k7.c b/arch/x86/kernel/cpu/mcheck/k7.c
index eef63e3..ad68cc9 100644
--- a/arch/x86/kernel/cpu/mcheck/k7.c
+++ b/arch/x86/kernel/cpu/mcheck/k7.c
@@ -72,13 +72,9 @@ void amd_mcheck_init(struct cpuinfo_x86 *c)
 	u32 l, h;
 	int i;
 
-	if (!cpu_has(c, X86_FEATURE_MCE))
-		return;
-
 	machine_check_vector = k7_machine_check;
 	wmb();
 
-	printk (KERN_INFO "Intel machine check architecture supported.\n");
 	rdmsr (MSR_IA32_MCG_CAP, l, h);
 	if (l & (1<<8))	/* Control register present ? */
 		wrmsr (MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
@@ -97,6 +93,6 @@ void amd_mcheck_init(struct cpuinfo_x86 *c)
 	}
 
 	set_in_cr4 (X86_CR4_MCE);
-	printk (KERN_INFO "Intel machine check reporting enabled on CPU#%d.\n",
+	printk (KERN_INFO "CPU%d: AMD K7 machine check reporting enabled.\n",
 		smp_processor_id());
 }
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 34c781e..c7246cc 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -17,7 +17,7 @@
 #include "mce.h"
 
 int mce_disabled = 0;
-int nr_mce_banks;
+unsigned int nr_mce_banks;
 
 EXPORT_SYMBOL_GPL(nr_mce_banks);	/* non-fatal.o */
 
@@ -33,8 +33,16 @@ void fastcall (*machine_check_vector)(struct pt_regs *, long error_code) = unexp
 /* This has to be run for each processor */
 void mcheck_init(struct cpuinfo_x86 *c)
 {
-	if (mce_disabled==1)
+	if (mce_disabled == 1) {
+		printk(KERN_INFO "MCE support disabled by bootparam\n");
 		return;
+	}
+
+	if (!cpu_has(c, X86_FEATURE_MCE)) {
+		printk(KERN_INFO "CPU%i: No machine check support available\n",
+			smp_processor_id());
+		return;
+	}
 
 	switch (c->x86_vendor) {
 		case X86_VENDOR_AMD:
diff --git a/arch/x86/kernel/cpu/mcheck/mce.h b/arch/x86/kernel/cpu/mcheck/mce.h
index 81fb6e2..9cbe812 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.h
+++ b/arch/x86/kernel/cpu/mcheck/mce.h
@@ -10,5 +10,5 @@ void winchip_mcheck_init(struct cpuinfo_x86 *c);
 /* Call the installed machine check handler for this CPU setup. */
 extern fastcall void (*machine_check_vector)(struct pt_regs *, long error_code);
 
-extern int nr_mce_banks;
+extern unsigned int nr_mce_banks;
 
diff --git a/arch/x86/kernel/cpu/mcheck/p5.c b/arch/x86/kernel/cpu/mcheck/p5.c
index 94bc43d..ddb41d2 100644
--- a/arch/x86/kernel/cpu/mcheck/p5.c
+++ b/arch/x86/kernel/cpu/mcheck/p5.c
@@ -32,10 +32,6 @@ void intel_p5_mcheck_init(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
 	
-	/*Check for MCE support */
-	if( !cpu_has(c, X86_FEATURE_MCE) )
-		return;	
-
 	/* Default P5 to off as its often misconnected */
 	if(mce_disabled != -1)
 		return;
diff --git a/arch/x86/kernel/cpu/mcheck/p6.c b/arch/x86/kernel/cpu/mcheck/p6.c
index deeae42..be29c3c 100644
--- a/arch/x86/kernel/cpu/mcheck/p6.c
+++ b/arch/x86/kernel/cpu/mcheck/p6.c
@@ -84,10 +84,6 @@ void intel_p6_mcheck_init(struct cpuinfo_x86 *c)
 	u32 l, h;
 	int i;
 	
-	/* Check for MCE support */
-	if (!cpu_has(c, X86_FEATURE_MCE))
-		return;
-
 	/* Check for PPro style MCA */
  	if (!cpu_has(c, X86_FEATURE_MCA))
 		return;
-- 
1.5.2.5



