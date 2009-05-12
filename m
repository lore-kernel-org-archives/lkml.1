Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbZELPtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbZELPtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbZELPrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:47:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:51129 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758044AbZELPro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:47:44 -0400
Subject: [PATCH 5/10 -tip] x86: check_powernow() for K8 and later user of
 Advanced Power Management features
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
In-Reply-To: <1242142807.2547.18.camel@ht.satnam>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam>  <1242142692.2547.15.camel@ht.satnam>
	 <1242142753.2547.16.camel@ht.satnam>  <1242142807.2547.18.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 12 May 2009 21:10:49 +0530
Message-Id: <1242142849.2547.19.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use X86_FEATURE_FID, X86_FEATURE_VID and X86_FEATURE_HWPSTATE
to determine K8 and later PowerNOW.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   16 ++++++++--------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    4 ----
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 4709ead..b3f4ec8 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -512,8 +512,9 @@ static int core_voltage_post_transition(struct powernow_k8_data *data,
 
 static int check_supported_cpu(unsigned int cpu)
 {
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	cpumask_t oldmask;
-	u32 eax, ebx, ecx, edx;
+	u32 eax;
 	unsigned int rc = 0;
 
 	oldmask = current->cpus_allowed;
@@ -540,23 +541,22 @@ static int check_supported_cpu(unsigned int cpu)
 			goto out;
 		}
 
-		eax = cpuid_eax(CPUID_GET_MAX_CAPABILITIES);
-		if (eax < CPUID_FREQ_VOLT_CAPABILITIES) {
+		/* Advanced Power Management capabilities */
+		if (c->x86_capability[9]) {
 			printk(KERN_INFO PFX
 			       "No frequency change capabilities detected\n");
 			goto out;
 		}
 
-		cpuid(CPUID_FREQ_VOLT_CAPABILITIES, &eax, &ebx, &ecx, &edx);
-		if ((edx & P_STATE_TRANSITION_CAPABLE)
-			!= P_STATE_TRANSITION_CAPABLE) {
+		/* check for frequncy and volatage ID control support */
+		if (!cpu_has(c, X86_FEATURE_FID) &&
+			!cpu_has(c, X86_FEATURE_VID)) {
 			printk(KERN_INFO PFX
 				"Power state transitions not supported\n");
 			goto out;
 		}
 	} else { /* must be a HW Pstate capable processor */
-		cpuid(CPUID_FREQ_VOLT_CAPABILITIES, &eax, &ebx, &ecx, &edx);
-		if ((edx & USE_HW_PSTATE) == USE_HW_PSTATE)
+		if (cpu_has(c, X86_FEATURE_HWPSTATE))
 			cpu_family = CPU_HW_PSTATE;
 		else
 			goto out;
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
index 6c6698f..4dfe414 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -64,9 +64,6 @@ struct powernow_k8_data {
 #define CPUID_XMOD_REV_MASK		0x000c0000
 #define CPUID_XFAM_10H			0x00100000	/* family 0x10 */
 #define CPUID_USE_XFAM_XMOD		0x00000f00
-#define CPUID_GET_MAX_CAPABILITIES	0x80000000
-#define CPUID_FREQ_VOLT_CAPABILITIES	0x80000007
-#define P_STATE_TRANSITION_CAPABLE	6
 
 /* Model Specific Registers for p-state transitions. MSRs are 64-bit. For     */
 /* writes (wrmsr - opcode 0f 30), the register number is placed in ecx, and   */
@@ -101,7 +98,6 @@ struct powernow_k8_data {
 
 
 /* Hardware Pstate _PSS and MSR definitions */
-#define USE_HW_PSTATE		0x00000080
 #define HW_PSTATE_MASK 		0x00000007
 #define HW_PSTATE_VALID_MASK 	0x80000000
 #define HW_PSTATE_MAX_MASK	0x000000f0
-- 
1.6.0.6



