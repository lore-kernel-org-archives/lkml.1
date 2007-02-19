Return-Path: <linux-kernel-owner+w=401wt.eu-S932759AbXBSWeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbXBSWeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932761AbXBSWeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:34:13 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:52693 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932759AbXBSWeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:34:12 -0500
Date: Mon, 19 Feb 2007 14:34:00 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH] x86_64 make NMI use PERFCTR1 for architectural perfmon (take 2)
Message-ID: <20070219223400.GB30469@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070217160838.GB16715@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217160838.GB16715@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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


diff -urNp --exclude=.git linux-2.6.20.orig/arch/x86_64/kernel/nmi.c linux-2.6.20.base/arch/x86_64/kernel/nmi.c
--- linux-2.6.20.orig/arch/x86_64/kernel/nmi.c	2007-02-19 13:37:27.000000000 -0800
+++ linux-2.6.20.base/arch/x86_64/kernel/nmi.c	2007-02-19 14:27:45.000000000 -0800
@@ -285,7 +285,7 @@ int __init check_nmi_watchdog (void)
 		struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 
 		nmi_hz = 1;
-	 	if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0)
+	 	if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1)
 			nmi_hz = adjust_for_32bit_ctr(nmi_hz);
 	}
 
@@ -650,8 +650,8 @@ static int setup_intel_arch_watchdog(voi
 	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
 		goto fail;
 
-	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR0;
-	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL0;
+	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR1;
+	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL1;
 
 	if (!reserve_perfctr_nmi(perfctr_msr))
 		goto fail;
@@ -895,7 +895,7 @@ int __kprobes nmi_watchdog_tick(struct p
 				/* start the cycle over again */
 				wrmsrl(wd->perfctr_msr,
 				       -((u64)cpu_khz * 1000 / nmi_hz));
-	 		} else if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0) {
+	 		} else if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1) {
 				/*
 				 * ArchPerfom/Core Duo needs to re-unmask
 				 * the apic vector
