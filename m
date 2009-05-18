Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbZERHvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbZERHvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbZERHvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:51:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:39487 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813AbZERHu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:50:59 -0400
Date: Mon, 18 May 2009 07:39:43 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, gorcunov@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, gorcunov@gmail.com,
       mingo@elte.hu
In-Reply-To: <4A09CCBB.2000306@kernel.org>
References: <4A09CCBB.2000306@kernel.org>
Subject: [tip:irq/numa] x86: don't call read_apic_id if !cpu_has_apic
Message-ID: <tip-2759c3287de27266e06f1f4e82cbd2d65f6a044c@git.kernel.org>
Git-Commit-ID: 2759c3287de27266e06f1f4e82cbd2d65f6a044c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 18 May 2009 07:39:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2759c3287de27266e06f1f4e82cbd2d65f6a044c
Gitweb:     http://git.kernel.org/tip/2759c3287de27266e06f1f4e82cbd2d65f6a044c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 15 May 2009 13:05:16 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 May 2009 08:43:25 +0200

x86: don't call read_apic_id if !cpu_has_apic

should not call that if apic is disabled.

[ Impact: fix crash on certain UP configs ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
LKML-Reference: <4A09CCBB.2000306@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic_flat_64.c |    2 +-
 arch/x86/kernel/cpu/amd.c           |    2 +-
 arch/x86/kernel/cpu/common.c        |    6 ++++++
 arch/x86/kernel/cpu/intel.c         |    6 +++---
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 744e6d8..d0c99ab 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -161,7 +161,7 @@ static int flat_apic_id_registered(void)
 
 static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
 {
-	return hard_smp_processor_id() >> index_msb;
+	return initial_apic_id >> index_msb;
 }
 
 struct apic apic_flat =  {
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7e4a459..728b375 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -272,7 +272,7 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	int cpu = smp_processor_id();
 	int node;
-	unsigned apicid = hard_smp_processor_id();
+	unsigned apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
 
 	node = c->phys_proc_id;
 	if (apicid_to_node[apicid] != NUMA_NO_NODE)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c1caefc..017c600 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -761,6 +761,12 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	if (this_cpu->c_identify)
 		this_cpu->c_identify(c);
 
+	/* Clear/Set all flags overriden by options, after probe */
+	for (i = 0; i < NCAPINTS; i++) {
+		c->x86_capability[i] &= ~cpu_caps_cleared[i];
+		c->x86_capability[i] |= cpu_caps_set[i];
+	}
+
 #ifdef CONFIG_X86_64
 	c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
 #endif
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 7437fa1..daed39b 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -229,12 +229,12 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 }
 #endif
 
-static void __cpuinit srat_detect_node(void)
+static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 {
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	unsigned node;
 	int cpu = smp_processor_id();
-	int apicid = hard_smp_processor_id();
+	int apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
 
 	/* Don't do the funky fallback heuristics the AMD version employs
 	   for now. */
@@ -400,7 +400,7 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 	}
 
 	/* Work around errata */
-	srat_detect_node();
+	srat_detect_node(c);
 
 	if (cpu_has(c, X86_FEATURE_VMX))
 		detect_vmx_virtcap(c);
