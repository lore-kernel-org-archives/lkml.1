Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbZA3SeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbZA3SeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 13:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZA3SeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 13:34:01 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39535 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139AbZA3SeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 13:34:00 -0500
Subject: [PATCH] voyager: remove duplicate cpu_callin/out_map symbols
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mike Travis <travis@sgi.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 18:34:01 +0000
Message-Id: <1233340441.3248.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c2d1cec1c77f7714672c1efeae075424c929e0d5
Author: Mike Travis <travis@sgi.com>
Date:   Sun Jan 4 05:18:03 2009 -0800

    x86: cleanup remaining cpumask_t ops in smpboot code

Moved the cpu_callin_map and cpu_callout_map symbols from smp boot
local code to cpu/common.c.  However, it forgot to move them for
voyager leading to duplicate symbols in the voyager build.  Fix this by
making voyager use the common symbols.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/mach-voyager/voyager_smp.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index dcc07d5..b1b1bd3 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -211,8 +211,6 @@ static __u32 cpu_booted_map;
 static cpumask_t smp_commenced_mask = CPU_MASK_NONE;
 
 /* This is for the new dynamic CPU boot code */
-cpumask_t cpu_callin_map = CPU_MASK_NONE;
-cpumask_t cpu_callout_map = CPU_MASK_NONE;
 
 /* The per processor IRQ masks (these are usually kept in sync) */
 static __u16 vic_irq_mask[NR_CPUS] __cacheline_aligned;
@@ -1750,10 +1748,11 @@ static void __cpuinit voyager_smp_prepare_boot_cpu(void)
 	init_gdt(smp_processor_id());
 	switch_to_new_gdt();
 
-	cpu_set(smp_processor_id(), cpu_online_map);
-	cpu_set(smp_processor_id(), cpu_callout_map);
-	cpu_set(smp_processor_id(), cpu_possible_map);
-	cpu_set(smp_processor_id(), cpu_present_map);
+	cpu_online_map = cpumask_of_cpu(smp_processor_id());
+	cpu_callout_map = cpumask_of_cpu(smp_processor_id());
+	cpu_callin_map = CPU_MASK_NONE;
+	cpu_present_map = cpumask_of_cpu(smp_processor_id());
+
 }
 
 static int __cpuinit voyager_cpu_up(unsigned int cpu)
-- 
1.5.6.6



