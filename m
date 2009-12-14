Return-Path: <linux-kernel-owner+w=401wt.eu-S1751903AbZLNI5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbZLNI5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 03:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbZLNI5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 03:57:10 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44208 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZLNI5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 03:57:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B25FDC2.3020401@jp.fujitsu.com>
Date: Mon, 14 Dec 2009 17:56:34 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH 1/2] x86, mce: Thermal monitoring depends on APIC being enabled
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@openvz.org>

Add check if APIC is not disabled since thermal
monitoring depends on it. As only apic gets disabled
we should not try to install "thermal monitor" vector,
print out that thermal monitoring is enabled and etc...

Note that "Intel Correct Machine Check Interrupts" already
has such a check.

Also I decided to not add cpu_has_apic check into mcheck_intel_therm_init
since even if it'll call apic_read on disabled apic -- it's safe
here and allow us to save a few code bytes.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 4fef985..687638e 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -274,8 +274,9 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	int tm2 = 0;
 	u32 l, h;
 
-	/* Thermal monitoring depends on ACPI and clock modulation*/
-	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
+	/* Thermal monitoring depends on APIC, ACPI and clock modulation */
+	if (!cpu_has_apic || !cpu_has(c, X86_FEATURE_ACPI) ||
+		!cpu_has(c, X86_FEATURE_ACC))
 		return;
 
 	/*
-- 
1.6.5.6


