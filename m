Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbYINJQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbYINJQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 05:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYINJQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 05:16:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:13599 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYINJQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 05:16:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=X87wBVyvmlZjmV7go+Suxvmx9MK03/IoYslPxQ/rqaJNxSmgGkIF/ZlEj2wTEijOyF
         vPnVKx0aXaLZA+3sml3HVPw15qr9DvVAXdmbV0XNQbTUgIJ9y+42nWPntMx4ugcm8GUJ
         VPnxy6Z9k29N+vg8W0DJYSbe+5u+Bpu+vMTv8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: [PATCH] x86: identify_cpu_without_cpuid v2
Date: Sun, 14 Sep 2008 02:15:26 -0700
Message-Id: <1221383726-10834-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof found some old cyrix cpu mtrr etc cpu feature was not detected

this one is based on Krzysztof' patch, and call c_identify in early_identify_cpu.

need to call c_identify() for cpus without cpuid earlier...
v2: Krzysztof point out need to give cyrix another chance about cpuid checking again
    after c_identify enable cpuid for it

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>

---
 arch/x86/kernel/cpu/common.c |   57 ++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -485,6 +485,33 @@ static void __cpuinit get_cpu_cap(struct
 		c->x86_power = cpuid_edx(0x80000007);
 
 }
+
+static void __cpuinit identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_32
+	int i;
+
+	/*
+	 * First of all, decide if this is a 486 or higher
+	 * It's a 486 if we can modify the AC flag
+	 */
+	if (flag_is_changeable_p(X86_EFLAGS_AC))
+		c->x86 = 4;
+	else
+		c->x86 = 3;
+
+	for (i = 0; i < X86_VENDOR_NUM; i++)
+		if (cpu_devs[i] && cpu_devs[i]->c_identify) {
+			c->x86_vendor_id[0] = 0;
+			cpu_devs[i]->c_identify(c);
+			if (c->x86_vendor_id[0]) {
+				get_cpu_vendor(c);
+				break;
+			}
+		}
+#endif
+}
+
 /*
  * Do minimum CPU detection early.
  * Fields really needed: vendor, cpuid_level, family, model, mask,
@@ -503,13 +530,16 @@ static void __init early_identify_cpu(st
 #endif
 	c->x86_cache_alignment = c->x86_clflush_size;
 
-	if (!have_cpuid_p())
-		return;
-
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
-
 	c->extended_cpuid_level = 0;
 
+	if (!have_cpuid_p())
+		identify_cpu_without_cpuid(c);
+
+	/* cyrix could have cpuid enabled via c_identify()*/
+	if (!have_cpuid())
+		return;
+
 	cpu_detect(c);
 
 	get_cpu_vendor(c);
@@ -583,10 +613,14 @@ static void __cpuinit detect_nopl(struct
 
 static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 {
+	c->extended_cpuid_level = 0;
+
 	if (!have_cpuid_p())
-		return;
+		identify_cpu_without_cpuid(c);
 
-	c->extended_cpuid_level = 0;
+	/* cyrix could have cpuid enabled via c_identify()*/
+	if (!have_cpuid())
+		return;
 
 	cpu_detect(c);
 
@@ -639,17 +673,6 @@ static void __cpuinit identify_cpu(struc
 	c->x86_cache_alignment = c->x86_clflush_size;
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 
-	if (!have_cpuid_p()) {
-		/*
-		 * First of all, decide if this is a 486 or higher
-		 * It's a 486 if we can modify the AC flag
-		 */
-		if (flag_is_changeable_p(X86_EFLAGS_AC))
-			c->x86 = 4;
-		else
-			c->x86 = 3;
-	}
-
 	generic_identify(c);
 
 	if (this_cpu->c_identify)
