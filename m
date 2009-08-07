Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbZHGNAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbZHGNAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757873AbZHGNAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:00:31 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:32608 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757851AbZHGNAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:00:30 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz655Nzz1202hzzz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KO0C2O-01-2CD-02
X-M-MSG: 
Date: Fri, 7 Aug 2009 14:58:43 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: [PATCH 3/8] x86: Add cpu_node topology detection for AMD
	Magny-Cours
Message-ID: <20090807125843.GV6520@alberich.amd.com>
References: <20090807125609.GH7198@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090807125609.GH7198@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 07 Aug 2009 12:58:43.0890 (UTC) FILETIME=[CB509120:01CA175E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adapts CPU topology detection for AMD Magny-Cours.

Here is example output from two cores on same package but different
internal cpu_nodes:

/sys/devices/system/cpu/cpu5:
  physical_package_id        : 0
  core_id                    : 5
  thread_siblings            : 00000020
  thread_siblings_list       : 5
  cpu_node_id                : 0
  cpu_node_siblings          : 0000003f
  cpu_node_siblings_list     : 0-5
  core_siblings              : 00000fff
  core_siblings_list         : 0-11
/sys/devices/system/cpu/cpu6:
  physical_package_id        : 0
  core_id                    : 0
  thread_siblings            : 00000040
  thread_siblings_list       : 6
  cpu_node_id                : 1
  cpu_node_siblings          : 00000fc0
  cpu_node_siblings_list     : 6-11
  core_siblings              : 00000fff
  core_siblings_list         : 0-11

Included allnoconfig compile fix by Nicolas Palix <npalix@diku.dk>.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |   69 +++++++++++++++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4a28d22..847fee6 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -95,6 +95,7 @@
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
 #define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with monitor */
 #define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
+#define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ec6c7a8..f18ece1 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -253,6 +253,60 @@ static int __cpuinit nearby_node(int apicid)
 #endif
 
 /*
+ * Fixup core topology information for AMD multi-node processors.
+ * Assumption 1: Number of cores in each internal node is the same.
+ * Assumption 2: Mixed systems with both single-node and dual-node
+ *               processors are not supported.
+ */
+#ifdef CONFIG_X86_HT
+static void __cpuinit amd_fixup_dcm(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_PCI
+	u32 t, cpn;
+	u8 n;
+
+	/* fixup topology information only once for a core */
+	if (cpu_has(c, X86_FEATURE_AMD_DCM))
+		return;
+
+	/* check for multi-node processor on boot cpu */
+	t = read_pci_config(0, 24, 3, 0xe8);
+	if (!(t & (1 << 29)))
+		return;
+
+	set_cpu_cap(c, X86_FEATURE_AMD_DCM);
+
+	/* cores per node: each internal node has half the number of cores */
+	cpn = c->x86_max_cores >> 1;
+
+	/* even-numbered NB_id of this dual-node processor */
+	n = c->phys_proc_id << 1;
+
+	/*
+	 * determine internal node id and assign cores fifty-fifty to
+	 * each node of the dual-node processor
+	 */
+	t = read_pci_config(0, 24 + n, 3, 0xe8);
+	n = (t>>30) & 0x3;
+	if (n == 0) {
+		if (c->cpu_core_id < cpn)
+			c->cpu_node_id = 0;
+		else
+			c->cpu_node_id = 1;
+	} else {
+		if (c->cpu_core_id < cpn)
+			c->cpu_node_id = 1;
+		else
+			c->cpu_node_id = 0;
+	}
+
+	 /* fixup core id to be in range from 0 to cpn */
+	c->cpu_core_id = c->cpu_core_id % cpn;
+#endif
+}
+#endif
+
+/*
  * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
  * Assumes number of cores is a power of two.
  */
@@ -267,8 +321,15 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 	c->cpu_core_id = c->initial_apicid & ((1 << bits)-1);
 	/* Convert the initial APIC ID into the socket ID */
 	c->phys_proc_id = c->initial_apicid >> bits;
+	/* fixup topology information on multi-node processors */
+	if ((c->x86 == 0x10) && (c->x86_model == 9))
+		amd_fixup_dcm(c);
 	/* use socket ID also for last level cache */
-	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
+	if (cpu_has(c, X86_FEATURE_AMD_DCM))
+		per_cpu(cpu_llc_id, cpu) = (c->phys_proc_id << 1) +
+		  c->cpu_node_id;
+	else
+		per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
 #endif
 }
 
@@ -279,7 +340,11 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 	int node;
 	unsigned apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
 
-	node = c->phys_proc_id;
+	if (cpu_has(c, X86_FEATURE_AMD_DCM))
+		node = (c->phys_proc_id << 1) + c->cpu_node_id;
+	else
+		node = c->phys_proc_id;
+
 	if (apicid_to_node[apicid] != NUMA_NO_NODE)
 		node = apicid_to_node[apicid];
 	if (!node_online(node)) {
-- 
1.6.3.3



