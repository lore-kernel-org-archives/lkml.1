Return-Path: <linux-kernel-owner+w=401wt.eu-S1752285AbZLNI5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbZLNI5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 03:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbZLNI5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 03:57:30 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55794 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZLNI53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 03:57:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B25FDDC.407@jp.fujitsu.com>
Date: Mon, 14 Dec 2009 17:57:00 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH 2/2] x86, mce: Introduce intel_thermal_supported()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks better to have a common function.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 687638e..4f4c8bb 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -256,6 +256,16 @@ asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
 	ack_APIC_irq();
 }
 
+/* Thermal monitoring depends on APIC, ACPI and clock modulation */
+static int intel_thermal_supported(struct cpuinfo_x86 *c)
+{
+	if (!cpu_has_apic)
+		return 0;
+	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
+		return 0;
+	return 1;
+}
+
 void __init mcheck_intel_therm_init(void)
 {
 	/*
@@ -263,8 +273,7 @@ void __init mcheck_intel_therm_init(void)
 	 * LVT value on BSP and use that value to restore APs' thermal LVT
 	 * entry BIOS programmed later
 	 */
-	if (cpu_has(&boot_cpu_data, X86_FEATURE_ACPI) &&
-		cpu_has(&boot_cpu_data, X86_FEATURE_ACC))
+	if (intel_thermal_supported(&boot_cpu_data))
 		lvtthmr_init = apic_read(APIC_LVTTHMR);
 }
 
@@ -274,9 +283,7 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	int tm2 = 0;
 	u32 l, h;
 
-	/* Thermal monitoring depends on APIC, ACPI and clock modulation */
-	if (!cpu_has_apic || !cpu_has(c, X86_FEATURE_ACPI) ||
-		!cpu_has(c, X86_FEATURE_ACC))
+	if (!intel_thermal_supported(c))
 		return;
 
 	/*
-- 
1.6.5.6


