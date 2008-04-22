Return-Path: <linux-kernel-owner+w=401wt.eu-S1764316AbYDVP2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764316AbYDVP2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYDVP2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:28:31 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16228 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbYDVP2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:28:30 -0400
Message-Id: <480E2049.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:28:41 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix watchdog ops for CoreDuo
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There apparently was an unnoticed conflict between an earlier patch to
this file and mine (d1e084746b0e5806e6345ab31c5b370f8dee2b23), which
I noticed only now. I suppose a change like the one below (untested) is
needed; I didn't get any response on a confirmation request for this from
the submitter of the first patch.

The issue is the writing of the 'checkbit' member at the end of
setup_intel_arch_watchdog(), which my patch made go to intel_arch_wd_ops
rather than wd_ops.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/cpu/perfctr-watchdog.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- linux-2.6.25/arch/x86/kernel/cpu/perfctr-watchdog.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-x86-coreduo-wd-ops/arch/x86/kernel/cpu/perfctr-watchdog.c	2008-03-04 10:30:27.000000000 +0100
@@ -614,16 +614,6 @@ static struct wd_ops intel_arch_wd_ops _
 	.evntsel = MSR_ARCH_PERFMON_EVENTSEL1,
 };
 
-static struct wd_ops coreduo_wd_ops = {
-	.reserve = single_msr_reserve,
-	.unreserve = single_msr_unreserve,
-	.setup = setup_intel_arch_watchdog,
-	.rearm = p6_rearm,
-	.stop = single_msr_stop_watchdog,
-	.perfctr = MSR_ARCH_PERFMON_PERFCTR0,
-	.evntsel = MSR_ARCH_PERFMON_EVENTSEL0,
-};
-
 static void probe_nmi_watchdog(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
@@ -637,8 +627,8 @@ static void probe_nmi_watchdog(void)
 		/* Work around Core Duo (Yonah) errata AE49 where perfctr1
 		   doesn't have a working enable bit. */
 		if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 14) {
-			wd_ops = &coreduo_wd_ops;
-			break;
+			intel_arch_wd_ops.perfctr = MSR_ARCH_PERFMON_PERFCTR0;
+			intel_arch_wd_ops.evntsel = MSR_ARCH_PERFMON_EVENTSEL0;
 		}
 		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 			wd_ops = &intel_arch_wd_ops;



