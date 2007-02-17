Return-Path: <linux-kernel-owner+w=401wt.eu-S2992429AbXBQQIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992429AbXBQQIy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992431AbXBQQIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:08:54 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:49852 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992429AbXBQQIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:08:53 -0500
Date: Sat, 17 Feb 2007 08:08:38 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@linux-foundation.org,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: [PATCH] x86_64 make NMI use PERFCTR1 for architectural perfmon
Message-ID: <20070217160838.GB16715@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch against 2.6.20 makes the NMI watchdog use PERFSEL1/PERFCTR1
instead of PERFSEL0/PERFCTR0 on processors supporting Intel architectural
perfmon, such as Intel Core 2. Although all PMU events can work on
both counters, the Precise Event-Based Sampling (PEBS) requires that the
event be in PERFCTR0 to work correctly (see section 18.14.4.1 in the
IA32 SDM Vol 3b).

Changelog:
	- make the x86_64 NMI watchdog use PERFSEL1/PERFCTR1 instead of PERFSEL0/PERFCTR0
	  on processors supporting the Intel architectural perfmon (e.g. Core 2 Duo).
	  This allows PEBS to work when the NMI watchdog is active.

signed-off-by: stephane eranian <eranian@hpl.hp.com>

diff -urNp --exclude=.git linux-2.6.20.orig/arch/x86_64/kernel/nmi.c linux-2.6.20.base/arch/x86_64/kernel/nmi.c
--- linux-2.6.20.orig/arch/x86_64/kernel/nmi.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20.base/arch/x86_64/kernel/nmi.c	2007-02-17 08:04:19.000000000 -0800
@@ -275,7 +275,7 @@ int __init check_nmi_watchdog (void)
 		 * 32nd bit should be 1, for 33.. to be 1.
 		 * Find the appropriate nmi_hz
 		 */
-	 	if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0 &&
+	 	if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1 &&
 			((u64)cpu_khz * 1000) > 0x7fffffffULL) {
 			nmi_hz = ((u64)cpu_khz * 1000) / 0x7fffffffUL + 1;
 		}
@@ -615,8 +615,8 @@ static int setup_intel_arch_watchdog(voi
 	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
 		goto fail;
 
-	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR0;
-	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL0;
+	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR1;
+	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL1;
 
 	if (!reserve_perfctr_nmi(perfctr_msr))
 		goto fail;
@@ -855,7 +855,7 @@ int __kprobes nmi_watchdog_tick(struct p
 				dummy &= ~P4_CCCR_OVF;
 	 			wrmsrl(wd->cccr_msr, dummy);
 	 			apic_write(APIC_LVTPC, APIC_DM_NMI);
-	 		} else if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0) {
+	 		} else if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1) {
 				/*
 				 * ArchPerfom/Core Duo needs to re-unmask
 				 * the apic vector
