Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbXLJPqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbXLJPqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 10:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXLJPp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 10:45:57 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:24869
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbXLJPpy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 10:45:54 -0500
Message-Id: <475D6D71.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 10 Dec 2007 15:46:41 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@redhat.com>
Cc: <eranian@hpl.hp.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: resolve hidden patch conflict in
	arch/x86/kernel/cpu/perfctr-watchdog.c
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
Cc: Stephane Eranian <eranian@hpl.hp.com>

 arch/x86/kernel/cpu/perfctr-watchdog.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- linux-2.6.24-rc4/arch/x86/kernel/cpu/perfctr-watchdog.c	2007-12-10 16:11:18.000000000 +0100
+++ 2.6.24-rc4-x86-coreduo-wd-ops/arch/x86/kernel/cpu/perfctr-watchdog.c	2007-12-06 08:51:03.000000000 +0100
@@ -615,16 +615,6 @@ static struct wd_ops intel_arch_wd_ops _
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
@@ -638,8 +628,8 @@ static void probe_nmi_watchdog(void)
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



