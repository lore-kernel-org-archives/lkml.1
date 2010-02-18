Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0BRUl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 15:41:59 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:39665 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab0BRUl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 15:41:57 -0500
X-SpamScore: -8
X-BigFish: VPS-8(zz154dM98dNab9bhzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KY21HN-02-561-02
X-M-MSG: 
Date: Thu, 18 Feb 2010 19:43:39 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: [PATCH 1/2] x86, cacheinfo: Remove NUMA dependency, fix for
 Fam10h, rev.D1
Message-ID: <20100218184339.GG20473@aftab>
References: <1266234236-24749-1-git-send-email-bp@amd64.org>
 <tip-472bf751b56324f8c96d97ada3c9dcdc8b2ec4f7@git.kernel.org>
 <20100216140246.GA31213@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100216140246.GA31213@elte.hu>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Feb 2010 18:43:35.0500 (UTC) FILETIME=[4706F0C0:01CAB0CA]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 03:02:46PM +0100, Ingo Molnar wrote:

> Also, there's a typo in the changelog: s/Isntanbul/Istanbul

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 4 Feb 2010 12:09:07 +0100
Subject: [PATCH 1/2] x86, cacheinfo: Remove NUMA dependency, fix for Fam10h, rev.D1

The show/store_cache_disable routines depend unnecessarily on NUMA's
cpu_to_node and the disabling of cache indices broke when !CONFIG_NUMA.
Remove that dependency by using a helper which is always correct.

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
1.6.4.2


-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center

