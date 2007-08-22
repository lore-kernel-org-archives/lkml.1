Return-Path: <linux-kernel-owner+w=401wt.eu-S934365AbXHVV7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934365AbXHVV7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764534AbXHVV7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:59:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48966 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764509AbXHVV7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:59:42 -0400
Date: Thu, 23 Aug 2007 03:42:30 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] intel_cacheinfo: Misc section annotation fixes /
 cleanups
Message-ID: <alpine.LFD.0.999.0708230340480.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cache_sysfs_init() is only ever called at device_initcall() time. Marking it
__cpuinit is quite wrong, and wasteful when HOTPLUG_CPU=y. It must be __init.

cache_shared_cpu_map_setup() and cache_remove_shared_cpu_map(), OTOH, are
functions called from another function that is __cpuinit. But the !CONFIG_SMP
empty-body stubs of these functions are unconditionally marked __init, which
is actively wrong, and will lead to oops. But we never saw this oops, because
they always managed to get inlined in their callsites, by virtue of being
empty-body stubs! They should still be __cpuinit, of course.

assocs[], levels[] and types[] are only referenced from function that is
__cpuinit. So these are candidates for being marked __cpuinitdata.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 arch/i386/kernel/cpu/intel_cacheinfo.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/i386/kernel/cpu/intel_cacheinfo.c b/arch/i386/kernel/cpu/intel_cacheinfo.c
index d5a456d..16499fe 100644
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c
+++ b/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -170,15 +170,15 @@ union l3_cache {
 	unsigned val;
 };
 
-static const unsigned short assocs[] = {
+static const unsigned short assocs[] __cpuinitdata = {
 	[1] = 1, [2] = 2, [4] = 4, [6] = 8,
 	[8] = 16, [0xa] = 32, [0xb] = 48,
 	[0xc] = 64,
 	[0xf] = 0xffff // ??
 };
 
-static const unsigned char levels[] = { 1, 1, 2, 3 };
-static const unsigned char types[] = { 1, 2, 3, 3 };
+static const unsigned char levels[] __cpuinitdata = { 1, 1, 2, 3 };
+static const unsigned char types[] __cpuinitdata = { 1, 2, 3, 3 };
 
 static void __cpuinit amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		       union _cpuid4_leaf_ebx *ebx,
@@ -493,8 +493,8 @@ static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
 	}
 }
 #else
-static void __init cache_shared_cpu_map_setup(unsigned int cpu, int index) {}
-static void __init cache_remove_shared_cpu_map(unsigned int cpu, int index) {}
+static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index) {}
+static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index) {}
 #endif
 
 static void free_cache_attributes(unsigned int cpu)
@@ -782,7 +782,7 @@ static struct notifier_block __cpuinitdata cacheinfo_cpu_notifier =
     .notifier_call = cacheinfo_cpu_callback,
 };
 
-static int __cpuinit cache_sysfs_init(void)
+static int __init cache_sysfs_init(void)
 {
 	int i;
 
