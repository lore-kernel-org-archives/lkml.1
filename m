Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab0BDNNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 08:13:07 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38204 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab0BDNNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 08:13:04 -0500
Date: Thu, 4 Feb 2010 14:13:14 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: [PATCH] x86, cacheinfo: Remove NUMA dependency
Message-ID: <20100204131314.GB32711@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a small fix ontop of the L3 cache index disable series from last
week. It is based on tip:x86/cpu and slated for .34 too.

Please apply,
thanks.

--
>From 031c4cc06d4668c4fa6b0363e2e32c8b30afbf67 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 4 Feb 2010 12:09:07 +0100
Subject: [PATCH] x86, cacheinfo: Remove NUMA dependency

The show/store_cache_disable routines depend unnecessarily on NUMA's
cpu_to_node and the disabling of cache indices breaks when !CONFIG_NUMA.
Remove that dependency by using a helper which returns always the
correct node id.

While at it, enable L3 Cache Index disable on revD1 Istanbuls which
sport the feature too.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 589b705..be5f5c2 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -327,7 +327,7 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 
 	/* see errata #382 and #388 */
 	if ((boot_cpu_data.x86 == 0x10) &&
-	    ((boot_cpu_data.x86_model < 0x9) ||
+	    ((boot_cpu_data.x86_model < 0x8) ||
 	     (boot_cpu_data.x86_mask  < 0x1)))
 		return;
 
@@ -744,7 +744,7 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 				  unsigned int index)
 {
 	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = cpu_to_node(cpu);
+	int node = amd_get_nb_id(cpu);
 	struct pci_dev *dev = node_to_k8_nb_misc(node);
 	unsigned int reg = 0;
 
@@ -771,7 +771,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	const char *buf, size_t count, unsigned int index)
 {
 	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = cpu_to_node(cpu);
+	int node = amd_get_nb_id(cpu);
 	struct pci_dev *dev = node_to_k8_nb_misc(node);
 	unsigned long val = 0;
 
-- 
1.6.6

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
