Return-Path: <linux-kernel-owner+w=401wt.eu-S932845AbXIUWsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbXIUWsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764159AbXIUWcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:57119 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762220AbXIUWcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:43 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [42/50] i386: constify wd_ops
Message-Id: <20070921223242.8902613DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
.. as they're, with a single exception, never written to.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/i386/kernel/cpu/perfctr-watchdog.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

Index: linux/arch/i386/kernel/cpu/perfctr-watchdog.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ linux/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -34,7 +34,7 @@ struct wd_ops {
 	u64 checkbit;
 };
 
-static struct wd_ops *wd_ops;
+static const struct wd_ops *wd_ops;
 
 /* this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
  * offset from MSR_P4_BSU_ESCR0.  It will be the max for all platforms (for now)
@@ -325,7 +325,7 @@ static void single_msr_rearm(struct nmi_
 	write_watchdog_counter(wd->perfctr_msr, NULL, nmi_hz);
 }
 
-static struct wd_ops k7_wd_ops = {
+static const struct wd_ops k7_wd_ops = {
 	.reserve = single_msr_reserve,
 	.unreserve = single_msr_unreserve,
 	.setup = setup_k7_watchdog,
@@ -388,7 +388,7 @@ static void p6_rearm(struct nmi_watchdog
 	write_watchdog_counter32(wd->perfctr_msr, NULL,nmi_hz);
 }
 
-static struct wd_ops p6_wd_ops = {
+static const struct wd_ops p6_wd_ops = {
 	.reserve = single_msr_reserve,
 	.unreserve = single_msr_unreserve,
 	.setup = setup_p6_watchdog,
@@ -540,7 +540,7 @@ static void p4_rearm(struct nmi_watchdog
 	write_watchdog_counter(wd->perfctr_msr, NULL, nmi_hz);
 }
 
-static struct wd_ops p4_wd_ops = {
+static const struct wd_ops p4_wd_ops = {
 	.reserve = p4_reserve,
 	.unreserve = p4_unreserve,
 	.setup = setup_p4_watchdog,
@@ -558,6 +558,8 @@ static struct wd_ops p4_wd_ops = {
 #define ARCH_PERFMON_NMI_EVENT_SEL	ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL
 #define ARCH_PERFMON_NMI_EVENT_UMASK	ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK
 
+static struct wd_ops intel_arch_wd_ops;
+
 static int setup_intel_arch_watchdog(unsigned nmi_hz)
 {
 	unsigned int ebx;
@@ -599,11 +601,11 @@ static int setup_intel_arch_watchdog(uns
 	wd->perfctr_msr = perfctr_msr;
 	wd->evntsel_msr = evntsel_msr;
 	wd->cccr_msr = 0;  //unused
-	wd_ops->checkbit = 1ULL << (eax.split.bit_width - 1);
+	intel_arch_wd_ops.checkbit = 1ULL << (eax.split.bit_width - 1);
 	return 1;
 }
 
-static struct wd_ops intel_arch_wd_ops = {
+static struct wd_ops intel_arch_wd_ops __read_mostly = {
 	.reserve = single_msr_reserve,
 	.unreserve = single_msr_unreserve,
 	.setup = setup_intel_arch_watchdog,
