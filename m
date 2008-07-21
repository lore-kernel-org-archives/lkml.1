Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbYGUIjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYGUIjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 04:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbYGUIjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 04:39:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:50922 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbYGUIjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 04:39:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Vd34rE0NJm5Uz22Q2dG5kXXufQdFI2e9ZIQ3DjEgVhtPU74eq9KcV9gFJOUzG42SJi
         2U4DkIqIPyBriq+oD3ocAkXgVSaBtRLYDtxApmNv3ka/RXSauNRxfR41sljBxF9IxfIz
         1jdbMFxRqc/+c/8Sxz3+MVrE1qmD0op440y3k=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: use setup_clear_cpu_cap with disable_apic
Date: Mon, 21 Jul 2008 01:38:14 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807210138.15054.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so don't need to call clear_cpu_cap again in early_identify_cpu,
and could use cleared_cpu_caps like other setup clear.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/apic_32.c       |    5 +----
 arch/x86/kernel/apic_64.c       |    2 +-
 arch/x86/kernel/cpu/common_64.c |    4 ----
 3 files changed, 2 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_32.c
+++ linux-2.6/arch/x86/kernel/apic_32.c
@@ -1251,9 +1251,6 @@ int apic_version[MAX_APICS];
 
 int __init APIC_init_uniprocessor(void)
 {
-	if (disable_apic)
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
-
 	if (!smp_found_config && !cpu_has_apic)
 		return -1;
 
@@ -1737,7 +1734,7 @@ early_param("lapic", parse_lapic);
 static int __init parse_nolapic(char *arg)
 {
 	disable_apic = 1;
-	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
+	setup_clear_cpu_cap(X86_FEATURE_APIC);
 	return 0;
 }
 early_param("nolapic", parse_nolapic);
Index: linux-2.6/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_64.c
+++ linux-2.6/arch/x86/kernel/apic_64.c
@@ -1556,7 +1556,7 @@ early_param("apic", apic_set_verbosity);
 static __init int setup_disableapic(char *str)
 {
 	disable_apic = 1;
-	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
+	setup_clear_cpu_cap(X86_FEATURE_APIC);
 	return 0;
 }
 early_param("disableapic", setup_disableapic);
Index: linux-2.6/arch/x86/kernel/cpu/common_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common_64.c
+++ linux-2.6/arch/x86/kernel/cpu/common_64.c
@@ -319,10 +319,6 @@ static void __cpuinit early_identify_cpu
 		cpu_devs[c->x86_vendor]->c_early_init(c);
 
 	validate_pat_support(c);
-
-	/* early_param could clear that, but recall get it set again */
-	if (disable_apic)
-		clear_cpu_cap(c, X86_FEATURE_APIC);
 }
 
 /*
