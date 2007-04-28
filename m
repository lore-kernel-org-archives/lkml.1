Return-Path: <linux-kernel-owner+w=401wt.eu-S1163331AbXD1Ryj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163331AbXD1Ryj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163305AbXD1Rxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:31 -0400
Received: from ns2.suse.de ([195.135.220.15]:38646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163306AbXD1Rwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:49 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Stephane Eranian <eranian@hpl.hp.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [23/35] x86_64: x86_64 make NMI use PERFCTR1 for architectural perfmon (take 2)
Message-Id: <20070428175248.75C6A151D1@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stephane Eranian <eranian@hpl.hp.com>
Hello,

This patch against 2.6.20-git14 makes the NMI watchdog use PERFSEL1/PERFCTR1
instead of PERFSEL0/PERFCTR0 on processors supporting Intel architectural
perfmon, such as Intel Core 2. Although all PMU events can work on
both counters, the Precise Event-Based Sampling (PEBS) requires that the
event be in PERFCTR0 to work correctly (see section 18.14.4.1 in the
IA32 SDM Vol 3b). This versions has 3 chunks compared to previous where
we had missed on check.

Changelog:
        - make the x86-64 NMI watchdog use PERFSEL1/PERFCTR1 instead of PERFSEL0/PERFCTR0
          on processors supporting the Intel architectural perfmon (e.g. Core 2 Duo).
          This allows PEBS to work when the NMI watchdog is active.

signed-off-by: stephane eranian <eranian@hpl.hp.com>


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/nmi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/arch/x86_64/kernel/nmi.c
===================================================================
--- linux.orig/arch/x86_64/kernel/nmi.c
+++ linux/arch/x86_64/kernel/nmi.c
@@ -348,7 +348,7 @@ int __init check_nmi_watchdog (void)
 		struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 
 		nmi_hz = 1;
-	 	if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0)
+	 	if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1)
 			nmi_hz = adjust_for_32bit_ctr(nmi_hz);
 	}
 
@@ -713,8 +713,8 @@ static int setup_intel_arch_watchdog(voi
 	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
 		goto fail;
 
-	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR0;
-	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL0;
+	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR1;
+	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL1;
 
 	if (!__reserve_perfctr_nmi(-1, perfctr_msr))
 		goto fail;
@@ -958,7 +958,7 @@ int __kprobes nmi_watchdog_tick(struct p
 				/* start the cycle over again */
 				wrmsrl(wd->perfctr_msr,
 				       -((u64)cpu_khz * 1000 / nmi_hz));
-	 		} else if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0) {
+	 		} else if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1) {
 				/*
 				 * ArchPerfom/Core Duo needs to re-unmask
 				 * the apic vector
