Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYAUVQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYAUVQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYAUVQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:16:06 -0500
Received: from relay2.sgi.com ([192.48.171.30]:39990 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752133AbYAUVQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:16:01 -0500
Message-Id: <20080121211600.536296000@sgi.com>
References: <20080121211600.079162000@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 13:16:03 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86: Change bios_cpu_apicid to percpu data variable fixup V2
Content-Disposition: inline; filename=change-bios_cpu_apicid-to-percpu-fixup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change static bios_cpu_apicid array to a per_cpu data variable.
This includes using a static array used during initialization
similar to the way x86_cpu_to_apicid[] is handled.

There is one early use of bios_cpu_apicid in apic_is_clustered_box().
The other reference in cpu_present_to_apicid() is called after
setup_per_cpu_maps() has setup the percpu version of bios_cpu_apicid.

Based on 2.6.24-rc8-mm1

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
---
V1->V2:
    - Removed extraneous casts
    - Add slight optimization to apic_is_clustered_box()
      [don't reference x86_bios_cpu_apicid_early_ptr each pass.]
---
 arch/x86/kernel/apic_64.c  |    6 +++---
 arch/x86/kernel/setup64.c  |    3 +++
 arch/x86/kernel/setup_64.c |    1 +
 3 files changed, 7 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1191,9 +1191,9 @@ __cpuinit int apic_is_clustered_box(void
 
 	/* Problem:  Partially populated chassis may not have CPUs in some of
 	 * the APIC clusters they have been allocated.  Only present CPUs have
-	 * x86_bios_cpu_apicid entries, thus causing zeroes in the bitmap.  Since
-	 * clusters are allocated sequentially, count zeros only if they are
-	 * bounded by ones.
+	 * x86_bios_cpu_apicid entries, thus causing zeroes in the bitmap.
+	 * Since clusters are allocated sequentially, count zeros only if
+	 * they are bounded by ones.
 	 */
 	clusters = 0;
 	zeros = 0;
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -98,6 +98,8 @@ static void __init setup_per_cpu_maps(vo
 #endif
 			per_cpu(x86_cpu_to_apicid, cpu) =
 						x86_cpu_to_apicid_init[cpu];
+			per_cpu(x86_bios_cpu_apicid, cpu) =
+						x86_bios_cpu_apicid_init[cpu];
 #ifdef CONFIG_NUMA
 			per_cpu(x86_cpu_to_node_map, cpu) =
 						x86_cpu_to_node_map_init[cpu];
@@ -112,6 +114,7 @@ static void __init setup_per_cpu_maps(vo
 
 	/* indicate the early static arrays will soon be gone */
 	x86_cpu_to_apicid_early_ptr = NULL;
+	x86_bios_cpu_apicid_early_ptr = NULL;
 #ifdef CONFIG_NUMA
 	x86_cpu_to_node_map_early_ptr = NULL;
 #endif
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -390,6 +390,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_SMP
 	/* setup to use the early static init tables during kernel startup */
 	x86_cpu_to_apicid_early_ptr = (void *)&x86_cpu_to_apicid_init;
+	x86_bios_cpu_apicid_early_ptr = (void *)&x86_bios_cpu_apicid_init;
 #ifdef CONFIG_NUMA
 	x86_cpu_to_node_map_early_ptr = (void *)&x86_cpu_to_node_map_init;
 #endif

-- 
