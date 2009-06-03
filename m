Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbZFCOpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbZFCOpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZFCOpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:45:36 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:3204 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753234AbZFCOpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:45:36 -0400
X-SpamScore: 3
X-BigFish: VPS3(z34a4jzzz1202hzzz32i17ch1a3h6bh)
X-FB-SS: 5,
X-WSS-ID: 0KKO3NO-02-UIX-01
Date: Wed, 3 Jun 2009 16:44:43 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Bert Wesarg <bert.wesarg@googlemail.com>
Subject: [PATCH 5/5] x86: mcheck: make use of cpu_node_mask instead of
	cpu_core_mask to support multi-node processors
Message-ID: <20090603144443.GN5736@alberich.amd.com>
References: <20090603142727.GI5736@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090603142727.GI5736@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Jun 2009 14:45:29.0194 (UTC) FILETIME=[F052A4A0:01C9E459]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes threshold_bank4 support.

We need to create symlinks for sibling shared banks to first core of
each internal node and not to first core of one internal node.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index ddae216..595cbe5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -494,7 +494,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 #ifdef CONFIG_SMP
 	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
-		i = cpumask_first(cpu_core_mask(cpu));
+		i = cpumask_first(cpu_node_mask(cpu));
 
 		/* first core not up yet */
 		if (cpu_data(i).cpu_core_id)
@@ -514,7 +514,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (err)
 			goto out;
 
-		cpumask_copy(b->cpus, cpu_core_mask(cpu));
+		cpumask_copy(b->cpus, cpu_node_mask(cpu));
 		per_cpu(threshold_banks, cpu)[bank] = b;
 
 		goto out;
@@ -539,7 +539,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 #ifndef CONFIG_SMP
 	cpumask_setall(b->cpus);
 #else
-	cpumask_copy(b->cpus, cpu_core_mask(cpu));
+	cpumask_copy(b->cpus, cpu_node_mask(cpu));
 #endif
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
-- 
1.6.3.1



