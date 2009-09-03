Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZICHmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZICHmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 03:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZICHmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 03:42:35 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:52340 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbZICHme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 03:42:34 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMzz1202hzzz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KPDXER-01-131-02
X-M-MSG: 
Date: Thu, 3 Sep 2009 09:42:20 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Borislav Petkov <borislav.petkov@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86, mcheck: Use correct cpumask for shared bank4
Message-ID: <20090903074220.GH7216@alberich.amd.com>
References: <20090903073818.GE7216@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090903073818.GE7216@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Sep 2009 07:42:20.0556 (UTC) FILETIME=[1184ECC0:01CA2C6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes threshold_bank4 support on multi-node processors.

The correct mask to use is llc_shared_map, representing an internal
node on Magny-Cours.

We need to create 2 sets of symlinks for sibling shared banks -- one
set for each internal node, symlinks of each set should target the
first core on same internal node.

Currently only one set is created where all symlinks are targeting
the first core of the entire socket.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index ddae216..1fecba4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -489,12 +489,14 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	int i, err = 0;
 	struct threshold_bank *b = NULL;
 	char name[32];
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
 
 	sprintf(name, "threshold_bank%i", bank);
 
 #ifdef CONFIG_SMP
 	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
-		i = cpumask_first(cpu_core_mask(cpu));
+		i = cpumask_first(c->llc_shared_map);
 
 		/* first core not up yet */
 		if (cpu_data(i).cpu_core_id)
@@ -514,7 +516,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (err)
 			goto out;
 
-		cpumask_copy(b->cpus, cpu_core_mask(cpu));
+		cpumask_copy(b->cpus, c->llc_shared_map);
 		per_cpu(threshold_banks, cpu)[bank] = b;
 
 		goto out;
@@ -539,7 +541,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 #ifndef CONFIG_SMP
 	cpumask_setall(b->cpus);
 #else
-	cpumask_copy(b->cpus, cpu_core_mask(cpu));
+	cpumask_copy(b->cpus, c->llc_shared_map);
 #endif
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
-- 
1.6.4



