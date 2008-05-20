Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbYETEKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbYETEKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 00:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYETEJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 00:09:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbYETEJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 00:09:50 -0400
Date: Tue, 20 May 2008 00:09:34 -0400
Message-Id: <200805200409.m4K49Ybn024338@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com
Subject: [X86] Add a boot parameter to force-enable PAT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add an enablepat boot parameter, useful for testing CPUs not yet
  added to the whitelist.
* Don't try to enable PAT if it was never enabled in the first place.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 72c07a0..e179c22 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -236,6 +236,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			try_unsupported: try to drive unsupported chipsets
 				(may crash computer or cause data corruption)
 
+	enablepat	[i386,x86-64]
+			Force the CPU's PAT feature to be used even if it
+			isn't in the kernels whitelist.
+
 	enable_timer_pin_1 [i386,x86-64]
 			Enable PIN 1 of APIC timer
 			Can be useful to work around chipset bugs
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index c2e1ce3..6ce3202 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -50,9 +50,28 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	}
 }
 
+static int forcepat;
+
+static int __init x86_forcepat_setup(char *s)
+{
+	forcepat = 1;
+	return 1;
+}
+__setup("enablepat", x86_forcepat_setup);
+
+
 #ifdef CONFIG_X86_PAT
 void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 {
+	if (!test_cpu_cap(c, X86_FEATURE_PAT))
+		return;
+
+	if (forcepat == 1) {
+		printk(KERN_INFO "Force enabling PAT\n");
+		set_cpu_cap(c, X86_FEATURE_PAT);
+		return;
+	}
+
 	switch (c->x86_vendor) {
 	case X86_VENDOR_AMD:
 		if (c->x86 >= 0xf && c->x86 <= 0x11)

