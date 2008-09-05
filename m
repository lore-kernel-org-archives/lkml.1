Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYIEDON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYIEDON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbYIEDJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:09:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:54468 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbYIEDJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:09:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Bm6yaaTRpnfZAibXI68tLkMcn/NiOTrjABs0DeAgi/utRNQwak0Kj3ttE5l3V+vnVK
         3va/cf6k54wsDNAyNpnB5mhoKIy3MmDehS60qqDI/vaAmiVMJVvHudYHAkIBjja+5hyw
         1257EaI1KK9aprIX6Oj0BIM34oEzE/MraUIE0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 14/16] x86: cpu common merge generic_identify
Date: Thu,  4 Sep 2008 20:09:12 -0700
Message-Id: <1220584154-32497-14-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |   15 ++++++++++++---
 arch/x86/kernel/cpu/common_64.c |   19 ++++++++++++++++---
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 61a7074..f35baa7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -548,6 +548,10 @@ void __init early_cpu_init(void)
  * of early VIA chips and (more importantly) broken virtualizers that
  * are not easy to detect.  Hence, probe for it based on first
  * principles.
+ *
+ * Note: no 64-bit chip is known to lack these, but put the code here
+ * for consistency with 32 bits, and to make it utterly trivial to
+ * diagnose the problem should it ever surface.
  */
 static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
 {
@@ -586,11 +590,16 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 
 	if (c->cpuid_level >= 0x00000001) {
 		c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xFF;
-#ifdef CONFIG_X86_HT
+#ifdef CONFIG_X86_32
+# ifdef CONFIG_X86_HT
 		c->apicid = phys_pkg_id(c->initial_apicid, 0);
-		c->phys_proc_id = c->initial_apicid;
-#else
+# else
 		c->apicid = c->initial_apicid;
+# endif
+#endif
+
+#ifdef CONFIG_X86_HT
+		c->phys_proc_id = c->initial_apicid;
 #endif
 	}
 
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 68b06a3..869a6ff 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -581,6 +581,9 @@ static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
 
 static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 {
+	if (!have_cpuid_p())
+		return;
+
 	c->extended_cpuid_level = 0;
 
 	cpu_detect(c);
@@ -589,11 +592,21 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 
 	get_cpu_cap(c);
 
-	c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xff;
-#ifdef CONFIG_SMP
-	c->phys_proc_id = c->initial_apicid;
+	if (c->cpuid_level >= 0x00000001) {
+		c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xFF;
+#ifdef CONFIG_X86_32
+# ifdef CONFIG_X86_HT
+		c->apicid = phys_pkg_id(c->initial_apicid, 0);
+# else
+		c->apicid = c->initial_apicid;
+# endif
 #endif
 
+#ifdef CONFIG_X86_HT
+		c->phys_proc_id = c->initial_apicid;
+#endif
+	}
+
 	if (c->extended_cpuid_level >= 0x80000004)
 		get_model_name(c); /* Default name */
 
-- 
1.5.4.5

