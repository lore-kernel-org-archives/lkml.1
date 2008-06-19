Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbYFSOeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbYFSOeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 10:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYFSOef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 10:34:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:58785 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbYFSOef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 10:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=Ql7R8b4C9mHk4q5UIRuE3MZbpxJKmuttTHYarJI3LqfoK2xrJuGYEoFpSIHhlRrqka
         7+nER38Xw2MOh1USdvP8IBW2ikMKtWcHj1DRPalbWJXK70nh2KtHQAh/W0dLmlMvDhB2
         h+qE4m0hxL85goSR7L1fUshnG+8nZd7A7kbkc=
Date: Thu, 19 Jun 2008 16:34:26 +0200
To: stable@kernel.org
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [stable PATCH 2/2] x86: disable mwait for AMD family 10H/11H CPUs
Message-ID: <20080619143426.GB3243@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 16 May 2008 22:55:26 +0200
Subject: [PATCH] x86: disable mwait for AMD family 10H/11H CPUs

The previous revert of 0c07ee38c9d4eb081758f5ad14bbffa7197e1aec left
out the mwait disable condition for AMD family 10H/11H CPUs.

Andreas Herrman said:

It depends on the CPU. For AMD CPUs that support MWAIT this is wrong.
Family 0x10 and 0x11 CPUs will enter C1 on HLT. Powersavings then
depend on a clock divisor and current Pstate of the core.

If all cores of a processor are in halt state (C1) the processor can
enter the C1E (C1 enhanced) state. If mwait is used this will never
happen.

Thus HLT saves more power than MWAIT here.

It might be best to switch off the mwait flag for these AMD CPU
families like it was introduced with commit
f039b754714a422959027cb18bb33760eb8153f0 (x86: Don't use MWAIT on AMD
Family 10)

Re-add the AMD families 10H/11H check and disable the mwait usage for
those.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

[back-ported from upstream commit e9623b35599fcdbc00c16535cbefbb4d5578f4ab]

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/process_32.c |   29 ++++++++++++++++++++++++++++-
 arch/x86/kernel/process_64.c |   29 ++++++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 54bb813..39b1b7e 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -259,6 +259,33 @@ static void mwait_idle(void)
 	mwait_idle_with_hints(0, 0);
 }
 
+/*
+ * mwait selection logic:
+ *
+ * It depends on the CPU. For AMD CPUs that support MWAIT this is
+ * wrong. Family 0x10 and 0x11 CPUs will enter C1 on HLT. Powersavings
+ * then depend on a clock divisor and current Pstate of the core. If
+ * all cores of a processor are in halt state (C1) the processor can
+ * enter the C1E (C1 enhanced) state. If mwait is used this will never
+ * happen.
+ *
+ * idle=mwait overrides this decision and forces the usage of mwait.
+ */
+static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
+{
+	if (force_mwait)
+		return 1;
+
+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		switch(c->x86) {
+		case 0x10:
+		case 0x11:
+			return 0;
+		}
+	}
+	return 1;
+}
+
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 	static int selected;
@@ -271,7 +298,7 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 			" performance may degrade.\n");
 	}
 #endif
-	if (cpu_has(c, X86_FEATURE_MWAIT)) {
+	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
 		/*
 		 * Skip, if setup has overridden idle.
 		 * One CPU supports mwait => All CPUs supports mwait
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index fbb171f..53b9c4c 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -254,6 +254,33 @@ static void mwait_idle(void)
 	}
 }
 
+/*
+ * mwait selection logic:
+ *
+ * It depends on the CPU. For AMD CPUs that support MWAIT this is
+ * wrong. Family 0x10 and 0x11 CPUs will enter C1 on HLT. Powersavings
+ * then depend on a clock divisor and current Pstate of the core. If
+ * all cores of a processor are in halt state (C1) the processor can
+ * enter the C1E (C1 enhanced) state. If mwait is used this will never
+ * happen.
+ *
+ * idle=mwait overrides this decision and forces the usage of mwait.
+ */
+static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
+{
+	if (force_mwait)
+		return 1;
+
+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		switch(c->x86) {
+		case 0x10:
+		case 0x11:
+			return 0;
+		}
+	}
+	return 1;
+}
+
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 	static int selected;
@@ -266,7 +293,7 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 			" performance may degrade.\n");
 	}
 #endif
-	if (cpu_has(c, X86_FEATURE_MWAIT)) {
+	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
 		/*
 		 * Skip, if setup has overridden idle.
 		 * One CPU supports mwait => All CPUs supports mwait
-- 
1.5.4.1

