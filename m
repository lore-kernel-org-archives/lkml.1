Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbZELSpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbZELSpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 14:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbZELSpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 14:45:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:55519 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbZELSpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 14:45:30 -0400
Subject: Re: [PATCH 5/10 -tip] x86: check_powernow() for K8 and later user
 of Advanced Power Management features
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
In-Reply-To: <20090512174848.GA3313@elte.hu>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam> <1242142692.2547.15.camel@ht.satnam>
	 <1242142753.2547.16.camel@ht.satnam> <1242142807.2547.18.camel@ht.satnam>
	 <1242142849.2547.19.camel@ht.satnam>  <20090512174848.GA3313@elte.hu>
Content-Type: text/plain
Date: Wed, 13 May 2009 00:15:26 +0530
Message-Id: <1242153926.2492.49.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 19:48 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > -		eax = cpuid_eax(CPUID_GET_MAX_CAPABILITIES);
> > -		if (eax < CPUID_FREQ_VOLT_CAPABILITIES) {
> > +		/* Advanced Power Management capabilities */
> > +		if (c->x86_capability[9]) {
> >  			printk(KERN_INFO PFX
> >  			       "No frequency change capabilities detected\n");
> >  			goto out;
> >  		}
> 
> How is the new check equivalent to the old one? It isnt and this is 
> a bug.
> 
> Also, open-coding x86_capability[9] like that is quite unclean. Were 
> we ever to reorder those bits internally, this could would break.
> 
> But i see what you are trying to do. A better method might be to add 
> a new helper:
> 
> +#define X86_FEATURE_TS         (9*32+ 0) /* Temperatue sensor          */
> +#define X86_FEATURE_FID                (9*32+ 1) /* Frequency ID control	*/
> +#define X86_FEATURE_VID                (9*32+ 2) /* Voltage ID control		*/
> +#define X86_FEATURE_TTP                (9*32+ 3) /* Thermal trip   	*/
> +#define X86_FEATURE_HTC                (9*32+ 4) /* Hardware thermal control   */
> +#define X86_FEATURE_STC                (9*32+ 5) /* Software thermal control   */
> +#define X86_FEATURE_100MHZSTEPS        (9*32+ 6) /* 100 MHz multiplier control */
> +#define X86_FEATURE_HWPSTATE   (9*32+ 7) /* Hardware P-State control   */
> +#define X86_FEATURE_CONSTANT_TSC (9*32+ 8) /* Constant rate TSC ticks  */
> 
> ... to represent the 'is any of these set' property.
> 

Yes, I was also thinking about adding this helper cpufeature, may be
that's why I made above mistake ;-)

> [ btw., there's a typo in the X86_FEATURE_TS comment above ]
> 

Ok I will send updated patches and new pull request :-)


[PATCH-tip] x86: check_powernow() for K8 and later user of Advanced Power Management features

use X86_FEATURE_POWER_MGMT, X86_FEATURE_FID, X86_FEATURE_VID and
X86_FEATURE_HWPSTATE to determine K8 and later PowerNOW.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   16 ++++++++--------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    4 ----
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 4709ead..c9869fd 100644
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
+		if (!cpu_has(c, X86_FEATURE_POWER_MGMT)) {
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



