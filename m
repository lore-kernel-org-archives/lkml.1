Return-Path: <linux-kernel-owner+w=401wt.eu-S1765588AbXJZRRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765588AbXJZRRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbXJZRRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:17:25 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:48229 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309AbXJZRRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:17:24 -0400
Subject: [PATCH] voyager: fix bogus conversion to per_cpu for boot_cpu_info
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: travis@sgi.com, clameter@sgi.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 12:17:19 -0500
Message-Id: <1193419039.3293.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There were two problems.  Firstly, someone forgot the struct keyword in
front of cpuinfo_x86, so I take it this wasn't even compile checked.
Secondly, the actual definition has this as a SHARED_ALIGNED, so the
definitions mismatch.

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

---

James

diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 361ac51..6937143 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -29,14 +29,14 @@
 #include <asm/arch_hooks.h>
 
 /* TLB state -- visible externally, indexed physically */
-DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate) ____cacheline_aligned = { &init_mm, 0 };
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate) = { &init_mm, 0 };
 
 /* CPU IRQ affinity -- set to all ones initially */
 static unsigned long cpu_irq_affinity[NR_CPUS] __cacheline_aligned = { [0 ... NR_CPUS-1]  = ~0UL };
 
 /* per CPU data structure (for /proc/cpuinfo et al), visible externally
  * indexed physically */
-DEFINE_PER_CPU(cpuinfo_x86, cpu_info) __cacheline_aligned;
+DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 /* physical ID of the CPU used to boot the system */


