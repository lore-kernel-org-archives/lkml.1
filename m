Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbYFUINk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbYFUINk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 04:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYFUINZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 04:13:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:3973 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYFUINX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 04:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=GJ3coxk3B2nulhUw/g/BOnYeif6MQs3tNbAwckTbcX5uTxGa/5pbnYnU3enYo70mB1
         VxZL+HCfKVmgrpa85PDgR0LO83Wj7QjDIx0c1SacvYBkiIkNf8GDU4v/zniVYCObN/v1
         KHm1WwFjQPp4wNSTURQtLD9Y/0KyuKH6gHESo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: clean up init_amd()
Date: Sat, 21 Jun 2008 01:14:27 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200806200742.36226.yhlu.kernel@gmail.com> <200806201611.21198.yhlu.kernel@gmail.com>
In-Reply-To: <200806201611.21198.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806210114.27610.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1. move out calling of check_enable_amd_mmconf_dmi out of setup_64.c
   put it into init_amd(), so don't need to make extra dmi check for
   system with other cpus.
2. 15 --> 0xf


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/amd_64.c |   22 ++++++++++++++--------
 arch/x86/kernel/setup_64.c   |    4 ----
 2 files changed, 14 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/amd_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd_64.c
+++ linux-2.6/arch/x86/kernel/cpu/amd_64.c
@@ -131,7 +131,7 @@ static void __cpuinit init_amd(struct cp
 	 * Errata 63 for SH-B3 steppings
 	 * Errata 122 for all steppings (F+ have it disabled by default)
 	 */
-	if (c->x86 == 15) {
+	if (c->x86 == 0xf) {
 		rdmsrl(MSR_K8_HWCR, value);
 		value |= 1 << 6;
 		wrmsrl(MSR_K8_HWCR, value);
@@ -143,10 +143,11 @@ static void __cpuinit init_amd(struct cp
 	clear_cpu_cap(c, 0*32+31);
 
 	/* On C+ stepping K8 rep microcode works well for copy/memset */
-	level = cpuid_eax(1);
-	if (c->x86 == 15 && ((level >= 0x0f48 && level < 0x0f50) ||
-			     level >= 0x0f58))
-		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+	if (c->x86 == 0xf) {
+		level = cpuid_eax(1);
+		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
+			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+	}
 	if (c->x86 == 0x10 || c->x86 == 0x11)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 
@@ -157,7 +158,7 @@ static void __cpuinit init_amd(struct cp
 	level = get_model_name(c);
 	if (!level) {
 		switch (c->x86) {
-		case 15:
+		case 0xf:
 			/* Should distinguish Models here, but this is only
 			   a fallback anyways. */
 			strcpy(c->x86_model_id, "Hammer");
@@ -176,14 +177,19 @@ static void __cpuinit init_amd(struct cp
 	else
 		num_cache_leaves = 3;
 
-	if (c->x86 == 0xf || c->x86 == 0x10 || c->x86 == 0x11)
+	if (c->x86 >= 0xf && c->x86 <= 0x11)
 		set_cpu_cap(c, X86_FEATURE_K8);
 
 	/* MFENCE stops RDTSC speculation */
 	set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
 
-	if (c->x86 == 0x10)
+	if (c->x86 == 0x10) {
+		/* do this for boot cpu */
+		if (c == &boot_cpu_data)
+			check_enable_amd_mmconf_dmi();
+
 		fam10h_check_enable_mmcfg();
+	}
 
 	if (c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
 		unsigned long long tseg;
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -72,7 +72,6 @@
 #include <asm/topology.h>
 #include <asm/trampoline.h>
 #include <asm/pat.h>
-#include <asm/mmconfig.h>
 
 #include <mach_apic.h>
 #ifdef CONFIG_PARAVIRT
@@ -491,9 +490,6 @@ void __init setup_arch(char **cmdline_p)
 	conswitchp = &dummy_con;
 #endif
 #endif
-
-	/* do this before identify_cpu for boot cpu */
-	check_enable_amd_mmconf_dmi();
 }
 
 struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
