Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbZHaND7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbZHaND7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 09:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZHaND6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 09:03:58 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:14334
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752619AbZHaND5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 09:03:57 -0400
X-SpamScore: 0
X-BigFish: VPS0(z34a4jz936eMzz1202hzzz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KP8S7Y-01-A3R-02
X-M-MSG: 
Date: Mon, 31 Aug 2009 15:02:09 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <borislav.petkov@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] x86, mcheck: Make use of cpu_node_mask instead of
	cpu_core_mask
Message-ID: <20090831130209.GF21867@alberich.amd.com>
References: <20090831125349.GA21867@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090831125349.GA21867@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 31 Aug 2009 13:02:09.0484 (UTC) FILETIME=[3FC5B8C0:01CA2A3B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes threshold_bank4 support on multi-node processors.

We need to create 2 sets of symlinks for sibling shared banks -- one
set for each internal node, symlinks of each set should target the
first core on same internal node.

Currently only one set is created where all symlinks are targeting
the first core of the entire socket.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index ddae216..595cbe5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
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
1.6.4



