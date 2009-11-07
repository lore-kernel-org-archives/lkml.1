Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbZKGAoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbZKGAoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 19:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbZKGAoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 19:44:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:1996 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190AbZKGAoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 19:44:09 -0500
X-ExtLoop1: 1
Date: Sat, 7 Nov 2009 08:17:36 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, therm: Only read the initial value of thermal LVT
	entry on BSP
Message-ID: <20091107001736.GA30790@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only read the initial value of thermal LVT entry on BSP. The initial
value of thermal LVT entries on all APs always reads 0x10000 because
APs are woken up by BSP issuing INIT-SIPI-SIPI sequence to them and
LVT registers are reset to 0s except for mask bits which are set to
1s when APs receive INIT IPI.

Also restore the value that BIOS has programmed on AP based on BSP's
info we saved since BIOS is always setting the same value for all
threads/cores.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Cc: stable <stable@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index b3a1dba..1fd42db 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -259,6 +259,7 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	unsigned int cpu = smp_processor_id();
 	int tm2 = 0;
 	u32 l, h;
+	static u32 lvtthmr;
 
 	/* Thermal monitoring depends on ACPI and clock modulation*/
 	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
@@ -270,7 +271,24 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	 * since it might be delivered via SMI already:
 	 */
 	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
-	h = apic_read(APIC_LVTTHMR);
+
+	/*
+	 * Only read the initial value of thermal LVT entry on BSP. The
+	 * initial value of thermal LVT entries on all APs always reads
+	 * 0x10000 because APs are woken up by BSP issuing INIT-SIPI-SIPI
+	 * sequence to them and LVT registers are reset to 0s except for
+	 * the mask bits which are set to 1s when APs receive INIT IPI.
+	 * Also restore the value that BIOS has programmed on AP based on
+	 * BSP's info we saved since BIOS is always setting the same value
+	 * for all threads/cores
+	 */
+	if (cpu == 0)
+		lvtthmr = apic_read(APIC_LVTTHMR);
+	else
+		apic_write(APIC_LVTTHMR, lvtthmr);
+
+	h = lvtthmr;
+
 	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
 		printk(KERN_DEBUG
 		       "CPU%d: Thermal monitoring handled by SMI\n", cpu);
