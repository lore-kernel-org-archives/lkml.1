Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbZLNBX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbZLNBX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 20:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbZLNBX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 20:23:57 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43962 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbZLNBX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 20:23:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B259363.5070002@jp.fujitsu.com>
Date: Mon, 14 Dec 2009 10:22:43 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH resend -tip] x86,mcheck: Thermal monitoring depends on
 APIC	being enabled
References: <20091212143155.GB15467@lenovo>
In-Reply-To: <20091212143155.GB15467@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2009/12/12 23:31), Cyrill Gorcunov wrote:
> Add check if APIC is not disabled since thermal
> monitoring depends on it. As only apic gets disabled
> we should not try to install "thermal monitor" vector,
> print out that thermal monitoring is enabled and etc...
> 
> Note that "Intel Correct Machine Check Interrupts" already
> has such a check.
> 
> Also I decided to not add cpu_has_apic check into mcheck_intel_therm_init
> since even if it'll call apic_read on disabled apic -- it's safe
> here and allow us to save a few code bytes.
> 
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
> 
> Please review. This should close a number of WARNs triggered
> by intel_init_thermal when apic gets disabled state.
> 
> Ie the WARNs like
> 
> 	http://kerneloops.org/oops.php?number=974702
> 
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Looks good.
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


And I think that the following incremental patch is reasonable
to apply on it.


Thanks,
H.Seto

===
Subject: [PATCH] x86, mce: introduce intel_thermal_supported

Have a common function.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
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
1.6.5.5

