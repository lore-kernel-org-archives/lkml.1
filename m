Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbZAOUC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbZAOUC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762150AbZAOUAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:20 -0500
Received: from kroah.org ([198.145.64.141]:48735 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761599AbZAOUAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:17 -0500
Date: Thu, 15 Jan 2009 11:57:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Suresh Siddha <suresh.b.siddha@intel.com>,
       Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 05/94] x86: fix intel x86_64 llc_shared_map/cpu_llc_id
	anomolies
Message-ID: <20090115195722.GE14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-intel-x86_64-llc_shared_map-cpu_llc_id-anomolies.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 345077cd98ff5532b2d1158013c3fec7b1ae85ec upstream.

Impact: fix wrong cache sharing detection on platforms supporting > 8 bit apicid's

In the presence of extended topology eumeration leaf 0xb provided
by cpuid, 32bit extended initial_apicid in cpuinfo_x86 struct will be
updated by detect_extended_topology(). At this instance, we should also
reinit the apicid (which could also potentially be extended to 32bit).

With out this there will potentially be duplicate apicid's populated in the
per cpu's cpuinfo_x86 struct, resulting in wrong cache sharing topology etc
detected by init_intel_cacheinfo().

Reported-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/addon_cpuid_features.c |    8 ++++++++
 arch/x86/kernel/cpu/intel.c                |    8 +++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -120,9 +120,17 @@ void __cpuinit detect_extended_topology(
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
 
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -242,6 +242,13 @@ static void __cpuinit init_intel(struct 
 
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
@@ -313,7 +320,6 @@ static void __cpuinit init_intel(struct 
 
 #endif
 
-	detect_extended_topology(c);
 	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
 		/*
 		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology

