Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbZLNJu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbZLNJu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbZLNJuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:50:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:48394 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633AbZLNJtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:49:53 -0500
Date: Mon, 14 Dec 2009 09:49:30 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B25FDDC.407@jp.fujitsu.com>
References: <4B25FDDC.407@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mce: Clean up thermal init by introducing intel_thermal_supported()
Message-ID: <tip-70fe440718d9f42bf963c2cffe12008eb5556165@git.kernel.org>
Git-Commit-ID: 70fe440718d9f42bf963c2cffe12008eb5556165
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70fe440718d9f42bf963c2cffe12008eb5556165
Gitweb:     http://git.kernel.org/tip/70fe440718d9f42bf963c2cffe12008eb5556165
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Mon, 14 Dec 2009 17:57:00 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Dec 2009 10:38:41 +0100

x86, mce: Clean up thermal init by introducing intel_thermal_supported()

It looks better to have a common function. No change in functionality.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <4B25FDDC.407@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 0a9b577..81c499e 100644
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
