Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbZFOIYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbZFOIYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZFOIYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:24:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47843 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbZFOIYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:24:16 -0400
Message-ID: <4A360529.6070009@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:24:09 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/16] x86, mce: unify smp_thermal_interrupt, prepare mce_intel_64
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divide it into two functions.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index c548111..a5232b2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -16,19 +16,21 @@
 #include <asm/idle.h>
 #include <asm/therm_throt.h>
 
-asmlinkage void smp_thermal_interrupt(void)
+static void intel_thermal_interrupt(void)
 {
 	__u64 msr_val;
 
-	ack_APIC_irq();
-
-	exit_idle();
-	irq_enter();
-
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
 	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT))
 		mce_log_therm_throt_event(msr_val);
+}
 
+asmlinkage void smp_thermal_interrupt(void)
+{
+	ack_APIC_irq();
+	exit_idle();
+	irq_enter();
+	intel_thermal_interrupt();
 	inc_irq_stat(irq_thermal_count);
 	irq_exit();
 }
-- 
1.6.3


