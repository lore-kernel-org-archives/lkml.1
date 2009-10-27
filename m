Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZJ0JjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZJ0JjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 05:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbZJ0JjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 05:39:15 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60047 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbZJ0JjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 05:39:14 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Oct 2009 05:39:13 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XOMfFSdRZMpTS1UnZkxY/E1hiokDjNCAki+YpJ0LTgAmMqXuOBsUXCy8SHbLdmA9yG
         V+Xq9aqjaRi4PJ9gjSicmdtppFSnSX9zNY8/CVIsHhgd3RmDwASGD6i+qrur47GUtV5B
         ANB2Vzukw6UJrYc0iVNPS+279JI4DQePnxbjY=
Date: Tue, 27 Oct 2009 10:33:40 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] x86, amd: Get multi-node CPU info from NodeId MSR
 instead of PCI config space
Message-ID: <20091027093340.GA30802@alberich.amd.com>
References: <20091016122229.GB8387@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016122229.GB8387@alberich.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use newly introduced NodeId MSR to get NodeId and number of nodes per
processor. Production systems will support this from scratch. Thus the
PCI config space accesses are superfluous and should be removed asap.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |   53 ++++++++++--------------------------
 2 files changed, 16 insertions(+), 38 deletions(-)

Please apply for .32.

Thanks,
Andreas


diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 9cfc88b..2cbf0a2 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -153,6 +153,7 @@
 #define X86_FEATURE_SSE5	(6*32+11) /* SSE-5 */
 #define X86_FEATURE_SKINIT	(6*32+12) /* SKINIT/STGI instructions */
 #define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
+#define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c910a71..3f56759 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -254,59 +254,36 @@ static int __cpuinit nearby_node(int apicid)
 
 /*
  * Fixup core topology information for AMD multi-node processors.
- * Assumption 1: Number of cores in each internal node is the same.
- * Assumption 2: Mixed systems with both single-node and dual-node
- *               processors are not supported.
+ * Assumption: Number of cores in each internal node is the same.
  */
 #ifdef CONFIG_X86_HT
 static void __cpuinit amd_fixup_dcm(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_PCI
-	u32 t, cpn;
-	u8 n, n_id;
+	unsigned long long value;
+	u32 nodes, cores_per_node; 
 	int cpu = smp_processor_id();
 
+	if (!cpu_has(c, X86_FEATURE_NODEID_MSR))
+		return;
+
 	/* fixup topology information only once for a core */
 	if (cpu_has(c, X86_FEATURE_AMD_DCM))
 		return;
 
-	/* check for multi-node processor on boot cpu */
-	t = read_pci_config(0, 24, 3, 0xe8);
-	if (!(t & (1 << 29)))
+	rdmsrl(0xc001100c, value);
+
+	nodes = ((value >> 3) & 7) + 1;
+	if (nodes == 1)
 		return;
 
 	set_cpu_cap(c, X86_FEATURE_AMD_DCM);
+	cores_per_node = c->x86_max_cores / nodes;
 
-	/* cores per node: each internal node has half the number of cores */
-	cpn = c->x86_max_cores >> 1;
+	/* store NodeID, use llc_shared_map to store sibling info */
+	per_cpu(cpu_llc_id, cpu) = value & 7;
 
-	/* even-numbered NB_id of this dual-node processor */
-	n = c->phys_proc_id << 1;
-
-	/*
-	 * determine internal node id and assign cores fifty-fifty to
-	 * each node of the dual-node processor
-	 */
-	t = read_pci_config(0, 24 + n, 3, 0xe8);
-	n = (t>>30) & 0x3;
-	if (n == 0) {
-		if (c->cpu_core_id < cpn)
-			n_id = 0;
-		else
-			n_id = 1;
-	} else {
-		if (c->cpu_core_id < cpn)
-			n_id = 1;
-		else
-			n_id = 0;
-	}
-
-	/* compute entire NodeID, use llc_shared_map to store sibling info */
-	per_cpu(cpu_llc_id, cpu) = (c->phys_proc_id << 1) + n_id;
-
-	/* fixup core id to be in range from 0 to cpn */
-	c->cpu_core_id = c->cpu_core_id % cpn;
-#endif
+	/* fixup core id to be in range from 0 to (cores_per_node - 1) */
+	c->cpu_core_id = c->cpu_core_id % cores_per_node;
 }
 #endif
 
-- 
1.6.0.4

