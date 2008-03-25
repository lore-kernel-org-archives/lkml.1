Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbYCYGWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbYCYGWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 02:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbYCYGWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 02:22:15 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:17992 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077AbYCYGWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 02:22:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=CJ98u6M0MMSaRw/GkGqGfxaMd/+wEaxs+Mx0iThjsKPJclECITVbwmM3bMQN0rI94sdqNlAHh2mtl20AXLTclO0Hc3wi/n0qs7eZMdHh9jCo/i0x2OMXEV39etnaKHb3+mcT/UhmIftoq09Pjfvnx8atDL1quy3aWHqLTMcFo+0=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: pat cpu feature bit setting for known cpus
Date: Mon, 24 Mar 2008 23:24:34 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803242324.35357.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: pat cpu feature bit setting for known cpus

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index eb94460..b186047 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -309,6 +309,19 @@ static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
 
 	}
 
+	clear_cpu_cap(c, X86_FEATURE_PAT);
+
+	switch (c->x86_vendor) {
+	case X86_VENDOR_AMD:
+		if (c->x86 >= 0xf && c->x86 <= 0x11)
+			set_cpu_cap(c, X86_FEATURE_PAT);
+		break;
+	case X86_VENDOR_INTEL:
+		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
+			set_cpu_cap(c, X86_FEATURE_PAT);
+		break;
+	}
+
 }
 
 /*
@@ -397,6 +410,18 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 		init_scattered_cpuid_features(c);
 	}
 
+	clear_cpu_cap(c, X86_FEATURE_PAT);
+
+	switch (c->x86_vendor) {
+	case X86_VENDOR_AMD:
+		if (c->x86 >= 0xf && c->x86 <= 0x11)
+			set_cpu_cap(c, X86_FEATURE_PAT);
+		break;
+	case X86_VENDOR_INTEL:
+		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
+			set_cpu_cap(c, X86_FEATURE_PAT);
+		break;
+	}
 }
 
 static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 3f1dc97..ddaaaaa 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -979,12 +979,19 @@ static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 	if (c->extended_cpuid_level >= 0x80000007)
 		c->x86_power = cpuid_edx(0x80000007);
 
+
+	clear_cpu_cap(c, X86_FEATURE_PAT);
+
 	switch (c->x86_vendor) {
 	case X86_VENDOR_AMD:
 		early_init_amd(c);
+		if (c->x86 >= 0xf && c->x86 <= 0x11)
+			set_cpu_cap(c, X86_FEATURE_PAT);
 		break;
 	case X86_VENDOR_INTEL:
 		early_init_intel(c);
+		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
+			set_cpu_cap(c, X86_FEATURE_PAT);
 		break;
 	}
 
--- a/arch/x86/mm/pat.c	2008-03-24 23:10:32.000000000 -0700
+++ b/arch/x86/mm/pat.c	2008-03-24 23:11:38.000000000 -0700
@@ -42,19 +42,8 @@
 	if (!pat_wc_enabled)
 		return 0;
 
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
-	    (boot_cpu_data.x86 == 0xF ||
-	     (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model >= 15))) {
-		if (cpu_has_pat) {
-			return 1;
-		}
-	}
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
-	     boot_cpu_data.x86 >= 0xf && boot_cpu_data.x86 <= 0x11) {
-		if (cpu_has_pat) {
-			return 1;
-		}
-	}
+	if (cpu_has_pat)
+		return 1;
 
 	pat_wc_enabled = 0;
 	printk(KERN_INFO "CPU and/or kernel does not support PAT.\n");
