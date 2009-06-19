Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbZFSJAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbZFSJAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 05:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZFSJAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 05:00:32 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:41779 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZFSJAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 05:00:31 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i6bh17ch62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KLHAC5-01-WZQ-01
Date: Fri, 19 Jun 2009 10:59:09 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: set cpu_llc_id on AMD CPUs
Message-ID: <20090619085909.GJ5218@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 19 Jun 2009 09:00:06.0654 (UTC) FILETIME=[5755F9E0:01C9F0BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This counts when building sched domains in case NUMA information
is not available.
(See cpu_coregroup_mask() which uses llc_shared_map which in turn is
created based on cpu_llc_id.)

Currently Linux builds domains as follows
(example from a dual socket quad-core system)

 CPU0 attaching sched-domain:
  domain 0: span 0-7 level CPU
   groups: 0 1 2 3 4 5 6 7

  ...

 CPU7 attaching sched-domain:
  domain 0: span 0-7 level CPU
   groups: 7 0 1 2 3 4 5 6

Ever since that is borked for multi-core AMD CPU systems.
This patch fixes that and now we get

 CPU0 attaching sched-domain:
  domain 0: span 0-3 level MC
   groups: 0 1 2 3
   domain 1: span 0-7 level CPU
    groups: 0-3 4-7

  ...

 CPU7 attaching sched-domain:
  domain 0: span 4-7 level MC
   groups: 7 4 5 6
   domain 1: span 0-7 level CPU
    groups: 4-7 0-3

This allows scheduler to assign tasks to cores on different sockets
(i.e. that don't share last level cache) for performance reasons.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/amd.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

Please apply.
Maybe that fix should go to stable-tree(s) as well.

Thanks,
Andreas

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e5b27d8..28e5f59 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -258,13 +258,15 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_HT
 	unsigned bits;
+	int cpu = smp_processor_id();
 
 	bits = c->x86_coreid_bits;
-
 	/* Low order bits define the core id (index of core in socket) */
 	c->cpu_core_id = c->initial_apicid & ((1 << bits)-1);
 	/* Convert the initial APIC ID into the socket ID */
 	c->phys_proc_id = c->initial_apicid >> bits;
+	/* use socket ID also for last level cache */
+	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
 #endif
 }
 
-- 
1.6.3.1



