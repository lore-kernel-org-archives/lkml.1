Return-Path: <linux-kernel-owner+w=401wt.eu-S1758460AbYHUANN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbYHUANN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 20:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbYHUAMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 20:12:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:10491 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbYHUAL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 20:11:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,242,1217833200"; 
   d="scan'208";a="327872937"
Message-Id: <20080820234604.592277000@intel.com>
References: <20080820234550.923970000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Aug 2008 16:45:53 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 3/4] x86: PAT Update validate_pat_support for intel CPUs
Content-Disposition: inline; filename=intel_pat_whitelist.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pentium III and Core Solo/Duo CPUs have an erratum
" Page with PAT set to WC while associated MTRR is UC may consolidate to UC "
which can result in WC setting in PAT to be ineffective. We will disable
PAT on such CPUs, so that we can continue to use MTRR WC setting.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/kernel/cpu/addon_cpuid_features.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

Index: tip/arch/x86/kernel/cpu/addon_cpuid_features.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/addon_cpuid_features.c	2008-08-20 14:25:18.000000000 -0700
+++ tip/arch/x86/kernel/cpu/addon_cpuid_features.c	2008-08-20 14:26:39.000000000 -0700
@@ -56,9 +56,22 @@ void __cpuinit validate_pat_support(stru
 
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
-		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
+		/*
+		 * There is a known erratum on Pentium III and Core Solo
+		 * and Core Duo CPUs.
+		 * " Page with PAT set to WC while associated MTRR is UC
+		 *   may consolidate to UC "
+		 * Because of this erratum, it is better to stick with
+		 * setting WC in MTRR rather than using PAT on these CPUs.
+		 *
+		 * Enable PAT WC only on P4, Core 2 or later CPUs.
+		 */
+		if (c->x86 > 0x6 || (c->x86 == 6 && c->x86_model >= 15))
 			return;
-		break;
+
+		pat_disable("PAT WC disabled due to known CPU erratum.");
+		return;
+
 	case X86_VENDOR_AMD:
 	case X86_VENDOR_CENTAUR:
 	case X86_VENDOR_TRANSMETA:

-- 

