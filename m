Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZG1PKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZG1PKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbZG1PKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:10:12 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:39735
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753681AbZG1PGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:42 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz655Nzz1202hzzz32i203h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KNHZAP-02-6P9-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [PATCH 03/20] x86: add cpu_node topology detection for AMD Magny-Cours
Date: Tue, 28 Jul 2009 17:06:03 +0200
Message-ID: <1248793580-29899-4-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:23.0691 (UTC) FILETIME=[F8C7F1B0:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

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

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |   59 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 59 insertions(+), 1 deletions(-)

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
index e2485b0..d90abeb 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -251,6 +251,56 @@ static int __cpuinit nearby_node(int apicid)
 #endif
 
 /*
+ * Fixup core topology information for AMD multi-node processors.
+ * Assumption 1: Number of cores in each internal node is the same.
+ * Assumption 2: Mixed systems with both single-node and dual-node
+ *               processors are not supported.
+ */
+static void __cpuinit amd_fixup_dcm(struct cpuinfo_x86 *c)
+{
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
+}
+
+/*
  * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
  * Assumes number of cores is a power of two.
  */
@@ -267,6 +317,9 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 	c->phys_proc_id = c->initial_apicid >> bits;
 	/* use socket ID also for last level cache */
 	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
+	/* fixup topology information on multi-node processors */
+	if ((c->x86 == 0x10) && (c->x86_model == 9))
+		amd_fixup_dcm(c);
 #endif
 }
 
@@ -277,7 +330,11 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
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


