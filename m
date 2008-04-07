Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbYDGKPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbYDGKPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 06:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbYDGKOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 06:14:53 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:7116 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbYDGKOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 06:14:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id:sender;
        b=DWKbPdsGHQCTtxX+tEV3NGEi1IQZK4lsvbKroSBfA8wKX7Koe2in6XKUMtxbZkE1VgJ49hXeAsWCOeCf3nc7CG7RjWjb9lA7lUkewHb5myiQtU2gyO/GBhcSyz/4M0QjSusIOaldDzhkekevs+69XlAykEyB8Y1SAAF9SwBbEVw=
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Fix call to set_cyc2ns_scale() from time_cpufreq_notifier()
Date: Mon, 7 Apr 2008 12:14:45 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200804071214.45791.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In time_cpufreq_notifier() the cpu id to act upon is held in freq->cpu. Use it
instead of smp_processor_id() in the call to set_cyc2ns_scale().
This makes the preempt_*able() unnecessary and lets set_cyc2ns_scale() update
the intended cpu's cyc2ns.

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
---

Hi,

the codepath changed by patch is untested as my smp's cpu has
X86_FEATURE_CONSTANT_TSC set.
A printk() inserted at the beginning of time_cpufreq_notifier() showed regular
cases of "smp_processor_id() != freq->cpu".

Related mail/thread: http://lkml.org/lkml/2007/12/7/130.

Thanks,
      Karsten

 arch/x86/kernel/tsc_32.c |    4 +---
 arch/x86/kernel/tsc_64.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index d7498b3..2f5f9a4 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -256,9 +256,7 @@ time_cpufreq_notifier(struct notifier_block *nb, unsigned long val, void *data)
 						ref_freq, freq->new);
 			if (!(freq->flags & CPUFREQ_CONST_LOOPS)) {
 				tsc_khz = cpu_khz;
-				preempt_disable();
-				set_cyc2ns_scale(cpu_khz, smp_processor_id());
-				preempt_enable();
+				set_cyc2ns_scale(cpu_khz, freq->cpu);
 				/*
 				 * TSC based sched_clock turns
 				 * to junk w/ cpufreq
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 01fc9f0..bd2e2c3 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -149,9 +149,7 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 			mark_tsc_unstable("cpufreq changes");
 	}
 
-	preempt_disable();
-	set_cyc2ns_scale(tsc_khz_ref, smp_processor_id());
-	preempt_enable();
+	set_cyc2ns_scale(tsc_khz_ref, freq->cpu);
 
 	return 0;
 }
-- 
1.5.3.3
