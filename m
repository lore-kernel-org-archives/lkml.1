Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbZEVXZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbZEVXZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 19:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758174AbZEVXZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 19:25:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:49197 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757953AbZEVXZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 19:25:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,235,1241420400"; 
   d="scan'208";a="146035749"
Message-Id: <20090522232230.162239000@intel.com>
References: <20090522231940.553094000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 22 May 2009 16:19:42 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, shaohua.li@intel.com,
       svaidy@linux.vnet.ibm.com, a.p.zijlstra@chello.nl,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 2/2] x86: put offline CPUs into deepest mwait cstate_subcstate
Content-Disposition: inline; filename=0002-x86-put-offline-CPUs-into-deepest-mwait-cstate_subc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Offline CPUs can save power by going into deepest cstate, subcstate
instead of hlt loop.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/kernel/acpi/cstate.c |   51 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index bbbe4bb..5b0988a 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -150,6 +150,54 @@ void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx *cx)
 }
 EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_enter);
 
+static unsigned long mwait_play_dead_eax;
+
+static void mwait_play_dead(void)
+{
+	if (boot_cpu_data.x86 >= 4)
+		wbinvd();
+
+	while (1) {
+		__monitor((void *)&current_thread_info()->flags, 0, 0);
+		smp_mb();
+		__mwait(mwait_play_dead_eax, 0);
+	}
+}
+
+static void mwait_play_dead_init(void *unused)
+{
+	unsigned int eax, ebx, ecx, edx;
+	unsigned int highest_cstate = 0;
+	unsigned int highest_subcstate = 0;
+	int i;
+
+	if (!boot_cpu_has(X86_FEATURE_MWAIT))
+		return;
+	
+	if (boot_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
+		return;
+
+	pm_play_dead = mwait_play_dead;
+
+	cpuid(CPUID_MWAIT_LEAF, &eax, &ebx, &ecx, &edx);
+	/*
+	 * mwait_play_dead_eax will be 0 if EDX enumeration is not valid.
+	 * Initialized below to cstate, sub_cstate value when EDX is valid.
+	 */
+	if (!(ecx & 0x1))
+		return;
+		
+	edx >>= MWAIT_SUBSTATE_SIZE;
+	for (i = 0; i < 7 && edx; i++, edx >>= MWAIT_SUBSTATE_SIZE) {
+		if (edx & MWAIT_SUBSTATE_MASK) {
+			highest_cstate = i;
+			highest_subcstate = edx & MWAIT_SUBSTATE_MASK;
+		}
+	}
+	mwait_play_dead_eax = (highest_cstate << MWAIT_SUBSTATE_SIZE) |
+			      (highest_subcstate - 1);
+}
+
 static int __init ffh_cstate_init(void)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
@@ -157,6 +205,9 @@ static int __init ffh_cstate_init(void)
 		return -1;
 
 	cpu_cstate_entry = alloc_percpu(struct cstate_entry);
+
+	smp_call_function_single(0, mwait_play_dead_init, NULL, 1);
+
 	return 0;
 }
 
-- 
1.6.0.6

-- 

