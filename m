Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbZH2USU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbZH2USU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 16:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZH2UST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 16:18:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:49757 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbZH2USS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 16:18:18 -0400
Message-ID: <4A998CCA.1040407@kernel.org>
Date: Sat, 29 Aug 2009 13:17:14 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] x86: use hard_smp_processor_id to get apic id for amd k8
 cpus
References: <4A9391CD.5020804@kernel.org>  <4A946082.9090809@kernel.org>	 <1251240835.2636.28.camel@sbs-t61>  <4A948C88.9060403@kernel.org>	 <1251308988.2787.39.camel@sbs-t61.sc.intel.com> <4A9587FE.20503@kernel.org> <1251325455.2787.61.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1251325455.2787.61.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


otherwise, system with apci id lifting will have wrong apicid in
/proc/cpuinfo

and use that in srat_detect_node

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/kernel/cpu/amd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6/arch/x86/kernel/cpu/amd.c
@@ -277,7 +277,7 @@ static void __cpuinit srat_detect_node(s
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	int cpu = smp_processor_id();
 	int node;
-	unsigned apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
+	unsigned apicid = c->apicid;
 
 	node = c->phys_proc_id;
 	if (apicid_to_node[apicid] != NUMA_NO_NODE)
@@ -437,6 +437,9 @@ static void __cpuinit init_amd(struct cp
 	}
 	if (c->x86 == 0x10 || c->x86 == 0x11)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+
+	/* get apicid instead of initial apic id from cpuid */
+	c->apicid = hard_smp_processor_id();
 #else
 
 	/*
