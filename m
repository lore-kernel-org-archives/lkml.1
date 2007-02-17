Return-Path: <linux-kernel-owner+w=401wt.eu-S1750929AbXBQQHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929AbXBQQHR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbXBQQHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:07:17 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:49806 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbXBQQHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:07:15 -0500
Date: Sat, 17 Feb 2007 08:06:56 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@linux-foundation.org,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: [PATCH] i386 make NMI use PERFCTR1 for architectural perfmon
Message-ID: <20070217160656.GA16715@frankl.hpl.hp.com>
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

A similar patch for x86-64 is to follow.

Changelog:
	- make the i386 NMI watchdog use PERFSEL1/PERFCTR1 instead of PERFSEL0/PERFCTR0
	  on processors supporting the Intel architectural perfmon (e.g. Core 2 Duo).
	  This allows PEBS to work when the NMI watchdog is active.

signed-off-by: stephane eranian <eranian@hpl.hp.com>


diff -urNp --exclude=.git linux-2.6.20.orig/arch/i386/kernel/nmi.c linux-2.6.20.base/arch/i386/kernel/nmi.c
--- linux-2.6.20.orig/arch/i386/kernel/nmi.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20.base/arch/i386/kernel/nmi.c	2007-02-17 07:59:41.000000000 -0800
@@ -288,7 +288,7 @@ static int __init check_nmi_watchdog(voi
 		 * 32nd bit should be 1, for 33.. to be 1.
 		 * Find the appropriate nmi_hz
 		 */
-	 	if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0 &&
+	 	if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1 &&
 			((u64)cpu_khz * 1000) > 0x7fffffffULL) {
 			u64 count = (u64)cpu_khz * 1000;
 			do_div(count, 0x7fffffffUL);
@@ -685,8 +685,8 @@ static int setup_intel_arch_watchdog(voi
 	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
 		goto fail;
 
-	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR0;
-	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL0;
+	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR1;
+	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL1;
 
 	if (!reserve_perfctr_nmi(perfctr_msr))
 		goto fail;
@@ -958,7 +958,7 @@ __kprobes int nmi_watchdog_tick(struct p
 	 			apic_write(APIC_LVTPC, APIC_DM_NMI);
 	 		}
 			else if (wd->perfctr_msr == MSR_P6_PERFCTR0 ||
-				 wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0) {
+				 wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1) {
 				/* P6 based Pentium M need to re-unmask
 				 * the apic vector but it doesn't hurt
 				 * other P6 variant.
-- 
-Stephane
