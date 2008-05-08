Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbYEHTtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbYEHTtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYEHTs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:48:56 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:2905 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbYEHTsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:48:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=DffbX29uuO7vFp+F/DTswNZxWhBKzS+6VYdeCaM0kSXXKtffYIi+RSShJPb7RFtd1l09svNkUnwT2u8DVcQdwFnRwyVNIsMEhf4dG1hzzYAmy8IYKef0ZxkWzhTDtdgOFb8QdXaT+Wacs0cm9XGj5os4Rd4DF/TNJRud2CFkXo8=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: RFC [PATCH] x86: trust amd new cpu families
Date: Thu, 8 May 2008 12:48:58 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805081248.58912.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


trust family 10h later like K8 Opteron.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 7bf5649..594619d 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1101,7 +1101,7 @@ static int __init detect_init_APIC(void)
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 		if ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model > 1) ||
-		    (boot_cpu_data.x86 == 15))
+		    (boot_cpu_data.x86 >= 0x0f))
 			break;
 		goto no_apic;
 	case X86_VENDOR_INTEL:
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index c2e1ce3..c6eed46 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -55,7 +55,7 @@ void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 {
 	switch (c->x86_vendor) {
 	case X86_VENDOR_AMD:
-		if (c->x86 >= 0xf && c->x86 <= 0x11)
+		if (c->x86 >= 0xf)
 			return;
 		break;
 	case X86_VENDOR_INTEL:
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index e07e8c0..4e3c79a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -472,11 +472,11 @@ static void __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
 {
 	/* This should be disabled by the BIOS, but isn't always */
 	if (c->x86_vendor == X86_VENDOR_AMD) {
-		if(c->x86 == 15)
+		if(c->x86 == 0x0f)
 			/* disable GART TBL walk error reporting, which trips off
 			   incorrectly with the IOMMU & 3ware & Cerberus. */
 			clear_bit(10, &bank[4]);
-		if(c->x86 <= 17 && mce_bootlog < 0)
+		if(mce_bootlog < 0)
 			/* Lots of broken BIOS around that don't clear them
 			   by default and leave crap in there. Don't log. */
 			mce_bootlog = 0;
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index a83f5cd..ce1de46 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -342,7 +342,7 @@ static void set_fixed_range(int msr, bool *changed, unsigned int *msrwords)
 
 	if (lo != msrwords[0] || hi != msrwords[1]) {
 		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
-		    (boot_cpu_data.x86 >= 0x0f && boot_cpu_data.x86 <= 0x11) &&
+		    boot_cpu_data.x86 >= 0x0f &&
 		    ((msrwords[0] | msrwords[1]) & K8_MTRR_RDMEM_WRMEM_MASK))
 			k8_enable_fixed_iorrs();
 		mtrr_wrmsr(msr, msrwords[0], msrwords[1]);
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index e6c162c..3987cd0 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -1398,7 +1398,7 @@ int __init amd_special_default_mtrr(void)
 
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		return 0;
-	if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
+	if (boot_cpu_data.x86 < 0xf)
 		return 0;
 	/* In case some hypervisor doesn't pass SYSCFG through */
 	if (rdmsr_safe(MSR_K8_SYSCFG, &l, &h) < 0)
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index f9ae93a..2128c44 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -618,8 +618,7 @@ static void probe_nmi_watchdog(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
-		if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
-		    boot_cpu_data.x86 != 16)
+		if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 < 0x0f)
 			return;
 		wd_ops = &k7_wd_ops;
 		break;
