Return-Path: <linux-kernel-owner+w=401wt.eu-S933284AbZIDH75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284AbZIDH75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933051AbZIDH7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:59:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:33535 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279AbZIDH7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:59:54 -0400
Date: Fri, 4 Sep 2009 07:59:22 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, yinghai@kernel.org, andreas.herrmann3@amd.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, gorcunov@openvz.org, andreas.herrmann3@amd.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A998CCA.1040407@kernel.org>
References: <4A998CCA.1040407@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Use hard_smp_processor_id() to get apic id for AMD K8 cpus
Message-ID: <tip-0d96b9ff748b5f57d6f1d6d21209f5745245aadc@git.kernel.org>
Git-Commit-ID: 0d96b9ff748b5f57d6f1d6d21209f5745245aadc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 07:59:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d96b9ff748b5f57d6f1d6d21209f5745245aadc
Gitweb:     http://git.kernel.org/tip/0d96b9ff748b5f57d6f1d6d21209f5745245aadc
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 29 Aug 2009 13:17:14 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 09:55:29 +0200

x86: Use hard_smp_processor_id() to get apic id for AMD K8 cpus

Otherwise, system with apci id lifting will have wrong apicid in
/proc/cpuinfo.

and use that in srat_detect_node().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <4A998CCA.1040407@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/amd.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index a76d2c1..e1600c7 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -336,7 +336,7 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	int cpu = smp_processor_id();
 	int node;
-	unsigned apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
+	unsigned apicid = c->apicid;
 
 	node = per_cpu(cpu_llc_id, cpu);
 
@@ -481,6 +481,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	}
 	if (c->x86 == 0x10 || c->x86 == 0x11)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+
+	/* get apicid instead of initial apic id from cpuid */
+	c->apicid = hard_smp_processor_id();
 #else
 
 	/*
