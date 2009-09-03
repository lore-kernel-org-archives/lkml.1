Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbZICHpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbZICHpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 03:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZICHpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 03:45:05 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:58279 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbZICHpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 03:45:04 -0400
X-SpamScore: -2
X-BigFish: VPS-2(z34a4jz936eMzz1202hzzz32i203h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KPDXIX-02-D1V-02
X-M-MSG: 
Date: Thu, 3 Sep 2009 09:44:28 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Borislav Petkov <borislav.petkov@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] x86, sched: Workaround broken sched domain creation
	for AMD Magny-Cours
Message-ID: <20090903074428.GI7216@alberich.amd.com>
References: <20090903073818.GE7216@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090903073818.GE7216@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Sep 2009 07:44:29.0137 (UTC) FILETIME=[5E28D410:01CA2C6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Current sched domain creation code can't handle multi-node processors.
When switching to power_savings scheduling errors show up and
system might hang later on (due to broken sched domain hierarchy):

  # echo 0  >> /sys/devices/system/cpu/sched_mc_power_savings
  CPU0 attaching sched-domain:
   domain 0: span 0-5 level MC
    groups: 0 1 2 3 4 5
    domain 1: span 0-23 level NODE
     groups: 0-5 6-11 18-23 12-17
  ...
  # echo 1  >> /sys/devices/system/cpu/sched_mc_power_savings
  CPU0 attaching sched-domain:
   domain 0: span 0-11 level MC
    groups: 0 1 2 3 4 5 6 7 8 9 10 11
  ERROR: parent span is not a superset of domain->span
    domain 1: span 0-5 level CPU
  ERROR: domain->groups does not contain CPU0
     groups: 6-11 (__cpu_power = 12288)
  ERROR: groups don't span domain->span
     domain 2: span 0-23 level NODE
      groups:
  ERROR: domain->cpu_power not set

  ERROR: groups don't span domain->span
  ...

Fixing all aspects of power-savings scheduling for Magny-Cours needs
some larger changes in the sched domain creation code.

As a short-term and temporary workaround avoid the problems by
extending "the worst possible hack" ;-(
and always use llc_shared_map on AMD Magny-Cours when MC domain span
is calculated.

With this I get:

  # echo 1  >> /sys/devices/system/cpu/sched_mc_power_savings
  CPU0 attaching sched-domain:
   domain 0: span 0-5 level MC
    groups: 0 1 2 3 4 5
    domain 1: span 0-5 level CPU
     groups: 0-5 (__cpu_power = 6144)
     domain 2: span 0-23 level NODE
      groups: 0-5 (__cpu_power = 6144) 6-11 (__cpu_power = 6144) 18-23 (__cpu_power = 6144) 12-17 (__cpu_power = 6144)
  ...

I.e. no errors during sched domain creation, no system hangs, and also
mc_power_savings scheduling works to a certain extend.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/smpboot.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2fecda6..c36cc14 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -434,7 +434,8 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	 * For perf, we return last level cache shared map.
 	 * And for power savings, we return cpu_core_map
 	 */
-	if (sched_mc_power_savings || sched_smt_power_savings)
+	if ((sched_mc_power_savings || sched_smt_power_savings) &&
+	    !(cpu_has(c, X86_FEATURE_AMD_DCM)))
 		return cpu_core_mask(cpu);
 	else
 		return c->llc_shared_map;
-- 
1.6.4



