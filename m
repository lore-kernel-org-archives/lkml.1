Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbYA2WRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbYA2WRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYA2WRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:17:31 -0500
Received: from cheypa.inria.fr ([138.96.218.90]:48722 "EHLO cheypa.inria.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbYA2WRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:17:30 -0500
X-Greylist: delayed 3730 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2008 17:17:29 EST
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH] x86: remove unused code in set_cyc2ns_scale()
Date: Tue, 29 Jan 2008 22:15:01 +0100
Message-Id: <1201641301-9288-1-git-send-email-guichaz@yahoo.fr>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be fold into:
4f95bd6e2b21a8c724357463f8341502d47aba13
x86: scale cyc_2_nsec according to CPU frequency

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
---
 arch/x86/kernel/tsc_32.c |   14 +++++---------
 arch/x86/kernel/tsc_64.c |   14 +++++---------
 2 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index 43517e3..e05e221 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -83,20 +83,16 @@ DEFINE_PER_CPU(unsigned long, cyc2ns);
 
 static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
-	unsigned long flags, prev_scale, *scale;
-	unsigned long long tsc_now, ns_now;
+	unsigned long flags, *scale;
+
+	if (!cpu_khz)
+		return;
 
 	local_irq_save(flags);
 	sched_clock_idle_sleep_event();
 
 	scale = &per_cpu(cyc2ns, cpu);
-
-	rdtscll(tsc_now);
-	ns_now = __cycles_2_ns(tsc_now);
-
-	prev_scale = *scale;
-	if (cpu_khz)
-		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
+	*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
 
 	/*
 	 * Start smoothly with the new frequency:
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 947554d..e0e9d4f 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -44,20 +44,16 @@ DEFINE_PER_CPU(unsigned long, cyc2ns);
 
 static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
-	unsigned long flags, prev_scale, *scale;
-	unsigned long long tsc_now, ns_now;
+	unsigned long flags, *scale;
+
+	if (!cpu_khz)
+		return;
 
 	local_irq_save(flags);
 	sched_clock_idle_sleep_event();
 
 	scale = &per_cpu(cyc2ns, cpu);
-
-	rdtscll(tsc_now);
-	ns_now = __cycles_2_ns(tsc_now);
-
-	prev_scale = *scale;
-	if (cpu_khz)
-		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
+	*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
 
 	sched_clock_idle_wakeup_event(0);
 	local_irq_restore(flags);
-- 
1.5.3.7

