Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYLSCJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYLSCJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 21:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYLSCJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 21:09:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:25291 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbYLSCJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 21:09:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,246,1228118400"; 
   d="scan'208";a="372163811"
Date: Thu, 18 Dec 2008 18:09:21 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Dimitri Sivanich <sivanich@sgi.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Intel x86_64 llc_shared_map/cpu_llc_id anomolies
Message-ID: <20081219020921.GD26490@linux-os.sc.intel.com>
References: <20081212214256.GA20559@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212214256.GA20559@sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 01:42:56PM -0800, Dimitri Sivanich wrote:
> I'm seeing some behavior on a multiblade Intel x86_64 that does not
> appear to be correct.
> 
> My x86_64 multiblade configuration has llc_shared_map (last level
> cache shared map) showing cpus on different blades sharing a last
> level cache.  With 2 cpus/blade and 4 blades (8 cpus total), I show
> cpus 1,3,5,7 sharing llc, and 0,2,4,6 sharing llc.
> 
> The llc_shared_map is set based on matching values of cpu_llc_id
> (last level cache ID).  The cpu_llc_id is set based on
> cpuinfo_x86->apicid.  This value is set to cpuinfo_x86->initial_apicid.
> 
> The value of cpuinfo_x86->initial_apicid appears to be set twice
> during startup:
> 
> - In generic_identify(), using the value returned by cpuid_ebx(1).
>   This is the initial_apicid set at poweron, and results in
>   cpuinfo_x86->initial_apicid having a value that is not unique across
>   blades (where the blades do not share a cpu bus).
> 
> - Later, in detect_extended_topology() using the value for edx returned
>   by cpuid_count(0xb,..).  This results in cpuinfo_x86->initial_apicid
>   having a value that appears to be unique across blades.
> 
> Between those two assignments, cpuinfo_x86->apicid is set to
> cpuinfo_x86->initial_apicid, so it is non-unique.  Then cpu_llc_id gets
> set in init_intel_cacheinfo(), so cpu_llc_id winds up with a value that
> is non-unique across blades, and llc_shared_map winds up showing cpus
> on different blades as sharing last level cache.
> 
> Is cpu_llc_id supposed to be unique across blades?  I assume
> llc_shared_map should not be showing shared cache across blades.

x86 folks, Appended patch fixes the reported issue. Please apply.

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch] x86: Fix apicid initialization in per cpu's cpuinfo_x86 struct

In the presence of extended topology eumeration leaf 0xb provided
by cpuid, 32bit extended initial_apicid in cpuinfo_x86 struct will be updated
by detect_extended_topology(). At this instance, we should also
reinit the apicid (which could also potentially be extended to 32bit).

With out this there will potentially be duplicate apicid's populated in the
per cpu's cpuinfo_x86 struct, resulting in wrong cache sharing topology etc
detected by init_intel_cacheinfo().

Impact: wrong cache sharing detection on platforms supporting > 8 bit apicid's

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Reported-by: Dimitri Sivanich <sivanich@sgi.com>
Acked-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
---
 
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index ef8f831..2cf2363 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -120,9 +120,17 @@ void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 	c->cpu_core_id = phys_pkg_id(c->initial_apicid, ht_mask_width)
 						 & core_select_mask;
 	c->phys_proc_id = phys_pkg_id(c->initial_apicid, core_plus_mask_width);
+	/*
+	 * Reinit the apicid, now that we have extended initial_apicid.
+	 */
+	c->apicid = phys_pkg_id(c->initial_apicid, 0);
 #else
 	c->cpu_core_id = phys_pkg_id(ht_mask_width) & core_select_mask;
 	c->phys_proc_id = phys_pkg_id(core_plus_mask_width);
+	/*
+	 * Reinit the apicid, now that we have extended initial_apicid.
+	 */
+	c->apicid = phys_pkg_id(0);
 #endif
 	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index cce0b61..57e3fba 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -242,6 +242,13 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 	intel_workarounds(c);
 
+	/*
+	 * Detect the extended topology information if available. This
+	 * will reinitialise the initial_apicid which will be used
+	 * in init_intel_cacheinfo()
+	 */
+	detect_extended_topology(c);
+
 	l2 = init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9) {
 		unsigned eax = cpuid_eax(10);
@@ -313,7 +320,6 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 #endif
 
-	detect_extended_topology(c);
 	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
 		/*
 		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology
