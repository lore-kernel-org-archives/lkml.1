Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbZELTYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbZELTYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 15:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZELTYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 15:24:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:56656 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbZELTYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 15:24:33 -0400
Message-ID: <4A09CCBB.2000306@kernel.org>
Date: Tue, 12 May 2009 12:23:39 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/numa] x86: read apic ID in the !acpi_lapic case
References: <tip-4797f6b021a3fa399942245d07a1feb30df81bb8@git.kernel.org> <20090512112205.GA12108@elte.hu> <20090512145128.GA10220@lenovo> <20090512145808.GA20587@elte.hu> <4A099013.6040708@kernel.org> <20090512150631.GA32067@elte.hu> <20090512164617.GA21673@elte.hu> <4A09C068.3010308@kernel.org> <20090512183302.GA4000@elte.hu> <4A09C157.7010407@kernel.org> <20090512190538.GA9769@elte.hu>
In-Reply-To: <20090512190538.GA9769@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check

[PATCH] x86: don't call read_apic_id if !cpu_has_apic

should not call that if apic is disabled.

[ Impact:  fix calling to read_apic_id ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/apic_flat_64.c |    2 +-
 arch/x86/kernel/cpu/amd.c           |    2 +-
 arch/x86/kernel/cpu/common.c        |    8 +++++++-
 arch/x86/kernel/cpu/intel.c         |    6 +++---
 4 files changed, 12 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/apic_flat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic_flat_64.c
+++ linux-2.6/arch/x86/kernel/apic/apic_flat_64.c
@@ -161,7 +161,7 @@ static int flat_apic_id_registered(void)
 
 static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
 {
-	return hard_smp_processor_id() >> index_msb;
+	return initial_apic_id >> index_msb;
 }
 
 struct apic apic_flat =  {
Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6/arch/x86/kernel/cpu/amd.c
@@ -272,7 +272,7 @@ static void __cpuinit srat_detect_node(s
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	int cpu = smp_processor_id();
 	int node;
-	unsigned apicid = hard_smp_processor_id();
+	unsigned apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
 
 	node = c->phys_proc_id;
 	if (apicid_to_node[apicid] != NUMA_NO_NODE)
Index: linux-2.6/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel.c
+++ linux-2.6/arch/x86/kernel/cpu/intel.c
@@ -252,12 +252,12 @@ static void __cpuinit intel_workarounds(
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
@@ -423,7 +423,7 @@ static void __cpuinit init_intel(struct
 	}
 
 	/* Work around errata */
-	srat_detect_node();
+	srat_detect_node(c);
 
 	if (cpu_has(c, X86_FEATURE_VMX))
 		detect_vmx_virtcap(c);
Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -763,6 +763,12 @@ static void __cpuinit identify_cpu(struc
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
@@ -810,7 +816,7 @@ static void __cpuinit identify_cpu(struc
 	init_hypervisor(c);
 
 	/*
-	 * Clear/Set all flags overriden by options, need do it
+	 * Finally Clear/Set all flags overriden by options, need do it
 	 * before following smp all cpus cap AND.
 	 */
 	for (i = 0; i < NCAPINTS; i++) {
