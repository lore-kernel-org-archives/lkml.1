Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbZHYWHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbZHYWHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 18:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZHYWHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 18:07:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:45305 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbZHYWHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 18:07:54 -0400
Message-ID: <4A946082.9090809@kernel.org>
Date: Tue, 25 Aug 2009 15:06:58 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] x86: use hard_smp_processor_id to get apic id in identify_cpu
 -v2
References: <4A9391CD.5020804@kernel.org>
In-Reply-To: <4A9391CD.5020804@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



and leave phys_proc_id to use initial apic id.

otherwise, system with apci id lifting will have wrong apicid in
/proc/cpuinfo

-v2: update the one in detect_extended_topology too.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/addon_cpuid_features.c |    4 ++--
 arch/x86/kernel/cpu/common.c               |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -715,7 +715,7 @@ static void __cpuinit generic_identify(s
 		c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xFF;
 #ifdef CONFIG_X86_32
 # ifdef CONFIG_X86_HT
-		c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
+		c->apicid = hard_smp_processor_id();
 # else
 		c->apicid = c->initial_apicid;
 # endif
@@ -772,7 +772,7 @@ static void __cpuinit identify_cpu(struc
 	}
 
 #ifdef CONFIG_X86_64
-	c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
+	c->apicid = hard_smp_processor_id();
 #endif
 
 	/*
Index: linux-2.6/arch/x86/kernel/cpu/addon_cpuid_features.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ linux-2.6/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -121,9 +121,9 @@ void __cpuinit detect_extended_topology(
 						 & core_select_mask;
 	c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, core_plus_mask_width);
 	/*
-	 * Reinit the apicid, now that we have extended initial_apicid.
+	 * Reinit the apicid, now that we have extended apicid ?
 	 */
-	c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
+	c->apicid = hard_smp_processor_id();
 
 	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
 
